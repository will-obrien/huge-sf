Public Class textReaderController{
  Public string fileName{get;set;}
  Public Blob fileBody{get;set;}
  Public String[] line{get;set;}
  
   Public String fileContent{get;set;}
   Public String fileContentnew{get;set;}
   public id Docid{get;set;}
   Public String Print{get;set;}
   public String myString {get;set;}
   Public String temp;
   Public textReaderController(){
       line = new String[]{};
       myString  = '';
   }
    Public Void read(){
             line.clear();
             line = new String[]{};
             fileContent = fileBody.toString();
           //  line = fileContent.split('\n');    
                fileContentnew= fileContent.replaceAll('\n','<br/>');            
             system.debug('************'+line);
    }
    Public pageReference download(){
       // print='this text file';
     
       System.debug('####> '+myString );
        Document att = new Document();
        att.name='Text__file';
        att.ContentType='Text/plain';
        att.body = Blob.ValueOf(myString );
        Print =  myString .replaceAll('<br/>','\n'); 
        Print =  Print.replaceAll('<p>','\r\n'); 
        Print =  Print .replaceAll('</p>',''); 
        Print =  Print.replaceAll('<[/a-zAZ0-9]*>',' ');
        
        //--------------convert html tag to plaintext---------------------
        
          
        //-----------------------------------------------------------------
          system.debug('************'+print);
        temp = fileContentnew;
        att.Type = 'txt';
        att.folderid =UserInfo.getUserId();
       // insert att;
        Docid = att.id;
          return new PageReference('/apex/downloadpage');
        
    }
    Public void dwn(){
       // Print =temp;
       //'https://ap1.salesforce.com/servlet/servlet.FileDownload?file={!Docid}';
      
    }
    public void test(){
    
    }
}