@RestResource(urlMapping='/RetrieveAssets/*')
global with sharing class  RetrieveAssets{
    public static map<id, list<asset>> licsetAssetMap = new map<id, list<asset>>();

    global class AssetsResponse{
        //string transactionId;        
        public String errorMessage;
        public String accountId;
        public list<LicenseSetRecord> licenseSetList;
    }

    global class LicenseSetRecord{
        public list<AssetsRecord> assetsList;
        public String licenseSetId;
        public String  companyID;
        public String  description;
        public Date    endDate;
        public String  enterpriseName;
        public Integer lineNumber;
        public Integer numberOfLicensedNamedUsers;
        public String  opportunityId;
        public String  accountId;
        public Integer orderNumber;
        public Decimal price;
        public String  sku;
        public Date    startDate;
        public Integer subscriptionLicenseTermMonths;
    }

    global class AssetsRecord{
        public String  assetId;
        public Date    assignmentDate;
        public String  clientID;
        public String  eCommerceAccountNumber;
        public String  licenseSetId;
        public String  opportunityId;
        public Date    terminationDate;
        public String  accountId;
        public String  contactId;
        public String  firstname;
        public String  lastname;      
    }
    
    @HttpGet
    global static AssetsResponse retrieveRecord(){
        AuditLog audtLog    = new AuditLog('RetrieveAssets ','retrieveRecord');
        AssetsResponse resp = new AssetsResponse();
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            audtLog.logRequestInfo(req.requestURI);
            String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);           
            /*
            AssetsRequest assetReq =  (AssetsRequest)JSON.deserializestrict(
                            RestContext.request.requestbody.tostring(),AssetsRequest.class);
            //resp.transactionId  = assetReq.transactionId;*/
            resp.accountId      = accountId;
            list<Licenseset__c> licSetLst = [select id, name, CompanyID__c, Description__c, End_Date__c, 
                                                 Enterprise_Name__c, Enterprise_Name__r.name, 
                                                 Line_Number__c, Number_of_Licensed_Named_Users__c, Opportunity__c, Opportunity__r.AccountId, 
                                                 Order_Number__c, Price__c, SKU__c, Start_Date__c,Subscription_License_Term_Months__c
                                                /*(
                                                    select  id, name,Assignment_Date__c, Client_ID__c, ECommerce_Account_Number__c, 
                                                            License_Name__c, Opportunity__c, Termination_Date__c, accountid 
                                                        from Assets
                                                )*/
                                            from 
                                                LicenseSet__c where opportunity__r.accountid = :accountId];
            if(licSetLst <> null && licSetLst.size()>0){
                list<LicenseSetRecord> licenseSetRecordList = new list<LicenseSetRecord>();

                for(Asset ast:[select  id, name,Assignment_Date__c, Client_ID__c, ECommerce_Account_Number__c, Z_Source__c,
                                License_Name__c, Opportunity__c, Termination_Date__c, accountid, contactid, contact.firstname, contact.lastname   
                            from Asset where   License_Name__c in :licSetLst]){
                    list<asset> astLst = (licsetAssetMap.containskey(ast.License_Name__c)) ? licsetAssetMap.get(ast.License_Name__c):new list<asset>();
                    audtLog.logSourceSystem(ast.Z_Source__c);
                    astLst.add(ast);
                    licsetAssetMap.put(ast.License_Name__c, astLst);
                }                           
                for(Licenseset__c licset:licSetLst){
                    licenseSetRecordList.add(setLicenseSetRecord(licset));
                }
                resp.licenseSetList     =   licenseSetRecordList;
            }
            else{
                resp.errorMessage = 'No Record Found';
            }
            
            audtLog.logRecordId(resp.accountId);
            
            system.debug('resp: ' + resp);
            audtLog.logResponseInfo(JSON.serialize(resp));
            audtLog.logStatusInfo('Success');
            audtLog.saveLog();
        }
        catch(Exception e){
            audtLog.logRecordId(resp.accountId);
            system.debug('resp: ' + resp);
            resp.errorMessage = e.getMessage();
            audtLog.logResponseInfo(JSON.serialize(resp));
            audtLog.logStatusInfo('Failure');
            audtLog.saveLog();
        }
            
       return resp;
    }
   
    public static LicenseSetRecord setLicenseSetRecord(Licenseset__c licset){
       
        LicenseSetRecord licsetRecord = new LicenseSetRecord();

        licsetRecord.licenseSetId               =   licset.id;
        licsetRecord.companyID                  =   licset.CompanyID__c;
        licsetRecord.description                =   licset.Description__c;
        licsetRecord.endDate                    =   licset.End_Date__c;
        licsetRecord.enterpriseName             =   licset.Enterprise_Name__r.name;
        licsetRecord.lineNumber                 =   (licset.Line_Number__c == null )?0:Integer.valueof(licset.Line_Number__c);
        licsetRecord.numberOfLicensedNamedUsers =   (licset.Number_of_Licensed_Named_Users__c == null)?0:Integer.valueof(licset.Number_of_Licensed_Named_Users__c);
        licsetRecord.opportunityId              =   licset.Opportunity__c;
        licsetRecord.accountId                  =   licset.Opportunity__r.AccountId;
        licsetRecord.orderNumber                =   (licset.Order_Number__c == null)?0:Integer.valueOf(licset.Order_Number__c);
        licsetRecord.price                      =   licset.Price__c;
        licsetRecord.sku                        =   licset.SKU__c;
        licsetRecord.startDate                  =   licset.Start_Date__c;
        licsetRecord.subscriptionLicenseTermMonths  = (licset.Subscription_License_Term_Months__c == null)?0:Integer.valueof(licset.Subscription_License_Term_Months__c);
        
        if(licsetAssetMap <> null && licsetAssetMap.containskey(licset.id)){
            licsetRecord.assetsList = setAssetsRecord(licsetAssetMap.get(licset.id));
        }
        return licsetRecord;
    }
    
    public static list<AssetsRecord> setAssetsRecord(list<Asset> assetLst){
        list<AssetsRecord> astRecordLst = new list<AssetsRecord>();
        for(Asset ast: assetLst){
            AssetsRecord astRecord = new AssetsRecord();
            astRecord.assetId           =   ast.id;
            astRecord.assignmentDate    =   ast.Assignment_Date__c;
            astRecord.clientID          =   ast.Client_ID__c;
            astRecord.eCommerceAccountNumber    =   ast.ECommerce_Account_Number__c;
            astRecord.licenseSetId      =   ast.License_Name__c;
            astRecord.opportunityId     =   ast.Opportunity__c;
            astRecord.terminationDate   =   ast.Termination_Date__c;
            astRecord.accountId         =   ast.accountid;
            astRecord.contactId         =   ast.contactid;
            astRecord.firstname         =   ast.contact.firstname;
            astRecord.lastname          =   ast.contact.lastname;
            astRecordLst.add(astRecord);
        }
        return astRecordLst;
    }
}