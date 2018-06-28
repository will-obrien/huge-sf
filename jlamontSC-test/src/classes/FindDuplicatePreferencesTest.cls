@isTest
public with sharing class FindDuplicatePreferencesTest {
	// CRON expression: midnight on March 15.
	// Because this is a test, job executes
	// immediately after Test.stopTest().
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testMethod void myUnitTest() {
		Account account1, account2, account3, account4;
		Contact contact1, contact2, contact3;
		List<Account> accounts = new List<Account>();
		List<Contact> contacts = new List<Contact>();
		
		account1 = new Account(Name='Account1');
		account2 = new Account(Name='Account2');
		account3 = new Account(Name='Account3');
		account4 = new Account(Name='Account4');
		accounts.add(account1);
		accounts.add(account2);
		accounts.add(account3);
		accounts.add(account4);
		insert accounts;
		
		contact1 = new Contact(AccountId=account1.Id, LastName='Contact1');
		contact2 = new Contact(AccountId=account2.Id, LastName='Contact2');
		contact3 = new Contact(AccountId=account3.Id, LastName='Contact3');
		contacts.add(contact1);
		contacts.add(contact2);
		contacts.add(contact3);
		insert contacts;
		
		List<rC_Bios__Preference__c> prefList = new List<rC_Bios__Preference__c>();
		
		rC_Bios__Preference__c pref1 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = account1.Id,
			rC_Bios__Contact__c = contact1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'CAT1',
			rC_Bios__Subcategory__c = 'SUB1'
		);
		prefList.add(pref1);
		
		rC_Bios__Preference__c pref2 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = account1.Id,
			rC_Bios__Contact__c = contact1.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'CAT1',
			rC_Bios__Subcategory__c = 'SUB1'
		);
		prefList.add(pref2);
		
		rC_Bios__Preference__c pref3 = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact2.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'CAT1',
			rC_Bios__Subcategory__c = 'SUB1'
		);
		prefList.add(pref3);

		rC_Bios__Preference__c pref4 = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact2.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'CAT1',
			rC_Bios__Subcategory__c = 'SUB1'
		);
		prefList.add(pref4);

		rC_Bios__Preference__c pref5 = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact2.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'CAT2',
			rC_Bios__Subcategory__c = 'SUB1'
		);
		prefList.add(pref5);

		rC_Bios__Preference__c pref5a = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact2.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'CAT2',
			rC_Bios__Subcategory__c = 'SUB2'
		);
		prefList.add(pref5a);

		rC_Bios__Preference__c pref6 = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact3.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'CAT2',
			rC_Bios__Subcategory__c = 'SUB1'
		);
		prefList.add(pref6);

		rC_Bios__Preference__c pref7 = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact3.Id,
			rC_Bios__Active__c = true,
			rC_Bios__Category__c = 'CAT2',
			rC_Bios__Subcategory__c = 'SUB1'
		);
		prefList.add(pref7);

		insert prefList;
		
		System.debug('pref1:' + pref1);
		System.debug('pref2:' + pref2);
		System.debug('pref3:' + pref3);
		System.debug('pref4:' + pref4);
		System.debug('pref5:' + pref5);
		System.debug('pref6:' + pref6);
		System.debug('pref7:' + pref7);
		
		Test.startTest();
		Database.executeBatch(new FindDuplicatePreferences());
		Test.stopTest();
				
		Set<Id> idSet = new Set<Id>();
		List<rC_Bios__Preference__c> allPrefs = [
			select Id, rC_Bios__Active__c from rC_Bios__Preference__c
		];
		System.debug('allPrefs:' + allPrefs);
		for(rC_Bios__Preference__c pref : allPrefs) {
			idSet.add(pref.Id);
		}
		System.assertEquals(false, idSet.contains(pref2.Id));
		System.assertEquals(false, idSet.contains(pref4.Id));
		System.assertEquals(5, allPrefs.size());
    }
    static testMethod void testSchedulable() {
		Test.startTest();
	    // Schedule the test job
		String jobId = System.schedule('FindDuplicatePreferencesTest',
                        CRON_EXP, 
                        new FindDuplicatePreferences());
      	// Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         	NextFireTime
         	FROM CronTrigger WHERE id = :jobId];

      	// Verify the expressions are the same
      	System.assertEquals(CRON_EXP, 
         	ct.CronExpression);

      	// Verify the job has not run
      	System.assertEquals(0, ct.TimesTriggered);

      	// Verify the next time the job will run
      	System.assertEquals('2022-03-15 00:00:00', 
         	String.valueOf(ct.NextFireTime));
      	Test.stopTest();
    }
}