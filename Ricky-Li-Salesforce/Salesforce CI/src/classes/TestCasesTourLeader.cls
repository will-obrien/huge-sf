@isTest(SeeAllData=true)
Public Class TestCasesTourLeader{
    static testmethod void TestCasesTourLeader(){
    
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
     
   Tour_Evaluation_Leader__c tel = new Tour_Evaluation_Leader__c(Tour_evaluation__c = te.Id);
   insert tel;
     
  ApexPages.StandardController sc = new ApexPages.standardController(te);

  //###################################
  PageReference pageRef = Page.CreateCaseTourLeader;
  Test.setCurrentPage(pageRef);
  pageRef.getParameters().put('id', String.valueOf(tel.Id));
  CasesTourLeader myPageCon =new CasesTourLeader(sc );
  myPageCon.CreateCaseTourLeader();
  }
}