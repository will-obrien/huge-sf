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
private class TestLogDeletedEmailAddress {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account acc = new Account(LastName='Jeff', Firstname='Bob',Compass_ID_2__c='A66669999', Salutation = 'Mr.');
        insert acc;
        System.debug('Created new test account '+acc.Id);
        List<Email_Address__c> emails = new List<Email_Address__c>();
        for (Integer i=0;i<200;i++) {
            Email_Address__c ea = new Email_Address__c(
                Email_Address__c = i+'stuart@stuart.com',
                Email_Address_Type__c = 'heck',
                Account__c = acc.Id
            );  
            emails.add(ea);
        }
        insert emails;
        delete emails;
        List<DeletedEmailAddress__c> deas = [Select Id,Name,Email_Address__c,Email_Address_Type__c,EmailAddress_Id__c,Contact__c,CheckPersonAccnt__c  From DeletedEmailAddress__c Where Account__c =: acc.Id];
        System.assertEquals(deas.size(),200);
        for (DeletedEmailAddress__c dac:deas){
            System.assertEquals(dac.Email_Address_Type__c,'heck');
            System.assert(dac.Email_Address__c.endsWith('stuart@stuart.com'));
            System.assert(dac.EmailAddress_Id__c != NULL);
            System.assert(dac.Contact__c == NULL);
        }
         
       
    }
}