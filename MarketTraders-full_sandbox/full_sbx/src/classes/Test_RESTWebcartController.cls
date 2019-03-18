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
private class Test_RESTWebcartController {

    static testMethod void RESTControllerTest_Payments() {
    	Test.startTest();
        RESTWebcartController.doProcess('payments');
        Test.stopTest();
    }
    
    static testMethod void RESTControllerTest_Declines() {
    	Test.startTest();
        RESTWebcartController.doProcess('declines');
        Test.stopTest();
    }
    
    static testMethod void RESTControllerTest_Both() {
    	Test.startTest();
        RESTWebcartController.doProcess('both');
        Test.stopTest();
    }
    
    static testMethod void RESTControllerTest_Products() {
    	Test.startTest();
        RESTWebcartController.doProcess('products');
        Test.stopTest();
    }
    
    static testMethod void RESTControllerTest_All() {
    	Test.startTest();
        RESTWebcartController.doProcess('all');
        Test.stopTest();
    }
}