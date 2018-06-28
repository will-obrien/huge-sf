@isTest
private class SetDistrictChangedFlagTest {
    static Id householdRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void myUnitTest() {
		Account account1, account2;
		List<Account> accounts = new List<Account>();
		
		account1 = new Account(Name='Account1', RecordTypeId = householdRTId, DistrictChanged__c = false);
		account2 = new Account(Name='Account2', RecordTypeId = householdRTId, DistrictChanged__c = false);
		accounts.add(account1);
		accounts.add(account2);
		insert accounts;
		
		Test.startTest();
		Database.executeBatch(new SetDistrictChangedFlag());
		Test.stopTest();
		
		List<Account> accountList = [SELECT Id, DistrictChanged__c FROM Account];
		
		System.assertEquals(2, accountList.size());
		for(Account acct : accountList) {
			System.assertEquals(true, acct.DistrictChanged__c);
		}
    }
}