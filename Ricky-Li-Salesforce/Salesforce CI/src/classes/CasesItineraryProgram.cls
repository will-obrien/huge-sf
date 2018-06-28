public class CasesItineraryProgram {
    Tour_Evaluation__c te;
    Account account;
    Service__c service;
    public CasesItineraryProgram(ApexPages.StandardController controller) {
      
        te = [SELECT Id, Name, Service__c, Account__c FROM Tour_Evaluation__c
                WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        account = [Select Name from Account where Id =: te.Account__c];
        service = [Select Name from Service__c where Id =: te.Service__c];
    }
    public PageReference CreateCaseTransportation(){
            String defAccountId = 'def_account_id';
            String tourEvalName = 'CF00NS0000001BpXW';
            String accountName = 'cas4';
            String serviceName = 'CF00N30000009gpcg';
            String serviceId = 'CF00N30000009gpcg_lkid';
            String type = 'cas5';
           
            String ServiceN = EncodingUtil.URLENCODE(Service.Name,'UTF-8');
            String redirection = '/500/e?'+ defAccountId +'='+ account.Id + '&' + tourEvalName + '=' + te.Name + '&' + accountName + '=' + account.name + '&' + serviceName + '=' + serviceN + '&' + serviceId + '=' + service.Id + '&' + Type + '=' + 'Itinerary / Program';
            PageReference redirectURL = new PageReference(redirection);
            return redirectURL;
    }

}