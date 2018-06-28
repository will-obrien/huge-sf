trigger CreateCaseComment on Service__c (after insert) {
    Service__c myService = trigger.new[0];
    Boolean serviceNameCustomerService = false;

    serviceNameCustomerService = myService.name == 'Refund Due to Complaint (Post-travel)' || myService.name == 'Refund as per Operations Department' || myService.name == 'Refund Due to Missed Service';

    if (serviceNameCustomerService) {
    //if (myService.Fee_Type__c == 'Fee' && serviceNameCustomerService) {
   
        String serviceID = myService.Related_Service_ID_2__c;
    
        List <Case> listCases = [select Id From Case where Service_ID_Compass__c =: serviceID];
    
        List <CaseComment> listCC = new list <CaseComment>();
    
        for (Case c: listCases) {
            String caseId = c.Id;
            
            c.Refund_Amount__c = myService.Gross__c;
            c.Refund_Currency__c = myService.CurrencyIsoCode;
           
            CaseComment cc = new CaseComment(CommentBody='Note: Refund was successfully issued!', ParentId=caseId);
            listCC.add(cc);
        
        }
        insert listCC;
    }

}