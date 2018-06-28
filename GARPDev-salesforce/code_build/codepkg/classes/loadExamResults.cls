public class loadExamResults {
  private final Exam__c exam;
  public loadExamResults(ApexPages.StandardController stdController) {
     this.exam = (Exam__c)stdController.getRecord();
    }

  //public string nameFile{get;set;}
  
  public boolean loadedResultsFile{get;set;}

  public string nameResultsFile{get;set;}

  public Blob ResultsFile{get;set;}

  String[] filelines = new String[]{};
  List< Exam_Result__c > ERs2Upload;
  List< Exam_Attempt__c > EAs2Udate ;
  List< Exam_Category__c > Catagories2Upload ;

  //define your custom exception
  public class processingException extends Exception{}  
  //public Pagereference LoadExamResults() {return NULL;}
  
  public Pagereference ReadResultsFile() {
    nameResultsFile=ResultsFile.toString();
        
    // Load Date to Site__c records 
    //Countries2Upload = new List< LEGACY_Country__c >();
    List<List<String>> parsedFile = new List<List<String>>();
    parsedFile = migrationUtil.parseCSV( nameResultsFile, FALSE ) ;
    system.debug('* * * In loadExamResults... parsedFile is.. '+parsedFile);
    boolean isFirstRow = TRUE ;
    set< string > garpIDs = new set< string > () ;
    set< string > CategoriesInFile = new set< string > (); 
    map< integer, string > CatColumn2CatName = new map< integer, string > ();
    map< string, id > CatName2CatID = new map< string, id > ();
    list<Exam_Attempt__c> EAsReferencedInResults = new list<Exam_Attempt__c> () ; 
    map< string, integer > gID2EAindex = new map< string, integer > ();
    
    for ( list< string > row : parsedFile ) {
      if ( isFirstRow ) { 
        if( row[0].replace( '"','') != 'GARP ID' ) {
          ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'First title field should be GARP ID... it is '+row[0].replace( '"',''));
          ApexPages.addMessage(errormsg);
        }     
        for (integer i=4; row.size()>i; i++) {
          CategoriesInFile.add( row[i].replace( '"','').trim()) ;
          system.debug('* * * In loadExamResults... CategoriesInFile is.. '+CategoriesInFile);
          CatColumn2CatName.put( i, row[i].replace( '"','').trim()) ;
        }

        list< Exam_Category__c > Categories2Add = new list< Exam_Category__c > ();
        set< string > existingCategories = new set< string > ();
        system.debug('* * * In loadExamResults... CategoriesInFile is.. '+CategoriesInFile);
        
        for( Exam_Category__c cat : [SELECT id, name FROM Exam_Category__c WHERE Name IN :CategoriesInFile ] )
          if( CategoriesInFile.contains( cat.name ) ) existingCategories.add( cat.name ) ;
       
        system.debug('* * * In loadExamResults... existingCategories is.. '+existingCategories);  
        
        
        for ( string s : CategoriesInFile )
          if ( ! existingCategories.contains( s ) ) 
            Categories2Add.add( new Exam_Category__c( name = s )) ;
        system.debug('* * * In loadExamResults... Categories2Add is.. '+Categories2Add);  
        insert Categories2Add ;
        for( Exam_Category__c cat : [SELECT id, name FROM Exam_Category__c WHERE name IN : CategoriesInFile ] )
          CatName2CatID.put( cat.name, cat.id ) ;
        system.debug('* * * In loadExamResults... CatName2CatID is.. '+CatName2CatID);
        isFirstRow = FALSE ;
      } else {
        // Data Rows
        garpIDs.add( row[0].replace( '"','')) ; 
      }
      
      
      
      
      
      system.debug('* * * In loadExamResults... exam is.. '+exam);
      //LEGACY_Country__c c = new LEGACY_Country__c();
      //c.PK_Country__c = row[0].replace( '"','') ;
      //c.name = row[1].replace( '"','') ;
      //c.Phone_Code__c = row[2].replace( '"','') ;     
      //c.Currency__c = row[3].replace( '"','') ;     
      //c.LetterCode__c = row[4].replace( '"','') ;     
      //c.RegionID__c = ( row[5].replace( '"','') == 'NULL') ? '' : row[5].replace( '"','') ;     
      //c.ISOCode__c  = ( row[6].replace( '"','') == 'NULL') ? '' : row[6].replace( '"','') ;     

      //Countries2Upload.add(c);
    }
    try{
      EAsReferencedInResults = [ 
        SELECT id, Score__c, Quartile__c, Member__r.GARP_ID__c, result__c 
        FROM Exam_Attempt__c
        WHERE Member__r.GARP_ID__c IN :garpIDs AND
          Exam_Site__r.Exam__c = :exam.id ]  ;
      integer i = 0 ;
      for( Exam_Attempt__c EA : EAsReferencedInResults ) {
        gID2EAindex.put( EA.Member__r.GARP_ID__c, i ) ;
        i++;
      }
      
      //upsert Countries2Upload PK_Country__c;
    }
    catch (Exception e) {
      ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
      ApexPages.addMessage(errormsg);
    }    

    list< Exam_Result__c > ERs2Add = new list< Exam_Result__c > ();
    isFirstRow = TRUE ;
    for ( list< string > row : parsedFile ) {
      if ( isFirstRow ) { 
        isFirstRow = FALSE ; 
      } else {
        if ( gID2EAindex.get(row[0].replace( '"','')) == NULL ) {
          ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'GARP ID from file does NOT match any Exam Registrations... GARP ID is '+row[0].replace( '"',''));
          ApexPages.addMessage(errormsg);
        } else {
          integer index = gID2EAindex.get(row[0].replace( '"','') ) ;
          EAsReferencedInResults[index].score__c = integer.valueOf( row[1].replace( '"','') ) ;
          if ( EAsReferencedInResults[index].result__c == 'No-Show' ) {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Results provided for candidate marked as No-Show... GARP ID is '+row[0].replace( '"',''));
            ApexPages.addMessage(errormsg);
          } else 
            EAsReferencedInResults[index].result__c = ( row[2].replace( '"','') == 'PASS' ) ? 'Pass' : 'Fail' ;
          EAsReferencedInResults[index].Quartile__c = decimal.valueOf( row[3].replace( '"','') ) ;
          for (integer i=4; row.size()>i; i++) {
            system.debug('* * * In loadExamResults... CatName2CatID is.. '+CatName2CatID);
            system.debug('* * * In loadExamResults... CatColumn2CatName is.. '+CatColumn2CatName);
            id catID = CatName2CatID.get( CatColumn2CatName.get( i ) );
            id EAID = EAsReferencedInResults[index].id ; 
            Exam_Result__c ER = new Exam_Result__c ( 
              Exam_Category__c = catID,
              quartile__c = decimal.valueOf( row[i].replace( '"','')),
              Exam_Registrations__c = EAID ) ;
            ERs2Add.add ( ER ) ;  
            
          }
        }
      }   
    } 
    update EAsReferencedInResults ;
    insert ERs2Add ;
    
    
    
    
    return null;
  }

  public Pagereference RemoveResults() {
    list<Exam_Attempt__c> EAs2Clear = [ 
      SELECT id, Score__c, Quartile__c, Member__r.GARP_ID__c, result__c 
      FROM Exam_Attempt__c
      WHERE Exam_Site__r.Exam__c = :exam.id ]  ;
    set<id> eaIDs = new set< id >() ;
    for( Exam_Attempt__c ea : EAs2Clear ) {
      ea.result__c = NULL ;
      ea.score__c = NULL ;
      ea.Quartile__c = NULL ;
      eaIDs.add( ea.id ) ;
    }
    
    list< Exam_Result__c > ERs2Delete = [SELECT id FROM Exam_Result__c WHERE Exam_Registrations__c IN :eaIDs ] ;
    
    update EAs2Clear ;
    delete ERs2Delete ;
    return NULL ;
  }

  //public List< Site__c > getSites2Upload() { 
//    if (Sites2Upload!= NULL)
//      if (Sites2Upload.size() > 0)
//        return Sites2Upload;
//        else
//        return null;                    
//      else
//      return null;
//  }  


        
//  public List<Exam_Attempt__c> getuploadedEAs() {
//    if (EAs2Upload!= NULL)
//      if (EAs2Upload.size() > 0)
//        return EAs2Upload;
//        else
//        return null;                    
//      else
//      return null;
//  }            
}