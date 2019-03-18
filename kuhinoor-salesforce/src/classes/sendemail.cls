public class sendemail{
    public String emailid{get;set;}
    public String Subject{get;set;}
    public String body{get;set;}
    public PageReference send() {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject(Subject);
            email.setToAddresses(new List<String>{emailid});
           // email.setPlainTextBody('Testing Mail');
            email.setHtmlBody(body);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        
        return null;
    }
}