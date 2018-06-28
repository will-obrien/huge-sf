@isTest
public class UpdateParentAccountTest{

    @testSetup
    static void setup(){
        List<Account> accounts = new List<Account>();
        //add a parent account
        accounts.add(new Account(name = 'Parent'));
        //add 100 child accounts
        for (Integer i = 0; i < 100; i++) {
            accounts.add(new Account(name='Test Account ' + i));
        }
        insert accounts;
    }
    
    static testmethod void testQueueable() {
        //query for test data to pass to queueable class
        Id parentId = [SELECT Id FROM account WHERE name = 'Parent'][0].Id;
        
        List<Account> accounts = [SELECT Id, name FROM account WHERE name like 'Test Account%'];
        
        //Create our Queueable instance
        UpdateParentAccount updater = new UpdateParentAccount(accounts, parentId);
        
        //startTest/stopTest block to force async process to run
        Test.startTest();
            System.enqueueJob(updater);
        Test.stopTest();
        
        //Validate the job ran. Check if record have correct parentId now
        System.assertEquals(100,[SELECT count() FROM account WHERE parentId = :parentId],'Expected 100 children orgs');
    }
}