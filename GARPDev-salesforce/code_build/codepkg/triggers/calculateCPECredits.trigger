trigger calculateCPECredits on CPE_Claim__c (before update) {

    // BEEN REPLACED WITH onCPDClaimBeforeUpdate
    // LEAVE DEACTIVATED
/*
  id recType4CPEReq = [SELECT id FROM RecordType WHERE SobjectType = 'Candidate_Requirement__c' and DeveloperName = 'CPE' LIMIT 1 ].id ;
  set< id > newlyUpdatedClaimIDs = new Set<id>() ; 
  set< id > ReqIDsOfUpdatedClaims = new Set<id>() ;   
    
  List<CPE_Claim__c> updateClaims = new List<CPE_Claim__c>();
    
    
  for ( CPE_Claim__c c : Trigger.new ) {
  
    if( c.ApprovedCredits__c == null && c.Approved__c == true && Trigger.oldMap.get(c.Id).Approved__c == false) {
        newlyUpdatedClaimIDs.add ( c.id ) ;
        ReqIDsOfUpdatedClaims.add( c.Candidate_Requirement__c ) ;
        c.ApprovedCredits__c = c.Credits_Earned__c;
        
        updateClaims.add(c);
        newlyUpdatedClaimIDs.add ( c.id ) ;
        ReqIDsOfUpdatedClaims.add( c.Candidate_Requirement__c ) ;
          
    } else if(c.ApprovedCredits__c != null && c.Approved__c == false && Trigger.oldMap.get(c.Id).Approved__c == true) {
        c.ApprovedCredits__c = null;
        updateClaims.add(c);
        newlyUpdatedClaimIDs.add ( c.id ) ;
        ReqIDsOfUpdatedClaims.add( c.Candidate_Requirement__c ) ;
        
    } else if ( c.ApprovedCredits__c != null && c.ApprovedCredits__c > 0) {
        system.debug('* * * In calculateCPECredits... c is.. '+c); 
        system.debug('* * * In calculateCPECredits... Trigger.oldMap.get(c.Id) is.. '+Trigger.oldMap.get(c.Id));
        if(c.Approved__c != true) {
            c.Approved__c = true;
            updateClaims.add(c);
        }
        newlyUpdatedClaimIDs.add ( c.id ) ;
        ReqIDsOfUpdatedClaims.add( c.Candidate_Requirement__c ) ;
    }
  }
  //update updateClaims;
    
    
  if ( newlyUpdatedClaimIDs.size() > 0 ) {
      
     
      
    list< CPE_Claim__c > allClaimsRelatedToUpdatedClaim = new list< CPE_Claim__c > () ;
    for( CPE_Claim__c c : [ 
      SELECT Id,  ApprovedCredits__c, Candidate_Requirement__c, Candidate_Requirement__r.RecordTypeId,
        Member__r.email
      FROM CPE_Claim__c 
      WHERE Candidate_Requirement__c IN :ReqIDsOfUpdatedClaims 
      ] ) 
      if ( c.Candidate_Requirement__r.RecordTypeId == recType4CPEReq ) allClaimsRelatedToUpdatedClaim.add ( c ) ;
    
    map< id, decimal > reqID2CreditTotal = new map< id, decimal >() ;
    map< id, string > reqID2email = new map< id, string >() ;
    system.debug('* * * In calculateCPECredits... allClaimsRelatedToUpdatedClaim is.. '+allClaimsRelatedToUpdatedClaim); 
    for ( CPE_Claim__c c : allClaimsRelatedToUpdatedClaim ) {
      if ( reqID2email.get( c.Candidate_Requirement__c ) == NULL ) 
        reqID2email.put( c.Candidate_Requirement__c, c.Member__r.email ) ;
      if ( reqID2CreditTotal.get( c.Candidate_Requirement__c ) == NULL )
        reqID2CreditTotal.put( c.Candidate_Requirement__c, c.ApprovedCredits__c ) ;
      else 
       reqID2CreditTotal.put( c.Candidate_Requirement__c, reqID2CreditTotal.get( c.Candidate_Requirement__c ) + 
         (c.ApprovedCredits__c == NULL ? 0 : c.ApprovedCredits__c )  ) ;
    }

    list< Candidate_Requirement__c > reqs2Update = new list< Candidate_Requirement__c >() ;
    for ( Candidate_Requirement__c r: [
      SELECT Id,  Approved_Credits__c, CPE_Credit_Requirement__c
      FROM Candidate_Requirement__c 
      WHERE id IN :ReqIDsOfUpdatedClaims 
      ] ) {    
      system.debug('* * * In calculateCPECredits... r.Approved_Credits__c is.. '+r.Approved_Credits__c);
      system.debug('* * * In calculateCPECredits... r.CPE_Credit_Requirement__c is.. '+r.CPE_Credit_Requirement__c);  
      r.Approved_Credits__c = reqID2CreditTotal.get( r.id ) ;
      if ( r.Approved_Credits__c >= r.CPE_Credit_Requirement__c ) {
        r.Date_of_Completion__c = date.today() ;
        r.Status__c = 'Completed' ;
      } else r.Status__c = 'Initial' ;
      r.Candidate_Email__c  = reqID2email.get( r.id ) ;
      reqs2Update.add( r ) ; 
    }    
    update reqs2Update ;
  }*/
}