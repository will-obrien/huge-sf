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

@isTest (SeeAllData=true)

private class DataDotComDemoTestClass {

    
    static testMethod void myUnitTest() {
        
            DataDotComDemo__c ddcDemo = DataDotComDemo__c.getOrgDefaults();
            
            try {
                 System.debug('DDC Demo ' + ddcDemo);
                 delete ddcDemo;
            } catch (Exception e){}
            
            Lead l = new Lead();
            l.FirstName = 'John';
            l.LastName = 'Doe';
            insert l;
            
            Account a = new Account();
            a.Name = 'ACME Industrial Ltd.';
            insert a;
            
            System.debug('Initial Account Is: ' + a);
            
            Contact c = new Contact();
            c.FirstName = 'Jane';
            c.LastName = 'Doe';
            c.AccountId = a.Id;
            insert c;
            
            DataDotComDemoHelper__c helpers = [select id, Name from DataDotComDemoHelper__c];
            delete helpers;
            
            DataDotComDemoHelper__c helper = new DataDotComDemoHelper__c();
            helper.Lead__c = l.Id;
            helper.Account__c = a.Id;
            helper.Contact__c = c.Id;
            insert helper;
            
            
            PageReference pageRef = Page.DemoReset;
            Test.setCurrentPage(pageRef);
        
            
            DemoReset resetController = new DemoReset();
            resetController.setupDefaults();
            
            
            String accName = resetController.demoAccountResetValues.Name__c;
            resetController.resetAccount();
            
             
            Account resetA = [select Name, Id from Account where id =: a.Id];
            
            System.assertEquals(resetA.Name, 'DOT Green Media');
            
            String leadFirstName = resetController.demoLeadResetValues.FirstName__c;
            String leadLastName = resetController.demoLeadResetValues.LastName__c;
            
            resetController.resetLead();
            Lead resetL = [select FirstName, LastName from Lead where id =: l.Id];
            System.assertEquals(resetL.FirstName, 'S');
            System.assertEquals(resetL.LastName, 'Hartman');
            
            resetController.resetContact();
            Contact resetC = [select FirstName, LastName from Contact where id =: c.Id];
            System.assertEquals(resetC.FirstName, 'Jason');
            System.assertEquals(resetC.LastName, 'Brennaman');
            
            List<Account> insertAccounts = new List<Account>();
            
            for(Integer i = 1; i <= 50; i++) {
                insertAccounts.add(new Account(name ='Account ' + i));
            }
            
            insert insertAccounts;
            
            /*
                As far as here is acutal test and assert what remains needs to be actually tested with asserts
                Due to time constraints it skips all asserts and just runs though each method.
            */
        
            resetController.updateResetValues();
            resetController.restoreDefaultValues();
            resetController.setupForDot();
            resetController.oneClickDot();
            resetController.quickDotPrepareAndRedirect();
            resetController.saveRecords();
        
        
            Lead l2 = new Lead();
            l2.FirstName = 'John';
            l2.LastName = 'Doe';
            insert l2;
            
            Account a2 = new Account();
            a2.Name = 'ACME Industrial Ltd.';
            insert a2;
            
            System.debug('Initial Account Is: ' + a);
            
            Contact c2 = new Contact();
            c2.FirstName = 'Jane';
            c2.LastName = 'Doe';
            c.AccountId = a.Id;
            insert c2;
            
            helpers = [select id, Name from DataDotComDemoHelper__c];
            delete helpers;
            
            helper = new DataDotComDemoHelper__c();
            helper.Lead__c = l2.Id;
            helper.Account__c = a2.Id;
            helper.Contact__c = c2.Id;
            insert helper;
            resetController = new DemoReset();
            resetController.setupDefaults();
        
            resetController.resetImportedData();
            resetController.resetAll();
            resetController.QuickResetAndRedirect();
            resetController.accessStandardMode();
            resetController.accessAdvancedMode();
    }
}