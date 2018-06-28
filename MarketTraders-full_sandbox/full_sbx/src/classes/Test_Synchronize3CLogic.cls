@IsTest
global class Test_Synchronize3CLogic {


    private static testMethod void testInsertNon3CUser() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=false,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        
        Account testAccount = testFactory.getTestPersonAccount(true);
        Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
        system.runAs(u){
            testOpp.OwnerId = u.Id;
            testOpp.StageName = 'New Deal';
            Database.insert(testOpp);
            testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
            system.assertEquals('INSERT',testOpp.X3CLogic_Status__c);
        }

        test.startTest();
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(false));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();
    }

    
    private static testMethod void testInsert() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        
        Account testAccount = testFactory.getTestPersonAccount(true);
        Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
        system.runAs(u){
            testOpp.OwnerId = u.Id;
            testOpp.StageName = 'New Deal';
            Database.insert(testOpp);
            testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
            system.assertEquals('INSERT',testOpp.X3CLogic_Status__c);
        }

        test.startTest();
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(false));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();
    }
    
    private static testMethod void testReplace() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        
        Account testAccount = testFactory.getTestPersonAccount(true);
        Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
        system.runAs(u){
            testOpp.OwnerId = u.Id;
            testOpp.StageName = 'Attempted 1';
            Database.insert(testOpp);
            testOpp.StageName = 'New Deal';
            Database.update(testOpp);
            testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
            system.assertEquals('REPLACE',testOpp.X3CLogic_Status__c);
        }

        test.startTest();
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(false));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();
    }
    
    private static testMethod void testReplaceOwnerChange() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        Database.insert(u);
        
        User u1 = new User(Alias = 'cloggx1', Email='standarduser1@testorg1.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest1@mti1.com'
        );
        Database.insert(u1);
        
        Account testAccount = testFactory.getTestPersonAccount(true);
        Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
        system.runAs(u){
            testOpp.OwnerId = u.Id;
            testOpp.StageName = 'Attempted 1';
            Database.insert(testOpp);
            testOpp.StageName = 'New Deal';
            testOpp.OwnerId = u1.Id;
            Database.update(testOpp);
            testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
            system.assertEquals('REPLACE',testOpp.X3CLogic_Status__c);
        }

        test.startTest();
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(false));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();
    }
    
    private static testMethod void testRemove() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        
        Account testAccount = testFactory.getTestPersonAccount(true);
        Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
        system.runAs(u){
            testOpp.OwnerId = u.Id;
            testOpp.StageName = 'New Deal';
            Database.insert(testOpp);
            testOpp.StageName = 'Closed Lost';
            Database.update(testOpp);
            testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
            system.assertEquals('REMOVE',testOpp.X3CLogic_Status__c);
        }

        test.startTest();
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(false));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();        
    }
    
    private static testMethod void testInsertFailure() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        
        Account testAccount = testFactory.getTestPersonAccount(true);
        Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
        system.runAs(u){
            testOpp.OwnerId = u.Id;
            testOpp.StageName = 'New Deal';
            Database.insert(testOpp);
            testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
            system.assertEquals('INSERT',testOpp.X3CLogic_Status__c);
        }

        test.startTest();
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(true));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();
    }
    
    private static testMethod void testReplaceFailure() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );

        Account testAccount = testFactory.getTestPersonAccount(true);
        Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
        system.runAs(u){
            testOpp.OwnerId = u.Id;
            testOpp.StageName = 'Attempted 1';
            Database.insert(testOpp);
            testOpp.StageName = 'New Deal';
            Database.update(testOpp);
            testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
            system.assertEquals('REPLACE',testOpp.X3CLogic_Status__c);
        }
        
        test.startTest();
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(true));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();
    }
    
    private static testMethod void testRemoveFailure() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        
        Account testAccount = testFactory.getTestPersonAccount(true);
        Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
        system.runAs(u){
            testOpp.OwnerId = u.Id;
            testOpp.StageName = 'New Deal';
            Database.insert(testOpp);
            testOpp.StageName = 'Closed Lost';
            Database.update(testOpp);
            testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
            system.assertEquals('REMOVE',testOpp.X3CLogic_Status__c);
        }

        test.startTest();
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(true));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();        
    }
    
    private static testMethod void testInsertCriticalFailure() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        test.startTest();
            Account testAccount = testFactory.getTestPersonAccount(true);
            Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
            system.runAs(u){
                testOpp.OwnerId = u.Id;
                testOpp.StageName = 'New Deal';
                Database.insert(testOpp);
                testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
                system.assertEquals('INSERT',testOpp.X3CLogic_Status__c);
            }

        
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(true));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();
    }
    
    private static testMethod void testReplaceCriticalFailure() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        test.startTest();   
            Account testAccount = testFactory.getTestPersonAccount(true);
            Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
            system.runAs(u){
                testOpp.OwnerId = u.Id;
                testOpp.StageName = 'Attempted 1';
                Database.insert(testOpp);
                testOpp.StageName = 'New Deal';
                Database.update(testOpp);
                testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
                system.assertEquals('REPLACE',testOpp.X3CLogic_Status__c);
            }
        
        
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(true));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();
    }
    
    private static testMethod void testRemoveCriticalFailure() {
        mti_TestFactory testFactory = new mti_TestFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'cloggx', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, X3CLogic_Active__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='callloggertest@mti.com'
        );
        test.startTest();
            Account testAccount = testFactory.getTestPersonAccount(true);
            Opportunity testOpp = testFactory.getTestOpportunity(testAccount,'UTP OnDemand', false);
            system.runAs(u){
                testOpp.OwnerId = u.Id;
                testOpp.StageName = 'New Deal';
                Database.insert(testOpp);
                testOpp.StageName = 'Closed Lost';
                Database.update(testOpp);
                testOpp = [SELECT Id,OwnerId,Owner_Name__c,x3Clogic_Stage_Score__c,Account_Phone__c,Account_Email__c,StageName,Product__c,Account_First_Name__c,Account_Last_Name__c,X3CLogic_Previous_Owner__c,X3CLogic_Status__c,X3CLogic_Previous_Owner__r.FirstName,X3CLogic_Previous_Owner__r.LastName FROM Opportunity WHERE Id = :testOpp.Id];
                system.assertEquals('REMOVE',testOpp.X3CLogic_Status__c);
            }

        
            test.setMock(HttpCalloutMock.class,new X3CLogicCallout(true));
            Synchronize_3CLogic syncManager = new Synchronize_3CLogic(testOpp);
            syncManager.synchronize();
        test.stopTest();        
    }



    global class X3CLogicCallout implements HttpCalloutMock {
        
        private boolean isFailure;
        
        public X3CLogicCallout(boolean isFailure) {
            this.isFailure = isFailure;
        }
        
        global HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            if(this.isFailure)
                res.setBody('{"result":"ERROR"}');
            else
                res.setBody('{"result":"SUCCESS"}');
            return res;
        }
        
    }



}