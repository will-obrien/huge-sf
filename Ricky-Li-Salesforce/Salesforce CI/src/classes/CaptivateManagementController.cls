public class CaptivateManagementController {

    Id UserId = UserInfo.getUserId();
    //Properties    
    Public List <Document> listMyDocuments{get;set;}
    Public String Id{get;set;}
    Public String NameSearch{get;set;}
    
    public CaptivateManagementController(){ 
        ListMyDocuments = [Select Id, Name, Description, type, Keywords from Document where AuthorId =: UserId and Type ='swf' order by CreatedDate DESC];
    }    
    //New Document Method
    public PageReference NewDocument() {
        PageReference pageRedirect = new PageReference('/apex/UploadCaptivateFiles');
        return pageRedirect;
    }
    
    //Getters
    public Integer getListMyDocumentsSize() {
        System.Debug(listMyDocuments.size());
        return listMyDocuments.size();   
    }
    
    public String getNameSearch() {
        return null;
    }
    
    //Setters
    Public void setNameSearch(String nameSearch){
        NameSearch = nameSearch;
        System.Debug('hi'+NameSearch);
    }
  
    //To open the Document
    public PageReference OpenLink() {
      Id = ApexPages.CurrentPage().getParameters().get('Id');
      PageReference redirect = new PageReference('/' + Id);
      return redirect;
    }
    
    //Base URL
    public String getBaseURL() {
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        if (baseURL.startsWith('http:')){
            baseURL = baseURL.replaceFirst('http:', 'https:');
        }
        return baseURL;
    }
    
    //Search Name
    public void SearchName() {
        String swf = 'swf';
        String query = 'Select Id, Name, Description, type, Keywords from Document '+'where AuthorId =: UserId and Type=: swf and Name LIKE \'%'+NameSearch+'%\'order by CreatedDate DESC';
        ListMyDocuments = Database.query(query);
    }
}