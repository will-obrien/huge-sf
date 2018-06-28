public class EmailsendMsgController{
    public String to{get;set;}
    public String subject{get;set;}
    public String body{get;set;}
    public EmailsendMsgController(){
    
    }
    public void SendMailToStudent(){
         //list<String> emailsend=new list<String>();
          subject='called Function';
          system.debug('Subject='+subject);
          system.debug('Body='+body);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('subject');
           email.setToAddresses(new List<String>{'kuhinoor.sk@outlook.com'});
           // email.setPlainTextBody('Testing Mail');
            email.setHtmlBody('body');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
    }
}