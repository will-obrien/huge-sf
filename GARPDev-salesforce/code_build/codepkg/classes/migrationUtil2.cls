public class migrationUtil2 {

  public static void processChapterMeetingChunk( string s, boolean hasColumnHeader ) {
    //system.debug('* * * In processChapterMeetingChunk... s is.. '+s);
    //system.debug('* * * In processChapterMeetingChunk... hasColumnHeader is.. '+hasColumnHeader);
    list< list< string >> parsedFile = migrationUtil.parseCSV( s , hasColumnHeader ) ;
    //system.debug('* * * In processChapterMeetingChunk... parsedFile is.. '+parsedFile);
    //system.debug('* * * In processChapterMeetingChunk... parsedFile size is.. '+parsedFile.size());
    set< id > IDsOfChapterLocations2Delete = new set< id > ();
    set< id > IDsOfImportedChapterMeetings = new set< id > ();
    for( Chapter_Meeting__c CM : 
      [ SELECT id, Chapter_Meeting_Location__r.id FROM Chapter_Meeting__c
      WHERE Imported_PK_ChMeetingID__c != NULL OR Chapter_Meeting_Location__r.CreatedById = '005f0000000zV6mAAE' ] ) {
        IDsOfChapterLocations2Delete.add( CM.Chapter_Meeting_Location__r.id  ) ;
        IDsOfImportedChapterMeetings.add( CM.id ) ;
    }
    set< id > IDsOfChapterSpeakers2Delete = new set< id > ();
    for ( Chapter_Meeting_Speaker__c CMS : [SELECT id FROM Chapter_Meeting_Speaker__c
      WHERE Chapter_Meeting__c IN :IDsOfImportedChapterMeetings ] ) {
        IDsOfChapterSpeakers2Delete.add( CMS.id ) ;
    } 
    
    delete [SELECT id FROM Chapter_Meeting_Location__c  WHERE id IN :IDsOfChapterLocations2Delete] ;
    delete [SELECT id FROM Chapter_Meeting_Speaker__c WHERE id IN :IDsOfChapterSpeakers2Delete] ;
    delete [SELECT id FROM Chapter_Meeting_Location__c WHERE  CreatedById = '005f0000000zV6mAAE' ] ; 
    map< string, Chapter_Meeting_Speaker__c > speakerName2CMS = new map< string, Chapter_Meeting_Speaker__c > () ;
    map< string, Chapter_Meeting_Location__c > locationName2CML = new map< string, Chapter_Meeting_Location__c > () ;
    map< string, list<string> > PK_ChMeeting2SpeakerNameList = new map< string, list<string> > () ;
    map<string, id > ChapterLocation2ID = new map<string, id >() ;
    set< string > chapterNames = new set<string>() ;
    //list< Chapter_Meeting__c > CMs2Update = new list< Chapter_Meeting__c >();
    list< Chapter_Meeting_Location__c > CMLocations2Update = new list< Chapter_Meeting_Location__c >();
    list< Chapter_Meeting__c > CMs2Upsert = new list< Chapter_Meeting__c > () ;
    Chapter_Meeting_Speaker__c newCMS ;
    Chapter_Meeting__c newCM ;
    Chapter_Meeting_Location__c newCML ;
    string tempLocation ;
    string tempSpeaker ;
    string tempPK_ChMeetingID ;
    list< string > tempSpeakerNames = new list< string >() ;
    //system.debug('In processChapterMeetingChunk processing chunk ' + parsedFile.size() + ' Rows to process'  ) ;  
    for ( list< string > row : parsedFile ) {
      //system.debug('In processChapterMeetingChunk processing row... row is ' + row ) ;  
      tempPK_ChMeetingID = row[0].replace( '"','') ;
      tempSpeaker = migrationUtil.deNULLify(row[10].replace( '"','')) ;
      tempSpeakerNames = tempSpeaker.split( '/', 0 ) ;
      for( string nameString : tempSpeakerNames ) {
        newCMS = new Chapter_Meeting_Speaker__c (  
          name = nameString.subString(0, ((nameString.length() < 79) ? nameString.length() : 79) ) ) ;
        speakerName2CMS.put( newCMS.name, newCMS ) ;
        if( PK_ChMeeting2SpeakerNameList.get( tempPK_ChMeetingID ) == NULL ) 
          PK_ChMeeting2SpeakerNameList.put( tempPK_ChMeetingID, new list<string>{ newCMS.name } ) ;
        else 
          PK_ChMeeting2SpeakerNameList.get( tempPK_ChMeetingID).add( newCMS.name ) ;    
      }
      string tempCapacity = migrationUtil.deNULLify(row[8].replace( '"','')) ;
      tempcapacity = ( tempcapacity == '' ) ? '0' : tempcapacity ; 
      string tempName = row[1].replace( '"','') ;
      integer tempNameLen = tempName.length() ;
      newCML = new Chapter_Meeting_Location__c(
        
        name = tempName.subString(0, ((tempNameLen < 79) ? tempNameLen : 79) ), 
        Capacity__c = decimal.valueOf( tempcapacity ),
        Venue_Location__c = tempName ) ;
      locationName2CML.put( tempName.subString(0, ((tempNameLen < 79) ? tempNameLen : 79) ), newCML ) ;
      
      chapterNames.add( tempName.subString(0, ((tempNameLen < 79) ? tempNameLen : 79) ) ) ;
           
      newCM = new Chapter_Meeting__c( ) ;
        newCM.name = tempName.subString(0, ((tempNameLen < 79) ? tempNameLen : 79) ) ;
        newCM.Status__c = 'Active' ;
        newCM.Imported_PK_ChMeetingID__c = tempPK_ChMeetingID ; 
        newCM.Start__c = migrationUtil.getDateTime2( row[3].replace( '"','')) ;
        newCM.End__c =  migrationUtil.getDateTime2( row[4].replace( '"','')) ;
        //Chapter__c
        //Chapter_Meeting_Location__c
        string tempCredits = migrationUtil.deNULLify( row[15].replace( '"','')) ;
        try {
          if (tempCredits != '') newCM.CPE_Credits__c = decimal.valueOf( tempCredits ) ;
        } catch( System.TypeException e ) { 
          system.debug(logginglevel.ERROR, '* * * In processChapterMeetingChunk... caught exception tempCredits is '+tempCredits );
          system.debug(logginglevel.ERROR, '* * * In processChapterMeetingChunk... caught exception CPE Credits Not a Number.. error message is '+e+' PK_ChMeetingID is '+tempPK_ChMeetingID );
        }
        
        //newCM.End__c = migrationUtil.getDate( row[4].replace( '"','')) ;
        //newCM.Start__c = migrationUtil.getDate( row[3].replace( '"','')) ;
        //Status__c
        newCM.Synopsis__c = migrationUtil.deNULLify(row[9].replace( '"','')) ;
        newCM.Imported_HTML__c = migrationUtil.deNULLify(row[19].replace( '"','')) ;
        newCM.isFRM_Only__c = ( migrationUtil.deNULLify(row[12].replace( '"',''))  == '1' ) ? TRUE : FALSE ; 
        newCM.isRPCEChapterMeeting__c = ( migrationUtil.deNULLify(row[12].replace( '"',''))  == '1' ) ? TRUE : FALSE ;
      //system.debug('* * * Adding newCM  is '+newCM ) ;
      CMs2Upsert.add( newCM ) ;
    } 
    for( chapter__c c : [SELECT id, Location__c FROM chapter__c WHERE Location__c IN :chapterNames ] ) 
      ChapterLocation2ID.put( c.Location__c, c.id ) ;
    for(  Chapter_Meeting__c CM : CMs2Upsert ) {
      if( ChapterLocation2ID.get( cm.name ) != NULL ) 
        cm.chapter__c = ChapterLocation2ID.get( cm.name ) ;
    }
    
    try{
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
     insert locationName2CML.values() ;
     //system.debug('In processChapterMeetingChunk upserting ' + CMs2Upsert.size() + ' Chapter Meetings'  ) ;
     upsert CMs2Upsert Imported_PK_ChMeetingID__c ;
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error upserting Chapter Meetings has occured.');
      system.debug(logginglevel.ERROR, '* * * In processChapterMeetingChunk... caught exception message is.. '+errormsg+'e is '+e);
    } 
    
    for(Chapter_Meeting__c CM : CMs2Upsert) {
      for( string sName : PK_ChMeeting2SpeakerNameList.get( CM.Imported_PK_ChMeetingID__c )) {
        system.debug('In processChapterMeetingChunk setting chapter meeting lookup in speaker... CM is ' + CM  ) ;
        system.debug('In processChapterMeetingChunk setting chapter meeting lookup in speaker... sName is ' + sName  ) ;
        system.debug('In processChapterMeetingChunk setting chapter meeting lookup in speaker...  speakerName2CMS.get(sName) is ' +  speakerName2CMS.get(sName)  ) ;
        speakerName2CMS.get(sName).Chapter_Meeting__c = CM.id ;
      }
      system.debug('In processChapterMeetingChunk setting meetng location locationName2CML is  ' +locationName2CML  ) ;
      system.debug('In processChapterMeetingChunk setting meetng location CM.name is  ' + CM.name  ) ;
      CM.Chapter_Meeting_Location__c = locationName2CML.get( CM.name ).id ; 
    }
    insert speakerName2CMS.values() ;
    update locationName2CML.values() ;  
    update CMs2Upsert ;
    return;
  } 

  public static void processChapterMeetingRegistrationChunk( string s, boolean hasColumnHeader ) {
    //system.debug('* * * In dateMigrator... s is.. '+s);
    
    list< Chapter_Meeting_Registration__c > CMRs2Upload  = new list< Chapter_Meeting_Registration__c >  () ;
    map< string, id > FKChapMeetingID2SFChapMeetingID = new map< string, id > () ;
    map< string, id > FKPID2SFSFMemberID = new map< string, id > () ;
    map< string, string > FKPID2SFSFMemberName = new map< string, string > () ;
    list< list< string >> parsedFile = migrationUtil.parseCSV( s , hasColumnHeader ) ;
    for( Chapter_Meeting__c cm : [SELECT id, Imported_PK_ChMeetingID__c FROM Chapter_Meeting__c ] ) 
      FKChapMeetingID2SFChapMeetingID.put( cm.Imported_PK_ChMeetingID__c, cm.id ) ;
    set< string > FK_PIDs = new set< string > () ;
    for ( list< string > row : parsedFile ) {
      FK_PIDs.add( migrationUtil.deNULLify(row[5].replace( '"','')) ) ; 
    }

    for( contact c : [SELECT id, LEGACY_PK_PID__c, name FROM contact WHERE LEGACY_PK_PID__c IN : FK_PIDs ] ) { 
      FKPID2SFSFMemberID.put( c.LEGACY_PK_PID__c, c.id ) ;
      FKPID2SFSFMemberName.put( c.LEGACY_PK_PID__c, c.name ) ;
    }
      
    string tempStatusCode, tempStatus, tempmeetingID, tempmemberID ; 
    for ( list< string > row : parsedFile ) {
      tempStatusCode = migrationUtil.deNULLify(row[3].replace( '"','')) ;
      tempStatus = ( tempStatusCode == '' ) ? 'Confirmed' :
        ( tempStatusCode == '1' ) ? 'Attended' :
           ( tempStatusCode == '2' ) ?  'No-Show' : 'Unknown Code in Import '+tempStatusCode ;
      tempmeetingID = migrationUtil.deNULLify(row[2].replace( '"','')) ;   
      tempmemberID = migrationUtil.deNULLify(row[5].replace( '"','')) ;    
      if ( tempmeetingID != '' && tempmemberID != '' ) {
        Chapter_Meeting_Registration__c cmr = new Chapter_Meeting_Registration__c( 
          Legacy_PK_CMREGISTRATION__c = row[0].replace( '"',''), 
          Chapter_Meeting__c = FKChapMeetingID2SFChapMeetingID.get( tempmeetingID ),
          Contact__c = FKPID2SFSFMemberID.get( tempmemberID ),
          Status__c = tempStatus, 
          Registration_Date__c = migrationUtil.getDate( row[4].replace( '"','') ),
          Role__c = 'Registrant',
          name = FKPID2SFSFMemberName.get( tempmemberID ) ) ; 
        if( cmr.Chapter_Meeting__c != NULL && cmr.Contact__c != NULL )
          CMRs2Upload.add( cmr ) ;
        else {
          system.debug(logginglevel.ERROR, '* * * In processChapterMeetingRegistrationChunk... cannot add registrant... caught exception Reg Record is.. '+cmr);
          system.debug(logginglevel.ERROR, '* * * In processChapterMeetingRegistrationChunk... cannot add registrant... caught exception Row is.. '+row);
        }
      }
    }
    try{
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
     upsert CMRs2Upload Legacy_PK_CMREGISTRATION__c ;
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error upserting Chapter Meetings has occured.');
      system.debug(logginglevel.ERROR, '* * * In processChapterMeetingChunk... caught exception while inserting registrations message is.. '+errormsg+'e is '+e);
    } 
  }

public static void processSeatingChartChunk( string s, boolean hasColumnHeader ) {
    //system.debug('* * * In dateMigrator... s is.. '+s);
    set< string > roomIDs = new set< string > () ;
    set< string > productIDs = new set< string > () ;
    set< string > FK_PIDs = new set< string > () ;
    map< string, id > roomID2SFRoomID = new map< string, id > () ;
    map< string, string > productID2ReqName = new map< string, string > () ;
    map< string, map< string, Exam_Attempt__c >> FK_PID2ReqName2EA = new map< string, map< string, Exam_Attempt__c >> () ;
    list< Exam_Attempt__c > EAs2Update = new list< Exam_Attempt__c > () ;
    list< list< string >> parsedFile = migrationUtil.parseCSV( s , hasColumnHeader ) ;
    for ( list< string > row : parsedFile ) {
      productIDs.add( row[4].replace( '"','')) ;
      FK_PIDs.add( row[1].replace( '"','')) ;
      roomIDs.add( row[2].replace( '"','')) ;
    }
    for( product2 p : [ SELECT id, action__c, Product_ID__c FROM product2 WHERE Product_ID__c IN :productIDs ] ) {
      if( p.action__c == 'Make FRM1 Exam Registration' ) productID2ReqName.put( p.Product_ID__c , 'Pass FRM1' ) ;
        else if( p.action__c == 'Make FRM2 Exam Registration' ) productID2ReqName.put( p.Product_ID__c , 'Pass FRM2' ) ;
          else if( p.action__c == 'Make ERP Exam Registration' ) productID2ReqName.put( p.Product_ID__c , 'Pass ERP' ) ;
    }
    for( Exam_Attempt__c EA : [
      SELECT id, Candidate_Requirement__r.name, Candidate_Requirement__c 
      FROM Exam_Attempt__c 
      WHERE Member__r.LEGACY_PK_PID__c IN :FK_PIDs] ) {
      
      if( FK_PID2ReqName2EA.get( EA.Member__r.LEGACY_PK_PID__c ) == NULL ) 
        FK_PID2ReqName2EA.put( EA.Member__r.LEGACY_PK_PID__c, new map< string, Exam_Attempt__c >() ) ;
      FK_PID2ReqName2EA.get( EA.Member__r.LEGACY_PK_PID__c).put( EA.Candidate_Requirement__r.name, EA ) ; 
    }
    for( Room__c r : [SELECT id, LEGACY_PK_Room__c, Venue__c FROM Room__c WHERE LEGACY_PK_Room__c IN : roomIDs ] ) {
      roomID2SFRoomID.put( r.LEGACY_PK_Room__c, r.id ) ;
    }
    for ( list< string > row : parsedFile ) {
      Exam_Attempt__c TempEA = 
        FK_PID2ReqName2EA.get( row[1].replace( '"','')).get( productID2ReqName.get( row[4].replace( '"','') ) ) ;
      TempEA.Seat_No__c = row[4].replace( '"','') ;
      TempEA.Candidate_No__c = row[7].replace( '"','') ;
      TempEA.Room__c = roomID2SFRoomID.get( row[2].replace( '"','')) ;
      EAs2Update.add( TempEA ) ;
    }
    
    try{
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
     update EAs2Update ;
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
    } catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error updating EAs with seating info has occured.');
      system.debug(logginglevel.ERROR, '* * * In processSeatingChartChunk... caught exception while inserting registrations message is.. '+errormsg+'e is '+e);
    } 
  }
public static void processCPEChunk( string s, boolean hasColumnHeader ) {
    //system.debug('* * * In dateMigrator... s is.. '+s);
    
    list< Chapter_Meeting_Registration__c > CMRs2Upload  = new list< Chapter_Meeting_Registration__c >  () ;
    map< string, id > FKChapMeetingID2SFChapMeetingID = new map< string, id > () ;
    map< string, id > FKPID2SFSFMemberID = new map< string, id > () ;
    map< string, string > FKPID2SFSFMemberName = new map< string, string > () ;
    list< list< string >> parsedFile = migrationUtil.parseCSV( s , hasColumnHeader ) ;
    for( Chapter_Meeting__c cm : [SELECT id, Imported_PK_ChMeetingID__c FROM Chapter_Meeting__c ] ) 
      FKChapMeetingID2SFChapMeetingID.put( cm.Imported_PK_ChMeetingID__c, cm.id ) ;
    for( contact c : [SELECT id, LEGACY_PK_PID__c, name FROM contact ] ) { 
      FKPID2SFSFMemberID.put( c.LEGACY_PK_PID__c, c.id ) ;
      FKPID2SFSFMemberName.put( c.LEGACY_PK_PID__c, c.name ) ;
    }
      
    string tempStatusCode, tempStatus, tempmeetingID, tempmemberID ; 
    for ( list< string > row : parsedFile ) {
      tempStatusCode = migrationUtil.deNULLify(row[3].replace( '"','')) ;
      tempStatus = ( tempStatusCode == '' ) ? 'Confirmed' :
        ( tempStatusCode == '1' ) ? 'Attended' :
           ( tempStatusCode == '2' ) ?  'No-Show' : 'Unknown Code in Import '+tempStatusCode ;
      tempmeetingID = migrationUtil.deNULLify(row[2].replace( '"','')) ;   
      tempmemberID = migrationUtil.deNULLify(row[5].replace( '"','')) ;    
      if ( tempmeetingID != '' && tempmemberID != '' ) {
        Chapter_Meeting_Registration__c cmr = new Chapter_Meeting_Registration__c( 
          Legacy_PK_CMREGISTRATION__c = row[0].replace( '"',''), 
          Chapter_Meeting__c = FKChapMeetingID2SFChapMeetingID.get( tempmeetingID ),
          Contact__c = FKPID2SFSFMemberID.get( tempmemberID ),
          Status__c = tempStatus, 
          Registration_Date__c = migrationUtil.getDate( row[4].replace( '"','') ),
          Role__c = 'Registrant',
          name = FKPID2SFSFMemberName.get( tempmemberID ) ) ; 
        if( cmr.Chapter_Meeting__c != NULL && cmr.Contact__c != NULL )
          CMRs2Upload.add( cmr ) ;
        else {
          system.debug(logginglevel.ERROR, '* * * In processChapterMeetingRegistrationChunk... cannot add registrant... caught exception Reg Record is.. '+cmr);
          system.debug(logginglevel.ERROR, '* * * In processChapterMeetingRegistrationChunk... cannot add registrant... caught exception Row is.. '+row);
        }
      }
    }
    try{
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
     upsert CMRs2Upload Legacy_PK_CMREGISTRATION__c ;
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error upserting Chapter Meetings has occured.');
      system.debug(logginglevel.ERROR, '* * * In processChapterMeetingChunk... caught exception while inserting registrations message is.. '+errormsg+'e is '+e);
    } 
  }

public static void processCPEProgramChunk( string s, boolean hasColumnHeader ) {
    system.debug('* * * In dateMigrator... s is.. '+s);
    
    list< contract > CPEPrograms2Upload  = new list< contract >  () ;
    list< candidate_Requirement__c > CPEProgramReq2Upload = new list< candidate_Requirement__c >  () ;
    map< string, id > FK_PID2AccountID = new map< string, id > () ;
    map< string, id > FK_PID2ContactID = new map< string, id > () ;
    map< string, id > FK_ProgramID2SFProgramID = new map< string, id > () ;
    map< string, candidate_Requirement__c > ProgramGARP_ID2REQ = new map< string, candidate_Requirement__c >() ;
    set< string > FK_PIDs = new set< string > () ;
    id CPEProgramRecordTypeID = [SELECT Id FROM RecordType WHERE  SobjectType = 'contract' AND developerName = 'CPE' ].id ;
    id CPERequirementRecordTypeID = [SELECT Id FROM RecordType WHERE  SobjectType = 'Candidate_Requirement__c' AND developerName = 'CPE' ].id ;
    list< list< string >> parsedFile = migrationUtil.parseCSV( s , hasColumnHeader ) ;
    for ( list< string > row : parsedFile ) {
      FK_PIDs.add( row[0].replace( '"','')) ;
    }
    for( account a : [SELECT id, PK_PID__c FROM account WHERE PK_PID__c IN :FK_PIDs ] )
      FK_PID2AccountID.put( a.PK_PID__c, a.id ) ;
      
    for( contact c : [SELECT id, LEGACY_PK_PID__c FROM contact WHERE  LEGACY_PK_PID__c IN :FK_PIDs]) 
      FK_PID2ContactID.put( c.LEGACY_PK_PID__c, c.id ) ;
    
    for ( list< string > row : parsedFile ) {
      string tempPK_PID = row[0].replace( '"','') ;
      if( FK_PID2AccountID.get( tempPK_PID ) != NULL ) {
        system.debug('* * * Adding a Program/req pair... tempPK_PID is  '+tempPK_PID ) ;
        integer originalProgramYear = integer.valueOf( row[1].replace( '"','') ) ;
        integer createYear = originalProgramYear + 1993 ;
        while (createYear <= 2014 ) {
          system.debug('* * * Adding a Program/req pair... createYear is  '+createYear ) ;
          CPEPrograms2Upload.add( new contract ( 
            AccountId = FK_PID2AccountID.get( tempPK_PID ),
            ContractTerm = 24, 
            CustomerSignedId = FK_PID2ContactID.get( tempPK_PID ) , 
            Description = 'Imported CPE Program', 
            LEGACY_Just_PK_PID__c = tempPK_PID, 
            LEGACY_PK_PID__c = tempPK_PID+'-CPD Program-'+createYear, 
            RecordTypeId = CPEProgramRecordTypeID, 
            StartDate = date.newinstance(createYear, 1, 1) 
            //Status, 
          ));
          candidate_Requirement__c CPEReq = new candidate_Requirement__c(
            recordTypeID = CPERequirementRecordTypeID,
            CPE_Credit_Requirement__c = 40,
            Imported_Key__c = tempPK_PID+'-CPD Program-'+createYear, 
            //Candidate_Commitment__c
            Status__c = 'Initial' ) ;
          CPEProgramReq2Upload.add( CPEReq ) ;
          ProgramGARP_ID2REQ.put ( tempPK_PID+'-CPD Program-'+createYear, CPEReq ) ;
          createYear += 2 ;
        }
      }
    } 
    try{
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
     upsert CPEPrograms2Upload LEGACY_PK_PID__c ;
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error upserting CPD Program Objects has occured.');
      system.debug(logginglevel.ERROR, '* * * In processCPEProgramChunk... caught exception while inserting CPE Program Object message is.. '+errormsg+'e is '+e);
    }      
    for(contract p : CPEPrograms2Upload ) {
      p.Status = 'Activated' ;
      system.debug('* * * Setting CPD contract to Active ... contract  is  '+p ) ;
      ProgramGARP_ID2REQ.get( p.LEGACY_PK_PID__c ).Candidate_Commitment__c = p.id ; 
      system.debug('* * * Adding lookup to contract to Requirement ... ProgramGARP_ID2REQ.get( p.LEGACY_PK_PID__c ).Candidate_Commitment__c is  '+ProgramGARP_ID2REQ.get( p.LEGACY_PK_PID__c ).Candidate_Commitment__c ) ;
    }
    system.debug('* * * Upserting requirements ProgramGARP_ID2REQ.values() is '+ProgramGARP_ID2REQ.values()  ) ;
    upsert ProgramGARP_ID2REQ.values() Imported_Key__c ;
    update CPEPrograms2Upload;
  }

public static void processCPEClaimChunk( string s, boolean hasColumnHeader ) {
    //system.debug('* * * In dateMigrator... s is.. '+s);
    
    list< CPE_Claim__c > CPDClaims2Upload  = new list< CPE_Claim__c >  () ;
    id CPERequirementRecordTypeID = [SELECT Id FROM RecordType WHERE  SobjectType = 'Candidate_Requirement__c' AND developerName = 'CPE' ].id ;
    map< string, id > FK_ProviderID2ProviderID = new map< string, id > () ;
    map< string, id > FK_PID2ActivityID = new map< string, id > () ;
    map< string, id > FK_PID2ContactID = new map< string, id > () ;
    map< string, map< integer, id >> FK_PID2CycleYear2RequirementID = new map< string, map< integer, id >>  () ;
    set< string > FK_PIDs = new set< string > () ;
    set< string > FK_ProviderIDs = new set< string > () ;
    set< string > FK_ActivityIDs = new set< string > () ;



    map< string, string > areaOfStudyID2String = new map< string, string >  { 
      '1'=> 'Credit Risk',
      '2'=> 'Energy Risk',
      '3'=> 'Enterprise Risk Management',
      '4'=> 'Financial Market and Products',
      '5'=> 'Investment Risk',
      '6'=> 'Liquidity Risk',
      '7'=> 'Market Risk',
      '8'=> 'Operational Risk',
      '9'=> 'Quantitative Analysis',
      '10'=> 'Regulatory',
      '11'=> 'Legal and Ethics',
      '12'=> 'Sovereign Risk', 
      '13'=> 'Other relevant area of study',
      '14'=> 'Integrated Risk',
      '15'=> 'Energy finance and Risk Management',
      '16'=> 'Energy Commodities, Derivatives and Trading',
      '17'=> 'Legal Issues',
      '18'=> 'Ethics' } ;
  
    list< list< string >> parsedFile = migrationUtil.parseCSV( s , hasColumnHeader ) ;
    for ( list< string > row : parsedFile ) {
      FK_PIDs.add( row[1].replace( '"','')) ;
      FK_ProviderIDs.add( row[9].replace( '"','')) ;
      FK_ActivityIDs.add( row[10].replace( '"','')) ;
    }

    for( account a : [SELECT id, Imported_PK_ProviderID__c FROM account WHERE  Imported_PK_ProviderID__c IN :FK_ProviderIDs]) 
      FK_ProviderID2ProviderID.put( a.Imported_PK_ProviderID__c, a.id ) ;
    system.debug('* * * Adding claims... FK_ProviderID2ProviderID is  '+FK_ProviderID2ProviderID ) ;          
    
    for( contact c : [SELECT id, LEGACY_PK_PID__c FROM contact WHERE  LEGACY_PK_PID__c IN :FK_PIDs]) 
      FK_PID2ContactID.put( c.LEGACY_PK_PID__c, c.id ) ;
    system.debug('* * * Adding claims... FK_PID2ContactID is  '+FK_PID2ContactID ) ;  
    
    for( Candidate_Requirement__c r : [
      SELECT id, Candidate_Commitment__r.LEGACY_Just_PK_PID__c, Candidate_Commitment__r.StartDate 
      FROM Candidate_Requirement__c 
      WHERE RecordTypeId = :CPERequirementRecordTypeID AND Candidate_Commitment__r.LEGACY_Just_PK_PID__c  IN :FK_PIDs]) {
      
      if ( FK_PID2CycleYear2RequirementID.get( r.Candidate_Commitment__r.LEGACY_Just_PK_PID__c ) == NULL )
        FK_PID2CycleYear2RequirementID.put( r.Candidate_Commitment__r.LEGACY_Just_PK_PID__c, new map< integer, id > () ) ;
        
      FK_PID2CycleYear2RequirementID.get( r.Candidate_Commitment__r.LEGACY_Just_PK_PID__c ).put( r.Candidate_Commitment__r.StartDate.year(), r.id ) ;    
    }
    system.debug('* * * Adding claims... FK_PID2CycleYear2RequirementID is  '+FK_PID2CycleYear2RequirementID ) ;  
    
    
    for( CPE_Activity_Type__c a : [SELECT id, Imported_PK_Activity__c FROM CPE_Activity_Type__c WHERE Imported_PK_Activity__c IN :FK_ActivityIDs]) 
      FK_PID2ActivityID.put( a.Imported_PK_Activity__c, a.id ) ;      
    system.debug('* * * Adding claims... FK_PID2ActivityID is  '+FK_PID2ActivityID ) ;  
    for ( list< string > row : parsedFile ) {
      string tempPK_PID = row[1].replace( '"','') ;
      string tempPK_RPCERegId = row[0].replace( '"','') ;
      decimal tempCreditsApproved = decimal.valueof( row[4].replace( '"','')  ) ;
      if( FK_PID2ContactID.get( tempPK_PID ) != NULL ) {
        system.debug('* * * Adding a claim... tempPK_PID is  '+tempPK_PID ) ;
        
        CPDClaims2Upload.add( new CPE_Claim__c ( 
          Imported_PK_RPCERegId__c = tempPK_RPCERegId, 
          Candidate_Requirement__c = FK_PID2CycleYear2RequirementID.get( tempPK_PID ).get( integer.valueof( row[2].replace( '"',''))+1993  ), 
          CPE_Activity_Type__c  = FK_PID2ActivityID.get( row[10].replace( '"','') ) ,
          Member__c = FK_PID2ContactID.get( tempPK_PID ), 
          ApprovalComments__c = '', 
          Approved__c = ( tempCreditsApproved > 0 ) ? TRUE : FALSE , 
          ApprovedCredits__c = tempCreditsApproved, 
          Area_of_Study__c = areaOfStudyID2String.get(row[11].replace( '"','') ), 
          Comment__c = '', 
          Credits_Earned__c = decimal.valueof( row[3].replace( '"','')  ), 
          Date_Approved__c = migrationUtil.getDate( row[6].replace( '"','')) , 
          Date_of_Completion__c = migrationUtil.getDate( row[5].replace( '"','')) , 
          Description__c = '', 
          //EventTitle__c = migrationUtil.deNULLify(row[13].replace( '"','')), 
          Imported_ApprovedBy__c = '',  
          Program_Type__c = '', 
          //Provider__c = FK_ProviderID2ProviderID.get(row[13].replace( '"','')) , 
          Publication__c = '',
          URL__c = ''
        ));
        
      }
    } 
    try{
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
     upsert CPDClaims2Upload Imported_PK_RPCERegId__c ;
     //system.debug('* * * Query Count is '+Limits.getQueries() ) ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error upserting CPD Program Objects has occured.');
      system.debug(logginglevel.ERROR, '* * * In processCPEClaimChunk... caught exception while inserting CPE Claim Object message is.. '+errormsg+'e is '+e);
    }      
  }

}