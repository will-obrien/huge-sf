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
private class ContactTriggerHandlerTest {

    static testMethod void testValid() {
        Contact conInstance = new Contact();
        Account accInstance = new Account();
        conInstance.LastName ='foo';
        conInstance.email = 'foo@abc.com';

        accInstance.Name = 'ABC Containers';
        accInstance.website = 'www.abc.com';

        insert accInstance;
        test.startTest();
        insert conInstance;
        test.stopTest();

        conInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(accInstance.Id,conInstance.AccountId);

    }

    static testMethod void testDifferentDomain() {
        Contact conInstance = new Contact();
        Account accInstance = new Account();
        conInstance.LastName ='foo';
        conInstance.email = 'foo@xyz.com';

        accInstance.Name = 'ABC Containers';
        accInstance.website = 'www.abc.com';

        insert accInstance;
        test.startTest();
        insert conInstance;
        test.stopTest();

        conInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,conInstance.AccountId);

    }

    static testMethod void testBlankEmail() {
        Contact conInstance = new Contact();
        Account accInstance = new Account();
        conInstance.LastName ='foo';
        conInstance.email = '';

        accInstance.Name = 'ABC Containers';
        accInstance.website = 'www.abc.com';

        insert accInstance;
        test.startTest();
        insert conInstance;
        test.stopTest();

        conInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,conInstance.AccountId);

    }

    static testMethod void testBlankWebsite() {
        Contact conInstance = new Contact();
        Account accInstance = new Account();
        conInstance.LastName ='foo';
        conInstance.email = 'foo@xyz.com';

        accInstance.Name = 'ABC Containers';
        accInstance.website = '';

        insert accInstance;
        test.startTest();
        insert conInstance;
        test.stopTest();

        conInstance = [SELECT AccountId FROM Contact];
        System.assertEquals(NULL,conInstance.AccountId);

    }

}