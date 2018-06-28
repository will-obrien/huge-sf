public class GARP_TestDataGenerator {

/* This class contains a collection of methods used to generate large volumes of test data.


*/

  public static  list< Site__c > testSites ( string baseName, integer noSites) {

    list< Site__c > sites2Insert = new list< Site__c > () ;
    Site__c nSite ;
    system.debug('* * * In testSites... noSites is.. '+noSites);
    for ( integer i = 0 ; i < noSites; i++ ) { 
      system.debug('* * * In testSites... i is.. '+i);
      nSite = new Site__c (
        name = baseName + ' - ' + i.format(),
        No_of_Exam_Attempts__c = 0,
        No_of_Members_Enrolled_for_ERP__c = '0',
        No_of_Members_Enrolled_for_FRM1_2__c = '0',
        No_of_Members_Enrolled_for_FRM1_Only__c = '0',
        No_of_Members_Enrolled_for_FRM_2_Only__c = '0',
        No_of_Members_Enrolled__c = 0,
        active__c = TRUE ) ;
    sites2Insert.add( nSite ) ;  
    }
    insert  sites2Insert ;
    system.debug('* * * In testSites... sites2Insert is.. '+sites2Insert);
    return ( sites2Insert ) ; 
  }


  public static  list< Venue__c > testVenues ( string baseName, list< Site__c > sList) {
    system.debug('* * * In testVenues... sList is.. '+sList);
    list< Venue__c > venues2Insert = new list< Venue__c > () ;
    Venue__c nVenue ;
    for ( Site__c s : sList ) 
      for ( integer i = 0 ; i < math.round( (math.random() * 5)+1 ); i++ ) {  // random number between 1 and 5
        nVenue = new Venue__c (
          name = baseName + ' - ' + s.name + ' - ' + i.format(),
          Active__c = TRUE,
          Site__c = s.id ) ;
    venues2Insert.add( nVenue ) ;  
    }
    system.debug('* * * In testVenues... venues2Insert is.. '+venues2Insert);
    insert  venues2Insert ;
    return ( venues2Insert ) ; 
  }
  
  public static  list< Room__c > testRooms ( string baseName, list< Venue__c > vList) {
    system.debug('* * * In testRooms... vList is.. '+vList);
    list< Room__c > rooms2Insert = new list< Room__c > () ;
    Room__c nRoom ;
    for ( Venue__c v : vList ) 
      for ( integer i = 0 ; i < math.round( (math.random() * 10)+1 ); i++ ) { // random number between 1 and 10
        nRoom = new Room__c (
          name = baseName + ' - ' + v.name + ' - ' + i.format(),
          active__c = TRUE,
          Venue__c = v.id,
          Capacity__c = 20,
          PM_Seats_Allocated__c = 0,
          AM_Seats_Allocated__c = 0,
          Seats_Allocated__c = 0 ) ;
      rooms2Insert.add( nRoom ) ;  
      }
    system.debug('* * * In testRooms... rooms2Insert is.. '+rooms2Insert);
    insert  rooms2Insert ;
    return ( rooms2Insert ) ; 
  }
  

  
  public static  list< Exam__c > testExams ( string baseName, id egID, integer dateOffset ) {
    list< Exam__c > exams2Insert = new list< Exam__c > () ;
    Exam__c nExam ;
    
//  MAKE THE FRM 1 EXAM
    nExam = new Exam__c ( 
      name = 'FRM1 - ' + baseName, 
      Exam_Group__c = egID,
      Deferral_Fee__c = 50 , 
     // Early_Exam_Registration_Fee__c = 100 , 
      Enrollment_Fee__c = 200 , 
      Exam_Request_Change_Fee__c = 50 , 
     // Late_Exam_Registration_Fee__c = 200 , 
     // Standard_Exam_Registration_Fee__c = 150  , 
      Exam__c = 'FRM Part 1' , //  FRM Part 2   ERP 
      Exam_Seating__c = 'AM' , // PM Both
      Exam_Status__c = 'Review Completed'  , //In Progress  Ready for Review  Review Completed
      Exam_Date__c = date.today() +45 + dateOffset  , 
      Israel_Exam_Date__c = date.today() +46 + dateOffset , 
      Last_Date_For_ADA__c = date.today() + 35 + dateOffset , 
      Last_Date_For_Early_Registration__c = date.today() + 15 + dateOffset , 
      Last_Date_For_Late_Registration__c = date.today() + 40 + dateOffset ,
      Last_Date_For_Location_Change__c = date.today() +35 + dateOffset ,
      Last_Date_For_Scholarship__c = date.today() +35 + dateOffset ,
      Last_Date_For_Standard_Registration__c = date.today() +25 + dateOffset ,
      Last_Date_To_Apply_For_Deferral__c = date.today() +25 + dateOffset ,
      Last_Date_To_Request_Exam_Change__c = date.today() +40 + dateOffset ,
      Religious_Alternative_Last_Date__c = date.today() +35 + dateOffset ) ;
    
    exams2Insert.add( nExam ) ;  

//  MAKE THE FRM 2 EXAM
    nExam = new Exam__c ( 
      name = 'FRM2 - ' + baseName, 
      Exam_Group__c = egID,
      Deferral_Fee__c = 50 , 
     // Early_Exam_Registration_Fee__c = 100 , 
      Enrollment_Fee__c = 200 , 
      Exam_Request_Change_Fee__c = 50, 
    //  Late_Exam_Registration_Fee__c = 200 , 
    //  Standard_Exam_Registration_Fee__c = 150  , 
      Exam__c = 'FRM Part 2' , //  FRM Part 2   ERP 
      Exam_Seating__c = 'PM' , // PM Both
      Exam_Status__c = 'Review Completed'  , //In Progress  Ready for Review  Review Completed
      Exam_Date__c = date.today() +45 + dateOffset  , 
      Israel_Exam_Date__c = date.today() +46 + dateOffset , 
      Last_Date_For_ADA__c = date.today() +35 + dateOffset  , 
      Last_Date_For_Early_Registration__c = date.today() +15 + dateOffset , 
      Last_Date_For_Late_Registration__c = date.today() +40 + dateOffset , 
      Last_Date_For_Location_Change__c = date.today() +35 + dateOffset , 
      Last_Date_For_Scholarship__c = date.today() +35 + dateOffset , 
      Last_Date_For_Standard_Registration__c = date.today() +25 + dateOffset , 
      Last_Date_To_Apply_For_Deferral__c = date.today() +25 + dateOffset , 
      Last_Date_To_Request_Exam_Change__c = date.today() +40 + dateOffset , 
      Religious_Alternative_Last_Date__c = date.today() +35 + dateOffset ) ;
    
    exams2Insert.add( nExam ) ;      

//  MAKE THE ERP EXAM
    nExam = new Exam__c ( 
      name = 'ERP - ' + baseName, 
      Exam_Group__c = egID,
      Deferral_Fee__c = 50 , 
      //Early_Exam_Registration_Fee__c = 100 , 
      Enrollment_Fee__c = 200 , 
      Exam_Request_Change_Fee__c = 50 , 
      //Late_Exam_Registration_Fee__c = 200 , 
    //  Standard_Exam_Registration_Fee__c = 150  , 
      Exam__c = 'ERP' , //  FRM Part 2   ERP 
      Exam_Seating__c = 'AM' , // PM Both
      Exam_Status__c = 'Review Completed'  , //In Progress  Ready for Review  Review Completed
      Exam_Date__c = date.today() +45 + dateOffset  , 
      Israel_Exam_Date__c = date.today() +46 + dateOffset , 
      Last_Date_For_ADA__c = date.today() +35 + dateOffset  , 
      Last_Date_For_Early_Registration__c = date.today() +15 + dateOffset , 
      Last_Date_For_Late_Registration__c = date.today() +40 + dateOffset , 
      Last_Date_For_Location_Change__c = date.today() +35 + dateOffset , 
      Last_Date_For_Scholarship__c = date.today() +35 + dateOffset , 
      Last_Date_For_Standard_Registration__c = date.today() +25 + dateOffset , 
      Last_Date_To_Apply_For_Deferral__c = date.today() +25 + dateOffset , 
      Last_Date_To_Request_Exam_Change__c = date.today() +40 + dateOffset , 
      Religious_Alternative_Last_Date__c = date.today() +35 + dateOffset ) ;
    
    exams2Insert.add( nExam ) ;  

    insert  exams2Insert ;
    return ( exams2Insert ) ; 
  
  }
  
  public static  list< Exam_Sites__c > testExamSites ( string baseName, list< Site__c > sList,  list< Exam__c > eList ) {
    list< Exam_Sites__c > examSites2Insert = new list< Exam_Sites__c > () ;
    Exam_Sites__c nES ; 

    for( Site__c s :sList )
      for( Exam__c e :eList ) {
        nES = new Exam_Sites__c ( 
          name =  baseName + ' - ' + e.Exam__c + ' - ' +  s.name, 
          Exam__c = e.id,
          Site__c = s.id ) ;
        examSites2Insert.add( nES ) ;
      }
    insert examSites2Insert ;
    return ( examSites2Insert ) ;
  }

    class EA_Link {
      public account account { get; set; }
      public contact contact { get; set; }
      public contract contract  { get; set; }
      public Candidate_Requirement__c requirement  { get; set; }
      public Room__c room { get; set; }
      public boolean isPartofBothPair { get; set; }
      
      EA_Link( 
        account a,
        contact c,
        contract commitment,
        Candidate_Requirement__c req, 
        Room__c r,
        boolean isPair  ) {
          this.account = a; 
          this.contact = c;          
          this.contract = commitment;
          this.requirement = req;
          this.Room = r;
          this.isPartofBothPair = isPair ;
      }
    }
 
  
  public static void makeEAs ( id egID, integer eaCount ) {
    List<String> exams = new String[4];
      exams[0] = 'Both';
      exams[1] = 'ERP';
      exams[2] = 'FRM2';
      exams[3] = 'FRM1';
    for ( string exam : exams ) {
      makeEAsBatch( egID, eaCount, exam ) ;
    }  
  }
  

  @future
  private static void makeEAsBatch ( id egID, integer eaCount, string exam ) {
    id erpRecTypeID = [ SELECT id FROM RecordType WHERE SobjectType = 'Contract' AND DeveloperName  = 'ERP_Program' LIMIT 1 ].id ;
    
    id frmRecTypeID = [ SELECT id FROM RecordType WHERE SobjectType = 'Contract' AND DeveloperName  = 'FRM_Program' LIMIT 1 ].id ;
    
    map< string, list< EA_Link > > examType2EALinks = new map< string, list< EA_Link > >() ;
    map< string, list< Exam_Sites__c > > examType2esList = new map< string, list< Exam_Sites__c > >() ;
    
    examType2EALinks.put(exam, new list< EA_Link >() ) ;
    for( integer i = 0; i < eaCount ; i++ ) {
      // Create a EALink ite for each EA that we're going to create
      // Use examType2EALinks map to store EALink lists by exam
      examType2EALinks.get(exam).add( new EA_Link (
        new account ( 
          name = 'Fit 4 Purpose Solutions - '+ exam + ' - ' + i.format() ),
        new contact ( 
          lastName = 'Cohen - '+exam+' - '+ i.format() ) ,
        new contract ( 
          name = 'Cohen - '+exam+' - '+ i.format(), 
          StartDate = date.today(),
          ContractTerm = 48, 
          Enrollment_Fee__c = 200, 
          RecordTypeId = ((exam == 'ERP') ? erpRecTypeID : frmRecTypeID ) ),
        new Candidate_Requirement__c ( 
          name = exam == 'Both' ? 'FRM1' : exam, 
          Status__c = 'initial' ),
        new Room__c(), 
        FALSE ) ) ;
      if ( exam == 'Both' )
        examType2EALinks.get(exam).add( new EA_Link (
        new account (),
        new contact () ,
        new contract (),
        new Candidate_Requirement__c ( 
          name = 'FRM2', 
          Status__c = 'initial' ),
        new Room__c(),
        TRUE ) ) ;
      }
    list< account > accounts2Insert ;
    list< contact > contacts2Insert ;
    list< contract > contracts2Insert ; 
    list< Candidate_Requirement__c > candidateRequirements2Insert ;
    list< Exam_Attempt__c > examAttempts2Insert ;    

    for ( EA_Link eaLink : examType2EALinks.get( exam ) ) {
      if ( accounts2Insert== NULL )
       accounts2Insert = new list< account >( ) ; 
      if ( eaLink.account.name != NULL ) accounts2Insert.add( eaLink.account ) ;
    }
    insert accounts2Insert ;

    for ( EA_Link eaLink : examType2EALinks.get( exam ) ) {
      if ( contacts2Insert== NULL )
        contacts2Insert = new list< contact >( ) ; 
      if ( eaLink.account.name != NULL ) {
        eaLink.contact.AccountId = eaLink.account.id ;
        contacts2Insert.add( eaLink.contact ) ;
      }
      if ( contracts2Insert== NULL )
        contracts2Insert = new list< contract >( ) ; 
      if ( eaLink.account.name != NULL ) {
        eaLink.contract.AccountId = eaLink.account.id ;
        contracts2Insert.add( eaLink.contract ) ;  
      }        
    }      
    insert contacts2Insert ;
    contacts2Insert.clear() ;
    insert contracts2Insert ;
    contracts2Insert.clear() ;
    id prevContractID ;
    for ( EA_Link eaLink : examType2EALinks.get( exam ) ) {
      if ( candidateRequirements2Insert== NULL )
       candidateRequirements2Insert = new list< Candidate_Requirement__c >( ) ; 
      // If there is no account.name this is the second part of the "both"
      if ( eaLink.account.name != NULL ) {
        eaLink.requirement.Candidate_Commitment__c = eaLink.contract.id ;
        candidateRequirements2Insert.add( eaLink.requirement ) ;
        prevContractID = eaLink.contract.id ;
      }
      else {
        eaLink.requirement.Candidate_Commitment__c = prevContractID ;
        prevContractID = NULL ;
        candidateRequirements2Insert.add( eaLink.requirement ) ;
      }
    }
    insert candidateRequirements2Insert ;
    candidateRequirements2Insert.clear() ;
   
    for( Exam_Sites__c es : [
      SELECT id, exam__c, Exam__r.exam__c FROM Exam_Sites__c WHERE Exam__r.Exam_Group__c = :egID ] ) {
      if ( examType2esList.get( es.exam__r.exam__c ) == NULL )
        examType2esList.put( es.exam__r.exam__c, new list< Exam_Sites__c >{ es } ); 
      else
        examType2esList.get( es.exam__r.exam__c ).add( es ) ;       
    }
    integer FRM1Count = 0,  FRM2Count = 0,  ERPCount = 0 ;
    id esID ;
    id prevReqID, prevContactID ;
    integer FRM1Max = examType2esList.get( 'FRM Part 1' ).size() ;
    integer FRM2Max = examType2esList.get( 'FRM Part 2' ).size() ;
    integer ERPMax = examType2esList.get( 'ERP' ).size() ;
    for ( EA_Link eaLink : examType2EALinks.get( exam ) ) {
      if ( examAttempts2Insert== NULL )
        examAttempts2Insert = new list< Exam_Attempt__c >( ) ;  
      if ( eaLink.requirement.name == 'FRM1' ) {
        system.debug('* * * In makeEAsBatch... FRM1Count is.. '+FRM1Count);
        system.debug('* * * In makeEAsBatch... FRM1Max is.. '+FRM1Count);
        system.debug('* * * In makeEAsBatch... examType2esList is.. '+examType2esList);
        esID = examType2esList.get( 'FRM Part 1' )[FRM1Count].id ;
        if ( FRM1Count == FRM1Max - 1 ) FRM1Count = 0; else FRM1Count++ ;
      }
      if ( eaLink.requirement.name == 'FRM2' ) {
          
        system.debug('* * * In makeEAsBatch... FRM2Count is.. '+FRM2Count);
        system.debug('* * * In makeEAsBatch... examType2esList is.. '+examType2esList);
        esID = examType2esList.get( 'FRM Part 2' )[FRM2Count].id ;
        system.debug('* * * In makeEAsBatch... esID is.. '+esID);
        if ( FRM2Count == FRM2Max - 1 ) FRM2Count = 0; else FRM2Count++ ;
      }
      if ( eaLink.requirement.name == 'ERP'  ) {
        system.debug('* * * In makeEAsBatch... FRM2Count is.. '+FRM2Count);
        system.debug('* * * In makeEAsBatch... examType2esList is.. '+examType2esList);
        esID = examType2esList.get( 'ERP' )[ERPCount].id ;
        system.debug('* * * In makeEAsBatch... esID is.. '+esID);
        if ( ERPCount == ERPMax - 1 ) ERPCount = 0; else ERPCount++ ;
      }
  
        
      examAttempts2Insert.add( new Exam_Attempt__c (
        name = exam + eaLink.contact.lastname, 
        Member__c = eaLink.contact.id != NULL ? eaLink.contact.id : prevContactID,
        Candidate_Requirement__c = eaLink.requirement.id != NULL ? eaLink.requirement.id : prevReqID,
        Exam_Site__c = esID ) ) ;
      prevReqID = eaLink.requirement.id ;
      prevContactID = eaLink.contact.id ;  
      if ( examAttempts2Insert.size() > 1000 ) { 
        insert examAttempts2Insert ;    
        examAttempts2Insert.clear() ;    
      }  
    }
    system.debug('* * * In makeEAsBatch... size of examAttempts2Insert is.. '+examAttempts2Insert.size());
    insert examAttempts2Insert ;     

      
    accounts2Insert.clear() ;
    contacts2Insert.clear()  ;
    contracts2Insert.clear()  ; 
    candidateRequirements2Insert.clear()  ;
    examAttempts2Insert.clear()  ;       

    system.debug('* * * In makeEAsBatch... examType2EALinks is.. '+examType2EALinks);
    return  ;
  }
 


  public static  void removeTestData ( id egID) {
    
    list< Exam__c > exams2Delete = new list< Exam__c > () ; 
    set< id > examIDs = new set< id >() ;
    for( Exam__c e : [
      SELECT id FROM Exam__c WHERE Exam_Group__c = :egID ] ) {
        exams2Delete.add( e ) ;
        examIDs.add( e.id ) ;
    }
    set< id > reqIDs = new set< id >() ;
    list< Exam_Attempt__c > EAs2Delete = new list< Exam_Attempt__c > () ;
    set< id > contactIDs = new set< id >() ;
    set< id > accountIDs = new set< id >() ;
    set< id > eaIDs = new set< id >() ;
    for( Exam_Attempt__c ea : [
      SELECT id, member__c, member__r.accountID, Candidate_Requirement__c 
      FROM Exam_Attempt__c WHERE Exam_Site__r.Exam__r.Exam_Group__c = :egID ] ) {
        eaIDs.add( ea.id ) ;
        EAs2Delete.add( ea ) ;
        reqIDs.add(ea.Candidate_Requirement__c) ;
        contactIDs.add( ea.member__c ) ;
        accountIDs.add( ea.member__r.accountID ) ;  
    }
    list< contact> contacts2Delete = [SELECT id FROM contact WHERE id IN :contactIDs ] ;
    list< account> accounts2Delete = [SELECT id FROM account WHERE id IN :accountIDs ] ;
    
    
    system.debug('* * * In removeTestData... examIDs is.. '+examIDs);
    list< Exam_Sites__c > examSites2Delete = new list< Exam_Sites__c > () ; 
    set< id > siteIDs = new set< id >() ;
    for( Exam_Sites__c es : [SELECT id, Site__c FROM Exam_Sites__c WHERE Exam__c IN :examIDs ] ) {
      examSites2Delete.add( es ) ;
      siteIDs.add ( es.Site__c ) ;
    }
    system.debug('* * * In removeTestData... examSites2Delete is.. '+examSites2Delete);
    system.debug('* * * In removeTestData... examIDs is.. '+examIDs);
    
    list< Site__c > Sites2Delete = new list< Site__c > () ;
    for( Site__c s : [SELECT id FROM Site__c WHERE id IN :siteIDs ] ) {
      Sites2Delete.add( s ) ;
    }
    set< id > contractIDs = new set< id >() ;
    
    for( Candidate_Requirement__c req : [SELECT id, Candidate_Commitment__c
      FROM Candidate_Requirement__c WHERE id IN :reqIDs ] ) {
      contractIDs.add ( req.id ) ;
    } 
    
    list< contract > contracts2Delete = new list< contract > () ;
    for( contract contract : [SELECT id
      FROM contract WHERE id IN :contractIDs ] ) {
      contracts2Delete.add ( contract ) ;
    } 
      
    /** Don't need this because of cascading delete
    list< Venue__c > venues2Delete = new list< Venue__c > () ;
    set< id > venueIDs = new set< id >() ;
    for( Venue__c v : [SELECT id FROM Venue__c WHERE Site__c IN :siteIDs ] ) {
      venues2Delete.add( v ) ;
      venueIDs.add ( v.id ) ;
    }
    delete venues2Delete ;
    list< Room__c > rooms2Delete = new list< Room__c > () ;
    set< id > roomIDs = new set< id >() ;
    for( Room__c r : [SELECT id FROM Room__c WHERE Venue__c IN :venueIDs ] ) {
      venues2Delete.add( v ) ;
      venueIDs.add ( v.id ) ;
    }
    delete venues2Delete ;
    **/
    delEAs ( eaIDs ) ;
    
    delete examSites2Delete ;
    delete Sites2Delete ;
    delete exams2Delete ;
    system.debug('* * * In removeTestData... size of accounts2Delete is.. '+accounts2Delete.size());
    delAccts ( accountIDs ) ;
    return  ;
  }  
    @future
    private static void delEAs ( set < id >  eaIDs ) {
      list< Exam_Attempt__c > EAs2Delete = new list< Exam_Attempt__c > () ;
      for( Exam_Attempt__c ea : [
        SELECT id
        FROM Exam_Attempt__c WHERE id in :eaIDs ] ) {
        EAs2Delete.add( ea ) ;
        if ( EAs2Delete.size() > 8000 ) {
          delete EAs2Delete ;
          EAs2Delete.clear() ;
        }
      }
      delete EAs2Delete ;
      return ;
    }

    @future
    private static void delAccts ( set < id >  accountIDs ) {
      list< account> accounts2Delete = new list< account> () ;
      for ( account a : [SELECT id FROM account WHERE id IN :accountIDs ] ) {
        accounts2Delete.add( a ) ;
        if ( accounts2Delete.size() > 8000 ) { 
          delete accounts2Delete ;
          accounts2Delete.clear() ;
        }
      }  
      delete accounts2Delete ;
      return ;
    }

  private static string calcTicketSection( string tCode ) {
    if ( tcode.startsWith( 'ERP-' )) return ('ERP') ; 
    if ( tcode.startsWith( 'FRM1-' )) return ('FRM1') ; 
    if ( tcode.startsWith( 'FRM2-' )) return ('FRM2') ; 
    if ( tcode.startsWith( 'FRM12' )) return ('FRM12') ; 
    return( 'Unknown Section' ) ;
  }

  private class roomVar {
    integer seatNumber { get; set; }
    integer firstFRM1SeatNumber { get; set; }
    integer SecCtrERP { get; set; } 
    integer SecCtrFRM12 { get; set; } 
    integer SecCtrFRM1 { get; set; } 
    integer SecCtrFRM2 { get; set; } 
    string LastSecCode  { get; set; }
    string firstFRM1SectionCode { get; set; }
    string SecCodeERP { get; set; }
    string SecCodeFRM12 { get; set; }
    string SecCodeFRM1 { get; set; }
    string SecCodeFRM2 { get; set; }
    boolean hasProcessedFirstFRM2 { get; set; }
  }  

    @future 
    public static void updateGroup (  id eGroup, boolean Has_Seating_Done, boolean Rooms_Assigned ) {
      Exam_Group__c EG = [ SELECT id, Has_Seating_Done__c, Rooms_Assigned__c FROM Exam_Group__c WHERE id =:eGroup ] ;
      EG.Has_Seating_Done__c = Has_Seating_Done ;
      EG.Rooms_Assigned__c = Rooms_Assigned ;
      update EG ;
    } 
      
    @future 
    public static void seatsites ( set< id > siteIDs ) {
      
      system.debug('* * * In seatsites... siteIDs is.. '+siteIDs);
      integer siteCount = -1 ;
      list< map< id, map< id, list< Exam_Attempt__c > > > > roomMapsBySite = new list< map< id, map< id, list<Exam_Attempt__c > > > >() ;
      //map< id, list<Exam_Attempt__c> > contactID2eaList = new map< id, list<Exam_Attempt__c> >() ;
      id prevSiteID ;
      id prevRoomID ;
      for (Exam_Attempt__c ea : [
        SELECT ID, Member__c, Room__c, Ticket_Code__c,Candidate_ID__c, Seat_No__c, section__c, 
          Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Site__c, Exam_Site__r.Exam__r.Exam_Group__c
        FROM Exam_Attempt__c
        WHERE Exam_Site__r.Site__c IN :siteIDs
        ORDER BY Exam_Site__r.Site__c, Room__c, Member__c ] ) {
        system.debug('* * * In seatsites... ea is.. '+ea);
        if ( prevSiteID != ea.Exam_Site__r.Site__c ) {
          // If this EA is from a new site setup structure for site
          siteCount++ ;
          roomMapsBySite.add( new map< id, map< id, list<Exam_Attempt__c> > >()) ;
          prevSiteID = ea.Exam_Site__r.Site__c ;
          system.debug('* * * In seatsites... siteCount is.. '+siteCount);
          roomMapsBySite.get( siteCount ).put( ea.Room__c, new map< id, list<Exam_Attempt__c> >() ) ;
          prevRoomID = ea.Room__c ;
        } else {
          if ( prevRoomID != ea.Room__c ) {
            // If this EA is from a new room setup structure for room 
            roomMapsBySite.get( siteCount ).put( ea.Room__c, new map< id, list<Exam_Attempt__c> >() ) ;
            prevRoomID = ea.Room__c ;
          }
        }
        if ( roomMapsBySite.get( siteCount ).get( ea.Room__c).get( ea.Member__c ) == NULL ) {
          // Add new list for new contact
          roomMapsBySite.get( siteCount ).get( ea.Room__c).put( ea.Member__c, new list< Exam_Attempt__c >() ) ;
        }
        // Place ea in proper location in structure
        roomMapsBySite.get( siteCount ).get( ea.Room__c).get( ea.Member__c).add( ea ) ;
      } 
      integer candidateNo ;
      integer FRM1, FRM2, FRM12, ERP ;
      string section = '' ;
      list< Exam_Attempt__c > eaUpdateList = new list< Exam_Attempt__c >() ;
      system.debug('* * * In seatsites... roomMapsBySite is.. '+roomMapsBySite);
      for ( map< id, map< id, list< Exam_Attempt__c > > >  site :  roomMapsBySite ) {
        candidateNo = 1000 ;
        for ( map< id, list< Exam_Attempt__c > >  room : site.values() ) {
          FRM1=0; FRM2=0; FRM12=0; ERP=0; 
          for ( list< Exam_Attempt__c > candidate : room.values() ) {
            if ( candidate.size() > 1 ) {
              section = 'FRM12' ;
              FRM12++ ;
            } else {
              section = '' ;
            }
            for ( Exam_Attempt__c ea : candidate ) {
           ea.Candidate_ID__c= candidateNo.format() ;
              if ( section != 'FRM12' ) {
                if ( ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1' ) {
                  system.debug('* * * In seatsites... FRM1 is.. '+FRM1);
                  FRM1++;
                  system.debug('* * * In seatsites... FRM1 is.. '+FRM1);
                  section = 'FRM1' ;
                } else {
                  if ( ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2' ) {
                    system.debug('* * * In seatsites... FRM2 is.. '+FRM2);
                    FRM2++;
                    system.debug('* * * In seatsites... FRM2 is.. '+FRM2);
                    section = 'FRM2' ;
                  } else {  
                    if ( ea.Exam_Site__r.Exam__r.Exam__c == 'ERP' ) {
                      ERP++;
                      section = 'ERP' ;
                    } else section = 'UNKNOWN' ;
                  }
                }
              }
              

              ea.Ticket_Code__c = section+'-'+ 
                (section=='FRM1' ? FRM1 : 
                  section == 'FRM2' ? FRM2 :
                    section == 'FRM12' ? FRM12 :
                      section == 'ERP' ? ERP : 9999).format() ;
              eaUpdateList.add(ea) ;
            }
            candidateNo++ ;
          }
        }
      } 
      system.debug('* * * In seatsites... eaUpdateList is.. '+eaUpdateList);
     // We need to sort the list of EAs so that seating is done in following order
     // ERP >> FRM12 >> FRM1 >> FRM2
     EAWrapper[] eaList = new List<EAWrapper>();
     for ( Exam_Attempt__c ea : eaUpdateList ) {
       eaList.add( new EAWrapper ( ea )) ;
     }
     system.debug('* * * In seatsites... eaList before sort is.. '+eaList);
     eaList.sort();
     system.debug('* * * In seatsites... eaList after sort is.. '+eaList);
     // Declare and intialize map for contiguous seating
     //  EXAM >> ROOM >> CONTACT >> EA List
     map< string, map< id, map< id, list< Exam_Attempt__c > > > > exam2Contact2eaList = 
       new map< string, map< id, map< id, list< Exam_Attempt__c > > > > () ;

     for ( EAWrapper ea : eaList ) {
       if ( exam2Contact2eaList.get( calcTicketSection(ea.ea.Ticket_Code__c )) == NULL ) {
         exam2Contact2eaList.put( calcTicketSection(ea.ea.Ticket_Code__c), new map< id, map< id, list< Exam_Attempt__c > > > () );
         exam2Contact2eaList.get( calcTicketSection(ea.ea.Ticket_Code__c)).put( ea.ea.Room__c, new map< id, list< Exam_Attempt__c > > ( ) ) ;    
         exam2Contact2eaList.get( calcTicketSection(ea.ea.Ticket_Code__c)).get( ea.ea.Room__c ).put( ea.ea.member__c, new list< Exam_Attempt__c  > {ea.ea} ) ;
       }else{
         if ( exam2Contact2eaList.get( calcTicketSection(ea.ea.Ticket_Code__c )).get( ea.ea.Room__c) == NULL ) {
           exam2Contact2eaList.get( calcTicketSection(ea.ea.Ticket_Code__c)).put( ea.ea.Room__c, new map< id, list< Exam_Attempt__c > > ( ) ) ; 
           exam2Contact2eaList.get( calcTicketSection(ea.ea.Ticket_Code__c)).get( ea.ea.Room__c ).put ( ea.ea.member__c, new list< Exam_Attempt__c > {ea.ea} ) ;
         } else {
           if ( exam2Contact2eaList.get( calcTicketSection(ea.ea.Ticket_Code__c )).get( ea.ea.Room__c ).get( ea.ea.member__c) == NULL ) {
             exam2Contact2eaList.get( calcTicketSection(ea.ea.Ticket_Code__c )).get( ea.ea.Room__c ).put( ea.ea.member__c, new list< Exam_Attempt__c > {ea.ea} ) ;
           } else {
             exam2Contact2eaList.get( calcTicketSection(ea.ea.Ticket_Code__c )).get( ea.ea.Room__c ).get( ea.ea.member__c).add( ea.ea ) ; 
           }
         }
       }    
     }
     system.debug('* * * In seatsites... exam2Contact2eaList is.. '+exam2Contact2eaList);
     
     // Intialize list to determine seating order
     list<string> seatOrder = new list<string> { 'ERP', 'FRM12', 'FRM1', 'FRM2' } ;

     
     //Iterate though map and assign seat numbers
     
     map< id, roomVar > roomID2RoomVar = new  map< id, roomVar > () ;
     String examTemp ;
     for ( string examName : seatOrder ) {
       if ( exam2Contact2eaList.get( examName ) != NULL ) {
         for ( id roomKey : exam2Contact2eaList.get( examName ).keySet() ) {
           if ( roomID2RoomVar.get(roomKey) == NULL ) {
             roomID2RoomVar.put( roomKey, new roomVar () ) ;
             roomID2RoomVar.get(roomKey).LastSecCode = ' A' ;
             roomID2RoomVar.get(roomKey).seatNumber = 1;
             roomID2RoomVar.get(roomKey).firstFRM1SeatNumber = 0; 
             roomID2RoomVar.get(roomKey).hasProcessedFirstFRM2 = FALSE ;
           }          
           for ( list< Exam_Attempt__c > candidate : exam2Contact2eaList.get( examName ).get(roomKey).values()  ) {
             for ( Exam_Attempt__c ea : candidate ) {
               if ( calcTicketSection(ea.Ticket_Code__c) == 'FRM1' && roomID2RoomVar.get( roomKey ).firstFRM1SeatNUmber == 0) 
                 roomID2RoomVar.get( roomKey).firstFRM1SeatNUmber = roomID2RoomVar.get( roomKey ).seatNumber ;
               if ( calcTicketSection(ea.Ticket_Code__c) == 'FRM2' && !roomID2RoomVar.get( roomKey ).hasProcessedFirstFRM2 ) {
                 roomID2RoomVar.get( roomKey ).hasProcessedFirstFRM2 = TRUE ;
                 roomID2RoomVar.get( roomKey ).seatNumber = roomID2RoomVar.get( roomKey ).firstFRM1SeatNUmber ;
               }
               
               examTemp = calcTicketSection(ea.Ticket_Code__c) ;
               system.debug('* * * In seatsites... examTemp is.. '+examTemp); 
               system.debug('* * * In seatsites... roomID2RoomVar.get(roomKey) is.. '+roomID2RoomVar.get(roomKey)); 
               system.debug('* * * In seatsites... ea is.. '+ea); 
               if (examTemp =='FRM1' ) 
                 if ( roomID2RoomVar.get(roomKey).SecCodeFRM1 == NULL ) {
                   roomID2RoomVar.get(roomKey).SecCodeFRM1  = roomID2RoomVar.get(roomKey).LastSecCode ;
                   roomID2RoomVar.get(roomKey).firstFRM1SectionCode = roomID2RoomVar.get(roomKey).LastSecCode ;
                   roomID2RoomVar.get(roomKey).LastSecCode = nextSectionCode( roomID2RoomVar.get(roomKey).LastSecCode ) ;
                   roomID2RoomVar.get(roomKey).SecCtrFRM1 = 1 ;
                 } else {
                   roomID2RoomVar.get( roomKey ).SecCtrFRM1++ ;
                   if ( roomID2RoomVar.get(roomKey).SecCtrFRM1 == 26 ) {
                     roomID2RoomVar.get( roomKey ).SecCtrFRM1 = 1 ;
                     roomID2RoomVar.get(roomKey).SecCodeFRM1 = roomID2RoomVar.get(roomKey).LastSecCode ;
                     roomID2RoomVar.get(roomKey).LastSecCode = nextSectionCode( roomID2RoomVar.get(roomKey).LastSecCode ) ;
                   }
                 }
               if (examTemp =='FRM2' ) 
                 if ( roomID2RoomVar.get(roomKey).SecCodeFRM2 == NULL ) {
                   roomID2RoomVar.get(roomKey).LastSecCode = roomID2RoomVar.get(roomKey).firstFRM1SectionCode ;
                   roomID2RoomVar.get(roomKey).SecCodeFRM2 = roomID2RoomVar.get(roomKey).LastSecCode ;
                   roomID2RoomVar.get(roomKey).LastSecCode = nextSectionCode( roomID2RoomVar.get(roomKey).LastSecCode ) ;
                   roomID2RoomVar.get(roomKey).SecCtrFRM2 = 1 ;
                 } else {
                   roomID2RoomVar.get( roomKey ).SecCtrFRM2++ ;
                   if ( roomID2RoomVar.get(roomKey).SecCtrFRM2 == 26 ) {
                     roomID2RoomVar.get( roomKey ).SecCtrFRM2 = 1 ;
                     roomID2RoomVar.get(roomKey).SecCodeFRM2 = roomID2RoomVar.get(roomKey).LastSecCode ;
                     roomID2RoomVar.get(roomKey).LastSecCode = nextSectionCode( roomID2RoomVar.get(roomKey).LastSecCode ) ;
                   }
                 }
               if (examTemp =='FRM12' ) 
                 if ( roomID2RoomVar.get(roomKey).SecCodeFRM12 == NULL ) { 
                   roomID2RoomVar.get(roomKey).SecCodeFRM12 = roomID2RoomVar.get(roomKey).LastSecCode ;
                   roomID2RoomVar.get(roomKey).LastSecCode = nextSectionCode( roomID2RoomVar.get(roomKey).LastSecCode ) ;
                   roomID2RoomVar.get(roomKey).SecCtrFRM12 = 1 ;
                 }  else {
                   if ( ea.section__c != 'FRM Part 2' ) roomID2RoomVar.get( roomKey ).SecCtrFRM12++ ;
                   if ( roomID2RoomVar.get(roomKey).SecCtrFRM12 == 26 ) {
                     roomID2RoomVar.get( roomKey ).SecCtrFRM12 = 1 ;
                     roomID2RoomVar.get(roomKey).SecCodeFRM12 = roomID2RoomVar.get(roomKey).LastSecCode ;
                     roomID2RoomVar.get(roomKey).LastSecCode = nextSectionCode( roomID2RoomVar.get(roomKey).LastSecCode ) ;   
                   }
                 }                                  
               if (examTemp =='ERP' ) {
                 if ( roomID2RoomVar.get(roomKey).SecCodeERP == NULL ) {
                   roomID2RoomVar.get(roomKey).SecCodeERP = roomID2RoomVar.get(roomKey).LastSecCode ;
                   roomID2RoomVar.get(roomKey).LastSecCode = nextSectionCode( roomID2RoomVar.get(roomKey).LastSecCode ) ;
                   roomID2RoomVar.get(roomKey).SecCtrERP = 1 ;
                 }  else {
                   roomID2RoomVar.get( roomKey ).SecCtrERP++ ;
                   if ( roomID2RoomVar.get(roomKey).SecCtrERP == 26 ) {
                     roomID2RoomVar.get( roomKey ).SecCtrERP = 1 ;
                     roomID2RoomVar.get(roomKey).SecCodeERP = roomID2RoomVar.get(roomKey).LastSecCode ;
                     roomID2RoomVar.get(roomKey).LastSecCode = nextSectionCode( roomID2RoomVar.get(roomKey).LastSecCode ) ;
                   }                 
                 }    
               }             

               
               ea.Seating_Section__c = (examTemp =='FRM1' ? roomID2RoomVar.get(roomKey).SecCodeFRM1  : 
                  examTemp == 'FRM2' ? roomID2RoomVar.get(roomKey).SecCodeFRM2 :
                    examTemp == 'FRM12' ? roomID2RoomVar.get(roomKey).SecCodeFRM12 :
                      examTemp == 'ERP' ? roomID2RoomVar.get(roomKey).SecCodeERP : 'x') ;
               system.debug('* * * In seatsites... ea.Seating_Section__c is.. '+ea.Seating_Section__c);
               
               ea.Seat_No__c = roomID2RoomVar.get( roomKey ).seatNumber.format() ;
               
             }
             roomID2RoomVar.get( roomKey ).seatNumber++;     
           }
         }   
       }
     }
    update  eaUpdateList ; 
    return ; 

  } 
  private static string nextSectionCode( string sectionCode ) {
    string alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' ;
    string digit1, digit2, resultdigit1, resultdigit2 ;
    integer offset ;
    system.debug('* * * In nextSectionCode about to advance sectionCode... sectionCode is.. '+sectionCode);
    //integer code1, code2, resultcode1, resultcode2 ;
    if ( sectionCode.length() == 0 ) return ( ' A' ) ;
    else {
      if ( sectionCode.length() == 2 ) {
        digit1 = sectionCode.substring(0, 1) ;
        system.debug('* * * In nextSectionCode... digit1 is.. '+digit1);
        digit2 = sectionCode.substring(1, 2) ;
        system.debug('* * * In nextSectionCode... digit2 is.. '+digit2);
        if ( digit1 == 'Z' ) return ( 'x' ) ;
        if ( digit2 == 'Z' ) {
          offset = alpha.indexof( digit1 ) ;
          resultdigit1 = alpha.substring( offset, offset + 1) ;
          resultdigit2 = 'A' ;
        } else {
          offset = alpha.indexof( digit2 ) ;
          resultdigit1 = digit1 ;
          resultdigit2 =  alpha.substring( offset+1, offset + 2) ;
        }
      system.debug('* * * In nextSectionCode advanced sectionCode... returning.. '+resultdigit1 + resultdigit2);
      return ( resultdigit1 + resultdigit2 ) ;
      } else {
        return ( 'x' ) ;
      }
    }
  }
  

}