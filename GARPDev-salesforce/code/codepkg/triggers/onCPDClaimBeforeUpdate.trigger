trigger onCPDClaimBeforeUpdate on CPE_Claim__c(before insert, before update) {

    Id recType4CPEReq = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'CPE');

    // Set Approved Checkbox

    // Set CR Email

    // Set CR Status

    set < id > newlyUpdatedClaimIDs = new Set < id > ();
    set < id > ReqIDsOfUpdatedClaims = new Set < id > ();

    List < CPE_Claim__c > updateClaims = new List < CPE_Claim__c > ();
    MAP <Id, Id> mapContactClaim = new MAP <Id, Id>();
    List<Id> clamsIds = new List<Id>();
    for (CPE_Claim__c c : Trigger.new) {
        
        // Entered Approved Credits will check the Approved Box
        if (c.Approved__c == false && c.ApprovedCredits__c != null && c.ApprovedCredits__c > 0) {
            c.Approved__c = true;
        }
        // Check the Approved Box will Entered Approved Credits will
        else if (c.Approved__c == true && (c.ApprovedCredits__c == null || c.ApprovedCredits__c == 0) && c.Credits_Earned__c != null && c.Credits_Earned__c > 0) {
            c.ApprovedCredits__c = c.Credits_Earned__c;
        }
        newlyUpdatedClaimIDs.add(c.id);
        ReqIDsOfUpdatedClaims.add(c.Candidate_Requirement__c);
        system.debug('c.Candidate_Requirement__c >>>'+c.Candidate_Requirement__c);
    }
    system.debug('ReqIDsOfUpdatedClaims>>>'+ReqIDsOfUpdatedClaims);
     system.debug('newlyUpdatedClaimIDs>>>'+newlyUpdatedClaimIDs);
    if (newlyUpdatedClaimIDs.size() > 0) {

        list < CPE_Claim__c > allClaimsRelatedToUpdatedClaim = new list < CPE_Claim__c > ();
        Map < Id, Boolean > updatedFRMClaims = new Map < Id, Boolean > ();
        Map < Id, Boolean > updatedERPClaims = new Map < Id, Boolean > ();
        for (CPE_Claim__c c : [
                SELECT Id, FRM__c, ERP__c, ApprovedCredits__c, Candidate_Requirement__c, Candidate_Requirement__r.RecordTypeId,
                Member__r.email, Member__r.KPI_FRM_Certified__c, Member__r.KPI_ERP_Certified__c
                FROM CPE_Claim__c
                WHERE Candidate_Requirement__c IN : ReqIDsOfUpdatedClaims
        ]) {

            system.debug('* * * claim ...'+ c);
            
            if (c.Candidate_Requirement__r.RecordTypeId == recType4CPEReq)
                allClaimsRelatedToUpdatedClaim.add(c);
        
            if(c.FRM__c == false && c.ERP__c == false) {
                
                if(c.Member__r.KPI_FRM_Certified__c == true)                
                    updatedFRMClaims.put(c.Id, true);
                if(c.Member__r.KPI_ERP_Certified__c == true)                
                    updatedERPClaims.put(c.Id, true);
                
                system.debug('* * * updatedClaims ...'+ c);

            }
            
        }
        system.debug('* * * updatedFRMClaims...'+ updatedFRMClaims);
        system.debug('* * * updatedERPClaims...'+ updatedERPClaims);
        
        for (CPE_Claim__c c : Trigger.new) {
        
            system.debug('* * * Loop c...'+ c);
    
            Boolean cbool = updatedFRMClaims.get(c.Id);
            
            system.debug('* * * cbool ...'+ cbool );
            
            if(cbool != null)
                c.FRM__c = true;

            cbool = updatedERPClaims.get(c.Id);
            if(cbool != null)
                c.ERP__c = true;

        }
        
        
        map < id,
        decimal > reqID2CreditTotal = new map < id,
        decimal > ();
        map < id,
        string > reqID2email = new map < id,
        string > ();
        system.debug('* * * In calculateCPECredits... allClaimsRelatedToUpdatedClaim is.. ' + allClaimsRelatedToUpdatedClaim);
        for (CPE_Claim__c c : allClaimsRelatedToUpdatedClaim) {
             system.debug('* * * c=== .. ' + c);
            if (reqID2email.get(c.Candidate_Requirement__c) == NULL)
                reqID2email.put(c.Candidate_Requirement__c, c.Member__r.email);
            if (reqID2CreditTotal.get(c.Candidate_Requirement__c) == NULL)
                reqID2CreditTotal.put(c.Candidate_Requirement__c, c.ApprovedCredits__c);
            else
                reqID2CreditTotal.put(c.Candidate_Requirement__c, reqID2CreditTotal.get(c.Candidate_Requirement__c) +
                    (c.ApprovedCredits__c == NULL ? 0 : c.ApprovedCredits__c));
        }
         system.debug('* * * creqID2CreditTotal .. ' + reqID2CreditTotal);
        list < Candidate_Requirement__c > reqs2Update = new list < Candidate_Requirement__c > ();
        for (Candidate_Requirement__c r : [
                SELECT Id, Approved_Credits__c, CPE_Credit_Requirement__c
                FROM Candidate_Requirement__c
                WHERE id IN : ReqIDsOfUpdatedClaims
            ]) {
            system.debug('* * * In calculateCPECredits... r.Approved_Credits__c is.. ' + r.Approved_Credits__c);
            system.debug('* * * In calculateCPECredits... r.CPE_Credit_Requirement__c is.. ' + r.CPE_Credit_Requirement__c);
             system.debug('* * * In reqID2CreditTotal.. ' + reqID2CreditTotal);
            r.Approved_Credits__c = reqID2CreditTotal.get(r.id);
            if (r.Approved_Credits__c >= r.CPE_Credit_Requirement__c) {
                r.Date_of_Completion__c = date.today();
                r.Status__c = 'Completed';
            } else
                r.Status__c = 'Initial';
            r.Candidate_Email__c = reqID2email.get(r.id);
            reqs2Update.add(r);
        }
        system.debug('* * * reqs2Update .. ' + reqs2Update);
        update reqs2Update;
    }

}