public class sendInformation{
    public student__c std{get;set;}
    public String sid{get;set;}
        
        public sendInformation(){
            sid=apexpages.currentpage().getParameters().get('id');
            std=[select email_id__c from student__c where id=:sid];
        }
    
    
     public PageReference Send(){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE Name = 'sendInformation'];
        email.setTemplateId(et.Id);
        email.setToAddresses(new List<String>{'kuhinoor.zk@gmail.com'});
        email.setTargetObjectId([select id from Contact limit 1].id);
        email.setWhatId(sid);
        email.setSaveAsActivity(false);
        emails.add(email);
        
        Messaging.SendEmail(emails);
        return null;    
    }
}