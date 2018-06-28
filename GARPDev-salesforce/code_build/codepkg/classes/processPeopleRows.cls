public class processPeopleRows implements Database.Batchable<string>{
  
  public string fileString;
  private boolean isFirstChunk;
  private map< string, string > PKid2CountryName ; 
  private map< string, string > PKid2CountryCode ; 
  public processPeopleRows(string s, boolean isFChunk ) {
    fileString = s ;
    isFirstChunk = isFChunk ;
    PKid2CountryName = migrationUtil.getCountryMap() ; 
    PKid2CountryCode = migrationUtil.getCountryCodeMap() ; 
  }

  public Iterable<string> start(Database.BatchableContext ctx ){ 
    integer chunksize = 200 ;
    list< string > chunks = new list< string > () ;
    string chunk ;
    integer endIndex = 0 ;
    integer startIndex = 0 ;
    integer tempIndex ;
    fileString.indexof( '\n' );
    //boolean isFirstChunk = TRUE ;
    while ( endIndex < fileString.length() ) {
      for( integer i=0; i < chunksize ; i++ ) {
        tempIndex = fileString.indexof( '\n', endIndex );
        if( tempIndex == -1 ) {
          endIndex = fileString.length() ;
          break ;
        } else
          endIndex = tempIndex + 1 ;
      }
      chunks.add( fileString.substring(startIndex, endIndex) ) ; 
      isFirstChunk = FALSE ;
      startIndex = endIndex++ ;
    }

            //Code to split string into chunks so we can return an iterable list of strings 
           //
    return chunks;
    }     
    
    public void execute(Database.BatchableContext ctx, List<string> scope){
              //process rows in scope
      for( string s : scope ) {
        migrationUtil.processPeopleChunk2( s, isFirstChunk, PKid2CountryName, PKid2CountryCode  ) ; 
        isFirstChunk = FALSE ;
      }
    }     
    public void finish(Database.BatchableContext ctx){ 
      isFirstChunk = FALSE ;    
    } 
}