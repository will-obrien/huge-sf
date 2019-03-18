/**
*    LeadEventHandler helper Class for lead trigger
*
*    Modification Log
*
*    Deepthi        PGI    10/27/2014      created helper class for lead trigger events, method/logic for leadConversion 
**/
public class LeadEventHandler{
    
    public static boolean skipAfterEvent      = false; // Skip recursive after  event logic

    /*
    *    Logic to convert lead on Lead with leadSource='eCommerce Customer' and eCommerceConvert = true
    */
    public static void leadConversion(list<lead> leadsLst){
        Database.LeadConvert[] leadConvertLst = new list<Database.LeadConvert> ();       
        LeadStatus leadSts               = [SELECT Id, MasterLabel FROM LeadStatus 
                                                    WHERE IsConverted=true LIMIT 1];
    
        list<Contact> ctToUpdate        = new list<Contact>();
        list<Account> AcctToUpdate      = new list<Account>();
        map<id, Opportunity> opporMap   = new map<id, Opportunity>();
        map<id,id> ldOpporMap           = new map<id, id>();
        map<string, lead> ldMap         = new map<string, lead>();
        Set<String> accountIdSet        = new set<String>();
       try{
        /* START getting database leadConvert list for each lead that need to be converted */
        for(Lead ld:leadsLst){
            ldMap.put(ld.id, ld);
            if(!ld.isConverted && 
                ld.ECommerce_Convert__c == true && 
                ld.LeadSource == Label.Lead_Convert_LeadSource){
                Database.LeadConvert ldConvert = new database.LeadConvert();        
                if((''+ld.ownerid).startswith('00G')){
                    ldConvert.setOwnerId(userinfo.getUserid());
                }
                
                ldConvert.setLeadId(ld.id);
                ldConvert.setConvertedStatus(leadSts.MasterLabel);
                leadConvertLst.add(ldConvert);
            }
        }
        /* END getting database leadConvert list for each lead that need to be converted */
        /* Converting Lead list */
        if(leadConvertLst <> null && leadConvertLst.size() > 0){
            for(Database.LeadConvertResult ldConvertResult : Database.convertLead(leadConvertLst)){
                //Updating ecommnerceConvert value
                if(ldConvertResult.isSuccess()){
                    Lead ld = ldMap.get(ldConvertResult.getLeadId());
                    if(ld.ecommerce_convert__c){
                        /*** START setting data for converted Account to update ***/
                        AcctToUpdate.add(new account(id=ldConvertResult.getAccountid(), 
                                Status__c = Label.Lead_Convert_Account_Status, 
                                Channel__c = Label.Lead_Convert_Account_Channel, 
                                Type = Label.Lead_Convert_Account_Type,
                                Z_Source__c = ld.Z_Source__c));
                        /*** END ***/
                        
                        /*** START setting data for converted Contact to update ***/
                        ctToUpdate.add(new contact(  id=ldConvertResult.getContactid(), 
                                                ecommerce_convert__c = ld.ecommerce_convert__c, 
                                                ECommerce_Account_Number__c = ld.ECommerce_Account_Number__c,
                                                Z_Source__c = ld.Z_Source__c,
                                                License_Profile__c= true));
                        /*** END ***/
                        
                        /*** START setting data for converted Opportunity to update ***/
                        opporMap.put(
                            ldConvertResult.getOpportunityid(), 
                            new opportunity(
                                id=ldConvertResult.getOpportunityid(), 
                                accountid = ldConvertResult.getAccountId(), 
                                ecommerce_convert__c = ld.ecommerce_convert__c, 
                                ECommerce_Account_Number__c = ld.ECommerce_Account_Number__c, 
                                StageName = Label.Lead_Convert_Default_Opportunity_StageName,
                                Opp_Stage__c  = Label.Lead_Convert_Default_Opportunity_Stage,
                                Prob_Input__c = Label.Lead_Convert_Default_Opportunity_Prob,
                                Type = Label.Lead_Convert_Default_Opportunity_Type,
                                Z_Source__c = ld.Z_Source__c,
                                CloseDate = date.today()
                                )
                        );
                        /*** END ***/
                        accountIdSet.add(ldConvertResult.getAccountId());
                        ldOpporMap.put(ld.id, ldConvertResult.getOpportunityId());
                    }
                }
                system.debug('LCR Errors : ' + ldConvertResult.getErrors());        
            }    
        }
        /* START Logic to update Account, Contact, Opportunity, LicenseSets */
        if(AcctToUpdate.size()>0){
            update AcctToUpdate;
        }        
        if(ctToUpdate.size()>0){
            update ctToUpdate;
        }
        if(opporMap.size()>0){
            update opporMap.values();
        }
        
        if(ldOpporMap <> null && ldOpporMap.size() >0){
            list<Licenseset__c> licSetLst = PGI_Utility.createOpporLicenseSet(ldOpporMap);   
            System.debug('licSetLst : ' + licSetLst);
            update licSetLst;
        }
        /* END */
        }
        catch(Exception e){
            throw e;
        }        
    }
}