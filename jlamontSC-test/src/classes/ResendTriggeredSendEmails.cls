/*
ResendTriggeredSendEmails

Created by: Mark Maslow
Created on: October, 2015

This class should be scheduled to run periodically. It finds any TriggeredSendEmail records
that have not been successfully sent and are marked to be resent.

If it finds any records, it enqueues a new instance of SendTriggeredEmails,
passing the records found.  
*/

global class ResendTriggeredSendEmails implements Schedulable {
	global void execute(SchedulableContext SC) {
		System.debug('Starting ResendTriggeredSendEmails.execute');
		
		Datetime minTime = System.now().addMinutes(-130);
		System.debug('minTime:' + minTime);
				
		List<TriggeredSendEmail__c> notSentList = [
			select
				Id
			from TriggeredSendEmail__c
			where 
				StatusCode__c != 202
			 	and CreatedDate < :minTime
		];
		
		if(Test.isRunningTest()) {
			sendErrorNotification('Testing sendErrorNotification');
		}
		if( ! notSentList.isEmpty()) {
			sendErrorNotification('Number of Triggered Send Emails waiting to be sent: ' + notSentList.size());
		}
		
		List<TriggeredSendEmail__c> emailList = [
			select
				Id,
				Message__c,
				RequestBody__c,
				SendId__c,
				StatusCode__c,
				TimeSent__c
			from TriggeredSendEmail__c
			where  
				Resend__c = true and StatusCode__c != 202
		];
		System.debug('emailList.size:' + emailList.size());
		
		if( ! emailList.isEmpty() ) {
			SendTriggeredSendEmails sender = new SendTriggeredSendEmails(emailList);
			Id jobId = System.enqueueJob(sender);
			System.debug('jobId:' + jobId);
		}
		/*
		// Re-schedule ourself to run again in 30 minutes
		DateTime now  = DateTime.now();
		DateTime nextRunTime = now.addMinutes(30);
		String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
			nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
			nextRunTime.month() + ' ? ' + nextRunTime.year(); 
		System.schedule('ResendTriggeredSendEmails' + '-' + now.format(), cronString, new ResendTriggeredSendEmails());
		// Abort the current job
		Id jobId = SC.getTriggerId();
		System.abortJob(jobId);
		*/     
	}
	private static void sendErrorNotification(String message) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'it-castiron-notifications-list@sierraclub.org'};
		mail.setToAddresses(toAddresses); 
		mail.setReplyTo('castiron@undefined.com');
		mail.setPlainTextBody(message);
		mail.setSubject('Triggered Send Emails Waiting to be Sent');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}