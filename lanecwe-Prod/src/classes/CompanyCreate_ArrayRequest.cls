public class CompanyCreate_ArrayRequest {

    public static void InsertCompanyId(List<LicenseSet__c> licenseSetListForUpdateArg) {
        update licenseSetListForUpdateArg;
    }
    public static void InsertAuditLog(List<AuditLog> AuditLogForUpdateArg) {
        for (AuditLog auditLog : AuditLogForUpdateArg) {
            upsert auditLog.saveLog();
        }  
    }
    
    //@future (callout=true)
    public static String CompanyCreateAPI (Opportunity opp/*Set<Id> opportunityIdSet*/) {
        //String to store CompanyId from response
        string CompanyID;
        //String to store HubId from response
        string hubID;
        //String to store LicenseSetId from response
        String licenseSetId;
        //Serialized Companycreatedata obj from lines 29-51
        String JSONString;
       //Grab integration custom settings
        Integrationparameters__c integrationSettings = Integrationparameters__c.getInstance('ClientCreate');
        String env = integrationSettings.Env__c;
        String webID = integrationSettings.WebID__c;
        String webPwd = integrationSettings.webPwd__c;
        String clientID = integrationSettings.ClientID__c;
        String clientPwd = integrationSettings.ClientPwd__c;
        String username = integrationSettings.username__c;
        String password = integrationSettings.password__c;
        String methodType = integrationSettings.MethodType__c;
        String endpoint = integrationSettings.Endpoint__c;
        
        //Http request, response and http
        HttpRequest req = new HttpRequest();
        req.setTimeout(120000);
        req.setEndpoint(endpoint);
        req.setMethod(methodType);
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        List<AuditLog> AuditLogForUpdate = new List<AuditLog>();
        List<LicenseSet__c> licenseSetListForUpdate = new List<LicenseSet__c>();
        //List to hold the Companycreatedata objs for each license set - currently commented out b/c endpoint cannot process arrays
        List<Companycreatedata> CompanyCreateDataList = new List<Companycreatedata>();
        //Opportunities that are in companyCreateTest trigger.New context, are Closed Won, and e-Commerce_create__c = true
        List<LicenseSet__c> licenseSetList = [SELECT Id, Opportunity__r.Id, Enterprise_Name__r.Enterprise_ID__c, CompanyId__c, Opportunity__r.Account.BillingStreet, Opportunity__r.Account.BillingCountry, Opportunity__r.Account.BillingCity, Opportunity__r.Account.BillingState, Opportunity__r.Account.BillingPostalCode, Opportunity__r.Account.Name FROM LicenseSet__c WHERE Opportunity__c = :opp.Id/*IN :opportunityIdSet*/];
        system.debug('licenseSetList: ' + licenseSetList);
        
        for (LicenseSet__c licenseSet : licenseSetList) {
            Companycreatedata company = new Companycreatedata();
            company.Address1             = licenseSet.Opportunity__r.Account.BillingStreet;
            company.Address2             = licenseSet.Opportunity__r.Account.BillingStreet;
            company.City                 = licenseSet.Opportunity__r.Account.BillingCity;
            company.StateCode            = licenseSet.Opportunity__r.Account.BillingState;//for testing success/fail in same array: licenseSet.Test_State__c;
            company.Province             ='';
            company.LicenseSetId         = licenseSet.Id;
            company.CountryCode          = licenseSet.Opportunity__r.Account.BillingCountry;
            company.PostalCode           = licenseSet.Opportunity__r.Account.BillingPostalCode;
            company.BusinessType         = '6';
            company.DoNotSolicit          = 'True';
            company.CompanyName          = licenseSet.Opportunity__r.Account.Name;
            company.CorporateCustomerId  = licenseSet.Opportunity__r.Account.Name;
            company.EnterpriseId         = licenseSet.Enterprise_Name__r.Enterprise_ID__c;//'2005';
            company.ProviderId           ='1';
            company.ENV                  = env;
            company.webID                = webID;
            company.webPwd               = webPwd;
            company.ClientID             = clientID;
            company.ClientPwd            = clientPwd;
            company.action               ='CompanyCreate';
            company.username             = username;
            company.password             = password;
            CompanyCreateDataList.add(company);
        }
        JSONString = JSON.serialize(CompanyCreateDataList);
        req.setBody(JSONString);
        res = http.send(req);
        
        system.debug('reqBody: ' + req.getBody());        
        system.debug('res.getBody: ' + res.getBody());
        
        JSONParser parser = JSON.createParser(res.getBody());
        //JSON2Apex responseWrapper = new JSON2Apex(parser);
        //responseWrapper.parse(res.getBody());
        
        //System.debug('responseWrapper: ' + responseWrapper);
 
        Integer count = 0;
        Boolean success;
        //Integer hubIdCount = 0;
 
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                LicenseSet__c licenseSetUpdate = new LicenseSet__c();
                AuditLog audtLog = new AuditLog('CompanyCreate_ArrayRequest','CompanyCreateAPI');
                audtLog.logRequestInfo(JSONString);
                audtLog.logResponseInfo(res.getBody());
                
                if (fieldName == 'status' && parser.getText() == 'OK') {
                    success = true;
                    system.debug('success: ' + success);
                }
                if (fieldName == 'status' && parser.getText() == 'Error') {
                    success = false;
                    system.debug('success: ' + success);
                }  
                if (fieldName == 'CompanyId' && success == true) {
                    CompanyID = parser.getText();
                    System.debug('CompanyID: ' + CompanyID);
                }
                if (fieldName == 'LicenseSetId' && success == true) {
                    licenseSetId = parser.getText();
                    System.debug('licenseSetId: ' + licenseSetId);
                }
                if (fieldName == 'HubId' && success == true) {
                    hubID = parser.getText();
                }
                if (fieldName == 'ProviderType' && success == true) {
                    licenseSetUpdate.CompanyID__c = CompanyID;
                    licenseSetUpdate.HubID__c = hubID;
                    licenseSetUpdate.id = licenseSetId;
                    licenseSetListForUpdate.add(licenseSetUpdate);
                    System.debug('licenseSetListForUpdate: ' + licenseSetListForUpdate);
                    audtLog.logRecordId(licenseSetId);
                    audtLog.logStatusInfo('Success');
                    AuditLogForUpdate.add(audtLog);
                }
                
                /*if (fieldName == 'LicenseSetId' && success == true) {
                    licenseSetId = parser.getText();
                    System.debug('licenseSetId: ' + licenseSetId);
                    licenseSetUpdate.CompanyID__c = CompanyID;
                    licenseSetUpdate.HubID__c = hubID;
                    licenseSetUpdate.id = licenseSetId;
                    licenseSetListForUpdate.add(licenseSetUpdate);
                    System.debug('licenseSetListForUpdate: ' + licenseSetListForUpdate);
                    audtLog.addLicenseSet(licenseSetId);
                    audtLog.logStatusInfo(1,'Success');
                    AuditLogForUpdate.add(audtLog);
                    //hubID = null;
                }*/
                /*if (fieldName == 'HubId' && success == true && (hubID == '' || hubID == null)) {
                    hubID = parser.getText();
                    System.debug('hubID: ' + hubID);
                    licenseSetUpdate.CompanyID__c = CompanyID;
                    licenseSetUpdate.HubID__c = hubID;
                    licenseSetUpdate.id = licenseSetId;
                    licenseSetListForUpdate.add(licenseSetUpdate);
                    System.debug('licenseSetListForUpdate: ' + licenseSetListForUpdate);
                    audtLog.addLicenseSet(licenseSetId);
                    audtLog.logStatusInfo(1,'Success');
                    AuditLogForUpdate.add(audtLog);
                    CompanyId = null;
                    licenseSetId = null;
                    hubID = null;
                }*/
                if (fieldName == 'LicenseSetId' && success == false) {
                    licenseSetId = parser.getText();
                    audtLog.logRecordId(licenseSetId);
                    audtLog.logStatusInfo('Error');
                    AuditLogForUpdate.add(audtLog);
                }   
            }
        }
        InsertCompanyId(licenseSetListForUpdate);
        InsertAuditLog(AuditLogForUpdate);
        return res.getBody();
    }
}