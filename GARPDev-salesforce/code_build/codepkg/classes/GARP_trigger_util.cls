public class GARP_trigger_util {
  

  public class EA_Item {
    public Exam_Attempt__c EA { get; set; }
    public boolean invoking_EA { get; set; }
    public boolean isRoomActive { get; set; }
    public boolean isVenueActive { get; set; }
    public boolean isSiteActive { get; set; }
    public string status { get; set; }
    public string error { get; set; }
    public string session { get; set; }
    public id originalEA  { get; set; }
    public id site  { get; set; }
    public id examGroup  { get; set; }
    public id contact  { get; set; }
    public id newRoom { get; set; }
    
    public EA_Item( 
      Exam_Attempt__c EAttempt, 
      boolean I_EA,
      boolean iRoom,
      boolean iVenue,
      boolean iSite, 
      string st,
      string er,
      string ses,
      id OEA,
      id s, 
      id EG,
      id c,
      id NewR ) {
        this.EA = EAttempt;          
        this.invoking_EA = I_EA;
        this.isRoomActive = iRoom;
        this.isVenueActive = iVenue;
        this.isSiteActive = iSite;
        this.status = st ;
        this.error = er ;
        this.session = ses ;
        this.originalEA = OEA ;
        this.site = s ;
        this.examGroup = EG ;
        this.contact = c ;    
        this.newRoom = NewR ;
    }
  }
 
  public static  list< Exam_Attempt__c> LinkEAs ( list <Exam_Attempt__c> InvokingEAs ) { 
    set<id> members = new set<id>() ;
    set<id> roomIDs = new set<id>() ;
    set<id> siteIDs = new set<id>() ;
    set<id> venueIDs = new set<id>() ;
    set<id> examGroups = new set<id>() ;
    set<id> oldRoomIDs = new set<id>() ;
    set<id> targetrooms = new set<id>() ;
    set<id> invokingEAset = new set<id>() ;
    map< id, Exam_Attempt__c > invokingEAid2EA = new map< id, Exam_Attempt__c >();
    map< id, room__c > roomID2Room = new map< id, room__c >();
    map< id, id > EAid2TargetRoomID = new map< id, id >();
    map< id, id > contactID2OriginalEAID = new map< id, id >();
    map< id, map< string, id > > roomID2ExamSiteMap = new map< id, map< string, id > > ();
    map< id, id > siteID2RoomID = new map< id, id >();
    list<room__c> roomList = new list<room__c> () ;
    list<Exam_Attempt__c> updateEAs = new List<Exam_Attempt__c>(); 
    EA_Item tempEA ;
    Map< id, boolean > eaID2disableMoveLogicBoolean = new Map< id, boolean > () ;
    set<id> allInvokingEAs = new set<id>() ;
    for( Exam_Attempt__c  ea :invokingEAs) allInvokingEAs.add( ea.id ) ;
    
    for( Exam_Attempt__c ea : [
      SELECT id, Exam_Site__r.Exam__r.Exam_Group__r.disableMoveLogic__c 
      FROM Exam_Attempt__c 
      WHERE id IN : allInvokingEAs ] ) 
        eaID2disableMoveLogicBoolean.put( ea.id, ea.Exam_Site__r.Exam__r.Exam_Group__r.disableMoveLogic__c ) ;
    
   
    for( Exam_Attempt__c  ea :invokingEAs) {
      Exam_Attempt__c oldEA = (Exam_Attempt__c)Trigger.oldMap.get(EA.ID) ;
     
      if( oldEA.Room__c != EA.Room__c  && 
        ( ea.room__c != NULL ) &&  
        (eaID2disableMoveLogicBoolean.get( ea.id ) != TRUE) )  {
        contactID2OriginalEAID.put( ea.member__c, ea.id ) ;
        invokingEAset.add( ea.id ) ;
        roomIDs.add( ea.room__c ) ;
        EAid2TargetRoomID.put( ea.id, ea.room__c ) ;
        invokingEAid2EA.put( ea.id, ea ) ;
        oldRoomIDs.add( oldEA.Room__c ) ;
      }
    }
  
    if( ! roomIDs.isEmpty() ) {
      for ( room__c r : [SELECT id, venue__r.site__c FROM room__c WHERE id IN :roomIDs ]) {
        siteIDs.add( r.venue__r.site__c ) ;
        siteID2RoomID.put( r.venue__r.site__c, r.id ) ;
        roomID2ExamSiteMap.put( r.id, new map< string, id >() ) ;
      }
      for ( Exam_Sites__c es : [SELECT id, Site__c, exam__r.exam__c FROM Exam_Sites__c WHERE site__c IN :siteIDs ] ) {
        roomID2ExamSiteMap.get( siteID2RoomID.get( es.Site__c)).put( es.exam__r.exam__c, es.id ) ;
      }
     
      for( Exam_Attempt__c  ea :invokingEAid2EA.values()) {
        ea.Exam_Site__c = roomID2ExamSiteMap.get( ea.room__c ).get( ea.Section__c ) ;
      }
   
      for ( Exam_Attempt__c iEA : [
        SELECT id, Session__c, Member__c, Site__c, Exam_Site__r.Exam__r.Exam_Group__c, 
          Exam_Site__r.Exam__r.Exam_Seating__c, Exam_Site__r.Site__c,
          Exam_Site__r.Exam__r.Exam_Group__r.Group_Locked_by_Seating_Algorithm__c, 
          room__r.venue__r.site__c, room__r.venue__r.active__c, Room__r.Active__c,
          room__r.venue__r.site__r.active__c
        FROM Exam_Attempt__c
        WHERE id IN :invokingEAset ] ) {
        
        if ( ! iEA.Exam_Site__r.Exam__r.Exam_Group__r.Group_Locked_by_Seating_Algorithm__c ) {
         
          members.add ( iEA.member__c ) ;
          examGroups.add ( iEA.Exam_Site__r.Exam__r.Exam_Group__c ) ;
          targetrooms.add ( invokingEAid2EA.get(iEA.id ).room__c) ;
          tempEA = new EA_Item(
            invokingEAid2EA.get(iEA.id) ,
            TRUE ,
            iEA.room__r.active__c,
            iEA.room__r.venue__r.active__c,
            iEA.room__r.venue__r.site__r.active__c,
            'In Progress',
            '',
            iEA.Exam_Site__r.Exam__r.Exam_Seating__c ,
            iEA.id,
            iEA.Exam_Site__r.Site__c,
            iEA.Exam_Site__r.Exam__r.Exam_Group__c,
            iEA.member__c, 
            EAid2TargetRoomID.get( iEA.id ) ) ;
          
          ifNotPresentAddEA2Structure ( tempEA, TRUE, EAid2TargetRoomID.get( iEA.id  ) ) ; 
        } else {
          
          invokingEAid2EA.get(iEA.id ).room__c.addError('Exam Group is locked... please try again later.') ;
        }
      }
    
      for ( Room__c r :[ SELECT id, capacity__c, AM_Seats_Allocated__c, PM_Seats_Allocated__c  
        FROM Room__c WHERE id IN :targetrooms ] )  {
        roomList.add( r ) ;
        roomID2Room.put( r.id, r ) ;
      }
      update ( roomList ) ;  
      for ( Room__c r :[ 
        SELECT id, capacity__c, AM_Seats_Allocated__c, PM_Seats_Allocated__c, active__c, 
          venue__r.active__c, venue__r.site__r.active__c
        FROM Room__c WHERE id IN :targetrooms ] )  {
        roomID2Room.put( r.id, r ) ;
      }
       
      for(map< id, GARP_trigger_util.EA_Item> eaMAP : CandidateMoveMap.memberID2EA_map.values()) {
        for ( GARP_trigger_util.EA_Item ei : eaMAP.values() ){
          if( ei.status == 'In Progress' ) {
            Decimal tempCapacity = roomID2Room.get( invokingEAid2EA.get(ei.EA.id).room__c ).capacity__c ;
          
            Decimal tempAMSeatsAvailable = tempCapacity - roomID2Room.get( invokingEAid2EA.get(ei.EA.id).room__c ).AM_Seats_Allocated__c ;
            Decimal tempPMSeatsAvailable = tempCapacity - roomID2Room.get( invokingEAid2EA.get(ei.EA.id).room__c ).PM_Seats_Allocated__c ;
            boolean hasAvailableSeat = TRUE ;
            if ( ! roomID2Room.get( invokingEAid2EA.get(ei.EA.id).room__c ).active__c ) hasAvailableSeat = FALSE ;
            if ( ! roomID2Room.get( invokingEAid2EA.get(ei.EA.id).room__c ).venue__r.active__c ) hasAvailableSeat = FALSE ;
            if ( ! roomID2Room.get( invokingEAid2EA.get(ei.EA.id).room__c ).venue__r.site__r.active__c ) hasAvailableSeat = FALSE ;
            if ( ( ei.session == 'AM' || ei.session == 'Both' ) && ( tempAMSeatsAvailable < 1 )  )
              hasAvailableSeat = FALSE ;
            if ( ( ei.session == 'PM' || ei.session == 'Both' ) && ( tempPMSeatsAvailable < 1 )  )
              hasAvailableSeat = FALSE ;           
           
            if ( ! hasAvailableSeat ) {
              invokingEAid2EA.get(ei.EA.id).room__c.addError('Insufficient seats in target room.') ;
              ei.status = 'Error' ;
              system.debug('* * * * * * Thowing insufficiant space error ei.EA is '+ei.EA ) ;
            } else {
              CandidateMoveMap.memberID2EA_map.get( ei.EA.Member__c ).get( ei.EA.id ).status = 'Done' ;
             
            }        
          }
        } 
      }
      id targetRoom ;
      for ( Exam_Attempt__c relatedEAs : [
        SELECT id, Room__c, Session__c, Member__c, Site__c, Exam_Site__r.Exam__r.Exam_Group__c, 
          Exam_Site__r.Exam__r.Exam_Seating__c, Exam_Site__r.Site__c, room__r.active__c,
          room__r.venue__r.active__c, room__r.venue__r.site__r.active__c
        FROM Exam_Attempt__c
        WHERE Member__c IN :members AND Exam_Site__r.Exam__r.Exam_Group__c IN :examGroups 
      ] ) {
        targetRoom = GetTargetRoomID( relatedEAs.Member__c) ;
        tempEA = new EA_Item(
          relatedEAs ,
          TRUE ,
          relatedEAs.room__r.active__c,
          relatedEAs.room__r.venue__r.active__c,
          relatedEAs.room__r.venue__r.site__r.active__c,
          'Initial',
          '' ,
          relatedEAs.Exam_Site__r.Exam__r.Exam_Seating__c,
          contactID2OriginalEAID.get( relatedEAs.member__c ),
          relatedEAs.Exam_Site__r.Site__c,
          relatedEAs.Exam_Site__r.Exam__r.Exam_Group__c,
          relatedEAs.member__c, 
          targetRoom ) ;
      
        Exam_Attempt__c EAtemp = ifNotPresentAddEA2Structure ( tempEA, FALSE, targetRoom ) ;
        if ( EAtemp != NULL ) updateEAs.add( EAtemp ) ;
      }
     
    } 
    return ( updateEAs ) ;
  }
        
  private static Exam_Attempt__c ifNotPresentAddEA2Structure ( EA_Item EAitem, boolean isinvoking, id targetRoom ) {
   
    
    Exam_Attempt__c EA2Update = new Exam_Attempt__c () ;
    if ( CandidateMoveMap.memberID2EA_map.get( EAitem.EA.Member__c ) == NULL )
      CandidateMoveMap.memberID2EA_map.put( EAitem.EA.Member__c, new map< id, EA_Item > () ) ;      
      if ( CandidateMoveMap.memberID2EA_map.get( EAitem.EA.Member__c ).get( EAitem.EA.id ) == NULL ) {
        EA_Item eItem = new EA_Item(
          EAitem.EA ,
          TRUE ,
          EAitem.isRoomActive,
          EAitem.isVenueActive,
          EAitem.isSiteActive,
          isinvoking ?'In Progress' : 'Initial',
          '' ,
          EAitem.EA.session__c,
          EAitem.originalEA,
          EAitem.site,
          EAitem.examGroup,
          EAitem.EA.Member__c,
          targetRoom ) ;
        CandidateMoveMap.memberID2EA_map.get( EAitem.EA.Member__c ).put( EAitem.EA.id , eItem ) ;
        EA2Update =  EAitem.EA ;
        EA2Update.room__c =  targetRoom ;
      } 
      else { 
        if ( CandidateMoveMap.memberID2EA_map.get( EAitem.EA.Member__c ).get( EAitem.EA.id ).status == 'Initial' )
          CandidateMoveMap.memberID2EA_map.get( EAitem.EA.Member__c ).get( EAitem.EA.id ).status = 'In Progress' ;
        return ( NULL ) ;
      }  
   
    return ( EA2Update ) ;   
  } 
  
  private static id GetTargetRoomID ( id memberID ) {
    
    if ( CandidateMoveMap.memberID2EA_map.get( memberID ) != NULL ) 
      for ( GARP_trigger_util.EA_Item ei :  CandidateMoveMap.memberID2EA_map.get( memberID ).values() ){
        if ( ei.status == 'Done' || ei.status == 'In Progress' ) {
          
          return ( ei.EA.room__c ) ;
        }
      }
  return ( NULL ) ;   
  }               
}