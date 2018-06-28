@IsTest(SeeAllData=true)
Private class BrochureRequest_TriggerAndClassTests {
 
  public static testmethod void BrochureAccountTest() {
          /* Billing - Traveller */
      Account acc = new Account(LastName='Test', BillingState='ON', BillingCountry='Canada',ShippingCountry='Canada', Salutation='Mr.');
      insert acc;
      if(acc.IsPersonAccount == true)
          System.assertEquals('CA', acc.ISOCountry__pc);
      else
          System.assertEquals(null, acc.ISOCountry__c);
      
      acc.BillingCountry = 'USA';
      update acc;
      if(acc.IsPersonAccount == true)
          System.assertEquals('US', acc.ISOCountry__pc);
      else
          System.assertEquals(null, acc.ISOCountry__c);
      
          /*Shipping - Traveller*/
      Account acc1 = new Account(LastName='Test',ShippingCountry='Canada', Salutation='Mr.');
      insert acc1;
      if(acc1.IsPersonAccount == true)
          System.assertEquals('CA', acc1.ISOCountry__pc);
      else
          System.assertEquals(null, acc1.ISOCountry__c);
      
      acc1.BillingCountry = 'USA';
      update acc1;
      if(acc.IsPersonAccount == true)
          System.assertEquals('US', acc1.ISOCountry__pc);
      else
          System.assertEquals(null, acc1.ISOCountry__c);
            
     
     /*BULK*/
/*      Integer i =0;
      List <Account> listAccount = new list<Account>();
      for(i=0; i < 50; i++){
          Account accounti = new Account(Name = 'Test'+i, BillingCountry = 'Canada');
          insert accounti;
          listAccount.add(accounti);
      }
     // insert listAccount;
      for(i=0; i < 50; i++){
          System.Debug('Testing' + listAccount[i].ISOCountry__c);
      }
      
      for(i=0; i < listAccount.size(); i++){
          if(listAccount[i].IsPersonAccount== false){
                  System.Debug('Hi');
                  System.assertEquals('CA', listAccount[i].ISOCountry__c);
              }
              
          else{
               System.Debug('hello');
              System.assertEquals('CA', listAccount[i].ISOCountry__pc);
          }
      }
*/
  }
  
  public static testmethod void BrochureContactTest() {
        
                  /*BULK*/
      Integer i =0;
      List <Account> listAccounts = new list<Account>();
      for(i=0; i < 100; i++){
          Account account = new Account(Name = 'Test'+i, BillingState='ON', BillingCountry = 'Canada');
          listAccounts.add(account);
      }
      insert listAccounts;
      
      list<Contact> listContact = new List <Contact>();
      for(i=0; i < 100; i++){
          Contact con10 = new Contact(LastName = 'Test2'+i, AccountId=listAccounts[i].Id);
          listContact.add(con10);
      }
      insert listContact; 
        
     Map <String, String> mapCountryISO = new Map <String, String>();
     Map <String, String> mapAgentAgencyId = new Map <String, String>();
     Map <String, String> mapIdAgencyMailingCountry = new Map <String, String>();
     Map <String, String> mapIdAgencyShippingCountry = new map <String, String>();
       
      list<Contact> ContactIds = new List <Contact>();
      for(i=0; i < 100; i++){
          Contact con11 = new Contact(LastName = 'Test2'+i, AccountId=listAccounts[i].Id);
         
          ContactIds.add(con11);
      }
      insert ContactIds;
      
       List <Account> listAgencyId = new list<Account>();
      for(i=0; i < 100; i++){
          Account account = new Account(Name = 'Test'+i, BillingState='ON', BillingCountry = 'Canada');
          
          listAgencyId.add(account);
      }
      insert listAgencyId;
       
       
       List <Contact> listContacts = [Select Id, MailingCountry, OtherCountry, ISOCountry__c, AccountId from Contact where Id in: ContactIds and isPersonAccount = false];
       List <Account> listAccount = [Select Id, ShippingCountry, BillingCountry from Account where isPersonAccount = false and Id in: listAgencyId];
       
        List <CountryToISO__c> listCountryToISO = [Select CountryName__c, ISO__c from CountrytoISO__c];
        for(CountrytoISO__c cti : listCountryToISO){
            mapCountryISO.put(cti.CountryName__c, cti.ISO__c);
        }
        
       
        System.Debug(mapCountryISO);
        
        for(Contact con : listContacts){
            mapAgentAgencyId.put(con.Id, con.AccountId);
        }
       
        for(Account acc : listAccount){
             mapIdAgencyMailingCountry.put(acc.Id, acc.BillingCountry);
             mapIdAgencyShippingCountry.put(acc.Id, acc.ShippingCountry);
        }
      
      Account acc = new Account(BillingCountry = 'Canada', BillingState='ON', ShippingCountry='USA', Name='test');
     // insert acc;
      
      Account acc1 = new Account(ShippingCountry = 'Canada', Name = 'test1');
     // insert acc1;
      
      Account acc2 = new Account(BillingCountry = 'Canada', BillingState='ON', Name = 'test1');
     // insert acc2;
      
      Account acc3 = new Account(Name = 'test1', BillingState='ON', BillingCountry = 'Canada');
      insert acc3;
        
      Contact con = new Contact(LastName = 'ConTest', MailingCountry='Canada', OtherCountry='USA', AccountId=acc.Id);
      Contact con1 = new Contact(LastName = 'ConTest1', MailingCountry='', OtherCountry='USA', AccountId=acc1.Id);
      Contact con2 = new Contact(LastName = 'ConTest2', AccountId=acc1.Id);
      Contact con3 = new Contact(LastName = 'ConTest3', AccountId=acc2.Id);
      Contact con4 = new Contact(LastName = 'ConTest3', AccountId=acc2.Id);
      Contact con5 = new Contact(LastName = 'ConTest4', AccountId=acc3.Id);
           
      insert con;
          System.assertEquals('CA', mapCountryISO.get(con.MailingCountry));
      insert con4;
          System.AssertEquals('CA', MapCountryISO.get(acc2.BillingCountry));
      insert con5;
          System.AssertEquals('CA', MapCountryISO.get(acc3.BillingCountry));
      con.MailingCountry = 'USA';
      update con;
      
      con5.MailingCountry = 'Canada';
      update con5;
          System.AssertEquals('CA', MapCountryISO.get(con5.MailingCountry));
      
 }
}