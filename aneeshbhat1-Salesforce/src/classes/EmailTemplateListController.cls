public with sharing class EmailTemplateListController {
    public Id oppId{get;set;}
    public List<EmailTemplate> Templates { get; set; }    
    public List<String> DataToBePrinted{get;set;}
    public string Data{get;set;}
    public String SelectedTemplate{get;set;}
    
    public string FormTag{get;set;}

    public string TextBox{get;set;}

    public EmailTemplateListController(ApexPages.StandardController controller) {
        try
        {
            oppId = controller.getId();
            Templates=new List<EmailTemplate>();
            Templates=[Select Id,Name FROM EmailTemplate];
        }
        catch(Exception ex)
        {
        }
    }


    public PageReference PrintSelectedTemplate() {
        DataToBePrinted = new List<String>();
       
        EmailTemplate template=[SELECT Id, Body,HtmlValue FROM EmailTemplate WHERE Id=:SelectedTemplate][0];
        List<Messaging.RenderEmailTemplateBodyResult> renderedMail=
            Messaging.renderEmailTemplate(oppId, null , new String[] {template.Body});
        DataToBePrinted.add(renderedMail[0].getMergedBody());
        PageReference pg=new PageReference('/apex/PrintEmailTemplate');
        pg.setRedirect(false);
        return pg;
    }
    
    private void LoadTemplate(){
        
         //Data = email.getPlainTextBody();
    }
}