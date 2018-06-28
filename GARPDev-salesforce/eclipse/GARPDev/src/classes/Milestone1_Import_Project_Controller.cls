public with sharing class Milestone1_Import_Project_Controller {
    public Milestone1_Project__c project {get; set;}
    public List<Document> docs {get;set;}
    public List<SelectOption> docOptions {get;set;}
    public String contentType {get;set;}
    public String docId{get;set;}
    public string fileName{get;set;}  
    public Blob fileBody{get;set;} 
    public Integer docsSize {get;set;} 
    public Integer maxFileSize {get; set;}
    public static Integer MAX_FILE_SIZE = 40000;
    
    private static String CONTENT_ERROR = 'Content is not allowed in prolog.';
    
    public Milestone1_Import_Project_Controller(ApexPages.StandardSetController ssc)
    {
        docOptions = new List<SelectOption>();
        docs = [Select Id, Name from Document where Name like: 'EXPORT %' ];
        
        for (Document doc : docs)
        {
            docOptions.add(new SelectOption(doc.Id,doc.Name));
        }
        docsSize = docs.size();
    }
    
    public PageReference importTemplateXML() {
        
        try {

        	if( this.maxFileSize < 1 ){
        		throw new Milestone1_Import_Exception( Milestone1_Import_Exception.ERROR_EMPTY_XML );
        	}
            Milestone1_XML_Import_Utility importUtility = new Milestone1_XML_Import_Utility();
            String xml = '';
            if( fileBody != null && fileName != null ) {
                system.debug('The Import XML Size == ' + fileBody.size());
                if(fileBody.size() > MAX_FILE_SIZE) {
                    fileBody = null; // Null out the large filesize to prevent ViewState Max Size errors.
                    throw new Milestone1_Import_Exception(Milestone1_Import_Exception.ERROR_FILESIZE_TOO_LARGE + ' The number of characters must be less than ' + MAX_FILE_SIZE +'.');
                }
                xml = fileBody.toString();  
            }
            else {
                xml = getDocumentXMLString();
            }
            if(xml == null || xml.length() < 1) {
                return ApexPages.currentPage();
            }

            project = importUtility.importProject(xml);
            
            
        }
        catch( Exception e ) {
            ApexPages.Message errorMsg = new ApexPages.Message( ApexPages.Severity.FATAL, e.getMessage() );
            if(e.getMessage() != null && e.getMessage().contains(CONTENT_ERROR)) {
                errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Milestone1_Import_Exception.ERROR_INVALID_XML);
            }
            ApexPages.addMessage( errorMsg );
            return ApexPages.currentPage();
        }
        return new ApexPages.StandardController(project).view();
    }
    
    
    public String getDocumentXMLString()
    {
        List<Document> docs = [Select Id, Body, ContentType From Document Where Id = :docId limit 1];
        if(docs.size() != 0)
        {
            String xml = docs.get(0).body.toString();
            return xml;
        }else
        {
            throw new Milestone1_Import_Exception(Milestone1_Import_Exception.ERROR_NO_FILE_SELECTED);
        }
    }
 
}