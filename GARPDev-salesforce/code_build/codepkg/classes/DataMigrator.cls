public class DataMigrator {
  public list< AsyncApexJob > activeJobs { get; set; }
  public boolean hasActiveJobs { get; set; }
  public boolean hasfileInProgress { get; set; }
  public integer fileOffset { get; set; }
  public integer fileSize { get; set; }
  public boolean isFirstChunk { get; set; }
  //public string nameFile{get;set;}
  public boolean loadedCountryFile{get;set;}
  public boolean loadedProductsFile{get;set;}
  public boolean loadedExamsFile{get;set;}
  public boolean loadedSiteFile{get;set;}
  public boolean loadedRoomFile{get;set;}
  public boolean loadedExamFile{get;set;} 
  public boolean loadedPurchaseHistoryFile{get;set;}
  public boolean loadedProgramHistoryFile{get;set;}
  public boolean loadedChapterFile{get;set;}
  public boolean FRMHistoryFile{get;set;}
  
  public boolean isPeopleLoadInProgress{get;set;} 
  public boolean isPurchaseLoadInProgress{get;set;} 
  public boolean isFRMLoadInProgress{get;set;} 
  public boolean isResultLoadInProgress{get;set;} 
  public boolean isChapterMeetingLoadInProgress{get;set;} 
  public boolean isChapterMeetingRegLoadInProgress{get;set;} 
  public boolean isCPEProgramLoadInProgress{get;set;}   
  public boolean isCPEClaimLoadInProgress{get;set;}   
  
  public string nameCountriesFile{get;set;}
  public string nameSitesFile{get;set;}
  public string nameRoomsFile{get;set;}
  public string nameExamsFile{get;set;}
  public string nameProductsFile{get;set;}
  public string nameChapterFile{get;set;}
  public string nameCPEProvidersFile{get;set;}
  public string nameCPEActivitiesFile{get;set;}
  public string nameCPEProviderActivitiesFile{get;set;}
  public string fileName{get;set;}
  public string fileID{get;set;}
  string action ;
  public Blob CountriesFile{get;set;}
  public Blob SitesFile{get;set;}
  public Blob RoomsFile{get;set;}
  public Blob ExamsFile{get;set;}
  public Blob ProductsFile{get;set;}
  public Blob ChapterFile{get;set;}
  public Blob CPEProvidersFile{get;set;}
  public Blob CPEActivitiesFile{get;set;}
  public Blob CPEProviderActivitiesFile{get;set;}
  String[] filelines = new String[]{};
  List<Exam_Attempt__c> EAs2Upload;
  List< LEGACY_Country__c > Countries2Upload ;
  List< Site__c > Sites2Upload ;
  List< Venue__c > Venues2Upload ;
  List< Chapter__c > Chapters2Upload ;
  //List< Room__c > Rooms2Upload ;
  //List< Exam_Group__c > examGroups2Upload ;

  //define your custom exception
  public class processingException extends Exception{}  

  public DataMigrator() {
    isPeopleLoadInProgress = FALSE ;
    isPurchaseLoadInProgress = FALSE ;
    isFRMLoadInProgress = FALSE ;
    isResultLoadInProgress = FALSE ;
    isChapterMeetingLoadInProgress = FALSE ;
    isChapterMeetingRegLoadInProgress = FALSE ;
    isCPEProgramLoadInProgress = FALSE ;
    isCPEClaimLoadInProgress = FALSE ;
    fileName = ApexPages.currentPage().getParameters().get('fName');
    fileID = ApexPages.currentPage().getParameters().get('fID');
    action = ApexPages.currentPage().getParameters().get('action');
    system.debug( '* * * In dataMigrator constructor... action is.. '+action);
    
    if ( action == 'peopleLoad' && fileID != NULL ) {
      // First invocation of a people load
      isPeopleLoadInProgress = TRUE ;
      hasActiveJobs = TRUE ;
      hasfileInProgress = TRUE ;
      fileOffset = 0 ;
    } 
    
    if ( action == 'purchaseLoad' && fileID != NULL ) {
      // First invocation of a purchase load
      isPurchaseLoadInProgress = TRUE ;
      hasActiveJobs = TRUE ;
      hasfileInProgress = TRUE ;
      fileOffset = 0 ;
    }     

    if ( action == 'FRMLoad' && fileID != NULL ) {
      // First invocation of a FRM load
      isFRMLoadInProgress = TRUE ;
      hasActiveJobs = TRUE ;
      hasfileInProgress = TRUE ;
      fileOffset = 0 ;
    }       
   
    if ( action == 'ResultLoad' && fileID != NULL ) {
      // First invocation of a Results load
      isResultLoadInProgress = TRUE ;
      hasActiveJobs = TRUE ;
      hasfileInProgress = TRUE ;
      fileOffset = 0 ;
    }       

    if ( action == 'ChapterMeetingLoad' && fileID != NULL ) {
      // First invocation of a Results load
      isChapterMeetingLoadInProgress = TRUE ;
      hasActiveJobs = TRUE ;
      hasfileInProgress = TRUE ;
      fileOffset = 0 ;
    }      

    if ( action == 'ChapterMeetingRegLoad' && fileID != NULL ) {
      // First invocation of a Results load
      isChapterMeetingRegLoadInProgress = TRUE ;
      hasActiveJobs = TRUE ;
      hasfileInProgress = TRUE ;
      fileOffset = 0 ;
    }              
    
    if ( action == 'CPEProgramLoad' && fileID != NULL ) {
      // First invocation of a CPE Program load
      isCPEProgramLoadInProgress = TRUE ;
      hasActiveJobs = TRUE ;
      hasfileInProgress = TRUE ;
      fileOffset = 0 ;
    }              
    if ( action == 'CPEClaimLoad' && fileID != NULL ) {
      // First invocation of a CPE Program load
      isCPEClaimLoadInProgress = TRUE ;
      hasActiveJobs = TRUE ;
      hasfileInProgress = TRUE ;
      fileOffset = 0 ;
    }           

    getProgress() ;
  }
    
  public Document document {
    get {
      if (document == null)
        document = new Document();
      return document;
    }
    set;
  }

  public Pagereference ReadCountriesFile() {
    nameCountriesFile=CountriesFile.toString();
        
    // Load Date to Site__c records 
    Countries2Upload = new List< LEGACY_Country__c >();
    List<List<String>> parsedFile = new List<List<String>>();
    parsedFile = migrationUtil.parseCSV( nameCountriesFile, TRUE ) ;
    system.debug('* * * In dateMigrator... parsedFile is.. '+parsedFile);
    for ( list< string > row : parsedFile ) {
      LEGACY_Country__c c = new LEGACY_Country__c();
      c.PK_Country__c = row[0].replace( '"','') ;
      c.name = row[1].replace( '"','') ;
      c.Phone_Code__c = row[2].replace( '"','') ;     
      c.Currency__c = row[3].replace( '"','') ;     
      c.LetterCode__c = row[4].replace( '"','') ;     
      c.RegionID__c = ( row[5].replace( '"','') == 'NULL') ? '' : row[5].replace( '"','') ;     
      c.ISOCode__c  = ( row[6].replace( '"','') == 'NULL') ? '' : row[6].replace( '"','') ;     

      Countries2Upload.add(c);
    }
    try{
      upsert Countries2Upload PK_Country__c;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      ApexPages.addMessage(errormsg);
    }    
    return null;
  }
  public Pagereference deactivateUsersofImportedAccountsAndContacts() {
    set< id > IDsOfContacts2Delete = new set< id > () ;
    set< id > IDsOfAccounts2Delete = new set< id > () ;
    list < account> accounts2Delete = [SELECT id FROM account WHERE PK_PID__c != NULL ORDER BY LastModifiedDate ASC LIMIT 500 ] ;
    system.debug('* * * In deactivateUsersofImportedAccountsAndContacts... accounts2Delete is.. '+accounts2Delete);
    for( account a : accounts2Delete ) IDsOfAccounts2Delete.add( a.id ) ;
    list <contact> contacts2Delete = [SELECT id FROM contact WHERE accountID IN :IDsOfAccounts2Delete AND  LEGACY_PK_PID__c != NULL ] ;
    system.debug('* * * In deactivateUsersofImportedAccountsAndContacts... contacts2Delete is.. '+contacts2Delete);
    //for( account a : accounts2Delete ) IDsOfAccounts2Delete.add( a.id ) ;
    for( contact c : contacts2Delete ) IDsOfContacts2Delete.add( c.id ) ;
    list <user> users2Update = [SELECT id, IsPortalEnabled FROM user WHERE contactID IN :IDsOfContacts2Delete ] ; 
    system.debug('* * * In deactivateUsersofImportedAccountsAndContacts... users2Update is.. '+users2Update);
    system.debug('* * * In deactivateUsersofImportedAccountsAndContacts... we are updating .. '+users2Update.size()+' users');
    for( user u : users2Update ) u.IsPortalEnabled = FALSE ;
    //update accounts2Delete ;
    system.debug('* * * In deactivateUsersofImportedAccountsAndContacts... calling update.. ');
    update users2Update ;
    system.debug('* * * In deactivateUsersofImportedAccountsAndContacts... returned from update.. ');
    //delete contacts2Delete ;
    //delete accounts2Delete ;
    return null; 
  }
public Pagereference deleteAccountsAndContactsWithoutPortalUsers() { 
  list < account> accounts2Delete = [SELECT id FROM account WHERE PK_PID__c != NULL ORDER BY LastModifiedDate ASC LIMIT 4000 ] ;
  list < contract > contracts2Delete = new list < contract >() ;
  list < opportunity > opportunities2Delete = new list < opportunity >() ;
  system.debug('* * * In deleteAccountsAndContactsWithoutPortalUsers... accounts2Delete is.. '+accounts2Delete);
  set< id > IDsOfAccounts2Delete = new set< id > () ;
  for (account a : accounts2Delete ) IDsOfAccounts2Delete.add( a.id ) ;
  for( contract con : [SELECT id FROM contract WHERE accountID IN :IDsOfAccounts2Delete ] ) 
   contracts2Delete.add( con ) ; 
  delete contracts2Delete;
  for( opportunity opp : [SELECT id FROM opportunity WHERE accountID IN :IDsOfAccounts2Delete ] ) 
   opportunities2Delete.add( opp ) ; 
  delete opportunities2Delete ;
  list< contact > contacts2Delete = [SELECT id, AccountID FROM contact WHERE accountID IN :IDsOfAccounts2Delete] ;
  set< id > IDsOfContacts2Delete = new set< id > () ; 
  map< id, contact> contactID2Contact = new map< id, contact>  () ;
  for( contact c : contacts2Delete ) {
    contactID2Contact.put( c.id, c ) ;
    IDsOfContacts2Delete.add( c.id ) ;
  }
  list<user> users2Check = [SELECT id, IsPortalEnabled, contactID FROM user WHERE contactID IN :IDsOfContacts2Delete] ;
  list< contact > contacts2ReallyDelete = new list< contact > () ;
  set< id > IDsOfAccounts2ReallyDelete = new set< id > () ;
  for(user u:users2Check ) {
    if ( u.IsPortalEnabled ) {
      contactID2Contact.remove( u.contactID ) ;
    }
  }
  for( contact c : contactID2Contact.values() )
    IDsOfAccounts2ReallyDelete.add( c.accountID ) ;
  list<opportunity> opps2Delete = [SELECT id FROM opportunity WHERE accountID IN : IDsOfAccounts2ReallyDelete ] ;
  list < account> accounts2ReallyDelete = [SELECT id FROM account WHERE id IN :IDsOfAccounts2ReallyDelete  ] ;
  
  system.debug('* * * In deleteAccountsAndContactsWithoutPortalUsers... contacts2Delete is.. '+contacts2Delete);
  update accounts2Delete ;
  delete opps2Delete ;
  system.debug('* * * In deleteAccountsAndContactsWithoutPortalUsers... contacts2ReallyDelete is.. '+contacts2ReallyDelete);
  delete contactID2Contact.values() ;
  system.debug('* * * In deleteAccountsAndContactsWithoutPortalUsers... accounts2ReallyDelete is.. '+accounts2ReallyDelete);
  delete accounts2ReallyDelete ;
  return null; 
  }  
public Pagereference deleteDeactivatedAccountsAndContacts() {
  set< id > IDsOfContacts2Delete = new set< id > () ;
  set< id > IDsOfAccounts2Delete = new set< id > () ;
  list<user> usersWithDisabledAccounts = [SELECT id, contactID FROM user WHERE IsPortalEnabled = FALSE Limit 3000 ] ;
  system.debug('* * * In deleteDeactivatedAccountsAndContacts... usersWithDisabledAccounts is.. '+usersWithDisabledAccounts);
  for( user u : usersWithDisabledAccounts ) 
    IDsOfContacts2Delete.add( u.contactID ) ;
  system.debug('* * * In deleteDeactivatedAccountsAndContacts... IDsOfContacts2Delete is.. '+IDsOfContacts2Delete);
  list< contact > contacts2Delete = [SELECT id, AccountID FROM contact WHERE id IN :IDsOfContacts2Delete] ;
  for( contact c : contacts2Delete ) IDsOfAccounts2Delete.add( c.accountID ) ;
  list<opportunity> opps2Delete = [SELECT id FROM opportunity WHERE accountID IN : IDsOfAccounts2Delete ] ;
  delete contacts2Delete ;
  delete [SELECT id FROM account WHERE id IN : IDsOfAccounts2Delete ] ;
  return null; 
  }  
  
public Pagereference ReadCPEProvidersFile() {
    id businessRecType = [SELECT id FROM RecordType WHERE SobjectType = 'contact' and DeveloperName = 'Business_Relationship' ].id ;
    system.debug('* * * In ReadCPEProvidersFile... CPEProvidersFile is.. '+CPEProvidersFile);
    nameCPEProvidersFile= CPEProvidersFile.toString();
    
    migrationUtil3.loadCPEProvider ( nameCPEProvidersFile, businessRecType ) ;
    return null;
  }

public Pagereference ReadCPEActivitiesFile() {
    
    system.debug('* * * In ReadCPEActivitiesFile... CPEActivitiesFile is.. '+CPEActivitiesFile);
    nameCPEActivitiesFile= CPEActivitiesFile.toString();
    
    migrationUtil3.loadCPEActivity ( nameCPEActivitiesFile ) ;
    return null;
  }
public Pagereference ReadCPEProviderActivitiesFile() {
    
    system.debug('* * * In ReadCPEProviderActivitiesFile... CPEProviderActivitiesFile is.. '+CPEProviderActivitiesFile);
    nameCPEProviderActivitiesFile= CPEProviderActivitiesFile.toString();
    
    migrationUtil3.loadCPEProviderActivity ( nameCPEProviderActivitiesFile ) ;
    return null;
  }
  public Pagereference ReadProductsFile() {
    nameProductsFile=ProductsFile.toString();
        
    // Load Date to Site__c records 
    list< LEGACY_Product__c > Products2Upload = new list< LEGACY_Product__c >();
    list< Product2 > SFProducts2Upload = new list< Product2 >();
    List<List<String>> parsedFile = new List<List<String>>();
    parsedFile = migrationUtil.parseCSV( nameProductsFile, TRUE ) ;
    system.debug('* * * In dateMigrator... parsedFile is.. '+parsedFile);

    for ( list< string > row : parsedFile ) {
      LEGACY_Product__c p = new LEGACY_Product__c();
      p.LEGACY_PK_PID__c = migrationUtil.deNULLify(row[0].replace( '"','')) ;
      p.FK_Product_Type__c = migrationUtil.deNULLify(row[1].replace( '"','')) ;
      p.LEGACY_Product_Name__c = migrationUtil.deNULLify(row[2].replace( '"','')) ; 
      p.name = p.LEGACY_Product_Name__c.substring(0, (p.LEGACY_Product_Name__c.length() > 79) ? 79 : p.LEGACY_Product_Name__c.length() ) ;     
      p.LEGACY_Product_Description__c = migrationUtil.deNULLify(row[3].replace( '"','')) ;     
      p.LEGACY_Admin_Description__c = migrationUtil.deNULLify(row[4].replace( '"','')) ;     
      p.LEGACY_Web_Description__c = migrationUtil.deNULLify( row[5].replace( '"','')) ;     
      p.LEGACY_Schedule_Date__c  = migrationUtil.getDate(row[10].replace( '"','')) ;   
      p.LEGACY_Invoice_Prefix__c = migrationUtil.deNULLify( row[11].replace( '"','')) ;    
      p.LEGACY_Next_Schedule_Date__c = migrationUtil.getDate( row[12].replace( '"','') )  ;    
      p.LEGACY_FK_Category__c = migrationUtil.deNULLify( row[13].replace( '"','')) ;     
      p.LEGACY_GL_Code__c = migrationUtil.deNULLify( row[14].replace( '"','')) ;     
      
      Products2Upload.add(p);
      
      string tempisActive = migrationUtil.deNULLify( row[9].replace( '"','')) ;
      string tempVersionNo = migrationUtil.deNULLify(row[8].replace( '"','')) ;
      
      Product2 prod = new Product2 (     
        Name = ( p.LEGACY_Product_Name__c.length() > 0 ) ? p.LEGACY_Product_Name__c : 'Product Name Missing From Import' ,
        Description = p.LEGACY_Product_Description__c, 
        Admin_Description__c = p.LEGACY_Admin_Description__c, 
        Web_Description__c = p.LEGACY_Web_Description__c,
        GARP_Category__c = p.LEGACY_FK_Category__c, 
        Garp_Product_Type__c = p.FK_Product_Type__c, 
        GL_Code__c = p.LEGACY_GL_Code__c, 
        Invoice_Prefix__c = p.LEGACY_Invoice_Prefix__c, 
        // *********** Making ALL Products Active for now.... 
        IsActive = ( tempisActive == '1' ) ? TRUE : TRUE,   //FALSE , 
        Next_Scheduled_Date__c = p.LEGACY_Next_Schedule_Date__c, 
        Product_ID__c = p.LEGACY_PK_PID__c,
        Scheduled_Date__c = p.LEGACY_Schedule_Date__c,
        Import_ID__c = p.LEGACY_PK_PID__c,
        VersionNo__c =  tempVersionNo ) ;
        

      set< string > FRMFullwithProgram = new set< string >   
        { '1','2','34','35','36','206','302','384','482','682'} ;
      set< string > FRMFull = new set< string >   
        { '934'} ;
      set< string > FRM1 = new set< string > 
        {'935','987','1030','1045','1052','1068','1107','1122','1130','1140','1148','1155' } ;
      set< string > FRM2 = new set< string > 
        { '988','1031','1046','1053','1069','1108','1123','1131','1141','1149','1156' } ;
      set< string > ERP = new set< string >
        { '957', '989','1028','1047','1054','1070','1109','1124','1132','1142','1150','1157' } ;
      set< string > FRM1Def = new set< string >        
        { '950', '996','1032','1048','1055','1073','1110','1134','1143','1151','1158' } ;
      set< string > FRM2Def = new set< string >   
        { '951',       '1033','1049','1056','1074','1111','1135','1144','1152','1159' } ;
      set< string > FRMBothDef = new set< string > 
        { '991',       '1034','1050','1057','1075','1112','1136','1145','1153','1160' } ;  
      set< string > ERPDef = new set< string > 
        { '960', '995','1029','1051','1058','1076','1113','1137','1146','1154','1161' } ;


      if( FRMFull.contains(prod.Product_ID__c) || FRMFullwithProgram.contains(prod.Product_ID__c)) {
        if ( FRMFullwithProgram.contains(prod.Product_ID__c) ) 
          prod.Action__c = 'Make FRM1 Exam Registration and Program' ;
        else
          prod.Action__c = 'Make FRM1 Exam Registration' ;
        prod.hasProgram__c = TRUE ;
        prod.Program_Name__c = 'FRM Program' ;
        prod.VersionNo__c = 'LEVEL I' ; // Maybe this should be FULL... I'm just worried about downstream breakage.
      }
      
      if( FRM1.contains(prod.Product_ID__c)) {
        prod.Action__c = 'Make FRM1 Exam Registration' ;
        prod.hasProgram__c = TRUE ;
        prod.Program_Name__c = 'FRM Program' ;
      }        
      if( FRM2.contains(prod.Product_ID__c)) {
        prod.Action__c = 'Make FRM2 Exam Registration' ;
        prod.hasProgram__c = TRUE ;
        prod.Program_Name__c = 'FRM Program' ;
      }        
      if( ERP.contains(prod.Product_ID__c)) {
        prod.Action__c = 'Make ERP Exam Registration' ;
        prod.hasProgram__c = TRUE ;
        prod.Program_Name__c = 'ERP Program' ;
      }   
      if( prod.Product_ID__c == '943' ) {
        prod.Action__c = 'Make FRM Program' ;
        prod.hasProgram__c = TRUE ; 
        prod.Program_Name__c = 'FRM Program' ;
      }  
      if( prod.Product_ID__c == '958' ) {
        prod.Action__c = 'Make ERP Program' ;
        prod.hasProgram__c = TRUE ; 
        prod.Program_Name__c = 'ERP Program' ;
      }
      if( prod.Product_ID__c == '944' ||
        prod.Product_ID__c == '4' ||
        prod.Product_ID__c == '207' || 
        prod.Product_ID__c == '129' ) {
        
        prod.Action__c = 'Make or Update Membership Program' ;
        prod.hasProgram__c = TRUE ; 
        prod.Program_Name__c = 'Membership' ;
        prod.Program_Type__c = 'Individual' ;
      }
          
           
      /**
      
      //
 
      ERP SiteChange  990

      **/
      
      SFProducts2Upload.add( prod )  ;
        
      
    }
    try{
      upsert Products2Upload LEGACY_PK_PID__c;
      upsert SFProducts2Upload Import_ID__c ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      ApexPages.addMessage(errormsg);
    }   
    map< string, id > pCode2pID = new map< string, id > () ; 
    id standardPriceBookID = [ SELECT id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1 ].id ;
    id idOfPricebook ;
    list<Pricebook2> MigrationPricebook = [ SELECT id FROM Pricebook2 WHERE name = 'Migration Pricebook' LIMIT 1 ] ;
    if ( MigrationPricebook.isEmpty() ) {
      Pricebook2 newPricebook = new Pricebook2 ( name = 'Migration Pricebook', isActive = TRUE, description = 'Pricebook Used By Migration Scripts' ) ;
      insert ( newPricebook ) ;
      idOfPricebook = newPricebook.id ;
    } else {
      idOfPricebook = MigrationPricebook[0].id ;
    }
    for( Product2 p :SFProducts2Upload ) 
      pCode2pID.put( p.Product_ID__c, p.id ) ;
    
    list< PricebookEntry > pbEntries2Upload = new list< PricebookEntry >();  
    list< PricebookEntry > standardpbEntries2Upload = new list< PricebookEntry >();  

    PricebookEntry pbEntry ;
    for ( list< string > row : parsedFile ) {
      string tempisActive = migrationUtil.deNULLify( row[9].replace( '"','')) ;
      string key = migrationUtil.deNULLify(row[0].replace( '"','')) ;
      pbEntry = new PricebookEntry( 
        UnitPrice = 0,
        UseStandardPrice = FALSE,
        IsActive = ( tempisActive == '1' ) ? TRUE : TRUE , 
        Pricebook2Id = idOfPricebook, 
        Product_ID__c = key,
        Product2Id = pCode2pID.get( key )) ;// , 
        //Import_ID__c  = key) ;
      pbEntries2Upload.add( pbEntry ) ;

      pbEntry = new PricebookEntry( 
        UnitPrice = 0,
        //UseStandardPrice = FALSE,
        IsActive = ( tempisActive == '1' ) ? TRUE : TRUE , 
        Pricebook2Id = standardPriceBookID,
        Product_ID__c = key, 
        Product2Id = pCode2pID.get( key )) ;// , 
        //Import_ID__c  = key) ;  
      standardpbEntries2Upload.add( pbEntry ) ;
      
    }
    try{
      insert standardpbEntries2Upload ;
      insert pbEntries2Upload  ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured uploading Pricebook Entries. ' + e);
      ApexPages.addMessage(errormsg);
    }   
    
    
    
    return null;
  }
  public Pagereference deleteOppLI() {
    id standardPriceBookID = [ SELECT id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1 ].id ;
    id idOfPricebook ;
    list<Pricebook2> MigrationPricebook = [ SELECT id FROM Pricebook2 WHERE name = 'Migration Pricebook' LIMIT 1 ] ;
    if ( MigrationPricebook.isEmpty() ) {
      Pricebook2 newPricebook = new Pricebook2 ( name = 'Migration Pricebook', isActive = TRUE, description = 'Pricebook Used By Migration Scripts' ) ;
      insert ( newPricebook ) ;
      idOfPricebook = newPricebook.id ;
    } else {
      idOfPricebook = MigrationPricebook[0].id ;
    }    
    list< PricebookEntry > PBEItems2Delete = [
      SELECT id from PriceBookEntry WHERE Pricebook2Id = :idOfPricebook AND Product2.Test__c = FALSE ] ;
    list< PricebookEntry > standardPBEItems2Delete = [
      SELECT id from PriceBookEntry where Product2.Import_ID__c != NULL and Pricebook2Id = :standardPriceBookID AND Product2.Test__c = FALSE ] ;

    // Delete EXISTING OppLineItems that use these PBEs
    system.debug('* * * In dataMigrator... Deleting existing OppLineItems. ' );  
    list< OpportunityLineItem > lineItems2Delete = [
      SELECT id, LEGACY_PK_PurchasesHistory__c 
      FROM OpportunityLineItem 
      WHERE  PricebookEntryId IN :PBEItems2Delete OR PricebookEntryId IN :standardPBEItems2Delete ] ;
    system.debug('* * * In dateMigrator:ReadProductsFile... lineItems2Delete is.. '+lineItems2Delete);
    delete  lineItems2Delete ; 
    system.debug('* * * In dateMigrator:ReadProductsFile... done deleting lineItems2Delete  '+lineItems2Delete);  
    return NULL ;   
  }
  public Pagereference deletePBEMigrate() {
    id idOfPricebook ;
    list<Pricebook2> MigrationPricebook = [ SELECT id FROM Pricebook2 WHERE name = 'Migration Pricebook' LIMIT 1 ] ;
    if ( MigrationPricebook.isEmpty() ) {
      Pricebook2 newPricebook = new Pricebook2 ( name = 'Migration Pricebook', isActive = TRUE, description = 'Pricebook Used By Migration Scripts' ) ;
      insert ( newPricebook ) ;
      idOfPricebook = newPricebook.id ;
    } else {
      idOfPricebook = MigrationPricebook[0].id ;
    }  
    list< PricebookEntry > PBEItems2Delete = [
      //SELECT id from PriceBookEntry WHERE Pricebook2Id = :idOfPricebook AND Product2.Test__c = FALSE ] ; 
      SELECT id from PriceBookEntry WHERE Product2.Import_ID__c != NULL AND Product2.Test__c = FALSE AND Pricebook2.IsStandard != TRUE ] ; 
        
    delete  PBEItems2Delete ; 
    system.debug('* * * In dateMigrator:ReadProductsFile... done deleting PBEItems2Delete  '+PBEItems2Delete);
    return NULL ;   
  }
  public Pagereference deletePBEStandard() {
    id standardPriceBookID = [ SELECT id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1 ].id ;
    list< PricebookEntry > standardPBEItems2Delete = [
      SELECT id from PriceBookEntry where Product2.Import_ID__c != NULL and Pricebook2Id = :standardPriceBookID AND Product2.Test__c = FALSE ] ;
    system.debug('* * * In dateMigrator:ReadProductsFile... standardPBEItems2Delete is.. '+standardPBEItems2Delete);
    delete  standardPBEItems2Delete ; 
    //system.debug('* * * In dateMigrator:ReadProductsFile... done deleting standardPBEItems2Delete  '+standardPBEItems2Delete);
    return NULL ;   
  }
  
  public Pagereference ReadPeopleFile() {
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder

    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e));
      return null;
    } finally {
      fileName = document.name ;
      fileID = document.id ;
      document.body = null; //-- clears the viewstate
      document = new Document();
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    pageReference newPage = page.dataMigratorShowStatus ;
    newPage.getParameters().put('fName', fileName);
    newPage.getParameters().put('fID', fileID);
    newPage.getParameters().put('action', 'peopleLoad');
    newPage.setRedirect(true);
    return (newPage) ;       
  }

  public Pagereference ReadCPEProgramFile() {
    
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder

    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e));
      return null;
    } finally {
      fileName = document.name ;
      fileID = document.id ;
      document.body = null; //-- clears the viewstate
      document = new Document();
    }
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    pageReference newPage = page.dataMigratorShowStatus ;
    newPage.getParameters().put('fName', fileName);
    newPage.getParameters().put('fID', fileID);
    newPage.getParameters().put('action', 'CPEProgramLoad');
    newPage.setRedirect(true);
    return (newPage) ; 
        
  }
  public Pagereference ReadCPEClaimFile() {
    
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder

    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e));
      return null;
    } finally {
      fileName = document.name ;
      fileID = document.id ;
      document.body = null; //-- clears the viewstate
      document = new Document();
    }  
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    pageReference newPage = page.dataMigratorShowStatus ;
    newPage.getParameters().put('fName', fileName);
    newPage.getParameters().put('fID', fileID);
    newPage.getParameters().put('action', 'CPEClaimLoad');
    newPage.setRedirect(true);
    return (newPage) ; 
        
  }
     
  public Pagereference ReadChapterFile() {
    nameChapterFile=ChapterFile.toString();
        
    // Load Date to Chapter__c records 
    Chapters2Upload = new List< Chapter__c >();
    List<List<String>> parsedFile = new List<List<String>>();
    parsedFile = migrationUtil.parseCSV( nameChapterFile, TRUE ) ;
    system.debug('* * * In dateMigrator... parsedFile is.. '+parsedFile);
    string tempType ;
    string tempName ;
    list< string > nameWords = new list< string > () ;
    for ( list< string > row : parsedFile ) {
      Chapter__c c = new Chapter__c();
      c.LEGACY_PK_Chapter__c = row[0].replace( '"','') ;
      c.LEGACY_Name__c = row[1].replace( '"','') ;
      if ( c.LEGACY_Name__c.length() <= 80 ) {
          c.name = c.LEGACY_Name__c ;
          system.debug('* * * In dateMigrator... Legacy Name is less than 80 chars.');
        } else {
          nameWords = row[1].replace( '"','').split( ' ', -1 ) ; 
          system.debug('* * * In dateMigrator... nameWords is.. '+nameWords);
          tempName = '' ;
          for(string s : nameWords ) { 
            if( tempName.length()+s.length() >= 80 ) break ;
            if( tempName.length() == 0 ) tempName = s ; else tempName = tempName+' '+s ;
          }
          c.name = tempName ;
        }
      c.Location__c =  row[5].replace( '"','') ;
      tempType = row[4].replace( '"','') ; 
      c.Type__c  = 
        ( tempType == '1' ) ? 'Professional' : 
          ( tempType == '2' ) ? 'University' : 'Unknown' ;
      c.Status__c = 
        ( tempType == '3' ) ? 'Suspended' : 'Active' ;
      //c.Active__c = ( c.Status__c == 'Active' ) ? TRUE : FALSE ;
      Chapters2Upload.add(c);
    }
    try{
      upsert Chapters2Upload LEGACY_PK_Chapter__c;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured loading Chapter.  '+e);
      ApexPages.addMessage(errormsg);
    }    
    return null;
  }
  
  public Pagereference ReadSitesFile() {
    nameSitesFile=SitesFile.toString();
    //filelines = nameSitesFile.split('\n');
    map< id, Site__c > siteID2Site = new map< id,Site__c > () ;
    set< id > siteIDs = new set< id >() ;
        
    // Load Date to Site__c records 
    Sites2Upload = new List<Site__c>();
    List<List<String>> parsedFile = new List<List<String>>();
    parsedFile = migrationUtil.parseCSV( nameSitesFile, TRUE ) ;
    system.debug('* * * In dateMigrator... parsedFile is.. '+parsedFile);
    set< string > CountriesRefBySites = new set< string > () ;
    for ( list< string > row : parsedFile ) {
      Site__c s = new Site__c();
      s.LEGACY_PK_ExamSite__c = row[0].replace( '"','') ;
      s.LEGACY_FRMSiteID__c = row[16].replace( '"','') ;
      s.name = row[1].replace( '"','') ;
      s.LEGACY_Year__c = row[9].replace( '"','') ; 
      s.LEGACY_Month__c =  row[22].replace( '"','') ;
      s.Active__c = TRUE ;
      Sites2Upload.add(s);
      CountriesRefBySites.add( row[8].replace( '"','') );
    }
    try{
      upsert Sites2Upload LEGACY_PK_ExamSite__c;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      ApexPages.addMessage(errormsg);
    }    
    
    map< string, LEGACY_Country__c > FKCountryID2CountryRec = new map< string, LEGACY_Country__c >() ;
    for ( LEGACY_Country__c c : [ SELECT id, name, PK_Country__c FROM LEGACY_Country__c WHERE PK_Country__c IN :CountriesRefBySites ] )
      FKCountryID2CountryRec.put( c.PK_Country__c, c ) ;
      
    // Create map to relate Venues to Site
    Venues2Upload = new List<Venue__c>();
    map< string, id > pkID2SiteID = new map< string, id > () ;
    for ( Site__c s : Sites2Upload ) 
      pkID2SiteID.put( s.LEGACY_PK_ExamSite__c, s.id ) ;
    // Load Date to Venue__c records 
    for ( list< string > row : parsedFile ) {
      Venue__c v = new Venue__c();
      v.LEGACY_PK_ExamSite__c = row[0].replace( '"','') ;
      v.name = row[1].replace( '"','') ;
      v.Site__c = pkID2SiteID.get( v.LEGACY_PK_ExamSite__c ) ;
      v.Building_Name__c = row[2].replace( '"','') ;
      v.Address1__c = row[3].replace( '"','') ;
      v.Address2__c = row[4].replace( '"','') ;
      v.City__c = row[5].replace( '"','') ;
      v.State__c = row[6].replace( '"','') ;
      v.Zipcode__c = row[7].replace( '"','') ;
      v.Active__c = TRUE ;
      system.debug('* * * In dateMigrator... FKCountryID2CountryRec is.. '+FKCountryID2CountryRec);
      system.debug('* * * In dateMigrator... row[8].replace(xxxx) is.. '+row[8].replace( '"',''));
      v.Country__c = FKCountryID2CountryRec.get( row[8].replace( '"','')).name ;
      Venues2Upload.add(v);
    }
    try{
      upsert Venues2Upload LEGACY_PK_ExamSite__c ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      ApexPages.addMessage(errormsg);
    }   

    //Setup to trhow errors if anomolies are detected while createing ExamSites
    try {
       map< id, string > siteID2SiteKey = new map< id, string > () ; 
       map< integer, map< integer, list<ID> >> yearAndMonth2SiteID = new map< integer, map< integer, list<ID> >>() ;
       list< Exam_Sites__c > ESs2Add = new list< Exam_Sites__c > () ;
       for( Site__c s : [
         SELECT id, LEGACY_Year__c, LEGACY_Month__c, LEGACY_PK_ExamSite__c
         FROM Site__c 
         WHERE LEGACY_PK_ExamSite__c != NULL ] ) {
         
         //if ( s.LEGACY_Year__c == NULL ) throw new processingException('Year is missing from Site record ' + s.id);
         //if ( s.LEGACY_Month__c == NULL ) throw new processingException('Month is missing from Site record ' + s.id);
         if ( yearAndMonth2SiteID.get( integer.valueOf( s.LEGACY_Year__c ) ) == NULL ) 
           if ( s.LEGACY_Year__c != NULL )
             yearAndMonth2SiteID.put( integer.valueOf( s.LEGACY_Year__c ), new map< integer, list<ID> >() ) ;
         if ( yearAndMonth2SiteID.get( integer.valueOf( s.LEGACY_Year__c ) ).get( integer.valueOf( s.LEGACY_Month__c )) == NULL )
           if ( s.LEGACY_Year__c != NULL && s.LEGACY_Month__c != NULL )
             yearAndMonth2SiteID.get( integer.valueOf( s.LEGACY_Year__c ) ).put( integer.valueOf( s.LEGACY_Month__c ), new list<id>() ) ;
         if ( s.LEGACY_Year__c != NULL && s.LEGACY_Month__c != NULL ) {
           yearAndMonth2SiteID.get( integer.valueOf( s.LEGACY_Year__c ) ).get( integer.valueOf( s.LEGACY_Month__c )).add( s.id ) ; 
           siteID2SiteKey.put( s.id, s.LEGACY_PK_ExamSite__c ) ;
         }
       }
       integer year, month ;
       list<id> idsOfSites2Link2Exam = new list< id > ();
       for ( Exam__c exam : [
         SELECT id, Exam_Date__c, exam__c
         FROM Exam__c WHERE LEGACY_PK_Product_Exam__c != NULL ] ) {
         
         year = exam.Exam_Date__c.year() ;
         month = exam.Exam_Date__c.month() ;
         system.debug('* * * In dateMigrator... making Exam Sites... exam is  '+exam);
         system.debug('* * * In dateMigrator... making Exam Sites... yearAndMonth2SiteID is  '+yearAndMonth2SiteID);
         if ( year == NULL ) throw new processingException('Year is NULL ' + exam.id );
         if ( month == NULL ) throw new processingException('Month is NULL ' + exam.id );
         //if ( yearAndMonth2SiteID.get( year ) == NULL ) throw new processingException('Year Missing From yearAndMonth2SiteID ' + year );      
         //if ( yearAndMonth2SiteID.get( year ).get( month ) == NULL )
           //throw new processingException('Exam has no sites ' + exam.id );
         if ( yearAndMonth2SiteID.get( year ) != NULL )
           if ( yearAndMonth2SiteID.get( year ).get( month ) != NULL ) {
             idsOfSites2Link2Exam = yearAndMonth2SiteID.get( year ).get( month ) ;
             for ( id i : idsOfSites2Link2Exam ) {
               Exam_Sites__c newES = new Exam_Sites__c (
                 Exam__c = exam.id, 
                 Exam_Date__c = exam.Exam_Date__c,
                 Site__c = i, 
                 LEGACY_PK_ExamSite__c =  siteID2SiteKey.get( i )+exam.exam__c ) ;
               ESs2Add.add( newES ) ;
             }
           }
       }
       upsert ESs2Add LEGACY_PK_ExamSite__c ;        




    } catch ( processingException e ) {
      ApexPages.Message processingErrorMsg = new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()); 
      ApexPages.addMessage(processingErrorMsg);
    }



    return null;
  }

  public Pagereference ReadRoomsFile() {
    
    map< string, LEGACY_Country__c > FKCountryID2CountryRec = new map< string, LEGACY_Country__c >() ;
    for ( LEGACY_Country__c c : [ SELECT id, name, PK_Country__c FROM LEGACY_Country__c ] )
      FKCountryID2CountryRec.put( c.PK_Country__c, c ) ;
      
    nameRoomsFile=RoomsFile.toString();
    List<List<String>> parsedFile = new List<List<String>>();
    parsedFile = migrationUtil.parseCSV( nameRoomsFile, TRUE ) ;
    set< string > siteCodes = new set< string >() ;
    
    for ( list< string > row : parsedFile )    
      siteCodes.add( row[1].replace( '"','')) ;
    
    map< string, ID > FK_ExamSiteID2SFSiteID = new map< string, ID >() ;
    
    for ( Venue__c v : [ SELECT
      id, LEGACY_PK_ExamSite__c FROM Venue__c WHERE LEGACY_PK_ExamSite__c IN :siteCodes ] )
      FK_ExamSiteID2SFSiteID.put ( v.LEGACY_PK_ExamSite__c, v.id ) ;
    
    List<Room__c> Rooms2Upload = new List<Room__c>();
    for ( list< string > row : parsedFile )  {  
       Room__c r = new Room__c();
       r.LEGACY_PK_Room__c = row[0].replace( '"','') ;  
       r.Venue__c = FK_ExamSiteID2SFSiteID.get( row[1].replace( '"','') ) ;
       r.name = row[2].replace( '"','') ; 
       r.Capacity__c = integer.valueOf(row[3].replace( '"','')) ;  
       r.Active__c = TRUE ;
       Rooms2Upload.add( r ) ;
    }
    try{
      upsert Rooms2Upload LEGACY_PK_Room__c;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      ApexPages.addMessage(errormsg);
    }    
    return null;
  }
    
  public List< Site__c > getSites2Upload() {
    if (Sites2Upload!= NULL)
      if (Sites2Upload.size() > 0)
        return Sites2Upload;
        else
        return null;                    
      else
      return null;
  }  

  public Pagereference ReadExamsFile() {
      
    nameExamsFile = ExamsFile.toString();
    List<List<String>> parsedFile = new List<List<String>>();
    parsedFile = migrationUtil.parseCSV( nameExamsFile, TRUE ) ;
    
    map< string, Product2 > pCode2Product = new map< string, Product2 > () ;
    // Load map with products that require programs
    for ( Product2 p : [
      SELECT Action__c, hasProgram__c, Program_Name__c, Program_Type__c, Product_ID__c, VersionNo__c 
      FROM Product2 ] )
        pCode2Product.put( p.Product_ID__c, p ) ;
    
    exam__c exam ;
    map< date, id > examDate2ExamGroup = new map< date, id > () ;
    list< exam__c > exams2Upload = new list< exam__c > () ;
    Exam_Group__c g ;
    List< Exam_Group__c > examGroups2Upload = new List< Exam_Group__c >();
    string tempExamType ;
    for ( list< string > column : parsedFile )  {  
      if ( column[1].replace( '"','') == '3'|| column[1].replace( '"','') == '12' ) { 
        // Make Exam
        exam = new exam__c() ;
        exam.name = column[2].replace( '"','') ;
        exam.LEGACY_PK_Product_Exam__c = column[0].replace( '"','') ;
        exam.Registration_Product__c = pCode2Product.get( exam.LEGACY_PK_Product_Exam__c ).id ;
        tempExamType = migrationUtil.deNULLify(column[8].replace( '"','') );
        set< string > EarlyFRM = new set< string > { '1', '2', '34', '35', '36', '206', '302', '384', '482', '682' } ;
        if( tempExamType == '' ) {
          system.debug( '* * * In ReadExamsFile... processing early exam,,,, exam.LEGACY_PK_Product_Exam__c  is.. '+exam.LEGACY_PK_Product_Exam__c );
          exam.exam__c = EarlyFRM.contains( exam.LEGACY_PK_Product_Exam__c ) ? 'FRM FULL Program' :'Unknown' ;  
          system.debug( '* * * In ReadExamsFile... processing early exam,,,, tempExamType  is.. '+tempExamType );     
        } else {
          exam.exam__c = 
            tempExamType == 'LEVEL I' ? 'FRM Part 1' : 
              tempExamType == 'LEVEL II' ? 'FRM Part 2' : 
                tempExamType == 'FULL PROGRAM' ? 
                  (( column[1].replace( '"','') == '3') ? 'FRM FULL Program' : 'ERP' ) : 'Unknown' ;
          system.debug( '* * * In ReadExamsFile... translating ExamType,,,, exam.exam__c  is.. '+exam.exam__c );
        }
        //Exam_Group__c = e.id,
        exam.Exam_Date__c = migrationUtil.getDate( column[10].replace( '"','')) ; 
        system.debug( '* * * In ReadExamsFile... adding item to exams2upload ,,,, exam  is.. '+exam );
        exams2Upload.add( exam ) ;
        if ( exam.exam__c == 'FRM Part 1' || exam.exam__c == 'FRM FULL Program' ) {
          // Make Exam Group
          g = new Exam_Group__c();
          g.LEGACY_PK_Product__c = column[0].replace( '"','') ; 
          
          g.Exam_Date__c = migrationUtil.getDate( column[10].replace( '"','') ) ;
          g.name = 'Exam ' + g.Exam_Date__c.format() ; 
          g.Israle_Deferral_Exam_Date__c = g.Exam_Date__c + 1 ;
          g.Registration_Start_Date__c = g.Exam_Date__c - 180 ;
         
          g.Last_Date_For_Early_Registration__c = g.Exam_Date__c - 150 ;
          g.Last_Date_For_Standard_Registration__c = g.Exam_Date__c - 100 ;
          g.Last_Date_For_Late_Registration__c = g.Exam_Date__c - 80 ;
         
          g.Last_Date_For_Location_Change__c = g.Exam_Date__c - 80 ;
          g.Last_Date_For_Scholarship__c = g.Exam_Date__c - 80 ;
          g.Last_Date_To_Apply_For_Deferral__c = g.Exam_Date__c - 80 ;
          g.Last_Date_To_Request_Exam_Change__c = g.Exam_Date__c - 80 ;
          g.Last_Date_For_ADA__c = g.Exam_Date__c - 80 ;
          g.Religious_Alternative_Last_Date__c = g.Exam_Date__c - 80 ;
          system.debug('* * * In ReadProductsFile... g is.. '+g);
          examGroups2Upload.add( g ) ;
        }
      }
    }
    try{
      upsert examGroups2Upload LEGACY_PK_Product__c;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      ApexPages.addMessage(errormsg);
    }    
    for ( Exam_Group__c eg : examGroups2Upload )
      examDate2ExamGroup.put( eg.Exam_Date__c, eg.id ) ;   
      
    for ( exam__c e : exams2Upload ) {
      e.Exam_Group__c = examDate2ExamGroup.get( e.Exam_Date__c ) ;
      system.debug( '* * * In ReadExamsFile... linking exam2group ,,,, exam  is.. '+exam );
      system.debug( '* * * In ReadExamsFile... linking exam2group ,,,, examDate2ExamGroup  is.. '+examDate2ExamGroup );
    }

    try{
      upsert exams2Upload LEGACY_PK_Product_Exam__c ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      ApexPages.addMessage(errormsg);
    }
    
    Site__c dummySite = new Site__c (
      name = 'dummySite', 
      Display_Address__c = 'xyz' ) ;
    insert dummySite ;
    list< Exam_Sites__c > examSites2Upload = new list< Exam_Sites__c >  () ;
    Exam_Sites__c es ;
    for( exam__c e : exams2Upload ) {
      es = new Exam_Sites__c(
        name = 'Registrations without sites',
        Site__c = dummySite.id,
        Exam__c = e.id,
        LEGACY_PK_Product_Exam__c = e.LEGACY_PK_Product_Exam__c );
      examSites2Upload.add( es ) ;
    }
    try{
      upsert examSites2Upload LEGACY_PK_Product_Exam__c ;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      ApexPages.addMessage(errormsg);
    }


  return null;
  }    

  public Pagereference ReadPurchaseFile() {
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder

    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+e));
      return null;
    } finally {
      fileName = document.name ;
      fileID = document.id ;
      document.body = null; //-- clears the viewstate
      document = new Document();
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    pageReference newPage = page.dataMigratorShowStatus ;
    newPage.getParameters().put('fName', fileName);
    newPage.getParameters().put('fID', fileID);
    newPage.getParameters().put('action', 'purchaseLoad');
    newPage.setRedirect(true);
    return (newPage) ;      
  }
  
  public Pagereference ReadFRMFile() {     
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder

    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading FRM_Tab file'+e));
      return null;
    } finally {
      fileName = document.name ;
      fileID = document.id ;
      document.body = null; //-- clears the viewstate
      document = new Document();
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    pageReference newPage = page.dataMigratorShowStatus ;
    newPage.getParameters().put('fName', fileName);
    newPage.getParameters().put('fID', fileID);
    newPage.getParameters().put('action', 'FRMLoad');
    newPage.setRedirect(true);
    return (newPage) ;            
  } 

  public Pagereference ReadChapterMeetingFile() {
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder

    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading Capter Meeting file'+e));
      return null;
    } finally {
      fileName = document.name ;
      fileID = document.id ;
      document.body = null; //-- clears the viewstate
      document = new Document();
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    pageReference newPage = page.dataMigratorShowStatus ;
    newPage.getParameters().put('fName', fileName);
    newPage.getParameters().put('fID', fileID);
    newPage.getParameters().put('action', 'ChapterMeetingLoad');
    newPage.setRedirect(true);
    return (newPage) ;      
  }

  public Pagereference ReadChapterMeetingRegFile() {
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder

    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading Capter Meeting Registration file'+e));
      return null;
    } finally {
      fileName = document.name ;
      fileID = document.id ;
      document.body = null; //-- clears the viewstate
      document = new Document();
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    pageReference newPage = page.dataMigratorShowStatus ;
    newPage.getParameters().put('fName', fileName);
    newPage.getParameters().put('fID', fileID);
    newPage.getParameters().put('action', 'ChapterMeetingRegLoad');
    newPage.setRedirect(true);
    return (newPage) ;      
  }
  
  public Pagereference ReadResultsFile() {     
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder

    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading Results_Tab file'+e));
      return null;
    } finally {
      fileName = document.name ;
      fileID = document.id ;
      document.body = null; //-- clears the viewstate
      document = new Document();
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    pageReference newPage = page.dataMigratorShowStatus ;
    newPage.getParameters().put('fName', fileName);
    newPage.getParameters().put('fID', fileID);
    newPage.getParameters().put('action', 'ResultLoad');
    newPage.setRedirect(true);
    return (newPage) ;            
  } 
        
  public List<Exam_Attempt__c> getuploadedEAs() {
    if (EAs2Upload!= NULL)
      if (EAs2Upload.size() > 0)
        return EAs2Upload;
        else
        return null;                    
      else
      return null;
  } 
    public PageReference getProgress() { 
      system.debug( '* * * In getProgress... fileOffset is.. '+fileOffset);
      string file ;
      integer chunksize = isPurchaseLoadInProgress ? 170 : isFRMLoadInProgress ? 20 : 4000 ;
      string chunk ;
      if ( fileOffset != NULL  ) {
        if ( file == NULL )
          file = [SELECT body, description FROM document WHERE id = :fileID ].body.toString() ;
        
       
        system.debug( '* * * In getProgress... file.length()  is.. '+file.length() );
        system.debug( '* * * In getProgress... fileOffset  is.. '+fileOffset );
        system.debug( '* * * In getProgress... chunksize  is.. '+chunksize );
        system.debug( '* * * In getProgress... hasActiveJobs  is.. '+hasActiveJobs );
        fileSize = file.length() ;
        if ( fileOffset < file.length() && !hasActiveJobs  ) {
          isFirstChunk = (( fileOffset == 0 )? TRUE : FALSE ) ;
          system.debug( '* * * In getProgress... just set isFirstChunk to.. '+isFirstChunk );
          integer endIndex = fileOffset ;
          integer startIndex = fileOffset ;
          integer tempIndex ;
          for( integer i=0; i < chunksize ; i++ ) {
            tempIndex = file.indexof( '\n', endIndex );
            //system.debug( '* * * In getProgress... checking for lineitem staddle  ... beginning of current line is ... '+file.substring(tempIndex, tempIndex+32) ) ;
            //system.debug(  '* * * In getProgress... tempIndex  is.. '+tempIndex );
            if( tempIndex == -1 ) {
              endIndex = file.length() ;
              break ;
            } else {
              // This is so line items in orders can's straddle chunks
              //system.debug( '* * * In getProgress... checking for lineitem staddle  ... file.substring(tempIndex, tempIndex+32) is ... '+file.substring(tempIndex, tempIndex+32) ) ;
              if( isPurchaseLoadInProgress ) {
                string currentPID  ; 
                if ( file.length() > tempIndex+32 ) {
                  currentPID = file.substring(tempIndex, tempIndex+32).split(',', 3)[1] ;
                }
                //system.debug( '* * * In getProgress... checking for lineitem staddle  ... currentPID is ... '+currentPID+' and tempIndex is... '+tempIndex ) ;
                if ( isPurchaseLoadInProgress &&  i+1 == chunksize ) {
                  integer sneakPeakIndex = file.indexof( '\n', tempIndex+1 );
                  if ( file.length() > sneakPeakIndex+32 ) {
                    string nextPID = file.substring(sneakPeakIndex, sneakPeakIndex+32).split(',', 3)[1] ;
                    //system.debug( '* * * In getProgress... checking for lineitem staddle  ... nextPID is ... '+nextPID+' and sneakPeakIndex is... '+sneakPeakIndex ) ;
                    if( currentPID == nextPID ) i-- ;
                  } else i-- ;
                } 
              }
              endIndex = tempIndex + 1 ;
            }
          }
          system.debug( '* * * In getProgress... instantiating with  ... '+file.substring(startIndex, endIndex) );
          system.debug( '* * * In getProgress... instantiating with fileOffset is  ... '+fileOffset);
          
          if ( isPurchaseLoadInProgress ) {
            Database.executeBatch(new processPurchaseRows( file.substring(startIndex, endIndex), isFirstChunk  ), 5);
            isPurchaseLoadInProgress = TRUE ;
          }
          if ( isPeopleLoadInProgress ) {
            Database.executeBatch(new processPeopleRows( file.substring(startIndex, endIndex), isFirstChunk  ), 3);
            isPeopleLoadInProgress = TRUE ;
          }
          if ( isFRMLoadInProgress ) {
            Database.executeBatch(new processFRMRows( file.substring(startIndex, endIndex), isFirstChunk  ), 5);
            isFRMLoadInProgress = TRUE ;
          }
         
          if ( isResultLoadInProgress ) {
            Database.executeBatch(new processResultRows( file.substring(startIndex, endIndex), isFirstChunk  ), 5);
            isResultLoadInProgress = TRUE ;
          }          
         
          if ( isChapterMeetingLoadInProgress ) {
            //system.debug( '* * * In getProgress... calling processChapterMeetingRows and passing isFirstChunk as .. '+isFirstChunk );
            Database.executeBatch(new processChapterMeetingRows( file.substring(startIndex, endIndex), isFirstChunk  ), 5);
            isChapterMeetingLoadInProgress = TRUE ;
          }              

          if ( isChapterMeetingRegLoadInProgress ) {
            Database.executeBatch(new processChapterMeetingRegistrationRows( file.substring(startIndex, endIndex), isFirstChunk  ), 5);
            isChapterMeetingRegLoadInProgress = TRUE ;
          }       
          if ( isCPEProgramLoadInProgress ) {
            Database.executeBatch(new processCPDProgramRows( file.substring(startIndex, endIndex), isFirstChunk  ), 5);
            isCPEProgramLoadInProgress = TRUE ;
          }    
          if ( isCPEClaimLoadInProgress ) {
            Database.executeBatch(new processCPDClaimRows( file.substring(startIndex, endIndex), isFirstChunk  ), 5);
            isCPEClaimLoadInProgress = TRUE ;
          }                              
          hasActiveJobs = TRUE ;
          isFirstChunk = FALSE ;
          fileOffset = endIndex++ ;
        } else {
          if ( isPeopleLoadInProgress )   isPeopleLoadInProgress = hasActiveJobs ? TRUE : FALSE ;
          if ( isPurchaseLoadInProgress ) isPurchaseLoadInProgress = hasActiveJobs ? TRUE : FALSE ;
          if ( isFRMLoadInProgress ) isFRMLoadInProgress = hasActiveJobs ? TRUE : FALSE ;
          if ( isResultLoadInProgress ) isResultLoadInProgress = hasActiveJobs ? TRUE : FALSE ;
          if ( isChapterMeetingLoadInProgress ) isChapterMeetingLoadInProgress = hasActiveJobs ? TRUE : FALSE ;  
          if ( isChapterMeetingRegLoadInProgress ) isChapterMeetingRegLoadInProgress = hasActiveJobs ? TRUE : FALSE ;    
          if ( isCPEProgramLoadInProgress ) isCPEProgramLoadInProgress = hasActiveJobs ? TRUE : FALSE ;   
          if ( isCPEClaimLoadInProgress ) isCPEClaimLoadInProgress = hasActiveJobs ? TRUE : FALSE ;   
        }
      }
      
      system.debug( '* * * In getProgress... checking for active jobs');  
      activeJobs = [
        SELECT id, JobType, NumberOfErrors , MethodName, Status, CreatedDate, 
          ApexClass.name, TotalJobItems, JobItemsProcessed
        FROM AsyncApexJob 
        WHERE (MethodName = 'processPeopleChunk' OR
          MethodName = 'processPurchaseChunk' OR
          MethodName = 'processFRMChunk' OR
          //MethodName = 'delAccts' OR
          //MethodName = 'delEAs' OR
          //MethodName = 'makeEAsBatch' OR
          MethodName = '' )
          AND ( JobType = 'BatchApex' )
          AND
          Status != 'Completed' AND
          Status != 'Failed' AND
          Status != 'Aborted'
        ORDER BY CreatedDate DESC
        LIMIT 10] ; 
      
      hasActiveJobs = activeJobs.size() > 0 ? TRUE : FALSE ;
      
      system.debug( '* * * In getProgress... isPeopleLoadInProgress is.. '+isPeopleLoadInProgress);
      system.debug( '* * * In getProgress... activeJobs.size() is.. '+activeJobs.size());
      
      if ( hasActiveJobs || 
        isPeopleLoadInProgress || 
        isPurchaseLoadInProgress || 
        isResultLoadInProgress || 
        isChapterMeetingLoadInProgress || 
        isChapterMeetingRegLoadInProgress || 
        isCPEProgramLoadInProgress || 
        isCPEClaimLoadInProgress || 
        isFRMLoadInProgress ) {    
        return NULL ; 
      } else {
        pageReference newpage = page.dataMigrator ;
        newPage.setRedirect(true);
        return (newPage) ;   
      }
  }           
}