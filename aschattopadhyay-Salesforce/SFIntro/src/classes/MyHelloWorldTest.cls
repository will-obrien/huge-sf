@isTest
private class MyHelloWorldTest {
   // Simple test of the method
   // MyHelloWorld.addHelloWorld(Account[])
   static testMethod void test_addHelloWorld()
   {
      // Set up test data set
      Account testAcct1 = new Account();
      Account testAcct2 = new Account(Description = 'Foo');
      Account[] accts = new Account[] { testAcct1, testAcct2 };
      
      // Execute code with test data
      MyHelloWorld.addHelloWorld(accts);  // call
      
      // Confirm results
      System.assertEquals('First Salesforce code in action', accts[0].Description);
      System.assertEquals('First Salesforce code in action', accts[1].Description);
   }
   
   // Simple test of the trigger helloWorldAccountTrigger
   static testMethod void test_helloWorldAccountTrigger()
   {
      // Set up test data set
      Account testAcct1 = new Account(Name='One');
      Account testAcct2 = new Account(Name='Two', Description = 'Foo');
      Account[] accts = new Account[] { testAcct1, testAcct2 };
      
      // Execute trigger with test data set
      insert accts;
      
      // Confirm results
      Account[] acctQuery = [SELECT Description FROM Account WHERE Id = :accts[0].Id OR Id = :accts[1].Id];
      System.assertEquals('First Salesforce code in action', acctQuery[0].Description);
      System.assertEquals('First Salesforce code in action', acctQuery[1].Description);
   }
}