/**
* this test covers the WorkPeriodController
*/
@isTest
public class WorkPeriodsTest 
{
    //creating data
    private static testMethod void setData()
    {
        List<Account> companies = new List<Account>();
        List<Order__c> orders = new List<Order__c>();
        List<Rate__c> rates = new List<Rate__c>();
        List<Work_Period__c> workPeriods = new List<Work_Period__c>();
        
        Account microsoft = new Account(Name = 'Microsoft');
        Account apple = new Account(Name = 'Apple');    
        companies.add(microsoft);
        companies.add(apple);
        insert companies;
        
        Order__c microsoftOrder = new Order__c(Name = 'microsoftOrder', Account__c = microsoft.ID);
        Order__c appleOrder = new Order__c(Name = 'appleOrder', Account__c = apple.ID);
        orders.add(microsoftOrder);
        orders.add(appleOrder);
        insert orders;
        
        Rate__c normalRate = new Rate__c(Name = 'normalRate',
                                        Customer_rate__c = 400,
                                        Employer_rate__c = 300);
        Rate__c halfTimeRate = new Rate__c(Name = 'halfTimeRate', 
                                        Customer_rate__c = 200,
                                        Employer_rate__c = 100);
        rates.add(normalRate);
        rates.add(halfTimeRate);
        insert rates;

        Work_Period__c microsoftWP = new Work_Period__c(Name = 'firstWP', 
                                                    Order__c = microsoftOrder.ID, 
                                                    Rate__c = normalRate.ID,
                                                    Start_Date__c = Date.today(),
                                                    End_Date__c = Date.today().addDays(30));
        Work_Period__c appleWP = new Work_Period__c(Name = 'secondWP',
                                                    Order__c = appleOrder.ID,
                                                    Rate__c = halfTimeRate.ID,
                                                    Start_Date__c = Date.today(),
                                                    End_Date__c = Date.today().addDays(70));
        workPeriods.add(microsoftWP);
        workPeriods.add(appleWP);
        insert workPeriods;
    }

    static testMethod void workPeriodsTest()
    {
        WorkPeriodsTest.setData();
		List<Work_Period__c> workPeriods = new List<Work_Period__c>();
        List<String> companies = new List<String>();

        workPeriods = [SELECT Id, Name, Order__r.Name, Order__r.Account__r.Name,Rate__r.Name,Rate__r.Customer_rate__c, Rate__r.Employer_rate__c
                        FROM Work_Period__c];
        
        for(Work_Period__c wp: workPeriods)
        {
            companies.add(wp.Order__r.Account__r.Name);
        }
        
        Test.startTest();
        	WorkPeriodsController wpc = new WorkPeriodsController();
        Test.stopTest();

        system.assertEquals(workPeriods.size(), wpc.workPeriods.size(), 'Error: test and controller workPeriods lists don\'t match');
        system.assertEquals(companies.size(), wpc.companies.size(), 'Error: test and controller companies lists don\'t match');
    }
}