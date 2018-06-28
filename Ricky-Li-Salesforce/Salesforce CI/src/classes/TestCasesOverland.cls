@isTest(SeeAllData=true)
Public Class TestCasesOverland{
    static testmethod void TestCasesOverland(){
    
    Account accounts = new Account(FirstName = 'Test', LastName = 'abc', Salutation = 'Mr.');
    insert accounts;

    Account abc = new Account(Name = 'Sta', BillingState='ON', BillingCountry = 'Canada');
    insert abc;

    Contact pqr = new Contact(LastName='Abc', AccountId = abc.Id);
    insert pqr;

   Booking__c booking =new Booking__c(Name = 'abc', Agent__c = pqr.Id);
   insert booking;

   Service__c service = new Service__c(Name = 'Service',booking__c=booking.Id);
   insert service;

   Tour_Evaluation__c te = new Tour_Evaluation__c(Account__c = accounts.Id, service__c = service.Id);
   insert te;

   TravellerServices__c ts = new TravellerServices__c(Account__c = accounts.Id, Service__c = service.Id, Unique_Id__c = '15161615161671');
   insert ts;
     
  ApexPages.StandardController sc = new ApexPages.standardController(te);

  //###################################
  PageReference pageRef = Page.CreateCaseTourOverland;
  Test.setCurrentPage(pageRef);
  pageRef.getParameters().put('id', String.valueOf(te.Id));
  CasesOverland myPageCon =new CasesOverland(sc );
  myPageCon.CreateCaseOverland();
  }
}