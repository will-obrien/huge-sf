public class examCheckin {

  private final Exam_Attempt__c ea;
  public boolean isAlreadyCheckedIn  { get; set; }
  public boolean isProctor  { get; set; }
  public string status { get; set; }
  
  public examCheckin(ApexPages.StandardController stdcontroller) {
    this.ea = (Exam_Attempt__c)stdController.getRecord(); 
    if (  ea.Checked_In__c == TRUE ) {
      isAlreadyCheckedIn = TRUE ;
    }
  }
  
    public PageReference checkin() { 
       Id profileId=userinfo.getProfileId();
       String profileName= [Select Id,Name from Profile where Id=:profileId].Name;
      
      if ( ea.Checked_In__c == TRUE ) {
        status = 'This ticket has already been used !!! ' ;
      } else {
        if ( profileName == 'Faux Proctor' ) {
          isProctor = TRUE ;
          ea.Checked_In__c = TRUE ;
          update ea ;
          status = 'You are checked in.' ;
        } else {
          isProctor = FALSE ;
          status = 'You are registered, please remember to bring your ticket to the exam.' ;
        }
      }
      return NULL ; 
    }     
}