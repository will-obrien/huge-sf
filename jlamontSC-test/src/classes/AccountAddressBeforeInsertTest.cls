//Replaced with AccountAddressTriggerBeforeTest
@IsTest
public with sharing class AccountAddressBeforeInsertTest {
/*
	static Id accountHouseholdTypeId;
	static Account account1;

	static {
		accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	}
	@IsTest
	public static void testAccountAddressInsert() {
		account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
		insert account1;
		
		rC_Bios__Account_Address__c addr1 = new  rC_Bios__Account_Address__c(
			rC_Bios__Account__c = account1.Id,
			rC_Bios__Type__c = 'Home',
			rC_Bios__Original_Street_Line_1__c = '1149 Dartmouth St',
			rC_Bios__Original_City__c = 'Albany',
			rC_Bios__Original_State__c = 'CA',
			rC_Bios__Original_Postal_Code__c = '94706' 
		);
		insert addr1;

		rC_Bios__Account_Address__c addr2 = new  rC_Bios__Account_Address__c(
			rC_Bios__Account__c = account1.Id,
			rC_Bios__Type__c = 'Home',
			rC_Bios__Original_Street_Line_1__c = '85 Second St',
			rC_Bios__Original_City__c = 'San Francisco',
			rC_Bios__Original_State__c = 'CA',
			rC_Bios__Original_Postal_Code__c = '94105' 
		);
		Database.SaveResult sr = Database.insert(addr2, false);
		System.assertEquals(false, sr.isSuccess());
		System.assertEquals('Address Type already exists for Account', sr.getErrors()[0].getMessage());
		
		addr1.rC_Bios__Type__c = 'Work';
		sr = Database.update(addr1, false);
		System.assertEquals(false, sr.isSuccess());
		System.assertEquals('Address Type may not be Changed', sr.getErrors()[0].getMessage());
	}
*/ 
}