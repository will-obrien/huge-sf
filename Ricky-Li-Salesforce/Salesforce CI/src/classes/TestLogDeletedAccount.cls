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
private class TestLogDeletedAccount {

    static testMethod void testDelete() {
        List<Account> accounts = new List<Account>();
        for (Integer i=0;i<200;i++) {

            Account a = new Account(
                Name = 'Test Account'+i,
                Compass_ID_2__c = 'C6666666666'+i,
                BillingState='ON', 
                BillingCountry = 'Canada'
            );  
            accounts.add(a);
        }
        insert accounts;
        delete accounts;
        Set<Id> accIds = new Set<Id>();
        for (Account acc: accounts){
            accIds.add(acc.Id);
        }
        List<DeletedAccount__c> daccs = [Select AccountID__c,Name,CompassID__c,MergeRecordID__c,MergeCompassID__c  From DeletedAccount__c Where AccountID__c IN :accIds];
        for (DeletedAccount__c dac:daccs){
            System.assert(dac.CompassID__c.startsWith('C6666666666'));
        } 
        
        
    }
    
    static testMethod void validateSimpleDeleteAccount() {
       Account a = new Account(LastName='Jeff', Firstname='Bob',Compass_ID_2__c='C666699999999', Salutation='Mr.' );
       System.debug('Created new test account '+a.name);
       insert a;
       
       a = [SELECT Id,Name,Compass_ID_2__c FROM Account WHERE Id =:a.Id];
       System.assertEquals(a.Compass_ID_2__c, 'C666699999999');
       
       delete a;
       
       DeletedAccount__c da = [SELECT Id,Name,CompassID__c,AccountId__c,MergeCompassID__c FROM DeletedAccount__c WHERE AccountID__c =:a.Id];
       System.assertEquals(a.Compass_ID_2__c, da.CompassID__c);
       System.assertEquals(da.MergeCompassID__c, null);

    }
    
    static testMethod void validateSimpleMerge() {
       Account a = new Account(LastName='Jeff', Firstname='Bob',Compass_ID_2__c='C666699999999', Salutation = 'Mr.');
       insert a;
       a = [SELECT Id FROM Account WHERE Id =:a.Id];
       
       Account b = new Account(LastName='Jeff2', Firstname='Bob',Compass_ID_2__c='C666699900000', Salutation = 'Mr.');
       insert b;
       b = [SELECT Id FROM Account WHERE Id =:b.Id];
       merge a b;
       
       DeletedAccount__c da = [SELECT Id,Name,CompassID__c,AccountId__c,MergeCompassID__c FROM DeletedAccount__c WHERE AccountID__c =:b.Id];
       System.assertEquals('C666699900000', da.CompassID__c);
       System.assertEquals('C666699999999', da.MergeCompassID__c);

    }
}