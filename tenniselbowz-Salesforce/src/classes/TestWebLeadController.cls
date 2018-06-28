@isTest
private class TestWebLeadController {
  
  static testmethod void runTest(){
      
      //Create Lead with all Information.
      Lead leadTest = new Lead();
      leadTest.firstname = 'First Name';
      leadTest.lastname = 'Last Name';
      leadTest.company = 'Test Company';
      leadTest.CountryCode = 'AR';
      leadTest.StateCode = 'H';
      leadTest.City = 'Test City';
      leadTest.Email = 'test@test.com';
      leadTest.phone = '12324567890';
      leadTest.Description = 'This is Description';
      //leadTest.LeadSource='Contact Us Web Page';
      //insert(leadTest);                //Insert Lead
      
      
        // start the test execution context
        //Test.startTest();

        // set the test's page to your VF page (or pass in a PageReference)
        //Test.setCurrentPage(Page.LatamWebtoLead);

        // call the constructor
        WebLeadController testLead = new WebLeadController(new ApexPages.StandardController(leadTest));
        testLead.save();
      	leadTest.StateCode = '';
      	testLead.save();
        testLead.Cancel();
        // stop the test
        //Test.stopTest();

   }  
}