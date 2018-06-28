Global class unsubscribe implements Messaging.inboundEmailHandler{

Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env) {
	// Create an inboundEmailResult object for returning the result of the Apex Email Service
	Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
	// Contact and Lead lists to hold all the updated records
	List<Contact> lc = new List <contact>();
	List<Lead> ll = new List <lead>();	
	// Convert the subject line to lower case, so I can match on lower case
	String mySubject = email.subject.toLowerCase();
	String s = 'unsubscribe';
	String s2 = 'se desabonner';
	Boolean unsubMe = mySubject.contains(s) || mySubject.contains(s2);
	try {
		// If unsubscribe is found in the subject line enter the if statement
		if (unsubMe == true) {		
			try {
				// Lookup all contacts with a matching email address
				for (Contact c : [Select Id, Name, Email, HasOptedOutOfEmail From Contact 
								Where Email = :env.fromAddress And hasOptedOutOfEmail = false Limit 100]) {
					c.hasOptedOutOfEmail = true;
					lc.add(c);
					}
					// update all the Contact records
					update lc;
 			}
	 		catch (System.QueryException e) {
	 			System.debug('Contact Query Issue: ' + e);
	 		}
	 		
	 		try {
	 			// Lookup all leads matching the email address
	 			for (Lead l : [Select Id, Name, Email, HasOptedOutOfEmail From Lead
								Where Email = :env.fromAddress And isConverted = false And hasOptedOutOfEmail = false Limit 100]) {
					l.hasOptedOutOfEmail = true;
					ll.add(l);
					System.debug('Lead Object: ' + l);
					}	 
					// Update all Lead records in the query
					update ll;
	 		}
	 		catch (System.QueryException e) {
	 			System.debug('Lead Query Issue: ' + e);
	 		}
	 		
//			sendEmail(email);
			
	 		System.debug('Found the unsubscribe word in the subject line.');
		}
	 	else {
	 		System.debug('No Unsuscribe word found in the subject line.' );
	 	}
		// Return true and exit
		// True will confirm it is complete and no bounced email 
		// should be send the sender of the unsubscribe request. 
		result.success = true;
	}
 	catch (Exception ex) {
 		System.debug(ex);
 		PGIErrorUtilities.logPgiError('unsubscribe:handleInboundEmail()', ex.getMessage(), PGIErrorUtilities.LoggingLevel.DEBUG);
 	}
	return result;
}
	
/*static void sendEmail(Messaging.InboundEmail email) {
    String orgWideEmail = [SELECT OrgWideEmailAddress__c FROM OrgWideEmailId__c WHERE Name = 'BISupport'].OrgWideEmailAddress__c;
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	//mail.setReplyTo(email.fromAddress); //Doesn't work
	//mail.setSenderDisplayName(email.fromName);
	mail.setOrgWideEmailAddressId(orgWideEmail);
	mail.setSubject(email.subject);
	mail.setToAddresses(new string[]{'matt.santy@pgi.com','carmen.wong@pgi.com', 'caunsubscribe@pgi.com'});
	string senderDetails = 'Name: [' + email.fromName + ']  Email: [' + email.fromAddress + ']';
	mail.setPlainTextBody(senderDetails + email.plainTextBody);
	mail.setHtmlBody(senderDetails + email.htmlBody);
	//mail.setFileAttachments(getFileAttachments(email));
	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}*/

/*static List<Messaging.EmailFileAttachment> getFileAttachments(Messaging.InboundEmail email){
	List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
	if (email.binaryAttachments != null && email.binaryAttachments.size()>0){
		for (Messaging.InboundEmail.BinaryAttachment a : email.binaryAttachments){
			Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
			attachment.setFileName(a.fileName);
			attachment.setBody(a.body);
			//attachment.setContentType(a.mimeTypeSubType);
			attachmentList.add(attachment);
		}
    }
    if (email.textAttachments != null && email.textAttachments.size()>0)
    {
    	for (Messaging.InboundEmail.TextAttachment a : email.textAttachments){
    		Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
    		attachment.setFileName(a.fileName);
    		attachment.setBody(Blob.valueOf(a.body));
    		//attachment.setContentType(a.mimeTypeSubType);
    		attachmentList.add(attachment);
    	}
    }
    return attachmentList;
}*/
    
	// Test method to ensure you have enough code coverage
	// Have created two methods, one that does the testing
	// with a valid "unsubcribe" in the subject line
	// and one the does not contain "unsubscribe" in the
	// subject line
	
static testMethod void testUnsubscribe() {

// Create a new email and envelope object
   Messaging.InboundEmail email = new Messaging.InboundEmail() ;
   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

// Create a new test Lead and insert it in the Test Method        
   Lead l = new lead(firstName='Rasmus', 
   			lastName='Mencke',
   			Company='Salesforce', 
   			Email='rmencke@salesforce.com', 
   			HasOptedOutOfEmail=false);
   insert l;

// Create a new test Contact and insert it in the Test Method  
   Contact c = new Contact(firstName='Rasmus', 
   				lastName='Mencke', 
   				Email='rmencke@salesforce.com', 
   				HasOptedOutOfEmail=false);
   insert c;
   
   // test with subject that matches the unsubscribe statement
   email.subject = 'test unsubscribe test';
   env.fromAddress = 'rmencke@salesforce.com';
   
   // call the class and test it with the data in the testMethod
   unsubscribe unsubscribeObj = new unsubscribe();
   unsubscribeObj.handleInboundEmail(email, env );
						
   }
 
static testMethod void testUnsubscribe2() {

// Create a new email and envelope object
   Messaging.InboundEmail email = new Messaging.InboundEmail();
   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

// Create a new test Lead and insert it in the Test Method        
   Lead l = new lead(firstName='Rasmus', 
   			lastName='Mencke',
   			Company='Salesforce', 
   			Email='rmencke@salesforce.com', 
   			HasOptedOutOfEmail=false);
   insert l;

// Create a new test Contact and insert it in the Test Method    
   Contact c = new Contact(firstName='Rasmus', 
   				lastName='Mencke', 
   				Email='rmencke@salesforce.com', 
   				HasOptedOutOfEmail=false);
   insert c;
   
   // Test with a subject that does Not contain unsubscribe
   email.subject = 'test';
   env.fromAddress = 'rmencke@salesforce.com';

   // call the class and test it with the data in the testMethod
   unsubscribe unsubscribeObj = new unsubscribe();
   unsubscribeObj.handleInboundEmail(email, env );						
   }   
   
static testMethod void testUnsubscribe3() {

// Create a new email and envelope object
   Messaging.InboundEmail email = new Messaging.InboundEmail();
   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

// Create a new test Lead and insert it in the Test Method        
   Lead l = new lead(firstName='Rasmus', 
   			lastName='Mencke',
   			Company='Salesforce', 
   			Email='rmencke@salesforce.com', 
   			HasOptedOutOfEmail=false);
   insert l;
    
// Create a new test Contact and insert it in the Test Method    
   Contact c = new Contact(firstName='Rasmus', 
   				lastName='Mencke', 
   				Email='rmencke@salesforce.com', 
   				HasOptedOutOfEmail=false);
   insert c;
   
   // Test with a subject that does Not contain unsubscribe
   email.subject = 'test se debonner test';
   email.fromAddress = 'rmencke@salesforce.com';
   env.fromAddress = 'rmencke@salesforce.com';
   
   /*Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
   attachment.body = blob.valueOf('test body');
   attachment.fileName = 'test fileName';
   attachment.mimeTypeSubtype = 'plain/txt';
   email.binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[]{attachment};
   Messaging.InboundEmail.TextAttachment attachment2 = new Messaging.InboundEmail.TextAttachment();
   attachment2.body = 'test body';
   attachment2.fileName = 'test fileName';
   attachment2.mimeTypeSubtype = 'plain/txt';
   email.textAttachments = new Messaging.InboundEmail.TextAttachment[]{attachment2};*/

   // call the class and test it with the data in the testMethod
   unsubscribe unsubscribeObj = new unsubscribe();
   unsubscribeObj.handleInboundEmail(email, env);						
   }    
   
}