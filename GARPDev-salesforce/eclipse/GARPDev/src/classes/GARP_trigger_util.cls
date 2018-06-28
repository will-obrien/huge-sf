public class GARP_trigger_util {

/* This class contains a collection of methods used by various triggers in the GARP SF System.
  
   Methods are listed under the trigger object that they were designed to run from.... this is not  
   meant to imply they can only be used in that context.
*/

/*
Exam Attempt
*/

  
  
  // Structure used to hold information relating to EAs being moved from one room or venue to another.
  public class EA_Item {
    public Exam_Attempt__c EA { get; set; }
    public boolean invoking_EA { get; set; }
    public boolean isOrriginalEA { get; set; }
    public string status { get; set; }
    public id oldRoom { get; set; }
    public id newRoom { get; set; }
    
    public EA_Item( 
      Exam_Attempt__c EAttempt, 
      boolean I_EA, 
      boolean OEA,
      string st,
      id OldR,
      id NewR ) {
        this.EA = EAttempt;          
        this.invoking_EA = I_EA;
        this.isOrriginalEA = OEA;
        this.status = st ;
        this.oldRoom = OldR ;
        this.newRoom = NewR ;
    }
  }
  // Identifies and moves related EAs when one are being moved. ( i.e. one candidate taking FRM1&2 on same day)
  public static  list< Exam_Attempt__c> LinkEAs ( list <Exam_Attempt__c> InvokingEAs ) {
    set<id> members = new set<id>() ;
    set<id> oldRoomIDs = new set<id>() ;
    set<id> targetrooms = new set<id>() ;
    map< id, Exam_Attempt__c > memberID2EA = new map< id, Exam_Attempt__c >();
    map< id, room__c > id2Room = new map< id, room__c >();
    map< id, room__c > id2OldRoom = new map< id, room__c >();
    map< id, Exam_Attempt__c > id2EA = new map< id, Exam_Attempt__c >();
    list<room__c> roomList = new list<room__c> () ;
    list<Exam_Attempt__c> updateEAs = new List<Exam_Attempt__c>(); 
    system.debug('* * * new invocation of before update trigger ...'+trigger.new);
    //  Create sets and maps for invoking EAs
    
    for( Exam_Attempt__c  EA :InvokingEAs) {
      Exam_Attempt__c oldEA = (Exam_Attempt__c)Trigger.oldMap.get(EA.ID) ;
      if( oldEA.Room__c != EA.Room__c)  {
        oldRoomIDs.add( oldEA.room__c ) ;
        members.add( EA.Member__c ) ;
        id2EA.put( EA.id, EA ) ;
        memberID2EA.put( EA.Member__c, EA ) ;
        targetrooms.add(EA.Room__c) ;
      } else {
        oldRoomIDs.add( oldEA.room__c ) ;
        members.add( EA.Member__c ) ;
        id2EA.put( EA.id, EA ) ;
        memberID2EA.put( EA.Member__c, EA ) ;
        targetrooms.add(EA.Room__c) ;
      }
    }
    // Create and load room map
    system.debug('* * * * * * @64 oldRoomIDs is '+oldRoomIDs  );
    for( room__c r : [ SELECT id, Capacity__c, Seats_Allocated__c, venue__r.site__r.id FROM room__c WHERE id IN :oldRoomIDs] ) {
      id2Room.put( r.id, r ) ;
    } 
    system.debug('* * * * * * @68 id2Room is '+id2Room  );
    for( room__c r : [ SELECT id, Seats_Allocated__c, venue__r.site__r.id FROM room__c WHERE id IN :targetrooms] ) {
      roomList.add( r ) ;
    } 
    
    update roomList ; // Force recalculation of room capacities before we start.   
    for( room__c r : [ 
      SELECT id, Capacity__c, Seats_Allocated__c, venue__r.site__r.id 
      FROM room__c WHERE id IN :targetrooms] ) {
      id2Room.put( r.id, r ) ; // Seats_Allocated__c
    }
    
    set<id> ExistingRoomIDs = new set<id>() ;
    for(map< id, GARP_trigger_util.EA_Item> eaMAP : CandidateMoveMap.memberID2EA_map.values())
        for( GARP_trigger_util.EA_Item eaItem : eaMAP.values() ) {
          ExistingRoomIDs.add( eaItem.oldRoom ) ;
          ExistingRoomIDs.add( eaItem.newRoom ) ;
        }          
    for( room__c r : [ SELECT id, Capacity__c, Seats_Allocated__c, venue__r.site__r.id FROM room__c WHERE id IN :ExistingRoomIDs] )
      id2Room.put( r.id, r ) ;       
    
    
    
    boolean ea_hasERROR ;
    id oldroom ;
    id newRoom ;
    boolean isOrriginalEARequest ;
    for( Exam_Attempt__c  ea  : [
      SELECT id, Room__c, Session__c, Member__c, Site__c 
      FROM Exam_Attempt__c 
      WHERE Member__c in :members ] ) {
        isOrriginalEARequest = FALSE ;
        ea_hasERROR = FALSE ;
        // Get id of oldRoom and newRoom of current EA
        Exam_Attempt__c tempEA = (Exam_Attempt__c)Trigger.oldMap.get(memberID2EA.get( ea.Member__c ).id) ;
        oldroom = tempEA.room__c ;
        newRoom = memberID2EA.get( ea.Member__c ).room__c ;
        
        // Link multiple EAs by placing them in lists by member      
        // If EA isn't from same exam site (way to tell that EAs are in same exam collection) IGNORE it * * * THIS NEEDS TO BE UPDATED WHEN WE GET THE ABILITY TO SEE TO THE SITE LEVEL
        if ( memberID2EA.get( ea.Member__c ).Site__c == ea.Site__c &&
          // if new room is NULL don't add to move Q (just let update go)
          id2Room.get(newroom) != NULL ) {
             
          // If target room has insufficient capacity throw error else move them. 
          // ONLY CAN THROW ERROR FOR ORRIGINAL REQUEST         
          if ( id2Room.get(newroom).Capacity__c < id2Room.get(newroom).Seats_Allocated__c + 1 ) {   
            // Throw an error if this move can't be accomodated ...         
            ea_hasERROR = TRUE ;
          } else {
            // Move the EA
            // Don't need to set anything just let the update proceed.
          }      
          // If member isn't already in work Q ADD him
          if ( id2EA.get(ea.id) != NULL ) isOrriginalEARequest = True ;
          if ( CandidateMoveMap.memberID2EA_map.get( ea.Member__c ) == NULL ) {
            CandidateMoveMap.memberID2EA_map.put( ea.Member__c, new map< id, EA_Item > () ) ;
            
            system.debug('* * * * * * debug id2EA is '+id2EA ) ;
            system.debug('* * * * * * debug CandidateMoveMap.memberID2EA_map is '+CandidateMoveMap.memberID2EA_map ) ;
            system.debug('* * * * * * debug ea.id is '+ea.id ) ;
            system.debug('* * * * * * debug id2EA.get(ea.id) is '+id2EA.get(ea.id) ) ;
            if ( ea_hasERROR && isOrriginalEARequest ) id2EA.get(ea.id).room__c.addError('Insufficient seats in target room.') ;
          }
          // If EA is NOT already in map add it 
          if ( CandidateMoveMap.memberID2EA_map.get(ea.Member__c).get(ea.id) == NULL ) {
          CandidateMoveMap.memberID2EA_map.get( ea.Member__c).put( ea.id, new GARP_trigger_util.EA_Item( 
            ea, 
            id2EA.get( ea.id) == NULL ? FALSE : TRUE,  // is Invoking ea
            isOrriginalEARequest ? TRUE : FALSE,
              ea_hasERROR ? 'Error' : 
                id2EA.get( ea.id) == NULL ? 'Intial' : 'In Progress',  // status
              oldroom,                                // oldRoom
              newRoom  )) ;                            // newRoom
          } else {
            // Update existing entry in map
            EA_Item tempItem = CandidateMoveMap.memberID2EA_map.get(ea.Member__c).get(ea.id) ;
            if ( id2EA.get( ea.id) == NULL ) {
              //  Not invoking EA
              tempItem.invoking_EA = FALSE ;  // is Invoking ea 
              tempItem.status  = ea_hasERROR ? 'Error' : (tempItem.status == 'In Progress') ?
                'In Progress' : 'Intial' ;
            } else {
              tempItem.invoking_EA = TRUE ;
              tempItem.status  = ea_hasERROR ? 'Error' : 'In Progress' ;          
            }        
          } 
        }   
    }  
    // Iterate through memberID2EA_map and process related EAs ( add them to update list)
    boolean isDone = TRUE ;
    decimal sessionCount = 0 ;
    for(map< id, GARP_trigger_util.EA_Item> eaMAP : CandidateMoveMap.memberID2EA_map.values()) {
      system.debug('* * * DUMP  ...CandidateMoveMap.memberID2EA_map'+CandidateMoveMap.memberID2EA_map);
      system.debug('* * * Found EA Siblings ...'+eaMAP);
      sessionCount = calculateSessions( eaMAP ) ;
      if ( sessionCount == 1) {
        system.debug('* * * Found list with 2 EA Siblings ...'+eaMAP);
        for ( GARP_trigger_util.EA_Item ei : eaMAP.values() ){
          if ( (! ei.invoking_EA) && ei.status == 'Intial') {
            //  This is a related EA that also needs to be updated
            system.debug('* * * * * * @162 ei.EA is '+ei.EA  );
            system.debug('* * * * * * @162 ei.newRoom is '+ei.newRoom  );
 
            ei.EA.room__c = ei.newRoom ;
            ei.status = 'In Progress' ;
            updateEAs.add( ei.EA ) ;
            isDone = FALSE ;
          } 
        } 
      }
      // Check if old and new rooms are in same site... if not throw error
        //system.debug('* * * Checking for site move error ... id2OldRoom.get(ie.oldRoom).venue__r.site__r.idd is:::'+id2OldRoom.get(ie.oldRoom).venue__r.site__r.id);
        //system.debug('* * * Checking for site move error ... id2Room.get(ie.newRoom).venue__r.site__r.idis:::'+id2Room.get(ie.newRoom).venue__r.site__r.id);
        for ( GARP_trigger_util.EA_Item ei : eaMAP.values() ){
          system.debug('* * * * * * @165 id2Room is '+id2Room  );
          system.debug('* * * * * * @165 ei.newRoom is '+ei.newRoom  );
          system.debug('* * * * * * @166 id2Room.get(ei.newRoom) is '+id2Room.get(ei.newRoom)) ;
          system.debug('* * * * * * @165 ei.oldRoom is '+ei.oldRoom  );
          system.debug('* * * * * * @166 id2Room.get(ei.oldRoom) is '+id2Room.get(ei.oldRoom)) ;
          system.debug('* * * * * * @166 CandidateMoveMap.memberID2EA_map is '+CandidateMoveMap.memberID2EA_map) ;
          
          system.debug('* * * * * * @167 id2Room.get(ei.oldRoom).venue__r.site_id2Rooms '+id2Room.get(ei.oldRoom).venue__r.site__r.id) ;
          if ( id2Room.get(ei.oldRoom).venue__r.site__r.id != id2Room.get(ei.newRoom).venue__r.site__r.id) {
            if ( id2EA.get(ei.ea.id) != NULL )id2EA.get(ei.ea.id).room__c.addError('Cannot move to room in another site... must first move candidate to the new site.') ;
            ei.status = 'Error' ;
          }
        }  
      
      if ( sessionCount > 1) {
        // stub for future detection of anomalies
        system.debug('* * * * * * More than two EAs throwing errors' ) ;
        for ( GARP_trigger_util.EA_Item ei : eaMAP.values() ){
        if ( id2EA.get( ei.ea.id) != NULL ) id2EA.get(ei.ea.id).room__c.addError('Too many EAs... Candidate is double booked.') ;
        ei.status = 'Error' ;  
        }
      } 
      if ( sessionCount < 1) {
        system.debug('* * * * * * Less than two EAs do nothing.' ) ;
        for ( GARP_trigger_util.EA_Item ei : eaMAP.values() ){        
          ei.status = 'Done' ;
        }
      }
    }
  //system.debug('* * * Exiting LinkEAs... isDone is ...'+isDone);
  return  updateEAs; 
  } 
  public static void clear_memberID2EA_ifDone ( list<Exam_Attempt__c> eaList ) { 
    if ( CandidateMoveMap.memberID2EA_map.size() > 0 ) {
      GARP_trigger_util.EA_Item eItem ;
      system.debug('* * *  Entering clear_memberID2EA_ifDone DUMP  ...CandidateMoveMap.memberID2EA_map'+CandidateMoveMap.memberID2EA_map);
      for( Exam_Attempt__c ea : eaList ) {
        eItem = CandidateMoveMap.memberID2EA_map.get(ea.Member__c).get( ea.id ) ;
        if ( eItem.status == 'In Progress' ) {
          eItem.status = 'Done' ;
          CandidateMoveMap.memberID2EA_map.get(ea.Member__c).put( ea.id, eItem ) ;
        }
      }
      boolean isDone = TRUE ;
      system.debug('* * *  About to run clear loop DUMP  ...CandidateMoveMap.memberID2EA_map'+CandidateMoveMap.memberID2EA_map);
      for(map< id, GARP_trigger_util.EA_Item> eaMAP : CandidateMoveMap.memberID2EA_map.values()) {
        for( GARP_trigger_util.EA_Item eaItem : eaMAP.values() ) 
          if( eaItem.status != 'Done' ) isDone = FALSE ; 
      } 
      if( isDone ) CandidateMoveMap.memberID2EA_map.clear() ;
      system.debug('* * *  Exiting clear_memberID2EA_ifDone  DUMP  ...CandidateMoveMap.memberID2EA_map'+CandidateMoveMap.memberID2EA_map);
      return;
    }
  }
  private static decimal calculateSessions ( map< id, GARP_trigger_util.EA_Item>  eItemMap) {
    decimal count = 0 ;
    for ( GARP_trigger_util.EA_Item ei : eItemMap.values() ){
      if ( ei.EA.Session__c == 'Both' ) count++ ; else count = count + .5 ;
    }
    system.debug('* * *  Exiting calculateSessions....'+count);
    return ( count ) ;
  }
}