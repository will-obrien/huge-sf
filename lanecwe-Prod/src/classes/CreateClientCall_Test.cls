@isTest (seealldata=true)
private class CreateClientCall_Test {
    static testMethod void testCreateClientCall() {
        //User u2 = [SELECT Id FROM User WHERE Alias='vvall'];
        //User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
        //System.RunAs(u2){
            //system.runas(new user(id=userinfo.getuserid())){ 
            Test.startTest();
            //List<sObject> intLst = Test.loadData(Integrationparameters__c.sObjectType, 'IntegrationTestRecords');
            String req = '[{"HowHeardCode":"WB","POCC":"","SpecialInfo":"","CompanyId":"781357","ExternalId":"","RoleCode":"3","DoNotSolicit":"","TimeZoneCode":"ESTRN-BASE","FirstName":"Testing","LastName":"Testing PGi","JobTitle":"Developer","Phone":"333-333-3333","PhoneIsDefault":"FALSE","HomePhoneIsDefault":"FALSE","MobilePhoneIsDefault":"FALSE","Address1":"10 Main Street","Address2":"Suite 101","City":"Atlanta","StateCode":"GA","Province":"","CountryCode":"USA","PostalCode":"30068","Email":"hema.naredla@pgi.com","HubId":"259350","pwd":"","ENV":"DEV","webID":"1973568","webPwd":"nI$DE6LT1#U","ClientID":"7216225","ClientPwd":"pgiPr@v1der","action":"SubscriberCreate","PlanType":"Audio","POnumber":"","RoomName":"pgitesternar1","username":"restapitesting","password":"password1234"}]';
    
            List<CreateClientCall.CreateClientCallRequest> requestLst = 
                  (List<CreateClientCall.CreateClientCallRequest>)JSON.deserialize(req, List<CreateClientCall.CreateClientCallRequest>.class);
            CreateClientCall.CreateClientCallRequest clientReq = new CreateClientCall.CreateClientCallRequest();
            String res = '[{"status":"OK","ClientId":3533108,"HubUrl":"sprintdemo4.pgilab.net","ClientCallResponse":{"ClientCreateResult":{"CorrelationId":null,"Errors":[],"ExecutionTime":765,"MessageId":"969a3463-2d78-4980-982c-90394e80eeff","ServerDateTime":"2014-10-20T17:50:00.1948452Z","ClientHierarchy":{"CompanyId":126159,"CompanyName":"SprintDemo4","CorporateCustomerId":0,"CorporateCustomerName":"Default CorporateCustomer","EnterpriseId":1771,"EnterpriseName":"GlobalMeet_mB3_Online","EnterpriseType":"1","HubGroupId":220985,"HubGroupName":"sprintdemo4","HubId":221065,"HubName":"sprintdemo4","HubUrl":"sprintdemo4.pgilab.net","ProviderId":1,"ProviderName":"Premiere Global Services","ProviderType":"1"},"ClientId":3533108}},"confID":6142829,"ModeratorPassCode":"5648324","ParticipantPassCode":"564832","ListenOnlyPassCode":"5648325","confPhoneNumber1":"1-416-640-4861","confPhoneNumber2":"1-888-809-4060","confPhoneNumber3":null,"ReservationCallResponse":{"ReservationCreateResult":{"CorrelationId":null,"Errors":[],"ExecutionTime":93,"MessageId":"c5e2778f-f16f-4a76-975a-5c809922d8bd","ServerDateTime":"2014-10-20T17:50:03.6480144Z","ConfId":6142829,"PassCodes":{"ModeratorPassCode":"5648324","ParticipantPassCode":"564832","SecurityCode":null,"ListenOnlyPassCode":"5648325"},"PhoneNumbers":{"ReservationPhoneNumber":[{"CustomLocation":null,"CustomPhoneType":null,"Location":null,"LocationCode":null,"Number":"1-416-640-4861","PhoneType":"2"},{"CustomLocation":null,"CustomPhoneType":null,"Location":null,"LocationCode":null,"Number":"1-888-809-4060","PhoneType":"1"}]}}}}]';
    
            List<CreateClientCall.CreateClientCallResponse> responseLst = 
                  (List<CreateClientCall.CreateClientCallResponse>)JSON.deserialize(res, List<CreateClientCall.CreateClientCallResponse>.class);
            CreateClientCall.CreateClientCallResponse clientRes = new CreateClientCall.CreateClientCallResponse();
            CreateClientCall.Errors err = new CreateClientCall.Errors();
            CreateClientCall.PhoneNumbers ph = new CreateClientCall.PhoneNumbers();
            
            Test.stopTest();
       }
    //}
}