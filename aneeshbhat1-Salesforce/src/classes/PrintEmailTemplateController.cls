public with sharing class PrintEmailTemplateController {
    public List<String> DataToBePrinted{get;set;}
    public PrintEmailTemplateController(){
        DataToBePrinted = new List<String>();
        Id selectedTemplateId = apexPages.currentPage().getParameters().get('templateId');
        Id whatId = apexPages.currentPage().getParameters().get('whatId');
        System.debug(selectedTemplateId);
        System.debug(whatId);
        Messaging.SingleEmailMessage email = 
                Messaging.renderStoredEmailTemplate(selectedTemplateId , '', whatId );
        DataToBePrinted.add(email.getPlainTextBody());
    }
}