public with sharing class FileUploadController {
  
  //doc.
  public Document document {
    get {
      if (document == null)
        document = new Document();
      return document;
    }
    set;
  }
    
  //Main Doc. Upload  
  public PageReference upload() {
     Boolean boolNameExists = false;
     Boolean boolDocName = false; 
     Boolean boolDocBody = false;
      if(document.body == null){
         boolDocName = true;
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Attach a file please!'));
       }
      else if(document.name == null){
         boolDocName = true;
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Name the file!'));
      }
      else {
        //put in User's folder
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = '00l30000002E2Ei';
        document.IsInternalUseOnly = true;
        document.type = 'swf';
            try {
              List <Document> listDocument =  [Select Name from Document];
              System.Debug('listDocument'+ listDocument);
              System.Debug(listDocument);    
                  for(integer i =0; i < listDocument.size(); i++){
                      if(listDocument[i].Name == document.name){
                          boolNameExists = true;  
                      }
                 }
                   if(boolNameExists == true){
                       System.Debug('Testing');
                       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Name exists already'));
                   }
                   else{   
                      System.Debug(boolNameExists); 
                      insert document;
                      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
                   }
            }
  
            catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
                return null;
            }
 
            finally {
              document.body = null; // clears the viewstate
              document = new Document();
            }
    }
       if(boolNameExists == false && boolDocName == false && boolDocBody == false){
           PageReference redirectURL = new PageReference('/apex/CaptivateManagement');
           return redirectURL;
       }
       else
           return null;
   } 
   
  //Cancel upload 
  public PageReference Cancel()  {
    PageReference pageRedirect = new PageReference('/apex/captivateManagement');
    return pageRedirect;
  } 
}