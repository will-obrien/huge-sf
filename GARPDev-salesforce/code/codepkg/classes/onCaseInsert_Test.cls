@isTest
public class onCaseInsert_Test {

    
    static void testData()
    {
          Profile p = [SELECT Id FROM Profile WHERE Id = '00e40000000iraa'];
          Account a1 = new Account(name = 'Test Account1', GARP_ID__c  = '101010');
          insert a1;
          User u = new user(TimeZoneSidKey = 'America/New_York',LocaleSidKey = 'en_US', ProfileId = p.Id, Username = 'testcontact@garp.com', CommunityNickname = 'GARP SYSTEM',Alias = 'GSystem',CurrencyIsoCode = 'USD', EmailEncodingKey = 'ISO-8859-1',LanguageLocaleKey = 'en_US',LastName = 'System', Email = 'testcontact@garp.com');
       	  insert u;
          Contact c1 = new contact(GARP_Member_ID__c = '101010',lastname = 'Garp System', AccountID = a1.ID, email = 'testcontact@garp.com');
          insert c1;
          
    }
   
    Static testMethod void unit_Test()
    {
        testData();
        test.startTest();
        ID recordType = RecordTypeHelper.GetRecordTypeId('Case','Marketing Request');
        case c = new case(recordTypeID = recordType,Department__c ='',Type = 'Request',Priority='Medium',Status='New',Origin='Email',Subject='Test Case',Description='BASIC INFO 1. Your Email Address: testcontact@garp.com  2. Department:Member Services  3. Which one of the following would you like to submit this request for? ');
       	insert c;
        test.stopTest();
        
    } 
    
}