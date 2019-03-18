trigger Service_OnBeforeDelete on Service__c (Before Delete) {
   
   Map<Id, User> compassIntegration = new Map<Id, User>([Select Id, Name from User where Name = 'Compass Integration']);
   Datetime timeStamp = System.now();
   Datetime dateStamp = timeStamp.addHours(-5);
   String userId = UserInfo.getUserId();
   String userName = UserInfo.getFirstName() + UserInfo.getLastName();
   for(Service__c service : trigger.old){
       //check if the id does not match the compass Integration
       if(!compassIntegration.containsKey(userId)){
           //Send an email to salesforce@g
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String[] toAddresses = new String[] {'Salesforce@gadventures.com'}; 
           mail.setToAddresses(toAddresses);
           mail.setSenderDisplayName('Salesforce Support');
           mail.setSubject('Service getting Deleted by someone except Compass Integration!');
           mail.setPlainTextBody('This is the Service Id ('+ service.Id +'/'+ service.Service_ID_2__c +') getting deleted. Timestamp :'+dateStamp+' and User deleting the record is:'+ userName+'/'+UserId);
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
   }
}