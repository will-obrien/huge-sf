/*********************************************************************************************************
Name			: AdvocacyActionTriggerHandlerTest
Created by		: Vernon Baas
Created Date	: June 29, 2015
Description		: test class for AdvocacyActionTriggerHandler
Update			: 2015/08/05 - VB - Added static non-SOQL record type lookup 
***********************************************************************************************************/
//@isTest(SeeAllData=true)
@isTest
private class AdvocacyActionTriggerHandlerTest {

	/*
    private static String HouseHoldAccountRecordType;
    private static String HouseHoldContactRecordType;
    private static String GeneralPreferenceRecordType;

    //fetch Account and Contact record type with name 'Houshold'
    private static void recordTypes(){
        for(RecordType RT: [SELECT ID,SobjectType 
        						FROM RecordType 
        						WHERE ((SobjectType='Account' OR SobjectType='Contact') AND NAME='Household')
        							OR (SobjectType='rC_Bios__Preference__c' AND NAME='General')]){
            if(RT.SobjectType == 'Account' ){
                HouseholdAccountRecordType = RT.ID;
            }
            if(RT.SobjectType == 'Contact'){
                HouseholdContactRecordType = RT.ID;
            }
            if(RT.SobjectType == 'rC_Bios__Preference__c' ){
                GeneralPreferenceRecordType = RT.ID;
            }
        }
    }
    */

    static String HouseHoldAccountRecordType;
    static String HouseHoldContactRecordType;
    static String GeneralPreferenceRecordType;
	static {
		HouseHoldAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		HouseHoldContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		GeneralPreferenceRecordType = Schema.SObjectType.rC_Bios__Preference__c.getRecordTypeInfosByName().get('Club-wide').getRecordTypeId();
	}


//
//
//
//
//  ONE - SR Account
//
//
//
//
//

    //method to test Preference creation
    private static testMethod void newSierraRiseAccount(){

        //recordTypes();
        
        // Create the preference codes we will need:
        rC_Bios__Preference_Code__c newPrefCode1 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Email Subscription',rC_Bios__Subcategory__c = 'SierraRise All', rC_Bios__Code_Value__c = 'SIERRARISE');
        rC_Bios__Preference_Code__c newPrefCode2 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Classification',rC_Bios__Subcategory__c = 'SierraRise Exclusive',   rC_Bios__Code_Value__c = 'SREXCLUSIVE');
        insert newPrefCode1;
        insert newPrefCode2;
        
        // Need to create attributes for the test.
        List<Attribute__c> attributeList = new List<Attribute__c>();
        
        Attribute__c newAttribute1 = new Attribute__c(Name='4',Description__c = 'Digital Innovation Email', Attribute_Type__c = 'Program', External_ID__c = 'PG-4');
        Attribute__c newAttribute2 = new Attribute__c(Name='9',Description__c = 'Digital Innovation Web',   Attribute_Type__c = 'Program', External_ID__c = 'PG-9');
        Attribute__c newAttribute3 = new Attribute__c(Name='A',Description__c = 'John Muir Society',   Attribute_Type__c = 'Program', External_ID__c = 'PG-A');
        Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');

    	Database.SaveResult result = Database.insert(newAttribute1, true);
    	
		// Iterate through each returned result
	    if (!result.isSuccess()) {
	        // Operation failed, so get all errors                
	        for(Database.Error err : result.getErrors()) {
	            System.debug('The following error has occurred.');                    
	            System.debug(err.getStatusCode() + ': ' + err.getMessage());
	            System.debug('Fields that affected this error: ' + err.getFields());
	        }
	    } else {
	            System.debug('Insert Successful: supposedly...');                    
	    }

		// Pull the values back from Salesforce
    	newAttribute1 = [SELECT Id, 
    					Name, 
    					CreatedById, 
    					LastModifiedById, 
    					OwnerId, 
    					Attribute_Type__c, 
    					Description__c, 
    					External_ID__c 
    				FROM Attribute__c 
    				WHERE Id=:newAttribute1.Id];
    	System.debug( 'ATTRIBUTE:Name:' + newAttribute1.Name);
    	
    	System.assertEquals('4', newAttribute1.Name);
    	System.assertEquals('Digital Innovation Email', newAttribute1.Description__c);
    	System.assertEquals('Program', newAttribute1.Attribute_Type__c);
    	System.assertEquals('PG-4', newAttribute1.External_Id__c);

        //insert newAttribute1;
        insert newAttribute2;
        insert newAttribute3;
        insert newAttribute4;


		// 
		// Now create the campaigns, using the atributes
		//        
    	List<Campaign> campaignList = new List<Campaign>();
        Campaign camp1 = new Campaign(
        						Name = 'TC1',
        						Description = 'Test SierraRise Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id);
    	campaignList.add(camp1);
    	Campaign camp2 = new Campaign(
    							Name = 'TC2',
    							Description = 'Test SierraRise Campaign2',
    							Program__c = newAttribute2.Id, 
    							Effort_Type__c = newAttribute4.Id);
    	campaignList.add(camp2);
    	Campaign camp3 = new Campaign(
    							Name = 'TC3',
    							Description = 'Test Non-SierraRise Campaign3',
    							Program__c = newAttribute3.Id, 
    							Effort_Type__c = newAttribute4.Id);
    	campaignList.add(camp3);
    	
    	//insert campaignList;
    	
    	Database.SaveResult[] srList = Database.insert(campaignList, false);

		// Iterate through each returned result
		for (Database.SaveResult sr : srList) {
		    if (!sr.isSuccess()) {
		        // Operation failed, so get all errors                
		        for(Database.Error err : sr.getErrors()) {
		            System.debug('The following error has occurred.');                    
		            System.debug(err.getStatusCode() + ': ' + err.getMessage());
		            System.debug('Fields that affected this error: ' + err.getFields());
		        }
		    } else {
		    	System.debug('Campaigns inserted successfully');
		    }
		}
    	
    	System.debug('Campaign1 Id:' + camp1.Id + ':');

		// Confirm the Campaigns are entered and are correctly attributed.
		// VB: was getting strange errors here, so it's a little overboard.    	
    	camp1 = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:camp1.Id];
    	System.assertEquals('TC1', 							camp1.Name);
    	System.assertEquals('Test SierraRise Campaign1', 	camp1.Description);
    	System.assertEquals('4', 							camp1.Program__r.Name);
    	System.assertEquals('Digital Innovation Email', 	camp1.Program__r.Description__c);
    	System.assertEquals('PG-4', 						camp1.Program__r.External_Id__c);
    	System.assertEquals('SR', 							camp1.Effort_Type__r.Name);
    	System.assertEquals(true, 							camp1.SierraRise_Campaign__c);

    	camp2 = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:camp2.Id];
    	System.assertEquals('TC2', camp2.Name);
    	System.assertEquals('Test SierraRise Campaign2', 	camp2.Description);
    	System.assertEquals('9', 							camp2.Program__r.Name);
    	System.assertEquals('Digital Innovation Web', 		camp2.Program__r.Description__c);
    	System.assertEquals('PG-9', 						camp2.Program__r.External_Id__c);
    	System.assertEquals('SR', 							camp2.Effort_Type__r.Name);
    	System.assertEquals(true, 							camp2.SierraRise_Campaign__c);

    	camp3 = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:camp3.Id];
    	System.assertEquals('TC3', 							camp3.Name);
    	System.assertEquals('Test Non-SierraRise Campaign3', camp3.Description);
    	System.assertEquals('A', 							camp3.Program__r.Name);
    	System.assertEquals('John Muir Society',			camp3.Program__r.Description__c);
    	System.assertEquals('PG-A', 						camp3.Program__r.External_Id__c);
    	System.assertEquals('SR', 							camp3.Effort_Type__r.Name);
    	System.assertEquals(false, 							camp3.SierraRise_Campaign__c);
    	
        //
        // Now create the Account & Contact from the Campaign
        //
        Account testAccount = new Account(Name='Test HH', Original_Campaign__c = camp1.Id );
        if(HouseholdAccountRecordType != null){
            testAccount.RecordTypeId = HouseholdAccountRecordType;
        }
        insert testAccount;

        // Create a contact with a SierraRise Original Campaign
        Contact testContact = new Contact(
        							Account = testAccount,
        							LastName = 'LN',
        							FirstName = 'FN',
        							Original_Campaign__c = camp1.Id
        							);
        if(HouseholdContactRecordType != null){
            testContact.RecordTypeId = HouseholdContactRecordType;
        }
        insert testContact;

        //
        // Confirm they're a SierraRise All person
        //
    	testContact = [SELECT Id, Name, External_Id__c, SierraRise_All__c 
    			FROM Contact 
    			WHERE Id=:testContact.Id];
    	System.assertEquals(true, testContact.SierraRise_All__c);
        
    	List<rC_Bios__Preference__c> newPreferences = [
    			SELECT 	Id, 
    					Name,
    					Preference_Record_Type__c,
    					rC_Bios__Account__c,
    					rC_Bios__Contact__c,
    					rC_Bios__Active__c,
    					rC_Bios__Affiliation__c,
    					rC_Bios__Subcategory__c,
    					rC_Bios__Category__c,
    					rC_Bios__Value__c,
						rC_Bios__Code_Value__c
    				FROM rC_Bios__Preference__c 
    				WHERE rC_Bios__Contact__c =: testContact.Id];
    	
    	// Should be two, a SR & SRE preference?
        System.assertEquals(2, newPreferences.size());

		Boolean sierrariseFound = false;

		// Iterate through each returned result
		for (rC_Bios__Preference__c thePref : newPreferences) {

			
			// Find the SierraRise All
			if (thePref.rC_Bios__Subcategory__c == 'SierraRise All') {

				//System.assertEquals('05675172',thePref.Name);
				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Email Subscription',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise All',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(testContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SIERRARISE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SIERRARISE',thePref.rC_Bios__Code_Value__c);
				
				// Note that we found the preference
				sierrariseFound = true;

				// DEBUG 
				/*
				System.debug('Pref.Name: ' +thePref.Name);
				System.debug('Pref.Preference_Record_Type__c: ' +thePref.Preference_Record_Type__c);
				System.debug('Pref.rC_Bios__Account__c: ' +thePref.rC_Bios__Account__c);
				System.debug('Pref.rC_Bios__Active__c: ' +thePref.rC_Bios__Active__c);
				System.debug('Pref.rC_Bios__Affiliation__c: ' +thePref.rC_Bios__Affiliation__c);
				System.debug('Pref.rC_Bios__Subcategory__c: ' +thePref.rC_Bios__Subcategory__c);
				System.debug('Pref.rC_Bios__Category__c: ' +thePref.rC_Bios__Category__c);
				System.debug('Pref.rC_Bios__Value__c: ' +thePref.rC_Bios__Value__c);
				*/
			}
			
		}
		//System.debug('Prefs Found: ' + newPreferences.size()); 
        System.assertEquals(true, sierrariseFound);

    }

//
//
//
//
//  TWO - NON-SR Account
//
//
//
//
//

    private static testMethod void newNonSierraRiseAccount(){

        //recordTypes();
        
        // Create the preference codes we will need:
        rC_Bios__Preference_Code__c newPrefCode1 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Email Subscription',rC_Bios__Subcategory__c = 'SierraRise All', rC_Bios__Code_Value__c = 'SIERRARISE');
        rC_Bios__Preference_Code__c newPrefCode2 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Classification',rC_Bios__Subcategory__c = 'SierraRise Exclusive',   rC_Bios__Code_Value__c = 'SREXCLUSIVE');
        insert newPrefCode1;
        insert newPrefCode2;
        
        // Need to create attributes for the test.
        List<Attribute__c> attributeList = new List<Attribute__c>();
        
        Attribute__c newAttribute1 = new Attribute__c(Name='4',Description__c = 'Digital Innovation Email', Attribute_Type__c = 'Program', External_ID__c = 'PG-4');
        Attribute__c newAttribute2 = new Attribute__c(Name='9',Description__c = 'Digital Innovation Web',   Attribute_Type__c = 'Program', External_ID__c = 'PG-9');
        Attribute__c newAttribute3 = new Attribute__c(Name='A',Description__c = 'John Muir Society',   Attribute_Type__c = 'Program', External_ID__c = 'PG-A');
        Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');

    	Database.SaveResult result = Database.insert(newAttribute1, true);
    	
		// Iterate through each returned result
	    if (!result.isSuccess()) {
	        // Operation failed, so get all errors                
	        for(Database.Error err : result.getErrors()) {
	            System.debug('The following error has occurred.');                    
	            System.debug(err.getStatusCode() + ': ' + err.getMessage());
	            System.debug('Fields that affected this error: ' + err.getFields());
	        }
	    } else {
	            System.debug('Insert Successful: supposedly...');                    
	    }

		// Pull the values back from Salesforce
    	newAttribute1 = [SELECT Id, 
    					Name, 
    					CreatedById, 
    					LastModifiedById, 
    					OwnerId, 
    					Attribute_Type__c, 
    					Description__c, 
    					External_ID__c 
    				FROM Attribute__c 
    				WHERE Id=:newAttribute1.Id];
    	System.debug( 'ATTRIBUTE:Name:' + newAttribute1.Name);
    	
    	System.assertEquals('4', newAttribute1.Name);
    	System.assertEquals('Digital Innovation Email', newAttribute1.Description__c);
    	System.assertEquals('Program', newAttribute1.Attribute_Type__c);
    	System.assertEquals('PG-4', newAttribute1.External_Id__c);

        //insert newAttribute1;
        insert newAttribute2;
        insert newAttribute3;
        insert newAttribute4;


		// 
		// Now create the campaigns, using the atributes
		//        
    	List<Campaign> campaignList = new List<Campaign>();
        Campaign camp1 = new Campaign(
        						Name = 'TC1',
        						Description = 'Test SierraRise Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id);
    	campaignList.add(camp1);
    	Campaign camp2 = new Campaign(
    							Name = 'TC2',
    							Description = 'Test SierraRise Campaign2',
    							Program__c = newAttribute2.Id, 
    							Effort_Type__c = newAttribute4.Id);
    	campaignList.add(camp2);
    	Campaign camp3 = new Campaign(
    							Name = 'TC3',
    							Description = 'Test Non-SierraRise Campaign3',
    							Program__c = newAttribute3.Id, 
    							Effort_Type__c = newAttribute4.Id);
    	campaignList.add(camp3);
    	
    	//insert campaignList;
    	
    	Database.SaveResult[] srList = Database.insert(campaignList, false);

		// Iterate through each returned result
		for (Database.SaveResult sr : srList) {
		    if (!sr.isSuccess()) {
		        // Operation failed, so get all errors                
		        for(Database.Error err : sr.getErrors()) {
		            System.debug('The following error has occurred.');                    
		            System.debug(err.getStatusCode() + ': ' + err.getMessage());
		            System.debug('Fields that affected this error: ' + err.getFields());
		        }
		    } else {
		    	System.debug('Campaigns inserted successfully');
		    }
		}
    	
    	System.debug('Campaign1 Id:' + camp1.Id + ':');

		// Confirm the Campaigns are entered and are correctly attributed.
		// VB: was getting strange errors here, so it's a little overboard.    	
    	camp1 = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:camp1.Id];
    	System.assertEquals('TC1', 							camp1.Name);
    	System.assertEquals('Test SierraRise Campaign1', 	camp1.Description);
    	System.assertEquals('4', 							camp1.Program__r.Name);
    	System.assertEquals('Digital Innovation Email', 	camp1.Program__r.Description__c);
    	System.assertEquals('PG-4', 						camp1.Program__r.External_Id__c);
    	System.assertEquals('SR', 							camp1.Effort_Type__r.Name);
    	System.assertEquals(true, 							camp1.SierraRise_Campaign__c);

    	camp2 = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:camp2.Id];
    	System.assertEquals('TC2', camp2.Name);
    	System.assertEquals('Test SierraRise Campaign2', 	camp2.Description);
    	System.assertEquals('9', 							camp2.Program__r.Name);
    	System.assertEquals('Digital Innovation Web', 		camp2.Program__r.Description__c);
    	System.assertEquals('PG-9', 						camp2.Program__r.External_Id__c);
    	System.assertEquals('SR', 							camp2.Effort_Type__r.Name);
    	System.assertEquals(true, 							camp2.SierraRise_Campaign__c);

    	camp3 = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:camp3.Id];
    	System.assertEquals('TC3', 							camp3.Name);
    	System.assertEquals('Test Non-SierraRise Campaign3', camp3.Description);
    	System.assertEquals('A', 							camp3.Program__r.Name);
    	System.assertEquals('John Muir Society',			camp3.Program__r.Description__c);
    	System.assertEquals('PG-A', 						camp3.Program__r.External_Id__c);
    	System.assertEquals('SR', 							camp3.Effort_Type__r.Name);
    	System.assertEquals(false, 							camp3.SierraRise_Campaign__c);

		/* VB: meh, not needed
    	Campaign camp3 = new Campaign(Name = 'Test Campaign1');
    	Database.SaveResult result = Database.insert(camp3, false);
    	System.assertEquals(false, result.isSuccess());
    	System.assertEquals('Campaign already exists', result.getErrors()[0].getMessage());
    	*/
    	
        
        Account testAccount = new Account(Name='Test HH', Original_Campaign__c = camp3.Id );
        if(HouseholdAccountRecordType != null){
            testAccount.RecordTypeId = HouseholdAccountRecordType;
            //testAccount.Original_Campaign__c = camp1.Id;
        }
        insert testAccount;

        // Create a contact with a Non-SierraRise Original Campaign
        Contact testContact = new Contact(
        							Account = testAccount,
        							LastName = 'LN',
        							FirstName = 'FN',
        							Original_Campaign__c = camp3.Id
        							);
        if(HouseholdContactRecordType != null){
            testContact.RecordTypeId = HouseholdContactRecordType;
        }
        insert testContact;

        //
        // Confirm they're NOT a SierraRise All person
        //
    	testContact = [SELECT 	Id, 
    							Name, 
    							External_Id__c, 
    							SierraRise_All__c 
    					FROM Contact 
    					WHERE Id=:testContact.Id];
    	System.assertEquals(false, testContact.SierraRise_All__c);
        
    	List<rC_Bios__Preference__c> newPreferences = [
    			SELECT 	Id, 
    					Name,
    					Preference_Record_Type__c,
    					rC_Bios__Account__c,
    					rC_Bios__Contact__c,
    					rC_Bios__Active__c,
    					rC_Bios__Affiliation__c,
    					rC_Bios__Subcategory__c,
    					rC_Bios__Category__c,
    					rC_Bios__Value__c,
						rC_Bios__Code_Value__c
    				FROM rC_Bios__Preference__c 
    				WHERE rC_Bios__Contact__c =: testContact.Id];
        System.assertEquals(0, newPreferences.size());

		Boolean sierrariseFound = false;

		// Iterate through each returned result
		for (rC_Bios__Preference__c thePref : newPreferences) {
			
			// Find the SierraRise All
			if (thePref.rC_Bios__Subcategory__c == 'SierraRise All') {
				
				// Note that we found the preference
				sierrariseFound = true;

				// DEBUG 
				/*
				System.debug('Pref.Name: ' +thePref.Name);
				System.debug('Pref.Preference_Record_Type__c: ' +thePref.Preference_Record_Type__c);
				System.debug('Pref.rC_Bios__Account__c: ' +thePref.rC_Bios__Account__c);
				System.debug('Pref.rC_Bios__Active__c: ' +thePref.rC_Bios__Active__c);
				System.debug('Pref.rC_Bios__Affiliation__c: ' +thePref.rC_Bios__Affiliation__c);
				System.debug('Pref.rC_Bios__Subcategory__c: ' +thePref.rC_Bios__Subcategory__c);
				System.debug('Pref.rC_Bios__Category__c: ' +thePref.rC_Bios__Category__c);
				System.debug('Pref.rC_Bios__Value__c: ' +thePref.rC_Bios__Value__c);
				*/
				
				// It should not find a SierraRise preference,
				//	so throw an error
				System.AssertEquals(true,false,'SierraRise Preference found when not expected');

				/*
				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('General',thePref.Preference_Record_Type__c);
				System.assertEquals('Email Subscription',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise All',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				System.assertEquals(null,thePref.rC_Bios__Value__c);
				*/
			}
			
		}
		//System.debug('Prefs Found: ' + newPreferences.size()); 
        System.assertEquals(false, sierrariseFound);

    }

//
//
//
//
//  THREE - Create a Non-SR Contact, and return it.
//
//
//
//
//

	//
	// Create a Non-SierraRise Account/Contact
	//
    private static Contact newNonSierraRiseAccountContact(){

        //recordTypes();
        
        // Create the preference codes we will need:
        rC_Bios__Preference_Code__c newPrefCode1 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Email Subscription',rC_Bios__Subcategory__c = 'SierraRise All', rC_Bios__Code_Value__c = 'SIERRARISE');
        rC_Bios__Preference_Code__c newPrefCode2 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Classification',rC_Bios__Subcategory__c = 'SierraRise Exclusive',   rC_Bios__Code_Value__c = 'SREXCLUSIVE');
        insert newPrefCode1;
        insert newPrefCode2;
        
        // Need to create attributes for the test.
        List<Attribute__c> attributeList = new List<Attribute__c>();
        
        Attribute__c newAttribute3 = new Attribute__c(Name='A',Description__c = 'John Muir Society',   Attribute_Type__c = 'Program', External_ID__c = 'PG-A');
	    Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');

   	    insert newAttribute4;
        insert newAttribute3;

		// 
		// Now create a Non-SR campaigns, using the atributes
		//        
    	Campaign camp3 = new Campaign(
    							Name = 'TC3',
    							Description = 'Test Non-SierraRise Campaign3',
    							Program__c = newAttribute3.Id, 
    							Effort_Type__c = newAttribute4.Id);
    	insert camp3;


		// Create the Account
        Account testAccount = new Account(Name='Test HH');
        if(HouseholdAccountRecordType != null){
            testAccount.RecordTypeId = HouseholdAccountRecordType;
        }
        insert testAccount;

        // Create a contact with a Non-SierraRise Original Campaign
        Contact testContact = new Contact(
        							Account = testAccount,
        							LastName = 'LN',
        							FirstName = 'FN',
        							Original_Campaign__c = camp3.Id
        							);
        if(HouseholdContactRecordType != null){
            testContact.RecordTypeId = HouseholdContactRecordType;
        }
        insert testContact;


        //
        // Confirm they're NOT a SierraRise All person
        //
    	testContact = [SELECT 	Id,
    							AccountId, 
    							Name, 
    							External_Id__c, 
    							SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id=:testContact.Id];
    	System.assertEquals(false, testContact.SierraRise_All__c);
        
        return testContact;
    }




//
//
//
//
//  THREE AAA - Create a non-SR Campaign, and return it.
//
//
//
//
//

	//
	// Create a Non-SierraRise Account/Contact
	//
    private static Campaign newNonSierraRiseCampaign(){

        //recordTypes();
        
        // Create the preference codes we will need:
        rC_Bios__Preference_Code__c newPrefCode1 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Email Subscription',rC_Bios__Subcategory__c = 'SierraRise All', rC_Bios__Code_Value__c = 'SIERRARISE');
        rC_Bios__Preference_Code__c newPrefCode2 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Classification',rC_Bios__Subcategory__c = 'SierraRise Exclusive',   rC_Bios__Code_Value__c = 'SREXCLUSIVE');
        insert newPrefCode1;
        insert newPrefCode2;
        
        Attribute__c newAttribute3 = new Attribute__c(Name='A',Description__c = 'John Muir Society',   Attribute_Type__c = 'Program', External_ID__c = 'PG-A');
        Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');
        insert newAttribute3;
        insert newAttribute4;

		// 
		// Now create the campaigns, using the atributes
		//        
    	Campaign camp3 = new Campaign(
    							Name = 'TC3',
    							Description = 'Test Non-SierraRise Campaign3',
    							Program__c = newAttribute3.Id, 
    							Effort_Type__c = newAttribute4.Id);
    	insert camp3;
    	
    	System.debug('Campaign1 Id:' + camp3.Id + ':');

		// Confirm the Campaigns are entered and are correctly attributed.
		// VB: was getting strange errors here, so it's a little overboard.    	
    	camp3 = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:camp3.Id];
    	System.assertEquals('TC3', 							camp3.Name);
    	System.assertEquals('Test Non-SierraRise Campaign3', camp3.Description);
    	System.assertEquals('A', 							camp3.Program__r.Name);
    	System.assertEquals('John Muir Society',			camp3.Program__r.Description__c);
    	System.assertEquals('PG-A', 						camp3.Program__r.External_Id__c);
    	System.assertEquals('SR', 							camp3.Effort_Type__r.Name);
    	System.assertEquals(false, 							camp3.SierraRise_Campaign__c);
        
        return camp3;
    }


//
//
//
//
//  THREE BBB - Create a SR Campaign, and return it.
//
//
//
//
//

	//
	// Create a SierraRise Campaign, and return it
	//
    private static Campaign newSierraRiseCampaign(){

        //recordTypes();
        
        // Create the preference codes we will need:
        rC_Bios__Preference_Code__c newPrefCode1 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Email Subscription',rC_Bios__Subcategory__c = 'SierraRise All', rC_Bios__Code_Value__c = 'SIERRARISE');
        rC_Bios__Preference_Code__c newPrefCode2 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Classification',rC_Bios__Subcategory__c = 'SierraRise Exclusive',   rC_Bios__Code_Value__c = 'SREXCLUSIVEe');
        insert newPrefCode1;
        insert newPrefCode2;
        
        // Need to create attributes for the test.
        //List<Attribute__c> attributeList = new List<Attribute__c>();
        
        Attribute__c newAttribute1 = new Attribute__c(Name='4',Description__c = 'Digital Innovation Email', Attribute_Type__c = 'Program', External_ID__c = 'PG-4');
        Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');

        insert newAttribute1;
        insert newAttribute4;

		// 
		// Now create the campaigns, using the atributes
		//        
        Campaign camp1 = new Campaign(
        						Name = 'TC1',
        						Description = 'Test SierraRise Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id);
    	insert camp1;
    	
		// Confirm the Campaigns are entered and are correctly attributed.
		// VB: was getting strange errors here, so it's a little overboard.    	
    	camp1 = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:camp1.Id];
    	System.assertEquals('TC1', 							camp1.Name);
    	System.assertEquals('Test SierraRise Campaign1', 	camp1.Description);
    	System.assertEquals('4', 							camp1.Program__r.Name);
    	System.assertEquals('Digital Innovation Email', 	camp1.Program__r.Description__c);
    	System.assertEquals('PG-4', 						camp1.Program__r.External_Id__c);
    	System.assertEquals('SR', 							camp1.Effort_Type__r.Name);
    	System.assertEquals(true, 							camp1.SierraRise_Campaign__c);

        return camp1;
    }



//
//
//
//
//  FOUR - SierraRise w/ preferences
//
//
//
//
//
        
	//
	// Create a Non-SierraRise Account/Contact & Add a SR Preference
	//
	private static testMethod void aSierraRisePreference(){

		// Create a new non-SR Contact/Account
		Contact newContact = newNonSierraRiseAccountContact();

		// First confirm the Contact is not SierraRise nor SierraRise Exclusive
        System.assertEquals(false, newContact.SierraRise_All__c);
        System.assertEquals(false, newContact.SierraRise_Exclusive__c);

		// Create a SierraRise preference for the Contact
		
		// Create the new Preference			
		rC_Bios__Preference__c newPreference = new rC_Bios__Preference__c(
			//rC_Bios__Account__c = newContact.AccountId,
			rC_Bios__Contact__c = newContact.Id,
			RecordTypeId = GeneralPreferenceRecordType,
			rC_Bios__Category__c = 'Email Subscription',		// 7/24/15: Populate by Value failed
			rC_Bios__Subcategory__c = 'SierraRise All',			// 7/24/15: Populate by Value failed
			rC_Bios__Code_Value__c = 'SIERRARISE',
			//rC_Bios__Value__c = 'SIERRARISE',					// 8/18/15: Stopping population of this.
			rC_Bios__Active__c = true);

		// Save off the new Preference					
		insert newPreference;
		

		// Confirm the User is now SierraRise
    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        System.assertEquals(true, newContact.SierraRise_All__c);
        
        // False?
        System.assertEquals(true, newContact.SierraRise_Exclusive__c);
		
    }


	//
	// Create a Non-SierraRise Account/Contact & a non-SR Preference
	//
	private static testMethod void nonSierraRisePreference(){

		// Create a new non-SR Contact/Account
		Contact newContact = newNonSierraRiseAccountContact();

		// First confirm the Contact is not SierraRise nor SierraRise Exclusive
        System.assertEquals(false, newContact.SierraRise_All__c);
        System.assertEquals(false, newContact.SierraRise_Exclusive__c);

		// Create a SierraRise preference for the Contact
		
		// Create the new Non-SierraRise Preference			
		rC_Bios__Preference__c newPreference = new rC_Bios__Preference__c(
			//rC_Bios__Account__c = newContact.AccountId,
			rC_Bios__Contact__c = newContact.Id,
			RecordTypeId = GeneralPreferenceRecordType,
			rC_Bios__Category__c = 'Email Subscription',
			rC_Bios__Subcategory__c = 'Green Life',
			rC_Bios__Active__c = true);

		// Save off the new Preference					
		insert newPreference;
		

		// Confirm the User is now SierraRise
    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
    					
		// Confirm they're not SR or SRE
        System.assertEquals(false, newContact.SierraRise_All__c);
        System.assertEquals(false, newContact.SierraRise_Exclusive__c);
    }



//
//
//
//
//  FIVE - SierraRise with Advocacy Action
//
//
//
//
//


	//
	// Create a Non-SierraRise Account/Contact & Add a SR Advocacy Action
	//
	private static testMethod void aSierraRiseAdvocacyAction(){

        //recordTypes();
        
        // Create the preference codes we will need:
        rC_Bios__Preference_Code__c newPrefCode1 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Email Subscription',rC_Bios__Subcategory__c = 'SierraRise All', rC_Bios__Code_Value__c = 'SIERRARISE');
        rC_Bios__Preference_Code__c newPrefCode2 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Classification',rC_Bios__Subcategory__c = 'SierraRise Exclusive',   rC_Bios__Code_Value__c = 'SREXCLUSIVE');
        insert newPrefCode1;
        insert newPrefCode2;
        
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
        // Confirm they're NOT a SierraRise All person
        //
    	newContact = [SELECT 	Id,
    							AccountId, 
    							Name, 
    							External_Id__c, 
    							SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id=:newContact.Id];

		// First confirm the Contact is not SierraRise nor SierraRise Exclusive
        System.assertEquals(false, newContact.SierraRise_All__c);
        System.assertEquals(false, newContact.SierraRise_Exclusive__c);


		// 
		// Create a SR Campaign
		//        
        Campaign newSRCampaign = new Campaign(
        						Name = 'TC1',
        						Description = 'Test SierraRise Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id);
    	insert newSRCampaign;
    	
		// Confirm the Campaigns are entered and are correctly attributed.
		// VB: was getting strange errors here, so it's a little overboard.    	
    	newSRCampaign = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:newSRCampaign.Id];
    	System.assertEquals('TC1', 							newSRCampaign.Name);
    	System.assertEquals('Test SierraRise Campaign1', 	newSRCampaign.Description);
    	System.assertEquals('4', 							newSRCampaign.Program__r.Name);
    	System.assertEquals('Digital Innovation Email', 	newSRCampaign.Program__r.Description__c);
    	System.assertEquals('PG-4', 						newSRCampaign.Program__r.External_Id__c);
    	System.assertEquals('SR', 							newSRCampaign.Effort_Type__r.Name);

		// Confirm the Campaign is SierraRise
        System.assertEquals(true, 							newSRCampaign.SierraRise_Campaign__c);


		//
		// Create a SierraRise Advocacy Action for the Contact
		//
		kweos__EOCS_Data__c newAdvocacyAction = new kweos__EOCS_Data__c(
			kwac__Contact__c = newContact.Id,
			kwac__Contact_Lead_Status__c = 'New Record Created',
			kweos__Email__c = 'test@test.com',
			kweos__Phone__c = '(415) 555-1212',
			kweos__Prefix__c = 'Ms.',
			kweos__First_Name__c = 'FNN',
			kweos__Last_Name__c = 'LN',
			kweos__Address1__c = '12 Parkway Ct',
			kweos__Address2__c = '',
			kweos__City__c = 'Orinda',
			kweos__State__c = 'CA',
			kweos__Postal_Code__c = '94563',
			kweos__Issue__c = 'Gambling',
			kweos__Subject__c = 'Test Subject',
			kweos__Message__c = 'Test Message',
			kwac__Related_Action__c = newSRCampaign.Id,
			kwac__Source_Campaign__c = newNonSRCampaign.Id
			);

    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        System.assertEquals(false, newContact.SierraRise_All__c);

		System.debug('INSERTINGADVOCACY');		
		insert newAdvocacyAction;


    	List<rC_Bios__Preference__c> newPreferences = [
    			SELECT 	Id, 
    					Name,
    					Preference_Record_Type__c,
    					rC_Bios__Account__c,
    					rC_Bios__Contact__c,
    					rC_Bios__Active__c,
    					rC_Bios__Affiliation__c,
    					rC_Bios__Subcategory__c,
    					rC_Bios__Category__c,
    					rC_Bios__Value__c,
						rC_Bios__Code_Value__c
    				FROM rC_Bios__Preference__c 
    				WHERE rC_Bios__Contact__c =: newContact.Id];
    	
		System.debug('Preferences Found: ' + newPreferences.size());

		// Iterate through each returned result
		for (rC_Bios__Preference__c thePref : newPreferences) {
			
			// Find the SierraRise All
			if (thePref.rC_Bios__Subcategory__c == 'SierraRise All') {
				
				// DEBUG 
				System.debug('Pref.rC_Bios__Account__c: ' +thePref.rC_Bios__Account__c);
				System.debug('Pref.rC_Bios__Contact__c: ' +thePref.rC_Bios__Contact__c);
				System.debug('Pref.rC_Bios__Active__c: ' +thePref.rC_Bios__Active__c);
				System.debug('Pref.rC_Bios__Affiliation__c: ' +thePref.rC_Bios__Affiliation__c);
				System.debug('Pref.rC_Bios__Category__c: ' +thePref.rC_Bios__Category__c);
				System.debug('Pref.rC_Bios__Subcategory__c: ' +thePref.rC_Bios__Subcategory__c);
				System.debug('Pref.rC_Bios__Value__c: ' +thePref.rC_Bios__Value__c);
				System.debug('Pref.rC_Bios__Code_Value__c: ' +thePref.rC_Bios__Code_Value__c);

			}
			
		}



		// Confirm the User is now SierraRise
    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        System.assertEquals(true, newContact.SierraRise_All__c);
        
        // As well as being in SierraRise Exclusive
        System.assertEquals(true, newContact.SierraRise_Exclusive__c);
		
    }


	//
	// Create a Non-SierraRise Account/Contact & Add a non-SR Preference
	//
	private static testMethod void aNonSierraRiseAdvocacyAction(){

        //recordTypes();
        
        // Create the preference codes we will need:
        rC_Bios__Preference_Code__c newPrefCode1 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Email Subscription',rC_Bios__Subcategory__c = 'SierraRise All', rC_Bios__Code_Value__c = 'SIERRARISE');
        rC_Bios__Preference_Code__c newPrefCode2 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Classification',rC_Bios__Subcategory__c = 'SierraRise Exclusive',   rC_Bios__Code_Value__c = 'SREXCLUSIVE');
        insert newPrefCode1;
        insert newPrefCode2;
        
        // Need to create attributes for the test.
        //Attribute__c newAttribute1 = new Attribute__c(Name='4',Description__c = 'Digital Innovation Email', Attribute_Type__c = 'Program', External_ID__c = 'PG-4');
        Attribute__c newAttribute3 = new Attribute__c(Name='A',Description__c = 'John Muir Society',   Attribute_Type__c = 'Program', External_ID__c = 'PG-A');
	    Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');
        //insert newAttribute1;
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
    	System.assertEquals(false,newNonSRCampaign.SierraRise_Campaign__c);
    	

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
    	newContact = [SELECT 	Id,
    							AccountId, 
    							Name, 
    							External_Id__c, 
    							SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id=:newContact.Id];

		// Confirm the Contact is not SierraRise nor SierraRise Exclusive
        System.assertEquals(false, newContact.SierraRise_All__c);
        System.assertEquals(false, newContact.SierraRise_Exclusive__c);

		//
		// Create a SierraRise Advocacy Action for the Contact
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
			kwac__Related_Action__c = newNonSRCampaign.Id,
			kwac__Source_Campaign__c = newNonSRCampaign.Id
			);
			//kwac__Source_Campaign__c = newSRCampaign.ID
		
		insert newAdvocacyAction;

		// Confirm the User is still not SierraRise
    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        System.assertEquals(false, newContact.SierraRise_All__c);
        
        // False?
        System.assertEquals(false, newContact.SierraRise_Exclusive__c);
		
    }


	//
	// Create a Non-SierraRise Account/Contact
	//			Add a SR Advocacy Action, confirm
	//			Add a SECOND SR Advocacy Action, confirm correct preferences
	//
	private static testMethod void aSierraRiseAdvocacyActionDupe(){

        //recordTypes();
        
        // Create the preference codes we will need:
        rC_Bios__Preference_Code__c newPrefCode1 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Email Subscription',rC_Bios__Subcategory__c = 'SierraRise All', rC_Bios__Code_Value__c = 'SIERRARISE');
        rC_Bios__Preference_Code__c newPrefCode2 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Classification',rC_Bios__Subcategory__c = 'SierraRise Exclusive',   rC_Bios__Code_Value__c = 'SREXCLUSIVE');
        insert newPrefCode1;
        insert newPrefCode2;
        
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
        // Confirm they're NOT a SierraRise All person
        //
    	newContact = [SELECT 	Id,
    							AccountId, 
    							Name, 
    							External_Id__c, 
    							SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id=:newContact.Id];

		// First confirm the Contact is not SierraRise nor SierraRise Exclusive
        System.assertEquals(false, newContact.SierraRise_All__c);
        System.assertEquals(false, newContact.SierraRise_Exclusive__c);


		// 
		// Create a SR Campaign
		//        
        Campaign newSRCampaign = new Campaign(
        						Name = 'TC1',
        						Description = 'Test SierraRise Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id);
    	insert newSRCampaign;
    	
		// Confirm the Campaigns are entered and are correctly attributed.
		// VB: was getting strange errors here, so it's a little overboard.    	
    	newSRCampaign = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:newSRCampaign.Id];
    	System.assertEquals('TC1', 							newSRCampaign.Name);
    	System.assertEquals('Test SierraRise Campaign1', 	newSRCampaign.Description);
    	System.assertEquals('4', 							newSRCampaign.Program__r.Name);
    	System.assertEquals('Digital Innovation Email', 	newSRCampaign.Program__r.Description__c);
    	System.assertEquals('PG-4', 						newSRCampaign.Program__r.External_Id__c);
    	System.assertEquals('SR', 							newSRCampaign.Effort_Type__r.Name);

		// Confirm the Campaign is SierraRise
        System.assertEquals(true, 							newSRCampaign.SierraRise_Campaign__c);


		//
		// Create a SierraRise Advocacy Action for the Contact
		//
		kweos__EOCS_Data__c newAdvocacyAction = new kweos__EOCS_Data__c(
			kwac__Contact__c = newContact.Id,
			kwac__Contact_Lead_Status__c = 'New Record Created',
			kweos__Email__c = 'test@test.com',
			kweos__Phone__c = '(415) 555-1212',
			kweos__Prefix__c = 'Ms.',
			kweos__First_Name__c = 'FNN',
			kweos__Last_Name__c = 'LN',
			kweos__Address1__c = '12 Parkway Ct',
			kweos__Address2__c = '',
			kweos__City__c = 'Orinda',
			kweos__State__c = 'CA',
			kweos__Postal_Code__c = '94563',
			kweos__Issue__c = 'Gambling',
			kweos__Subject__c = 'Test Subject',
			kweos__Message__c = 'Test Message',
			kwac__Related_Action__c = newSRCampaign.Id,
			kwac__Source_Campaign__c = newNonSRCampaign.Id
			);

		//
		// Create a 2nd SierraRise Advocacy Action for the Contact
		//
		kweos__EOCS_Data__c newAdvocacyAction2 = new kweos__EOCS_Data__c(
			kwac__Contact__c = newContact.Id,
			kwac__Contact_Lead_Status__c = 'New Record Created',
			kweos__Email__c = 'test@test.com',
			kweos__Phone__c = '(415) 555-1212',
			kweos__Prefix__c = 'Ms.',
			kweos__First_Name__c = 'FNN',
			kweos__Last_Name__c = 'LN',
			kweos__Address1__c = '12 Parkway Ct',
			kweos__Address2__c = '',
			kweos__City__c = 'Orinda',
			kweos__State__c = 'CA',
			kweos__Postal_Code__c = '94563',
			kweos__Issue__c = 'Gambling',
			kweos__Subject__c = 'Test Subject 2',
			kweos__Message__c = 'Test Message 2',
			kwac__Related_Action__c = newSRCampaign.Id,
			kwac__Source_Campaign__c = newNonSRCampaign.Id
			);


    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        System.assertEquals(false, newContact.SierraRise_All__c);

		//
		// Insert the First Advocacy Action
		//
		System.debug('INSERTINGADVOCACY');		
		insert newAdvocacyAction;


    	List<rC_Bios__Preference__c> newPreferences = [
    			SELECT 	Id, 
    					Name,
    					Preference_Record_Type__c,
    					rC_Bios__Account__c,
    					rC_Bios__Contact__c,
    					rC_Bios__Active__c,
    					rC_Bios__Affiliation__c,
    					rC_Bios__Subcategory__c,
    					rC_Bios__Category__c,
    					rC_Bios__Value__c,
						rC_Bios__Code_Value__c
    				FROM rC_Bios__Preference__c 
    				WHERE rC_Bios__Contact__c =: newContact.Id];

		// Should have 2 preferences?      	
		System.debug('Preferences Found: ' + newPreferences.size());
//        System.assertEquals(2, newPreferences.size());

		// Iterate through each returned result
		for (rC_Bios__Preference__c thePref : newPreferences) {

			// DEBUG 
			System.debug('Pref.Name: ' +thePref.Name);
			System.debug('Pref.Preference_Record_Type__c: ' +thePref.Preference_Record_Type__c);
			System.debug('Pref.rC_Bios__Account__c: ' +thePref.rC_Bios__Account__c);
			System.debug('Pref.rC_Bios__Contact__c: ' +thePref.rC_Bios__Contact__c);
			System.debug('Pref.rC_Bios__Active__c: ' +thePref.rC_Bios__Active__c);
			System.debug('Pref.rC_Bios__Affiliation__c: ' +thePref.rC_Bios__Affiliation__c);
			System.debug('Pref.rC_Bios__Category__c: ' +thePref.rC_Bios__Category__c);
			System.debug('Pref.rC_Bios__Subcategory__c: ' +thePref.rC_Bios__Subcategory__c);
			System.debug('Pref.rC_Bios__Value__c: ' +thePref.rC_Bios__Value__c);
			System.debug('Pref.rC_Bios__Code_Value__c: ' +thePref.rC_Bios__Code_Value__c);
			
			// Find the SierraRise All
			if (thePref.rC_Bios__Subcategory__c == 'SierraRise All') {
				
				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Email Subscription',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise All',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(newContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SIERRARISE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SIERRARISE',thePref.rC_Bios__Code_Value__c);

			} else if (thePref.rC_Bios__Subcategory__c == 'SierraRise Exclusive') {

				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Classification',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise Exclusive',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(newContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SREXCLUSIVE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SREXCLUSIVE',thePref.rC_Bios__Code_Value__c);

			} else {
				// It should not find a SierraRise preference,
				//	so throw an error
				System.AssertEquals(true,false,'Preference found when not expected');
			}
		}

		// Confirm the User is now SierraRise
    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        System.assertEquals(true, newContact.SierraRise_All__c);
        
        // As well as being in SierraRise Exclusive
        System.assertEquals(true, newContact.SierraRise_Exclusive__c);

		//
		// Now insert the 2nd Advocacy Action
		//
		System.debug('INSERTINGADVOCACY2');		
		insert newAdvocacyAction2;


    	List<rC_Bios__Preference__c> newPreferences2 = [
    			SELECT 	Id, 
    					Name,
    					Preference_Record_Type__c,
    					rC_Bios__Account__c,
    					rC_Bios__Contact__c,
    					rC_Bios__Active__c,
    					rC_Bios__Affiliation__c,
    					rC_Bios__Subcategory__c,
    					rC_Bios__Category__c,
    					rC_Bios__Value__c,
						rC_Bios__Code_Value__c
    				FROM rC_Bios__Preference__c 
    				WHERE rC_Bios__Contact__c =: newContact.Id];

		// Should have 2 preferences?      	
		System.debug('2 Preferences Found: ' + newPreferences2.size());
        System.assertEquals(2, newPreferences2.size());

		// Iterate through each returned result
		for (rC_Bios__Preference__c thePref : newPreferences2) {

			// DEBUG 
			System.debug('Pref.Name: ' +thePref.Name);
			System.debug('Pref.Preference_Record_Type__c: ' +thePref.Preference_Record_Type__c);
			System.debug('Pref.rC_Bios__Account__c: ' +thePref.rC_Bios__Account__c);
			System.debug('Pref.rC_Bios__Contact__c: ' +thePref.rC_Bios__Contact__c);
			System.debug('Pref.rC_Bios__Active__c: ' +thePref.rC_Bios__Active__c);
			System.debug('Pref.rC_Bios__Affiliation__c: ' +thePref.rC_Bios__Affiliation__c);
			System.debug('Pref.rC_Bios__Category__c: ' +thePref.rC_Bios__Category__c);
			System.debug('Pref.rC_Bios__Subcategory__c: ' +thePref.rC_Bios__Subcategory__c);
			System.debug('Pref.rC_Bios__Value__c: ' +thePref.rC_Bios__Value__c);
			System.debug('Pref.rC_Bios__Code_Value__c: ' +thePref.rC_Bios__Code_Value__c);
			
			// Find the SierraRise All
			if (thePref.rC_Bios__Subcategory__c == 'SierraRise All') {
				
				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Email Subscription',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise All',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(newContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SIERRARISE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SIERRARISE',thePref.rC_Bios__Code_Value__c);

			} else if (thePref.rC_Bios__Subcategory__c == 'SierraRise Exclusive') {

				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Classification',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise Exclusive',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(newContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SREXCLUSIVE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SREXCLUSIVE',thePref.rC_Bios__Code_Value__c);

			} else {
				// It should not find a SierraRise preference,
				//	so throw an error
				System.AssertEquals(true,false,'SierraRise Preference found when not expected');
			}
			

			
			
			
		}

		// Confirm the User is STILL SierraRise
    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        System.assertEquals(true, newContact.SierraRise_All__c);
        
        // As well as STILL being in SierraRise Exclusive
        System.assertEquals(true, newContact.SierraRise_Exclusive__c);

		
		
    }




//
//
//
//
//  SIX - SierraRise w/ Donation
//
//
//
//
//

	//
	// Create a Non-SierraRise Account/Contact & Add a SR Donation
	//
	private static testMethod void aSierraRiseDonation(){

        //recordTypes();
        
        // Create the preference codes we will need:
        rC_Bios__Preference_Code__c newPrefCode1 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Email Subscription',rC_Bios__Subcategory__c = 'SierraRise All', rC_Bios__Code_Value__c = 'SIERRARISE');
        rC_Bios__Preference_Code__c newPrefCode2 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Classification',rC_Bios__Subcategory__c = 'SierraRise Exclusive',   rC_Bios__Code_Value__c = 'SREXCLUSIVE');
        insert newPrefCode1;
        insert newPrefCode2;
        
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
        Account newAccount = new Account(Name='Test HH');
        if(HouseholdAccountRecordType != null){
            newAccount.RecordTypeId = HouseholdAccountRecordType;
        }
        insert newAccount;

        // Create a contact with a Non-SierraRise Original Campaign
        Contact newContact = new Contact(
        							AccountId = newAccount.Id,
        							LastName = 'LN',
        							FirstName = 'FN',
        							Original_Campaign__c = newNonSRCampaign.Id
        							);
        if(HouseholdContactRecordType != null){
            newContact.RecordTypeId = HouseholdContactRecordType;
        }
        insert newContact;


        //
        // Confirm they're NOT a SierraRise All person
        //
    	newContact = [SELECT 	Id,
    							AccountId, 
    							Name, 
    							External_Id__c, 
    							SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id=:newContact.Id];

		// First confirm the Contact is not SierraRise nor SierraRise Exclusive
        System.assertEquals(false, newContact.SierraRise_All__c);
        System.assertEquals(false, newContact.SierraRise_Exclusive__c);


		// 
		// Create a SR Campaign
		//        
        Campaign newSRCampaign = new Campaign(
        						Name = 'TC1',
        						Description = 'Test SierraRise Campaign1',
        						Type = 'Promotion',
        						Status = 'Planned',
        						Program__c = newAttribute1.Id, 
        						Effort_Type__c = newAttribute4.Id);
    	insert newSRCampaign;
    	
		// Confirm the Campaigns are entered and are correctly attributed.
		// VB: was getting strange errors here, so it's a little overboard.    	
    	newSRCampaign = [SELECT Id, 
    					Name, 
    					Description, 
    					Program__r.Name, 
    					Program__r.Description__c, 
    					Program__r.External_Id__c, 
    					Effort_Type__r.Name, 
    					SierraRise_Campaign__c, 
    					Program__c, 
    					External_Id__c 
    				FROM Campaign 
    				WHERE Id=:newSRCampaign.Id];
    	System.assertEquals('TC1', 							newSRCampaign.Name);
    	System.assertEquals('Test SierraRise Campaign1', 	newSRCampaign.Description);
    	System.assertEquals('4', 							newSRCampaign.Program__r.Name);
    	System.assertEquals('Digital Innovation Email', 	newSRCampaign.Program__r.Description__c);
    	System.assertEquals('PG-4', 						newSRCampaign.Program__r.External_Id__c);
    	System.assertEquals('SR', 							newSRCampaign.Effort_Type__r.Name);

		// Confirm the Campaign is SierraRise
        System.assertEquals(true, 							newSRCampaign.SierraRise_Campaign__c);


		//
		// Create a SierraRise Donation for the Contact?  / Account?
		//

		// First create the GAU
		rC_Giving__GAU__c newGAU = new rC_Giving__GAU__c();
		newGAU.Name = 'Test Data GAU';
		newGAU.GivingType__c = 'Donations';
		newGAU.Recipient__c = 'Club';
		newGAU.FundType__c = 'Chapter Funds';
		insert newGAU;


		// Create the Donation Opportunity
		//		Assign onto Account ( setting SR status on account) and also Contact, to trigger preference
		Opportunity opp = new Opportunity();
		opp.name = 'Test Giving';
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		opp.rC_Giving__GAU__c = newGAU.Id;
		opp.AccountId = newAccount.Id;
		opp.Donor_Contact__c = newContact.Id;
		opp.CloseDate = system.today().addDays(3);
		opp.StageName = 'Completed';
		opp.rC_Giving__Giving_Years__c = 1;
		opp.rC_Giving__Giving_Frequency__c = 'One Payment';

		opp.rC_Giving__Closed_Amount__c = 1000;
		opp.rC_Giving__Current_Giving_Amount__c = 1000;
		opp.rC_Giving__Giving_Amount__c = 1000;
		//opp.rC_Giving__Projected_Amount__c = 1000;

		// Campaign is a SierraRise campaign  
		//opp.Campaign = newSRCampaign;
		opp.CampaignId = newSRCampaign.Id;

		// Confirm the Contact is still NOT SierraRise
    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        System.assertEquals(false, newContact.SierraRise_All__c);

		//
		// Salesforce SOQL Query Errors
		//
		Test.startTest();

		// Insert the Opportunity
		System.debug('INSERTINGDONATION A');		
		insert opp;

		Test.stopTest();

		// Look for the new preferences
    	List<rC_Bios__Preference__c> newPreferences = [
    			SELECT 	Id, 
    					Name,
    					Preference_Record_Type__c,
    					rC_Bios__Account__c,
    					rC_Bios__Contact__c,
    					rC_Bios__Active__c,
    					rC_Bios__Affiliation__c,
    					rC_Bios__Subcategory__c,
    					rC_Bios__Category__c,
    					rC_Bios__Value__c,
						rC_Bios__Code_Value__c
    				FROM rC_Bios__Preference__c 
    				WHERE rC_Bios__Contact__c =: newContact.Id];
    	
		System.debug('Preferences Found: ' + newPreferences.size());

		// Iterate through each returned result
		for (rC_Bios__Preference__c thePref : newPreferences) {

			// DEBUG 
			System.debug('Pref.Name: ' +thePref.Name);
			System.debug('Pref.Preference_Record_Type__c: ' +thePref.Preference_Record_Type__c);
			System.debug('Pref.rC_Bios__Account__c: ' +thePref.rC_Bios__Account__c);
			System.debug('Pref.rC_Bios__Contact__c: ' +thePref.rC_Bios__Contact__c);
			System.debug('Pref.rC_Bios__Active__c: ' +thePref.rC_Bios__Active__c);
			System.debug('Pref.rC_Bios__Affiliation__c: ' +thePref.rC_Bios__Affiliation__c);
			System.debug('Pref.rC_Bios__Category__c: ' +thePref.rC_Bios__Category__c);
			System.debug('Pref.rC_Bios__Subcategory__c: ' +thePref.rC_Bios__Subcategory__c);
			System.debug('Pref.rC_Bios__Value__c: ' +thePref.rC_Bios__Value__c);
			System.debug('Pref.rC_Bios__Code_Value__c: ' +thePref.rC_Bios__Code_Value__c);
			
			// Find the SierraRise All
			if (thePref.rC_Bios__Subcategory__c == 'SierraRise All') {
				
				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Email Subscription',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise All',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(newContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SIERRARISE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SIERRARISE',thePref.rC_Bios__Code_Value__c);

			} else if (thePref.rC_Bios__Subcategory__c == 'SierraRise Exclusive') {

				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Classification',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise Exclusive',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(newContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SREXCLUSIVE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SREXCLUSIVE',thePref.rC_Bios__Code_Value__c);

			} else {
				// It should not find a SierraRise preference,
				//	so throw an error
				System.AssertEquals(true,false,'SierraRise Preference found when not expected');
			}
		}
        System.assertEquals(2, newPreferences.size());



		// Confirm the User is now SierraRise
    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        System.assertEquals(true, newContact.SierraRise_All__c);
        
        // As well as being in SierraRise Exclusive
        System.assertEquals(true, newContact.SierraRise_Exclusive__c);
		
    }


	//
	// Create a Non-SierraRise Account/Contact & Add a non-SR Donation
	//
	private static testMethod void aNonSierraRiseDonation(){

        //recordTypes();
        
        // Create the preference codes we will need:
        rC_Bios__Preference_Code__c newPrefCode1 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Email Subscription',rC_Bios__Subcategory__c = 'SierraRise All', rC_Bios__Code_Value__c = 'SIERRARISE');
        rC_Bios__Preference_Code__c newPrefCode2 = new rC_Bios__Preference_Code__c(rC_Bios__Category__c='Classification',rC_Bios__Subcategory__c = 'SierraRise Exclusive',   rC_Bios__Code_Value__c = 'SREXCLUSIVE');
        insert newPrefCode1;
        insert newPrefCode2;
        
        // Need to create attributes for the test.
        //Attribute__c newAttribute1 = new Attribute__c(Name='4',Description__c = 'Digital Innovation Email', Attribute_Type__c = 'Program', External_ID__c = 'PG-4');
        Attribute__c newAttribute3 = new Attribute__c(Name='A',Description__c = 'John Muir Society',   Attribute_Type__c = 'Program', External_ID__c = 'PG-A');
	    Attribute__c newAttribute4 = new Attribute__c(Name='SR',Description__c = 'SIERRA RISE', Attribute_Type__c = 'Effort Type', External_ID__c = 'H1-SR');
        //insert newAttribute1;
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
    	System.assertEquals(false,newNonSRCampaign.SierraRise_Campaign__c);
    	

		// Create the Account
        Account newAccount = new Account(Name='Test HH');
        if(HouseholdAccountRecordType != null){
            newAccount.RecordTypeId = HouseholdAccountRecordType;
        }
        insert newAccount;

        // Create a contact with a Non-SierraRise Original Campaign
        Contact newContact = new Contact(
        							AccountId = newAccount.Id,
        							LastName = 'LN',
        							FirstName = 'FN',
        							Original_Campaign__c = newNonSRCampaign.Id
        							);
        if(HouseholdContactRecordType != null){
            newContact.RecordTypeId = HouseholdContactRecordType;
        }
        insert newContact;
    	newContact = [SELECT 	Id,
    							AccountId, 
    							Name, 
    							External_Id__c, 
    							SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id=:newContact.Id];

		// Confirm the Contact is not SierraRise nor SierraRise Exclusive
        System.assertEquals(false, newContact.SierraRise_All__c);
        System.assertEquals(false, newContact.SierraRise_Exclusive__c);

		//
		// Create a SierraRise Advocacy Action for the Contact
		//
		//
		// Create a SierraRise Donation for the Contact?  / Account?
		//

		// First create the GAU
		rC_Giving__GAU__c newGAU = new rC_Giving__GAU__c();
		newGAU.Name = 'Test Data GAU';
		newGAU.GivingType__c = 'Donations';
		newGAU.Recipient__c = 'Club';
		newGAU.FundType__c = 'Chapter Funds';
		insert newGAU;


		// Create the Donation Opportunity
		//		Assign the Account, as well as the Contact
		Opportunity opp = new Opportunity();
		opp.name = 'Test Giving';
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		opp.rC_Giving__GAU__c = newGAU.Id;
		opp.AccountId = newAccount.Id;
		opp.Donor_Contact__c = newContact.Id;
		opp.CloseDate = system.today().addDays(3);
		opp.StageName = 'Completed';
		opp.rC_Giving__Giving_Years__c = 1;
		opp.rC_Giving__Giving_Frequency__c = 'One Payment';

		opp.rC_Giving__Closed_Amount__c = 1000;
		opp.rC_Giving__Current_Giving_Amount__c = 1000;
		opp.rC_Giving__Giving_Amount__c = 1000;
		//opp.rC_Giving__Projected_Amount__c = 1000;

		// Campaign is a NON - SierraRise campaign  
		//opp.Campaign = newNonSRCampaign.Id; error
		//opp.Campaign = newNonSRCampaign;  // This doesn't seem to be 'sticking' 
		opp.CampaignId = newNonSRCampaign.Id;


		// Confirm the Contact is still NOT SierraRise
    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        System.assertEquals(false, newContact.SierraRise_All__c);

		// 
		//System.debug('Donation Campaign:' + opp.Campaign + ':');		
		//System.debug('Donation Campaign Id:' + opp.Campaign.Id + ':');		
		System.debug('Donation CampaignId:' + opp.CampaignId + ':');		// 		

		//
		// Salesforce SOQL Query Errors
		//
		Test.startTest();

		System.debug('INSERTINGDONATION B');		

		// Insert the Opportunity
		insert opp;

		Test.stopTest();


		// Look for the new preferences
    	List<rC_Bios__Preference__c> newPreferences = [
    			SELECT 	Id, 
    					Name,
    					Preference_Record_Type__c,
    					rC_Bios__Account__c,
    					rC_Bios__Contact__c,
    					rC_Bios__Active__c,
    					rC_Bios__Affiliation__c,
    					rC_Bios__Subcategory__c,
    					rC_Bios__Category__c,
    					rC_Bios__Value__c,
						rC_Bios__Code_Value__c
    				FROM rC_Bios__Preference__c 
    				WHERE rC_Bios__Contact__c =: newContact.Id];
    	
		System.debug('Preferences Found: ' + newPreferences.size());

		// Iterate through each returned result
		for (rC_Bios__Preference__c thePref : newPreferences) {

			// DEBUG 
			System.debug('Pref.Name: ' +thePref.Name);
			System.debug('Pref.Preference_Record_Type__c: ' +thePref.Preference_Record_Type__c);
			System.debug('Pref.rC_Bios__Account__c: ' +thePref.rC_Bios__Account__c);
			System.debug('Pref.rC_Bios__Contact__c: ' +thePref.rC_Bios__Contact__c);
			System.debug('Pref.rC_Bios__Active__c: ' +thePref.rC_Bios__Active__c);
			System.debug('Pref.rC_Bios__Affiliation__c: ' +thePref.rC_Bios__Affiliation__c);
			System.debug('Pref.rC_Bios__Category__c: ' +thePref.rC_Bios__Category__c);
			System.debug('Pref.rC_Bios__Subcategory__c: ' +thePref.rC_Bios__Subcategory__c);
			System.debug('Pref.rC_Bios__Value__c: ' +thePref.rC_Bios__Value__c);
			System.debug('Pref.rC_Bios__Code_Value__c: ' +thePref.rC_Bios__Code_Value__c);
			
			// Find the SierraRise All
			if (thePref.rC_Bios__Subcategory__c == 'SierraRise All') {
				
				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Email Subscription',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise All',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(newContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SIERRARISE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SIERRARISE',thePref.rC_Bios__Code_Value__c);

			} else if (thePref.rC_Bios__Subcategory__c == 'SierraRise Exclusive') {

				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Classification',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise Exclusive',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(newContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SREXCLUSIVE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SREXCLUSIVE',thePref.rC_Bios__Code_Value__c);

			} else {
				// It should not find a SierraRise preference,
				//	so throw an error
				System.AssertEquals(true,false,'Preference found when not expected');
			}
		}
		// Two preferences?
        System.assertEquals(0, newPreferences.size());



		// Confirm the User is now SierraRise
    	newContact = [SELECT 	Id, 
		    					SierraRise_All__c, 
    							SierraRise_Exclusive__c 
    					FROM Contact 
    					WHERE Id =: newContact.Id];
        
        // User should NOT be a SierraRise member
        System.assertEquals(false, newContact.SierraRise_All__c);
        
        // User should NOT be a SierraRise Exclusive 
        //		This non-state should be confirmed by the existence of an Inactive SierraRise Exclusive preference
        System.assertEquals(false, newContact.SierraRise_Exclusive__c);

        
		//
        // Confirm the Account is now marked as a Non-SierraRise Donation Account!
		//
    	newAccount = [SELECT 	Id, 
    							Non_SierraRise_Donor__c
    					FROM Account 
    					WHERE Id =: newAccount.Id];
        
        // Account should NOW be a Non-SierraRise Donor
        System.assertEquals(true, newAccount.Non_SierraRise_Donor__c);
        
		
		//
		// Look for the new preferences
    	List<rC_Bios__Preference__c> newAccountPreferences = [
    			SELECT 	Id, 
    					Name,
    					Preference_Record_Type__c,
    					rC_Bios__Account__c,
    					rC_Bios__Contact__c,
    					rC_Bios__Active__c,
    					rC_Bios__Affiliation__c,
    					rC_Bios__Subcategory__c,
    					rC_Bios__Category__c,
    					rC_Bios__Value__c,
						rC_Bios__Code_Value__c
    				FROM rC_Bios__Preference__c 
    				WHERE rC_Bios__Account__c =: newAccount.Id];
    	
		System.debug('Preferences Found: ' + newAccountPreferences.size());

		// Iterate through each returned result
		for (rC_Bios__Preference__c thePref : newAccountPreferences) {

			// DEBUG 
			System.debug('Pref.Name: ' +thePref.Name);
			System.debug('Pref.Preference_Record_Type__c: ' +thePref.Preference_Record_Type__c);
			System.debug('Pref.rC_Bios__Account__c: ' +thePref.rC_Bios__Account__c);
			System.debug('Pref.rC_Bios__Contact__c: ' +thePref.rC_Bios__Contact__c);
			System.debug('Pref.rC_Bios__Active__c: ' +thePref.rC_Bios__Active__c);
			System.debug('Pref.rC_Bios__Affiliation__c: ' +thePref.rC_Bios__Affiliation__c);
			System.debug('Pref.rC_Bios__Category__c: ' +thePref.rC_Bios__Category__c);
			System.debug('Pref.rC_Bios__Subcategory__c: ' +thePref.rC_Bios__Subcategory__c);
			System.debug('Pref.rC_Bios__Value__c: ' +thePref.rC_Bios__Value__c);
			System.debug('Pref.rC_Bios__Code_Value__c: ' +thePref.rC_Bios__Code_Value__c);
			
			// Find the SierraRise All
			if (thePref.rC_Bios__Subcategory__c == 'SierraRise All') {
				
				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Email Subscription',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise All',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(newContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SIERRARISE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SIERRARISE',thePref.rC_Bios__Code_Value__c);

			} else if (thePref.rC_Bios__Subcategory__c == 'SierraRise Exclusive') {

				System.assertEquals(true,thePref.rC_Bios__Active__c);
				System.assertEquals('Club-wide',thePref.Preference_Record_Type__c);
				System.assertEquals('Classification',thePref.rC_Bios__Category__c);
				System.assertEquals('SierraRise Exclusive',thePref.rC_Bios__Subcategory__c);
				System.assertEquals(null,thePref.rC_Bios__Account__c);
				System.assertEquals(newContact.Id,thePref.rC_Bios__Contact__c);
				System.assertEquals(null,thePref.rC_Bios__Affiliation__c);
				//System.assertEquals('SREXCLUSIVE',thePref.rC_Bios__Value__c);

// Currently Failing, have Case open with rC
				System.assertEquals('SREXCLUSIVE',thePref.rC_Bios__Code_Value__c);

			} else {
				// It should not find a SierraRise preference,
				//	so throw an error
				System.AssertEquals(true,false,'Preference found when not expected');
			}
		}
		// No preferences?
        System.assertEquals(0, newAccountPreferences.size());


        
		
    }







    //method to test Preference update
    private static testMethod void PreferenceModification(){
    	
    	/*
        recordTypes();

        Contact testContact1 = new Contact(LastName='Sierra1');
        Contact testContact2 = new Contact(LastName='Sierra2');
        if(HouseholdContactRecordType != null){
            testContact1.RecordTypeId = HouseholdContactRecordType;
            testContact2.RecordTypeId = HouseholdContactRecordType;
        }
        insert new list<Contact>{testContact1,testContact2};
        Account testAccount1 = new Account(Name='Sierra');
        Account testAccount2 = new Account(Name='Sierra');
        if(HouseholdAccountRecordType != null){
            testAccount1.RecordTypeId = HouseholdAccountRecordType;
            testAccount2.RecordTypeId = HouseholdAccountRecordType;
        }
        insert new list<Account>{testAccount1,testAccount2};
        rC_Bios__Preference__c Preference1 = createPreference(testContact1.Id,testAccount1.Id,'Major Gift Donor');
        rC_Bios__Preference__c Preference2 = createPreference(testContact1.Id,testAccount1.Id,'Major Gift Donor Prospect');
        rC_Bios__Preference__c Preference3 = createPreference(testContact1.Id,testAccount1.Id,'Summit Circle Member');	// Changed Donor to Member
        rC_Bios__Preference__c Preference4 = createPreference(testContact1.Id,testAccount1.Id,'Planned Gift Donor');
        rC_Bios__Preference__c Preference5 = createPreference(testContact1.Id,testAccount1.Id,'Planned Gift Major Prospect');
        rC_Bios__Preference__c Preference6 = createPreference(testContact1.Id,testAccount1.Id,'John Muir Society');		// WARNING: This is wrong.
        insert new list<rC_Bios__Preference__c>{Preference1,Preference2,Preference3,Preference4,Preference5,Preference6};
        Preference1.rC_Bios__Contact__c= testContact2.Id;
        Preference1.rC_Bios__Account__c= testAccount2.Id;
        Preference1.rC_Bios__Active__c = false;
        update Preference1;
        testAccount1 = [SELECT Major_Donor__c,Major_Donor_Prospect__c FROM Account WHERE ID =: testAccount1.Id];
        testAccount2 = [SELECT Major_Donor__c,Major_Donor_Prospect__c FROM Account WHERE ID =: testAccount2.Id];
        system.assert(!testAccount1.Major_Donor__c);
        system.assert(!testAccount2.Major_Donor__c);
        
        testAccount2.Major_Donor__c = true;
        update testAccount2;
        
        testContact2.Major_Donor__c = true;
        update testContact2;

        delete Preference1;
        undelete Preference1;
        */
    }

    private static rC_Bios__Preference__c createPreference(ID contactId,Id accountId, String subcategory){

        rC_Bios__Preference__c Preference = new rC_Bios__Preference__c(rC_Bios__Contact__c = contactId,
                                                                      // rC_Bios__Account__c = accountId,
                                                                       rC_Bios__Subcategory__c = subcategory);
        return Preference;
    }

}