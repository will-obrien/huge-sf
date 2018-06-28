public with sharing class HelloTest {
    
    public static void addHelloWorld(Account[] accs){
      for (Account l:accs){
         if (l.Description != 'Hello World')
         l.Description = 'Hello World';
      }
   }
    
}