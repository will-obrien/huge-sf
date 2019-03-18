public with sharing class Logger {
	
	private list<map<DateTime,String>> log = new list<map<DateTime,String>>(); 
	private String subject {get;set;}
	
	public Logger(){
		this.subject = 'Logger Results';
	}
	
	public Logger(String subject){
		this.subject = subject;
	}
	
	public void emailDebugResults(list<String> toAddresses){
		try{
			if(!this.log.isEmpty()){
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			    mail.setToAddresses(toAddresses);
			    mail.setReplyTo('webdev@markettraders.com');
			    mail.setSenderDisplayName('Logger');
			    mail.setSubject(this.subject);
			    String body = 'Logger Results <br/>';
			    body += String.valueOf(DateTime.now()) + ' <br/>';
			    body += '<br/>-----------------------------------------<br/>';
			    body += 'LIMITS <br/>';
				body += 'Number of Queries: ' + String.valueOf(Limits.getQueries()) + '/' + String.valueOf(Limits.getLimitQueries()) + '<br/>';
				body += 'Number of Query Rows: ' + String.valueOf(Limits.getQueryRows()) + '/' + String.valueOf(Limits.getLimitQueryRows()) + '<br/>';
				body += 'Number of DML Statements: ' + String.valueOf(Limits.getDmlStatements()) + '/' + String.valueOf(Limits.getLimitDmlStatements()) + '<br/>';
				body += 'Number of DML Rows: ' + String.valueOf(Limits.getDmlRows()) + '/' + String.valueOf(Limits.getLimitDmlRows()) + '<br/>';
				body += 'Heap Size: ' + String.valueOf(Limits.getHeapSize()) + '/' + String.valueOf(Limits.getLimitHeapSize()) + '<br/>';
				body += 'Number of CPU Time: ' + String.valueOf(Limits.getCpuTime()) + '/' + String.valueOf(Limits.getLimitCpuTime()) + '<br/>';
				
				body += '<br/>-----------------------------------------<br/>';
			    body += 'Log <br/>';
			    for(Map<DateTime,String> logEntries : this.log){
			    	for(DateTime logEntryTime : logEntries.keySet()){
			    		body +=  String.valueOf(logEntryTime) + ': ' + logEntries.get(logEntryTime) + '<br/>';
			    	}
			    }
			    mail.setHtmlBody(body);
			    Messaging.reserveSingleEmailCapacity(toAddresses.size());
			    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			}
		}catch(Exception ex){
			system.debug(ex);
		}
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
    
    public void logCollectionResults(String collectionName, integer collectionSize){
   		map<DateTime,String> logEntry = new map<DateTime,String>();
    	logEntry.put(DateTime.now(),collectionName + ' returned ' + String.valueOf(collectionSize));
    	this.log.add(logEntry);
    }

}