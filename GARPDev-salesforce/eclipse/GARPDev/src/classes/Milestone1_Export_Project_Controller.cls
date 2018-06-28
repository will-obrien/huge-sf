public with sharing class Milestone1_Export_Project_Controller { 
    
    public Milestone1_Project__c rec {get; set;}
    public Boolean exportSuccess{get;set;}
    public Document doc{get;set;}
    
    public Milestone1_Export_Project_Controller(ApexPages.StandardController stc)
    {
        rec = [SELECT Id,
                      Name, 
                      Description__c 
               FROM Milestone1_Project__c
               WHERE Id = :stc.getId()
              ];
    }
    
    public void createExportXML()
    {
        Milestone1_XML_Export_Utility xmlUtil = new Milestone1_XML_Export_Utility();
        String xmlString = xmlUtil.buildProjectXmlString(rec.Id);
        String exportName = rec.Name;
        String description = rec.Description__c;
        doc = saveToDocument(exportName,xmlString,description); 
    }
    
    public PageReference returnToProject()
    {
        return new ApexPages.StandardController(rec).view();
    }
    
    public PageReference returnToDocument()
    {
        return new ApexPages.StandardController(doc).view();
    }
    
    public Document saveToDocument(String name, String xml, String description) {
        Document d = new Document();
        d.body = Blob.valueOf(xml);
        d.ContentType = 'text/xml';
        d.name = 'Export - ' + name + ' - ' + System.now() + '.xml';
        d.Description = description;
        d.FolderId = UserInfo.getUserId();
        insert d;
        return d;
  }
}