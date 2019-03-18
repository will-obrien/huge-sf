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
private class Test_Scheduled_IER_Management {

    /**************************************
    *
    * @description:
    * scheduleTest - tests the Scheduled_IER_Management class
    *  
    **/
    static testMethod void scheduleTest() {
        // create ier management config custom setting
        IERMgmtConfig__c ierConfig = new IERMgmtConfig__c();
        ierConfig.Name = 'test config';
        ierConfig.Days_To_Keep__c = 30;
        ierConfig.Period_in_minutes__c = 60;
        ierConfig.Record_Count__c = 50;
        insert ierConfig;
        
        // create IER records
        List<et4ae5__IndividualEmailResult__c> testIERs = new List<et4ae5__IndividualEmailResult__c>();
        et4ae5__IndividualEmailResult__c ier;
        for (Integer i = 0; i < 20; i++) {
            ier = new et4ae5__IndividualEmailResult__c();
            ier.Name = 'test ier ' + String.valueOf(i);
            testIERs.add(ier);
        }
        insert testIERs;
        
        Test.startTest();
        // create cron expression
        Datetime nextDateTime = System.now();
        nextDateTime = nextDateTime.addMinutes(Integer.valueOf(5));
        String chron_exp = '' + nextDateTime.second() + ' ' + nextDateTime.minute() + ' ' + nextDateTime.hour() + ' ' + nextDateTime.day() + ' ' + nextDateTime.month() + ' ? ' + nextDateTime.year();
        System.debug(chron_exp);
        // schedule cron job
        Scheduled_IER_Management IERScheduler = new Scheduled_IER_Management();
        System.schedule('IER Management Scheduler Test' + System.now(), chron_exp, IERScheduler);
        Test.stopTest();        
    }
}