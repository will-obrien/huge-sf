@RestResource(urlMapping='/OpportunityUpsert/*')
global with sharing class OpportunityUpsert {
    global class OpportunityRequest{
        public String  opportunityStage;
        public String  opportunityName;
        public String  accountId;
        public String  type;
        public Date    closeDate;
        public String  stageName;
        public String  opportunityId;
        public String  probInput;
        public Boolean eCommerceConvert;
        public String  eCommerceAccountNumber;
    }

    global class OpportunityResponse{
        public String errorMessage;
        public String accountId;
        public String opportunityId;
        public String companyCreateResp;
    }

    @HttpPut
    global static OpportunityResponse upsertOpportunityJSON(){
       OpportunityRequest opporReq =  (OpportunityRequest)JSON.deserializestrict(
                        RestContext.request.requestbody.tostring(),OpportunityRequest.class);
       Opportunity oppor = setOpportunityRecord(opporReq);
       //upsert oppor;
   
       OpportunityUpsert.OpportunityResponse resp = new OpportunityUpsert.OpportunityResponse();
       resp.accountId           = oppor.accountId;
       resp.opportunityId       = oppor.id;
       resp.companyCreateResp   = CompanyCreate_ArrayRequest.CompanyCreateAPI(oppor);
       system.debug('resp: ' + resp);
       upsert oppor;
       return resp;
    }
   
    public static Opportunity setOpportunityRecord(OpportunityUpsert.OpportunityRequest opporReq){
        Opportunity oppor                   = new Opportunity();
        oppor.Opp_Stage__c                  = opporReq.opportunityStage;
        oppor.name                          = opporReq.opportunityName;
        oppor.accountId                     = opporReq.accountId;
        oppor.Type                          = opporReq.Type;
        oppor.CloseDate                     = opporReq.closeDate;
        oppor.stageName                     = opporReq.stageName;
        oppor.id                            = opporReq.opportunityId;
        oppor.Prob_Input__c                 = opporReq.probInput;
        oppor.ECommerce_Convert__c          = opporReq.eCommerceConvert;
        oppor.ECommerce_Account_Number__c   = opporReq.eCommerceAccountNumber;
        
        oppor.Z_Source__c                   = Label.Default_Z_Source;
        return oppor;
    }
}