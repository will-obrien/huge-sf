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
private class Test_Batch_EPO_Update {

    static testMethod void testBatchable1() {
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
        
        // create first term
        Payment_Terms__c ptTest = new Payment_Terms__c(Opportunity__c = testOpp.Id, Active__c = false);
        ptTest.Payment_Terms_Type__c = 'Standard for regular sales';
        ptTest.First_Payment_Term__c = true;
        ptTest.Date_Voided__c = Date.today().addDays(-30);
        ptTest.Discount__c = 100;
        insert ptTest;
        
        // create planned payments
        List<Planned_Payment__c> ppTestList = new List<Planned_Payment__c>();
        Planned_Payment__c ppTest1 = new Planned_Payment__c (Amount_Due__c = 100, Due_Date__c = Date.today().addDays(-20), Payment_Terms__c = ptTest.Id);
        ppTestList.add(ppTest1);
        
        Planned_Payment__c ppTest2 = new Planned_Payment__c (Amount_Due__c = 100, Due_Date__c = Date.today().addDays(-15), Payment_Terms__c = ptTest.Id);
        ppTestList.add(ppTest2);
        insert ppTestList;
        
        // create payment activities
        List<Payment_Activity__c> paTestList = new List<Payment_Activity__c>();
        Payment_Activity__c paTest1 = new Payment_Activity__c(Payment_Terms__c = ptTest.Id, Outcome__c = 'Approved', Amount__c = 100);
        paTest1.Date__c = DateTime.now().addDays(-20);
        paTestList.add(paTest1);
        
        Payment_Activity__c paTest2 = new Payment_Activity__c(Payment_Terms__c = ptTest.Id, Outcome__c = 'Approved', Amount__c = 100);
        paTest2.Date__c = DateTime.now().addDays(-15);
        paTestList.add(paTest2);
        insert paTestList;
        
        // create junction objects
        List<Payment__c> pTestList = new List<Payment__c>();
        Payment__c pTest1 = new Payment__c (Planned_Payment__c = ppTest1.Id, Payment_Activity__c = paTest1.Id);
        pTestList.add(pTest1);
        
        Payment__c pTest2 = new Payment__c (Planned_Payment__c = ppTest2.Id, Payment_Activity__c = paTest2.Id);
        pTestList.add(pTest2);
        insert pTestList;
        
        // create EPO term
        ppTestList.clear();
        paTestList.clear();
        pTestList.clear();
        Payment_Terms__c ptEPOTest = new Payment_Terms__c(Opportunity__c = testOpp.Id, Active__c = true);
        ptEPOTest.Payment_Terms_Type__c = 'EPO';
        ptEPOTest.Discount__c = 100;
        insert ptEPOTest;
        
        // create planned payments
        ppTest1 = new Planned_Payment__c (Amount_Due__c = 100, Due_Date__c = Date.today().addDays(-10), Payment_Terms__c = ptEPOTest.Id);
        ppTestList.add(ppTest1);
        
        ppTest2 = new Planned_Payment__c (Amount_Due__c = 100, Due_Date__c = Date.today().addDays(-5), Payment_Terms__c = ptEPOTest.Id);
        ppTestList.add(ppTest2);
        
        
        Planned_Payment__c ppTest3 = new Planned_Payment__c (Amount_Due__c = 100, Due_Date__c = Date.today().addDays(5), Payment_Terms__c = ptEPOTest.Id);
        ppTestList.add(ppTest3);
        insert ppTestList;
        
        // create payment activities
        paTest1 = new Payment_Activity__c(Payment_Terms__c = ptEPOTest.Id, Outcome__c = 'Approved', Amount__c = 100);
        paTest1.Date__c = DateTime.now().addDays(-10);
        paTestList.add(paTest1);
        
        paTest2 = new Payment_Activity__c(Payment_Terms__c = ptEPOTest.Id, Outcome__c = 'Approved', Amount__c = 100);
        paTest2.Date__c = DateTime.now().addDays(-5);
        paTestList.add(paTest2);
        insert paTestList;
        
        // create junction objects
        pTest1 = new Payment__c (Planned_Payment__c = ppTest1.Id, Payment_Activity__c = paTest1.Id);
        pTestList.add(pTest1);
        
        pTest2 = new Payment__c (Planned_Payment__c = ppTest2.Id, Payment_Activity__c = paTest2.Id);
        pTestList.add(pTest2);
        insert pTestList;
        
        // create case
        Case testCase = new Case();  
        testCase.AccountId = testAcct.Id;
        testCase.Opportunity_Link__c = testOpp.Id;
        testCase.Type = 'EPO';
        insert testCase;
        
        Test.startTest();
        
        Database.executebatch(new Batch_EPO_Update(), 100);
        
        Test.stopTest();
    }
    
    static testMethod void testBatchable2() {
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
        
        // create first term
        Payment_Terms__c ptTest = new Payment_Terms__c(Opportunity__c = testOpp.Id, Active__c = false);
        ptTest.Payment_Terms_Type__c = 'Standard for regular sales';
        ptTest.First_Payment_Term__c = true;
        ptTest.Date_Voided__c = Date.today().addDays(-30);
        ptTest.Discount__c = 100;
        insert ptTest;
        
        // create planned payments
        Planned_Payment__c ppTest = new Planned_Payment__c (Amount_Due__c = 100, Due_Date__c = Date.today().addDays(-15), Payment_Terms__c = ptTest.Id);
        insert ppTest;
        
        // create payment activities
        Payment_Activity__c paTest = new Payment_Activity__c(Payment_Terms__c = ptTest.Id, Outcome__c = 'Approved', Amount__c = 100);
        paTest.Date__c = DateTime.now().addDays(-15);
        insert paTest;
        
        // create junction objects
        Payment__c pTest = new Payment__c (Planned_Payment__c = ppTest.Id, Payment_Activity__c = paTest.Id);
        insert pTest;
        
        // create case
        Case testCase = new Case();  
        testCase.AccountId = testAcct.Id;
        testCase.Opportunity_Link__c = testOpp.Id;
        testCase.Type = 'EPO';
        insert testCase;
        
        Test.startTest();
        
        Database.executebatch(new Batch_EPO_Update(), 100);
        
        Test.stopTest();
    }
}