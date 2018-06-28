@isTest
public class UpdatePortalContactInfoTest{
    
    static testmethod void testUpdatePortalContactInfo(){
        
        Account acc = new Account(Name = 'apttus test account', status__c= 'Included', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID());
        insert acc;
        
        Contact con = new Contact(LastName = 'testName', AccountId = acc.Id);
        insert con;
        
        Test.startTest();
        
            User loggedInUser = new User(Alias = 'standt', Email='loggedin.user1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = UserInfo.getProfileId(), 
            TimeZoneSidKey='America/Los_Angeles', UserName='loggedin.user1@testorg.com');

        System.runAs(loggedInUser) {
                
                Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User']; 
            
                User u = new User(Alias = 'standt', Email='standardportaluser_mozilla@testorg.com', 
                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles', UserName='standardportaluser_mozilla@testorg.com',
                    ContactId = con.Id, IsActive = true);
                    
                insert u;
                
                u.IsActive = false;
                update u;
                
        }
        
        Test.stopTest();
        
    }
}