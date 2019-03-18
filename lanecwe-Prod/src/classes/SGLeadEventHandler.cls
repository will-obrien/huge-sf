/**** This class converts lead and updates Account, Opportunity and Contract objects.
****/
public class SGLeadEventHandler{
 public static boolean skipexecution      = false;
    public static void leadConversion(list<lead> leadsLst){
        string AccountID;
		/*** converts Lead ***/
        Database.LeadConvert leadToConvert = new database.LeadConvert();
        LeadStatus leadSts = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];

        list<Account> AcctToUpdate            = new list<Account>();
        list<Contact> CntctToUpdate           = new list<Contact>();
        map<id, Opportunity> opporMap         = new map<id, Opportunity>();
        map<id,id> ldOpporMap                 = new map<id, id>();
        list<CONMAN_Contract__c> CntrToInsert = new list<CONMAN_Contract__c>();

        Set<String> accountIdSet = new set<String>();
        
        for(Lead NewLead:leadsLst){
            if(!NewLead.isConverted){
                leadToConvert.setLeadId(NewLead.id);
                leadToConvert.setConvertedStatus(leadSts.MasterLabel);
                Database.LeadConvertResult LeadConvertRslt = Database.convertLead(leadToConvert);
                /*** Getting newly created Account ID ***/
                AccountID = LeadConvertRslt.getAccountId();
                if(LeadConvertRslt.isSuccess()){
                   /*** Setting data for converted Account to update ***/
                   AcctToUpdate.add(new account(id=LeadConvertRslt.getAccountid(), Status__c = 'Prospect', Channel__c = 'E-Commerce',
                                                z_source__c = 'Salesgateway',SlesgatewayID__c = NewLead.SlesgatewayID__c));
                   /*** Setting data for converted Contact to update ***/
                   CntctToUpdate.add(new contact(id=LeadConvertRslt.getContactid(),z_source__c = 'Salesgateway'));
                    
                   /*** Setting data for CONMAN Contract to insert ***/
                   CntrToInsert.add(new CONMAN_Contract__c(	Account_Name__c 			= LeadConvertRslt.getAccountid(),
                                                       		Opportunity__c 				= LeadConvertRslt.getOpportunityid(),
                                                       		Contract_URL__c 			= NewLead.ContractURL__c,
                                                       		Date_Submitted__c 			= date.today(),
                                                       		Legal_Approval_Status__c 	= 'Not Required',
                                                       		Pricing_Approval_Status__c 	= 'Not Required',
                                                       		Contract_Status__c 			= 'Sent To Customer',
                                                       		SlesgatewayID__c 			= NewLead.SlesgatewayID__c,
                                                       		Ownerid 					= NewLead.Ownerid, 
                                                            z_source__c 				= 'Salesgateway'));
                    /*** Setting data for converted Opportunity to update ***/
                    opporMap.put(LeadConvertRslt.getOpportunityid(),
                                new opportunity(id=LeadConvertRslt.getOpportunityid(), 
                                    			//Name 				= 'Salesgateway-' + NewLead.SlesgatewayID__c,
                                                Name 				= NewLead.Company,
                                    			accountid 			= LeadConvertRslt.getAccountId(), 
			                                    StageName 			= 'Proposal/Price Quote',
            			                        Opp_Stage__c  		= 'Proposal/Price Quote',
                        			            Channel__c 			= 'E-Commerce',
                                    			Prob_Input__c 		= '70',
                                    			Type 				= 'New Logo',
                                    			CloseDate 			= date.today().addDays(7),
                                    			SlesgatewayID__c 	= NewLead.SlesgatewayID__c,
                                                z_source__c 		= 'Salesgateway'));
                    accountIdSet.add(leadToConvert.getAccountId());
                    ldOpporMap.put(NewLead.id, LeadConvertRslt.getOpportunityId());
                    }
                }
            }
        if(AcctToUpdate.size()>0){
           update AcctToUpdate;
        }        
      
        if(opporMap.size()>0){
           update opporMap.values();
        }

        if(CntrToInsert.size()>0){
           insert CntrToInsert;
        }        
        if(CntctToUpdate.size()>0){
           update CntctToUpdate;
        }        
    }
}