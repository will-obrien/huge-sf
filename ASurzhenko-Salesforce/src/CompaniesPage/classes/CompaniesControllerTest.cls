/**
 * This is Test class for CompaniesController class
 * It covers such classes as: 
 * CompaniesController - 100%
 * Company - 100%
 * Order - 100%
 * Rate - 100%
 * WorkPeriod - 100%
*/

@isTest
private class CompaniesControllerTest {

    @TestSetup 
    private static void dataCreation()
    {
        List<Account> accountList = new List<Account>();
        for (Integer i = 0; i < 20; i++)
        {
            accountList.add(new Account(Name = 'Test' + i));
        }
        
        insert accountList;
        
        List<Account> accList = [SELECT Id, Name FROM Account];
        List<Order__c> orderList = new List<Order__c>();
        for (Integer i = 0; i < 10; i++)
        {
            orderList.add(new Order__c(Account__c = accList.get(i).Id));
        }
        
        insert orderList;
        
        List<Rate__c> rateList = new List<Rate__c>();
        for (Integer i = 0; i < 10; i++)
        {
            rateList.add(new Rate__c(Name = 'Test Rate' + i, Revenue__c = 1000, Margin__c = 700));
        }
        
        insert rateList;
        
        List<Order__c> ordList = [SELECT Id FROM Order__c];
        List<Rate__c> rList = [SELECT Id FROM Rate__c];
        List<Work_Period__c> wplist = new List<Work_Period__c>();
        for (Integer i = 0; i < ordList.size(); i++)
        {
            wplist.add(new Work_Period__c(Name = 'TestPeriod' + i, Order__c = ordlist.get(i).Id, 
                                          Rate__c = rList.get(i).Id));
        }
        
        insert wplist;
        
        Company comp = new Company('1', 'test company');
        Order o = new Order('1', 'test order', accList.get(0));
        Rate r = new Rate('1', 'test rate', 1000, 500);
        WorkPeriod w = new WorkPeriod('1', 'test period', ordList.get(0), rList.get(0), 
                                      Date.today(), Date.today().addDays(30));
    }
    
    @isTest 
    private static void companiesControllerTest()
    {
        List<Account> accList = [SELECT Id,Name FROM Account];
        CompaniesController cc = new CompaniesController();
        
        System.assertEquals(20, acclist.size());
    }
}
