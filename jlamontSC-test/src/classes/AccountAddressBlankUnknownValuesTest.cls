@isTest
private class AccountAddressBlankUnknownValuesTest {
	static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void myUnitTest() {
		Account account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
		insert account1;
		
		rC_Bios__Account_Address__c addr1 =
			new rC_Bios__Account_Address__c(
				rC_Bios__Account__c = account1.Id,
				rC_Bios__Original_Street_Line_1__c = 'Unknown',
				rC_Bios__Original_City__c = 'Unknown',
				rC_Bios__Original_State__c = 'UN',
				rC_Bios__Original_Postal_Code__c = 'Unknown'
			);
		insert addr1;
		
		rC_Bios__Account_Address__c testAddr = [
			select
				 rC_Bios__Original_Street_Line_1__c,
				 rC_Bios__Original_City__c,
				 rC_Bios__Original_State__c,
				 rC_Bios__Original_Postal_Code__c
			from rC_Bios__Account_Address__c
			where id=:addr1.Id
		];
		
		System.assertEquals(null, testAddr.rC_Bios__Original_Street_Line_1__c);
		System.assertEquals(null, testAddr.rC_Bios__Original_City__c);
		System.assertEquals(null, testAddr.rC_Bios__Original_State__c);
		System.assertEquals(null, testAddr.rC_Bios__Original_Postal_Code__c);
    }
}