@isTest
private class EventCampaignExtensionTest {

    static testMethod void test1() {
    	Club_Entity__c clubEntity = new Club_Entity__c(
    		EntityId__c = 'CLUB',
    		Name = 'Sierra Club'
    	);
    	insert clubEntity;
    	
    	Campaign camp = new Campaign();
    	camp.Events_Category__c = 'Outing';
    	camp.Send_RSVP_to_Leader__c = true;
    	ApexPages.StandardController sc = new ApexPages.standardController(camp);
        EventCampaignExtension controller = new EventCampaignExtension(sc);
		PageReference pageRef = Page.EventCampaignEntry;
		Test.setCurrentPage(pageRef);

		ApexPages.currentPage().getParameters().put('clone', 'true');
        controller = new EventCampaignExtension(sc);

		controller.getDtBegin();
		controller.getDtEnd();
		controller.setDtBegin('');
		controller.setDtEnd('');
		
		camp = controller.getCamp();
		camp.Status__c = 'Active';
		controller.saveAndReturn();
		String dtBegin = '1/1/2020 8:00 AM';
		String dtEnd = '1/1/2020 6:00 PM';
		controller.setDtBegin(dtBegin);
		controller.setDtEnd(dtEnd);
		controller.getDtBegin();
		controller.getDtEnd();
		
		controller.saveAndReturn();
		controller.saveAndNew();
		controller.cancel();
		
		controller.addLeader();
		controller.setSelectedRow(0);
		controller.getSelectedRow();

		Account account1 = new Account(Name='Test Account');
		insert account1;
		Contact contact1 = new Contact(AccountId=account1.Id, FirstName='Test', LastName='Contact');
		insert contact1;
		
		List<EventCampaignExtension.EventLeader> ldrList = controller.getLeaderList();
		Event_Leader__c evLdr = new Event_Leader__c(
			Contact__c = contact1.Id,
			Is_Primary_Leader__c = true,
			Email__c = 'junk',
			Phone_or_Other_Contact_Information__c = '(415)444-5555'
		);
		EventCampaignExtension.EventLeader ldr = new EventCampaignExtension.EventLeader(
			evLdr, '', 0
		);
		ldrList.set(0, ldr);
		controller.setSelectedRow(0);
		
		ClubEventTriggerHandler.testing = true;
		
		controller.saveCampaign();
		controller.fillLeaderInfo();
		
		evLdr.Leader_Name__c = 'Test Contact';
		evLdr.Is_Primary_Leader__c = true;
		ldr.leader = evLdr;
		ldrList.set(0, ldr);
		controller.fillLeaderInfo();
		
		controller.saveCampaign();

		controller.getLeaderList();
		controller.adjustPrimaryLeader();
		controller.deleteLeader();
    }
    static testMethod void testSuccessfulSave() {
    	Club_Entity__c clubEntity = new Club_Entity__c(
    		EntityId__c = 'CLUB',
    		Name = 'Sierra Club'
    	);
    	insert clubEntity;
    	
    	Campaign camp = new Campaign();
    	camp.Events_Category__c = 'Outing';
    	camp.Send_RSVP_to_Leader__c = true;
    	ApexPages.StandardController sc = new ApexPages.standardController(camp);
        EventCampaignExtension controller = new EventCampaignExtension(sc);
		PageReference pageRef = Page.EventCampaignEntry;
		Test.setCurrentPage(pageRef);
		camp = controller.getCamp();
		camp.Name = 'TestCampaign';
		camp.Status__c = 'Active';
		String dtBegin = '1/1/2020 8:00 AM';
		String dtEnd = '1/1/2020 6:00 PM';
		controller.setDtBegin(dtBegin);
		controller.setDtEnd(dtEnd);
		
		controller.addLeader();
		controller.setSelectedRow(0);

		Account account1 = new Account(Name='Test Account');
		insert account1;
		Contact contact1 = new Contact(AccountId=account1.Id, FirstName='Test', LastName='Contact');
		insert contact1;
		
		List<EventCampaignExtension.EventLeader> ldrList = controller.getLeaderList();
		Event_Leader__c evLdr = new Event_Leader__c(
			Contact__c = contact1.Id,
			Is_Primary_Leader__c = true,
			Leader_Name__c = 'Test Contact',
			Email__c = 'test@abc.com',
			Phone_or_Other_Contact_Information__c = '(415)444-5555'
		);
		EventCampaignExtension.EventLeader ldr = new EventCampaignExtension.EventLeader(
			evLdr, 'Test Contact', 0
		);
		ldrList.set(0, ldr);
		controller.setSelectedRow(0);
		
		ClubEventTriggerHandler.testing = true;

		controller.saveAndReturn();
		controller.saveAndNew();
    }
}