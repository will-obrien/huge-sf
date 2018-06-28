@isTest(SeeAllData=true)
Public Class TestNextTourLeader{
    static testmethod void TestNextCEO(){
        
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
        
        Tour_Evaluation_Leader__c tel = new Tour_Evaluation_Leader__c(Tour_Evaluation__c = te.Id);
        insert tel;
        
        Tour_Evaluation_Leader__c tel1 = new Tour_Evaluation_Leader__c(Tour_Evaluation__c = te.Id);
        insert tel1;
        
        ApexPages.StandardController sc = new ApexPages.standardController(tel);
        PageReference pageRef = Page.NextTourLeader;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(tel.Id));
        NextTourLeader ptl = new NextTourLeader(sc);
        ptl.NextCEO();
    }
}