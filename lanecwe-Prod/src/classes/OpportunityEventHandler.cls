/**
*    Opportunity trigger logic for Before/After insert/Update/delete Events
*
*    Modification Log
*
*    Deepthi        PGI    11/06/2014      Opportunity trigger logic for Before/After Insert/Update/Delete 
**/

public class OpportunityEventHandler{
    public static boolean skipExecution = false; // boolean to exempt recursive trigger logic execution
    
    /*
    * Logic to Associate Opportunity.AccountId with existing Account matching  eCommerceAccountNumber
    */
    public static void updateOpportunity(list<Opportunity> opporLst){
        map<String, list<Opportunity>> opporEcomAcctNoMap = new map<String, list<Opportunity>>();
        list<Opportunity> opporEcomLst = new list<Opportunity>();
        
        /* Storing map<opportunity.EcommerceAccountNumber, list<Opportunities>> */
        for(Opportunity oppor:opporLst){
          if(oppor.ECommerce_Account_Number__c != null){
            opporEcomLst = opporEcomAcctNoMap.containskey(oppor.ECommerce_Account_Number__c)?
                            opporEcomAcctNoMap.get(oppor.ECommerce_Account_Number__c):new list<Opportunity>();
            opporEcomLst.add(oppor);
            opporEcomAcctNoMap.put(oppor.ECommerce_Account_Number__c, opporEcomLst);  
          }
          
        }
        //END of Storing opportunity eCommerceAccountNumber in Map
        
        /* START Retrieving Accounts matching the EcommerceAccountNumber and Associate the matching Opportunity with Account */
        if(opporEcomAcctNoMap != null && opporEcomAcctNoMap.size()>0){
        try{
           for(Account act: [select id, ECommerce_Account_Number__c from account 
                        where ECommerce_Account_Number__c != null and ECommerce_Account_Number__c in :opporEcomAcctNoMap.keyset()]){
               if(opporEcomAcctNoMap.containskey(act.ECommerce_Account_Number__c)){
                  for(Opportunity oppor:opporEcomAcctNoMap.get(act.ECommerce_Account_Number__c)){         
                   oppor.accountid = act.id;
                  }
               }
           }
         }
         catch(Exception e){
             system.debug('OpportunityEventHandler Exception : ' + e.getMessage()); 
         }
        }
        /* END logic for associating opportunity with account matching eCommerceAccountNumber */
        system.debug('OpporLst:'+ opporLst);
    }
    
    /**
    * Logic to delete Opportunity LicenseSets on deleting Opportunities
    **/
    public static void deleteOpporLicenseSets(list<opportunity> opporLst){
        delete [select id from licenseset__c where Opportunity__c in :opporLst];
    }

    /**
    * Logic to delete Opportunity License/Assets on deleting Opportunities
    **/ 
    public static void deleteOpporLicenses(list<opportunity> opporLst){
        delete [select id from Asset where Opportunity__c in :opporLst];
    }
    
    /*
    * Logic to create Contracts for Opportunities updated with Opp_Stage__c = 'Closed Won' and eCommerceConvert = true
    */
    public static void createContracts(map<id, Opportunity> newOpporMap, map<id,Opportunity> oldOpporMap){
        list<opportunity> opporLst = new list<opportunity>();
        /* START getting list of opportunities updated with Opp_Stage__c = 'Closed Won' and eCommerceConvert = true */
         for(Opportunity oppor:newOpporMap.values()){
            Opportunity oldOppor = oldOpporMap.get(oppor.id);
            if(oppor.Opp_Stage__c == 'Closed Won' && oppor.ECommerce_Convert__c && 
                (
                    oppor.Opp_Stage__c <> oldOppor.Opp_Stage__c ||
                    oppor.ECommerce_Convert__c <> oldOppor.ECommerce_Convert__c
                )
                ){
                opporLst.add(oppor);
            }
         }
         /* END - getting opportunity list with 'Closed Won' and eCommerceConvert */
         
         /* START logic to create Contracts for opportunity */
         if(opporLst.size()>0){ 
             
             list<Contracts__c> contractsLst = PGI_Utility.createAccountContracts(opporLst);
             
             if(contractsLst.size() > 0){
                insert contractsLst;
             }        
         }
        /* END logic to create Contracts for opportunity */      
    }
    /* Logic to mirror Opportunity Licenseset to OpportunityLineItem using ProductMapping 
        if opportunity.isClosed (StageName = Closed Won/Lost)
    */
    public static void mirrorOpportunityLineItemLicenseSet(map<id, Opportunity> oldOpporMap, map<id, Opportunity> opporMap){
        set<id> closedOpporIdSet = new set<id>();
        
        system.debug('Opportunity Map :' + opporMap);
        
        // OpportunityLineItemMap to Update
        list<opportunityLineItem> opportunityLineItemUpdateLst = new list<OpportunityLineItem>();
        //Retrieve Opportunity updated with isClosed
        for(Opportunity oppor: opporMap.values()){
            if(((oppor.Opp_stage__c == 'Closed Won' && 
                oldOpporMap.get(oppor.id).opp_Stage__c <> 'Closed Won') || 
                (oppor.Opp_stage__c == 'Closed Lost' && 
                oldOpporMap.get(oppor.id).opp_Stage__c <> 'Closed Lost')) 
                && oppor.ecommerce_convert__c == true){
                closedOpporIdSet.add(oppor.id);
            }
        }
        map<String, licenseset__c> planNameLicensesetMap = new map<String, licenseset__c>();
        // Retrieving licensesets for all Closed Opportunities
        if(closedOpporIdSet <> null && closedOpporIdSet.size()>0){
            for(Licenseset__c licset: [Select zAccount__c, Z_Source__c, Test_State__c,  
                                        Subscription_License_Term_Months__c, Start_Date__c, 
                                        SKU__c, Product__c, Price__c, OwnerId, Order_Number__c, 
                                        Opportunity__c, Number_of_UnAssigned_Users__c, 
                                        Number_of_Licensed_Named_Users__c, Name, Line_Number__c, 
                                        Lead__c, Id, HubID__c, Enterprise_Name__c, End_Date__c, 
                                        Description__c, CompanyID__c
                                       From LicenseSet__c 
                                       where opportunity__c in :closedOpporIdSet]){
                planNameLicensesetMap.put(licset.name, licset);
            }
        }
        
        // Retrieving productMappings for all LicenseSet PlanName
        map<String, Product_Mappings__c> planNameProdMappingsMap = new map<String, Product_Mappings__c>();
        if(planNameLicensesetMap <> null && planNameLicensesetMap.size()>0){
            for(Product_Mappings__c prodMapping: [Select  Source_Product_Name__c, 
                                                         SFDC_Product_Name__c, SFDC_Product_ID__c, 
                                                         SFDC_PB_Entry_ID__c, Name, Id 
                                                        From Product_Mappings__c 
                                                        where 
                                                        Source_Product_Name__c in :planNameLicensesetMap.keyset()]){
                if(planNameLicensesetMap.containskey(prodMapping.Source_Product_Name__c)){
                    Licenseset__c licset = planNameLicensesetMap.get(prodMapping.Source_Product_Name__c);
                    
                    // Assigning opprtunityLineItem with licenseset/productMapping values.
                    OpportunityLineItem opporLineItem = new OpportunityLineItem();
                    //opporLineItem.Product Name    = Product Family=LS.Plan Name;
                    opporLineItem.OpportunityId         = licset.Opportunity__c;
                    //opporLineItem.Billing_Frequency__c  = Label.Default_OpportunityLineItem_Frequency;
                    system.debug('prodMapping:'+prodMapping);
                    system.debug('Source_Product_Name__c:'+prodMapping.Source_Product_Name__c);
                    LicenseSet__c billfreq = [select Enterprise_Name__r.billing_frequency__c from LicenseSet__c where name = :prodMapping.Source_Product_Name__c limit 1];
                    //offerings__c offeringsdata = [select billing_frequency__c from offerings__c where Name = :prodMapping.Source_Product_Name__c limit 1];
                    opporLineItem.Billing_Frequency__c  = billfreq.Enterprise_Name__r.billing_frequency__c;
                    opporLineItem.New_Quantity__c        = licset.Number_of_Licensed_Named_Users__c;
                    opporLineItem.Unit_Type__c          = Label.Default_OpportunityLineItem_UnitType;
                    opporLineItem.New_Sales_Price__c    = licset.Price__c;
                    opporLineItem.Contract_Term__c      = licset.Subscription_License_Term_Months__c;
                    opporLineItem.licenseset__c         = licset.id;
                    opporLineItem.PricebookEntryId      = prodMapping.SFDC_PB_Entry_ID__c;
                    opportunityLineItemUpdateLst.add(opporLineItem);
                }
            }
        }

        // Inserting OpportunityLineItem list
        if(opportunityLineItemUpdateLst <>null && opportunityLineItemUpdateLst.size()>0){
            insert opportunityLineItemUpdateLst;
        }
    }
    
    public static void setOpportunityScorecardFields(Map<Id, Opportunity> oldOppMap, Map<Id, Opportunity> oppMap){
    	Map<Id, Opportunity> oppToUpdateMap = new Map<Id, Opportunity>();
    	for(Opportunity opp : oppMap.values()){
    		if(opp.OwnerId != oldOppMap.get(opp.Id).OwnerId){
    			oppToUpdateMap.put(opp.Id, opp);
    		}
    	}
    	
    	List<GCS_Acq_Opportunity_Scorecard__c> oppScorecardList = [SELECT Id, Opportunity__c FROM GCS_Acq_Opportunity_Scorecard__c WHERE Opportunity__c =: oppToUpdateMap.keySet()];
    	for(GCS_Acq_Opportunity_Scorecard__c oppScorecard : oppScorecardList){
    		oppScorecard.OwnerId = oppToUpdateMap.get(oppScorecard.Opportunity__c).OwnerId;
    	}
    	update oppScorecardList;
    }
    
    public static void validateRampDates(Map<Id, Opportunity> oldOppMap, List<Opportunity> oppList){
    	Integer isGCSReadWritePermission = [SELECT count() FROM PermissionSetAssignment WHERE permissionSet.Label = 'GCS: Read-Write Fields' AND Assignee.Id =: UserInfo.getUserId()];
    	if(isGCSReadWritePermission == 1){
	    	Set<Id> oppIds = new Set<Id>();
	    	for(Opportunity opp : oppList){
	    		if(((oldOppMap == null || opp.Prob_Input__c != oldOppMap.get(opp.Id).Prob_Input__c) && opp.Prob_Input__c != null && opp.Prob_Input__c.contains('90')) || ((oldOppMap == null || opp.Opp_Stage__c != oldOppMap.get(opp.Id).Opp_Stage__c) && opp.Opp_Stage__c != null && opp.Opp_Stage__c.contains('Closed Won'))){
	    			oppIds.add(opp.Id);
	    		}
	    	}
	    	
	    	Set<Id> errorOppIds = new Set<Id>();
	    	List<OpportunityLineItem> opliList = [SELECT Initial_Bill_Date__c, X100_Ramp_Date__c, OpportunityId FROM OpportunityLineItem WHERE Existing_Service__c = false AND OpportunityId IN :oppIds];
	    	for(OpportunityLineItem opli : opliList){
	    		if(opli.Initial_Bill_Date__c == null || opli.X100_Ramp_Date__c == null){
	    			errorOppIds.add(opli.OpportunityId);
	    		}
	    	}
	    	
	    	for(Opportunity opp : oppList){
	    		if(errorOppIds.contains(opp.Id)){
	    			opp.addError('Before setting Prob% to 90 or higher or Status to Closed Won, both Initial Bill Date and 100% Ramp Date on the product screen are required for any product that is not an Existing Service');
	    		}
	    	}
    	}
    }
    
    //Case #51272
    /*public static void setOppStage(Map<Id, Opportunity> oldOppMap, List<Opportunity> oppList){
    	for(Opportunity opp : oppList){
    		if((oldOppMap == null && opp.GCS_Opp_Stage__c != null) || 
    		(oldOppMap != null && opp.GCS_Opp_Stage__c != oldOppMap.get(opp.Id).GCS_Opp_Stage__c && opp.GCS_Opp_Stage__c != null)){
    			if(opp.GCS_Opp_Stage__c.contains('Identify Target')){
    				opp.Opp_Stage__c = 'Identify Target';
    				opp.StageName = 'Identify Target';
    			}
    			else if(opp.GCS_Opp_Stage__c.contains('Qualify Opportunity')){
    				opp.Opp_Stage__c = 'Qualification';
    				opp.StageName = 'Qualification';
    			}
    			else if(opp.GCS_Opp_Stage__c.contains('Develop Solution')){
    				opp.Opp_Stage__c = 'Info Session/Needs Analysis';
    				opp.StageName = 'Info Session/Needs Analysis';
    			}
    			else if(opp.GCS_Opp_Stage__c.contains('Develop Proposal')){
    				opp.Opp_Stage__c = 'Proposal/Price Quote';
    				opp.StageName = 'Proposal/Price Quote';
    			}
    			else if(opp.GCS_Opp_Stage__c.contains('Trial/Pilot')){
    				opp.Opp_Stage__c = 'Pilot/Trial/Evaluation';
    				opp.StageName = 'Pilot/Trial/Evaluation';
    			}
    			else if(opp.GCS_Opp_Stage__c.contains('Gain Commitment')){
    				opp.Opp_Stage__c = 'Negotiation/Verbal';
    				opp.StageName = 'Negotiation/Verbal';
    			}
    			else if(opp.GCS_Opp_Stage__c.contains('Closed Won')){
    				opp.Opp_Stage__c = 'Closed Won';
    				opp.StageName = 'Closed Won';
    			}
    			else if(opp.GCS_Opp_Stage__c.contains('Closed Lost')){
    				opp.Opp_Stage__c = 'Closed Lost';
    				opp.StageName = 'Closed Lost';
    			}
    		}
    	}
    }
    
    public static void setProbInput(Map<Id, Opportunity> oldOppMap, List<Opportunity> oppList){
    	for(Opportunity opp : oppList){
    		if((oldOppMap == null && opp.GCS_Prob__c != null) || 
    		(oldOppMap != null && opp.GCS_Prob__c != oldOppMap.get(opp.Id).GCS_Prob__c && opp.GCS_Prob__c != null)){
    			String prob = opp.GCS_Prob__c.split('%')[0];
    			opp.Prob_Input__c = prob;
    			opp.Probability = Decimal.valueOf(prob);
    		}
    	}
    }*/  
}