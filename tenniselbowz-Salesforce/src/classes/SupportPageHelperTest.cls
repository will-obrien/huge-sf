@isTest
private class SupportPageHelperTest {

    static testMethod void sortRecordsTest(){
        SupportPageContTest.setupRecords();
        
        UnitTest.get('Contacts').divide(3).part('Contacts with One Matches')
                                       .part('Contacts with Two Matches')
                                       .part('Contacts with Three Matches');
        UnitTest.get('Contacts with One Matches').assign('LastName', 'Smith');
        UnitTest.get('Contacts with Two Matches').assign('LastName', 'Smithy');
        UnitTest.get('Contacts with Three Matches').assign('LastName', 'Blacksmith');
        
        SupportPageContTest.cont.proxyContact.lastName = 'Smith';
        
        UnitTest.get('Contacts with One Matches').assign('firstName', 'Taylor');
        UnitTest.get('Contacts with Two Matches').assign('firstName', 'John');
        UnitTest.get('Contacts with Three Matches').assign('firstName', 'John');
        
        SupportPageContTest.cont.proxyContact.firstName = 'John';
        
        UnitTest.get('Contacts with One Matches').assign('email', 'taylorsmith@test.com');
        UnitTest.get('Contacts with Two Matches').assign('email', 'johnsmith@test.com');
        UnitTest.get('Contacts with Three Matches').assign('email', 'johnsmith@realtest.com');
        
        SupportPageContTest.cont.proxyContact.email = 'johnsmith@realtest.com';
        
        List<Contact> allContacts = (List<Contact>) UnitTest.get('Contacts').getList(); 
        

        List<String> fieldsToReturn = new List<String>{'firstName', 'lastName', 'email'};

        Test.startTest();
            SupportPageCont.CheckboxWrapperList wrapperList = SupportPageHelper.sortRecords(fieldsToReturn, allContacts, SupportPageContTest.cont.proxyContact, new Map<ID, Integer>());
        Test.stopTest();
        
        System.AssertEquals(12, wrapperList.wrappers.size(), 'An incorrect number of wrappers returned');
        for(Integer i=0; i< 9; i++) {
            
            if(i < 4){
                System.Assert(UnitTest.getIds('Contacts with Three Matches').contains(wrapperList.wrappers[i].obj.id), 'The contact order has been set incorrectly');
            } else if(i < 8){
                System.Assert(UnitTest.getIds('Contacts with Two Matches').contains(wrapperList.wrappers[i].obj.id), 'The order has been set incorrectly');
            } else if(i < 12){
                System.Assert(UnitTest.getIds('Contacts with One Matches').contains(wrapperList.wrappers[i].obj.id), 'The order has been set incorrectly');
            } else {
                System.Assert(false, 'This contact does not exist in the contacts created by this test');
            }
          
        }
        
    }

    static testMethod void buildSearchQuery(){
        final String ACCOUNT_NAME = 'testAccount';
        final String ASSET_JOB_NAME = 'assetName';
        final String ASSET_SERIAL_NUMBER = '12345';
        final String CASE_NUMBER = '54321';
        final String INVALID_CASE_NUMBER = '54322';
        final Integer RECORD_LIMIT = 49500;

        Account acct = new Account(Name = ACCOUNT_NAME);
        insert acct;
        Order__c ordr = new Order__c(Job_Name__c = ASSET_JOB_NAME);
        insert ordr;
        Asset asst = new Asset(Name = 'testAsset', AccountId = acct.id, Order__c = ordr.id, SerialNumber = ASSET_SERIAL_NUMBER);
        insert asst;

        List<String> fieldsToDisplay = new List<String>{'AccountId', 'Account.Name', 'AssetId'};
        Set<String> fieldsToSearch = new Set<String>{'CaseNumber', 'AccountId', 'AssetId', 'Asset.Job_Name__c', 'Asset.SerialNumber', 'Account.Name'};
        Map<String, String> additionalFieldMaps = new Map<String, String>();
        String additionalQueryCondition = ' CaseNumber !=\'' + INVALID_CASE_NUMBER + '\' ';

        Case proxyCase = new Case();

        String expectedQuery = 'SELECT AccountId, Account.Name, AssetId FROM Case WHERE'
                              + ' Asset.SerialNumber = \'' + ASSET_SERIAL_NUMBER + '\' OR Account.Name = \'' + ACCOUNT_NAME + '\' OR CaseNumber = \'' + CASE_NUMBER + '\' OR ' 
                              + additionalQueryCondition + ' LIMIT ' + RECORD_LIMIT;

        Test.startTest();
        String returnedQuery = SupportPageHelper.buildSearchQuery(fieldsToDisplay, fieldsToSearch, proxyCase, additionalFieldMaps, '');
        System.assertEquals(null, returnedQuery);

        additionalFieldMaps.put('CaseNumber', CASE_NUMBER);
        proxyCase.Asset = asst;
        proxyCase.Account = acct;
        
        returnedQuery = SupportPageHelper.buildSearchQuery(fieldsToDisplay, fieldsToSearch, proxyCase, additionalFieldMaps, additionalQueryCondition);
        Test.stopTest();

        System.assertEquals(expectedQuery, returnedQuery);
    }
    
     static testMethod void buildSearchQuery_WithAndClause(){

        final Integer RECORD_LIMIT = 49500;

        List<String> fieldsToDisplay = new List<String>{'Email', 'FirstName', 'LastName'};
        Set<String> fieldsToSearch = new Set<String>{'Email'};
        Map<String, String> additionalFieldMaps = new Map<String, String>{'firstName;lastName' => 'John;Smith'};

        Contact proxyContact = new Contact(email = 'test@test.com');

        String expectedQuery = 'SELECT Email, FirstName, LastName FROM Contact WHERE Email = \'test@test.com\' OR (firstName LIKE \'%John%\' AND lastName LIKE \'%Smith%\')' 
                               + ' LIMIT ' + RECORD_LIMIT;

        Test.startTest();
            String returnedQuery = SupportPageHelper.buildSearchQuery(fieldsToDisplay, fieldsToSearch, proxyContact, additionalFieldMaps, '');
        Test.stopTest();

        System.assertEquals(expectedQuery, returnedQuery);
    }
    

    static testMethod void findRecordMatches(){
        SupportPageContTest.setupRecords();
        Contact queryObj = new Contact(firstName = 'Joe', lastName = 'Schmoe', email = 'jschmoe@test.com', accountId = SupportPageContTest.accounts[0].id);
        Contact proxyObjPartialMatch = new Contact(firstName = 'Joe', lastName = 'Smith', email = 'jsmith@test.com', accountId = SupportPageContTest.accounts[0].id);
        Contact proxyObjMatch = queryObj;
        
        
        Contact proxyObjWithAccountMatch = queryObj.clone(); 
        SupportPageContTest.accounts[1].name = 'Match Test';
        update SupportPageContTest.accounts[1];
        insert proxyObjWithAccountMatch;
        
        Contact queryObjForAccountMatch = [Select ID, firstname, lastname, email, accountid, account.name from Contact where ID =:  proxyObjWithAccountMatch.id limit 1];
        
        
        List<String> fieldsToReturn = new List<String>{'firstName', 'lastName', 'email', 'accountId'};

        Test.startTest();
            Integer hits = SupportPageHelper.findRecordMatches(fieldsToReturn, queryObj, proxyObjPartialMatch);
            System.assertEquals(2, hits, 'Returned an unexpected number of hits on the search objects');
            hits = SupportPageHelper.findRecordMatches(fieldsToReturn, queryObj, proxyObjMatch);
            System.assertEquals(4, hits, 'Returned an unexpected number of hits on the search objects');
            
            fieldsToReturn.add('account.name');
            hits = SupportPageHelper.findRecordMatches(fieldsToReturn, queryObjForAccountMatch, queryObjForAccountMatch);
            System.AssertEquals(5, hits, 'Returned an unexpected number of hits on the search objects');
            
        Test.stopTest();
    }
    
    static testMethod void sortByRelevance(){
        SupportPageContTest.setupRecords();
        Map<Integer, List<sObject>> relevanceMap = new Map<Integer, List<sObject>>{
            1=>new List<sObject>{SupportPageContTest.contacts[0], SupportPageContTest.contacts[1]},
            3=>new List<sObject>{SupportPageContTest.contacts[2]},
            4=>new List<sObject>{SupportPageContTest.contacts[3], SupportPageContTest.contacts[4]}
        };

        // Ordered from most relevant to least relevant based on above relevanceMap
        List<SupportPageCont.checkboxWrapper> cbw = new List<SupportPageCont.checkboxWrapper>{
            new SupportPageCont.checkboxWrapper(SupportPageContTest.contacts[3]),
            new SupportPageCont.checkboxWrapper(SupportPageContTest.contacts[4]),
            new SupportPageCont.checkboxWrapper(SupportPageContTest.contacts[2]),
            new SupportPageCont.checkboxWrapper(SupportPageContTest.contacts[0]),
            new SupportPageCont.checkboxWrapper(SupportPageContTest.contacts[1])
        };

        SupportPageCont.checkboxWrapperList expectedList = new SupportPageCont.checkboxWrapperList(cbw);

        Test.startTest();
            SupportPageCont.checkboxWrapperList actualList = SupportPageHelper.sortByRelevance(relevanceMap, 4);
        Test.stopTest();

        System.assertEquals(expectedList.wrappers.size(), actualList.wrappers.size(), 'Unexpected amount of search objects returned');
        for(Integer i = 0; i < expectedList.wrappers.size(); i++){
            System.assertEquals(expectedList.wrappers[i].obj.Id, expectedList.wrappers[i].obj.Id, 'Search Result has object in wrong order');
        }
    }
    
    
    static testMethod void findObjectAdditionalFieldMatchesTest(){
         SupportPageContTest.setupRecords();
         
         UnitTest.get('Contacts').divide(4).part('Contacts with No Matches')
                                       .part('Contacts with One Matches')
                                       .part('Contacts with Two Matches')
                                       .part('Contacts with Three Matches');
         UnitTest.get('Contacts with No Matches').assign('LastName', 'Smitty');
         UnitTest.get('Contacts with One Matches').assign('LastName', 'Smith');
         UnitTest.get('Contacts with Two Matches').assign('LastName', 'Smithy');
         UnitTest.get('Contacts with Three Matches').assign('LastName', 'Blacksmith');
        
         UnitTest.get('Contacts with No Matches').assign('firstName', 'Steven');
         UnitTest.get('Contacts with One Matches').assign('firstName', 'Taylor');
         UnitTest.get('Contacts with Two Matches').assign('firstName', 'John');
         UnitTest.get('Contacts with Three Matches').assign('firstName', 'John');
        
         UnitTest.get('Contacts with No Matches').assign('email', 'stevensmitty@test.com');
         UnitTest.get('Contacts with One Matches').assign('email', 'taylorsmith@test.com');
         UnitTest.get('Contacts with Two Matches').assign('email', 'johnsmith@test.com');
         UnitTest.get('Contacts with Three Matches').assign('email', 'johnsmith@realtest.com');
         
         Map<Id, Integer> additionalSearchMatchesMap = new Map<Id, Integer>();
         Map<String, String> additionalFields = new Map<String, String>{
                                                        'firstname' => 'John',
                                                        'lastname' => 'Smith',
                                                        'email' => 'johnsmith@realtest.com'};
         
         Map<Id, Integer> expectedAdditionalSearchMatchesMap = new Map<Id, Integer>(); 
         
         for(Id contactID : UnitTest.getids('Contacts with One Matches')) {
             expectedAdditionalSearchMatchesMap.put(contactID, 1);
         }
         for(Id contactID : UnitTest.getids('Contacts with Two Matches')){
            expectedAdditionalSearchMatchesMap.put(contactID, 2);
         }
         for(Id contactID : UnitTest.getids('Contacts with Three Matches')){
            expectedAdditionalSearchMatchesMap.put(contactID, 3);
         }
         
         Test.startTest();
             SupportPageHelper.findObjectAdditionalFieldMatches(UnitTest.get('Contacts').getList(), additionalFields, additionalSearchMatchesMap);
         Test.stopTest();
         
         System.AssertEquals(9, additionalSearchMatchesMap.keyset().size(), 'An incorrect number of matches have been found');
         System.AssertEquals(expectedAdditionalSearchMatchesMap, additionalSearchMatchesMap, 'An incorrect search match has been found');
         
    }
    static testMethod void findCaseAdditionalSearchMatches(){
         SupportPageContTest.setupRecords();
         UnitTest.get('Cases').divide(4).part('Cases with No Matches')
                                        .part('Cases with One Matches')
                                        .part('Cases with Two Matches')
                                        .part('Cases with Three Matches');
         UnitTest.get('Cases with No Matches').assign('Subject', 'Test Subject');
         UnitTest.get('Cases with One Matches').assign('Subject', 'Case Number 1234');
         UnitTest.get('Cases with Two Matches').assign('Subject', 'Case Number 522');
         UnitTest.get('Cases with Three Matches').assign('Subject', 'Case Number 312');
        
         UnitTest.get('Cases with No Matches').assign('Status', 'Open');
         UnitTest.get('Cases with One Matches').assign('Status', 'Close');
         UnitTest.get('Cases with Two Matches').assign('Status', 'Working');
         UnitTest.get('Cases with Three Matches').assign('Status', 'Working');
        
         UnitTest.get('Cases with No Matches').assign('Priority', 'Low');
         UnitTest.get('Cases with One Matches').assign('Priority', 'Medium');
         UnitTest.get('Cases with Two Matches').assign('Priority', 'High');
         UnitTest.get('Cases with Three Matches').assign('Priority', 'Urgent');
         
         
         Map<String, String> additionalFields = new Map<String, String>{'Priority'=>'Urgent',
                                                                        'Status'=>'Working',
                                                                        'Subject'=>'Case Number'};
         Map<Id, Integer> expectedCaseMatches = new Map<Id, Integer>();
         for(Id contactID : UnitTest.getids('Cases with One Matches')) {
             expectedCaseMatches.put(contactID, 1);
         }
         for(Id contactID : UnitTest.getids('Cases with Two Matches')){
            expectedCaseMatches.put(contactID, 2);
         }
         for(Id contactID : UnitTest.getids('Cases with Three Matches')){
            expectedCaseMatches.put(contactID, 3);
         }
         ID caseAssetMatchID = new List<ID>(UnitTest.getids('Cases with Three Matches'))[0];
         expectedCaseMatches.put(caseAssetMatchID, 4);
         
         Set<Id> caseAssetMatches = new Set<Id>{caseAssetMatchID};
         
         Test.startTest();
             Map<Id, Integer> additionalCaseMatches = SupportPageHelper.findCaseAdditionalSearchMatches(caseAssetMatches, additionalFields, (List<Case>) UnitTest.get('Cases').getList() ); 
         Test.stopTest();
         
         System.AssertEquals(9, additionalCaseMatches.keyset().size(), 'An incorrect number of matches have been found');
         System.AssertEquals(expectedCaseMatches, additionalCaseMatches, 'An incorrect search match has been found');
         
    }

    
}