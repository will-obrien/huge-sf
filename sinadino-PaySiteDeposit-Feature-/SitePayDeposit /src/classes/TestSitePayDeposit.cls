@isTest
private Class TestSitePayDeposit{

  @isTest public static void testOpportunityOne(){
  
      // we are just instantiating test data
      Account account = new Account(name = 'Test Account');
      insert account;
      
      Contact contact = new Contact (firstname = 'John',
      lastname = 'Test',
      accountId = account.id,
      email = 'thelinviotester@test.com');
      insert contact;

      Opportunity opp = new Opportunity(
       
      name = 'thisTestOpp',
      AccountId = account.id,
      Deposit__c = 1000.00,
      StageName = 'Closed Won'
      );
      insert opp;
  
  
      OpportunityContactRole ocr = new OpportunityContactRole(ContactId = contact.Id, IsPrimary = true, OpportunityId = opp.Id, Role='Decision Maker');
      insert ocr;
      
      
        Test.startTest();
        // Given


        // When


        // Then
        Test.stopTest();  
   }
    
    @isTest static void testOpportunityTwo(){
  
      // we are just instantiating test data
      Account account = new Account(name = 'Test Account');
      insert account;
      
      Contact contact = new Contact (firstname = 'John',
      lastname = 'Test',
      accountId = account.id,
      email = 'thelinviotester@test.com');
      insert contact;

      Opportunity opp = new Opportunity(
       
      name = 'thisTestOpp',
      AccountId = account.id,
      Deposit__c = 1000,
      StageName = 'Closed Won'
      );
      insert opp;
  
  
      OpportunityContactRole ocr = new OpportunityContactRole(ContactId = contact.Id, IsPrimary = true, OpportunityId = opp.Id, Role='Decision Maker');
      insert ocr;
      
      
        Test.startTest();
        // Given


        // When


        // Then
        Test.stopTest();  
   }
}