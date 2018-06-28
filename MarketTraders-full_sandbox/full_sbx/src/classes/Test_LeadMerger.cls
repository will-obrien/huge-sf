@isTest
private class Test_LeadMerger{
    /***************************
    * testLeadMergerBatch 
    * @description:test lead merging
    * test lead blacklist (from custom setting) overwrite
    *
    **********************************/
    private static testMethod void testLeadMergerBatch(){
        //aac add custom setting
        List<LeadFieldBlacklist__c> testblacklist = new List<LeadFieldBlacklist__c>();
        LeadFieldBlacklist__c testblacklistfield1 = new LeadFieldBlacklist__c();
        testblacklistfield1.name = 'Phone';        
        testblacklistfield1.Field_APIName__c ='Phone';
        testblacklist.add(testblacklistfield1);

        LeadFieldBlacklist__c testblacklistfield2 = new LeadFieldBlacklist__c();
         testblacklistfield2.name = 'MobilePhone';
         testblacklistfield2.Field_APIName__c = 'MobilePhone';       
         testblacklist.add( testblacklistfield2);
        
        insert testblacklist;
        
        Lead lead = new Lead();
        lead.FirstName = 'Clark';
        lead.LastName = 'Kent';
        lead.leadSource = 'Newspaper';
        lead.MobilePhone = '777-777-0777';
        lead.Phone = '222-222-0222';
        lead.Email = 'clark.kent@smallville.com';
        lead.leadSource = 'test lead source';
        lead.Lead_Source_Detail__c = 'test lead source detail';
        lead.Lead_Source_Date__c = Date.today();
        Database.insert(lead);
        
        Lead lead2 = new Lead();
        lead2.FirstName = 'Clark';
        lead2.LastName = 'Kent';
        lead2.leadSource = 'Newspaper';
        lead2.MobilePhone = '777-777-0777';
        lead2.Phone = '222-222-0222';
        lead2.Email = 'clark.kent@smallville.com';
        lead2.leadSource = 'test lead source';
        lead2.Lead_Source_Detail__c = 'test lead source detail';
        lead2.Lead_Source_Date__c = Date.today();
        Database.insert(lead2);
        
        list<Lead> leads = [SELECT id,FirstName,LastName FROM Lead];
        system.assertEquals(1,leads.size());
        
        list<Lead> dupeLeads = new list<Lead>();
        for(integer x = 0; x < 10; x++){
            Lead dupeLead = new Lead();
            dupeLead.FirstName = 'Bizarro';
            dupeLead.LastName = 'Kent';
            dupeLead.MobilePhone = '444-444-0444';
            dupeLead.Phone = '555-555-0555';
            dupeLead.leadSource = 'Newspaper';
            dupeLead.Email = 'clark1.kent@smallville.com';
            dupeLeads.add(dupeLead); 
        }
        Database.insert(dupeLeads);

        map<Id,Lead> dupeMap = Handler_Lead.getDupeMap(new list<Lead>{lead});

        test.startTest();
            LeadMerger merger = new LeadMerger(dupeMap);
            Database.executeBatch(merger,1);
           //test black list copy over phone field from lead2 to first of dupelead list
           // LeadMerger.updateMasterLead(dupeLeads[0].ID, lead2);
            list<Lead> rewriteleads = [SELECT id,FirstName,LastName,Phone, MobilePhone FROM Lead where ID =: dupeleads[0].id];
            System.assertequals(1,rewriteleads.size());
           // System.assertequals(lead2.MobilePhone, rewriteleads[0].MobilePhone);                                           
           // System.assertequals(lead2.Phone, rewriteleads[0].Phone);     
        
        test.stopTest();
        
    }
        
}