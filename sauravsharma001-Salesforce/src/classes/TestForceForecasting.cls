@isTest 
public class TestForceForecasting {
    static testMethod void insertNewUser() {
       
       User userToCreate = new User();
       
       // Do you recognize these fields?
       userToCreate.FirstName = 'David';
       userToCreate.LastName  = 'Liu';
       userToCreate.Email     = 'dvdkliu@gmail.com';
       userToCreate.Username  = 'sfdc-dreamer@gmail.com';
       userToCreate.Alias     = 'fatty';
       userToCreate.ProfileId = '00ei0000000rTfp';
         
       // Don't worry about these
       userToCreate.TimeZoneSidKey    = 'America/Denver';
       userToCreate.LocaleSidKey      = 'en_US';
       userToCreate.EmailEncodingKey  = 'UTF-8';
       userToCreate.LanguageLocaleKey = 'en_US';
       
       insert userToCreate;
    }
}