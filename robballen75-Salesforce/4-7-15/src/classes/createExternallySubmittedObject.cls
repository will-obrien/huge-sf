/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class createExternallySubmittedObject implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();


// Add the email plain text into the local variable
String userContent = '';
String userEmail='';
String objectType = '';
String product = '';
String emailBody = email.plainTextBody;
String groupID = '';
String contactID = '';

system.debug('body=' + email.plaintextbody);

try
{
	try{
	  userEmail = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<userEmail>')+11,email.plainTextBody.indexOfIgnoreCase('</userEmail>')).trim();
	}
	 catch (exception e)
	 {system.debug('exception parsing useremail');}
	  system.debug('userEmail=' + userEmail);
	 try{
	
	  objectType = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<objectType>')+12,email.plainTextBody.indexOfIgnoreCase('</objectType>')).trim();
	  }
	 catch (exception e)
	 {system.debug('exception parsing objectType');}
	  system.debug('objectType=' + objectType);
	  try{
	  userContent = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<userContent>')+13,email.plainTextBody.indexOfIgnoreCase('</userContent>')).trim();
	  }
	 catch (exception e)
	 {system.debug('exception parsing userContent');}
	  system.debug('userContent=' + userContent);
      
      try{
      product = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<product>')+9,email.plainTextBody.indexOfIgnoreCase('</product>')).trim();
      }
	 catch (exception e)
	 {system.debug('exception parsing product');}
      system.debug('product=' + product);
      
      if (userEmail == '')
      {
      	result.success = false;
      	return result;
      }
      
}
catch (System.StringException e)
{
 
handleErrorAndSendEmail('Unable to parse email.  Format problem?',emailBody);
}

// new Task object to be created

CASE[] newCase = new Case[0];

    // Try to lookup any contacts based on the email from address
    // If there is more than 1 contact with the same email address
    // an exception will be thrown and the catch statement will be called
try {
       Contact vCon = [Select Id, Name, Email
       From Contact  
    //   Where Email = :email.fromAddress
    Where Email = :userEmail
       Limit 1];
Contactid = vCon.id;
}
catch (exception e)
{
 handleErrorAndSendEmail('Unable to find contact by email address or duplicate contacts found.',emailBody);
 return result;

}

// Try to get the queue by group ID to assign the case.
Try {
		Group g=[Select Id from Group where name='TSC Case Queue'];
		GroupID = g.id;
}
catch (exception e)
{
 handleErrorAndSendEmail('Unable to find queue by name.',emailBody);
 return result;
}

// Add a new Case to the contact record we just found above
Try {

if (objectType == 'case') {
	system.debug('Creating a Case');
		
 		newCase.add(new Case(Status = 'Open',
     	Origin = 'Online Submission',
     	subject = 'Case submitted via online application',
     	Type = 'Product Support',
     	Case_Category__c = product,
     	description = userContent,
     	OwnerID= GroupID,
     	contactId = ContactID));

	// Insert the new Case and it will be created and appended to the contact record
     	insert newCase;
} else if (objectType == 'ER') {
	system.debug('Creating an ER');		
		
		
 		newCase.add(new Case(Status = 'Enhancement Request Entered',
     	Origin = 'Online Submission',
     	subject = 'Case submitted via online application',
     	Type = 'Product Support',
     	
     	Case_Category__c = product,
     	description = userContent,
     	Case_Resolution__c = 'ER entered.  See ER for more information.',
     	ContactId = ContactID));

	// Insert the new Case and it will be created and appended to the contact record
     	insert newCase;
		
	// Insert the new ER, tie to the case
		enhancement_request__c[] newER = new enhancement_request__c[0];
 		newER.add(new enhancement_request__c(ER_Status__c = 'Awaiting Review',
     	name = 'ER submitted via online application',
     	Origin__c = 'Online Submission',
     	Product__c = product,
     	Long_Description__c = userContent));
     	
     	insert newER;
     	
     	Enhancement_Request_Case_Connector__c ERCC = new Enhancement_Request_Case_Connector__c();
     	ERCC.Enhancement_Request__c = newER[0].id;
     	ERCC.Case__c = newCase[0].id;
     	   	 
     	insert ERCC;
     	   
}

     
System.debug('New Case Object: ' + newCase );
}
   // If there is an exception with creating the case or ER
   // this QueryException will be called.
   // and the exception will be written to the Apex Debug logs

   catch (System.QueryException e) {
     handleErrorAndSendEmail('Unable to Create contact or ER.',emailBody);
return result;
}

// Set the result to true, no need to send an email back to the user
// with an error message

  result.success = true;

  // Return the result for the Force.com Email Service
        return result;
    }
 
 
 
  public static void handleErrorAndSendEmail(String errorType, String emailBody) {
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
String[] toAddresses = new String[] {'support@microsystems.com'};
mail.setToAddresses(toAddresses);
mail.setReplyTo('support@microsystems.com');
mail.setSenderDisplayName('Web Submission User');
mail.setSubject('Error creating web submittied item' + errorType);
mail.setPlainTextBody('Check to see if this object was created successfully. Submitted data:' + emailBody);
mail.setHtmlBody('Check to see if this object was created successfully. <br> <br>  Submitted data: <br><br>' + emailBody);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
 
 
 
 
 }