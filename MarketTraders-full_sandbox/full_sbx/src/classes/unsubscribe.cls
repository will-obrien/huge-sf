Global class unsubscribe implements Messaging.inboundEmailHandler{

Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
							Messaging.InboundEnvelope env ) {

// Create an inboundEmailResult object for returning 
//the result of the Apex Email Service
Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
 
// Contact and Lead lists to hold all the updated records
List<Contact> lc = new List <contact>();
List<Lead> ll = new List <lead>();
 
// Convert the subject line to lower case, so I can match on lower case
String mySubject = email.subject.toLowerCase();
// String I am searching for in the subject line
String s = 'unsubscribe';
 
// Check variable to see if the word "unsubscribe" was found in the subject line 
Boolean unsubMe;
// Look for the unsubcribe word in the subject line, 
// if it is found return true, otherwise false is returned
unsubMe = mySubject.contains(s);
 
 // If unsubscribe is found in the subject line enter the if statement
 
 if (unsubMe == true) {
 	
 	try {
 		
 	// Lookup all contacts with a matching email address
 		
	 for (Contact c : [Select Id, Name, Email, HasOptedOutOfEmail
						From Contact
						Where Email = :env.fromAddress
						And hasOptedOutOfEmail = false
						Limit 100]) {
						
		// Add all the contacts into the List	
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
	 for (Lead l : [Select Id, Name, Email, HasOptedOutOfEmail
						From Lead
						Where Email = :env.fromAddress
						And isConverted = false
						And hasOptedOutOfEmail = false
						Limit 100]) {
		// Add all the leads to the List		
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

	System.debug('Found the unsubscribe word in the subject line.');
 } 
 else {
 	System.debug('No Unsuscribe word found in the subject line.' );
 }
// Return true and exit
// True will confirm it is complete and no bounced email 
// should be send the sender of the unsubscribe request. 
result.success = true;
return result;
	}	
	
	// Test method to ensure you have enough code coverage
	// Have created two methods, one that does the testing
	// with a valid "unsubcribe" in the subject line
	// and one the does not contain "unsubscribe" in the
	// subject line
	
static testMethod void testUnsubscribe() {

// Create a new email and envelope object
   Messaging.InboundEmail email = new Messaging.InboundEmail() ;
   Messaging.InboundEnvelope env 	= new Messaging.InboundEnvelope();

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
   
}