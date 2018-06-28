@isTest
public class TestApexClass {
private static testMethod void verifyAccountDescriptionsWhereOverwritten(){

    // Perform our data preparation.
    List<Account> accounts = new List<Account>{};
        
    for(Integer i = 0; i < 200; i++){
        Account a = new Account(Name = 'Test Account ' + i);
        accounts.add(a);
    }

    // Start the test, this changes governor limit context to 
    // that of trigger rather than test. 
    Test.startTest();
   	
    // Insert the Account records that cause the trigger to execute.
    insert accounts; 	
    // Stop the test, this changes limit context back to test from trigger.
   Test.stopTest();

		
    // Query the database for the newly inserted records.
    
    List<Account> insertedAccounts = [SELECT Name, Description

          							FROM Account

                                      WHERE Id IN :accounts];

		
    // Assert that the Description fields contains the proper value now.
    for(Account a: insertedAccounts){
      System.assertEquals(
        'This Account is probably left over from testing. It should probably be deleted.', 
        a.Description);
    }
}

}