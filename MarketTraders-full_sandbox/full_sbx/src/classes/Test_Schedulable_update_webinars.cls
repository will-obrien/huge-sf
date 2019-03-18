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
Private class Test_Schedulable_update_webinars{
  
     
    
      static testmethod void test() {
       test.startTest();
          
             Webinar_Credentials__c credentials = new Webinar_Credentials__c();
                credentials.API_Key__c = 'test';
                credentials.Credentials_ID__c = '1';
                credentials.Mnemonic__c = 'test';
                credentials.Org_ID__c = '654564654';
                credentials.Password__c = 'test';
                credentials.Provider__c = 'Citrix';
                credentials.Token__c = '123123';
                credentials.Username__c = 'test';
                database.insert(credentials);
                
                list<Webinar_Credentials__c> wclist = new list<Webinar_Credentials__c>();
                wclist=[select Id, API_Key__c, Credentials_ID__c, Mnemonic__c, Org_ID__c, Password__c, Provider__c, Token__c, Username__c from Webinar_Credentials__c];
                

                System.schedule('Update Webinar', '0 0 * * * ?', new Schedulable_update_webinars() ); 

                

       test.stopTest();     
           
      }
}