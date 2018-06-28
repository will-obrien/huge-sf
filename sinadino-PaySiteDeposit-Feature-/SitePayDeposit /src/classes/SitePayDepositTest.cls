@isTest
  private Class SitePayDepositTest{
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
          CloseDate = System.today(),
          AccountId = account.id,
          Deposit__c = 1000.00,
          StageName = 'Closed Won',
          Number_of_Guests__c = 111,
          Event_Date__c = Date.today().addDays(30),
          Event_START_Time__c = '08:00',
          Event_END_Time__c = '10:00'
          );
          insert opp;
      
           // optional for this test.     
          OpportunityContactRole ocr = new OpportunityContactRole(ContactId = contact.Id, IsPrimary = true, OpportunityId = opp.Id, Role='Decision Maker');
          insert ocr;
          
          
            Test.startTest();
                 PageReference pageRef = Page.SitePayDeposit;
                 Test.setCurrentPage(pageRef);
                 ApexPages.currentPage().getParameters().clear();
                 ApexPages.currentPage().getParameters().put('id',opp.Id);
                 PayDepositController controller = new PayDepositController();
                 System.assert(controller.disableSubmit == false, 'Expected field to be enabled or boolean value to be true unless opportunity does not have a primary contact ');
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
               
              name = 'thisTestOpp2',
              CloseDate = System.today(),
              AccountId = account.id,
              Deposit__c = 1000.00,
              StageName = 'Closed Won',
              Number_of_Guests__c = 111,
              Event_Date__c = Date.Today().addDays(1),
              Event_START_Time__c = '13:00',
              Event_END_Time__c = '18:00'
              );
              insert opp;
          
          
              OpportunityContactRole ocr = new OpportunityContactRole(ContactId = contact.Id, IsPrimary = true, OpportunityId = opp.Id);
              insert ocr;
              
              
                Test.startTest();
                        Test.setCurrentPage(Page.SitePayDeposit);
                        ApexPages.currentPage().getParameters().put('id',opp.Id);
                        PayDepositController controller = new PayDepositController();
                        controller.submitPayment();

                        pymt__paymentX__c[] results = [select Id from pymt__paymentX__c where pymt__opportunity__c = :opp.id];

                        System.assert(results != null && results.size() > 0 , 'The payment has not been created');
                 Test.stopTest();  
           }
 }