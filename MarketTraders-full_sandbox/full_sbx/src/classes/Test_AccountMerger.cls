/*******************************
Created By Asha C. 4.13.15
Test class for account merging class : AccountMerger


***************************/

@isTest 
private class Test_AccountMerger {
    
    private static testMethod void unitTest(){
        
        list<Account> accounts = new list<Account>();
        
        Account initialAccount = new Account();
        initialAccount.FirstName = 'Jim';
        initialAccount.LastName = 'Hutcherson';
        initialAccount.PersonEmail = 'jhutcherson@markettraders.com';
        initialAccount.Alternate_Email__c = 'myalternate@yahoo.com';        
        accounts.add(initialAccount);
        
        Account duplicateAccount = new Account();
        duplicateAccount.FirstName = 'Jim';
        duplicateAccount.LastName = 'Hutcherson';
        duplicateAccount.PersonEmail = 'jhutcherson@markettraders.com';
        duplicateAccount.Alternate_Email__c = 'anotheremail@gmail.com';
        accounts.add(duplicateAccount);
        
        Account_Merger__c mergerSetting = new Account_Merger__c();
        mergerSetting.Name = 'Email';
        mergerSetting.Field_Name__c = 'PersonEmail';
        Database.insert(mergerSetting);
        
        Account_Merger__c mergerSettingAltEmail = new Account_Merger__c();
        mergerSettingAltEmail.Name = 'Alternate Email';
        mergerSettingAltEmail.Field_Name__c = 'Alternate_Email__c';
        Database.insert(mergerSettingAltEmail);
        
        Account_Merger__c mergerSettingAltPhone = new Account_Merger__c();
        mergerSettingAltPhone.Name = 'Phone';
        mergerSettingAltPhone.Field_Name__c = 'Phone';
        Database.insert(mergerSettingAltPhone);

        test.startTest();
            Database.insert(accounts);
        test.stopTest();

    }   
    
    private static testMethod void testBatch(){
        //custom setting
        List<AccountFieldBlacklist__c> testblacklist = new List<AccountFieldBlacklist__c>();
        AccountFieldBlacklist__c testblacklistfield1 = new AccountFieldBlacklist__c();
        testblacklistfield1.name = 'Phone';        
        testblacklistfield1.Field_APIName__c ='Phone';
        testblacklist.add(testblacklistfield1);
        insert testblacklist;
        
        //test accounts
        set<Id> accountIds = new set<Id>();
        Account initialAccount = new Account();
        initialAccount.FirstName = 'Jim';
        initialAccount.LastName = 'Hutcherson';
        initialAccount.Phone = '777-777-0777' ;
        initialAccount.PersonEmail = 'testemail@markettraders.com';
        initialAccount.Alternate_Email__c = 'myalternate@yahoo.com';
        Database.insert(initialAccount);
        
        Account initialAccount1 = new Account();
        initialAccount1.FirstName = 'TestAsha';
        initialAccount1.LastName = 'TestLastName';
        initialAccount1.Phone = '222-222-0222';
        initialAccount1.PersonEmail = 'testemail@markettraders.com';
        initialAccount1.Alternate_Email__c = 'myalternate@yahoo.com';
        Database.insert(initialAccount1);
        
        
        accountIds.add(initialAccount.Id);

        test.startTest();
            AccountMerger mergeAccounts = new AccountMerger(accountIds);
            Database.executeBatch(mergeAccounts,1);

            AccountMerger.updateMasterAccount(initialAccount.ID, initialAccount1);
            List<Account> listaccts = [Select Id, Phone from Account where id =: initialAccount1.id ];
               System.assertequals(1,listaccts.size());
            System.assertequals(initialAccount1.Phone, listaccts[0].Phone);  
        test.stopTest();
    }
    
    
        private static testMethod void testAtFuture(){
        //custom setting
        List<AccountFieldBlacklist__c> testblacklist = new List<AccountFieldBlacklist__c>();
        AccountFieldBlacklist__c testblacklistfield1 = new AccountFieldBlacklist__c();
        testblacklistfield1.name = 'Phone';        
        testblacklistfield1.Field_APIName__c ='Phone';
        testblacklist.add(testblacklistfield1);
        insert testblacklist;
        
        //test accounts
        set<Id> accountIds = new set<Id>();
        Account initialAccount = new Account();
        initialAccount.FirstName = 'Jim';
        initialAccount.LastName = 'Hutcherson';
        initialAccount.Phone = '222-222-0222';
        initialAccount.PersonEmail = 'testemail@markettraders.com';
        initialAccount.Alternate_Email__c = 'myalternate@yahoo.com';
        Database.insert(initialAccount);
        
        Account initialAccount1 = new Account();
        initialAccount1.FirstName = 'TestAsha';
        initialAccount1.LastName = 'TestLastName';
        initialAccount1.Phone = null;
        initialAccount1.PersonEmail = 'testemail@markettraders.com';
        initialAccount1.Alternate_Email__c = 'myalternate@yahoo.com';
        Database.insert(initialAccount1);
        
        
        accountIds.add(initialAccount.Id);

        test.startTest();
            AccountMerger.mergeaccountasynch(accountIds);

        test.stopTest();
        
            List<Account> listaccts = [Select Id, Phone from Account where id in :accountIds ];
            System.assertequals(1,listaccts.size());
            System.assertequals(initialAccount.Phone, listaccts[0].Phone);  
    }
}