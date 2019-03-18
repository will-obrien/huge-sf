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
@isTest(SeeAllData=true)
private class Test_PaymentTermsController {
    private static Opportunity testOpp;
    private static User usr;
    
    private static void initData1() {
        // create a user
        Profile prof = [SELECT Id FROM Profile where Name = 'System Administrator'];
        usr = new User(alias = 'sysAdy', email='sysAdy@testorg.com', emailencodingkey='UTF-8', lastname='Smith', languagelocalekey='en_US',
            localesidkey='en_US', profileid = prof.Id, timezonesidkey='America/New_York', username='sysAdy@testorg.xyz');
            
        // create an account
        Account testAcct = new Account();
        testAcct.Name = 'test account';
        insert testAcct;
        
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
    }
    
    
    static testMethod void myUnitTest() {
        
        initData1();        
         // load the page
        Test.startTest();
        PageReference pageRef = Page.CreatePaymentTerms;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid',String.valueOf(testOpp.Id));
        
        PaymentTermsController testController = new PaymentTermsController();
        testController.init();
        
        testController.numOfDownPayments = 2;
        testController.dpStartDate = Date.today();
        testController.dpFrequency = 'Daily';
        testController.totalOfDownpayments = 100.0;
        testController.numOfRegPayments = 12;
        testController.regStartDate = Date.today();
        testController.regFrequency = 'Monthly';
        testController.totalOfRegPayments = 1200.0;
        
        testController.getSequenceDate(1, Date.today(), 'Daily');
        testController.getSequenceDate(1, Date.today(), 'Weekly');
        testController.getSequenceDate(1, Date.today(), 'BiWeekly');
        testController.getSequenceDate(1, Date.today(), 'Monthly');
        testController.createDPWrappers();
        testController.createRegWrappers();
        testController.createPaymentWraps(1200.0, 12, 'Auto', testController.regPaymentWraps, Date.today(), 'Monthly', false);
        testController.createTermsAndPlannedPayments();
        testController.getRegFrequencies();
        testController.getDPFrequencies();
        testController.getCalcTypes();
        testController.createDPWrappers();
        testController.cancelPayments();
        testController.resetDPWrappers();
        testController.resetRegWrappers();
        testController.getShowButtons();
        testController.getDownpaymentsExist();
        testController.getRegularPaymentsExist();
        testController.getTotalOfPlannedDownPayments();
        testController.getTotalOfPlannedRegPayments();
        testController.navigateToRecordPayment();
        testController.navigateToOpp();
        
        Test.stopTest();
    }
}