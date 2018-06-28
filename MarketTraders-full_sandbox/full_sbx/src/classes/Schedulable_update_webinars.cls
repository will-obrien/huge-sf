global class Schedulable_update_webinars implements Schedulable {
      global void execute(SchedulableContext SC) {
           list<Webinar_Credentials__c> credentials = new list<Webinar_Credentials__c >([SELECT Token__c,Org_ID__c,Provider__c,Credentials_ID__c,Mnemonic__c FROM Webinar_Credentials__c]);
               if(!credentials.isEmpty())
                   {
                   for(Webinar_Credentials__c credential : credentials){ 
                       if(!Test.isRunningTest())
                       {
                           Update_Webinars_Helper.updateWebinar(credential.Id);
                       }          
                   } 
               }
         }
}