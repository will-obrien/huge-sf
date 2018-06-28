public class SharedLoginQueueable implements Queueable, Database.AllowsCallouts {

	private List<ID> accts {get; set;}

	public SharedLoginQueueable(List<ID> accts)	{
 		this.accts = accts;
	}


	public void execute(QueueableContext context) {
    	List<Account> loginlist = [SELECT id, PersonEmail,FirstName, LastName, Country_List__c,Phone, PersonContactId,
                                        ForexTips_Username__c,Moodle_Start_Date__c, Moodle_Username_College__c, Sub_End_Ultimate_Charting_Pro_Forex__pc, Sub_End_Ultimate_Charting_Pro_Stocks__pc, 
    									UCS_User_Password__c, UCS_Username__c, PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c 
    								FROM Account Where id in : accts];
    								
        System.debug(LoggingLevel.ERROR,'@@@@ login list size: ' + loginlist.size()); 
      
      	List<id> sendemailaccts = new list<id>();
      	SharedLoginCallout  callout = new SharedLoginCallout();
      	set<Account> updateuser = new set<Account>();
      	Boolean err = false;
      	Logger logger = new Logger();
      	HTTPResponse response = new HTTPResponse();   
      	Map<String, SharedLoginInfo__c> endpointsmap = new Map<String, SharedLoginInfo__c>();
      	endpointsmap = SharedLoginInfo__c.getAll();    
      	
      	for (Account acct : loginlist) {
        	//UCS                 
            try {
            	if (!test.isRunningTest()) {
            		String ucsenpt = (String.isblank(endpointsmap.get('UCS').url__c)) ? 'http://dev.api.markettraders.com/app_dev.php/v1/ucsapp/users' : endpointsmap.get('UCS').url__c;
                    response = callout.sharedLoginEndpoint(ucsenpt, 'UCS', acct);                            
                    System.debug(LoggingLevel.ERROR,'@@@@ SharedLoginCallout:'+ response.getStatusCode() + ' response : ' + response.toString());
            	}
            	else {
            		response = new HttpResponse();
            		response.setStatusCode(200);
            	}
            	
            	if (response.getStatusCode() != 200) {
                    err = true;
                }
                else {
                	System.debug('@@@ not running test in shared login queueable...');
                	if (String.isblank(acct.UCS_Username__c) || String.isblank(acct.UCS_User_Password__c)) {
                        System.debug(LoggingLevel.ERROR,'@@@@ adding account with id ' + acct.Id + ' to email recipients');
                    	sendemailaccts.add(acct.id);
                    }
                    
                    acct.UCS_Username__c = acct.PersonEmail;
                    acct.UCS_User_Password__c = 'password1';            
                    updateuser.add(acct);
                }
            }
            catch(System.CalloutException e) {
                System.debug(LoggingLevel.ERROR,'@@@@ SharedLoginCallout : ERROR: Account:'+ account.id +' Callout error: '+ e);
                logger.log('ERROR: Shared Login Callout: Account:'+ account.id );
                logger.log(response.getBody());
                err = true;
            }            
		}
      	//send error log
    	if (err) { 
     		logger.log(context.getJobId());
     		logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});        
    	}
    	List<account> listofaccts = new list<account>();

    	listofaccts.addall(updateuser);
    	update listofaccts; 

    
    	List<Account> returnedacctlist = [SELECT id, PersonEmail, FirstName, LastName, Country_List__c, Phone, PersonContactId,
                                                ForexTips_Username__c, Moodle_Start_Date__c, Moodle_Username_College__c, Sub_End_Ultimate_Charting_Pro_Forex__pc, Sub_End_Ultimate_Charting_Pro_Stocks__pc, 
    											UCS_User_Password__c, UCS_Username__c, PB_SubEnd_UCSForex__c, PB_SubEnd_UCSStocks__c 
    										FROM Account 
    										WHERE id in : sendemailaccts]; 
      
    	//callout is limited to 5 accts at at time so email limits should not be hit
     	Boolean sendemail = (!Test.isRunningTest()) ? endpointsmap.get('UCS').Send_Email__c : true ;
     	if (sendemail) {
            System.debug(LoggingLevel.ERROR,'@@@@ preparing UCS credential email...');
         	Id templateId = (!Test.isRunningTest()) ? endpointsmap.get('UCS').Email_Template_Id__c : null;
         	Id orgWideEmailId = (!Test.isRunningTest()) ? endpointsmap.get('UCS').OrgWideEmailAddress__c : null ;
        	Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
         	for (Account account : returnedacctlist) {                      
              	//email message
              	Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
              	list<String> toRecipients = new List<String>();
              	toRecipients.add(account.PersonEmail);
              
                email.setToAddresses(toRecipients);
                email.setTargetObjectId(account.PersonContactId); //always set to an account
                email.setWhatId(account.id);
                email.setSaveAsActivity(true);  
                
                if (Test.isRunningTest()) {
                	List<OrgWideEmailAddress> owa = [select id, Address, DisplayName from OrgWideEmailAddress limit 1];
                    orgWideEmailId = owa[0].id;
                    List<EmailTemplate> et = [SELECT id, DeveloperName FROM EmailTemplate  limit 1];
                    templateId = et[0].id;
                }    
              
              	if(templateId != null && orgWideEmailId != null) {
                 	email.setorgWideEmailAddressId(orgWideEmailId);
                 	email.setTemplateId(templateId);
                 	messages.add(email);                          
              	}
              	else {
                    System.debug('@asha: @debug: SharedLoginCallout : Error - Email not sent TemplateId: '+templateId+' Org Wide Address: '+orgWideEmailId+' send email is: '+sendemail);
                    logger.log('ERROR: SharedLoginCallout : Error - Email not sent. Please check the fields in the Shared Login Custom Setting. TemplateId: '+templateId+' Org Wide Address: '+orgWideEmailId+' send email is '+sendemail);
                    logger.log(response.getBody());
                    err = true;
              	}    
        	}
        
            try {
            	if (messages.size() > 0) {
                    System.debug(LoggingLevel.ERROR,'@@@@ sending UCS credential email...');
                 	Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                 
                 	for (Messaging.SendEmailResult r :results) {
                      	if (!r.success) {
                            System.debug(LoggingLevel.ERROR,'@@@@ SharedLoginCallout : Error - Email not sent - message: '+ r.errors[0].message);
                         	logger.log('ERROR: SharedLoginCallout : Error - Email not sent '+ r.errors[0].message);
                         	err = true;  
                      	} 
                  	}   
                }  
            }
            catch (EmailException e) {                            
                System.debug(LoggingLevel.ERROR,'@@@@ SharedLoginCallout : Error - Email not sent '+ e.getMessage());
                logger.log('ERROR: SharedLoginCallout : Error - Email not sent '+ e.getMessage());
                err = true;               
            }
	   	}
   	}  
}