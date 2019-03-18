@isTest
public class AddPrimaryContactTest {
/*
In the test class, insert 50 Account records for BillingState "NY" and 50 Account records for BillingState "CA". 
Create an instance of the AddPrimaryContact class, enqueue the job and assert that a Contact record was inserted for each of the 
50 Accounts with the BillingState of "CA".
*/
    @testSetup
    static void setup(){
        List <Account> accounts = new List<Account>();
        for(Integer i = 1; i <=100; i ++){
            if (i <=50) {
                accounts.add(new Account(name = 'Test Account ' + i, BillingState = 'NY'));
            }
            else {
                accounts.add(new Account(name = 'Test Account ' + i, BillingState = 'CA'));
            }

        }
        insert accounts;
    }

    static testMethod void testQueuable() {
        Contact cont = new Contact();
        cont.FirstName = 'John';
        cont.LastName = 'Dow';
        insert cont;

        String state = 'CA';

        AddPrimaryContact apc = new AddPrimaryContact(cont, state);
        Test.startTest();
            System.enqueueJob(apc);
        Test.stopTest();            
    }
}