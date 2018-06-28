Public class ComponentController_OutboundEmailPTE{

     private String tourEvalId;
     private String Contact;
     private String FullURL;
     private String tourName;
     
     Tour_Evaluation_Historical_Summary__c tehs;
     
     public String getContact () {
         //Contact = 'Subodh';
         List <ContactName__c> listContactName = ContactName__c.getAll().values();
         if(listContactName[0].Name == 'Test1'){
              Contact = listContactName[0].Name__c;
        } 
        return Contact; 
     }
    
     public String getTourName() {
            List <ContactName__c> listContactName = ContactName__c.getAll().values();
             if(listContactName[0].Name == 'Test1'){
              tourName = listContactName[0].tourName__c;
            }
            
            if(tourName == null){
                return 'abc';
            } 
            else
          return tourName;
     }

     public String getFullURL() {
         List <ContactName__c> listContactName = ContactName__c.getAll().values();
         if(listContactName[0].Name == 'Test1'){
           tourEvalId = listContactName[0].tourEvalId__c;
                 if(tourEvalId != null){
                     tehs = [Select Clicktools_Url__c from Tour_Evaluation_Historical_Summary__c where Tour_Evaluation__c = :tourEvalId];
                     FullURL = tehs.Clicktools_Url__c;
                 }
          }
            return FullURL;
     }
}