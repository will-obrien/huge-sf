/*
    Created by: Greg Hacic
    Last Update: 11 August 2015 by Greg Hacic
    Questions?: greg@interactiveties.com
    
    NOTES:
        - tests for localeFormattedDate.class (100.00% coverage)
*/
@isTest
private class localeFormattedDateTest {
    
    //English (United States)
    static testMethod void en_US_Test() {
        //BEGIN: perform some setup steps...
        UserRole role = [SELECT Id, Name FROM UserRole LIMIT 1]; //grab a UserRole entry
        Profile p = [SELECT Id FROM Profile LIMIT 1]; //grab a profile for a new testing user
        //create a test user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'test', Email = 'test@example.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test', LanguageLocaleKey = 'en_US', LastName = 'User', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Denver', UserName = 'abc.123.xyz@example.com', UserRoleId = role.Id));
        insert users;
        //END: perform some setup steps...
        System.runAs(users[0]) { //run as the newly created User
            Test.startTest(); //denote testing context
            localeFormattedDate controller = new localeFormattedDate(); //constructor for our Apex class
            controller.dateValue = Date.valueOf('2007-01-01'); //set the dateValue variable to 1 January 2007
            String methodResult = controller.getFormattedDate(); //call the getFormattedDate method
            System.assertEquals('1/1/2007', methodResult); //validate the results
            Test.stopTest(); //stop testing context
        }
    }
    
    //Belarusian (Belarus)
    static testMethod void be_BY_Test() {
        //BEGIN: perform some setup steps...
        UserRole role = [SELECT Id, Name FROM UserRole LIMIT 1]; //grab a UserRole entry
        Profile p = [SELECT Id FROM Profile LIMIT 1]; //grab a profile for a new testing user
        //create a test user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'test', Email = 'test@example.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test', LanguageLocaleKey = 'en_US', LastName = 'User', LocaleSidKey='be_BY', ProfileId = p.Id, TimeZoneSidKey = 'America/Denver', UserName = 'def.123.uvw@example.com', UserRoleId = role.Id));
        insert users;
        //END: perform some setup steps...
        System.runAs(users[0]) { //run as the newly created User
            Test.startTest(); //denote testing context
            localeFormattedDate controller = new localeFormattedDate(); //constructor for our Apex class
            controller.dateValue = Date.valueOf('2005-03-07'); //set the dateValue variable to 7 March 2005
            String methodResult = controller.getFormattedDate(); //call the getFormattedDate method
            System.assertEquals('7.3.2005', methodResult); //validate the results
            Test.stopTest(); //stop testing context
        }
    }
    
    //Chinese (Taiwan)
    static testMethod void zh_TW_Test() {
        //BEGIN: perform some setup steps...
        UserRole role = [SELECT Id, Name FROM UserRole LIMIT 1]; //grab a UserRole entry
        Profile p = [SELECT Id FROM Profile LIMIT 1]; //grab a profile for a new testing user
        //create a test user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'test', Email = 'test@example.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test', LanguageLocaleKey = 'zh_TW', LastName = 'User', LocaleSidKey='zh_TW', ProfileId = p.Id, TimeZoneSidKey = 'America/Denver', UserName = 'ghi.123.rst@example.com', UserRoleId = role.Id));
        insert users;
        //END: perform some setup steps...
        System.runAs(users[0]) { //run as the newly created User
            Test.startTest(); //denote testing context
            localeFormattedDate controller = new localeFormattedDate(); //constructor for our Apex class
            controller.dateValue = Date.newInstance(2011, 1, 3); //set the dateValue variable to 3 January 2011
            String methodResult = controller.getFormattedDate(); //call the getFormattedDate method
            System.assertEquals('2011/1/3', methodResult); //validate the results
            Test.stopTest(); //stop testing context
        }
    }

}