trigger SetSeatSatus on Room__c (before update) {

  // Set & map for rooms that are being updated
  Set<id> allRooms = new Set<id>() ;
  Set<id> inactiveRooms = new Set<id>() ;
  map< ID, Room__c > RoomID2Room = new Map< ID, Room__c >();
  map< ID, list< Exam_Attempt__c >>  memberID2EAList = new map< ID, list< Exam_Attempt__c >> ();
  map< id, Exam_Attempt__c > id2EA = new map< id, Exam_Attempt__c >();
  RoomID2Room = new Map< ID, Room__c >();
  map< ID, map< string, integer > > RoomID2Counts = new Map< ID, map< string, integer > >();
  map< string, integer> innerMap ;
  List<String> innerKeys = new List<String>{'AM','PM', 'Both'}; 
  List<Exam_Attempt__c> updateEAs = new List<Exam_Attempt__c>(); 
    

  // Load maps and sets with  Room info
  for ( Room__c r : Trigger.new ) {
    innerMap = new map< string, integer>();
    for ( string s : innerKeys )  
      innerMap.put(s,0);
    RoomID2Counts.put( r.id, innerMap ) ; 
    allRooms.add(r.id);
    // Load set with ids of Rooms being deactivated
    if ( r.Active__c != TRUE )  {
      inactiveRooms.add(r.id); 
      RoomID2Room.put( r.id, r ) ;
      r.hasSeatsAssigned__c  = FALSE ;  //  Clear hasSeatsAssigned for Venues being updated
    }
  }

  //  Iterate through all EAs and increment counters so that Seats_Allocated__c can be calculated.
  integer tempCount ;
  for ( Exam_Attempt__c ea : [
    SELECT id, Room__c, Session__c, Member__c 
    FROM Exam_Attempt__c 
    WHERE Room__c IN :allRooms ] )  {
      // Room count logic
      id2EA.put( EA.id, EA ) ;
      tempCount = RoomID2Counts.get( ea.Room__c).get( ea.Session__c )+1 ;
      RoomID2Counts.get( ea.Room__c).put( ea.Session__c, tempCount ) ;
      
      //  Code to identify and link sibling EAs (siblings are EAs linked to same member)
      if ( memberID2EAList.get( ea.Member__c ) == NULL )
        memberID2EAList.put( ea.Member__c, new list<Exam_Attempt__c>( )) ;
      memberID2EAList.get( ea.Member__c).add(ea) ;
  }
  //system.debug('About to iterate memberID2EAList ...'+memberID2EAList);

  //  Iterate through rooms and save Seats_Allocated__c .
  for ( Room__c r : Trigger.new )  {
    r.Seats_Allocated__c = 
      RoomID2Counts.get( r.id ).get( 'Both' ) +
      math.max( RoomID2Counts.get( r.id ).get( 'AM' ), RoomID2Counts.get( r.id ).get( 'PM' ))  ; 
    if ( r.active__c == FALSE && r.Seats_Allocated__c == 0 ) r.Capacity__c = 0 ;
    }
  //  Iterate through exam attempts from rooms being deactivated, set hasSeatsAssigned__c if any seats have been assigned.
  for ( Exam_Attempt__c ea : [
    SELECT id, Room__c
    FROM Exam_Attempt__c 
    WHERE Room__c IN :InactiveRooms ] )  {
      RoomID2Room.get( ea.Room__c).hasSeatsAssigned__c = TRUE ;
    }
}