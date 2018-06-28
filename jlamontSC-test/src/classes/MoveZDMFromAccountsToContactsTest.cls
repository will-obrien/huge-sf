@isTest
private class MoveZDMFromAccountsToContactsTest {

    static testMethod void myUnitTest() {
    	List<Account> accountList = new List<Account>();
    	Account account1 = new Account(
    		Name = 'Test Account1',
			kwzd__KW_CountyCode__c = 'TestCountyCode1',
			kwzd__KW_CountyDistrict__c = 'TestCountyDistrict1',
			kwzd__KW_CountyDistrictDesc__c = 'TestCountyDistrictDesc1'
    	);
    	accountList.add(account1);
    	Account account2 = new Account(
    		Name = 'Test Account2',
			kwzd__KW_CountyCode__c = 'TestCountyCode2',
			kwzd__KW_CountyDistrict__c = 'TestCountyDistrict2',
			kwzd__KW_CountyDistrictDesc__c = 'TestCountyDistrictDesc2'
    	);
    	accountList.add(account2);
    	insert accountList;
    	
    	Contact contact1 = new Contact(
    		AccountId = account1.Id,
    		FirstName = 'Test',
    		LastName = 'Contact'
    	);
    	insert contact1;
		
		Contact updatedContact = [
			select 
				kwzd__KW_CountyCode__c,
				kwzd__KW_CountyDistrict__c,
				kwzd__KW_CountyDistrictDesc__c
			from Contact
			where id = :contact1.id
		];
		
		System.assertEquals(account1.kwzd__KW_CountyCode__c, updatedContact.kwzd__KW_CountyCode__c);    	
		System.assertEquals(account1.kwzd__KW_CountyDistrict__c, updatedContact.kwzd__KW_CountyDistrict__c);    	
		System.assertEquals(account1.kwzd__KW_CountyDistrictDesc__c, updatedContact.kwzd__KW_CountyDistrictDesc__c);
		
		contact1.AccountId = account2.Id;
		update contact1;
		
		updatedContact = [
			select 
				kwzd__KW_CountyCode__c,
				kwzd__KW_CountyDistrict__c,
				kwzd__KW_CountyDistrictDesc__c
			from Contact
			where id = :contact1.id
		];

		System.assertEquals(account2.kwzd__KW_CountyCode__c, updatedContact.kwzd__KW_CountyCode__c);    	
		System.assertEquals(account2.kwzd__KW_CountyDistrict__c, updatedContact.kwzd__KW_CountyDistrict__c);    	
		System.assertEquals(account2.kwzd__KW_CountyDistrictDesc__c, updatedContact.kwzd__KW_CountyDistrictDesc__c);
		 	
    }
}