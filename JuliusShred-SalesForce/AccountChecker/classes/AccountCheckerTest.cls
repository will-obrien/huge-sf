/**
* this test covers the AccountCheckerController
*/
@isTest
public class AccountCheckerTest 
{
    //creating data
    private static testMethod void setData() 
    {
        List<Account> companies = new List<Account>();

        Account microsoft = new Account(Name = 'Microsoft');
        Account apple = new Account(Name = 'Apple');   
        Account asus = new Account(Name = 'Asus');
        Account lg = new Account(Name = 'LG'); 
        companies.add(microsoft);
        companies.add(apple);
        companies.add(asus);
        companies.add(lg);
        insert companies;
    }
    //testing the work of controller if none of accounts were selected
    static testMethod void noAccountsSelectedTest() 
    {
        AccountCheckerTest.setData();
        List<Account> accountsList = [SELECT Id, Name, Phone, Description 
                                      FROM Account];
        
        Test.startTest();
        	AccountCheckerController accCheckerCtrl = new AccountCheckerController();
        	accCheckerCtrl.getCheckedRecords();
        Test.stopTest();

        system.assertEquals(accountsList.size(), accCheckerCtrl.accountsList.size(), 'Error: test and controller accountsList lists don\'t match');       
        system.assertEquals(0, accCheckerCtrl.checkedAccs.size(), 'Error: List size must be 0.'); 
    }
    //testing the work of controller with one account selected
    static testMethod void oneAccountSelectedTest() 
    {
        AccountCheckerTest.setData();
        List<Account> accountsList = [SELECT Id, Name, Phone, Description 
                                      FROM Account];
        
        Test.startTest();
        	AccountCheckerController accCheckerCtrl = new AccountCheckerController();
        	accCheckerCtrl.accountsList[0].isSelected = true;
        	accCheckerCtrl.getCheckedRecords();
        Test.stopTest();

        system.assertEquals(accountsList.size(), accCheckerCtrl.accountsList.size(), 'Error: test and controller accountsList lists don\'t match');       
        system.assertEquals(1, accCheckerCtrl.checkedAccs.size(), 'Error: List size must be 1.'); 
    }
    //testing the work of controller with all accounts selected
    static testMethod void allAccountsSelectedTest() 
    {
        AccountCheckerTest.setData();
        List<Account> accountsList = [SELECT Id, Name, Phone, Description 
                                      FROM Account];
        
        Test.startTest();
        	AccountCheckerController accCheckerCtrl = new AccountCheckerController();
        	for (Integer i = 0; i < accCheckerCtrl.accountsList.size(); i++)
                {
                    accCheckerCtrl.accountsList[i].isSelected = true;
                }
        	accCheckerCtrl.getCheckedRecords();
        Test.stopTest();

        system.assertEquals(accountsList.size(), accCheckerCtrl.accountsList.size(), 'Error: test and controller accountsList lists don\'t match');       
        system.assertEquals(accountsList.size(), accCheckerCtrl.checkedAccs.size(), 'Error: accountsList and checkedAccs lists don\'t match'); 
    }
}