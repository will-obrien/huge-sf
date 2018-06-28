@RestResource(urlMapping='/LeadLineItemsUpsert/*')
global with sharing class LeadLineItemsOperation{
    global class LeadLineItemRequest{
        public integer Order_Number;
        public integer Line_Number;
        public string SKU;
        public string Description;
        public decimal Price;
        public string LeadId;
        public string lineItemId;
        public string Name;
        public string Enterprise_Name;
        public integer Number_of_Licensed_Named_Users;
        public integer Subscription_License_Term_Months;
        public date Start_Date;  
        public date End_Date;
        public boolean isDeleteOperation;
    }

    global class LeadLineItemResponse{
        String errorMessage;
        String leadId;
        String leadLineItemId;
    }
    public static string leadId;
    public static boolean isDeleteOperation;
    @HttpPut
    global static list<LeadLineItemResponse> upsertLeadLineItem(){
        list<LeadLineItemRequest> ldLineItemLst =  (list<LeadLineItemRequest>)JSON.deserializestrict(
                        RestContext.request.requestbody.tostring(),list<LeadLineItemRequest>.class);
        system.debug('ldLineItemLst : ' + ldLineItemLst);               
        list<Licenseset__c>             licSetLst         = setLeadLineItemRecord(ldLineItemLst);
        system.debug('licSetLst : ' + licSetLst);
        list<LeadLineItemResponse>   ldLineItemRespLst = new list<LeadLineItemResponse>();
        try{
           if(licSetLst <> null && licSetLst.size() >0){
                ldLineItemRespLst = (isDeleteOperation<> null && isDeleteOperation)?deleteOperation(licSetLst) : upsertOperation(licSetLst);
           }
        }
       catch(Exception e){
       
       }
       system.debug('ldLineItemRespLst : ' + ldLineItemRespLst);
       return ldLineItemRespLst;
    }
    
    public static list<LeadLineItemResponse> upsertOperation (list<Licenseset__c>  licSetLst){
        list<LeadLineItemResponse>   ldLineItemRespLst = new list<LeadLineItemResponse>();
        try{
            Database.upsertResult[] uprRslt = database.upsert(licSetLst, true);
            system.debug('uprRslt : ' + uprRslt);
        
            for (Integer count = 0; count < uprRslt.size(); count++) {
                LeadLineItemResponse ldLineItemResp = new LeadLineItemResponse();
                ldLineItemResp.leadid = leadid;
                if (!uprRslt[count].isSuccess()) {
                    ldLineItemResp.errormessage = uprRslt[count].getErrors()[0].getmessage();
                }else{
                    ldLineItemResp.leadLineItemId = uprRslt[count].getId();
                }
                system.debug('ldLineItemResp : ' + ldLineItemResp);
                ldLineItemRespLst.add(ldLineItemResp);
            }
        }
        catch(Exception e){
            
            LeadLineItemResponse ldLineItemResp = new LeadLineItemResponse();
            ldLineItemResp.leadid = leadid;
            ldLineItemResp.errorMessage = e.getMessage();
            system.debug('ldLineItemResp : ' + ldLineItemResp);
            ldLineItemRespLst.add(ldLineItemResp);          
        }
        return ldLineItemRespLst;
    }
    
    public static list<LeadLineItemResponse> deleteOperation(list<Licenseset__c>  licSetLst){
        list<LeadLineItemResponse>   ldLineItemRespLst = new list<LeadLineItemResponse>();
        Database.deleteResult[] deleteRslt = database.delete(licSetLst, true);
        system.debug('deleteRslt : ' + deleteRslt);
        for (Integer count = 0; count < deleteRslt.size(); count++) {
            LeadLineItemResponse ldLineItemResp = new LeadLineItemResponse();
            ldLineItemResp.leadid = leadid;
            if (!deleteRslt[count].isSuccess()) {
                ldLineItemResp.errormessage = deleteRslt[count].getErrors()[0].getmessage();
            }else{
                ldLineItemResp.leadLineItemId = deleteRslt[count].getId();
            }
            system.debug('ldLineItemResp : ' + ldLineItemResp);
            ldLineItemRespLst.add(ldLineItemResp);
        }
        return ldLineItemRespLst;   
    }   
    
    public static list<Licenseset__c> setLeadLineItemRecord(list<LeadLineItemRequest> ldLineItemReqLst){
        list<string> lineItemIdSet      = new list<String>();
        list<string> offeringsNameSet   = new list<String>();
        list<licenseset__c> licSetLst   = new list<licenseset__c>();
        map<string, Offerings__c> offerMap = new map<string, Offerings__c>();
        system.debug('In setLeadLineItemRecord : ' + ldLineItemReqLst);
        for(LeadLineItemRequest ldLineItemReq : ldLineItemReqLst){
            leadId = ldLineItemReq.LeadId;
            isDeleteOperation = ldLineItemReq.isDeleteOperation;
            lineItemIdSet.add(ldLineItemReq.lineItemId);
            offeringsNameSet.add(ldLineItemReq.Enterprise_Name);
        }
        system.debug('In lineItemIdSet : ' + lineItemIdSet);
        system.debug('In offeringsNameSet : ' + offeringsNameSet);
        map<id, licenseset__c> licSetmap = new map<id, licenseset__c>([select id, name from licenseset__c where id in :lineItemIdSet]);
        system.debug('In licSetmap : ' + licSetmap);        
        for(Offerings__c offer:[select id, name from Offerings__c where name in : offeringsNameSet]){
            offerMap.put(offer.name, offer);
        }
        system.debug('In offerMap : ' + offerMap);
        for(LeadLineItemRequest ldLineItemReq :   ldLineItemReqLst){
            Licenseset__c licSet = licSetmap.containskey(ldLineItemReq.lineItemId)?licSetmap.get(ldLineItemReq.lineItemId):new Licenseset__c(Z_Source__c = Label.Default_Z_Source);
                //licSet.CompanyID__c       = ldLineItemReq
                licSet.Description__c       = ldLineItemReq.Description;
                licSet.End_Date__c          = ldLineItemReq.End_Date;
                licSet.Enterprise_Name__c   = offerMap.containskey(ldLineItemReq.Enterprise_Name)?offerMap.get(ldLineItemReq.Enterprise_Name).id:null;
                licSet.Lead__c              = ldLineItemReq.LeadId;
                licSet.Line_Number__c       = ldLineItemReq.Line_Number;
                licSet.Number_of_Licensed_Named_Users__c = ldLineItemReq.Number_of_Licensed_Named_Users;
                //licSet.Number_of_UnAssigned_Users__c = 
                //licSet.Opportunity__c = 
                licSet.Order_Number__c      = ldLineItemReq.Order_Number;
                licSet.Price__c             = ldLineItemReq.Price;
                licSet.SKU__c               = ldLineItemReq.SKU;
                licSet.Start_Date__c        = ldLineItemReq.Start_Date;
                licSet.Subscription_License_Term_Months__c = ldLineItemReq.Subscription_License_Term_Months;
                licSet.name                 = ldLineItemReq.name;
                licSetLst.add(licSet);
        }
        system.debug('In licSetLst : ' + licSetLst);        
        return licSetLst;
    }
}