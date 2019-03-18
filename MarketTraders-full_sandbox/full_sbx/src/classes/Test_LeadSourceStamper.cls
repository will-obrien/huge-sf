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
private class Test_LeadSourceStamper {

    static testMethod void testAccountRollup() {
        
        // account testing
        
        Account account = new Account();
        account.FirstName = 'Bruce';
        account.LastName = 'Wayne';
        account.PersonEmail = 'bruce.wayne@gotham.com';
        account.Country_List__c = 'United States of America';
        account.RecordTypeId = '012600000005CeK';
        Database.insert(account);
        
        list<Lead_Sources__c> acctLeadSources = new list<Lead_Sources__c>();
        
        // UTP
        Lead_Sources__c utpAccountJan = new Lead_Sources__c();
        utpAccountJan.Account__c = account.id;
        utpAccountJan.Lead_Source__c = 'utpAccountJan';
        utpAccountJan.Lead_Source_Date__c =  Date.newInstance(2014, 1, 3);
        utpAccountJan.Lead_Source_Detail__c = 'utpAccountJan';
        utpAccountJan.Offer__c = 'utpAccountJan';
        utpAccountJan.Offer_Type__c = 'utpAccountJan';
        utpAccountJan.Product__c = 'UTP';
        acctLeadSources.add(utpAccountJan);
        
        Lead_Sources__c utpAccountFeb = new Lead_Sources__c();
        utpAccountFeb.Account__c = account.id;
        utpAccountFeb.Lead_Source__c = 'utpAccountFeb';
        utpAccountFeb.Lead_Source_Date__c =  Date.newInstance(2014, 2, 25);
        utpAccountFeb.Lead_Source_Detail__c = 'utpAccountFeb';
        utpAccountFeb.Offer__c = 'utpAccountFeb';
        utpAccountFeb.Offer_Type__c = 'utpAccountFeb';
        utpAccountFeb.Product__c = 'UTP';
        acctLeadSources.add(utpAccountFeb);
        
        Lead_Sources__c utpAccountJune = new Lead_Sources__c();
        utpAccountJune.Account__c = account.id;
        utpAccountJune.Lead_Source__c = 'utpAccountJune';
        utpAccountJune.Lead_Source_Date__c =  Date.newInstance(2014, 6, 12);
        utpAccountJune.Lead_Source_Detail__c = 'utpAccountJune';
        utpAccountJune.Offer__c = 'utpAccountJune';
        utpAccountJune.Offer_Type__c = 'utpAccountJune';
        utpAccountJune.Product__c = 'UTP';
        acctLeadSources.add(utpAccountJune);
        
        // UOC
        Lead_Sources__c uocAccountDec = new Lead_Sources__c();
        uocAccountDec.Account__c = account.id;
        uocAccountDec.Lead_Source__c = 'uocAccountDec';
        uocAccountDec.Lead_Source_Date__c =  Date.newInstance(2013, 12, 3);
        uocAccountDec.Lead_Source_Detail__c = 'uocAccountDec';
        uocAccountDec.Offer__c = 'uocAccountDec';
        uocAccountDec.Offer_Type__c = 'uocAccountDec';
        uocAccountDec.Product__c = 'UOC';
        acctLeadSources.add(uocAccountDec);
        
        Lead_Sources__c uocAccountFeb = new Lead_Sources__c();
        uocAccountFeb.Account__c = account.id;
        uocAccountFeb.Lead_Source__c = 'uocAccountFeb';
        uocAccountFeb.Lead_Source_Date__c =  Date.newInstance(2014, 2, 27);
        uocAccountFeb.Lead_Source_Detail__c = 'uocAccountFeb';
        uocAccountFeb.Offer__c = 'uocAccountFeb';
        uocAccountFeb.Offer_Type__c = 'uocAccountFeb';
        uocAccountFeb.Product__c = 'UOC';
        acctLeadSources.add(uocAccountFeb);
        
        Lead_Sources__c uocAccountNov = new Lead_Sources__c();
        uocAccountNov.Account__c = account.id;
        uocAccountNov.Lead_Source__c = 'uocAccountNov';
        uocAccountNov.Lead_Source_Date__c =  Date.newInstance(2014, 11, 12);
        uocAccountNov.Lead_Source_Detail__c = 'uocAccountNov';
        uocAccountNov.Offer__c = 'uocAccountNov';
        uocAccountNov.Offer_Type__c = 'uocAccountNov';
        uocAccountNov.Product__c = 'UOC';
        acctLeadSources.add(uocAccountNov);
        
        // LMFS
        Lead_Sources__c lmfsAccountDec = new Lead_Sources__c();
        lmfsAccountDec.Account__c = account.id;
        lmfsAccountDec.Lead_Source__c = 'lmfsAccountDec';
        lmfsAccountDec.Lead_Source_Date__c =  Date.newInstance(2013, 12, 3);
        lmfsAccountDec.Lead_Source_Detail__c = 'lmfsAccountDec';
        lmfsAccountDec.Offer__c = 'lmfsAccountDec';
        lmfsAccountDec.Offer_Type__c = 'lmfsAccountDec';
        lmfsAccountDec.Product__c = 'LMFS';
        acctLeadSources.add(lmfsAccountDec);
        
        Lead_Sources__c lmfsAccountFeb = new Lead_Sources__c();
        lmfsAccountFeb.Account__c = account.id;
        lmfsAccountFeb.Lead_Source__c = 'lmfsAccountFeb';
        lmfsAccountFeb.Lead_Source_Date__c =  Date.newInstance(2014, 2, 27);
        lmfsAccountFeb.Lead_Source_Detail__c = 'lmfsAccountFeb';
        lmfsAccountFeb.Offer__c = 'lmfsAccountFeb';
        lmfsAccountFeb.Offer_Type__c = 'lmfsAccountFeb';
        lmfsAccountFeb.Product__c = 'LMFS';
        acctLeadSources.add(lmfsAccountFeb);
        
        Lead_Sources__c lmfsAccountNov = new Lead_Sources__c();
        lmfsAccountNov.Account__c = account.id;
        lmfsAccountNov.Lead_Source__c = 'lmfsAccountNov';
        lmfsAccountNov.Lead_Source_Date__c =  Date.newInstance(2014, 11, 12);
        lmfsAccountNov.Lead_Source_Detail__c = 'lmfsAccountNov';
        lmfsAccountNov.Offer__c = 'lmfsAccountNov';
        lmfsAccountNov.Offer_Type__c = 'lmfsAccountNov';
        lmfsAccountNov.Product__c = 'LMFS';
        acctLeadSources.add(lmfsAccountNov);
        
        // USC
        Lead_Sources__c uscAccountDec = new Lead_Sources__c();
        uscAccountDec.Account__c = account.id;
        uscAccountDec.Lead_Source__c = 'uscAccountDec';
        uscAccountDec.Lead_Source_Date__c =  Date.newInstance(2013, 12, 3);
        uscAccountDec.Lead_Source_Detail__c = 'uscAccountDec';
        uscAccountDec.Offer__c = 'uscAccountDec';
        uscAccountDec.Offer_Type__c = 'uscAccountDec';
        uscAccountDec.Product__c = 'USC';
        acctLeadSources.add(uscAccountDec);
        
        Lead_Sources__c uscAccountFeb = new Lead_Sources__c();
        uscAccountFeb.Account__c = account.id;
        uscAccountFeb.Lead_Source__c = 'uscAccountFeb';
        uscAccountFeb.Lead_Source_Date__c =  Date.newInstance(2014, 2, 27);
        uscAccountFeb.Lead_Source_Detail__c = 'uscAccountFeb';
        uscAccountFeb.Offer__c = 'uscAccountFeb';
        uscAccountFeb.Offer_Type__c = 'uscAccountFeb';
        uscAccountFeb.Product__c = 'USC';
        acctLeadSources.add(uscAccountFeb);
        
        Lead_Sources__c uscAccountNov = new Lead_Sources__c();
        uscAccountNov.Account__c = account.id;
        uscAccountNov.Lead_Source__c = 'uscAccountNov';
        uscAccountNov.Lead_Source_Date__c =  Date.newInstance(2014, 11, 12);
        uscAccountNov.Lead_Source_Detail__c = 'uscAccountNov';
        uscAccountNov.Offer__c = 'uscAccountNov';
        uscAccountNov.Offer_Type__c = 'uscAccountNov';
        uscAccountNov.Product__c = 'USC';
        acctLeadSources.add(uscAccountNov);
        
        // lead testing
        
        Lead testLead = new Lead();
        testLead.FirstName = 'Tony';
        testLead.LastName = 'Stark';
        testLead.Email = 'ironman@test.com';
        testLead.Phone = '407-555-1212';
        insert testLead;
        
        list<Lead_Sources__c> leadLeadSources = new list<Lead_Sources__c>();
        
        // UTP
        Lead_Sources__c utpLeadJan = new Lead_Sources__c();
        utpLeadJan.Lead__c = testLead.id;
        utpLeadJan.Lead_Source__c = 'utpLeadJan';
        utpLeadJan.Lead_Source_Date__c =  Date.newInstance(2014, 1, 3);
        utpLeadJan.Lead_Source_Detail__c = 'utpLeadJan';
        utpLeadJan.Offer__c = 'utpLeadJan';
        utpLeadJan.Offer_Type__c = 'utpLeadJan';
        utpLeadJan.Product__c = 'UTP';
        leadLeadSources.add(utpLeadJan);
        
        Lead_Sources__c utpLeadFeb = new Lead_Sources__c();
        utpLeadFeb.Lead__c = testLead.id;
        utpLeadFeb.Lead_Source__c = 'utpLeadFeb';
        utpLeadFeb.Lead_Source_Date__c =  Date.newInstance(2014, 2, 25);
        utpLeadFeb.Lead_Source_Detail__c = 'utpLeadFeb';
        utpLeadFeb.Offer__c = 'utpLeadFeb';
        utpLeadFeb.Offer_Type__c = 'utpAccountFeb';
        utpLeadFeb.Product__c = 'UTP';
        leadLeadSources.add(utpLeadFeb);
        
        Lead_Sources__c utpLeadJune = new Lead_Sources__c();
        utpLeadJune.Lead__c = testLead.id;
        utpLeadJune.Lead_Source__c = 'utpLeadJune';
        utpLeadJune.Lead_Source_Date__c =  Date.newInstance(2014, 6, 12);
        utpLeadJune.Lead_Source_Detail__c = 'utpLeadJune';
        utpLeadJune.Offer__c = 'utpLeadJune';
        utpLeadJune.Offer_Type__c = 'utpLeadJune';
        utpLeadJune.Product__c = 'UTP';
        leadLeadSources.add(utpLeadJune);
        
        // UOC
        Lead_Sources__c uocLeadDec = new Lead_Sources__c();
        uocLeadDec.Lead__c = testLead.id;
        uocLeadDec.Lead_Source__c = 'uocLeadDec';
        uocLeadDec.Lead_Source_Date__c =  Date.newInstance(2013, 12, 3);
        uocLeadDec.Lead_Source_Detail__c = 'uocLeadDec';
        uocLeadDec.Offer__c = 'uocLeadDec';
        uocLeadDec.Offer_Type__c = 'uocLeadDec';
        uocLeadDec.Product__c = 'UOC';
        leadLeadSources.add(uocLeadDec);
        
        Lead_Sources__c uocLeadFeb = new Lead_Sources__c();
        uocLeadFeb.Lead__c = testLead.id;
        uocLeadFeb.Lead_Source__c = 'uocLeadFeb';
        uocLeadFeb.Lead_Source_Date__c =  Date.newInstance(2014, 2, 27);
        uocLeadFeb.Lead_Source_Detail__c = 'uocLeadFeb';
        uocLeadFeb.Offer__c = 'uocLeadFeb';
        uocLeadFeb.Offer_Type__c = 'uocLeadFeb';
        uocLeadFeb.Product__c = 'UOC';
        leadLeadSources.add(uocLeadFeb);
        
        Lead_Sources__c uocLeadNov = new Lead_Sources__c();
        uocLeadNov.Lead__c = testLead.id;
        uocLeadNov.Lead_Source__c = 'uocLeadNov';
        uocLeadNov.Lead_Source_Date__c =  Date.newInstance(2014, 11, 12);
        uocLeadNov.Lead_Source_Detail__c = 'uocLeadNov';
        uocLeadNov.Offer__c = 'uocLeadNov';
        uocLeadNov.Offer_Type__c = 'uocLeadNov';
        uocLeadNov.Product__c = 'UOC';
        leadLeadSources.add(uocLeadNov);
        
        // LMFS
        Lead_Sources__c lmfsLeadDec = new Lead_Sources__c();
        lmfsLeadDec.Lead__c = testLead.id;
        lmfsLeadDec.Lead_Source__c = 'lmfsLeadDec';
        lmfsLeadDec.Lead_Source_Date__c =  Date.newInstance(2013, 12, 3);
        lmfsLeadDec.Lead_Source_Detail__c = 'lmfsLeadDec';
        lmfsLeadDec.Offer__c = 'lmfsLeadDec';
        lmfsLeadDec.Offer_Type__c = 'lmfsLeadDec';
        lmfsLeadDec.Product__c = 'LMFS';
        leadLeadSources.add(lmfsLeadDec);
        
        Lead_Sources__c lmfsLeadFeb = new Lead_Sources__c();
        lmfsLeadFeb.Lead__c = testLead.id;
        lmfsLeadFeb.Lead_Source__c = 'lmfsLeadFeb';
        lmfsLeadFeb.Lead_Source_Date__c =  Date.newInstance(2014, 2, 27);
        lmfsLeadFeb.Lead_Source_Detail__c = 'lmfsLeadFeb';
        lmfsLeadFeb.Offer__c = 'lmfsLeadFeb';
        lmfsLeadFeb.Offer_Type__c = 'lmfsLeadFeb';
        lmfsLeadFeb.Product__c = 'LMFS';
        leadLeadSources.add(lmfsLeadFeb);
        
        Lead_Sources__c lmfsLeadNov = new Lead_Sources__c();
        lmfsLeadNov.Lead__c = testLead.id;
        lmfsLeadNov.Lead_Source__c = 'lmfsLeadNov';
        lmfsLeadNov.Lead_Source_Date__c =  Date.newInstance(2014, 11, 12);
        lmfsLeadNov.Lead_Source_Detail__c = 'lmfsLeadNov';
        lmfsLeadNov.Offer__c = 'lmfsLeadNov';
        lmfsLeadNov.Offer_Type__c = 'lmfsLeadNov';
        lmfsLeadNov.Product__c = 'LMFS';
        leadLeadSources.add(lmfsLeadNov);
        
        // USC
        Lead_Sources__c uscLeadDec = new Lead_Sources__c();
        uscLeadDec.Lead__c = testLead.id;
        uscLeadDec.Lead_Source__c = 'uscLeadDec';
        uscLeadDec.Lead_Source_Date__c =  Date.newInstance(2013, 12, 3);
        uscLeadDec.Lead_Source_Detail__c = 'uscLeadDec';
        uscLeadDec.Offer__c = 'uscLeadDec';
        uscLeadDec.Offer_Type__c = 'uscLeadDec';
        uscLeadDec.Product__c = 'USC';
        leadLeadSources.add(uscLeadDec);
        
        Lead_Sources__c uscLeadFeb = new Lead_Sources__c();
        //MSM uscLeadFeb.Account__c = account.id;
        uscLeadFeb.Lead__c = testLead.id;
        uscLeadFeb.Lead_Source__c = 'uscLeadFeb';
        uscLeadFeb.Lead_Source_Date__c =  Date.newInstance(2014, 2, 27);
        uscLeadFeb.Lead_Source_Detail__c = 'uscLeadFeb';
        uscLeadFeb.Offer__c = 'uscLeadFeb';
        uscLeadFeb.Offer_Type__c = 'uscLeadFeb';
        uscLeadFeb.Product__c = 'USC';
        leadLeadSources.add(uscLeadFeb);
        
        Lead_Sources__c uscLeadNov = new Lead_Sources__c();
        uscLeadNov.Account__c = account.id;
        uscLeadNov.Lead_Source__c = 'uscLeadNov';
        uscLeadNov.Lead_Source_Date__c =  Date.newInstance(2014, 11, 12);
        uscLeadNov.Lead_Source_Detail__c = 'uscLeadNov';
        uscLeadNov.Offer__c = 'uscLeadNov';
        uscLeadNov.Offer_Type__c = 'uscLeadNov';
        uscLeadNov.Product__c = 'USC';
        leadLeadSources.add(uscLeadNov);
        
        insert acctLeadSources;
        insert leadLeadSources;
        
        // start test
        
        test.startTest();
        
        Map<Id, Account> testAcctMap = new Map<Id, Account>();
        testAcctMap.put(account.Id, account);
        LeadSourceStamper acctStamper = new LeadSourceStamper();
        acctStamper.stampLeadSources(testAcctMap);
        
        Map<Id, Lead> testLeadMap = new Map<Id, Lead>();
        testLeadMap.put(testLead.Id, testLead);
        LeadSourceStamper leadStamper = new LeadSourceStamper();
        leadStamper.stampLeadSources(testLeadMap);
        
        List<Lead_Sources__c> testLeadSourceList = new List<Lead_Sources__c>();
        testLeadSourceList.addAll(acctLeadSources);
        testLeadSourceList.addAll(leadLeadSources);
        LeadSourceStamper sourceStamper = new LeadSourceStamper();
        sourceStamper.stampLeadSources(testLeadSourceList, true);
            
        test.stopTest();
    }
}