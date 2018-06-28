public class EGAdmin {
  
  private final Exam_Group__c eGroup;
  public list< AsyncApexJob > activeJobs { get; set; }
  public list< AsyncApexJob > activeseatingJobs { get; set; }
  public integer noSites2Create { get; set; }
  public integer noExamAttempts2Create { get; set; }
  public integer dateOffset { get; set; }
  public string baseName { get; set; }
  public boolean hasActiveJobs { get; set; }
  public boolean hasExams {  get { return(gethasExams ( )); } set; }
  public boolean hasEAs {  get { return(gethasEAs ( )); } set; }
  public boolean isSeatingInProgress = FALSE ;
  Public boolean isRoomAssignmentsInProgress = FALSE ;
  Public boolean isRemoveTestDataInProgress = FALSE ;
  
  AssignRoomsToExamAttempts roomBatch = new AssignRoomsToExamAttempts();
  public list< Exam__c > exams { 
    get { return([
      SELECT id, name
      FROM Exam__c
      WHERE Exam_Group__c = :eGroup.id 
      ORDER BY name DESC ]); }
    set; } 
    
    public EGAdmin(ApexPages.StandardController stdcontroller) {
      this.eGroup = (Exam_Group__c)stdController.getRecord();
      //getProgress() ;
      
      
      string groupID = eGroup.id ;
      roomBatch.query = 'SELECT Id,disableMoveLogic__c,Rooms_Assigned__c FROM Exam_Group__c WHERE id = \''+ groupID+'\'' ; 
      system.debug('* * * In constructor... roomBatch is.. '+roomBatch); 
    }
    
    public PageReference doSeatCandidates() { 
      set< id > siteIDs = new set< id >() ;
      set< id > roomIDs = new set< id >() ;
      
      eGroup.disableMoveLogic__c = TRUE ;
      update eGroup ;
      for ( Exam_Sites__c examSite : [ 
        SELECT id, Site__c  
        FROM Exam_Sites__c
        WHERE Exam__r.Exam_Group__c = :eGroup.id ] ) siteIDs.add( examSite.Site__c  ) ;
      integer sitesPerBatch = (siteIDs.size() / 1) + 1 ;
      system.debug('* * * In doSeatCandidates... sitesPerBatch is.. '+sitesPerBatch);
      list< set<id> > batches = new list< set< id > > () ;
      integer x = 0, y = 0 ;
      batches.add( new set< id >() ) ;
      system.debug('* * * In doSeatCandidates... siteIDs is.. '+siteIDs);
      for ( id i : siteIDs ) {
        system.debug('* * * In doSeatCandidates... sitesPerBatch is.. '+sitesPerBatch+' x is '+x);
        if ( sitesPerBatch > x++ ) {
          batches.get( y ).add ( i ) ;
        } else {
          batches.add( new set< id >() ) ;
          x = 0 ;
          batches.get( ++y ).add ( i ) ;
        }
      }
      system.debug('* * * In doSeatCandidates... batches is.. '+batches);
      for ( set< id > s : batches ) GARP_TestDataGenerator.seatsites( s ) ;
      isSeatingInProgress = TRUE ;
      getProgress() ;
      hasActiveJobs = TRUE ;
      return NULL ; 
    }
    
    public PageReference getProgress() { 
      activeJobs = [
        SELECT id, JobType, MethodName, Status, CreatedDate, ApexClassId
        FROM AsyncApexJob 
        WHERE (MethodName = 'seatsites' OR
          MethodName = 'seatsites' OR
          MethodName = 'delAccts' OR
          MethodName = 'delEAs' OR
          MethodName = 'makeEAsBatch' OR
          MethodName = '' )
          AND
          Status != 'Completed' AND
          Status != 'Failed' AND
          Status != 'Aborted'
        ORDER BY CreatedDate DESC
        LIMIT 10] ; 
      hasActiveJobs = activeJobs.size() > 0 ? TRUE : FALSE ;
      
      if ( isRoomAssignmentsInProgress && !hasActiveJobs ) {
        eGroup.Rooms_Assigned__c = TRUE ;
        isRoomAssignmentsInProgress = FALSE ;
      }
      
      if ( isSeatingInProgress && !hasActiveJobs ) {
        eGroup.Has_Seating_Done__c = TRUE ;
        isSeatingInProgress = FALSE ;
        eGroup.Group_Locked_by_Seating_Algorithm__c = TRUE ;
      }
      
      if ( isRemoveTestDataInProgress && !hasActiveJobs ) {
        isRemoveTestDataInProgress = FALSE ;
        eGroup.Rooms_Assigned__c = FALSE ;
        eGroup.Has_Seating_Done__c = FALSE ;
        eGroup.disableMoveLogic__c = FALSE ;
        eGroup.Group_Locked_by_Seating_Algorithm__c = FALSE ;
      }
      if ( !hasActiveJobs ) update eGroup ; 
      system.debug('* * * In getSeatingProgress... activeJobs is.. '+activeJobs);
      return NULL ; 
    }

    public PageReference doRoomAllocation() {
      system.debug('* * * In doRoomAllocation... roomBatch is.. '+roomBatch); 
      Database.executeBatch(roomBatch); //invoke Batch
      getProgress() ;
      hasActiveJobs = TRUE ;
      isRoomAssignmentsInProgress = TRUE ;
      return NULL ; 
    }    
    
    public PageReference doMakeTestData() { 
      //  SECOND PARAMETER is the number of sites to create
      list< Site__c > sites = GARP_TestDataGenerator.testSites ( baseName, noSites2Create ) ;
      list< Venue__c > venues = GARP_TestDataGenerator.testVenues ( baseName+' Test Venue', sites ) ;
      list< Room__c > rooms = GARP_TestDataGenerator.testRooms ( baseName+' Test Room', venues) ;
      list< Exam__c > exams = GARP_TestDataGenerator.testExams ( baseName+' Test Exam', eGroup.id, dateOffset ) ;
      list< Exam_Sites__c > examSites = GARP_TestDataGenerator.testExamSites ( baseName+' Test Exam Site', sites,  exams ) ;
      getProgress() ;
      hasActiveJobs = TRUE ;
      return NULL ; 
    }

    public PageReference doRemoveTestData() { 
      GARP_TestDataGenerator.RemoveTestData ( eGroup.id) ;
      //getProgress() ;
      hasActiveJobs = TRUE ;
      isRemoveTestDataInProgress = TRUE ;
      return NULL ; 
    }    

    public PageReference domakeEAs() { 
      //  SECOND PARAMETER is the number of EAs to create per exam
      GARP_TestDataGenerator.makeEAs ( eGroup.id, noExamAttempts2Create) ;
      getProgress() ;
      hasActiveJobs = TRUE ;
      return NULL ; 
    }   
    
    public PageReference doHandleContractExpirations() { 
      //  SECOND PARAMETER is the number of EAs to create per exam
      contractUtil.ProcessContractExpirations(); 
      return NULL ; 
    }       
    
    
    public boolean gethasExams ( ) {
      return ([ SELECT count() FROM Exam__c WHERE  Exam_Group__c =: eGroup.id ] > 0 ? TRUE : FALSE) ;
    }

    public boolean gethasEAs ( ) {
      return ([ SELECT count() FROM Exam_Attempt__c WHERE  Exam_Site__r.Exam__r.Exam_Group__c =: eGroup.id ] > 0 ? TRUE : FALSE) ;
    }
    
}