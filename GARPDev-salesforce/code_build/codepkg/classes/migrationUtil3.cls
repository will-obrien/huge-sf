public class migrationUtil3 {

  public static void loadCPEProvider( string s, id businessRecType) {
    map< string, map<string, id >> oType2DevName2RecTypeID = new map< string, map<string, id >> () ;
    for( RecordType rt : [ SELECT id, DeveloperName, SobjectType FROM RecordType ] ) {
      if( oType2DevName2RecTypeID.get( rt.SobjectType) == NULL ) 
        oType2DevName2RecTypeID.put( rt.SobjectType, new map<string, id >() ) ;
      oType2DevName2RecTypeID.get( rt.SobjectType).put( rt.DeveloperName, rt.id ) ;
    }     
     id accountRecordTypeID = oType2DevName2RecTypeID.get( 'Account' ).get( 'Business' ) ;
     id contactRecordTypeID = oType2DevName2RecTypeID.get( 'Contact' ).get( 'Business_Relationship' ) ;
    
    
    List<List<String>> parsedFile = new List<List<String>>();
    parsedFile = migrationUtil.parseCSV( s, TRUE ) ;
    list< account> accounts2Create = new list< account>()  ;
    list< contact> ProviderContacts2Create = new list< contact> () ;
    list< contact> GARPContacts2Create = new list< contact> () ;
    string name, fname, lName ;
    list<string> nameList = new list<string> () ;
    for ( list< string > row : parsedFile ) {
      account a = new account ( 
        recordTypeID = accountRecordTypeID,
        Imported_PK_ProviderID__c = row[0].replace( '"',''),
        name = row[1].replace( '"',''),
        Imported_Provider_Screen_Name__c = row[2].replace( '"',''),
        Imported_isAgreementOnFile__c = ( row[3].replace( '"','') == '1') ? TRUE : FALSE, 
        Imported_Agreement_Cycle__c = migrationUtil.deNULLify(row[4].replace( '"','')),
        Imported_Organization_Type__c = migrationUtil.deNULLify(row[5].replace( '"','')),
        Imported_isVisible__c = ( row[7].replace( '"','') == '1') ? TRUE : FALSE ) ;
      accounts2Create.add ( a ) ;
      
      if ( migrationUtil.deNULLify(row[9].replace( '"','')) != '' ) {
        contact ProviderContact= new contact ( 
          recordTypeID = contactRecordTypeID,
          ImportedPK_ProviderID__c = 'Provider-'+row[0].replace( '"',''),
          firstName = migrationUtil.deNULLify(row[8].replace( '"','')),
          lastName = migrationUtil.deNULLify(row[9].replace( '"','')),
          email = migrationUtil.deNULLify(row[10].replace( '"','')), 
          phone = migrationUtil.deNULLify(row[12].replace( '"',''))) ; 
        ProviderContacts2Create.add ( ProviderContact ) ;
      }
      
      name = migrationUtil.deNULLify(row[11].replace( '"','')) ;
      if ( name == '' )
        fName = lName= '' ;
      else {
        nameList = name.split( ' ', 2 ) ;
        fName = nameList[0] ;
        if ( namelist.size() > 1 ) lName = nameList[1] ;

        contact GARPContact = new contact (
          recordTypeID = businessRecType,
          ImportedPK_ProviderID__c = 'GARP-'+row[0].replace( '"',''),
         firstName = fname, 
          lastName = lname  ) ;
        GARPContacts2Create.add ( GARPContact ) ;
      }
    }
    try{
     system.debug('* * * Query Count is '+Limits.getQueries() ) ;
     upsert accounts2Create Imported_PK_ProviderID__c ;
     upsert ProviderContacts2Create ImportedPK_ProviderID__c ;
     upsert GARPContacts2Create ImportedPK_ProviderID__c ;
     system.debug('* * * Query Count is '+Limits.getQueries() ) ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error upserting Chapter Meetings has occured.');
      system.debug(logginglevel.ERROR, '* * * In loadCPEProvider... caught exception message is.. '+errormsg+'e is '+e);
    } 
    map< string, account > providerPKID2Account = new map< string, account > ();
    map< string, contact > providerPKID2Contact = new map< string, contact > ();  
    set<id> accountIDs = new  set<id> () ;
    for( account a : accounts2Create ) {
      providerPKID2Account.put( a.Imported_PK_ProviderID__c, a ) ;
      accountIDs.add( a.id ) ;
    }
    for( contact c : ProviderContacts2Create ) {
      system.debug('* * * Adding CPE Provider provider ACR contact is '+c ) ;
      providerPKID2Contact.put( c.ImportedPK_ProviderID__c, c ) ;
    }
    for( contact c : GARPContacts2Create ) {
      system.debug('* * * Adding CPE Provider GARP ACR contact is '+c ) ;
      providerPKID2Contact.put( c.ImportedPK_ProviderID__c, c ) ;
    }
    
    list< accountContactRole > ACRs2Create = new list< accountContactRole >() ;
    for ( account a : accounts2Create ) {
      if ( providerPKID2Contact.get( 'Provider-'+a.Imported_PK_ProviderID__c) != NULL ) {
        providerPKID2Contact.get( 'Provider-'+a.Imported_PK_ProviderID__c).accountid = a.id ;
        accountContactRole acr = new accountContactRole (
          accountID = a.id,
          contactID = providerPKID2Contact.get( 'Provider-'+a.Imported_PK_ProviderID__c).id,
          Role = 'GARP CPD Provider Contact' ) ;
        system.debug('* * * Inserting CPE Provider provider ACR contactId is '+acr.contactID ) ;
        system.debug('* * * Inserting CPE Provider provider ACR accountId is '+acr.accountID ) ;
        ACRs2Create.add( acr ) ;
      }
      if ( providerPKID2Contact.get( 'GARP-'+a.Imported_PK_ProviderID__c) != NULL ) {
        providerPKID2Contact.get( 'GARP-'+a.Imported_PK_ProviderID__c).accountid = a.id ;
        accountContactRole acr = new accountContactRole (
          accountID = a.id,
          contactID = providerPKID2Contact.get( 'GARP-'+a.Imported_PK_ProviderID__c).id,
          Role = 'CPD Provider Contact' ) ;
        system.debug('* * * Inserting CPE Provider  GARP ACR contactId is '+acr.contactID ) ;
        system.debug('* * * Inserting CPE Provider  GARP ACR accountId is '+acr.accountID ) ;
        ACRs2Create.add( acr ) ;        
      }
    }
    try{
     system.debug('* * * Query Count is '+Limits.getQueries() ) ;
     delete [SELECT id FROM accountContactRole WHERE accountID IN :accountIDs ] ;
     insert ACRs2Create ;
     upsert ProviderContacts2Create ImportedPK_ProviderID__c ;
     upsert GARPContacts2Create ImportedPK_ProviderID__c ;
     system.debug('* * * Query Count is '+Limits.getQueries() ) ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error inserting Roles for CPE Providers has occured.');
      system.debug(logginglevel.ERROR, '* * * In loadCPEProvider... caught exception message is.. '+errormsg+'e is '+e);
    }     
      
  }
  public static void loadCPEActivity( string s) {
    List<List<String>> parsedFile = new List<List<String>>();
    parsedFile = migrationUtil.parseCSV( s, TRUE ) ;  
    set<string> ActivityIDs = new set<string>() ;
    map< string, id > CPEProviderActivityID2SFID = new map< string, id > () ;
    map< string, id > CPEActivityID2SFID = new map< string, id > () ;
    list< CPE_Activity_Type__c > CPEActivities2Create = new  list< CPE_Activity_Type__c > () ;   
    for ( list< string > row : parsedFile ) { 
      string tempActivityID = row[0].replace( '"','') ;
      ActivityIDs.add( tempActivityID ) ;
      CPEActivities2Create.add( new CPE_Activity_Type__c ( 
        Active__c = (row[2].replace( '"','') == '1') ? TRUE : FALSE ,
        Imported_PK_Activity__c = tempActivityID,
        Title_Label_Text__c = row[1].replace( '"','')
        //Organization_Label_Text__c
        //Provider_Label_Text__c
        //Publication_Label_Text__c  
      ));  
    }
    upsert  CPEActivities2Create Imported_PK_Activity__c ;
    for(CPE_Activity_Type__c CPE_A : CPEActivities2Create ) CPEActivityID2SFID.put( CPE_A.Imported_PK_Activity__c, CPE_A.id ) ;
    list< CPE_Provider_Activity__c > CPE_PAs2Update = new list< CPE_Provider_Activity__c > () ;
    for( CPE_Provider_Activity__c CPE_PA :[
      SELECT id, Imported_FK_ActivityID__c, CPE_Activity_Type__c, CPE_Provider__c 
      FROM CPE_Provider_Activity__c
      WHERE Imported_FK_ActivityID__c IN : ActivityIDs ] ) {
      
      CPE_PA.CPE_Activity_Type__c = CPEActivityID2SFID.get( CPE_PA.Imported_FK_ActivityID__c ) ;
      CPE_PAs2Update.add( CPE_PA ) ;
    }
    update CPE_PAs2Update ;
  }
  
  
  public static void loadCPEProviderActivity( string s) {
    List<List<String>> parsedFile = new List<List<String>>();
    parsedFile = migrationUtil.parseCSV( s, TRUE ) ;   
    set<string> providerIDs = new set<string>() ;
    map< string, string > PK_SetItemID2FK_ProviderID = new map< string, string >() ;
    map< string, string > PK_SetItemID2FK_ActivityID = new map< string, string >() ;
    map< string, id > FK_ProviderID2AccountID = new map< string, id > () ;
    list< CPE_Provider_Activity__c > ProviderActivities2Create = new  list< CPE_Provider_Activity__c > () ;   
    for ( list< string > row : parsedFile ) {
      system.debug('* * * Building ProviderActivity Maps row is '+row ) ;
      system.debug('* * * Building ProviderActivity Maps row[0] is '+row[0].replace( '"','') ) ;
      string tempSetItemID = row[0].replace( '"','') ;
      string tempProviderID = row[2].replace( '"','') ;
      providerIDs.add( tempProviderID ) ;
      PK_SetItemID2FK_ProviderID.put( tempSetItemID, tempProviderID ) ;
      PK_SetItemID2FK_ActivityID.put( tempSetItemID, row[1].replace( '"','')) ; 
    } 
    for ( Account a : [
      SELECT id, Imported_PK_ProviderID__c 
      FROM account 
      WHERE Imported_PK_ProviderID__c IN :providerIDs ] ) 
        FK_ProviderID2AccountID.put( a.Imported_PK_ProviderID__c, a.id ) ;

    for( string PK_SetItemID : PK_SetItemID2FK_ProviderID.keySet() ) {
      system.debug('* * * Creating CPE_Provider_Activity__c PK_SetItemID is '+PK_SetItemID ) ;
      system.debug('* * * Creating CPE_Provider_Activity__c AccountID is '+FK_ProviderID2AccountID.get( PK_SetItemID ) ) ;
      ProviderActivities2Create.add( new CPE_Provider_Activity__c ( 
        CPE_Provider__c = FK_ProviderID2AccountID.get( PK_SetItemID2FK_ProviderID.get( PK_SetItemID ) ) , 
        Imported_FK_ActivityID__c = PK_SetItemID2FK_ActivityID.get( PK_SetItemID ), 
        Imported_FK_ProviderID__c = PK_SetItemID2FK_ProviderID.get( PK_SetItemID ),
        Import_PK_SetItemID__c = PK_SetItemID
        //CPE_Credit_Hours__c
        //Start_Date__c 
        //End_Date__c
        //Web_Description__c
        )) ;
    }
    upsert ProviderActivities2Create Import_PK_SetItemID__c ;
  }  
}