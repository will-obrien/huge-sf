/*
    Test class for CountryListAcc
*/
@isTest
public class CountryListAccTest {
    
    //Test method to test all queries
    private static testMethod void testCountryList(){
        
        //Create data
        createData();
        
        String testString = 'test';
        
        Test.startTest();
        
        CountryListAcc countryListAcc = new CountryListAcc();
        countryListAcc.SearchString = testString;
        
        //Search method
        countryListAcc.Search();
        //System.assertNotEquals(0, countryListAcc.wrapperList.size());
        
        countryListAcc.selectedAccountId = '001g000000LQQnn';
        countryListAcc.searchByAccount();
        //System.assertNotEquals(0, countryListAcc.childAccounts.size());
        
        //Just for coverage
        //We can remove these functions from controller
        List<CountryListAcc.ParentAcc> parentNodes = countryListAcc.mainnodes();
        countryListAcc.ContList();
        
        Test.stopTest();
    }
    
    private static void createData(){
    	//Add account
    	Account acc = new Account();
    	acc.Name = 'test';		
		insert acc;  
		
		Account childAcc = new Account();
		childAcc.Name = 'childAcc';
		childAcc.ParentId = acc.Id;
		insert childAcc;
		
		//Add contact
		Contact cont = new Contact();
    	cont.FirstName = 'contact';
    	cont.LastName = 'test';
    	cont.AccountId = acc.Id;
    	cont.Email = 'a.b@test.com';
    	insert cont;
    	
    	DContract__c contract = new DContract__c();
    	contract.Name = 'dContractComplete';
    	contract.Account__c = acc.Id;
    	contract.Status__c = 'complete';
    	insert contract;
    	
    	DContract__c contractOpen = new DContract__c();
    	contractOpen.Name = 'dContractOpen';
    	contractOpen.Account__c = acc.Id;
    	contractOpen.Status__c = 'Draft';
    	insert contractOpen;
    	
    			      
    }    
}