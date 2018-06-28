/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seealldata=true)
private class Test_Schedule_EPO_Update {

    static testMethod void testScheduleEPOUpdate() {
    	// init required data 
        
        // create account
        Account testAcct = new Account();
        testAcct.Name = 'test account';
        insert testAcct;
        
        // create opportunity
        Opportunity testOpp = new Opportunity();
        testOpp.AccountId = testAcct.Id;
        testOpp.Name = 'test opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Closed Won';
        testOpp.Sub_Stage__c = 'Payment Plan';
        testOpp.Payment_Plan__c = 'In-House Financed';
        testOpp.Amount = 200.0;
        insert testOpp;
        
        // get a pricebook
        Pricebook2 testPBK = [SELECT Id FROM Pricebook2 WHERE Name = 'North American' LIMIT 1];
        
        // get a product
        List<Product2> testProds = [SELECT Id FROM Product2 WHERE Name LIKE '%Course%' LIMIT 2];
        
        Set<Id> testProdIds = new Set<Id>();
        for (Product2 p : testProds) {
            testProdIds.add(p.Id);
        }
        
        // get a pricebook entry
        List<PricebookEntry> testPBEs = [SELECT Id FROM PricebookEntry WHERE Product2Id IN :testProdIds AND isActive = true AND Pricebook2Id = :testPBK.Id];
        
        // create opportunity line items
        OpportunityLineItem testOLI_1 = new OpportunityLineItem();
        testOLI_1.Quantity = 1;
        testOLI_1.PricebookEntryId = testPBEs[0].Id;
        testOLI_1.OpportunityId = testOpp.Id;
        testOLI_1.ServiceDate = Date.today();
        testOLI_1.TotalPrice = 100.0;
        insert testOLI_1;
        
        OpportunityLineItem testOLI_2 = new OpportunityLineItem();
        testOLI_2.Quantity = 1;
        testOLI_2.PricebookEntryId = testPBEs[1].Id;
        testOLI_2.OpportunityId = testOpp.Id;
        testOLI_2.ServiceDate = Date.today();
        testOLI_2.TotalPrice = 100.0;
        insert testOLI_2;
        
        // create revenue schedules
        List<OpportunityLineItemSchedule> testSchedules = new List<OpportunityLineItemSchedule>();
        for (Integer i = -1; i < 2; i++) {
            OpportunityLineItemSchedule testSched = new OpportunityLineItemSchedule();
            testSched.OpportunityLineItemId = testOLI_1.Id;
            testSched.ScheduleDate = Date.today().addDays(i);
            testSched.Revenue = 100 + i;
            testSched.Type = 'Revenue';
            if (testSched.ScheduleDate <= Date.today()) {
                testSched.Description = 'Paid';
            }
            else {
                testSched.Description = 'Scheduled Bad Debt';
            }
            testSchedules.add(testSched);
        }
        insert testSchedules;
        
        testSchedules = new List<OpportunityLineItemSchedule>();
        for (Integer i = -2; i < 3; i++) {
            OpportunityLineItemSchedule testSched = new OpportunityLineItemSchedule();
            testSched.OpportunityLineItemId = testOLI_2.Id;
            testSched.ScheduleDate = Date.today().addDays(i);
            testSched.Revenue = 100 + i;
            testSched.Type = 'Revenue';
            if (testSched.ScheduleDate <= Date.today()) {
                testSched.Description = 'Paid';
            }
            else {
                testSched.Description = 'Scheduled Bad Debt'; 
            }
            testSchedules.add(testSched);
        }
        insert testSchedules;
        
        // create case
        Case testCase = new Case();
        testCase.AccountId = testAcct.Id;
        testCase.Opportunity_Link__c = testOpp.Id;
        testCase.Type = 'EPO';
        insert testCase;
    	
    	Test.startTest();
        // create cron expression
        Datetime nextDateTime = System.now();
        nextDateTime = nextDateTime.addDays(Integer.valueOf(2));
        String chron_exp = '' + nextDateTime.second() + ' ' + nextDateTime.minute() + ' ' + nextDateTime.hour() + ' ' + nextDateTime.day() + ' ' + nextDateTime.month() + ' ? ' + nextDateTime.year();
        System.debug(chron_exp);
        // schedule cron job
        Schedule_EPO_Update EPOScheduler = new Schedule_EPO_Update();
        System.schedule('EPO Update Scheduler Test' + nextDateTime, chron_exp, EPOScheduler);
        Test.stopTest();  
    }
}