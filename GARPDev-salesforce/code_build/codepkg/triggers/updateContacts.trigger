trigger updateContacts on Contract (before update,after update) {

    // AG WE NO LONGER NEED THIS
    // LEAVE IT DEACTIVIATED!!

    system.debug('* * * Entering updateContacts Query Count is '+Limits.getQueries() ) ;
    id frmRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
    id erpRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
    id icbrrRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
    Set<Contract> setContracts = new Set<Contract>();
    Map<Id,Contract> mapContracts = new Map<Id,Contract>();
    Set<Id> setaccountIds = new Set<Id>();
    
    Map<Id,Contract> mapaccountIds = new Map<Id,Contract>();
    
    for(Contract obj : trigger.New)
    {
        
        if(obj.All_Requirements_Completed__c && (obj.recordTypeId == frmRecordTypeId || obj.recordTypeId == erpRecordTypeId) && trigger.oldMap.get(obj.Id).All_Requirements_Completed__c != obj.All_Requirements_Completed__c)
        {
            mapaccountIds.put(obj.accountId,obj);
                
        }
        if(obj.recordTypeId == icbrrRecordTypeId && (obj.Status.indexOf('Activated') >= 0) && trigger.oldMap.get(obj.Id).Status != obj.Status)
        {
            mapContracts.put(obj.Id,obj);
        }
        
    }
    if(setContracts.size() > 0)
    {
        List<Exam_Attempt__c> lstExamAttempts = [select id,Name,Garp_Id__c,Candidate_Requirement__c,Member__r.FirstName,Candidate_Commitment__c,ClientAuthorizationID__c,Member__r.LastName,Member__r.Suffix__c,Member__r.MailingCity,Member__r.MailingCountry,Member__r.MailingPostalCode,Member__r.MailingState,Member__r.MailingStreet,Member__r.Salutation,Member__r.Phone,Member__r.Email,Candidate_Commitment__r.StartDate,Candidate_Commitment__r.EndDate  from Exam_Attempt__c where Candidate_Commitment__c in: mapContracts.keySet()];
        contractUtil.createIcbrrExport(lstExamAttempts,mapContracts);
    }
    
    if(mapaccountIds.size() >= 0)
    {
        List<Contact> lstContacts = new List<Contact>();
        for(Contact objContact : [select id,KPI_FRM_Candidate__c,accountId from contact where accountId in: mapaccountIds.keySet()])
        {
            Contract objContract = mapaccountIds.get(objContact.accountId);
            if(objContract.recordTypeId == frmRecordTypeId)
                objContact.KPI_FRM_Certified__c = true;
            else if(objContract.recordTypeId == erpRecordTypeId)
                objContact.KPI_ERP_Candidate__c = true;
                
            lstContacts.add(objContact);
        
        }
        
        if(lstContacts.size() > 0)
            update lstContacts;
    }
    system.debug('* * * Exiting updateContacts Query Count is '+Limits.getQueries() ) ;
}