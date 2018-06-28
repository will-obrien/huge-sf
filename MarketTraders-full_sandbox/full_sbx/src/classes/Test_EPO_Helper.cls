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
private class Test_EPO_Helper { 

    static testMethod void testRollup() {
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
        Payment_Terms__c ptTest = new Payment_Terms__c(Opportunity__c = testOpp.Id, Active__c = true);
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
        
        // create case
        Case testCase = new Case(); 
        testCase.AccountId = testAcct.Id;
        testCase.Opportunity_Link__c = testOpp.Id;
        testCase.Type = 'EPO';
        insert testCase;
        
        Map<String, ScheduleCommentTranslation__c> schedulecommentmap = ScheduleCommentTranslation__c.getAll();
        Map<String,String> schedulemap = new Map<String, String>();
        for (String scomment : schedulecommentmap.keyset()) {
            schedulemap.put(schedulecommentmap.get(scomment).Comment_Contains__c, schedulecommentmap.get(scomment).Comment_Meaning__c);
        }
        
        // query necessary case data
        Case qCase = [SELECT Id, Opportunity_Link__c, Type, Opportunity_Amount_Paid_calc_2__c, Discount_Amount_Scheduled__c, Liability_Balance_Remaining__c,
                    Opportunity_Amount_Sale_Price__c, Last_Payment_Amount__c, Last_Payment_Date__c, Next_Payment_Date__c, Number_of_Payments_Remaining__c
                FROM Case
                WHERE Id = :testCase.Id];
                
        List<Payment_Terms__c> testTerms = new List<Payment_Terms__c>();
        testTerms.add(ptTest);
        
        Map<Id, Payment_Terms__c> testActiveTermsMap = new Map<Id, Payment_Terms__c>();
        testActiveTermsMap.put(testOpp.Id, ptTest);
        
        Map<Id, Payment_Activity__c> testPmtActToOppMap = new Map<Id, Payment_Activity__c>();
        testPmtActToOppMap.put(testAcct.Id, paTest2);
        
        // start the testing
        Test.startTest();        
        //EPO_Helper.rollUpEPOValues(qCase, testSchedules, schedulemap);
        EPO_Helper.rollUpEPOValues(testOpp, qCase, testTerms, testActiveTermsMap, testPmtActToOppMap);
        Test.stopTest();
    }
}