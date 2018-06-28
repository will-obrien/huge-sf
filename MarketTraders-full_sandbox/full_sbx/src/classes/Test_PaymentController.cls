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
private class Test_PaymentController {
	
	private static Opportunity testOpp;
	private static User usr;
	
	private static void initData1() {
		// create a user
		Profile p = [SELECT Id FROM Profile where Name = 'System Administrator'];
		usr = new User(alias = 'sysAdy', email='sysAdy@testorg.com', emailencodingkey='UTF-8', lastname='Smith', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, timezonesidkey='America/New_York', username='sysAdy@testorg.xyz');
        
		// create an account
        Account testAcct = new Account();
        testAcct.Name = 'test account';
        insert testAcct;
        
        // create payment sources (primary and non-primary)
        Payment_Source__c testSource = new Payment_Source__c();
        testSource.Account__c = testAcct.Id;
        testSource.Primary__c = true;
        testSource.Credit_Card_Type__c = 'Visa';
        testSource.Credit_Card_Number__c = '4111111111111111';
        testSource.Credit_Card_CVV__c = '123';
        if (Date.today().month() < 10) {
        	testSource.Credit_Card_Exp_Month__c = '0' + String.valueOf(Date.today().month());
        }
        else {
        	testSource.Credit_Card_Exp_Month__c = String.valueOf(Date.today().month());
        }
        testSource.Credit_Card_Exp_Year__c = String.valueOf(Date.today().year() + 1);
        insert testSource;
        
        testSource = new Payment_Source__c();
        testSource.Account__c = testAcct.Id;
        testSource.Primary__c = false;
        testSource.Credit_Card_Type__c = 'Mastercard';
        testSource.Credit_Card_Number__c = '5222222222222222';
        testSource.Credit_Card_CVV__c = '789';
        if (Date.today().month() < 10) {
        	testSource.Credit_Card_Exp_Month__c = '0' + String.valueOf(Date.today().month());
        }
        else {
        	testSource.Credit_Card_Exp_Month__c = String.valueOf(Date.today().month());
        }
        testSource.Credit_Card_Exp_Year__c = String.valueOf(Date.today().year() + 1);
        insert testSource;
        
        testSource = new Payment_Source__c();
        testSource.Account__c = testAcct.Id;
        testSource.Primary__c = false;
        testSource.Credit_Card_Type__c = 'Mastercard';
        testSource.Credit_Card_Number__c = '5222222222222222';
        testSource.Credit_Card_CVV__c = '789';
        if (Date.today().month() < 10) {
        	testSource.Credit_Card_Exp_Month__c = '0' + String.valueOf(Date.today().month());
        }
        else {
        	testSource.Credit_Card_Exp_Month__c = String.valueOf(Date.today().month());
        }
        testSource.Credit_Card_Exp_Year__c = String.valueOf(Date.today().year() + 1);
        insert testSource;
        
        // create an opportunity
        testOpp = new Opportunity();
        testOpp.AccountId = testAcct.Id;
        testOpp.Name = 'test opp';
        testOpp.CloseDate = Date.today().addDays(-30);
        testOpp.StageName = 'Closed Won';
        testOpp.Sub_Stage__c = 'Payment Plan';
        testOpp.Payment_Plan__c = 'In-House Financed';
        testOpp.Amount = 1320.0;
        insert testOpp;
        
        // create term
        Payment_Terms__c testTerm = new Payment_Terms__c();
        testTerm.Opportunity__c = testOpp.Id;
        testTerm.Active__c = true;
        testTerm.Discount__c = 0;
        testTerm.First_Payment_Term__c = true;
        testTerm.Terms_Number_of_Payments_Not_inc_Down__c = 12;
        testTerm.Sales_Price__c = 1320.0;
        testTerm.Payment_Terms_Type__c = 'Standard for regular sales';
        insert testTerm;
        
        // create planned payments
        List<Planned_Payment__c> testPlannedPmts = new List<Planned_Payment__c>();
        // down payment
        Planned_Payment__c testPP = new Planned_Payment__c();
    	testPP.Payment_Terms__c = testTerm.Id;
    	testPP.Amount_Due__c = 120.0;
    	testPP.PP_Description__c = 'Standard - for regular sales';
    	testPP.Down_Payment__c = true;
    	testPP.Due_Date__c = Date.today().addDays(-30);
    	testPP.Status__c = 'Scheduled';
    	testPP.PP_Type__c = 'Down Payment';
    	testPlannedPmts.add(testPP);
        
        // regular payments
        for (Integer i = 0; i < 12; i++) {
        	testPP = new Planned_Payment__c();
        	testPP.Payment_Terms__c = testTerm.Id;
        	testPP.Amount_Due__c = 100.0;
        	testPP.PP_Description__c = 'Standard - for regular sales';
        	testPP.Down_Payment__c = false;
        	testPP.Due_Date__c = Date.today().addDays(i*30);
        	testPP.Status__c = 'Scheduled';
        	testPP.PP_Type__c = 'Recurring Payment';
        	testPlannedPmts.add(testPP);
        }
        
        insert testPlannedPmts;
        
        // create payment activities
        Payment_Activity__c testPA;
        List<Payment_Activity__c> testPmtActys = new List<Payment_Activity__c>();
        for (Integer j = -1; j < 2; j++) {
        	testPA = new Payment_Activity__c();
        	testPA.Payment_Terms__c = testTerm.Id;
        	testPA.Opportunity__c = testOpp.Id;
        	testPA.Amount__c = 100;
        	testPA.Outcome__c = 'Approved';
        	testPA.Payment_Type__c = 'Credit Card';
        	testPA.Processed_By__c = usr.Id;
        	testPA.Payment_Status__c = 'Paid';
        	testPmtActys.add(testPA);
        }
        
        insert testPmtActys;
	}
	
	
	private static void initData2() {
		// create a user
		Profile p = [SELECT Id FROM Profile where Name = 'System Administrator'];
		usr = new User(alias = 'sysAdy', email='sysAdy@testorg.com', emailencodingkey='UTF-8', lastname='Smith', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, timezonesidkey='America/New_York', username='sysAdy@testorg.xyz');
        
		// create an account
        Account testAcct = new Account();
        testAcct.Name = 'test account';
        insert testAcct;
        
        // create payment sources (primary and non-primary)
        Payment_Source__c testSource = new Payment_Source__c();
        testSource.Account__c = testAcct.Id;
        testSource.Primary__c = true;
        testSource.Credit_Card_Type__c = 'Visa';
        testSource.Credit_Card_Number__c = '4111111111111111';
        testSource.Credit_Card_CVV__c = '123';
        if (Date.today().month() < 10) {
        	testSource.Credit_Card_Exp_Month__c = '0' + String.valueOf(Date.today().month());
        }
        else {
        	testSource.Credit_Card_Exp_Month__c = String.valueOf(Date.today().month());
        }
        testSource.Credit_Card_Exp_Year__c = String.valueOf(Date.today().year() + 1);
        insert testSource;
        
        testSource = new Payment_Source__c();
        testSource.Account__c = testAcct.Id;
        testSource.Primary__c = false;
        testSource.Credit_Card_Type__c = 'Mastercard';
        testSource.Credit_Card_Number__c = '5222222222222222';
        testSource.Credit_Card_CVV__c = '789';
        if (Date.today().month() < 10) {
        	testSource.Credit_Card_Exp_Month__c = '0' + String.valueOf(Date.today().month());
        }
        else {
        	testSource.Credit_Card_Exp_Month__c = String.valueOf(Date.today().month());
        }
        testSource.Credit_Card_Exp_Year__c = String.valueOf(Date.today().year() + 1);
        insert testSource;
        
        // create an opportunity
        testOpp = new Opportunity();
        testOpp.AccountId = testAcct.Id;
        testOpp.Name = 'test opp';
        testOpp.CloseDate = Date.today().addDays(-30);
        testOpp.StageName = 'Closed Won';
        testOpp.Sub_Stage__c = 'Payment Plan';
        testOpp.Payment_Plan__c = 'In-House Financed';
        testOpp.Amount = 1320.0;
        insert testOpp;
	}
	
	private static void initData3() {
		// create a user
		Profile p = [SELECT Id FROM Profile where Name = 'System Administrator'];
		usr = new User(alias = 'sysAdy', email='sysAdy@testorg.com', emailencodingkey='UTF-8', lastname='Smith', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, timezonesidkey='America/New_York', username='sysAdy@testorg.xyz');
        
        // create an account
        Account testAcct = new Account();
        testAcct.Name = 'test account';
        insert testAcct;
        
        // create payment sources (primary and non-primary)
        Payment_Source__c testSource = new Payment_Source__c();
        testSource.Account__c = testAcct.Id;
        testSource.Primary__c = true;
        testSource.Credit_Card_Type__c = 'Visa';
        testSource.Credit_Card_Number__c = '4111111111111111';
        testSource.Credit_Card_CVV__c = '123';
        if (Date.today().month() < 10) {
        	testSource.Credit_Card_Exp_Month__c = '0' + String.valueOf(Date.today().month());
        }
        else {
        	testSource.Credit_Card_Exp_Month__c = String.valueOf(Date.today().month());
        }
        testSource.Credit_Card_Exp_Year__c = String.valueOf(Date.today().year() - 1);
        insert testSource;
        
        // create an opportunity
        testOpp = new Opportunity();
        testOpp.AccountId = testAcct.Id;
        testOpp.Name = 'test opp';
        testOpp.CloseDate = Date.today().addDays(-30);
        testOpp.StageName = 'Closed Won';
        testOpp.Sub_Stage__c = 'Payment Plan';
        testOpp.Payment_Plan__c = 'In-House Financed';
        testOpp.Amount = 1320.0;
        insert testOpp;
        
        // create term
        Payment_Terms__c testTerm = new Payment_Terms__c();
        testTerm.Opportunity__c = testOpp.Id;
        testTerm.Active__c = true;
        testTerm.Discount__c = 0;
        testTerm.First_Payment_Term__c = true;
        testTerm.Terms_Number_of_Payments_Not_inc_Down__c = 12;
        testTerm.Sales_Price__c = 1320.0;
        testTerm.Payment_Terms_Type__c = 'Standard for regular sales';
        insert testTerm;
        
        // create planned payments
        List<Planned_Payment__c> testPlannedPmts = new List<Planned_Payment__c>();
        // down payment
        Planned_Payment__c testPP = new Planned_Payment__c();
    	testPP.Payment_Terms__c = testTerm.Id;
    	testPP.Amount_Due__c = 120.0;
    	testPP.PP_Description__c = 'Standard - for regular sales';
    	testPP.Down_Payment__c = true;
    	testPP.Due_Date__c = Date.today().addDays(-30);
    	testPP.Status__c = 'Scheduled';
    	testPP.PP_Type__c = 'Down Payment';
    	testPlannedPmts.add(testPP);
        
        // regular payments
        for (Integer i = 0; i < 12; i++) {
        	testPP = new Planned_Payment__c();
        	testPP.Payment_Terms__c = testTerm.Id;
        	testPP.Amount_Due__c = 100.0;
        	testPP.PP_Description__c = 'Standard - for regular sales';
        	testPP.Down_Payment__c = false;
        	testPP.Due_Date__c = Date.today().addDays(i*30);
        	testPP.Status__c = 'Scheduled';
        	testPP.PP_Type__c = 'Recurring Payment';
        	testPlannedPmts.add(testPP);
        }
        
        insert testPlannedPmts;
        
        // create payment activities
        Payment_Activity__c testPA;
        List<Payment_Activity__c> testPmtActys = new List<Payment_Activity__c>();
        for (Integer j = -1; j < 2; j++) {
        	testPA = new Payment_Activity__c();
        	testPA.Payment_Terms__c = testTerm.Id;
        	testPA.Opportunity__c = testOpp.Id;
        	testPA.Amount__c = 100;
        	testPA.Outcome__c = 'Approved';
        	testPA.Payment_Type__c = 'Credit Card';
        	testPA.Processed_By__c = usr.Id;
        	testPA.Payment_Status__c = 'Paid';
        	testPmtActys.add(testPA);
        }
        
        insert testPmtActys;
	}

    static testMethod void testController_General_1() {
        
        initData1();
        
        // load the page
        Test.startTest();
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
        
        PaymentController testController = new PaymentController();
        testController.getHasPlannedPayments();
		testController.getHasPaymentActivities();
		testController.getNewPaymentSourceURL();
		testController.getPaymentSources();
		testController.refreshPaymentSources();
		testController.getPendingPayments();
		testController.navigateToNext();
		Test.stopTest();
    }
    
    static testMethod void testController_General_2() {
        
        initData1();
        
        // load the page
        Test.startTest();
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
        
        PaymentController testController = new PaymentController();
        testController.oppId = null;
        testController.acctId = null;
        testController.cancel();
		Test.stopTest();
    }
    
    static testMethod void testController_runMoney_1() {
        initData1();
        
        Test.startTest();
        
        // load the page
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
		// create controller        
        PaymentController testController = new PaymentController();
        // select payment type of credit card and check process card
        testController.paymentActivity.Payment_Type__c = 'Credit Card';
        testController.processCard = true;
        testController.handlePaymentTypeChange();
        // select payment source
        testController.selectedPaymentSourceId = testController.primaryPaymentSourceId;
        // set amount
        testController.paymentActivity.Amount__c = 100;
        // run money 
        testController.process();
        
        Test.stopTest();
    }
    
    static testMethod void testController_runMoney_2() {
        initData2();
        
        Test.startTest();
        
        // load the page
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
		// create controller        
        PaymentController testController = new PaymentController();
        // select payment type of credit card and check process card
        testController.paymentActivity.Payment_Type__c = 'Credit Card';
        testController.processCard = true;
        testController.handlePaymentTypeChange();
        // select payment source
        testController.selectedPaymentSourceId = testController.primaryPaymentSourceId;
        // set amount
        testController.paymentActivity.Amount__c = 100;
        // run money
        testController.process();
        
        Test.stopTest();
    }
    
    static testMethod void testController_runMoney_3() {
        initData3();
        
        Test.startTest();
        
        // load the page
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
		// create controller        
        PaymentController testController = new PaymentController();
        // select payment type of credit card and check process card
        testController.paymentActivity.Payment_Type__c = 'Credit Card';
        testController.processCard = true;
        testController.handlePaymentTypeChange();
        // select payment source
        testController.selectedPaymentSourceId = testController.primaryPaymentSourceId;
        // set amount
        testController.paymentActivity.Amount__c = 100;
        // run money
        testController.process();
        
        Test.stopTest();
    }
    
    static testMethod void testController_manual_1() {
        initData1();
        
        Test.startTest();
        
        // load the page
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
		// create controller        
        PaymentController testController = new PaymentController();
        testController.paymentActivity.Payment_Type__c = 'Credit Card';
        testController.processCard = false;
        testController.handlePaymentTypeChange();
        testController.selectedPaymentSourceId = testController.primaryPaymentSourceId;
        testController.paymentActivity.Amount__c = 100;
        testController.paymentActivity.Authorization_Decline_Number__c = '121212';
        testController.paymentActivity.Outcome__c = 'Approved';
        testController.paymentActivity.Payment_Status__c = 'Paid';
        testController.paymentActivity.Processed_By__c = usr.Id;
        
        // add an amount paid to a planned payment
        PaymentController.PlannedPaymentWrapper testPlannedPmt = testController.plannedPaymentWraps[0];
        testPlannedPmt.amount = 100;
        
        // run manual
        testController.process();
        
        Test.stopTest();
    }
    
    static testMethod void testController_manual_2() {
        initData1();
        
        Test.startTest();
        
        // load the page
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
		// create controller        
        PaymentController testController = new PaymentController();
        testController.paymentActivity.Payment_Type__c = 'Credit Card';
        testController.processCard = false;
        testController.handlePaymentTypeChange();
        testController.selectedPaymentSourceId = testController.primaryPaymentSourceId;
        testController.paymentActivity.Amount__c = 100;
        testController.paymentActivity.Authorization_Decline_Number__c = '121212';
        testController.paymentActivity.Outcome__c = 'Approved';
        testController.paymentActivity.Payment_Status__c = 'Paid';
        testController.paymentActivity.Processed_By__c = usr.Id;
        
        // add an amount paid to a planned payment
        PaymentController.PlannedPaymentWrapper testPlannedPmt = testController.plannedPaymentWraps[0];
        testPlannedPmt.amount = 100;
        
        // run manual
        testController.process();
        
        Test.stopTest();
    }
    
    static testMethod void testController_manual_3() {
        initData1();
        
        Test.startTest();
        
        // load the page
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
		// create controller        
        PaymentController testController = new PaymentController();
        testController.paymentActivity.Payment_Type__c = 'Cash';
        testController.processCard = false;
        testController.handlePaymentTypeChange();
        testController.paymentActivity.Amount__c = 100;
        testController.paymentActivity.Payment_Status__c = 'Paid';
        testController.paymentActivity.Processed_By__c = usr.Id;
        
        // add an amount paid to a planned payment
        PaymentController.PlannedPaymentWrapper testPlannedPmt = testController.plannedPaymentWraps[0];
        testPlannedPmt.amount = 100;
        
        // run manual
        testController.process();
        
        Test.stopTest();
    }
    
    static testMethod void testController_apply_1() {
        initData1();
        
        Test.startTest();
        
        // load the page
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
		// create controller        
        PaymentController testController = new PaymentController();
        // select and existing payment activity wrapper
        testController.paymentActivityWrapList[0].selected = true;
        testController.handleSelectionChange();
        // add an amount paid to a planned payment
        testController.plannedPaymentWraps[0].amount = 100;
        
        // run apply
        testController.process();
        
        Test.stopTest();
    }
    
    static testMethod void testController_apply_2() {
        initData1();
        
        Test.startTest();
        
        // load the page
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
		// create controller        
        PaymentController testController = new PaymentController();
        // select and existing payment activity wrapper
        testController.paymentActivityWrapList[0].selected = true;		// amount is 100
        testController.handleSelectionChange();
        testController.paymentActivityWrapList[1].selected = true;		// amount is 100
        testController.handleSelectionChange();
        // add an amount paid to a planned payment
        testController.plannedPaymentWraps[0].amount = 200;				// must match amount of payment activities
        
        // run apply
        testController.process();
        
        Test.stopTest();
    }
    
    static testMethod void testController_apply_3() {
        initData1();
        
        Test.startTest();
        
        // load the page
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
		// create controller        
        PaymentController testController = new PaymentController();
        // select and existing payment activity wrapper
        testController.paymentActivityWrapList[0].selected = true;		// amount is 100
        testController.handleSelectionChange();
        // add an amount paid to a planned payment
        testController.plannedPaymentWraps[0].amount = 50;
        testController.plannedPaymentWraps[1].amount = 50;				// must match amount of payment activity
        
        // run apply
        testController.process();
        
        Test.stopTest();
    }
    
    static testMethod void testController_apply_4() {
        initData1();
        
        Test.startTest();
        
        // load the page
        PageReference pageRef = Page.CreatePayment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
		// create controller        
        PaymentController testController = new PaymentController();
        // select and existing payment activity wrapper
        testController.paymentActivityWrapList[0].selected = true;		// amount is 100
        testController.handleSelectionChange();
        // add an amount paid to a planned payment
        testController.plannedPaymentWraps[0].amount = 25;
        testController.plannedPaymentWraps[1].amount = 25;				// intentional mis-match to amount of payment activity
        
        // run apply
        testController.process();
        
        Test.stopTest();
    }
}