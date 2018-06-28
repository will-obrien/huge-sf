/*
    Created by: Greg Hacic
    Last Update: 17 August 2015 by Greg Hacic
    Questions?: greg@interactiveties.com
    
    NOTES:
        - tests for localeFormattedDatetime.class (100.00% coverage)
*/
@isTest
private class localeFormattedDatetimeTest {
    
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
            localeFormattedDatetime controller = new localeFormattedDatetime();  //constructor for our Apex class
            controller.datetimeValue = DateTime.valueOf('2007-01-01 2:35:21'); //set the datetimeValue variable to 1 January 2007
            String methodResult = controller.getFormattedDatetime(); //call the getFormattedDatetime method
            System.assertEquals('1/1/2007 2:35 AM', methodResult); //validate the results
            Test.stopTest(); //stop testing context
        }
    }
    
    //French (Switzerland)
    static testMethod void be_BY_Test() {
        //BEGIN: perform some setup steps...
        UserRole role = [SELECT Id, Name FROM UserRole LIMIT 1]; //grab a UserRole entry
        Profile p = [SELECT Id FROM Profile LIMIT 1]; //grab a profile for a new testing user
        //create a test user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'test', Email = 'test@example.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test', LanguageLocaleKey = 'en_US', LastName = 'User', LocaleSidKey='fr_CH', ProfileId = p.Id, TimeZoneSidKey = 'America/Denver', UserName = 'def.123.uvw@example.com', UserRoleId = role.Id));
        insert users;
        //END: perform some setup steps...
        System.runAs(users[0]) { //run as the newly created User
            Test.startTest(); //denote testing context
            localeFormattedDatetime controller = new localeFormattedDatetime(); //constructor for our Apex class
            controller.datetimeValue = DateTime.valueOf('2005-03-07 5:02:21'); //set the datetimeValue variable to 7 March 2005
            String methodResult = controller.getFormattedDatetime(); //call the getFormattedDatetime method
            System.assertEquals('07.03.2005 05:02', methodResult); //validate the results
            Test.stopTest(); //stop testing context
        }
    }
    
    //Spanish (Venezuela)
    static testMethod void es_VE_Test() {
        //BEGIN: perform some setup steps...
        UserRole role = [SELECT Id, Name FROM UserRole LIMIT 1]; //grab a UserRole entry
        Profile p = [SELECT Id FROM Profile LIMIT 1]; //grab a profile for a new testing user
        //create a test user
        List<User> users = new List<User>();
        users.add(new User(Alias = 'test', Email = 'test@example.com', EmailEncodingKey = 'ISO-8859-1', FirstName = 'Test', LanguageLocaleKey = 'en_US', LastName = 'User', LocaleSidKey='es_VE', ProfileId = p.Id, TimeZoneSidKey = 'America/Denver', UserName = 'ghi.123.rst@example.com', UserRoleId = role.Id));
        insert users;
        //END: perform some setup steps...
        System.runAs(users[0]) { //run as the newly created User
            Test.startTest(); //denote testing context
            localeFormattedDatetime controller = new localeFormattedDatetime(); //constructor for our Apex class
            controller.datetimeValue = DateTime.newInstance(2011, 1, 3, 12, 41, 15); //set the datetimeValue variable to 3 January 2011
            String methodResult = controller.getFormattedDatetime(); //call the getFormattedDatetime method
            System.assertEquals('03/01/2011 12:41 PM', methodResult); //validate the results
            Test.stopTest(); //stop testing context
        }
    }

}