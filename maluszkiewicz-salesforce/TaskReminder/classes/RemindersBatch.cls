global class RemindersBatch implements Database.Batchable<sObject> {

    global final string privateRecordTypeId;
    global final string masterRecordTypeId;
    
    public RemindersBatch() { 
        List<RecordType> allRecordTypes = [SELECT Id, DeveloperName From RecordType WHERE DeveloperName='Private' OR DeveloperName='Master'];

        boolean flagPrivate = false, flagMaster = false;
        
        for(RecordType rt : allRecordTypes) {
            if(flagPrivate == true && flagMaster == true) {
                break;
            }

            if(rt.DeveloperName == 'Private') {
                privateRecordTypeId = rt.Id;
                flagPrivate = true;
            } else if(rt.DeveloperName == 'Master') {
                masterRecordTypeId = rt.Id;
                flagMaster = true;
            }
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, ActivityDate, OwnerId, Status, Subject, RecordTypeId FROM Task WHERE ActivityDate >= :Date.today() AND ActivityDate <= :Date.today().addDays(3)]);
    }

    global void execute(Database.BatchableContext BC, List<Task> allTasks) {
        List<Id> idList = new List<Id>();
    
        for(Task t : allTasks) {
            idList.add(t.OwnerId);
        }
    
        List<User> usersList = [SELECT Id, Email FROM User WHERE Id IN :idList];
        
        Map<Id,User> idUserMap = new Map<Id,User>();
        for(User u : usersList) {
            idUserMap.put(u.Id,u);
        }
        
        EmailHelper eh = new EmailHelper(UserInfo.getOrganizationName() + ': Task Reminder');
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
     
        for(Task t : allTasks) {
            if(t.RecordTypeId == privateRecordTypeId) {
                if(t.ActivityDate < Date.today()+1) {
                    mails.add(eh.newEmail(idUserMap.get(t.OwnerId).Email,t.OwnerId,t.ActivityDate,t.Status,t.OwnerId,t.Id));
                }
            } else if(t.RecordTypeId == masterRecordTypeId) {
                mails.add(eh.newEmail(idUserMap.get(t.OwnerId).Email,t.OwnerId,t.ActivityDate,t.Status,t.OwnerId,t.Id));
            }
        }

        Messaging.sendEmail(mails);
    }
    
    global void finish(Database.BatchableContext BC) {}
}