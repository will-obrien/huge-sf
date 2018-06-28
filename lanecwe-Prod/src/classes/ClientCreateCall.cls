@RestResource(urlMapping='/ClientCreateCall/*')
global with sharing class ClientCreateCall {
    
    private static string sourceSystem;
    
    global class ContactRequest{
        //string transactionId;
        public string contactId;
        public string assetId;
    }

    global class ContactResponse{
        //string transactionId;        
        public String  errorMessage;
        public string  contactId;
        public string  assetId;
        public Date    assignmentDate;
        public String  clientId;
        //String  eCommerceAccountNumber;
        public String  enterpriseName;
        //string  licenseName;
        public String  licenseNumber;
        //string  opportunity;
        public Date    terminationDate;
        public String  assetName;
        //String  accountId;
        //String  assetStatus;
    }
    
    @HttpPut
    global static ContactResponse createClientCall(){
        AuditLog audtLog = new AuditLog('ClientCreateCall ','createClientCall');
        ContactResponse resp = new ContactResponse();
        try{
            
            audtLog.logRequestInfo(RestContext.request.requestbody.tostring());
           
            ContactRequest ctReq =  (ContactRequest)JSON.deserializestrict(
                            RestContext.request.requestbody.tostring(),ContactRequest.class);
            
            audtLog.logRecordId(ctReq.contactId);
            resp.assetId = ctReq.assetId;
            resp.contactId = ctReq.Contactid;
            resp.errorMessage = CreateClientCallHelper.sendCreateClientCall(ctReq.assetId, ctReq.contactId);
            system.debug('resp: ' + resp);
            resp = createContactResponse(resp);
            audtLog.logSourceSystem(sourceSystem);
            audtLog.logResponseInfo(JSON.serialize(resp));
            audtLog.logStatusInfo('Success');
            audtLog.saveLog();
        }
        catch(Exception e){
            resp.errorMessage = e.getStackTraceString();
            system.debug('resp: ' + resp);
            audtLog.logResponseInfo(JSON.serialize(resp));
            audtLog.logStatusInfo('Failure');
            audtLog.saveLog();
        }
       return resp;
    }
    
    public static ContactResponse createContactResponse(ContactResponse resp){
            Asset ast = [select id, Assignment_Date__c, Client_ID__c, ECommerce_Account_Number__c, 
                                Enterprise_Name__c, Enterprise_Name__r.Name, License_Name__c, 
                                License_Number__c, Opportunity__c, Termination_Date__c, 
                                Name, AccountId, Status, z_Source__c
                            from asset 
                            where id =:resp.assetId  limit 1];
            resp.assignmentDate     =   ast.Assignment_Date__c; 
            resp.clientId           =   ast.Client_ID__c;
            resp.enterpriseName     =   ast.Enterprise_Name__r.Name; 
            resp.licenseNumber       =   ast.License_Number__c; 
            resp.terminationDate    =   ast.Termination_Date__c; 
            resp.assetName          =   ast.Name; 
            sourceSystem            = ast.z_Source__c;
            return resp;
    }
}