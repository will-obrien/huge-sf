@IsTest
public with sharing class MergePreferencesTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id preferenceNationalTypeId;
    static Account account1, account2, account3, account4, account5, account6;
    static Contact contact1, contact2, contact3, contact4, contact5, contact6, contact7;
    static rC_Bios__Preference__c preference1, preference2, preference3, preference4, preference5, preference6;

    static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        preferenceNationalTypeId = Schema.Sobjecttype.rC_Bios__Preference__c.getRecordTypeInfosByName().get('Club-wide').getRecordTypeId();
    }
    
    @IsTest
    static void testMergePreferences() {
        setupAccounts();
        setupContacts();
        List<rC_Bios__Preference__c> preferenceList = new List<rC_Bios__Preference__c>();
        preference1 = new rC_Bios__Preference__c (
            rC_Bios__Contact__c = contact1.Id,
            rC_Bios__Account__c = account1.Id,
            RecordTypeId = preferenceNationalTypeId,
            rC_Bios__Code_Value__c = 'NONATFRMAIL',
            rC_Bios__Category__c = 'Contact Preference',
            rC_Bios__Subcategory__c = 'No Fundraising Mail - Nat'
        );
        preferenceList.add(preference1);

        preference2 = new rC_Bios__Preference__c (
            rC_Bios__Contact__c = contact1.Id,
            rC_Bios__Account__c = account1.Id,
            RecordTypeId = preferenceNationalTypeId,
            rC_Bios__Code_Value__c = '0NATFRMAIL',  
            rC_Bios__Category__c = 'Contact Preference',
            rC_Bios__Subcategory__c = 'No Fundraising Mail This Year - Nat'
        );
        preferenceList.add(preference2);

        preference3 = new rC_Bios__Preference__c (
            rC_Bios__Contact__c = contact2.Id,
            rC_Bios__Account__c = account2.Id,
            RecordTypeId = preferenceNationalTypeId,
            rC_Bios__Code_Value__c = 'NONATFRMAIL',  
            rC_Bios__Category__c = 'Contact Preference',
            rC_Bios__Subcategory__c = 'No Fundraising Mail - Nat'
        );
        preferenceList.add(preference3);
        
        preference4 = new rC_Bios__Preference__c (
            rC_Bios__Contact__c = contact3.Id,
            rC_Bios__Account__c = account3.Id,
            RecordTypeId = preferenceNationalTypeId,
            rC_Bios__Code_Value__c = '0NATFRMAIL',  
            rC_Bios__Category__c = 'Contact Preference',
            rC_Bios__Subcategory__c = 'No Fundraising Mail This Year - Nat'
        );
        preferenceList.add(preference4);

        preference5 = new rC_Bios__Preference__c (
            rC_Bios__Contact__c = contact3.Id,
            rC_Bios__Account__c = account3.Id,
            RecordTypeId = preferenceNationalTypeId,
            rC_Bios__Code_Value__c = 'NONATFRMAIL',  
            rC_Bios__Category__c = 'Contact Preference',
            rC_Bios__Subcategory__c = 'No Fundraising Mail - Nat'
        );
        preferenceList.add(preference5);

        preference6 = new rC_Bios__Preference__c (
            rC_Bios__Contact__c = contact4.Id,
            rC_Bios__Account__c = account4.Id,
            RecordTypeId = preferenceNationalTypeId,
            rC_Bios__Code_Value__c = 'NONATFRMAIL',  
            rC_Bios__Category__c = 'Contact Preference',
            rC_Bios__Subcategory__c = 'No Fundraising Mail - Nat'
        );
        preferenceList.add(preference6);
        
        insert preferenceList;
        
        List<rC_Bios__Preference__c> testPreferences = new List<rC_Bios__Preference__c> ([
            SELECT Id, rC_Bios__Account__c, RecordTypeId, rC_Bios__Code_Value__c, rC_Bios__Category__c, rC_Bios__Subcategory__c
            FROM rC_Bios__Preference__c
        ]);
        
        for(rC_Bios__Preference__c pref : testPreferences) {
        	System.debug('PreferenceId:' + pref.Id);
        	System.debug('RecordTypeId:' + pref.RecordTypeId);
        	System.debug('PreferenceAccount:' + pref.rC_Bios__Account__c);
        	System.debug('Code:' + pref.rC_Bios__Code_Value__c);
        	System.debug('Category:' + pref.rC_Bios__Category__c);
        	System.debug('Subcatagory:' + pref.rC_Bios__Subcategory__c);
        }
        

        Merge_Request__c request1 = new Merge_Request__c(
            Retained_Contact__c = contact2.Id, 
            Retained_Account__c = account2.Id, 
            Previous_Contact__c = contact1.Id, 
            Previous_Account__c = account1.Id           
        );
        Merge_Request__c request2 = new Merge_Request__c(
            Retained_Contact__c = contact4.Id, 
            Retained_Account__c = account4.Id, 
            Previous_Contact__c = contact3.Id, 
            Previous_Account__c = account3.Id           
        );

        List<Merge_Request__c> mergeRequestList = new List<Merge_Request__c>();
        mergeRequestList.add(request1);
        mergeRequestList.add(request2);
        insert mergeRequestList;
        
        Test.startTest();
        MergePreferences.processPreferences(mergeRequestList);
        Test.stopTest();
        
        List<rC_Bios__Preference__c> savedPreferences = new List<rC_Bios__Preference__c> ([
            SELECT Id, rC_Bios__Account__c, rC_Bios__Code_Value__c
            FROM rC_Bios__Preference__c
        ]);
        
        for(rC_Bios__Preference__c pref : savedPreferences) {
            System.assertNotEquals(preference1.Id, pref.Id);
            System.assertNotEquals(preference5.Id, pref.Id);
            if(pref.Id == preference2.Id) {
                System.assertEquals(account2.Id, pref.rC_Bios__Account__c);
            }
            else if(pref.Id == preference4.Id) {
            	System.assertEquals(account4.Id, pref.rc_Bios__Account__c);
            }
        }
        
        
    }
    static void setupAccounts() {
        account1 = 
            new Account(
                Name='Account1',
                RecordTypeId = accountHouseholdTypeId
            );
        account2 = 
            new Account(
                Name='Account2',
                RecordTypeId = accountHouseholdTypeId
            );
        account3 = 
            new Account(
                Name='Account3',
                RecordTypeId = accountHouseholdTypeId
            );
        account4 = 
            new Account(
                Name='Account4',
                RecordTypeId = accountHouseholdTypeId
            );
        account5 = 
            new Account(
                Name='Account5',
                RecordTypeId = accountHouseholdTypeId
            );
        List<Account> accountList = new List<Account>();
        accountList.add(account1);
        accountList.add(account2);
        accountList.add(account3);
        accountList.add(account4);
        accountList.add(account5);
        insert accountList;
        System.debug('account1:' + account1.Id);
        System.debug('account2:' + account2.Id);
        System.debug('account3:' + account3.Id);
        System.debug('account4:' + account4.Id);
	}
    static void setupContacts() {
        contact1 =
            new Contact(
                AccountId = account1.Id,
                FirstName = 'Test',
                LastName = 'Contact1',
                RecordTypeId = contactHouseholdTypeId
            );  
        contact2 =
            new Contact(
                AccountId = account2.Id,
                FirstName = 'Test',
                LastName = 'Contact2',
                RecordTypeId = contactHouseholdTypeId
            );
        contact3 =
            new Contact(
                AccountId = account2.Id,
                FirstName = 'Test',
                LastName = 'Contact3',
                RecordTypeId = contactHouseholdTypeId
            );
        contact4 =
            new Contact(
                AccountId = account4.Id,
                FirstName = 'Test',
                LastName = 'Contact4',
                RecordTypeId = contactHouseholdTypeId
            );
        contact5 =
            new Contact(
                AccountId = account5.Id,
                FirstName = 'Test',
                LastName = 'Contact5',
                RecordTypeId = contactHouseholdTypeId
            );
        List<Contact> contactList = new List<Contact>();
        contactList.add(contact1);
        contactList.add(contact2);
        contactList.add(contact3);
        contactList.add(contact4);
        contactList.add(contact5);
        insert contactList;
    }
}