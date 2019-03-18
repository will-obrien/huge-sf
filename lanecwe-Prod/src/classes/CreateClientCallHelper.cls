public class CreateClientCallHelper{
    private static string sourceSystem;
    public static String sendCreateClientCall(String assetId, String contactId){
        CreateClientCall.CreateClientCallRequest clientReq = createClientCallRequest(assetId, contactId);
        AuditLog audtLog = new AuditLog('CreateClientCallHelper','sendCreateClientCall');
        audtLog.logSourceSystem(sourceSystem);
        
        system.debug('clientReq  : ' + clientReq );
        //Http request, response and http
        HttpRequest req = new HttpRequest();
        req             = setHTTPRequest(req);
        String reqStr   = JSON.serialize(new list<CreateClientCall.CreateClientCallRequest>{clientReq});
        reqStr = reqstr.replaceall('"pwd"','"Password"'); 
        req.setBody(reqStr);
        audtLog.logRequestInfo(reqStr);
        audtLog.setUrl(req.getEndpoint());
        system.debug('Create Client Call Res: ' + req.getBody());
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        String respStr = '';
        if(!Test.isRunningTest()){        
            res = http.send(req);
            respStr = res.getBody();
        }
        else{
            respStr = '[{"status":"OK","ClientId":3533108,"HubUrl":"sprintdemo4.pgilab.net","ClientCallResponse":{"ClientCreateResult":{"CorrelationId":null,"Errors":[],"ExecutionTime":765,"MessageId":"969a3463-2d78-4980-982c-90394e80eeff","ServerDateTime":"2014-10-20T17:50:00.1948452Z","ClientHierarchy":{"CompanyId":126159,"CompanyName":"SprintDemo4","CorporateCustomerId":0,"CorporateCustomerName":"Default CorporateCustomer","EnterpriseId":1771,"EnterpriseName":"GlobalMeet_mB3_Online","EnterpriseType":"1","HubGroupId":220985,"HubGroupName":"sprintdemo4","HubId":221065,"HubName":"sprintdemo4","HubUrl":"sprintdemo4.pgilab.net","ProviderId":1,"ProviderName":"Premiere Global Services","ProviderType":"1"},"ClientId":3533108}},"confID":6142829,"ModeratorPassCode":"5648324","ParticipantPassCode":"564832","ListenOnlyPassCode":"5648325","confPhoneNumber1":"1-416-640-4861","confPhoneNumber2":"1-888-809-4060","confPhoneNumber3":null,"ReservationCallResponse":{"ReservationCreateResult":{"CorrelationId":null,"Errors":[],"ExecutionTime":93,"MessageId":"c5e2778f-f16f-4a76-975a-5c809922d8bd","ServerDateTime":"2014-10-20T17:50:03.6480144Z","ConfId":6142829,"PassCodes":{"ModeratorPassCode":"5648324","ParticipantPassCode":"564832","SecurityCode":null,"ListenOnlyPassCode":"5648325"},"PhoneNumbers":{"ReservationPhoneNumber":[{"CustomLocation":null,"CustomPhoneType":null,"Location":null,"LocationCode":null,"Number":"1-416-640-4861","PhoneType":"2"},{"CustomLocation":null,"CustomPhoneType":null,"Location":null,"LocationCode":null,"Number":"1-888-809-4060","PhoneType":"1"}]}}}}]';
        }
        //respError = respError.replaceall('"Errors":'+'['+'],','"Errors":null');
        system.debug('Create Client Call Res: ' + respStr); 
        // Deserialize the list of responses from the JSON string.
        List<CreateClientCall.CreateClientCallResponse> responseLst = 
                  (List<CreateClientCall.CreateClientCallResponse>)JSON.deserialize(respStr, List<CreateClientCall.CreateClientCallResponse>.class);
            String errorMsg= null;
            
            for(CreateClientCall.CreateClientCallResponse resp:responseLst){
                if(resp.status == 'OK'){
                  Asset at              = new Asset(id=assetId);
                  at.contactId          = contactId;
                  at.Assignment_Date__c = system.today();
                  at.Client_Id__c       = ''+resp.clientId;
                  update at;
                }
                else if(resp.status == 'Error'){
                    errorMsg = resp.message;
                   /* 
                    if(errorMsg == null){
                        errorMsg = '';
                        for(CreateClientCall.ApiError apiErr: 
                                resp.ClientCallResponse.ClientCreateResult.Errors.ApiError){
                            errorMsg += apiErr.Message +', ';
                        }
                    }
                    */
                }   
            }
            audtLog.logRecordId(contactId);
            audtLog.logResponseInfo(respStr);
            audtLog.logStatusInfo('Success');
            if(errorMsg <> null)
                audtLog.logStatusInfo('Failure');
            audtLog.saveLog();            
        system.debug('Create Client Call Response Lst: ' + responseLst); 
        //system.debug('Create Client Call responseMap: ' + resMap);         
        return errorMsg;    
    }
    
    public static HttpRequest setHTTPRequest(HttpRequest req){
        Integrationparameters__c integ = Integrationparameters__c.getInstance('ClientCreate');
        req.setTimeout(Integer.valueof(integ.Timeout__c));
        req.setEndpoint(integ.endpoint__c);
        req.setMethod(integ.methodtype__c);
        
        return req;
    }    
    public static CreateClientCall.CreateClientCallRequest createClientCallRequest(String assetId, String contactId){
        CreateClientCall.CreateClientCallRequest createCallReq = null;
        list<Asset>     astLst = [select id, name, License_Name__r.CompanyID__c, License_Name__r.HubId__c,  Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, License_Name__r.Enterprise_Name__r.Plan_Type__c, Z_Source__c from asset where id =:assetId  limit 1];
        list<Contact>   ctLst  = [Select id, FirstName, lastName, Title, Phone, Email from contact where id=:contactId limit 1];
        
        if(astLst  <> null && astLst.size() >0 && ctLst <> null && ctLst.size() >0 && 
            astLst[0].License_Name__r.CompanyID__c <> null  && 
            astLst[0].License_Name__r.HubID__c <> null){
            createCallReq               = new CreateClientCall.CreateClientCallRequest();
            createCallReq.FirstName     =   ctLst[0].firstName;
            createCallReq.LastName      =   ctLst[0].lastName;
            createCallReq.JobTitle      =   ctLst[0].title;
            createCallReq.Phone         =   ctLst[0].phone;
            createCallReq.Email         =   ctLst[0].email;

            createCallReq.Address1      =   astLst[0].Account.BillingStreet;
            createCallReq.Address2      =   astLst[0].Account.BillingStreet;
            createCallReq.City          =   astLst[0].Account.BillingCity;
            createCallReq.StateCode     =   astLst[0].Account.BillingState;
            createCallReq.CountryCode   =   astLst[0].Account.BillingCountry;
            createCallReq.PostalCode    =   astLst[0].Account.BillingPostalCode;
            createCallReq.province      =   '';

            createCallReq.CompanyId     =   astLst[0].License_Name__r.CompanyID__c;
            createCallReq.HubID         =   astLst[0].License_Name__r.HubID__c;
            createCallReq.PlanType      =   astLst[0].License_Name__r.Enterprise_Name__r.Plan_Type__c;
            
            createCallReq.roomName      =   (createCallReq.PlanType == 'Web')?ctLst[0].firstName+ctLst[0].lastName:'';
            createCallReq.ponumber      = '';
            
            sourceSystem                =   astLst[0].Z_Source__c;
        }
        system.debug('After setting values createCallReq : ' + createCallReq);
        return createCallReq;
    }
}