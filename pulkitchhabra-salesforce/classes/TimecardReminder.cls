global class TimecardReminder implements Database.Batchable<sObject>{
   	List<User> EmailId = new List<User>();
    Map<Id, Decimal> UserLogHrs = new Map<Id, Decimal>();
    global Database.querylocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([Select Id, Name from User where isActive = True]);
    }
    global void execute(Database.BatchableContext BC, List<sObject> members){
        System.debug('+++++++++'+members.size()+'Members Size');
        //List<User> members = new List<User>([Select Id from User where isActive = True]);
        for(Timecard__c tc: [Select Entered_By__c, Hours_Logged__c from Timecard__c where Date_Delivered__c = YESTERDAY]){
            if(!UserLogHrs.containsKey(tc.Pulkit__Entered_By__c)){
                UserLogHrs.put(tc.Pulkit__Entered_By__c, tc.Pulkit__Hours_Logged__c);
            }
            else{
                Decimal hours = UserLogHrs.get(tc.Pulkit__Entered_By__c);
                hours = hours+tc.Pulkit__Hours_Logged__c;
                UserLogHrs.put(tc.Pulkit__Entered_By__c, hours);
            }

        }
        System.debug('+++++++++++After TC for loop++++++++++');
        for(User u : (List<user>)members){
            if((UserLogHrs.containsKey(u.Id) && UserLogHrs.get(u.Id)<8.00)||!UserLogHrs.containsKey(u.Id)|| UserLogHrs.size()== 0){
                    EmailId.add(u);
            }
                
		}
        System.debug('++++++++'+EmailId.size()+'Email Size');
        if(EmailId.size()>0){
            for(User us :EmailId){
                List<String> mailId = new List<String>();
                mailId.add(us.Id);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(mailId);
                mail.setReplyTo('pulkitforconam@gmail.com');
                mail.setSenderDisplayName('ConAm Technologies Pvt. Ltd.');
                mail.setSubject('Abe Timecard bharle nahi to salary nahi milegi.. smjha kya');
                String body1 = 'Priye karamcharee '+us.Name+'<br/><br/>';
                String body2 = 'Ku bekaar mein sunne waale kaam kar raha/rahi hai.. Bhar liya kr apna timecard.. Kintni bar smjhana padhega yr..';
                mail.setHtmlBody(body1+body2);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
    global void finish(Database.BatchableContext BC){
	}
}