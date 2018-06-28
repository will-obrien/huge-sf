public with sharing class BulkEmailController {   
    public List<Opportunity> memList {get;set;}
    private Set<Id> memIds = new Set<Id>();
    public List<EmailTemplate> Templates { get; set; }
    public String SelectedTemplate{get;set;} 
    public List<String> DataToBePrinted{get;set;}
    public String SomeData{get;set;}
    public Blob PDFData{get;set;}
    public BulkEmailController(ApexPages.StandardSetController controller) {
         memList = new List<Opportunity>();
         for (Opportunity mem : (List<Opportunity>)controller.getSelected()){ 
            memIds.add(mem.Id);
        }
        
        Templates=[Select Id,Name FROM EmailTemplate];
    }
    
    public PageReference PrintSelectedTemplate() 
    {
        DataToBePrinted = new List<String>();
        EmailTemplate template=[SELECT Id, Body,HtmlValue,TemplateType,Markup FROM EmailTemplate WHERE Id=:SelectedTemplate][0];
        //Document mergeTemplate=[Select Id,Body FROM Document where Id='015280000035aYr'];
        //SomeData = mergeTemplate.Body.toString();
        //DataToBePrinted.add(SomeData);
        for(Id oppId:memIds )
        {
            if(template.TemplateType == 'text')
            {
                Messaging.SingleEmailMessage mail =
                        Messaging.renderStoredEmailTemplate(SelectedTemplate, oppId, '');
                DataToBePrinted.add(mail.getPlainTextBody());
            }
            else if(template.TemplateType == 'html')
            {
                Messaging.SingleEmailMessage mail =
                        Messaging.renderStoredEmailTemplate(SelectedTemplate, oppId, '');
                DataToBePrinted.add(mail.getHtmlBody());
            }
            else if(template.TemplateType == 'visualforce')
            {
               Messaging.SingleEmailMessage mail =
                        Messaging.renderStoredEmailTemplate(SelectedTemplate, oppId, '');
                                                //Messaging.renderEmailTemplate(oppId, null , new String[] {template.Body});
                DataToBePrinted.add(mail.getHtmlBody());
            }
        }
        
        PageReference pg=new PageReference('/apex/PrintBulkEmailTemplate');
        pg.setRedirect(false);
        return pg;
    }
}