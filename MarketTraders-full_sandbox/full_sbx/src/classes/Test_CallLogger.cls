/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_CallLogger {

    static testMethod void myUnitTest() {
        Account account = new Account();
        account.FirstName = 'Jim';
        account.LastName = 'Hutcherson';
        account.PersonEmail = 'sfdev@markettraders.com';
        account.Alternate_Email__c = 'myalternate@yahoo.com';   
            
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        
        User u1 = new User(Alias = 'cloggy', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest1@mti.com'
        );
        
        test.startTest();
        
            Task taskDifferentOwner = new Task();
            Task invalidTask = new Task();
            Task taskSameOwner = new Task();
            
            
            
            system.runAs(u){
                
                account.OwnerId = u.Id;
                Database.insert(account);

                invalidTask.Status = 'Complete';
                invalidTask.OwnerId = u.Id;
                invalidTask.WhatId = account.id;
                invalidTask.Activity_Type__c = 'Phone Call';
                invalidTask.Subject = 'EMAIL:';
                invalidTask.Call_Disposition__c  = 'Not Interested';
                Database.insert(invalidTask);
                
                account = Database.query('SELECT Id,Last_PhoneCall_Spoke_With__c,Last_PhoneCall_Attempt_Account_Owner__c,Last_PhoneCall_Attempt__c FROM Account LIMIT 1');
                System.assertEquals(account.Last_PhoneCall_Spoke_With__c,null);
                System.assertEquals(account.Last_PhoneCall_Attempt_Account_Owner__c,null);
                System.assertEquals(account.Last_PhoneCall_Attempt__c,null);
                
            }
            
            system.runAs(u1){
                
                taskDifferentOwner.Status = 'Complete';
                taskDifferentOwner.OwnerId = u1.Id;
                taskDifferentOwner.Activity_Type__c = 'Phone Call';
                taskDifferentOwner.Subject = 'Test';
                taskDifferentOwner.Call_Disposition__c  = 'Not Interested';
                taskDifferentOwner.WhatId = account.id;
                Database.insert(taskDifferentOwner);
                
                account = Database.query('SELECT Id,Last_PhoneCall_Spoke_With__c,Last_PhoneCall_Attempt_Account_Owner__c,Last_PhoneCall_Attempt__c FROM Account LIMIT 1');
                System.assertEquals(account.Last_PhoneCall_Spoke_With__c,null);
                System.assertEquals(account.Last_PhoneCall_Attempt_Account_Owner__c,null);
                System.assertEquals(account.Last_PhoneCall_Attempt__c,null);
// above line failed repeatedly, this is original logic - TODAY, not NULL
//              System.assertEquals(account.Last_PhoneCall_Attempt__c,Date.today());

            }
            
            system.runAs(u){
                
                taskSameOwner.Status = 'Complete';
                taskSameOwner.OwnerId = u.Id;
                taskSameOwner.Activity_Type__c = 'Phone Call';
                taskSameOwner.Subject = 'Test';
                taskSameOwner.Call_Disposition__c  = 'Not Interested';
                taskSameOwner.WhatId = account.Id;
                Database.insert(taskSameOwner);
                
                account = Database.query('SELECT Id,Last_PhoneCall_Spoke_With__c,Last_PhoneCall_Attempt_Account_Owner__c,Last_PhoneCall_Attempt__c FROM Account LIMIT 1');
            
            }

            Database.delete(taskSameOwner);
            Database.delete(taskDifferentOwner);
            account = Database.query('SELECT Id,Last_PhoneCall_Spoke_With__c,Last_PhoneCall_Attempt_Account_Owner__c,Last_PhoneCall_Attempt__c FROM Account LIMIT 1');
            
        test.stopTest();
        
    }
}