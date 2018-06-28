@isTest
private class BatchUploadBeforeInsertUpdateTest {
    static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void myUnitTest() {
    	List<Account> accountList = new List<Account>();
		Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		Account account2 = new Account(
            Name='Account2',
            RecordTypeId = accountHouseholdTypeId,
            Merge_Survivor__c = account1.Id 
		);
		insert account2;
		
		Contact contact1 = new Contact(
			FirstName = 'Test',
			LastName = 'Contact1',
			RecordTypeId = contactHouseholdTypeId,
			AccountId = account1.Id
		);
		insert contact1;
		Contact contact2 = new Contact(
			FirstName = 'Test',
			LastName = 'Contact2',
			RecordTypeId = contactHouseholdTypeId,
			AccountId = account2.Id,
            Merge_Survivor__c = contact1.Id 
		);
		insert contact2;
		rC_Connect__Batch_Upload__c bu = new rC_Connect__Batch_Upload__c(
			rC_Connect__Batch_Upload_Account_Matched__c = account2.Id,
			rC_Connect__Batch_Upload_Contact_1_Matched__c = contact2.Id
		);
		insert bu;

        rC_Connect__Batch_Upload__c buTest = [
        	select 
        		rC_Connect__Batch_Upload_Account_Matched__c,
        		rC_Connect__Batch_Upload_Contact_1_Matched__c
        	from rC_Connect__Batch_Upload__c
        	where Id = :bu.Id
        ];
        System.assertEquals(null, buTest.rC_Connect__Batch_Upload_Account_Matched__c);
        System.assertEquals(null, buTest.rC_Connect__Batch_Upload_Contact_1_Matched__c);
        
        BatchUploadBeforeInsertUpdate.process(new List<rC_Connect__Batch_Upload__c>{bu});
    }
}