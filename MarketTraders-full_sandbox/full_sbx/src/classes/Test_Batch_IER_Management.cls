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
private class Test_Batch_IER_Management {
	
	/**************************************
    *
    * @description:
    * batchTest - tests the Batch_IER_Management class
    *  
    **/
	static testMethod void batchTest() {
        // create IER record(s)
        List<et4ae5__IndividualEmailResult__c> testIERs = new List<et4ae5__IndividualEmailResult__c>();
        et4ae5__IndividualEmailResult__c ier;
        for (Integer i = 0; i < 20; i++) {
			ier = new et4ae5__IndividualEmailResult__c();
			ier.Name = 'test ier ' + String.valueOf(i);
			testIERs.add(ier);
        }
        insert testIERs;
        
        Test.startTest();
        
        Date cutoffDate = Date.today();
		cutoffDate = cutoffDate.addDays(-30);
		String queryDate = String.valueOf(cutoffDate); 
		queryDate = queryDate.substringBefore(' ');
		queryDate = queryDate + 'T00:00:00Z';
		String userQuery ='SELECT Id FROM et4ae5__IndividualEmailResult__c WHERE CreatedDate < ' + queryDate;
        userQuery += ' LIMIT 20';
		Database.executebatch(new Batch_IER_Management(userQuery), 20);
        
        Test.stopTest();
    }
}