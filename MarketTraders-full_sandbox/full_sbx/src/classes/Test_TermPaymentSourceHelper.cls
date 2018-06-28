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
private class Test_TermPaymentSourceHelper {

        static TestMethod void termPaymentSource(){
        
        Account acc = new Account();
        acc.LastName = 'Sean';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.CloseDate = Date.today();
        opp.AccountId=acc.Id;
        opp.StageName='Close Won';
        opp.Product__c='Charting'; 
        insert opp;
        
        Payment_Terms__c pt = new Payment_Terms__c();
        pt.Opportunity__c = opp.Id;
        insert pt;
        
        Payment_Source__c ps = new Payment_Source__c();
        ps.Account__c = acc.Id;
        ps.Credit_Card_Type__c = 'Visa';
        ps.Credit_Card_Number__c = '1234123412349999';
        insert ps;
        
        Term_Payment_Source__c tps1 = new Term_Payment_Source__c ();
        tps1.Payment_Source__c = ps.Id;
        tps1.Terms__c = pt.Id;
        tps1.Primary__c = true;
        insert tps1;
            
        Term_Payment_Source__c tps2 = new Term_Payment_Source__c ();
        tps2.Payment_Source__c = ps.Id;
        tps2.Terms__c = pt.Id;
        tps2.Primary__c = false;
        insert tps2;
            
        Term_Payment_Source__c tps3 = new Term_Payment_Source__c ();
        tps3.Payment_Source__c = ps.Id;
        tps3.Terms__c = pt.Id;
        tps3.Primary__c = true;
        insert tps3;  
        
        tps2.Primary__c = true;
        update tps2;   
            
                     
    }
}