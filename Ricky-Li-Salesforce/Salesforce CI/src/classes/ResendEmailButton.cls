public class ResendEmailButton {
    public boolean reloadNeeded{get;set;}
    public String pageURL {set;}
    
    private final Tour_evaluation_Historical_Summary__c tehsa;
    private ApexPages.StandardController tehsController {get;set;}
    Tour_Evaluation_Historical_Summary__c tehs;
    Tour_Evaluation_Historical_Summary__c tehs_TE;
    Tour_Evaluation__c te;
    String tehsId;
    Account accountName;
    Service__c serviceName;
    
    public ResendEmailButton(ApexPages.StandardController controller) {
       tehs = [SELECT id FROM Tour_Evaluation_Historical_Summary__c
              WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];     
       
       tehsId = tehs.Id;
       system.debug('tehsId: ' + tehsId);
       tehs_TE = [Select Tour_Evaluation__c, Date_Sent__c, Status__c, Agency_Name__c, Clicktools_Url__c from Tour_Evaluation_Historical_Summary__c where Id =: tehsId];      
       te = [Select Account__c, Service__c from Tour_Evaluation__c where Id =: tehs_TE.Tour_Evaluation__c];    
       accountName = [Select FirstName, Evaluation_Email__c from Account where Id = : te.Account__c];
       serviceName = [Select Name from Service__c where Id = : te.Service__c]; 
       tehsController = controller;
       this.tehsa = (Tour_Evaluation_Historical_Summary__c) controller.getRecord();             
    }

    public String ResendEmail() {  
     if(accountName.Evaluation_Email__c != null){
      List<ContactName__c> listContactNameAndTourEvalId = [Select Name, tourEvalId__c, tourName__c from ContactName__c where TestId__c = 'abc'];  
      listContactNameAndTourEvalId[0].Name__c = accountName.FirstName;
      listContactNameAndTourEvalId[0].tourEvalId__c = tehs_TE.Tour_Evaluation__c; 
      listContactNameandTourEvalId[0].tourName__c = serviceName.Name; 
      update listContactNameAndTourEvalId;
     
      Boolean isWhiteLabelSTA;
      String agencyName = tehs_TE.Agency_Name__c;
      String strSenderName;
      String strTemplate;
      List <OrgWideEmailAddress> listOrgWideEmail = new List <OrgWideEmailAddress> ();
      // Add other agencies below here when adding more whitelabels
      if(agencyName.startsWith('STA ')){
          isWhiteLabelSTA = true;
          strSenderName = 'STA Travels';
          strTemplate = 'OutboundEmail7DaysSTA';
      }
      else {
          isWhiteLabelSTA = false;
          strSenderName = 'G Adventures';
          strTemplate = 'Outbound Email PTE 7 days';
      }
      List <EmailTemplate> listTemplateId = [Select Id from EmailTemplate where Name =: strTemplate];
      Id TemplateId = listTemplateId[0].Id;
      //This list will determine the From Name and From Email Address
      listOrgWideEmail = [SELECT Id FROM OrgWideEmailAddress where DisplayName =: strSenderName];
     
     /*
      * Add a validation that if the click tools URL is empty do nothing; updates the error to 
      */
      
     String ClicktoolsUrl = tehs_TE.Clicktools_Url__c;
      if(ClicktoolsUrl != null){  
         List <Contact> contact = [Select Id from Contact where AccountId =: te.Account__c];  
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         mail.setOrgWideEmailAddressId(listOrgWideEmail[0].Id); 
         //fetch the templateId from the Templates
         mail.setTemplateId(templateId);
         mail.setTargetObjectId(contact[0].Id);
         
         List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         String errorMessage;
           if (!results.get(0).isSuccess()) {
               System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
               errorMessage = results.get(0).getErrors()[0].getMessage();
           }
           //if there is any error, update the tehs_TE
           if (!results.get(0).isSuccess()) {
               System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
               errorMessage = results.get(0).getErrors()[0].getMessage();
           }
           //if there is any error, update the objTEHSMain
           if(errorMessage != null){
             tehs_TE.Error__c = errorMessage;  
           }
           else{
               tehs_TE.Error__c = '';
               Datetime currentDateTime = datetime.now();
               System.Debug(currentDateTime);
               String convertedDate = currentDateTime.format('yyyy-MM-dd hh:mm:ss a');
               System.Debug(convertedDate);
               tehs_TE.Date_Sent__c = convertedDate;
               tehs_TE.Status__c = 'Sent using the resend button';
               tehs_TE.Resent_By__c = UserInfo.getName();
               System.Debug(UserInfo.getName());
           }                      
           update tehs_TE;
        }
     }     
        reloadNeeded = true;
        System.Debug(tehsController.view().getUrl());
        return null;
   } 
   
   public String getPageURL(){
       System.Debug('Hi');
       PageReference redirectURL = tehsController.view();
       return redirectURL.getUrl();
   }
}