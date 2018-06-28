@isTest(seeAllData=True)
public with sharing class BKSL_SyncEvent_UT {
    static testMethod void BKSL_SyncEvent_Test(){
    BKSL2__Working_Hours__c objWHnew = new BKSL2__Working_Hours__c();
        objWHnew.BKSL2__Working_Hour_Name__c = 'TEST WORKING HOUR';
        objWHnew.BKSL2__Active__c = true;
        objWHnew.BKSL2__Sunday_Start_Time__c = '6:00 AM';
        objWHnew.BKSL2__Sunday_End_Time__c = '11:00 PM';
        objWHnew.BKSL2__Monday_Start_Time__c = '6:00 AM';
        objWHnew.BKSL2__Monday_End_Time__c = '11:00 PM';
        objWHnew.BKSL2__Tuesday_Start_Time__c = '6:00 AM';
        objWHnew.BKSL2__Tuesday_End_Time__c = '11:00 PM';
        objWHnew.BKSL2__Wednesday_Start_Time__c = '6:00 AM';
        objWHnew.BKSL2__Wednesday_End_Time__c = '11:00 PM';
        objWHnew.BKSL2__Thursday_Start_Time__c = '6:00 AM';
        objWHnew.BKSL2__Thursday_End_Time__c = '11:00 PM';
        objWHnew.BKSL2__Friday_Start_Time__c = '6:00 AM';
        objWHnew.BKSL2__Friday_End_Time__c = '11:00 PM';
        objWHnew.BKSL2__Saturday_Start_Time__c = '6:00 AM';
        objWHnew.BKSL2__Saturday_End_Time__c = '11:00 PM';
        insert objWHnew;
    //Account create to assign oppurtunity
        Account objAccount = new Account();
        objAccount.Lastname = 'Vinu test';
        objAccount.PersonEmail = 'vinu@gmail.com';
        Insert objAccount;
        
    //Contact Create to assign service request
        Contact conDet = new Contact();
        conDet.firstName = 'Vinu';
        conDet.Lastname = 'Test';
        conDet.Email = 'Vinu@gmail.com';
        conDet.HasOptedOutOfEmail = False;
        insert conDet;
        
    //Create Service 
        BKSL2__Service__c newService = new BKSL2__Service__c();
        newService.Name = 'New Service';
        newService.BKSL2__Provider__c ='testDemo';
        newService.BKSL2__Working_Hours__c = objWHnew.Id;
        newService.BKSL2__Active__c = true;
        newService.BKSL2__Duration_Time__c = 30.00;
        newService.BKSL2__Duration_Unit__c = 'Minutes';
        newService.BKSL2__Availability_Count__c = 100;
        insert newService;
        
    //COMMENT: First, prepare Dummy Event
        Event EventToCreate1 = new Event(WhatId=objAccount.Id,Subject='TESTING',DurationInMinutes = 34, StartDateTime=System.Now());
        insert EventToCreate1;
    //Get The User
        User objUser = [Select Id,Name From User Where Id = : userinfo.getuserid()];
    
    //Create Oppurtunity
        Opportunity ObjOpportunity = new Opportunity();
            ObjOpportunity.Name = 'Test Oppurtunity';
            ObjOpportunity.Account = objAccount;
            ObjOpportunity.Product__c = 'UTP OnDemand';
            ObjOpportunity.CloseDate = system.Today();
            ObjOpportunity.StageName = 'New Deal';
            ObjOpportunity.Owner = objUser;
        Insert ObjOpportunity;
        
    //Create Service Request
        BKSL2__Service_Request__c  appUpdt = new BKSL2__Service_Request__c();
        appUpdt.BKSL2__Start_Date__c = datetime.now();
        appUpdt.BKSL2__End_Date__c = appUpdt.BKSL2__Start_Date__c.addMinutes(10);
        appUpdt.BKSL2__Status__c = 'Completed';
        appUpdt.BKSL2__Service__c = newService.id;
        appUpdt.BKSL2__Contact__c = conDet.id;
        appUpdt.Appointment_Owner__c = userinfo.getuserid();
        appUpdt.Related_Event__c = EventToCreate1.Id;
        appUpdt.Opportunity__c = ObjOpportunity.Id;
        insert appUpdt;
    //COMMENT: First, prepare Dummy Event
        Event EventToCreate = new Event(WhatId=objAccount.Id,Subject='TESTING',DurationInMinutes = 34,Service_Request_Id__c=appUpdt.Id, StartDateTime=System.Now());
        insert EventToCreate;
        
    //Apex Class Call   
        BKSL_SyncServiceRequest.isServiceRequestLocked = false;
        BKSL_SyncServiceRequest sync_ServiceReq = new BKSL_SyncServiceRequest();
        sync_ServiceReq.afterInsertServiceRequestHandler(appUpdt);
        BKSL_SyncServiceRequest.isServiceRequestLocked = false;
        sync_ServiceReq.afterUpdateServiceRequestHandler(appUpdt);
        BKSL_SyncEvent sync_event = new BKSL_SyncEvent();
            sync_event.afterInsertEventHandler(EventToCreate);
        BKSL_SyncServiceRequest.isServiceRequestLocked = false;
            sync_event.afterUpdateEventHandler(EventToCreate);

    }
}