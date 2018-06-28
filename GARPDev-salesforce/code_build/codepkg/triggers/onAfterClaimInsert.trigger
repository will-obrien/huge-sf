trigger onAfterClaimInsert on CPE_Claim__c (after insert) {
    set < id > newlyUpdatedClaimIDs = new Set < id > ();
    for (CPE_Claim__c c : Trigger.new) {
        newlyUpdatedClaimIDs.add(c.id);
    }

    List<CPE_Claim__c> updateClaims = new List<CPE_Claim__c>();
    for (CPE_Claim__c c : [
                SELECT Id, FRM__c, ERP__c, ApprovedCredits__c, Candidate_Requirement__c, Candidate_Requirement__r.RecordTypeId,
                Member__r.email, Member__r.KPI_FRM_Certified__c, Member__r.KPI_ERP_Certified__c
                FROM CPE_Claim__c
                WHERE Id IN : newlyUpdatedClaimIDs
        ]) {    
            if(c.FRM__c == false && c.ERP__c == false) {
                
                if(c.Member__r.KPI_FRM_Certified__c == true) {
                    c.FRM__c = true;
                }
                if(c.Member__r.KPI_ERP_Certified__c == true) {
                    c.ERP__c = true;
                }
                if(c.ERP__c == true || c.FRM__c == true)
                    updateClaims.add(c);
                system.debug('* * * updatedClaims ...'+ c);
            }            
    }
    update updateClaims;
}