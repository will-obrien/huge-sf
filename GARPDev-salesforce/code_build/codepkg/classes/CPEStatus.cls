public class CPEStatus {
  private ApexPages.StandardController controller {get; set;}
  public boolean hasCPECycle {get; set;}
  public decimal approvedCredits {get; set;}
  public decimal claimedCredits {get; set;}
  public id idOfCPErequirement {get; set;}
  public integer cycleStart {get; set;}
  public integer cycleEnd {get; set;}
  public list < CPE_Claim__c> claimList { get; set; }
  private contact c;
  public CPEStatus( ApexPages.StandardController controller ) {
    //initialize the standard controller
    this.controller = controller;
    this.c = (contact)controller.getRecord();
    claimList = [
      SELECT 
        id, 
        Credits_Earned__c, 
        ApprovedCredits__c, 
        Candidate_Requirement__r.id,
        Candidate_Requirement__r.Candidate_Commitment__r.status, 
        Candidate_Requirement__r.Candidate_Commitment__r.StartDate,
        Candidate_Requirement__r.Candidate_Commitment__r.endDate
      FROM CPE_Claim__c 
      WHERE Member__c  = :c.id AND 
        ( Candidate_Requirement__r.Candidate_Commitment__r.status = 'Activated' OR Candidate_Requirement__r.Candidate_Commitment__r.status = 'Activated ( Auto-Renew )') ] ;
  if ( claimList.size() == 0 ) hasCPECycle = FALSE ;
    else {
      approvedCredits = claimedCredits = 0 ;
      hasCPECycle = TRUE ;
      idOfCPErequirement = claimList[0].Candidate_Requirement__r.id ;
      cycleStart = claimList[0].Candidate_Requirement__r.Candidate_Commitment__r.StartDate.year() ;
      cycleEnd = claimList[0].Candidate_Requirement__r.Candidate_Commitment__r.EndDate.year() ;
      for ( CPE_Claim__c claim : claimList )  {
        if ( claim.ApprovedCredits__c != NULL ) approvedCredits += claim.ApprovedCredits__c ;
        if ( claim.Credits_Earned__c != NULL ) claimedCredits += claim.Credits_Earned__c ;
      }
    }   
  }
  public pagereference goRequirement() { 
    PageReference newPage = new PageReference('/'+idOfCPErequirement) ;
    newPage.setRedirect(true);
    return newPage ;
  } 
}