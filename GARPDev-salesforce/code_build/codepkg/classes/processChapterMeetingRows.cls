public class processChapterMeetingRows implements Database.Batchable<string>{
  
  public string fileString;
  private boolean isFirstChunk;
  
  public processChapterMeetingRows(string s, boolean isFChunk ) {
    //system.debug('* * * In processChapterMeetingRows... isFChunk was passed as .. '+isFChunk);
    fileString = s ;
    isFirstChunk = isFChunk ;
  }

  public Iterable<string> start(Database.BatchableContext ctx ){ 
    integer chunksize = 350 ;
    list< string > chunks = new list< string > () ;
    string chunk ;
    integer endIndex = 0 ;
    integer startIndex = 0 ;
    integer tempIndex ;
    fileString.indexof( '\n' );
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
        migrationUtil2.processChapterMeetingChunk( s, isFirstChunk) ; 
        isFirstChunk = FALSE ;
      }
    }     
    public void finish(Database.BatchableContext ctx){     
    } 
}