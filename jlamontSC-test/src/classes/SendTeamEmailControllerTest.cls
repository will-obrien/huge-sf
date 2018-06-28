/*
Contains tests for SendTeamEmailController, SendListEmailController, and SendEventEmailController classes
*/
@isTest
public class SendTeamEmailControllerTest {
    
    private static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static Id eventsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();
    private static Id ListsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();
    
    static testMethod void testTeamEmail() {
        
        Club_Entity__c ent = new Club_Entity__c(Name = 'Test Entity');
   	 	insert ent;
        
         Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
        List<Contact> cts = new List<Contact>();
        for (Integer i = 0; i < 50; i++) {
            Contact contact1 = new Contact(
            	AccountId = account1.Id,
            	FirstName = 'Test',
            	LastName = 'Contact' + i,
            	Email = 'test1.contact1@abc.com',
            	RecordTypeId = contactHouseholdTypeId
        	);
            cts.add(contact1);
        }      
		insert cts;
        
        Leader_Position__c pos = new Leader_Position__c(
        	Name = 'Test Position',
            Code__c = 'TEST'
        );       
        insert pos;
      
        List<Leadership__c> ldrs = new List<Leadership__c>();
        for (Contact ct : cts) {
            Leadership__c lead = new Leadership__c(
        	Contact__c = ct.Id,
            Club_Entity__c = ent.Id,
            Leader_Position__c = pos.Id,
            Position_Status__c = 'Active'           
        	);
            ldrs.add(lead);
        }  
        insert ldrs;
        
        PageReference PageRef = Page.SendTeamEmail;
		Test.setCurrentPage(PageRef);
        pageRef.getParameters().put('entityid', ent.Id);
		SendTeamEmailController controller = new SendTeamEmailController();
        
        controller.subjLine = 'Test Subject Line';
        controller.image = 'http://www.sierraclub.org/';
        controller.text1 = 'Opening Paragraph';
        controller.text2 = 'Middle Paragraph';
        controller.text3 = 'Last Paragraph';
        controller.close = 'Sincerely,';
        controller.closeName = 'FirstName';
        
        List<SendTeamEmailController.Wrapper> contactList = controller.getMemberList();
        
        for (SendTeamEmailController.Wrapper w : contactList) {
            w.isSelected = true;
        }

        controller.preview();
		controller.back();         
        controller.sendemail();
        controller.cancel();
    }

    static testMethod void testEventEmail() {
        
        ClubEventTriggerHandler.testing = true;
        Campaign cmp = new Campaign (
        	RecordTypeId = eventsTypeId,
    		Name = 'Testing',
    		Event_Name__c = 'Testing',
    		Status__c = 'In Development',
    		Events_Category__c = 'Outing',
    		Events_Type__c = 'Hike',
    		Start_Date__c = System.today(),
    		Start_Time__c = '8:00 AM',
    		Time_Zone__c = 'Local Time',
    		Sponsor_Description__c = 'Local Entity',
    		Summary_Description__c = 'Testing',
    		Display_Method__c = 'Salesforce Events Page'
    	);
        insert cmp;
        
         Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
        List<Contact> cts = new List<Contact>();
        for (Integer i = 0; i < 50; i++) {
            Contact contact1 = new Contact(
            	AccountId = account1.Id,
            	FirstName = 'Test',
            	LastName = 'Contact' + i,
            	Email = 'test1.contact1@abc.com',
            	RecordTypeId = contactHouseholdTypeId
        	);
            cts.add(contact1);
        }      
		insert cts;
            
        List<Event_Registration__c> reg = new List<Event_Registration__c>();
        for (Contact ct : cts) {
            Event_Registration__c rg = new Event_Registration__c(
        	Contact__c = ct.Id,
            Campaign__c = cmp.Id,
            Status__c = 'Registered'           
        	);
            reg.add(rg);
        }  
        insert reg;
        
        //for event registration, test a record without a contact lookup
        Event_Registration__c rg2 = new Event_Registration__c(
            Campaign__c = cmp.Id,
            Status__c = 'Registered',
            First_Name__c = 'Test',
            Last_Name__c = 'Without Contact',
            Email__c = 'test@test.com'
        	);
        insert rg2;
        
        PageReference PageRef = Page.SendEventEmailNew;
		Test.setCurrentPage(PageRef);
        pageRef.getParameters().put('eventid', cmp.Id);
		SendEventEmailController controller = new SendEventEmailController();
        
        controller.registeredBox = true;
        controller.attendedBox = true;
        controller.cancelledBox = true;
        controller.noshowBox = true;
        controller.next();
        
        controller.subjLine = 'Test Subject Line';
        controller.image = 'http://www.sierraclub.org/';
        controller.text1 = 'Opening Paragraph';
        controller.text2 = 'Middle Paragraph';
        controller.text3 = 'Last Paragraph';
        controller.close = 'Sincerely,';
        controller.closeName = 'FirstName';
        
        List<SendEventEmailController.Wrapper> contactList = controller.getMemberList();
        
        for (SendEventEmailController.Wrapper w : contactList) {
            w.isSelected = true;
        }
        
        controller.preview();
		controller.back();         
        controller.sendemail();
        controller.cancel();
    }

    static testMethod void testListEmail() {
        
        Campaign cmp = new Campaign (
        	RecordTypeId = ListsTypeId,
    		Name = 'Testing'
    	);
        insert cmp;
        
         Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
        List<Contact> cts = new List<Contact>();
        for (Integer i = 0; i < 50; i++) {
            Contact contact1 = new Contact(
            	AccountId = account1.Id,
            	FirstName = 'Test',
            	LastName = 'Contact' + i,
            	Email = 'test1.contact1@abc.com',
            	RecordTypeId = contactHouseholdTypeId
        	);
            cts.add(contact1);
        }      
		insert cts;
            
        List<CampaignMember> cmpmem = new List<CampaignMember>();
        for (Contact ct : cts) {
            CampaignMember mem = new CampaignMember(
        	ContactId = ct.Id,
            CampaignId = cmp.Id           
        	);
            cmpmem.add(mem);
        }  
        insert cmpmem;
        
        PageReference PageRef = Page.SendListEmail;
		Test.setCurrentPage(PageRef);
        pageRef.getParameters().put('listid', cmp.Id);
		SendListEmailController controller = new SendListEmailController();
        
        controller.subjLine = 'Test Subject Line';
        controller.image = 'http://www.sierraclub.org/';
        controller.text1 = 'Opening Paragraph';
        controller.text2 = 'Middle Paragraph';
        controller.text3 = 'Last Paragraph';
        controller.close = 'Sincerely,';
        controller.closeName = 'FirstName';
        
        List<SendListEmailController.Wrapper> contactList = controller.getMemberList();
        
        for (SendListEmailController.Wrapper w : contactList) {
            w.isSelected = true;
        }

        controller.preview();
		controller.back();        
        controller.sendemail();
        controller.cancel();
    }
}