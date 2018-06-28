@isTest                              
private class TestCreateAccount{    

    
        
         static testmethod void testCreateAccountTrigger() {        
            Test.startTest();
            Contact objCon = new Contact(firstName = 'FNAME',LastName='LName',Email='Test@Test.com',GARP_Member_ID__c='321123',MailingCity='Jersey',MailingCountry='US',MailingPostalCode='08335',MailingState='NJ',MailingStreet='Test');
            insert objCon;

           Test.stopTest();       
        }
       
    }