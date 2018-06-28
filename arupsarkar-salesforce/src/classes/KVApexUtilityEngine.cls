public with sharing class KVApexUtilityEngine
{
    //This variable will create or get the Apex Job Name as mentioned.
    public static final String APEXSCHEDULE = 'KV Apex Schedule';

    
    public static KVApexJobSchedule__c GetorCreateApexSchedule()
    {
        KVApexJobSchedule__c KVapexScheduler = getApexSchedule();
        
        System.debug('~~~~~~~~~~ Creating Apex Schedule Record ' + KVapexScheduler.Name + ' Cron Id : ' + KVapexScheduler.CronId__c);
                
        if(KVapexScheduler == null) // No custom setting record yet
        {
            KVapexScheduler = new KVApexJobSchedule__c(Name = APEXSCHEDULE);
            insert KVapexScheduler;
        }

        System.debug('~~~~~~~~~~ Created Apex Schedule Record ' + KVapexScheduler.Name + ', '+ KVapexScheduler.Id);
        
        return KVapexScheduler;    
    }
    
    
    public static KVApexJobSchedule__c getApexSchedule()
    {
        return KVApexJobSchedule__c.getInstance(APEXSCHEDULE);

    }    

    private static boolean CheckEmailCapacity(){
    
        if(System.Limits.getLimitEmailInvocations() - System.Limits.getEmailInvocations() > 0){
            return true;        
        }else{
            return false;
        }

    }
    public static void SendEmailToGoalOwner(String subject, String body, String email){
    
    
        try{
        
            if(CheckEmailCapacity()){
                System.debug('~~~~~~~~~ Subject : ' + subject);
                System.debug('~~~~~~~~~ body : ' + body);
                System.debug('~~~~~~~~~ To Address : ' + email);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {email}; 
        
                mail.setToAddresses(toAddresses);
                mail.setReplyTo(email);
            
                mail.setSenderDisplayName('Salesforce Goal setup support');
                mail.setSubject(subject);
                mail.setUseSignature(false);
                mail.setPlainTextBody(body);
                mail.setHtmlBody(body);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
                System.debug('~~~~~~~~~~ Success sending email to ' + email);
        

            }        


        }catch(Exception e){
            System.debug('~~~~~~~~~~ Error sending email : ' + e);

        }
        


    }


}