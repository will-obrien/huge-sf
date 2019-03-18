public class SendEmailController{
    public list<String> to{get;set;}
    public String subject{get;set;}
    public String body{get;set;}
    public string testing{get;set;}
    public void SendMailToStudent(){
        //list<String> emailsend=new list<String>();
        testing='called Function';
      //  system.debug('Subject='+subject);
      //  system.debug('Body='+body);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('ddd');
        email.setToAddresses(new List<String>{'kabir.mufiz49@gmail.com'});
        // email.setPlainTextBody('Testing Mail');
        email.setHtmlBody('dddd');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
    }
}