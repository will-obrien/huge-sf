global with sharing class SyncLogger {

    @TestVisible private list<map<DateTime,String>> log = new list<map<DateTime,String>>(); 
    @TestVisible private String subject {get;set;}
  
    public SyncLogger (String subject){
        this.subject = subject;
    }
    
    public void log(String message){
        map<DateTime,String> logEntry = new map<DateTime,String>();
        logEntry.put(DateTime.now(),message);
        this.log.add(logEntry);
    }
    
    public void log(Object objectToLog){
        map<DateTime,String> logEntry = new map<DateTime,String>();
        logEntry.put(DateTime.now(),json.serialize(objectToLog));
        this.log.add(logEntry);
    }
  
    public void emailDebugResults(String email,boolean includeLimits){
        try{
            if(!this.log.isEmpty()){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new list<String>{email});
                mail.setReplyTo(email);
                mail.setSenderDisplayName('Logger');
                mail.setSubject(this.subject);
                String body = 'Logger Results <br/>';
                body += String.valueOf(DateTime.now()) + ' <br/>';
                if(includeLimits)
                    body += this.getLimits();
                body += 'Log <br/>';
                for(Map<DateTime,String> logEntries : this.log){
                    for(DateTime logEntryTime : logEntries.keySet()){
                        body +=  String.valueOf(logEntryTime) + ': ' + logEntries.get(logEntryTime) + '<br/>';
                    }
                }
                mail.setHtmlBody(body);
                Messaging.reserveSingleEmailCapacity(1);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }catch(Exception ex){
            system.debug(ex);
        }
    }
    
    public String getLimits() {
        String body = '<br/>-----------------------------------------<br/>';
        body += 'LIMITS <br/>';
        body += 'Number of Queries: ' + String.valueOf(Limits.getQueries()) + '/' + String.valueOf(Limits.getLimitQueries()) + '<br/>';
        body += 'Number of Query Rows: ' + String.valueOf(Limits.getQueryRows()) + '/' + String.valueOf(Limits.getLimitQueryRows()) + '<br/>';
        body += 'Number of DML Statements: ' + String.valueOf(Limits.getDmlStatements()) + '/' + String.valueOf(Limits.getLimitDmlStatements()) + '<br/>';
        body += 'Number of DML Rows: ' + String.valueOf(Limits.getDmlRows()) + '/' + String.valueOf(Limits.getLimitDmlRows()) + '<br/>';
        body += 'Heap Size: ' + String.valueOf(Limits.getHeapSize()) + '/' + String.valueOf(Limits.getLimitHeapSize()) + '<br/>';
        body += 'Number of CPU Time: ' + String.valueOf(Limits.getCpuTime()) + '/' + String.valueOf(Limits.getLimitCpuTime()) + '<br/>';
        body += '<br/>-----------------------------------------<br/>';
        return body;
    }

}