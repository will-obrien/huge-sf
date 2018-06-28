trigger SetRoomSatus on Venue__c (before update) {

  // Set & map for venues that are inactive
  Set<id> inactiveVenues = new Set<id>() ;
  map< ID, Venue__c > VenueID2Venue = new Map< ID, Venue__c >();

  // Set & map for room in venues that are inactive
  Set<id> roomsInInactiveVenues = new Set<id>() ;
  map< ID, Venue__c > RoomID2Venue = new Map< ID, Venue__c >(); 
  
  // Load set with ids of Venues being updated
  for ( Venue__c v : Trigger.new ) {
    if ( v.Active__c != TRUE )  {
      inactiveVenues.add(v.id); 
      VenueID2Venue.put( v.id, v ) ;
      v.hasSeatsAssigned__c  = FALSE ;  //  Clear hasSeatsAssigned for Venues being updated
      v.hasActiveRooms__c = FALSE ;  // reset the room flag.. we going to recalculate it.
    }
  }
    
  // Load set and map with IDs of Rooms in Venues being updated
  for ( Room__c r : [ SELECT id, Venue__c, Active__c FROM Room__c WHERE Venue__c IN :inactiveVenues ] ) {
    roomsInInactiveVenues.add( r.id ) ;
    RoomID2Venue.put( r.id, VenueID2Venue.get(r.Venue__c) ) ;
    if ( r.active__c ) VenueID2Venue.get(r.Venue__c ).hasActiveRooms__c = TRUE ;
  }

  //  Iterate through exam attempts from venues being deactivated, set hasSeatsAssigned__c if any seats have been assigned.
  for ( Exam_Attempt__c ea : [
    SELECT id, Room__c
    FROM Exam_Attempt__c 
    WHERE Room__c IN :roomsInInactiveVenues ] )  {
      RoomID2Venue.get( ea.Room__c).hasSeatsAssigned__c = TRUE ;
    }

}