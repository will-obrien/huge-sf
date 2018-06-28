public with sharing class TriggeredSendEmailTriggerHandler {
	public static Boolean emailsSent = false;
	public static void afterInsert(List<TriggeredSendEmail__c> emailList) {
		if( ! emailsSent ) {
			SendTriggeredSendEmails sender = new SendTriggeredSendEmails(emailList);
			System.enqueueJob(sender);
			emailsSent = true;
		}
	}
}