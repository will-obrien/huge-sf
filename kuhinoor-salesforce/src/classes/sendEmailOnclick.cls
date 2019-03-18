Public class sendEmailOnclick{
    public String emailid{get;set;}
    public String Subject{get;set;}
    public String body{get;set;}
    
    public List<Contact> record{get;set;}
    Public List<Contact> senddata{get;set;}
    Public List<ModelClass> models{get;set;}
    public sendEmailOnclick(){
        models = new List<ModelClass>();
        record = [ select lastname,email from contact limit 10];
        for(Contact con : record){
           ModelClass md = new ModelClass();
               md.contacts = con;
               md.isCheck=false;
               models.add(md);
        }
        }
      public void sendmail(){
           senddata = new List<Contact>();
           for(ModelClass md  : models){
               if(md.ischeck==true){
                   senddata.add(md.contacts);
               }
           }
           
           for( contact c : senddata){
           
        EmailTemplate  templateId = [ select id from EmailTemplate where name = 'mytemplate']; 
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateID(templateId.Id);       
        mail.setSaveAsActivity(false); 
        mail.setTargetObjectId(c.id);
        mail.setToAddresses(new List<String>{c.email});
        allmsg.add(mail);
        
        Messaging.sendEmail(allmsg,false);
           /* Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Subject');
            email.setToAddresses(new List<String>{c.email});
           // email.setPlainTextBody('Testing Mail');
            email.setHtmlBody('this is body');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});  */      
        
           }
             
            System.debug('######################'+senddata);           
      }  
    
    public class ModelClass{
        Public Boolean isCheck{get;set;}
        Public Contact contacts{get;set;}
    }
}