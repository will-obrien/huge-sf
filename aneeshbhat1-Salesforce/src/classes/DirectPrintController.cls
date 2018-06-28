public with sharing class DirectPrintController {
  public List<String> DataToBePrinted{get;set;}
   public Id oppId{get;set;}
   Public Opportunity SelectedOpp{get;set;}

    public DirectPrintController(ApexPages.StandardController controller) {
   
          oppId = controller.getId();
          SelectedOpp=[Select Id,Template_ID__c FROM Opportunity where Id=:oppId ];
          if(SelectedOpp.Template_ID__c==''  || SelectedOpp.Template_ID__c== null)
          {
              //ApexPages.addMessage(﻿ new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Assign A template A Print')﻿);
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Assign A template to Print');
              ApexPages.addMessage(myMsg);
          }
        else
        {
             EmailTemplate template=[SELECT Id, Body,HtmlValue,Name FROM EmailTemplate WHERE Id=:SelectedOpp.Template_ID__c];
             system.debug(' Template Name '+template.Name+ ' Email Template Id '+template.Id);
            PrintSelectedTemplate(template);
         
        }
         
         
        

    }
    
     public void PrintSelectedTemplate(EmailTemplate template) {
     if(SelectedOpp.Template_ID__c=='' || template== null)
          {
              //ApexPages.addMessage(﻿ new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Assign A template A Print')﻿);
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Assign A template A Print');
              ApexPages.addMessage(myMsg);
          }
          else
          {
           DataToBePrinted = new List<String>();
        List<Messaging.RenderEmailTemplateBodyResult> renderedMail=
            Messaging.renderEmailTemplate(oppId, null , new String[] {template.Body});
        DataToBePrinted.add(renderedMail[0].getMergedBody());
          }
       
    }

}