@isTest
public class AddToListsCampaignTest {
    
    static testMethod void unitTest() {
        
        Id eventId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    	Id listId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();
    	ClubEventTriggerHandler.testing = true;

        Campaign camp3 = new Campaign(
            Name = 'Test List',
            Promo_Description__c = 'Test List',
            RecordTypeId = listId
        );
        
        insert camp3;
        
        Campaign camp4 = new Campaign(
            Name = 'Test List 2',
            Promo_Description__c = 'Test List 2',
            RecordTypeId = listId
        );        

        insert camp4;
        
        Campaign camp1 = new Campaign(
            Name = 'Test Event Campaign 1',
            Event_Name__c = 'Test Event Campaign',
            External_Id__c = 'Test Event Campaign 1',
            RecordTypeId = eventId,
            Start_Time__c = '8:00 AM',
            Sponsor_Description__c = 'Test Sponsor',
            Add_to_List__c = camp3.Id
        );
        
        insert camp1;
        
        Account Acct1 = new Account (Name = 'Test Account');
        insert Acct1;
        
        List<Contact> cts = new List<Contact>();
        Contact Ct1 = new Contact (FirstName = 'Test', LastName = 'Contact', AccountId = Acct1.Id);
        cts.add(Ct1);
        Contact Ct2 = new Contact (FirstName = 'Test 2', LastName = 'Contact', AccountId = Acct1.Id);
        cts.add(Ct2);
        Contact Ct3 = new Contact (FirstName = 'Test 3', LastName = 'Contact', AccountId = Acct1.Id);
        cts.add(Ct3);        
        
		insert cts;  

		test.startTest();
        
        //test adding event registrations
        List<Event_Registration__c> regs = new List<Event_Registration__c>();
        
        Event_Registration__c reg1 = new Event_Registration__c(Campaign__c = camp1.Id, Contact__c = Ct1.Id, Status__c = 'Registered');    
        regs.add(reg1);
        
        Event_Registration__c reg2 = new Event_Registration__c(Campaign__c = camp1.Id, Contact__c = Ct1.Id, Status__c = 'Attended');    
        regs.add(reg2); 
        
        Event_Registration__c reg3 = new Event_Registration__c(Campaign__c = camp1.Id, Contact__c = Ct3.Id, Status__c = 'Attended');    
        regs.add(reg3);         
        insert regs;
        
        //test adding advocacy actions
        List<kweos__EOCS_Data__c> actions = new List<kweos__EOCS_Data__c>();
        
        kweos__EOCS_Data__c a1 = new kweos__EOCS_Data__c(kwac__Related_Action__c = camp1.Id, kwac__Contact__c = ct2.Id, Action__c = 'Event Support');
        actions.add(a1);
        
        kweos__EOCS_Data__c a2 = new kweos__EOCS_Data__c(kwac__Related_Action__c = camp1.Id, kwac__Contact__c = ct2.Id, Action__c = 'Tabling');
        actions.add(a2); 
        
        insert actions;
        
        //test campaign update
        camp1.Add_to_List__c = camp4.Id;
        update camp1;
        
        test.stopTest();
        
        List<CampaignMember> cm = new List<CampaignMember>([SELECT Id FROM CampaignMember WHERE CampaignId = :camp3.Id]);
        system.assertEquals(3, cm.size());
        
        List<CampaignMember> cm2 = new List<CampaignMember>([SELECT Id FROM CampaignMember WHERE CampaignId = :camp4.Id]);
        system.assertEquals(3, cm2.size());        
               
    }

}