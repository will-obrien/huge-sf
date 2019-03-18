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
@isTest
private class Test_RocketGateIntegrationHelper {

    static testMethod void authorizationTest() {
    	
    	// create an account
        Account testAcct = new Account();
        testAcct.Name = 'test account';
        insert testAcct;
    	// create payment source
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
    	
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockRocketGateResponseGenerator());
        RocketGateIntegrationHelper.RocketGateResponseBody resp = RocketGateIntegrationHelper.requestPurchase(testSource, String.valueOf(testAcct.Id), 1.0);
        System.debug('@@@@ resp: ' + resp);
        Test.stopTest();
    }
}