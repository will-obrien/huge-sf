@isTest
public class updateAccountSync_test{

     Static Account acc;

    static void testdata()
    {
        acc = new Account(name = 'Test Account1');
        insert acc;
        
        Contact c1 = new contact(lastname = 'Test Contact1', Last_Account_Sync__c = system.today() - 5, AccountID = acc.ID, email = 'testcontact1@contact.com');
        insert c1;
    }
    
    static testMethod void unitTest()
    {
           test.startTest();
           testdata();
           updateAccountSync uAccSync = new updateAccountSync('null');
           updateAccountSync uAccSync1 = new updateAccountSync('date');
           updateAccountSync uAccSync2 = new updateAccountSync(acc.Id);
           Database.executebatch(uAccSync);
           Database.executebatch(uAccSync1);
           Database.executebatch(uAccSync2);
           test.stopTest();
    }
    

}