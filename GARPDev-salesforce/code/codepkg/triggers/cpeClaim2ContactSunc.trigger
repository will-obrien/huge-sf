trigger cpeClaim2ContactSunc on CPE_Claim__c (after insert, after update) {

    Map<Id,Candidate_Requirement__c> mapAcctIds = new Map<Id,Candidate_Requirement__c>();
    Map<Id,CPE_Claim__c> mapCrIds = new Map<Id,CPE_Claim__c>();
    
    Map<Id,Decimal> mapCrCount = new Map<Id,Decimal>();

    id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
    id CPERequirementTypeId = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','CPE');

    for(CPE_Claim__c obj : trigger.New)
    {        
        system.debug('* * * claim: ' + obj.Id + ':' + obj.Candidate_Requirement__c);    
        mapCrIds.put(obj.Candidate_Requirement__c,obj);
    }
    system.debug('* * * mapCrIds: ' + mapCrIds.keySet());    
    
    List<Candidate_Requirement__c> lcr = [Select Id, Name, Candidate_Commitment__c, Candidate_Commitment__r.AccountId from Candidate_Requirement__c where Id in :mapCrIds.keySet()];
    for(Candidate_Requirement__c cr : lcr) {
        mapAcctIds.put(cr.Candidate_Commitment__r.AccountId,cr);
    }
    system.debug('* * * mapAcctIds: ' + mapAcctIds.keySet());    
    
    List<Contract> lcontract = [Select Id, Name, AccountId, StartDate, EndDate, recordTypeId from Contract where recordTypeId = :CPEContractTypeId and AccountId in :mapAcctIds.keySet() Order By ActivatedDate];
    List<CPE_Claim__c> lclaim = [Select Id, Name, ApprovedCredits__c, Date_of_Completion__c, Candidate_Requirement__c, Candidate_Requirement__r.Candidate_Commitment__c from CPE_Claim__c where Candidate_Requirement__r.Candidate_Commitment__c in :lcontract];

    List<Contact> lstContacts = new List<Contact>();
    for(Contact objContact : [select Id, Name, AccountId from contact where AccountId in: mapAcctIds.keySet()])
    {
        objContact.KPI_CPE_Participation__c = false;
        objContact.KPI_CPE_Requirement_Status__c = null;
        objContact.KPI_CPE_Credits__c = null;
        objContact.CPE_Last_Cycle__c = null;
        objContact.KPI_CPE_Last_Cycle_Credits__c = null;

        Contract currentContract = null;
        Contract prevContract = null;
        Contract lastCompleted = null;
        Decimal credits=0;

        for(Contract con : lcontract) {
            
            system.debug('* * * contract: ' + con.id + ':' + con.StartDate + ':' + con.EndDate);   
                        
            Date nowDate = date.today();
            if(con.AccountId == objContact.AccountId) {
            
                credits=0;
                Id cr = null;
                for(CPE_Claim__c claim : lclaim) {    
                    cr = claim.Candidate_Requirement__c;
                    if(claim.Candidate_Requirement__r.Candidate_Commitment__c == con.Id && claim.ApprovedCredits__c != null) {
                        credits += claim.ApprovedCredits__c;
                    }
                }                    
                system.debug('* * * calc credits for cr: ' + credits + ':' + cr);
                if(credits != 0)
                    mapCrCount.put(cr,credits);
                
                
                if(nowDate >= con.StartDate && nowDate < con.EndDate) {
                    currentContract=con; 
                }
                system.debug('con>>>'+con);
                // Older contracts
                if(con.EndDate < nowDate) {
                    // Find most recent old contract
                    if(prevContract == null || con.StartDate > prevContract.StartDate) {
                        prevContract = con;
                    }
                    
                    credits=0;
                    for(CPE_Claim__c claim : lclaim) {    
                        if(claim.Candidate_Requirement__r.Candidate_Commitment__c == prevContract.Id && claim.ApprovedCredits__c != null) {
                            credits += claim.ApprovedCredits__c;
                        }
                    }
                        
                    if(credits > 40) {        
                        if(lastCompleted == null || con.StartDate > lastCompleted.StartDate) {
                            lastCompleted = con;
                        }                        
                    }
                }
            }
        }

        system.debug('* * * found contract: ' + currentContract + ':' + prevContract);
        
        // Calc stats for current contract
        if(currentContract != null) {
            objContact.KPI_CPE_Participation__c = true;   
            objContact.KPI_CPE_Current_Cycle__c = string.valueof(currentContract.StartDate.year()) + '/' + string.valueof(currentContract.EndDate.year());
            credits=0;
            for(CPE_Claim__c claim : lclaim) {
                if(claim.Candidate_Requirement__r.Candidate_Commitment__c == currentContract.Id && claim.ApprovedCredits__c != null) {
                    credits += claim.ApprovedCredits__c;
                }
            }
            objContact.KPI_CPE_Credits__c = credits;            
        }
        
        if(prevContract != null) {
            objContact.CPE_Last_Cycle__c = string.valueof(prevContract.StartDate.year()) + '/' + string.valueof(prevContract.EndDate.year());
            credits=0;
            for(CPE_Claim__c claim : lclaim) {
                if(claim.Candidate_Requirement__r.Candidate_Commitment__c == prevContract.Id && claim.ApprovedCredits__c != null) {
                    credits += claim.ApprovedCredits__c;
                }
            }
            objContact.KPI_CPE_Last_Cycle_Credits__c=credits;
                
            if(credits > 40) {
                objContact.KPI_CPE_Requirement_Status__c = 'In Good Standing';
            } else {
                objContact.KPI_CPE_Requirement_Status__c = 'Lapsed';
            }
        } else if(currentContract != null) {
            objContact.KPI_CPE_Requirement_Status__c = 'Pending';
        }
        
        if(lastCompleted != null) {
            objContact.KPI_CPE_Last_Completed_Cycle__c = string.valueof(lastCompleted.StartDate.year()) + '/' + string.valueof(lastCompleted.EndDate.year());
        }
        lstContacts.add(objContact);        
    }

    for(Candidate_Requirement__c cr: lcr) {
        Decimal count = mapCrCount.get(cr.Id) == null ? 0 : mapCrCount.get(cr.Id);
        if(count!=null) {
            cr.Approved_Credits__c = count;
            system.debug('* * * update calc credits for cr: ' + count + ':' + cr);
        }
            
    }        
    update lcr;
    
    if(lstContacts.size() > 0)
        update lstContacts;
}