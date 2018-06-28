global class LeadMerger implements Database.Batchable<sObject>,Database.Stateful{
    
    global final String Query;
    global map<Id,Lead> dupeMap;
    global set<Id> leadIds;
    
    global LeadMerger(map<Id,Lead> dupeMap) {
        this.dupeMap = dupeMap;
        this.leadIds = this.dupeMap.keySet();
        set<String> requiredFields = new set<String>{'Id','Email','Alternate_Email__c'};
        list<Lead_Merger__c> leadMergerSettings = Lead_Merger__c.getall().values();
        String SOQL = 'SELECT ';
        for(String requiredField : requiredFields){
            SOQL += requiredField + ',';  
        }
        for (Lead_Merger__c mergerSetting : leadMergerSettings){
            if(!requiredFields.contains(mergerSetting.Field_Name__c))
                SOQL += mergerSetting.Field_Name__c + ',';  
        } 
        SOQL = SOQL.substring(0,SOQL.length()-1);
        SOQL += ' FROM Lead';
        SOQL += ' WHERE Id IN :leadIds';
        this.Query = SOQL;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Lead> duplicateLeads) {
        for(Lead duplicateLead : duplicateLeads){
            Lead masterLead = dupeMap.get(duplicateLead.Id);
            LeadMerger.mergeLead(duplicateLead,masterLead);
        }
    }

    global void finish(Database.BatchableContext BC) {
   
    }
    
    /**
    *   @author Jim Hutcherson
    *   @description Merges a newer lead in the oldest existing. 
    *
    **/
    public static void mergeLead(Lead duplicateLead,Lead masterLead) {
        try{    
            if((masterLead != null && duplicateLead != null && duplicateLead.Id != masterLead.Id) || test.isRunningTest()){
                list<MergeHistory> duplicateHistory = new list<MergeHistory>();
                for(LeadHistory history : [SELECT Id,NewValue,OldValue,LeadId,Field,CreatedDate FROM LeadHistory WHERE LeadId = :duplicateLead.Id ORDER BY CreatedDate DESC limit 50000]){
                    MergeHistory mergeHistory = new MergeHistory(history.CreatedDate.format('MM/dd/yyyy HH:mm:ss'),history.Field,String.valueOf(history.NewValue),String.valueOf(history.OldValue));
                    duplicateHistory.add(mergeHistory); 
                }
                map<Id,Lead> leadstoMergeMap = new map<Id,Lead>([SELECT id FROM Lead WHERE (Id = :masterLead.Id OR Id = :duplicateLead.Id) AND IsDeleted != true]);
                Lead mLead = leadstoMergeMap.get(masterLead.Id);
                Lead dLead = leadstoMergeMap.get(duplicateLead.Id);
                if(mLead != null && dLead != null){
                    Database.MergeResult result = Database.merge(mLead,dLead,true);
                    if(result.isSuccess()){
                        Attachment duplicateAttachment = new Attachment();
                        duplicateAttachment.ContentType = '.json';
                        duplicateAttachment.Description = 'This document contains the values of a merged lead';
                        duplicateAttachment.Name = 'Merged Lead: ' +  DateTime.now();
                        duplicateAttachment.ParentId = masterLead.id;
                        duplicateAttachment.body = Blob.valueOf(JSON.serialize(duplicateLead));
                        Database.insert(duplicateAttachment);
                        
                        if(!duplicateHistory.isEmpty()){
                            Attachment duplicateHistoryAttachment = new Attachment();
                            duplicateHistoryAttachment.ContentType = '.json';
                            duplicateHistoryAttachment.Description = 'This document contains the history of a merged Lead';
                            duplicateHistoryAttachment.Name = 'Merged Lead History:' + duplicateAttachment.Id;
                            duplicateHistoryAttachment.ParentId = masterLead.id;
                            duplicateHistoryAttachment.body = Blob.valueOf(JSON.serialize(duplicateHistory));
                            Database.insert(duplicateHistoryAttachment);
                        }
                        LeadMerger.sendResults(masterLead);
                    }
                }   
            }
        }catch(Exception ex){
            Logger logger = new Logger('CRITICAL ERROR: LeadMerger');
            if(duplicateLead != null)
                logger.log('Duplicate Id: ' + duplicateLead.Id);
            if(masterLead != null)
                logger.log('Master Id: ' + masterLead.Id);
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            if(Limits.getEmailInvocations() < Limits.getLimitEmailInvocations())
                logger.emailDebugResults(new list<String>{'webdev@markettraders.com'});
            system.debug(ex);
        }
    }
    
    private static void sendResults(Lead winningLead){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new list<String>{UserInfo.getUserEmail()});
            mail.setReplyTo('webdev@markettraders.com');
            mail.setSenderDisplayName('MTI Lead Merger');
            mail.setSubject('Lead Auto-Merged - ' + winningLead.FirstName + ' ' + winningLead.LastName);
            
            String body = 'A Lead has been auto-merged! <br/>';
            body += '<br/>';
            body += 'User causing the merge: ' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
            body += '<br/>';
            body += '<br/>';
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + winningLead.Id;
            body += 'Merged Lead: ' + '<a href="'+fullRecordURL+'">Click to see winning lead</a>';
            body += '<br/>';
            body += 'Name: ' + winningLead.FirstName + ' ' + winningLead.LastName;
            body += '<br/>';
            body += 'Primary Email: ' + winningLead.Email;
            body += '<br/>';
            body += 'Alternate Email: ' + winningLead.Alternate_Email__c;
            body += '<br/>';
            body += '<br/>';
            body += 'Merge happened at: ' + String.valueOf(DateTime.now());

            mail.setHtmlBody(body);
            
            Messaging.reserveSingleEmailCapacity(2);
            if(Limits.getEmailInvocations() < Limits.getLimitEmailInvocations())
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception ex){
            system.debug(ex);
            Logger logger = new Logger('CRITICAL ERROR: ');
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            if(Limits.getEmailInvocations() < Limits.getLimitEmailInvocations())
                logger.emailDebugResults(new list<String>{'webdev@markettraders.com'});
            system.debug(ex);
        }
    }

}