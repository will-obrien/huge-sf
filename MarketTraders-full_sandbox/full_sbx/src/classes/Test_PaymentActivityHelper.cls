/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       1/5/2016
*   Author:             Sean Murphy
*   Last Modified:      1/6/2016
*   Last Modified By:   Sean Murphy
*
*   1/5/16 - Class created
*   
**********************************************************************************************************************/

@isTest(SeeAllData=true)
private class Test_PaymentActivityHelper {

    static testMethod void testHelper() {
        // create account
        Account testAcct = new Account();
        testAcct.Name = 'test account';
        insert testAcct;
        
        // create opportunity
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'test opp';
        testOpp.CloseDate = Date.today().addMonths(-6);
        testOpp.AccountId = testAcct.Id;
        testOpp.StageName = 'Closed Won';
        testOpp.Sub_Stage__c = 'Payment Plan';
        testOpp.Payment_Plan__c = 'In-House Financed';
        testOpp.Amount = 1000.0;
        insert testOpp;
        
        // create payment terms
        Payment_Terms__c testTerms = new Payment_Terms__c();
        testTerms.Account__c = testAcct.Id;
        testTerms.Opportunity__c = testOpp.Id;
        testTerms.Active__c = true;
        testTerms.Discount__c = 100.0;
        testTerms.First_Payment_Term__c = true;
        insert testTerms;
        
        // create payment activities
        List<Payment_Activity__c> testActs = new List<Payment_Activity__c>();
        Date testDate = Date.today();
        Payment_Activity__c testPmtAct = new Payment_Activity__c();
        testPmtAct.Payment_Terms__c = testTerms.Id;
        testPmtAct.Opportunity__c = testOpp.Id;
        testPmtAct.Amount__c = 100.0;
        testPmtAct.Payment_Status__c = 'Paid';
        testPmtAct.Outcome__c = 'Approved';
        testPmtAct.Date__c = Date.today().addMonths(-5);
        testPmtAct.Payment_Activity_Type__c = 'Paid';
        testActs.add(testPmtAct);
        
        testPmtAct = new Payment_Activity__c();
        testPmtAct.Payment_Terms__c = testTerms.Id;
        testPmtAct.Opportunity__c = testOpp.Id;
        testPmtAct.Amount__c = 100.0;
        testPmtAct.Payment_Status__c = 'Paid';
        testPmtAct.Outcome__c = 'Declined';
        testPmtAct.Date__c = Date.today().addMonths(-4);
        testPmtAct.Payment_Activity_Type__c = 'Paid';
        testActs.add(testPmtAct);
        
        testPmtAct = new Payment_Activity__c();
        testPmtAct.Payment_Terms__c = testTerms.Id;
        testPmtAct.Opportunity__c = testOpp.Id;
        testPmtAct.Amount__c = 100.0;
        testPmtAct.Payment_Status__c = 'Paid';
        testPmtAct.Outcome__c = 'Declined';
        testPmtAct.Date__c = Date.today().addMonths(-3);
        testPmtAct.Payment_Activity_Type__c = 'Paid';
        testActs.add(testPmtAct);
        
        testPmtAct = new Payment_Activity__c();
        testPmtAct.Payment_Terms__c = testTerms.Id;
        testPmtAct.Opportunity__c = testOpp.Id;
        testPmtAct.Amount__c = 100.0;
        testPmtAct.Payment_Status__c = 'Paid';
        testPmtAct.Outcome__c = 'Approved';
        testPmtAct.Date__c = Date.today().addMonths(-2);
        testPmtAct.Payment_Activity_Type__c = 'Paid';
        testActs.add(testPmtAct);
        
        testPmtAct = new Payment_Activity__c();
        testPmtAct.Payment_Terms__c = testTerms.Id;
        testPmtAct.Opportunity__c = testOpp.Id;
        testPmtAct.Amount__c = 100.0;
        testPmtAct.Payment_Status__c = 'Paid';
        testPmtAct.Outcome__c = 'Approved';
        testPmtAct.Date__c = Date.today().addMonths(-1);
        testPmtAct.Payment_Activity_Type__c = 'Paid';
        testActs.add(testPmtAct);
        
        Test.startTest();
        
        insert testActs;
        
        Test.stopTest();
    }
}