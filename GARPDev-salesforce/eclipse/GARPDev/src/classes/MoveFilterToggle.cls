public class MoveFilterToggle {

  public boolean MoveFilterState {get; set; }

  public MoveFilterToggle() {  
    system.debug('Entering MoveFilterToggle.... disableCandidateMoveFilter is :::: '+CandidateMoveMap.disableCandidateMoveFilter);
    MoveFilterState = CandidateMoveMap.disableCandidateMoveFilter ;
    
  }
  
  public PageReference ToggleFilter() {
  
    if ( MoveFilterState == TRUE || MoveFilterState == NULL )  MoveFilterState = FALSE ; ELSE MoveFilterState = TRUE ; 
    
    CandidateMoveMap.disableCandidateMoveFilter = MoveFilterState ;
    system.debug('After click assign MoveFilterToggle.... disableCandidateMoveFilter is :::: '+CandidateMoveMap.disableCandidateMoveFilter);
    
    return null ;
  }
  
}