@RestResource(urlMapping='/ContactUs/*')
global with sharing class RESTContactController {

@HttpPost
global static void sendContactUs(string fromAddress, string toContact, string msgBody){
        try{
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] ccAddresses = new String[] {'duane.robinson@garp.com'};
        if (toContact=='Membership'){
            String[] contactEmail = new String[] {'khalid.garner@garp.com'};
            mail.setToAddresses(contactEmail);
        }
        if (toContact=='Exams'){
            String[] contactEmail = new String[] {'khalid.garner@garp.com'};
            mail.setToAddresses(contactEmail);
        }
        if (toContact=='CPD'){
            String[] contactEmail = new String[] {'khalid.garner@garp.com'};
            mail.setToAddresses(contactEmail);
        }
        if (toContact=='Marketing'){
            String[] contactEmail = new String[] {'khalid.garner@garp.com'};
            mail.setToAddresses(contactEmail);
        }
        if (toContact=='General'){
            String[] contactEmail = new String[] {'khalid.garner@garp.com'};
            mail.setToAddresses(contactEmail);
        }
        
        mail.setCcAddresses(ccAddresses);
        mail.setReplyTo('support@garp.com');
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('From Contact Us on Website');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(msgBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception e){
        	
        }
    }
}