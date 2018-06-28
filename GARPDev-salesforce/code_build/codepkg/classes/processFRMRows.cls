public class processFRMRows implements Database.Batchable<string>{
  public string fileString;
  private boolean isFirstChunk;
  public processFRMRows(string s, boolean isFChunk ) {
    fileString = s ;
    isFirstChunk = isFChunk ; 
  }
  public Iterable<string> start(Database.BatchableContext ctx ){ 
    integer chunksize = 20 ;
    list< string > chunks = new list< string > () ;
    string chunk ;
    integer endIndex = 0 ;
    integer startIndex = 0 ;
    integer tempIndex ;
    fileString.indexof( '\n' );
    boolean isFirstChunk = TRUE ;
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
    return chunks;
    }     
    public void execute(Database.BatchableContext ctx, List<string> scope){
              //process rows in scope
      for( string s : scope )
        migrationUtil.processFRMChunk( s, isFirstChunk ) ; 
      isFirstChunk = FALSE ;
    }     
    public void finish(Database.BatchableContext ctx){     
    } 
}