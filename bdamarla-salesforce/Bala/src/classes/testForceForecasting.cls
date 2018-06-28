@isTest
Public class testForceForecasting {
    static testMethod void insert_newUser(){
       User userToCreate = new User();
       userToCreate.FirstName = 'Sankar';
       userToCreate.LastName  = 'Damarla';
       userToCreate.Email     = 'sankar123.d@gmail.com';
       userToCreate.Username  = 'Test';
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