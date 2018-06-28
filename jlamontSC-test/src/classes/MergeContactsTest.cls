@IsTest
public with sharing class MergeContactsTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Account account1, account2, account3;
    static Contact contact1, contact2, contact3;
    static List<Account> accountList = new List<Account>();
    static List<Contact> contactList = new List<Contact>();

    static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    }

    @IsTest
    static void testMergeContacts() {
        account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
        );
        account2 = new Account(
            Name='Account2',
            RecordTypeId = accountHouseholdTypeId
        );
        account3 = new Account(
            Name='Account3',
            RecordTypeId = accountHouseholdTypeId
        );
        accountList.add(account1);
        accountList.add(account2);
        accountList.add(account3);
        insert accountList;
        
        contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            RecordTypeId = contactHouseholdTypeId
        );  
        contact2 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact2',
            RecordTypeId = contactHouseholdTypeId
        );
        contact3 = new Contact(
            AccountId = account3.Id,
            FirstName = 'Test',
            LastName = 'Contact3',
            RecordTypeId = contactHouseholdTypeId
        );
        contactList.add(contact1);
        contactList.add(contact2);
        contactList.add(contact3);
        insert contactList;

        System.debug('contact1.Id:' + contact1.Id);
        System.debug('contact2.Id:' + contact2.Id);
        System.debug('contact3.Id:' + contact3.Id);
        
        List<Merge_Request__c> requestList = new List<Merge_Request__c>();
        
        Merge_Request__c request1 = new Merge_Request__c(
            Retained_Contact__c = contact1.Id, 
            Retained_Account__c = account1.Id, 
            Previous_Contact__c = contact2.Id, 
            Previous_Account__c = account1.Id           
        );
        Merge_Request__c request2 = new Merge_Request__c(
            Retained_Account__c = account3.Id, 
            Previous_Contact__c = contact3.Id, 
            Previous_Account__c = account3.Id           
        );
        
        requestList.add(request1);
        requestList.add(request2);
        insert requestList;
        
        Test.startTest();
        MergeContacts.processContacts(requestList);
        Test.stopTest();
        
        List<Merge_Request__c> processedMerges = new List<Merge_Request__c>([
            SELECT Id, Error_Message__c, Last_Step_Completed__c, Date_Last_Step_Completed__c FROM Merge_Request__c
        ]); 
        
        for(Merge_Request__c req : processedMerges) {
            System.assertEquals(MergeProcessor.mergeContactsStep, req.Last_Step_Completed__c);
            System.assert(req.Date_Last_Step_Completed__c != null);
        }
        
        List<Contact> processedContacts = new List<Contact>([
            SELECT Id, LastName, FirstName FROM Contact
        ]);
        
        for(Contact ctct : processedContacts) {
            System.assertEquals(contact1.Id, ctct.Id);
        }
        System.assert(processedContacts.size() == 1);
    }
}