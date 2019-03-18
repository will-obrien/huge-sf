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
private class chatterJanitorTester {

    static testMethod void myUnitTest() {
    	
    	test.startTest();
        chatterJanitor cj2 = new chatterjanitor();
        cj2.doWork();
        cjControlPanel cjcp = new cjControlPanel();
        cjcp.makeSetting();
        cjcp.getSObjectList();
        
        for(cjControlPanel.CJSetting cjs : cjcp.settingList)
        {
        	cjs.runSetting();
        
        }
        cjcp.updateEmail();
        cjcp.addSetting();
        cjcp.cjsNew.Active__c = false;
        cjcp.cjsNew.object_name__c = 'User';
        
        cjcp.cleanAll();
        
        List<ChatterJanitorSetting__c> cjsList = [select date_limit_no_of_type__c, skip_tracked_changes__c, skip_written_posts__c, date_limit_type__c, id, email_archival__c, name, object_name__c from ChatterJanitorSetting__c where active__c = true order by object_name__c asc limit 3];
        chatterJanitor.cleanObjects('cjimson@mailinator.com', cjsList);
        test.stopTest();
        cjcp.scrubOrg();

    }
}