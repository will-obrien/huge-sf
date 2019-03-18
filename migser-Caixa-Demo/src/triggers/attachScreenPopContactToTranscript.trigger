trigger attachScreenPopContactToTranscript on LiveChatTranscript (before insert) {
    //this trigger will attach the contact that is screen popped in the live agent chat window in the Service Cloud Console to the related LiveChatTranscript text
    
    
    try{
        list<LiveChatTranscript> lctList = new List<LiveChatTranscript>();
        Contact c = [Select id From Contact Where ActiveLiveAgentUser__c = true limit 1];
        
        for (LiveChatTranscript lct : trigger.new){
            
            lct.ContactId = c.id;
            lctList.add(lct);
        }
    }
    
    catch (Exception e){
            String subjectText = '';
            String bodyText = 'The field ActiveLiveAgentUser__c needs to be set to true on the contact record that you wish to attach to the LiveChatTranscript record in the Service Cloud Console Live Agent Chat window.' + e.getMessage() +
                '\n\nStacktrace: ' + e.getStacktraceString();

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] { Site.getAdminEmail() };

            mail.setReplyTo('no-reply@salesforce.com');
            mail.setSenderDisplayName('Salesforce Live Agent Contact');

            mail.setToAddresses(toAddresses);
            mail.setSubject(subjectText);
            mail.setPlainTextBody(bodyText);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}