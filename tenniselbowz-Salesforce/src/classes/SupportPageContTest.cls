@isTest
public class SupportPageContTest {

    @testVisible static SupportPageCont cont;
    @testVisible static List<Contact> contacts;
    @testVisible static List<Account> accounts;
    @testVisible static List<Case> cases;
    @testVisible static List<Case_Asset__c> caseAssets;
    @testVisible static List<Asset> assets;
    @testVisible static List<Order__c> orders;

    @testVisible static void setupRecords(){
        
        final Integer NUM_OF_ACCOUNTS = 12;
        final Integer NUM_OF_CONTACTS = 12;
        final Integer NUM_OF_CASES = 12;
        final Integer NUM_OF_ASSETS = 12;
        final Integer NUM_OF_ORDERS = 12;

        accounts = TestingUtils.createAccounts(NUM_OF_ACCOUNTS, 'Test Account', true);
        UnitTest.addData(accounts).tag('Accounts');
        
        contacts = TestingUtils.createContacts(NUM_OF_CONTACTS, accounts[0].Id, true);
        UnitTest.addData(contacts).tag('Contacts');
        
        orders = TestingUtils.createOrders(NUM_OF_ORDERS, true);
        UnitTest.addData(orders).tag('Orders');
        
        cases = TestingUtils.createCases(NUM_OF_CASES, 'Test case', true);
        UnitTest.addData(cases).tag('Cases');
        
        assets = TestingUtils.createAssets(NUM_OF_ASSETS, accounts[0], false);
        UnitTest.addData(assets).tag('Assets').property('Order__c').assignFrom('Orders').insertAll();
        
        caseAssets = TestingUtils.createCaseAssets(cases, assets, true);
        UnitTest.addData(caseAssets).tag('Case Assets');
        
        
        cont = new SupportPageCont();
    }
    
    static testMethod void selectRecord(){
        setupRecords();

        Test.startTest();
        try{
            cont.selectRecord();
            System.assert(false, 'Selected ID is not set, function should throw an exception');
        } catch (Exception e) {}

        cont.selectedId = UnitTest.get('Contacts').getList()[0].id;
        cont.selectRecord();
        System.assertEquals(UnitTest.get('Contacts').getList()[0].id, cont.selectedContact.id);

        cont.selectedId = UnitTest.get('Cases').getList()[0].id;
        cont.selectRecord();
        System.assertEquals(UnitTest.get('Cases').getList()[0].id, cont.selectedCase.id);
        Test.stopTest();
    }

    static testMethod void selectRecords(){
        setupRecords();

        SupportPageCont.checkboxWrapperList singleCaseList = new SupportPageCont.checkboxWrapperList(UnitTest.get('Cases').getList());
        singleCaseList.wrappers[0].isChecked = true;

        SupportPageCont.checkboxWrapperList multContactList = new SupportPageCont.checkboxWrapperList(UnitTest.get('Contacts').getList());
        for(Integer i = 0; i < multContactList.wrappers.size(); i++){
            if(Math.mod(i, 2) == 0){
                multContactList.wrappers[i].isChecked = true;
            }
        }

        List<Asset> expectedAssets = new List<Asset>();
        SupportPageCont.checkboxWrapperList multAssetList = new SupportPageCont.checkboxWrapperList(UnitTest.get('Assets').getList());
        for(Integer i = 0; i < multAssetList.wrappers.size(); i++){
            if(Math.mod(i, 2) == 0){
                multAssetList.wrappers[i].isChecked = true;
                expectedAssets.add((Asset)multAssetList.wrappers[i].obj);
            }
        }

        Test.startTest();
        cont.currentQueriedRecords = singleCaseList;
        cont.selectRecords();
        System.assertEquals((Case)singleCaseList.wrappers[0].obj, cont.selectedCase);

        cont.currentQueriedRecords = multContactList;
        cont.selectRecords();
        System.assert(ApexPages.hasMessages(), 'Page should have an error due to too many contacts selected');

        cont.currentQueriedRecords = multAssetList;
        cont.selectRecords();
        System.assertEquals(expectedAssets, cont.selectedAssets);
        Test.stopTest();
    }

    static testMethod void saveSelectedRecords(){
        setupRecords();

        Test.startTest();
        
        PageReference returnedPage = cont.saveSelectedRecords();
        System.assertEquals(null, returnedPage);
        System.assert(ApexPages.hasMessages(), 'Page should have an error due to no objects selected');

        cont.selectedContact = (Contact)UnitTest.get('Contacts').getList()[0];
        cont.selectedCase = (Case)UnitTest.get('Cases').getList()[0];
        cont.selectedAssets = (List<Asset>)UnitTest.get('Assets').getList();
        cont.selectedCase.ContactId = cont.selectedContact.Id;

        returnedPage = cont.saveSelectedRecords();
        System.assertNotEquals(null, returnedPage);
        System.assertEquals('/' + cont.selectedCase.id, returnedPage.getUrl());
        List<Task> dbTasks = [SELECT Id, WhoId FROM Task WHERE WhoId =: cont.selectedContact.Id];
        System.assert(dbTasks.size() == 1, 'Unexpected tasks returned: ' + dbTasks);

        Test.stopTest();
    }

    static testMethod void searchCases(){
        cont = new SupportPageCont();

        final String ACCOUNT_NAME = 'testAccount';
        final String ASSET_JOB_NAME = 'assetName';
        final String ASSET_SERIAL_NUMBER = '12345';
        final String CASE_NUMBER = '54321';
        final Integer RECORD_LIMIT = 20;


        Account matchAcct = new Account(Name = ACCOUNT_NAME);
        Account wrongAcct = new Account(Name = 'Wrong Account');
        insert new List<Account>{matchAcct, wrongAcct};
       
       
        contact matchCtc = TestingUtils.createContacts(1, matchAcct.id, false)[0];
        matchCtc.FirstName = 'John';
        matchCtc.LastName = 'Match';
        Contact wrongCtc = TestingUtils.createContacts(1, wrongAcct.id, false)[0];
        wrongCtc.FirstName = 'John';
        wrongCtc.LastName = 'Wrong';
        insert new List<Contact>{matchCtc, wrongCtc};

        Order__c matchOrder = new Order__c(Job_Name__c = ASSET_JOB_NAME, SO_Number__c = '123456789');
        Order__c wrongOrder = new Order__c(Job_Name__c = 'Wrong Job', SO_Number__c = '987654321');
        insert new List<Order__c>{matchOrder, wrongOrder};

        Asset matchAsset = new Asset(Name = 'testAsset', AccountId = matchAcct.id, Order__c = matchOrder.id, SerialNumber = ASSET_SERIAL_NUMBER);
        Asset wrongAsset = new Asset(Name = 'Wrong_Asset', AccountId = wrongAcct.id, Order__c = wrongOrder.id, SerialNumber = '555');
        insert new List<Asset>{matchAsset, wrongAsset};

        Case cse = TestingUtils.createCases(1, 'testCase', false)[0];
        cse.put('AssetId', matchAsset.Id);
        cse.put('AccountId', matchAcct.Id);
        cont.proxyCase = cse;

        cont.caseFieldsToDisplay = new List<String>{'Account.Name', 'AccountId', 'Asset.Id', 'Asset.Job_Name__c', 'Asset.SerialNumber', 'CaseNumber'};
        cont.caseFieldsToSearch = new Set<String>{'CaseNumber', 'AccountId', 'AssetId'};

        Case match0 = new Case(AssetId = wrongAsset.Id, AccountId = wrongAcct.Id);
        Case match1 = new Case(AssetId = wrongAsset.Id, AccountId = matchAcct.Id);
        Case match2 = new Case(AssetId = matchAsset.Id, AccountId = matchAcct.Id);
        Case match3 = new Case(AssetId = matchAsset.Id, AccountId = matchAcct.Id);
        insert new List<Case>{match0, match1, match2, match3};

        Case_Asset__c matchCA = new Case_Asset__c(Asset__c = matchAsset.Id, Case__c = match3.Id);
        Case_Asset__c wrongCA = new Case_Asset__c(Asset__c = wrongAsset.Id, Case__c = match0.Id);
        insert new List<Case_Asset__c>{matchCA, wrongCA};

        cont.proxySONumber_Case = '123456789';

        cont.proxyCaseNumber = [SELECT CaseNumber FROM Case WHERE Id =: match3.id LIMIT 1].CaseNumber;

        List<Case> expectedList = new List<Case>{match3, match2, match1};

        SupportPageCont.checkboxWrapperList expectedResult = new SupportPageCont.checkboxWrapperList(expectedList);

        Test.startTest();
        cont.searchCases();
        Test.stopTest();

        System.assertEquals(expectedResult.wrappers.size(), cont.currentQueriedRecords.wrappers.size());
        for(Integer i = 0; i < expectedResult.wrappers.size(); i++){
            System.assertEquals(expectedResult.wrappers[i].obj.id, cont.currentQueriedRecords.wrappers[i].obj.id);
        }
    }
  
    static testMethod void searchContactsTest(){
        setupRecords();
        
        cont.proxyContact = new Contact();
        
        UnitTest.get('Contacts').divide(4).part('Contacts with No Matches')
                                       .part('Contacts with One Matches')
                                       .part('Contacts with Two Matches')
                                       .part('Contacts with Three Matches');
        UnitTest.get('Contacts with No Matches').assign('LastName', 'Smitty');
        UnitTest.get('Contacts with One Matches').assign('LastName', 'Smith');
        UnitTest.get('Contacts with Two Matches').assign('LastName', 'Smithy');
        UnitTest.get('Contacts with Three Matches').assign('LastName', 'Smith');
        
        cont.proxyContact.lastName = 'Smith';
        
        UnitTest.get('Contacts with No Matches').assign('firstName', 'Steven');
        UnitTest.get('Contacts with One Matches').assign('firstName', 'Taylor');
        UnitTest.get('Contacts with Two Matches').assign('firstName', 'John');
        UnitTest.get('Contacts with Three Matches').assign('firstName', 'John');
        
        cont.proxyContact.firstName = 'John';
        
        UnitTest.get('Contacts with No Matches').assign('email', 'stevensmitty@test.com');
        UnitTest.get('Contacts with One Matches').assign('email', 'taylorsmith@test.com');
        UnitTest.get('Contacts with Two Matches').assign('email', 'johnsmith@test.com');
        UnitTest.get('Contacts with Three Matches').assign('email', 'johnsmith@realtest.com');
        
        cont.proxyContact.email = 'johnsmith@realtest.com';
        update contacts;
        
        
        cont.contactFieldsToSearch = new Set<String>{'FirstName', 'LastName', 'email'};
        
        Test.startTest();
            cont.searchContacts();
        Test.stopTest();
        
        
        Set<ID> firstResultGroup = UnitTest.getIds('Contacts with Three Matches');  
        Set<ID> secondResultGroup = UnitTest.getIds('Contacts with Two Matches'); 
        Set<ID> thirdResultGroup =  UnitTest.getIds('Contacts with One Matches');
        
        
        System.assertEquals(9, cont.currentQueriedRecords.wrappers.size(), 'Unexpected amount of Contacts returned from search');
        for(Integer i = 0; i < 9; i++){
            if(i>= 0 && i < 3){
                System.Assert(firstResultGroup.contains(cont.currentQueriedRecords.wrappers[i].obj.id), 'An incorrect Contact has been returned');
            } else if( i >= 3 && i < 6) {
                System.Assert(secondResultGroup.contains(cont.currentQueriedRecords.wrappers[i].obj.id), 'An incorrect Contact has been returned');
            } else if ( i >= 6 && i < 9) {
                System.Assert(thirdResultGroup.contains(cont.currentQueriedRecords.wrappers[i].obj.id), 'An incorrect Contact has been returned');
            } else {
                System.Assert(false, 'Index out of range');
            }
        }  
    }
    
    static testMethod void searchContactsTest_WithClauseTest(){
        setupRecords();
        
        cont.proxyContact = new Contact();
        
        UnitTest.get('Contacts').divide(4).part('Contacts with No Matches')
                                       .part('Contacts with One Matches')
                                       .part('Contacts with Two Matches')
                                       .part('Contacts with Three Matches');
        UnitTest.get('Contacts with No Matches').assign('email', 'stevensmitty@test.com');
        UnitTest.get('Contacts with One Matches').assign('email', 'johnsmith@realtest.com');
        UnitTest.get('Contacts with Two Matches').assign('email', 'johnsmith@realtest.com');
        UnitTest.get('Contacts with Three Matches').assign('email', 'johnsmith@realtest.com');

        UnitTest.get('Contacts with No Matches').assign('LastName', 'Smitty');
        UnitTest.get('Contacts with One Matches').assign('LastName', 'Taylor');
        UnitTest.get('Contacts with Two Matches').assign('LastName', 'Smithy');
        UnitTest.get('Contacts with Three Matches').assign('LastName', 'Smith');
        
        cont.proxyContact.lastName = 'Smith';
        
        UnitTest.get('Contacts with No Matches').assign('firstName', 'Steven');
        UnitTest.get('Contacts with Two Matches').assign('firstName', 'Jonny');
        UnitTest.get('Contacts with Three Matches').assign('firstName', 'John');
        cont.proxyContact.firstName = 'John';
        
        update contacts;
        
        
        cont.contactFieldsToSearch = new Set<String>{'email'};
        cont.proxyContact.email = 'johnsmith@realtest.com';
        cont.proxyFirstName = 'John';
        cont.proxyLastName = 'Smith';
        
        
        Test.startTest();
            cont.searchContacts();
        Test.stopTest();
        
        Set<ID> firstResultGroup = UnitTest.getIds('Contacts with Three Matches');  
        Set<ID> secondResultGroup = UnitTest.getIds('Contacts with Two Matches'); 
        Set<ID> thirdResultGroup =  UnitTest.getIds('Contacts with One Matches');
        
        System.assertEquals(9, cont.currentQueriedRecords.wrappers.size(), 'Unexpected amount of Contacts returned from search');
        for(Integer i = 0; i < 9; i++){
            if(i>= 0 && i < 3){
                System.Assert(firstResultGroup.contains(cont.currentQueriedRecords.wrappers[i].obj.id), 'An incorrect Contact has been returned');
            } else if( i >= 3 && i < 6) {
                System.Assert(secondResultGroup.contains(cont.currentQueriedRecords.wrappers[i].obj.id), 'An incorrect Contact has been returned');
            } else if ( i >= 6 && i < 9) {
                System.Assert(thirdResultGroup.contains(cont.currentQueriedRecords.wrappers[i].obj.id), 'An incorrect Contact has been returned');
            } else {
                System.Assert(false, 'Index out of range');
            }
        }  
    }
    
    static testMethod void searchAssetsTest(){
    
        setupRecords();
        
        UnitTest.get('Assets').divide(4).part('Assets with No Matches')
                                       .part('Assets with One Matches')
                                       .part('Assets with Two Matches')
                                       .part('Assets with Three Matches');

        cont.proxyAsset = new Asset(SerialNumber = '8888');
        cont.proxySONumber_Asset = '9999';
        cont.proxyGONumber_Asset = '7777';
        cont.proxySerialNumber = '12345';
        
        Map<Id, Order__c> orderMap = new Map<Id, Order__c>(orders);
        Map<Id, Case_Asset__c> assetIDToCaseAssetMap = new Map<Id, Case_Asset__c>();
        for(Case_Asset__c caAsset: caseAssets){
            assetIDToCaseAssetMap.put(caAsset.Asset__c, caAsset);
        } 
        
        List<Order__c> ordersToUpdate = new List<Order__c>();
        List<Case_Asset__c> caseAssetsToUpdate = new List<Case_Asset__c>();
        
        
        for ( Asset a : (List<Asset>) UnitTest.get('Assets with Three Matches').getList()) {
           Order__c o = orderMap.get(a.order__c);
           o.GO_Number__c = '7777';
           o.SO_Number__c = '9999';
           a.serialnumber = '8888';
           ordersToUpdate.add(o);
           
        }
        
        for ( Asset a : (List<Asset>) UnitTest.get('Assets with Two Matches').getList()) {
           Order__c o = orderMap.get(a.order__c);
           o.GO_Number__c = '7777';
           a.serialnumber = '8888';
           ordersToUpdate.add(o);
           
        }
        
        for ( Asset a : (List<Asset>) UnitTest.get('Assets with One Matches').getList()) {
           Order__c o = orderMap.get(a.order__c);
           o.GO_Number__c = '7777';
           ordersToUpdate.add(o);
        }
        
        update ordersToUpdate;
        update UnitTest.get('Assets').getList();
        
        
        cont.assetFieldsToSearch = new Set<String>{'go_number__c', 'so_number__c', 'serialnumber'};
        
        Test.startTest();
            cont.searchAssets();
        Test.stopTest();
        
        
        Set<ID> firstResultGroup = UnitTest.getIds('Assets with Three Matches');  
        Set<ID> secondResultGroup = UnitTest.getIds('Assets with Two Matches'); 
        Set<ID> thirdResultGroup =  UnitTest.getIds('Assets with One Matches');
        
        System.assertEquals(9, cont.currentQueriedRecords.wrappers.size(), 'Unexpected amount of Assets returned from search');
        for(Integer i = 0; i < 9; i++){
            if(i>= 0 && i < 3){
                System.Assert(firstResultGroup.contains(cont.currentQueriedRecords.wrappers[i].obj.id), 'An incorrect Asset has been returned in first group - ' + cont.currentQueriedRecords.wrappers[i]);
            } else if( i >= 3 && i < 6) {
                System.Assert(secondResultGroup.contains(cont.currentQueriedRecords.wrappers[i].obj.id), 'An incorrect Asset has been returned in second group - ' + cont.currentQueriedRecords.wrappers[i]);
            } else if ( i >= 6 && i < 9) {
                System.Assert(thirdResultGroup.contains(cont.currentQueriedRecords.wrappers[i].obj.id), 'An incorrect Asset has been returned in third group - ' + cont.currentQueriedRecords.wrappers[i]);
            } else {
                System.Assert(false, 'Index out of range');
            }
        }  
    }
    
    
    static testMethod void removeSelectedCaseTest(){
        Case ca = new Case();
        cont = new SupportPageCont (); 
        cont.selectedCase = ca;
        
        Test.startTest();
            cont.removeSelectedCase();
        Test.stopTest();
        
        System.AssertEquals(null, cont.selectedCase, 'The selected case should be removed');
        
    }
    
    static testMethod void editCaseTest(){
        
        Case ca = TestingUtils.createCases(1, 'Test case', true)[0];
        
        cont = new SupportPageCont (); 
        cont.selectedId = ca.id;
        
        PageReference ref;
        Test.startTest();
            ref = cont.editCase();
        Test.stopTest();
        
        System.AssertEquals(ca.id, cont.editableCase.id, 'An incorrect contact is set' );
        System.AssertEquals(null, ref, 'The page Reference should be returned as null');
        
    }
    
    
    static testMethod void removeSelectedContactTest(){
        Contact ourContact = new Contact();
        
        cont = new SupportPageCont (); 
        cont.selectedContact = ourContact;
        
        
        Test.startTest();
            cont.removeSelectedContact();
        Test.stopTest();
        
        System.AssertEquals(null, cont.selectedContact, 'The selected contact should be removed');
        
    }
  
  
    static testMethod void editContactTest(){
        
        Account acc = TestingUtils.createAccounts(1, 'Test Acc', true)[0];
        Contact ourContact = TestingUtils.createContacts( 1, acc.id, true)[0];
        
        cont = new SupportPageCont (); 
        cont.selectedId = ourContact.id;
        
        PageReference ref;
        Test.startTest();
            ref = cont.editContact();
        Test.stopTest();
        
        System.AssertEquals(ourContact.id, cont.editableContact.id, 'An incorrect contact is set' );
        System.AssertEquals(null, ref, 'The page Reference should be returned as null');
        
    }
    
    //Covering non-code setupobjects-- specifically FieldSets. 
    static testMethod void fieldSetCoverageTest(){
        
        cont = new SupportPageCont();
        Set<String> dummyFieldStrings;
        List<Schema.FieldSetMember> dummyFieldSet;
        Test.startTest();
            dummyFieldStrings = new Set<String>(cont.caseFieldsToDisplay);
            System.AssertNotEquals(null, dummyFieldStrings);
            dummyFieldStrings = new Set<String>(cont.assetFieldsToDisplay);
            System.AssertNotEquals(null, dummyFieldStrings);
            dummyFieldStrings = cont.caseFieldsToSearch;
            System.AssertNotEquals(null, dummyFieldStrings);
            dummyFieldStrings = new Set<String>(cont.contactFieldsToDisplay);
            System.AssertNotEquals(null, dummyFieldStrings);
            dummyFieldStrings = cont.contactFieldsToSearch;
            System.AssertNotEquals(null, dummyFieldStrings);
            dummyFieldSet = cont.accountFields;
            System.AssertNotEquals(null, dummyFieldSet);
        
        Test.stopTest();
        
        
    } 
}