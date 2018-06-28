public  class emailSendController{
    public emailSendController(){
    }
        public void Emailsend(){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Salesforce Email Send Class');
            email.setToAddresses(new List<String>{'kuhinoor.sk@outlook.com'});
           // email.setPlainTextBody('Testing Mail');
            email.setHtmlBody('<b>Testing my email</b> Mail');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
       }
       
        public static void sendEmailAttachment(){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Salesforce Email Send Class');
            email.setToAddresses(new List<String>{'kuhinoor.sk@outlook.com'});
            email.setPlainTextBody('Testing Mail');
            //Attachment
            Messaging.EmailFileAttachment Attachment = new Messaging.EmailFileAttachment();
            Attachment.setBody(blob.valueOf('Testing Attachment'));
            Attachment.setFileName('test.txt');
            
            email.setFileAttachments(new List<Messaging.EmailFileAttachment>{Attachment}) ;
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        }
        
        public static void sendEmailTemplate(){
            EmailTemplate temp = new EmailTemplate();
            temp = [select id from EmailTemplate where developerName ='job_email'];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{'kuhinoor.sk@outlook.com'});
            email.setTemplateId(temp.id);
            // Account,Contact,Lead
            email.setTargetObjectId([select id from contact limit 1].id);
            // Except Account,Contact,Lead
            //email.setWhatId(stu.id);
            //email.setSaveAsActivity(false);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
    }       
        
}