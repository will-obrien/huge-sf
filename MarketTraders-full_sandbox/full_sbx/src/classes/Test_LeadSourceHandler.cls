/***************************
* Test_LeadSourceHandler 
* @description:test lead source handler class
* 
*   Author:             Asha Calderon
*   Date Created:       1/10/2015
*   Last Modified:      1/10/2015
*   Last Modified By:   Asha Calderon
*
**********************************/
@isTest
private class Test_LeadSourceHandler {

    private static testMethod void unitTest1(){
        
        Lead lead = new Lead();
        lead.FirstName = 'Clark';
        lead.LastName = 'Kent';
        lead.Email = 'clark.kent@smallville.com';
        Database.insert(lead);
        
                
        Lead_Sources__c leadsrc = new Lead_Sources__c();
        leadsrc.Lead__c = lead.id;
        leadsrc.Lead_Source__c = 'Newspaper';
        leadsrc.Email_at_last_edit__c = 'clark.kent@smallville.com';
        leadsrc.Lead_Source_Detail__c = 'test lead source detail';
        leadsrc.Lead_Source_Date__c = Date.today();
        leadsrc.Override_Lead_Source_Rules__c = true;
        Database.insert(leadsrc);
        
       test.startTest();    
            String triggerObject = 'Lead Source';
            Handler_LeadSource controller = new Handler_LeadSource(triggerObject);
            list<SObject> newListLeadSources = new list<SObject>();
            newListLeadSources.add(leadsrc);
        
            List<Lead_sources__c> returnedleadsources = [Select id from lead_sources__c];           
            System.assertequals(1, returnedleadsources.size());
            /* inprogress entry method from lead source handler
            controller.inProgressEntry(
            String triggerObject,
            Boolean isBefore, 
            Boolean isAfter, 
            Boolean isInsert, 
            Boolean isUpdate,
            Boolean isDelete, 
            Boolean isUndelete, 
            Boolean isExecuting, 
            list<SObject> newList,
            map<Id,SObject> newMap, 
            list<SObject> oldList, 
            map<Id,SObject> oldMap);
            */
            controller.inProgressEntry(
            triggerObject,
             false, 
             false, 
             true, 
             false,
             false, 
             false, 
             false, 
            newListLeadSources,
            null, 
            null, 
            null);
            
            /* main entry method from lead source handler
            controller.mainEntry(String triggerObject,
            Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
            Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
            map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap);
            */

            controller.mainEntry(triggerObject,
            true, false, true, false,
            false, false, false, newListLeadSources,
            null, null, null);          
            

            
        test.stopTest();
    }
    
    private static testMethod void unitTest2(){
    
        Lead lead = new Lead();
        lead.FirstName = 'Clark';
        lead.LastName = 'Kent';
        lead.leadSource = 'Newspaper';
        lead.Email = 'clark.kent@smallville.com';
        lead.Alternate_Email__c ='ckent@smallville.com';
        lead.leadSource = 'test lead source';
        lead.Lead_Source_Detail__c = 'test lead source detail';
        lead.Lead_Source_Date__c = Date.today();
        Database.insert(lead);
        
        Lead_Sources__c leadsrc1 = new Lead_Sources__c();
        leadsrc1.Lead__c = lead.id;
        leadsrc1.Lead_Source__c = 'Newspaper';
        leadsrc1.Email_at_last_edit__c = 'clark.kent@smallville.com';
        leadsrc1.Lead_Source_Detail__c = 'test lead source detail';
        leadsrc1.Lead_Source_Date__c = Date.today();
        Database.insert(leadsrc1);
        
    
        Lead lead2 = new Lead();
        lead2.FirstName = 'Clark';
        lead2.LastName = 'Kent';
        lead2.leadSource = 'Newspaper';
        lead2.Email = 'clark.kent@smallville.com';
        lead2.leadSource = 'test lead source';
        lead2.Lead_Source_Detail__c = 'test lead source detail';
        lead2.Lead_Source_Date__c = Date.today();
        Database.insert(lead2);
                
        
        Lead_Sources__c leadsrc2 = new Lead_Sources__c();
        leadsrc2.Lead__c = lead2.id;
        leadsrc2.Lead_Source__c = 'Newspaper';
        leadsrc2.Email_at_last_edit__c = 'clark.kent@smallville.com';
        leadsrc2.Lead_Source_Detail__c = 'test lead source detail';
        leadsrc2.Lead_Source_Date__c = Date.today();
        Database.insert(leadsrc2);
        
          test.startTest(); 
        //verify merge 
        List<Lead> returnedleads = [Select id,email from lead where email = 'clark.kent@smallville.com'];
        System.assertequals(1, returnedleads.size());
        
        //verify that lead source is attached to first lead
        List<Lead_sources__c> returnedleadsources = [Select id, lead__c from lead_sources__c ];
        For(Lead_sources__c ls : returnedleadsources){
            system.assertequals(lead.id,ls.lead__c);            
        }
            test.stopTest();
    }   
    
    private static testMethod void unitTest3(){
        
        Lead lead = new Lead();
        lead.FirstName = 'Clark';
        lead.LastName = 'Kent';
        lead.leadSource = 'Newspaper';
        lead.Email = 'clark.kent@smallville.com';
        lead.leadSource = 'test lead source';
        lead.Lead_Source_Detail__c = 'test lead source detail';
        lead.Lead_Source_Date__c = Date.today();
        Database.insert(lead);
        
        
        
        Lead_Sources__c leadsrc = new Lead_Sources__c();
        leadsrc.Lead__c = lead.id;
        leadsrc.Lead_Source__c = 'Newspaper';
        leadsrc.Email_at_last_edit__c = 'clark.kent@smallville.com';
        leadsrc.Lead_Source_Detail__c = 'test lead source detail';
        leadsrc.Lead_Source_Date__c = Date.today();
        Database.insert(leadsrc);
        
          test.startTest(); 
        //test the delete
            Database.delete(leadsrc);
            test.stopTest();
    }
    
    
    
}