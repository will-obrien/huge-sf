public class sendemailTemplate{
    public sendemailTemplate()
    {
    }
    
    public void send(){
        EmailTemplate  templateId = [ select id from EmailTemplate where name = 'mytemplate']; 
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateID(templateId.Id);       
        mail.setSaveAsActivity(false); 
        mail.setTargetObjectId([select id from Contact limit 1].id);
        mail.setToAddresses(new List<String>{'kuhinoor.zk@gmail.com'});
        allmsg.add(mail);
        
        Messaging.sendEmail(allmsg,false);
    }
}