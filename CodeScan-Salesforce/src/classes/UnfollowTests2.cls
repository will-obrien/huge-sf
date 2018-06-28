@isTest
private class UnfollowTests2{
    //utility class to create dummy users
    public static List<User> createUsers(Long numUsers, string profileName){
        Profile p = [select id from profile where name=:profileName]; 
        List<user> users=new List<user>();
        for (Integer i=0; i<numUsers;i++){
            User u = new User(alias = 'user', email=profileName.replace(' ','')+'user'+i+'@testorg.com', 
                emailencodingkey='UTF-8', lastname='testUser'+i, languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, 
                timezonesidkey='America/Los_Angeles', username=profileName.replace(' ','')+'user'+i+'@testorg.com');
            users.add(u);
        }//for 1    
        insert users;
        return users;
    }//createUsers

    //utility class to create dummy data to test.  This custom object is used as standard objects tend to have validation rules, failing the insert of records
    public static List<Id> createUnfollowTestRecords(Long numRecords,Boolean Check, Date dat, DateTime datTim, Decimal dec, String em, String ph, String pick, string str,String ur ) {
        List<UnfollowTest__c> testRecords = new List<UnfollowTest__c>{};
        Integer i;
        for (i=0;i<numRecords;i++){
            UnfollowTest__c t = new UnfollowTest__c(Name='test'+i, String__c=str,Checkbox__c = Check,Date__c= dat, DateTime__c=datTim,  Decimal__c=Dec, Email__c=em, Phone__c=ph, Picklist__c=pick, URL__c=ur);
            testRecords.add(t);
        }//for
        insert testRecords;
        List<Id> Ids=new List<Id>();
        for (UnfollowTest__c t:testRecords){
            Ids.add(t.Id);
        }//for 1
        return Ids;
    }//createUnfollowTestRecords
    
    //utility class to create dummy Subscriptions to test
    public static List<EntitySubscription> createSubs(List<User> users, List<Id> recordIds){
        List<EntitySubscription> subs=new List<EntitySubscription>();
        for (User u: users){
            for (Id rId:recordIds){
                subs.add(new EntitySubscription(ParentId=rId, SubscriberId=u.Id));
            }//for 2
        }//for 1
        insert subs;
        return subs;
    }//createSubs

    //utility class to create rules 
    public static UnfollowRule__c createUR(Boolean Active, String urON,  String urFN, String urOperator, String urValue ,Double urDD) {
        UnfollowRule__c ur=new UnfollowRule__c(Active__c=Active, objectName__c=urON, fieldName__c=urFN, Operator__c=urOperator, Value__c=urValue,  daysDelay__c=urDD );
        return ur;
    }//createLSR

    //utility class that deletes the existing rules in case this app is already installed & this is an upgrade installation
    public static void cleanUpTestData() {
        List<UnfollowRule__c> urs=[Select ID from UnfollowRule__c LIMIT 100];
        List<UnfollowBatchJobsQueue__c> uqs = [SELECT Id FROM UnfollowBatchJobsQueue__c LIMIT 100];
        List<UnfollowTest__c> tRecs=[SELECT Id FROM UnfollowTest__c LIMIT 4000];
        List<UnfollowQueue__c> qRecs=[SELECT Id FROM UnfollowQueue__c LIMIT 4000];
        List<UnfollowRuleJob__c> jobs=[SELECT Id FROM UnfollowRuleJob__c LIMIT 500];
        
        delete urs;
        delete uqs;
        delete tRecs;
        delete qRecs;
        delete jobs;
    }//cleanUpTestData
    
    static testMethod void verifyDateTimeEqualsTodayDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='CreatedDate';
        String UROperator='equals TODAY';
        String URValue='TODAY';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';            
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyDateTimeEqualsTodayDelay

    static testMethod void verifyDateTimeEqualsTodayDelay2(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='createdDate';
        String UROperator='equals TODAY';
        String URValue='TODAY';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';           
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyDateTimeEqualsTodayDelay2



    static testMethod void verifyStringEqualsDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='String__c';
        String UROperator='eQuals';
        String URValue='Str';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str=URValue;
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Phone = '415-555-5555';
        String Email = 'test@test.com';
        String Url='www.test.com';       

        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Str='asdf';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyLeadStringEqualsDelay

    static testMethod void verifyStringNotEqualToDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='String__c';
        String UROperator='not equal to';
        String URValue='com  Pany';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str='asdf';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Phone = '415-555-5555';
        String Email = 'test@test.com';
        String Url='www.test.com';       
       
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Str=URValue;
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyStringNotEqualToDelay

    static testMethod void verifyDoubleGreaterThanDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='Decimal__c';
        String UROperator='greater than';
        String URValue='5';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';         
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);

        Dec=5;
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);
  
        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyDoubleGreaterThanDelay

    static testMethod void verifyDoubleLessThanDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='Decimal__c';
        String UROperator='less than';
        String URValue='5';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=4;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';           
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);

        Dec=5;
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);
  
        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyDoubleLessThanDelay

    static testMethod void verifyDoubleGreaterOrEqualDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='Decimal__c';
        String UROperator='greater or equal';
        String URValue='5';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=5;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';            
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);

        Dec=4;
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);
  
        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyDoubleGreaterOrEqualDelay

    static testMethod void verifyDoubleLessOrEqualDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='Decimal__c';
        String UROperator='less or equal';
        String URValue='5';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=4;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';           
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);

        Dec=6;
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyDoubleLessOrEqualDelay

    static testMethod void verifyStringContainsDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='String__c';
        String UROperator='contains';
        String URValue='testLe';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str='testLead';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';     
       
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Str='asdf';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyStringContainsDelay

    static testMethod void verifyStringDoesNotContainDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='String__c';
        String UROperator='does not contain';
        String URValue='1234';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';     
       
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Str=URValue;
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyStringDoesNotContainDelay

    static testMethod void verifyStringStartsWithDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='String__c';
        String UROperator='starts with';
        String URValue='test';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str='testLead';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';     
       
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Str='asdf';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyStringStartsWithDelay

    static testMethod void verifyPicklistEqualsDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='Picklist__c';
        String UROperator='equals';
        String URValue='2';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';            

        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);

        Pick='1';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyPicklistEqualsDelay

    static testMethod void verifyPicklistNotEqualToDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='Picklist__c';
        String UROperator='not equal to';
        String URValue='1';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';            
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);

        Pick='1';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyPicklistNotEqualToDelay

//* Apex is messing with me - the test passed with a standard field boolean, but fails with this custom field boolean - the record gets inserted with null value.
    static testMethod void verifyBooleanEqualsDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='Checkbox__c';
        String UROperator='equals';
        String URValue='TRUE';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='asdf';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';       
       
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Check=FALSE;
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyBooleanEqualsDelay
//*/

    static testMethod void verifyBooleanNotEqualToDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='Checkbox__c';
        String UROperator='not equal to';
        String URValue='FALSE';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str='asdf';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';       
       
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Check=FALSE;
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyBooleanNotEqualToDelay

    static testMethod void verifyPhoneContains555Delay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='Phone__c';
        String UROperator='contains';
        String URValue='555';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str='test';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';       
        
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Phone='415-536-1000';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyPhoneContains555Delay

    static testMethod void verifyEmailContainsGmailDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='Email__c';
        String UROperator='contains';
        String URValue='gmail';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str='test';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';       
        
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Email='bob@yahoo.com';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyEmailContainsGmailDelay


    static testMethod void verifyStringGreaterThanDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='String__c';
        String UROperator='greater than';
        String URValue='b';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str='c';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';       
        
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Str='a';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyStringGreaterThanDelay

    static testMethod void verifyStringLessThanDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='String__c';
        String UROperator='less than';
        String URValue='b';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';       
        
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Str='c';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyStringLessThanDelay


    static testMethod void verifyStringGreaterOrEqualDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=0;
        String URObjectName='UnfollowTest__c';
        String URFieldName='String__c';
        String UROperator='greater or equal';
        String URValue='b';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str='b';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';       
        
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Str='a';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyStringGreaterOrEqualDelay

    static testMethod void verifyStringLessOrEqualDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=1;
        String URObjectName='UnfollowTest__c';
        String URFieldName='String__c';
        String UROperator='less or equal';
        String URValue='b';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();


        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';       

        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        URDaysDelay=2;
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    
        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Str='c';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds];
        system.assertEquals(numRecordsToCreate,uqs.size());
    }//verifyStringLessOrEqualDelay

    //verify Job works
    //verify # batches, Object name, # records, # follows
    static testMethod void verifyReportingJobDetailsNoDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';

        Boolean Active=True;
        Double URDaysDelay=0;
        String URObjectName='UnfollowTest__c';
        String URFieldName='String__c';
        String UROperator='equals';
        String URValue='test';
        List<UnfollowRule__c> urs=new List<UnfollowRule__c>();

        String Str='test';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';       
        
        cleanUpTestData();
        
        urs.add(createUR(Active, URObjectName, URFieldName, UROperator, URValue, URDaysDelay ));    

        insert urs;
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        Str='wrongValue';
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        Test.StartTest();
            Boolean runFromButton=FALSE;
            unfollowExecute.unfollowQueueBatchJobs(runFromButton);
        Test.StopTest();

        //Adding purely to prevent wasted investigation if the unfollow methods fail, not the job inserts        
        List<EntitySubscription> es=[Select Id FROM EntitySubscription WHERE ParentId IN :recordIds];
        system.assertEquals(0,es.size());

        List<UnfollowRuleJob__c> jobs=[SELECT ID, DelayRuleJob__c,   NumFollows__c, NumRecords__c, NumRules__c, ObjectName__c FROM UnfollowRuleJob__c WHERE CreatedDate=TODAY];
        system.assertEquals(1,jobs.size());
        system.assertEquals(numRecordsToCreate*numUsersToCreate,jobs[0].NumFollows__c);//
        system.assertEquals(urs.size(),jobs[0].NumRules__c);
        system.assertEquals(URObjectName,jobs[0].ObjectName__c);
        system.assertEquals(FALSE, jobs[0].DelayRuleJob__c);
    }//verifyReportingJobDetailsNoDelay


    static testMethod void verifyReportingJobDetailsDelay(){
        Long numRecordsToCreate=2;
        Long numUsersToCreate=2;
        String profileName='System Administrator';
        Double URDaysDelay=2;

        String Str='a';
        Boolean Check=TRUE;
        String Pick='2';
        Double Dec=1000;
        String Phone = '415-555-1234';
        String email='bob@gmail.com';
        Date Dat=date.today();
        DateTime DatTim=dateTime.now();
        String Url='www.test.com';       
        
        cleanUpTestData();
        List<UnfollowQueue__c> pendingRecords=new List<UnfollowQueue__c>();
        
        List<Id> recordIds=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<User> users=createUsers(numUsersToCreate, profileName);
        List<EntitySubscription> subs=createSubs(users,recordIds);
        
        for(Id i:recordIds){
            pendingRecords.add(new UnfollowQueue__c(recordId__c=i,daysDelay__c=URdaysDelay, CriteriaMetDate__c=date.today()-URDaysDelay.intValue()));
        }//for 1
        
        //These are records that shouldn't be unfollowed today
        List<Id> recordIds2=createUnfollowTestRecords(numRecordsToCreate,Check, Dat, DatTim, Dec, Email, Phone, Pick, Str, Url);
        List<EntitySubscription> subs2=createSubs(users,recordIds2);

        for(Id i:recordIds2){
            pendingRecords.add(new UnfollowQueue__c(recordId__c=i,daysDelay__c=URdaysDelay, CriteriaMetDate__c=date.today()));
        }//for 1

        //Insert both the records that should be processed and those that shoudln't be processed today.
        insert pendingRecords;

        test.startTest();
            UnfollowRecordsDelayed.unfollowQueueDelayBatchJob();  
        test.stopTest();
        
        //Adding purely to prevent wasted investigation if the unfollow methods fail, not the job inserts        
        List<UnfollowQueue__c> uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds AND ScheduledUnfollowDate__c=TODAY];
        system.assertEquals(0,uqs.size());
        List<EntitySubscription> es=[SELECT Id FROM EntitySubscription WHERE ParentId IN:recordIds];
        system.assertEquals(0,es.size());   
             
        uqs=[SELECT Id, ScheduledUnfollowDate__c FROM UnfollowQueue__c WHERE recordId__c IN:recordIds2 AND ScheduledUnfollowDate__c!=TODAY];
        system.assertEquals(numRecordsToCreate,uqs.size());
        es=[SELECT Id FROM EntitySubscription WHERE ParentId IN:recordIds2];
        system.assertEquals(numRecordsToCreate*numUsersToCreate,es.size());

        //this is th real test
        List<UnfollowRuleJob__c> jobs=[SELECT ID, DelayRuleJob__c, NumFollows__c, NumRecords__c, NumRules__c, ObjectName__c FROM UnfollowRuleJob__c WHERE CreatedDate=TODAY];
        system.assertEquals(1,jobs.size());
        system.assertEquals(numRecordsToCreate*numUsersToCreate,jobs[0].NumFollows__c);
        system.assertEquals(TRUE, jobs[0].DelayRuleJob__c);
    }//verifyReportingJobDetailsDelay

    
}//UnfollowTests2