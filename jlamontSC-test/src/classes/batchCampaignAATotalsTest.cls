// **************************************************************************
// batchCampaignAATotalsTest						     (c) 2015 Sierra Club
//
//	Tests the recalculation of the Advocacy Action totals for Campaigns
//
//	2016/01/19		VB		Original
//	2016/01/31		VB		Zero'd three asserts for temporary disabling of trigger
//	2016/07/27		VB		Additional test for the new offset field on Campaigns
//	2016/11/09		VB		New tests, since totals are not incremented in real-time
// **************************************************************************
@isTest
private class batchCampaignAATotalsTest {

    static String HouseHoldAccountRecordType;
    static String HouseHoldContactRecordType;
	static {
		HouseHoldAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		HouseHoldContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	}

    static Id eventId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Events').getRecordTypeId();

    static testMethod void myUnitTestOne() {

		//
		// Need to create Advocacy Test Action
		//
		
        // Create the attributes we will need to insert the Account, Contact, Campaign, and Advocacy Action:
        //
        Attribute__c newAttribute1 = new Attribute__c(Name='4',Description__c = 'Digital Innovation Email', Attribute_Type__c = 'Program', External_ID__c = 'PG-4');
        Attribute__c newAttribute3 = new Attribute__c(Name='A',Description__c = 'John Muir Society',   Attribute_Type__c = 'Program', External_ID__c = 'PG-A');
	    Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');
        insert newAttribute1;
        insert newAttribute3;
   	    insert newAttribute4;

		// 
		// Now create a Non-SR campaigns, using the atributes
		//        
    	Campaign newNonSRCampaign = new Campaign(
    							Name = 'TC3',
    							Description = 'Test Non-SierraRise Campaign3',
    							Program__c = newAttribute3.Id, 
    							Effort_Type__c = newAttribute4.Id);
    	insert newNonSRCampaign;


		// Create the Account
        Account testAccount = new Account(Name='Test HH');
        if(HouseholdAccountRecordType != null){
            testAccount.RecordTypeId = HouseholdAccountRecordType;
        }
        insert testAccount;

        // Create a contact with a Non-SierraRise Original Campaign
        Contact newContact = new Contact(
        							Account = testAccount,
        							LastName = 'LN',
        							FirstName = 'FN',
        							Original_Campaign__c = newNonSRCampaign.Id
        							);
        if(HouseholdContactRecordType != null){
            newContact.RecordTypeId = HouseholdContactRecordType;
        }
        insert newContact;


		// 
		// Create a SR Campaign
		//        
        Campaign newCampaign = new Campaign(
        						Name = 'TC1',
        						Description = 'Test SierraRise Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id);
    	insert newCampaign;

		//
		// Create a SierraRise Advocacy Action for the Contact, using the newCampaign from above
		//
		kweos__EOCS_Data__c newAdvocacyAction = new kweos__EOCS_Data__c(
			kwac__Contact__c = newContact.Id,
			kwac__Contact_Lead_Status__c = 'New Record Created',
			kweos__Email__c = 'test@test.com',
			kweos__Phone__c = '(415) 555-1212',
			kweos__Prefix__c = 'Ms.',
			kweos__First_Name__c = 'FN',
			kweos__Last_Name__c = 'LN',
			kweos__Address1__c = '12 Parkway Ct',
			kweos__Address2__c = '',
			kweos__City__c = 'Orinda',
			kweos__State__c = 'CA',
			kweos__Postal_Code__c = '94563',
			kweos__Issue__c = 'Gambling',
			kweos__Subject__c = 'Test Subject',
			kweos__Message__c = 'Test Message',
			kwac__Related_Action__c = newCampaign.Id,
			//kwac__Related_Action__c = camp1.Id,
			kwac__Source_Campaign__c = newNonSRCampaign.Id
			);

		System.debug('INSERTINGADVOCACY');		
		insert newAdvocacyAction;
		//
		// END: Create Test Advocacy Action
		//
		

		// Now Test the batch		
		Test.startTest();
		// Same query pulled from batchCampaignAATotalsSchedulable
		String query = 'SELECT id, kwac__Related_Action__c ' +
						'FROM kweos__EOCS_Data__c ' +
						'WHERE kwac__Related_Action__r.Advocacy_Action_Count_Dirty__c = true ' +
						'ORDER BY kwac__Related_Action__c';
        Database.executeBatch(new batchCampaignAATotals(query));
        Test.stopTest();
        
        newCampaign = [
        	SELECT Advocacy_Action_Count__c
        	FROM Campaign
        	WHERE Id = :newCampaign.Id 
        ];
		
		// Assert that the count is now 1
		System.assertEquals(1, newCampaign.Advocacy_Action_Count__c);
    }

	// Create a Campaign with a Convio Related Action    
    static testMethod void myUnitTestTwo() {

		//
		// Need to create Advocacy Test Action
		//
		
        // Create the attributes we will need to insert the Account, Contact, Campaign, and Advocacy Action:
        //
        Attribute__c newAttribute1 = new Attribute__c(Name='4',Description__c = 'Digital Innovation Email', Attribute_Type__c = 'Program', External_ID__c = 'PG-4');
        Attribute__c newAttribute3 = new Attribute__c(Name='A',Description__c = 'John Muir Society',   Attribute_Type__c = 'Program', External_ID__c = 'PG-A');
	    Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');
        insert newAttribute1;
        insert newAttribute3;
   	    insert newAttribute4;

		// 
		// Now create a Non-SR campaigns, using the atributes
		//        
    	Campaign newNonSRCampaign = new Campaign(
    							Name = 'TC3',
    							Description = 'Test Non-SierraRise Campaign3',
    							Program__c = newAttribute3.Id, 
    							Effort_Type__c = newAttribute4.Id);
    	insert newNonSRCampaign;


		// Create the Account
        Account testAccount = new Account(Name='Test HH');
        if(HouseholdAccountRecordType != null){
            testAccount.RecordTypeId = HouseholdAccountRecordType;
        }
        insert testAccount;

        // Create a contact with a Non-SierraRise Original Campaign
        Contact newContact = new Contact(
        							Account = testAccount,
        							LastName = 'LN',
        							FirstName = 'FN',
        							Original_Campaign__c = newNonSRCampaign.Id
        							);
        if(HouseholdContactRecordType != null){
            newContact.RecordTypeId = HouseholdContactRecordType;
        }
        insert newContact;


		// 
		// Create a Convio Campaign, with an "imported" 100 actions
		//        
        Campaign newConvioCampaign = new Campaign(
        						Name = 'TC1',
        						Description = 'Test Convio Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Advocacy_Action_Count__c = 100,
        						Effort_Type__c = newAttribute4.Id);
    	insert newConvioCampaign;

		// 
		// Create a SR Campaign
		//        
        Campaign newCampaign = new Campaign(
        						Name = 'TSR1',
        						Description = 'Test SierraRise Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id,
        						Related_Convio_Action__c = newConvioCampaign.Id);
    	insert newCampaign;


		//
		// Create a SierraRise Advocacy Action for the Contact, using the newCampaign from above
		//
		kweos__EOCS_Data__c newAdvocacyAction = new kweos__EOCS_Data__c(
			kwac__Contact__c = newContact.Id,
			kwac__Contact_Lead_Status__c = 'New Record Created',
			kweos__Email__c = 'test@test.com',
			kweos__Phone__c = '(415) 555-1212',
			kweos__Prefix__c = 'Ms.',
			kweos__First_Name__c = 'FN',
			kweos__Last_Name__c = 'LN',
			kweos__Address1__c = '12 Parkway Ct',
			kweos__Address2__c = '',
			kweos__City__c = 'Orinda',
			kweos__State__c = 'CA',
			kweos__Postal_Code__c = '94563',
			kweos__Issue__c = 'Gambling',
			kweos__Subject__c = 'Test Subject',
			kweos__Message__c = 'Test Message',
			kwac__Related_Action__c = newCampaign.Id,
			//kwac__Related_Action__c = camp1.Id,
			kwac__Source_Campaign__c = newNonSRCampaign.Id
			);

		System.debug('INSERTINGADVOCACY');		
		insert newAdvocacyAction;
		//
		// END: Create Test Advocacy Action
		//
		

		// Now Test the batch		
		Test.startTest();
		// Same query pulled from batchCampaignAATotalsSchedulable
		String query = 'SELECT id, kwac__Related_Action__c ' +
						'FROM kweos__EOCS_Data__c ' +
						'WHERE kwac__Related_Action__r.Advocacy_Action_Count_Dirty__c = true ' +
						'ORDER BY kwac__Related_Action__c';
        Database.executeBatch(new batchCampaignAATotals(query));
        Test.stopTest();
        
        newCampaign = [
        	SELECT Advocacy_Action_Count__c
        	FROM Campaign
        	WHERE Id = :newCampaign.Id 
        ];
		
		// Assert that the count is now 1 + the 100 from the Convio count for a total of 101.
		//	VB: Odd that when this fails, the counter is Zero.
		//	NOTE: Is the batch the only place the convio counts are added?
		System.assertEquals(101, newCampaign.Advocacy_Action_Count__c);
    }

	// Create two Campaign to test multiple actions.    
    static testMethod void myUnitTestThree() {

		//
		// Need to create Advocacy Test Action
		//
		
        // Create the attributes we will need to insert the Account, Contact, Campaign, and Advocacy Action:
        //
        Attribute__c newAttribute1 = new Attribute__c(Name='4',Description__c = 'Digital Innovation Email', Attribute_Type__c = 'Program', External_ID__c = 'PG-4');
        Attribute__c newAttribute3 = new Attribute__c(Name='A',Description__c = 'John Muir Society',   Attribute_Type__c = 'Program', External_ID__c = 'PG-A');
	    Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');
        insert newAttribute1;
        insert newAttribute3;
   	    insert newAttribute4;

		// 
		// Now create a Non-SR campaigns, using the atributes
		//        
    	Campaign newNonSRCampaign = new Campaign(
    							Name = 'TC3',
    							Description = 'Test Non-SierraRise Campaign3',
    							Program__c = newAttribute3.Id, 
    							Effort_Type__c = newAttribute4.Id);
    	insert newNonSRCampaign;


		// Create the Account
        Account testAccount = new Account(Name='Test HH');
        if(HouseholdAccountRecordType != null){
            testAccount.RecordTypeId = HouseholdAccountRecordType;
		}
        insert testAccount;

        // Create a contact with a Non-SierraRise Original Campaign
        Contact newContact = new Contact(
        							Account = testAccount,
        							LastName = 'LN',
        							FirstName = 'FN',
        							Original_Campaign__c = newNonSRCampaign.Id
        							);
        if(HouseholdContactRecordType != null){
            newContact.RecordTypeId = HouseholdContactRecordType;
        }
        insert newContact;


		// 
		// Create two SR Campaigns
		//        
        Campaign newCampaign1 = new Campaign(
        						Name = 'TC1',
        						Description = 'Test SierraRise Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id);
    	insert newCampaign1;
        Campaign newCampaign2 = new Campaign(
        						Name = 'TC2',
        						Description = 'Test SierraRise Campaign2',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id);
    	insert newCampaign2;

		//
		// Create a SierraRise Advocacy Action for the Contact, using the newCampaign from above
		//
		kweos__EOCS_Data__c newAdvocacyAction1 = new kweos__EOCS_Data__c(
			kwac__Contact__c = newContact.Id,
			kwac__Contact_Lead_Status__c = 'New Record Created',
			kweos__Email__c = 'test@test.com',
			kweos__Phone__c = '(415) 555-1212',
			kweos__Prefix__c = 'Ms.',
			kweos__First_Name__c = 'FN',
			kweos__Last_Name__c = 'LN',
			kweos__Address1__c = '12 Parkway Ct',
			kweos__Address2__c = '',
			kweos__City__c = 'Orinda',
			kweos__State__c = 'CA',
			kweos__Postal_Code__c = '94563',
			kweos__Issue__c = 'Gambling',
			kweos__Subject__c = 'Test Subject',
			kweos__Message__c = 'Test Message',
			kwac__Related_Action__c = newCampaign1.Id,
			//kwac__Related_Action__c = camp1.Id,
			kwac__Source_Campaign__c = newNonSRCampaign.Id
			);

		System.debug('INSERTINGADVOCACY 1');		
		insert newAdvocacyAction1;

		kweos__EOCS_Data__c newAdvocacyAction2 = new kweos__EOCS_Data__c(
			kwac__Contact__c = newContact.Id,
			kwac__Contact_Lead_Status__c = 'New Record Created',
			kweos__Email__c = 'test@test.com',
			kweos__Phone__c = '(415) 555-1212',
			kweos__Prefix__c = 'Ms.',
			kweos__First_Name__c = 'FN',
			kweos__Last_Name__c = 'LN',
			kweos__Address1__c = '12 Parkway Ct',
			kweos__Address2__c = '',
			kweos__City__c = 'Orinda',
			kweos__State__c = 'CA',
			kweos__Postal_Code__c = '94563',
			kweos__Issue__c = 'Gambling',
			kweos__Subject__c = 'Test Subject',
			kweos__Message__c = 'Test Message',
			kwac__Related_Action__c = newCampaign2.Id,
			//kwac__Related_Action__c = camp1.Id,
			kwac__Source_Campaign__c = newNonSRCampaign.Id
			);

		System.debug('INSERTINGADVOCACY');		
		insert newAdvocacyAction2;

		//
		// END: Create Test Advocacy Action
		//
		

		// Now Test the batch		
		Test.startTest();
		// Same query pulled from batchCampaignAATotalsSchedulable
		String query = 'SELECT id, kwac__Related_Action__c ' +
						'FROM kweos__EOCS_Data__c ' +
						'WHERE kwac__Related_Action__r.Advocacy_Action_Count_Dirty__c = true ' +
						'ORDER BY kwac__Related_Action__c';
        Database.executeBatch(new batchCampaignAATotals(query));
        Test.stopTest();

		// Grab the 1st AA Campaign        
        newCampaign1 = [
        	SELECT Advocacy_Action_Count__c
        	FROM Campaign
        	WHERE Id = :newCampaign1.Id 
        ];
		// Assert that the count is now 1
		System.assertEquals(1, newCampaign1.Advocacy_Action_Count__c);

		// Grab the 2nd AA Campaign
        newCampaign2 = [
        	SELECT Advocacy_Action_Count__c
        	FROM Campaign
        	WHERE Id = :newCampaign2.Id 
        ];
		// Assert that the count is now 1
		System.assertEquals(1, newCampaign2.Advocacy_Action_Count__c);
    }

	// Create a Campaign with an oFfset count    
    static testMethod void myUnitTestFour() {

		//
		// Need to create Advocacy Test Action
		//
		
        // Create the attributes we will need to insert the Account, Contact, Campaign, and Advocacy Action:
        //
        Attribute__c newAttribute1 = new Attribute__c(Name='4',Description__c = 'Digital Innovation Email', Attribute_Type__c = 'Program', External_ID__c = 'PG-4');
        Attribute__c newAttribute3 = new Attribute__c(Name='A',Description__c = 'John Muir Society',   Attribute_Type__c = 'Program', External_ID__c = 'PG-A');
	    Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');
        insert newAttribute1;
        insert newAttribute3;
   	    insert newAttribute4;

		// 
		// Now create a Non-SR campaigns, using the atributes
		//        
    	Campaign newNonSRCampaign = new Campaign(
    							Name = 'TC3',
    							Description = 'Test Non-SierraRise Campaign3',
    							Program__c = newAttribute3.Id, 
    							Effort_Type__c = newAttribute4.Id);
    	insert newNonSRCampaign;


		// Create the Account
        Account testAccount = new Account(Name='Test HH');
        if(HouseholdAccountRecordType != null){
            testAccount.RecordTypeId = HouseholdAccountRecordType;
        }
        insert testAccount;

        // Create a contact with a Non-SierraRise Original Campaign
        Contact newContact = new Contact(
        							Account = testAccount,
        							LastName = 'LN',
        							FirstName = 'FN',
        							Original_Campaign__c = newNonSRCampaign.Id
        							);
        if(HouseholdContactRecordType != null){
            newContact.RecordTypeId = HouseholdContactRecordType;
        }
        insert newContact;


		// 
		// Create a Convio Campaign, with an "imported" 100 actions
		//        
        Campaign newConvioCampaign = new Campaign(
        						Name = 'TC1',
        						Description = 'Test Convio Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Advocacy_Action_Count__c = 100,
        						Effort_Type__c = newAttribute4.Id);
    	insert newConvioCampaign;

		// 
		// Create a SR Campaign
		//        
        Campaign newCampaign = new Campaign(
        						Name = 'TSR1',
        						Description = 'Test SierraRise Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id,
        						Related_Convio_Action__c = newConvioCampaign.Id,
        						Advocacy_Action_Count_Offset__c = 1000
        						);
    	insert newCampaign;


		//
		// Create a SierraRise Advocacy Action for the Contact, using the newCampaign from above
		//
		kweos__EOCS_Data__c newAdvocacyAction = new kweos__EOCS_Data__c(
			kwac__Contact__c = newContact.Id,
			kwac__Contact_Lead_Status__c = 'New Record Created',
			kweos__Email__c = 'test@test.com',
			kweos__Phone__c = '(415) 555-1212',
			kweos__Prefix__c = 'Ms.',
			kweos__First_Name__c = 'FN',
			kweos__Last_Name__c = 'LN',
			kweos__Address1__c = '12 Parkway Ct',
			kweos__Address2__c = '',
			kweos__City__c = 'Orinda',
			kweos__State__c = 'CA',
			kweos__Postal_Code__c = '94563',
			kweos__Issue__c = 'Gambling',
			kweos__Subject__c = 'Test Subject',
			kweos__Message__c = 'Test Message',
			kwac__Related_Action__c = newCampaign.Id,
			//kwac__Related_Action__c = camp1.Id,
			kwac__Source_Campaign__c = newNonSRCampaign.Id
			);

		System.debug('INSERTINGADVOCACY');		
		insert newAdvocacyAction;
		//
		// END: Create Test Advocacy Action
		//
		

		// Now Test the batch		
		Test.startTest();
		// Same query pulled from batchCampaignAATotalsSchedulable
		String query = 'SELECT id, kwac__Related_Action__c ' +
						'FROM kweos__EOCS_Data__c ' +
						'WHERE kwac__Related_Action__r.Advocacy_Action_Count_Dirty__c = true ' +
						'ORDER BY kwac__Related_Action__c';
        Database.executeBatch(new batchCampaignAATotals(query));
        Test.stopTest();
        
        newCampaign = [
        	SELECT Advocacy_Action_Count__c
        	FROM Campaign
        	WHERE Id = :newCampaign.Id 
        ];
		
		// Assert that the count is now 1 + the 100 from the Convio count for a total of 101.
		//	VB: Odd that when this fails, the counter is Zero.
		//	NOTE: Is the batch the only place the convio counts are added?
		System.assertEquals(1101, newCampaign.Advocacy_Action_Count__c);
    }


}