/* Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class MS_CloudServiceActions_v2 implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)
     {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

       // Set up working variables 
Boolean didItWork = false;
String firstName = '';
String lastName = '';
String action = '';
String accountName = '';
String userEmail='';
String product = '';
String SFAccountID = '';
String emailBody = email.plainTextBody;
string emailDomain = '';
string domainBody = '';
string leadSource = '';
string emailOptOut = '';
string MSSecureContactID = '';
String MSSubscriptionID = '';
String ContractType = '';
String userPhone = '';
String billingAmount = '0';
String subscriptionExpirationDate = '';
String userCount = '0';
String promoCode = '';
String year1Billing = '';
String year2Billing = '';
String year3Billing = '';
String year4Billing = '';
String downloadFileName = '';
String downloadDateTime = '';
String productFeatures = '';
String promoDiscount = '';
String referralCode = '';
String packageName = '';
String transactionID = '';

	//Try to parse the email for all the data parts we need
			try
	  		{
	  		transactionID = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<transactionID>')+15,email.plainTextBody.indexOfIgnoreCase('</transactionID>')).trim();
	  		system.debug('transactionID=' + transactionID);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing packageName');}
			
			try
	  		{
	  		packageName = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<packageName>')+13,email.plainTextBody.indexOfIgnoreCase('</packageName>')).trim();
	  		system.debug('packageName=' + packageName);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing packageName');}
			try
	  		{
	  		promoDiscount = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<promoDiscount>')+15,email.plainTextBody.indexOfIgnoreCase('</promoDiscount>')).trim();
	  		system.debug('promoDiscount=' + promoDiscount);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing promoDiscount');}
	  		try
	  		{
	  		referralCode = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<referralCode>')+14,email.plainTextBody.indexOfIgnoreCase('</referralCode>')).trim();
	  		system.debug('referralCode=' + referralCode);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing referralCode');}
			try
	  		{
	  		downloadFileName = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<downloadFileName>')+18,email.plainTextBody.indexOfIgnoreCase('</downloadFileName>')).trim();
	  		system.debug('downloadFileName=' + downloadFileName);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing downloadFileName');}
	  		try
	  		{
	  		productFeatures = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<productFeatures>')+17,email.plainTextBody.indexOfIgnoreCase('</productFeatures>')).trim();
	  		system.debug('productFeatures=' + productFeatures);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing productFeatures');}
	  		try
	  		{
	  		downloadDateTime = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<downloadDateTime>')+18,email.plainTextBody.indexOfIgnoreCase('</downloadDateTime>')).trim();
	  		system.debug('downloadDateTime=' + downloadDateTime);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing downloadDateTime');}
			
			try
	  		{
	  		year1Billing = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<year1Billing>')+14,email.plainTextBody.indexOfIgnoreCase('</year1Billing>')).trim();
	  		system.debug('year1Billing=' + year1Billing);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing year1Billing');}try
	  		{
	  		year2Billing = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<year2Billing>')+14,email.plainTextBody.indexOfIgnoreCase('</year2Billing>')).trim();
	  		system.debug('year2Billing=' + year2Billing);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing year2Billing');}try
	  		{
	  		year3Billing = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<year3Billing>')+14,email.plainTextBody.indexOfIgnoreCase('</year3Billing>')).trim();
	  		system.debug('year3Billing=' + year3Billing);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing year3Billing');}try
	  		{
	  		year4Billing = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<year4Billing>')+14,email.plainTextBody.indexOfIgnoreCase('</year4Billing>')).trim();
	  		system.debug('year4Billing=' + year4Billing);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing year4Billing');}
	  		try
	  		{
	  		userEmail = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<emailAddress>')+14,email.plainTextBody.indexOfIgnoreCase('</emailAddress>')).trim();
	  		system.debug('userEmail=' + userEmail);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing userEmail');}
	  		try
	  		{
	  		promoCode = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<promoCode>')+11,email.plainTextBody.indexOfIgnoreCase('</promoCode>')).trim();
	  		system.debug('promoCode=' + promoCode);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing promoCode');}
	  		try
	  		{
	  		userPhone = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<userPhone>')+11,email.plainTextBody.indexOfIgnoreCase('</userPhone>')).trim();
	  		system.debug('userPhone=' + userPhone);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing userPhone');}
	  		
	  		try
	  		{
	  		billingAmount = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<amount>')+8,email.plainTextBody.indexOfIgnoreCase('</amount>')).trim();
	  		system.debug(billingAmount);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing billingAmount');}
	  		try
	  		{
	  			
	  		action = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<action>')+8,email.plainTextBody.indexOfIgnoreCase('</action>')).trim();
	  		system.debug('action=' + action);
	  		
	  	
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing action');}	  		
			try
			{
	  		product = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<product>')+9,email.plainTextBody.indexOfIgnoreCase('</product>')).trim();
      		system.debug('product=' + product);
      		}
	  		catch (exception e)
	  		{system.debug('exception parsing product');}	  		
			try
			{
      		accountName = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<accountName>')+13,email.plainTextBody.indexOfIgnoreCase('</accountName>')).trim();
	  		system.debug('accountName=' + accountName);
			}
	  		catch (exception e)
	  		{system.debug('exception parsing accountName');}	  		
			try
			{
			firstName = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<firstName>')+11,email.plainTextBody.indexOfIgnoreCase('</firstName>')).trim();
	  		system.debug('firstName=' + firstName);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing firstName');}	  		
			try
			{
	  		lastName = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<lastName>')+10,email.plainTextBody.indexOfIgnoreCase('</lastName>')).trim();
	  		system.debug('lastName=' + lastName);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing lastName');}	  		
				  		
			try
			{
	  		leadSource = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<leadSource>')+12,email.plainTextBody.indexOfIgnoreCase('</leadSource>')).trim();
	  		system.debug('leadSource=' + leadSource);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing leadSource');}	  		
			try
			{
	  		emailOptOut = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<emailOptOut>')+13,email.plainTextBody.indexOfIgnoreCase('</emailOptOut>')).trim();
	  		system.debug('emailOptOut=' + emailOptOut);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing emailOptOut');}	  		
			try
			{
	  		MSSecureContactID = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<MSSecureContactID>')+19,email.plainTextBody.indexOfIgnoreCase('</MSSecureContactID>')).trim();
	  		system.debug('MSSecureContactID=' + MSSecureContactID);
			}
			catch (exception e)
			{system.debug('exception parsing MSSecureContactID');}
	  		try
	  		{
	  		emailDomain = '%' + userEmail.substring(useremail.indexOf('@')) + '%';
			}
	  		catch (exception e)
	  		{system.debug('exception parsing emailDomain');}	  		
			try
			{
			domainBody = emailDomain.substring(2,(emailDomain.length()-5));
			system.debug('domainBody=' + domainBody);	
			}
			catch (exception e)
			{system.debug('exception parsing domainBody');}	
			try
			{
			SFAccountID = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<SFAccountID>')+13,email.plainTextBody.indexOfIgnoreCase('</SFAccountID>')).trim();
	  		system.debug('SFAccountID=' + SFAccountID);			  			  		
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing SFAccountID');}	  		
			try
			{
	  		MSSubscriptionID = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<MSSubscriptionID>')+18,email.plainTextBody.indexOfIgnoreCase('</MSSubscriptionID>')).trim();
	  		system.debug('MSSubscriptionID=' + MSSubscriptionID);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing MSSubscriptionID');}	  		
			try
			{
	  		ContractType = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<contractType>')+14,email.plainTextBody.indexOfIgnoreCase('</contractType>'));
	  		system.debug('ContractType=' + ContractType);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing ContractType');}	  		
			try
			{
	  		subscriptionExpirationDate = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<subscriptionExpirationDate>')+28,email.plainTextBody.indexOfIgnoreCase('</subscriptionExpirationDate>'));
	  		system.debug('subscriptionExpirationDate=' + subscriptionExpirationDate);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing subscriptionExpirationDate');}	
			try
			{
	  		userCount = email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<userCount>')+11,email.plainTextBody.indexOfIgnoreCase('</userCount>'));
	  		system.debug('userCount=' + userCount);
	  		}
	  		catch (exception e)
	  		{system.debug('exception parsing userCount');}	
		
		if (action == 'ADDDOWNLOADRECORD')
		{
			didItWork = addDownloadRecord(downloadFileName, downloadDateTime, userEmail, MSSecureContactID, emailDomain,  domainBody,  leadSource);
			result.success = didItWork;
			return result;
		}
		
    
 //Check to see if the action is "CANCEL" - if so, call cancel function.
 		if (action == 'CANCEL')
 		{
     	didItWork = cancelContracts(MSSubscriptionID);
 		result.success = didItWork;
		return result;
 		}
 		
 //Check to see if the action is "UPDATEFEATURES" - if so, remove all contract products and add new valid ones.
 		if (action == 'UPDATEFEATURES')
 		{
 			didItWork = updateContractFeatures(productFeatures, MSSubscriptionID, product);
 			result.success = didItWork;
			return result;
 		}
 		
 //Check to see if action is "UPDATEUSERCOUNT" - if so, just update the number of users on an existing contract
 		if (action == 'UPDATEUSERCOUNT')
		{
			didItWork = changeContractUserCount(MSSubscriptionID, userCount);
			result.success = didItWork;
			return result;
		}  
 		
 		
 		if (action == 'UPDATEENDDATE')
		{
			didItWork = changeContractEndDate(MSSubscriptionID, subscriptionExpirationDate);
			result.success = didItWork;
			return result;
		}  
 		
    
 //Check to see if the action is "UPDATECONTACT" - if so, call update function.
		if (action == 'UPDATECONTACT')
		{
			didItWork = changeContactDetails(MSSecureContactID, firstName,lastName, userEmail, accountName, emailOptOut, userPhone);
			result.success = didItWork;
			return result;
		}   
    
    
//Check to see if the action is "REGISTER" - if so, create the initial contact.
		if (action=='REGISTER')
		{
			
			didItWork = createContact(MSSecureContactID,userEmail,emailDomain,domainBody,leadSource);
			result.success = didItWork;
			return result;
		}
		
//Check to see if the action is "CREATECONTRACT" and the  contractType is "GROUP" - if so, call associate funciton and exit.
//Will deprecate this function with Subway - will become action of 'ASSOCIATE' and contractType = GROUP
		if (action=='CREATECONTRACT' && contractType == 'GROUP')
		{
			didItWork = connectUserToFirmContract(MSSubscriptionID,MSSecureContactID);
			result.success = didItWork;
			return result;
		}
		
		
		//Check to see if the action is "Associate" and the  contractType is "GROUP" - if so, call associate funciton and exit.
		if (action=='ASSOCIATE' && contractType == 'GROUP')
		{
			didItWork = connectUserToFirmContract(MSSubscriptionID,MSSecureContactID);
			result.success = didItWork;
			return result;
		}
		
		
 //Check to see if the action is "CREATECONTRACT" and the type is NOT "GROUP"

 system.debug('checking to see if we should create a contract - type=' + contractType);
 		if (action == 'CREATECONTRACT' && (contractType == 'EVAL' || contractType =='INDIVIDUAL' || contractType =='RENEW'))
 		{
			didItWork = createContract(ContractType,MSSecureContactID, SFAccountID, MSSubscriptionID, product, billingAmount,subscriptionExpirationDate,userCount,promoCode,year1Billing,year2Billing,year3Billing,year4Billing,productFeatures,promoDiscount,referralCode,packageName,transactionID);
			result.success = didItWork;
			system.debug('didItWork=');
			
			system.debug(result.success);
			return result;
 		}
 		
 		
 //Check to see if the action is "CREATEGROUPCONTRACT" - if so, create firm contract
 			if (action == 'CREATEGROUPCONTRACT')
 			{
 			didItWork = createContract(ContractType,MSSecureContactID, SFAccountID, MSSubscriptionID, product, billingAmount,subscriptionExpirationDate,userCount,promoCode,year1Billing,year2Billing,year3Billing,year4Billing,productFeatures,promoDiscount,referralCode,packageName,transactionID);
 			result.success = didItWork;
			return result;
 			}
 
 	//Generic return
//  	result.success = true;
	return result;
    }
    
    public static void handleErrorAndSendEmail(String errorType, String emailBody) 
				{
						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						String[] toAddresses = new String[] {'support@microsystems.com'};
						mail.setToAddresses(toAddresses);
						mail.setReplyTo('support@microsystems.com');
						mail.setSenderDisplayName('Salesforce Automation Agent');
						mail.setSubject('Error creating web submitted item:    ' + errorType);
						mail.setPlainTextBody('Check to see if this object was created successfully. Submitted data:     ' + emailBody);
						mail.setHtmlBody('Check to see if this object was created successfully. <br> <br>  Submitted data:   <br><br>' + emailBody);
						Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
						return;
				}    
				
	public static void sendNotificationEmail (String message, String [] TOrecipients, String [] CCrecipients)
				{
						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						//String[] toAddresses = new String[] {recipients};
						mail.setToAddresses(TOrecipients);
						mail.setCcAddresses(CCrecipients);
						mail.setReplyTo('support@microsystems.com');
						mail.setSenderDisplayName('Salesforce Automation Agent');
						mail.setSubject('Salesforce notice:  Action needed');
						mail.setPlainTextBody(message);
						mail.setHtmlBody(message);
						Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
				}
    
    public static boolean changeContactDetails(String MSSecureContactID, String firstName, String lastName, String emailAddress, String accountName, string emailOptOut, string userPhone)
				{
				String accountId ='';
				String origAccountName = '';
				String emailDomain = '%' + emailAddress.substring(emailAddress.indexOf('@')) + '%';
				String domainBody = emailDomain.substring(2,(emailDomain.length()-5));
				String leadSource= 'Secure Online Portal';
				try
				{
					Contact [] updateContact = [Select AccountId, Id, account.Name  From Contact Where MSSecureContactID__c = :MSSecureContactID];
					
					if (updateContact.size() == 0 || updateContact.size() == null )
					{
						system.debug('no contact found to update, need to call createContact');
						createContact(MSSecureContactID,emailAddress,emailDomain,domainBody,leadSource);
						updateContact = [Select AccountId, Id, account.Name  From Contact Where MSSecureContactID__c = :MSSecureContactID];
					}
					
					Account unknownEmploymentAccount = [select id from account where name = 'Employment Unknown'];
					system.debug('unknownEmploymentAccountID = ' + unknownEmploymentAccount.id);				
						accountId = updatecontact[0].AccountId;
						origAccountName = updateContact[0].account.name;
							
						Integer originalAccountNameCanBeUpdated = origAccountName.indexOfIgnoreCase('(via online submission-please verify)');
						system.debug('originalAccountNameCanBeUpdated=');
						system.debug('starting to check fields for values');
						if (emailAddress != '')
						{
						system.debug('emailAddress is not null');	
						updateContact[0].email = emailAddress;	
						}
						if (firstName != '')
						{
						system.debug('firstName is not null');
						updateContact[0].FirstName = firstName;	
						}
						if (lastName != '')
						{
						system.debug('lastName is not null');
						updateContact[0].LastName = lastName;	
						}
						if (emailOptOut == 'True')
						{
						updateContact[0].HasOptedOutOfEmail = True;
						system.debug('emailOptOut is not null');
						}
						if (userPhone != '')
						{
						system.debug('userPhone is not null');
						updatecontact[0].Phone = userPhone;
						}
					
					update updateContact;
					
					if (accountName != '')
					{
					system.debug('accountName variable was null');	
						if (accountID != unknownEmploymentAccount.id && originalAccountNameCanBeUpdated != -1) 
						
						{
							system.debug('accountID was not unknownemploymentaccount and orig not -1');
							system.debug('account name passed, contact not currently connected to Employment Unknown account.  Will update name.');
							account updateAccount = [select id from Account where id = :accountId];	
							updateAccount.name = accountName + ' (via online submission-please verify)';
							update updateAccount;
						
						} else if (accountID == unknownEmploymentAccount.id)
						{
							system.debug('Account was previously connected to Employment Unknown account - now creating new acccount');
							account acct  = new Account();
					        acct.name = accountName + ' (via online submission-please verify)';
					        acct.industry = 'Other';
					        acct.description = 'Account automatically created via online secure contact registration.';
					        insert acct;
					        accountId = acct.id;
					        
					        updateContact[0].accountid = accountId;
					        update updateContact;
							
						}
								
					
								
					}
					return true;
				}
				catch (exception e)
				{
						handleErrorAndSendEmail('Error changing contact details for GUID ' + MSSecureContactID,e.getmessage());	
					return false;
				}
			}
    
    public static boolean createContact(String MSSecureContactID, String emailAddress, String emailDomain, String domainBody, String leadSource)
    		{
    			String emailDomainBlackList = 'mailinator.com,trashmail.net,trbvm.com,gmail.com,yahoo.com,msn.com,outlook.com,me.com,icloud.com,hotmail.com,aol.com,hushmail.com,lycos.com,mail.com,rackspace.net,live.com,earthlink.net';
    			system.debug('MSSecureContactID for create contact =' + MSSecureContactID);
    			String accountID = '';
    			Integer domainInBlacklist = emailDomainBlackList.indexOfIgnoreCase(domainBody);
    			system.debug('domaininblacklist=' + domainInBlackList);	
    			String leadOwner = '';
				String leadOwnerEmail = '';
				String leadId = '';
				String leadOwnerID = '';
				String contactAndLeadBothExistMessage = 'An attempt was made to automatically convert a lead into a contact.<br>This failed due to a duplicate contact already existing in the system.<br>The lead below needs to be manually converted, selecting to merge into the existing contact.<br>' + URL.getSalesforceBaseUrl().toExternalForm() + '/';
				
				String [] contactAndLeadBothExistTORecipients = new List<String>();
				String [] contactAndLeadBothExistCCRecipients = new List<String>();
				
    			//First, check to see if there is an existing lead with this email address.
    			//If there is, get the lead ID, convert it to a contact / account and then update it.
    			
    			try 
    			{
    				Lead [] leadArray = [Select id, name, company, email, ownerID From Lead Where Email = :emailAddress ];
    				if (leadArray.size()> 0 )
									{
										system.debug('got existing lead.  Will also ensure there is not an existing contact with matching email address.');
										
										//Get owner and lead ID and set conversion date
										system.debug('Trying to set lead fields for later use');
										leadOwner = leadArray[0].ownerid;
										leadOwnerId = leadArray[0].ownerid;
										leadId = leadArray[0].Id;
										contactAndLeadBothExistMessage = contactAndLeadBothExistMessage + leadId;
										
												contact [] leadContactCheck = [select id from contact where email = :emailAddress ];
													
													if (leadContactCheck.size() > 0)
													{
															contactAndLeadBothExistTORecipients.add('support@microsystems.com');
															contactAndLeadBothExistCCRecipients.add('support@microsystems.com');
														sendNotificationEmail(contactAndLeadBothExistMessage,contactAndLeadBothExistTORecipients,contactAndLeadBothExistCCRecipients);
													} else
													
												  {
													
													
																//Now, try to convert the lead to a contact.
																system.debug('Trying to convert lead to a contact');
																Database.LeadConvert lc = new Database.LeadConvert();
																lc.setLeadId(leadArray[0].id);
																lc.setDoNotCreateOpportunity(true);
																
																LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
																lc.setConvertedStatus(convertStatus.MasterLabel);
																
																Database.LeadConvertResult lcr = Database.convertLead(lc);
																if(lcr.isSuccess())
																{
																
																accountId = lcr.getAccountId();
																								
																}
													}
									}
    			}
    			
    			catch (exception e)
    			{
    				handleErrorAndSendEmail('Unable to query for or create Lead for contact ',emailAddress);
    				
    			}
    			
    			
    			try
    			
    			
    			{
    				if (accountID == '')
    				{
    				
    					Contact [] accountArray = [Select accountId From contact Where Email like :emailDomain and account.name != 'Employment Unknown' Limit 1];

								
							
									if (accountArray.size() > 0 && domainInBlackList == -1) 
									{
										system.debug('got existing account');
										accountId = accountArray[0].accountId;
										
									} 
									else if ((accountArray.size() == 0 | accountArray.size() == null) && domainInBlackList == -1) 
									{
										system.debug('unable to find account - creating new one');
										account acct  = new Account();
					               		acct.name = domainBody + ' (via online submission-please verify)';
					               		acct.industry = 'Other';
					               		acct.description = 'Account automatically created via online secure contact registration.';
					               		insert acct;
					               		accountId = acct.id;
									} else if (domainInBlackList != -1)
									
									{
										system.debug('domain was in blacklist');
										try
										{
											account employmentUnknownAccount = [select id from account where name = 'Employment Unknown'];
											accountId = employmentUnknownAccount.id;
										}
										catch (exception e)
										{
											handleErrorAndSendEmail('Unable to find / query for employment unknown  Account.',emailDomain);
											return false;
										}
										
																			
									}
    				}
				}
		
				catch (exception e)
				{
						handleErrorAndSendEmail('Unable to query for or create Account.',emailDomain);
						return false;

				}
    	
    		
			// Look up the contact by email address or secure contacat ID.  If it does not exist, create a new contact.	
			
			try 
				{
				
				
					system.debug('looking for contacts');
	       			Contact [] contactArray = [Select Id, Name, Email From Contact Where (email = :emailAddress) or (mssecurecontactid__c = :MSSecureContactID) ];

						//If we got a contact from the above query by email, use it.
		  				if (contactArray.size() == 1) 
  						{		
  							system.debug('Found a contact by the passed in email address or secure contact id');
			             	//Update contact with the MSSecureContactID
			             	contactArray[0].MSSecureContactID__c = MSSecureContactID;
			             	contactArray[0].SecureRegistrationDate__c = date.today();
			             	
			             	if (leadOwner != '')
			             	{
			             	contactArray[0].original_lead_owner__c = leadOwner;
			             	contactArray[0].original_lead_conversion_date__c = date.today();
			             	}
			             		if (leadId != '')
			             	{
			             	contactArray[0].original_lead_id__c = leadId;
			             	}
			             		
			             	if (leadOwnerId != '')
			             	{
			             		contactArray[0].original_lead_owner_user__c = leadOwnerId;
			             	}
			             	
			             	
			             	
			             	update contactArray[0];
			               	
               			} else if (contactArray.size() > 1)
               			{
               				handleErrorAndSendEmail('Multiple contacts found with this email address or secure contact ID.',emailAddress);
               				return false;
               			}	 
		         
		         //There's no existing contact, so create one.
		        		else if (contactArray.size() == 0 | contactArray.size() == null) 
		             
			            {
		            	
			             	system.debug('no contact found, need to make one');
			             	//Didn't find a contact, so I need to create one
			             	
							Contact cnt = new Contact(); 
							system.debug('Account id=' + accountId);
			               	cnt.AccountId = accountId;
			               	cnt.Email = emailAddress;
			               	cnt.lastName='Temporary Online Portal User';
			               	cnt.Contact_Role__c = 'Other';
			               	cnt.leadSource = leadSource;
			               	system.debug('MSSecureContactID=' + MSSecureContactID);
			               	cnt.MSSecureContactID__c = MSSecureContactID;
			               	cnt.SecureRegistrationDate__c = date.today();
			             	  	if (leadOwner != '')
			             	{
			             	cnt.original_lead_owner__c = leadOwner;
			             	cnt.original_lead_conversion_date__c = date.today();
			             	}
			             		if (leadId != '')
			             	{
			             	cnt.original_lead_id__c = leadId;
			             	}
			             				             	
			               	insert cnt;
		              	}
				return true;
				}
			//Throw error if the query for contact fails
			catch (System.Queryexception e)
				{
		    		handleErrorAndSendEmail('Error querying for / creating contact for GUID ' + MSSecureContactID,e.getmessage());
		    		return false;

    			}
    			
		    }
		    
	public static boolean createContract(String ContractType,String MSSecureContactID, String SFAccountID, String MSSubscriptionID, String product,  String billingAmount, String subscriptionExpirationDate, String userCount,String promoCode,String year1billing,String year2billing,String year3billing,String year4billing, String productFeatures, String promoDiscount, String referralCode, String packageName, String transactionId)
		    {
		    	String accountId = '';
		    	String contactId = '';
		    	String accountNameFromID ='';
		    	String firstName = '';
		    	String lastName = '';
		    	Decimal origBillingAmount = 0;
		    	String period = ' year ';
		    	String[] productFeaturesArray = productFeatures.split('--',0);
		    	
		    	system.debug('featuresarrayitem=' + productFeaturesArray[0]);
		    	
		    	Date subscriptionExpirationDateAsDate = Date.parse(subscriptionExpirationDate);
		    	
		    	Integer userCountInt = integer.valueOf(userCount);
		    	if (userCountInt == 0 || userCountInt == null){
		    		userCountInt = 1;
		    	}
		    	
		    	if (billingAmount == null || billingamount == '') billingAmount = '0';
		    	
		    	decimal year1billingInt = 0;
		    	decimal year2billingInt = 0;
		    	decimal year3billingInt = 0;
		    	decimal year4billingInt = 0;
		    	
		    	if (year1billing  != '') year1billingInt = decimal.valueOf(year1billing); 
		    	if (year2billing  != '') year2billingInt = decimal.valueOf(year2billing);
		    	if (year3billing  != '') year3billingInt = decimal.valueOf(year3billing);
		    	if (year4billing  != '') year4billingInt = decimal.valueOf(year4billing);
		    	if (year1billing == '') year1billingInt = decimal.valueOf(billingAmount).intValue();
		    	
		    	if (product == 'PATENT'){
		    		product ='Patent Companion';
		    	}
		    	
		    	//Temporary hack to deal with the online portal not passing in a product.  Until multi products are implemented in the online portal, all calls will be for Patent Companion.
		    	if (product == ''){
		    		product = 'Patent Companion';
		    	}
		    	system.debug('product=' + product);
		    	string contractLengthMonths = String.valueOf(date.today().monthsBetween(subscriptionExpirationDateAsDate));
		    	string contractLengthYears = String.valueOf((date.today().monthsBetween(subscriptionExpirationDateAsDate)/12));
		    	string contractLengthDays = String.valueof((date.today().daysBetween(subscriptionExpirationDateAsDate)));
		    	string contractLengthForDescription = '';
		    	
		    	system.debug('contractlengthyears=' + contractLengthYears);
		    	system.debug('contractLengthMonths=' + contractLengthMonths);
		    	system.debug('contractLengthDays=' + contractLengthDays);
	
	//Set period variable to year, month or day, based on term
		
		if (integer.valueOf(contractLengthMonths) > 12) {
			period = ' year ';
			contractLengthForDescription = contractLengthYears;
				}
		if (integer.valueOf(contractLengthMonths) > 0 && integer.valueOf(contractLengthMonths) <= 12) {
			period = ' month ';
			contractLengthForDescription = contractLengthMonths;
				}	
		if (contractLengthMonths == '0' &&  integer.valueOf(contractLengthDays) > 0) {
			period = ' day ';
			contractLengthForDescription = contractLengthDays;
			contractLengthMonths = '1';
		}
		 
		
			
	//Try to get the SF Contact from the passed in MSSecureContactID
		    if (MSSecureContactID != '')
		    {
		    
				    try		
				    	{	
				    	Contact [] contactArray = [Select Id, firstname, lastname, AccountId, Account.Name, Name, Email From Contact Where MSSecureContactID__c = :MSSecureContactID Limit 1];
		
						if (contactArray.size() > 0) 
		  				
		  				
		  					{
		  							contactID = contactArray[0].id;
		  							accountId = contactArray[0].AccountId;
		  							accountNameFromID = contactArray[0].Account.Name;
		  							firstName = contactArray[0].FirstName;
		  							lastName = contactArray[0].LastName;
		  							
		               		}
				    	
				    	}
				    	catch (exception e)
				    	{
				    		handleErrorAndSendEmail('Unable to query for Contact.',MSSecureContactID);
							return false;
				    	}
		    }	    	
	//Try to get the SF Account from the passed in SFAccountID 
		    	if (SFAccountID != '')
		    	{
		    	 try 
					    {
				 			Account [] accountArray = [Select ID,name from account where AccountID__c = :SFAccountID];
								system.debug('SFAccountID=' + SFAccountID);
			
							if (accountArray.size() > 0 ) 
								{
									system.debug('got existing account');
									system.debug('accountId=' + accountID);
									
									if (product == 'EagleEye' | product == 'Drafting Companion') {
									accountArray[0].EagleEye__c = True;										
									} 
									
									if (product == 'Patent Companion') {
									accountArray[0].Patent_Companion__c = True;
									}

									update accountArray[0];
									if (accountID == '')
									{
										system.debug('accountID was blank, so setting it to ' + accountArray[0].Id);
										accountId = accountArray[0].Id;
										
									}
									if (accountNameFromID == '')
									{
										accountNameFromID = accountArray[0].Name;
									}
									
								}
							
						}
					
					catch (exception e)
						{
							handleErrorAndSendEmail('Unable to query for / create Account.',SFAccountID);
							return false;
						}
		    	
		    	}
		    		if (contactId == '' && SFAccountID == '')
		    		{
		    			
		    			handleErrorAndSendEmail('Contact and SFAccountID both NULL. Invalid CreateContract call.',MSSecureContactID + ' / ' + SFAccountID);
		    			system.debug('going to return false');
		    			return false;
		    		}
		    	
		    	try
					{
					
					
					//First, try to look up an existing contract by subscription ID.  If we find it, we're just updating things.  If not, create new one.
					String updateContractId = '';
					String checkContractID = '';
					
					decimal billingAmountInt = decimal.valueof(billingAmount);
					Contract [] checkContract = [Select ID, MSSubscriptionID__c, online_subscription_revenue_to_date__c from Contract where MSSubscriptionID__c = :MSSubscriptionID];
					system.debug('going to see if checkContract has a value.');
					if (checkContract.size() > 0)
					{
						system.debug('checkContractID has a value - existing contract');
						checkContractId = checkContract[0].id;	
					}
					
				system.debug('checkContractID = ');
					if (checkContractID <> '')
					{
						contract newContract = [select ID, MSSubscriptionID__c, online_subscription_revenue_to_date__c from Contract where id = :checkContract[0].Id];
						system.debug('Contract found.');

						origBillingAmount = newContract.online_subscription_revenue_to_date__c;
						
						if (origBillingAmount == null )
						{
							origBillingAmount = 0;
						}
						
						updateContractID = newContract.id;
					}
					
						
						else if (checkContractId == '')
					{
							system.debug('no contract found, so making a new one.');
							
							contract newContract = new contract();
							newContract.AccountId = accountID;
							newContract.StartDate = date.today();
							newContract.EndDate = subscriptionExpirationDateAsDate;
							newContract.Activation_End_Date_WF__c = subscriptionExpirationDateAsDate;
							newContract.MSSubscriptionID__c = MSSubscriptionID;
							newContract.Contract_Sub_Type__c = 'Subscription';
							newContract.Original_Contract_Date__c = date.today();
							newContract.online_subscription_revenue_original__c = billingAmountInt;
							newContract.ContractTerm = Integer.valueOf(contractLengthMonths);
							newContract.product__c = product;
							insert newContract;
							system.debug('just made a new contract - here is the ID=' + newContract.id);
							updateContractId = newContract.id;
					}
					
							contract updateContract = [select ID, MSSubscriptionID__c, online_subscription_revenue_to_date__c,year_1_billing_amount_patent_Companion__c, year_2_billing_amount_patent_Companion__c,year_3_billing_amount_patent_Companion__c,year_4_billing_amount_patent_Companion__c ,startdate from Contract where id = :updateContractId];
							
							if (ContractType == 'EVAL') 
									{
											updateContract.ContractIndividual__c = ContactId;
											updateContract.Contract_Type__c = 'Evaluation';
											updateContract.Evaluation_Start_Date__c = date.today();
											updateCOntract.Evaluation_End_Date__c = subscriptionExpirationDateAsDate;
											
											updateContract.Description = product + ' evaluation for ' + firstName + ' ' + lastName;
											updateContract.Name = firstName + ' ' + lastName + ' - ' + date.today().year() + '/' + date.today().month() + '/' + date.today().day() + ' ' + product;
											
											
											contact updateContact = [select id from contact where id = :ContactId];
											
											
											if (product == 'Patent Companion') {
										
											updateContact.Patent_Companion_Trial_Initiated__c = true;
											updateContact.Patent_companion_trial_start__c = date.today();
											updateContact.Patent_Companion_trial_end__c = subscriptionExpirationDateAsDate;
											updateContact.patent_companion__c = true;
											updateContract.patent_companion_users__c = userCountInt;
											}
											If (product=='EagleEye' | product == 'Drafting Companion'){
												updateContact.EagleEye__c = true;
												updateContact.Agreement_Checker_Trial_Start__c = date.today();
												updateContact.Agreement_Checker_Trial_End__c = subscriptionExpirationDateAsDate;
												updateContact.Agreement_Checker_Trial_Initiated__c = true;
												updateContract.EagleEye_users__c = userCountInt;
												}
											
											
											
											update updateContact;
									}
							 else if (ContractType == 'INDIVIDUAL') 
									{
											updateContract.ContractIndividual__c = ContactId;										
											updateContract.Description = product + ' ' + contractLengthForDescription  + ' ' +  period + ' contract for ' + firstName + ' ' + lastName;
											updateContract.Contract_Type__c = 'Agreement (Initial)';
											updateContract.Name = firstName + ' ' + lastName + ' - ' + date.today().year() + '/' + date.today().month() + '/' + date.today().day() + ' ' +  product;
											updateContract.EndDate = subscriptionExpirationDateAsDate;
											updateContract.Activation_End_Date_WF__c = subscriptionExpirationDateAsDate;
											//if (promocode != '') updateContract.promotion_code__c = promocode;
											//if (promocode != '') updateContract.promotion_applied__C = true;
											//if (promoDiscount != '') updateContract.promotion_amount__c = decimal.valueOf(promoDiscount);
											
											If (product=='EagleEye' | product == 'Drafting Companion'){
												updateContract.EagleEye_users__c = userCountInt;
												}
											
											If (product=='Patent Companion'){
												updateContract.patent_companion_users__c = userCountInt;
												}


											if (MSSecureContactID != '')
												    {
		    
													    try		
				    										{	
				    										Contact updateContact = [Select Id, firstname, lastname, AccountId, Account.Name, Name, Email From Contact Where id  = :ContactId];
				    										if (product == 'Patent Companion'){
				    										updateContact.patent_companion__c = true;
				    										}
				    										if (product == 'EagleEye' | product == 'Drafting Companion'){
				    										updateContact.EagleEye__c = true;
				    										}
				    										
				    										update updateContact;
				    										}
														catch (exception e){
																			}
														}
														
														
										//Create the opportunity for this contract
										createOpportunityForContract(MSSubscriptionId, product);
										//ADDING CODE TO FIND THE ORIGINAL EVAL CONTRACT.  IF IT EXISTS, SET THE ORIGINAL CONTRACT FIELD ON THE NEW CONTRACT
										//TEMPORARY - PC WILL BE CHANGED TO USE THE SAME SUBSCRIPTION ID FOR EVAL AND REAL CONTRACTS
										//WHEN THAT HAPPENS, DELETE OR COMMENT OUT THIS CODE
										
				    						contract [] evalcontract = [select ID, startdate, enddate, Previous_Term_Contract__c, Previous_Contract_ID__c from Contract where accountid=:AccountId and product__c = :product and Contract_Type__c = 'Evaluation' ];
											
													
											system.debug('going to see if checkContract has a value.');
											if (evalcontract.size() > 0)
											{
											system.debug('evalcontract has a value - existing contract');
											updateContract.Previous_Contract_ID__c = evalcontract[0].previous_contract_id__c;
											updateContract.Previous_Term_Contract__c = evalcontract[0].Previous_term_contract__c;
											updateContract.Evaluation_Start_Date__c = evalcontract[0].startdate;
											updateContract.Evaluation_End_Date__c = evalcontract[0].enddate;
											}	
										//END CODE TO FIND THE EVAL CONTRACT
												    
									} 
							 else if (ContractType == 'RENEW') 
									{
											updateContract.EndDate = subscriptionExpirationDateAsDate;
											updateContract.Activation_End_Date_WF__c = subscriptionExpirationDateAsDate;
											updateContract.ContractIndividual__c = ContactId;
											updateContract.Name = firstName + ' ' + lastName + ' - ' + date.today().year() + '/' + date.today().month() + '/' + date.today().day() +  ' ' + product;
											updateContract.Description = product + ' ' + contractLengthForDescription + ' '  + period + ' renewal for ' + firstName + ' ' + lastName;
											//updateContract.online_subscription_revenue_to_date__c = origBillingAmount + billingAmountInt;
											updateContract.Contract_Type__c = 'Renewal';
											//if (promocode != '') updateContract.promotion_code__c = promocode;
											//if (promocode != '') updateContract.promotion_applied__C = true;
											//if (promoDiscount != '') updateContract.promotion_amount__c = decimal.valueOf(promoDiscount);
											
											If (product=='EagleEye' | product == 'Drafting Companion'){
												updateContract.EagleEye_users__c = userCountInt;
												}
											
											If (product=='Patent Companion'){
												updateContract.patent_companion_users__c = userCountInt;
												}
											
											
									}
							else if (ContractType == 'GROUP')
									{
											updateContract.Name = accountNameFromID + ' - ' + date.today().year() + '/' + date.today().month() + '/' + date.today().day() +  ' ' + product;
											updateContract.Description = product + ' ' + contractLengthForDescription + ' ' + period + ' contract for ' + accountNameFromID;
											updateContract.Contract_Type__c = 'Agreement (Initial)';
											//if (promocode != '') updateContract.promotion_code__c = promocode;
											//if (promocode != '') updateContract.promotion_applied__C = true;
											//if (promoDiscount != '') updateContract.promotion_amount__c = decimal.valueOf(promoDiscount);
											system.debug('what kind of contract is this/' + product);
											
											if (product == 'Patent Companion'){
												system.debug('This is a patent contract');
												system.debug(year1billingInt);
											updateContract.patent_companion_users__c = userCountInt;
											updatecontract.year_1_billing_amount_patent_companion__c = year1billingInt;
											updatecontract.year_2_billing_amount_patent_companion__c = year2billingInt;
											updatecontract.year_3_billing_amount_patent_companion__c = year3billingInt;
											updatecontract.year_4_billing_amount_patent_companion__c = year4billingInt;	
											}
											if (product == 'EagleEye' | product == 'Drafting Companion') {
												system.debug('This is an EE contract');
											updateContract.EagleEye_users__c = userCountInt;
											updatecontract.year_1_billing_amount_EagleEye__c = year1billingInt;
											updatecontract.year_2_billing_amount_EagleEye__c = year2billingInt;
											updatecontract.year_3_billing_amount_EagleEye__c = year3billingInt;
											updatecontract.year_4_billing_amount_EagleEye__c = year4billingInt;
											}
											
									}
							
							if (promocode != '') updateContract.promotion_code__c = promocode;
							if (promocode != '') updateContract.promotion_applied__C = true;
							if (promoDiscount != '') updateContract.promotion_amount__c = decimal.valueOf(promoDiscount);
							if (referralCode != '') updateContract.referral_code__c = referralCode;
							if (packageName != '') updateContract.Software_Feature_Package_Name__c = packageName;
							
							updateContract.Contract_Term_Length_Yrs__c = Decimal.valueOf(contractLengthYears);
							updateContract.ContractTerm = Integer.valueOf(contractLengthMonths);
							updateContract.Contract_Sub_Type__c = 'Subscription';
							
							updateContract.online_subscription_revenue_to_date__c = billingAmountInt + origBillingAmount;
							updateContract.online_subscription_revenue_current_term__c = billingAmountInt;
							updateContract.Online_Subscription_Transaction_ID__c = transactionId;
							
								update updateContract;

								//Now, update the revenue for the contract.		
								system.debug('calling updatecontractrevenueamount');						
								updateContractRevenueAmounts(updatecontract.Id,  billingAmountInt);
								updateContractStartEndDates(updatecontract.id, date.today());
						//now get the record type so we can create the contract products
							RecordType rt = [select Id from RecordType where Name = 'User Licenses' and SobjectType = 'Contract_Product__c' limit 1];
							
							system.debug('I am going to delete all contract products');
							deleteContractProducts (updateContract.id);
							system.debug('now I am creating the primary contract product');
							createContractProduct (updateContract.id, product, rt.id);
							
							system.debug('productFeaturesArraySize=' + productFeaturesArray.size());
							system.debug('now I am going to create contract products for all of the feature areas');
							for (Integer i = 0; i < productFeaturesArray.size(); i++)
								 {  
							     createContractProduct (updateContract.id, productFeaturesArray[i], rt.id);	
    												
								 }
							
							
								updateContract.Status = 'ACTIVE';
								system.debug('updateContractName=' + updateContract.name);
								update updateContract;
							
							
							
							
							return true;
							}	
						catch (exception e)	
						{
						handleErrorAndSendEmail('Error creating contract', e.getmessage());
						return false;
						}
						
		    	
		   
		   
		   
		    }
		    
		    public static boolean deleteContractProducts (String contractID)
		    		{
		    		try{
		    			
		    		
		    		contract_product__c [] CPs = [select Product__c from contract_product__c where contract__c = :contractID ];
		    		delete CPs;
		    		return true;
		    		}
		    		catch (exception e){
		    			return false;
		    		}
		    		}
		    
		    public static boolean createContractProduct (String contractId, String Product, String recordTypeId)
		    		{
		    			try{
		    				
		    			
		    			 if (product != ''){
		    					contract_product__c newCP = new contract_product__c();
    							newCP.Contract__c = contractId;
    							newCP.Product__c =Product;
    							newCP.RecordTypeID = recordTypeId;
    							insert newCP;
		    			 }
		    			 return true;
		    			}
		    			catch (exception e)
		    			{
		    				return false;
		    			}
				    } 
		    
		    
	public static boolean connectUserToFirmContract(String MSSubscriptionID, String MSSecureContactID)
			{
			String contractId = '';
			String accountId = '';
			String contactId = '';
				try
					{
					
				
					Contact [] contactArray = [select id from contact where MSSecureContactID__c = :MSSecureContactID];
						if (contactArray.size() > 0)
						{
							contactId = contactArray[0].Id;
						}
				
				
					Contract [] contractArray = [Select id from Contract where MSSubscriptionID__c = : MSSubscriptionID];
				
						if (contractArray.size() == 0 || contractArray.size() == null)
	  						{
	  							handleErrorAndSendEmail('No Contracts found for subscriptionID ' + MSSubscriptionID,MSSubscriptionID);
	  							return false;
	  						}
	  						else 
	  						{
	  							contractId = contractArray[0].id;
				  						
	  						}
	  						
	  						//NEED TO add logic to this function to detect what kind of contract it is.  Either passed in or query the product field of the passed in contract.
	  						 
	  						contactArray[0].patent_contract__c = contractId;
	  						//update userContact;
	  						update contactArray[0];	
				return true;
				
					}
				catch (QueryException e)
					{
						handleErrorAndSendEmail('Error connecting contract for user ' + contact.id,e.getmessage());
						return false;	
					}
			
			}
			
		
			public static boolean updateContractStartEndDates(String contractId, Date startDate)
			{
				
				contract newContract = [select ID, Contract_Term_Length_Yrs__c, product__c, MSSubscriptionID__c,  year_1_start_date__c, year_1_end_date__c,year_2_start_date__c, year_2_end_date__c, year_3_start_date__c, year_3_end_date__c, year_4_start_date__c ,year_4_end_date__c from Contract where id = :contractId];
				
			try{
				
					Date startDateForCalculations = startDate ;
            		integer term = newContract.Contract_Term_Length_Yrs__c.intValue();
            		newContract.year_1_start_date__c = startDateForCalculations;
            		newContract.year_1_end_date__c =  startDateForCalculations.AddYears(1).AddDays(-1);
            		
            		if (term > 1 ){
					newContract.year_2_start_date__c = startDateForCalculations.AddYears(1);
					newContract.year_2_end_date__c =  startDateForCalculations.AddYears(2).AddDays(-1);
            		}
            		if (term > 2)  {
					newContract.year_3_start_date__c = startDateForCalculations.AddYears(2);
					newContract.year_3_end_date__c =  startDateForCalculations.AddYears(3).AddDays(-1);
            		}
					  	if (term > 3)
					  {
					newContract.year_4_start_date__c = startDateForCalculations.AddYears(3);
					newContract.year_4_end_date__c =  startDateForCalculations.AddYears(4).AddDays(-1);           	
					  }   
			
				    		
		    		update newContract;
		    	return true;
			}	
		    catch (exception e)
		    {
		    	return false;
		    }				
		    				
			}		   
		
		
		
			
			public static boolean updateContractRevenueAmounts(String contractId, Decimal billingAmountInt)
			{
				
				contract updateContract = [select ID, product__c, MSSubscriptionID__c, online_subscription_revenue_to_date__c,year_1_billing_amount_patent_Companion__c, year_2_billing_amount_patent_Companion__c,year_3_billing_amount_patent_Companion__c,year_4_billing_amount_patent_Companion__c ,Year_1_Billing_Amount_EagleEye__c,Year_2_Billing_Amount_EagleEye__c,Year_3_Billing_Amount_EagleEye__c,Year_4_Billing_Amount_EagleEye__c,startdate from Contract where id = :contractId];
				
				try{
					
				
				
				string howFarIntoContract = String.valueof((updateContract.startdate.monthsBetween(date.today())));
		    				//String product = updatecontract.product__c;
		    				if (updatecontract.product__c == 'Patent Companion'){	
		    					decimal origYear1Billing = updateContract.year_1_billing_amount_patent_companion__c;
		    					if (origYear1Billing == null) origYear1Billing = 0;
		    					
		    					decimal origYear2Billing = updateContract.year_2_billing_amount_patent_companion__c;
		    					if (origYear2Billing == null) origYear2Billing = 0;
		    				
		    					decimal origYear3Billing = updateContract.year_3_billing_amount_patent_companion__c;
		    					if (origYear3Billing == null) origYear3Billing = 0;
		    				
		    					decimal origYear4Billing = updateContract.year_1_billing_amount_patent_companion__c;
		    					if (origYear4Billing == null) origYear4Billing = 0;
		    				
		    				
		    				system.debug('howfarintocontract=' + howFarIntoContract);	
		    				system.debug('year1=' + updateContract.year_1_billing_amount_patent_companion__c);
		    						if (Integer.valueof(howFarIntoContract) <= 12 ){
		    							updateContract.year_1_billing_amount_patent_Companion__c = billingAmountInt + origYear1Billing;
		    						} else if (Integer.valueof(howFarIntoContract) > 12 && Integer.valueof(howFarIntoContract) <=24) {
		    							updateContract.year_2_billing_amount_patent_Companion__c = billingAmountInt + origYear2Billing;
		    						} else if (Integer.valueof(howFarIntoContract) > 24 && Integer.valueof(howFarIntoContract) <=36) {
		    							updateContract.year_3_billing_amount_patent_Companion__c = billingAmountInt + origYear3Billing;
		    						} else if (Integer.valueof(howFarIntoContract) > 36 && Integer.valueof(howFarIntoContract) <=48) {
		    							updateContract.year_4_billing_amount_patent_Companion__c = billingAmountInt + origYear4Billing;
		    						}
		
									//end PC if tt
				    				}				 	
		    		
		    		
		    					if (updatecontract.product__c == 'EagleEye' | updatecontract.product__c == 'Drafting Companion'){	
		    					decimal origYear1Billing = updateContract.year_1_billing_amount_EagleEye__c;
		    					if (origYear1Billing == null) origYear1Billing = 0;
		    					
		    					decimal origYear2Billing = updateContract.year_2_billing_amount_EagleEye__c;
		    					if (origYear2Billing == null) origYear2Billing = 0;
		    				
		    					decimal origYear3Billing = updateContract.year_3_billing_amount_EagleEye__c;
		    					if (origYear3Billing == null) origYear3Billing = 0;
		    				
		    					decimal origYear4Billing = updateContract.year_4_billing_amount_EagleEye__c;
		    					if (origYear4Billing == null) origYear4Billing = 0;
		    				
		    				system.debug(updatecontract.id);
		    				system.debug('howfarintocontract=' + howFarIntoContract);	
		    				system.debug('year1=' + updateContract.year_1_billing_amount_EagleEye__c);
		    						if (Integer.valueof(howFarIntoContract) <= 12 ){
		    							updateContract.year_1_billing_amount_EagleEye__c = billingAmountInt + origYear1Billing;
		    						} else if (Integer.valueof(howFarIntoContract) > 12 && Integer.valueof(howFarIntoContract) <=24) {
		    							updateContract.year_2_billing_amount_EagleEye__c = billingAmountInt + origYear2Billing;
		    						} else if (Integer.valueof(howFarIntoContract) > 24 && Integer.valueof(howFarIntoContract) <=36) {
		    							updateContract.year_2_billing_amount_EagleEye__c = billingAmountInt + origYear3Billing;
		    						} else if (Integer.valueof(howFarIntoContract) > 36 && Integer.valueof(howFarIntoContract) <=48) {
		    							updateContract.year_3_billing_amount_EagleEye__c = billingAmountInt + origYear4Billing;
		    						}
		
		//end EE if
				    				}
		    		
		    		update updateContract;
			return true;
				}	
		    	catch (exception e)
		    	{
		    		return false;
		    	}			
		    				
			}		   
			
			
		public static boolean createOpportunityForContract(String MSSubscriptionID, String Product) 
			{
			
			try
			{
				
			system.debug('in the create opportunity for contract function');
			 	String products = '';
  				
  				Contract [] contractArray = [select account.name, ID,Currency_Type__c, AccountId, name, Year1_Billing_Amount_Total__c, Year2_Billing_Amount_Total__c,Year3_Billing_Amount_Total__c,Year4_Billing_Amount_Total__c,Year_4_Billng_Amount_Services__c,Year_3_Billing_Amount_Services__c,Year_2_Billing_Amount_Services__c,Year_1_Billing_Amount_Services__c,Contract_Term_Length_Yrs__c,startdate,enddate,account.industry, account.Client_Relations_Account_Owner__c,account.ownerid,Year_1_Maintenance_Amount_3BClean__c,Year_1_Maintenance_Amount_DocXtools__c,Year_1_Maintenance_Amount_EagleEye__c,Contract_Sub_Type__c,Year_1_License_Amount_3BClean__c,Year_1_License_Amount_DocXtools__c,Year_1_License_Amount_EagleEye__c,Year_1_Year_4_Total_Billing__c FROM Contract where MSSubscriptionID__c = :MSSubscriptionID];
  						
  						if (contractArray.size() > 0)
  						
  						{
  							
		  						system.debug('found a contract array - now need to create opportunity.');
		  						for(Integer a = 0; a < contractArray.size(); a++)
			  						{
			  						
			  						
			  						
			  				for (contract_product__c cp : [select product__c, contract__r.account.industry, contract__r.account.BillingCountry from contract_product__c where contract__r.id =:contractArray[a].Id and product__c != 'Services' ])
							{	
								if (products == '')
								{
									products = cp.product__c;
								}
								else if (products != '')
								{
									products = products + ',' + cp.product__c;
								
								}
			
							}
			  						
			  				//Create opportunity
			  				Decimal totalValue = 0;
							Decimal totalServices = 0;
							Decimal totalPerpSupport = 0;
	
			
			//if (contractArray[a].Contract_Term_Length_Yrs__c == 1)  totalValue = cont.Year1_Billing_Amount_Total__c;
			//if (contractArray[a].Contract_Term_Length_Yrs__c == 2)  totalValue = cont.Year2_Billing_Amount_Total__c;
			//if (contractArray[a].Contract_Term_Length_Yrs__c == 3)  totalValue = cont.Year3_Billing_Amount_Total__c;
			//if (contractArray[a].Contract_Term_Length_Yrs__c == 4)  totalValue = cont.Year4_Billing_Amount_Total__c;
			//if (contractArray[a].Contract_Term_Length_Yrs__c == 1)  totalServices = cont.Year_1_Billing_Amount_Services__c;
			//if (contractArray[a].Contract_Term_Length_Yrs__c == 2)  totalServices = cont.Year_2_Billing_Amount_Services__c;  
			//if (contractArray[a].Contract_Term_Length_Yrs__c == 3)  totalServices = cont.Year_3_Billing_Amount_Services__c;
			//if (contractArray[a].Contract_Term_Length_Yrs__c == 4)  totalServices = cont.Year_4_Billng_Amount_Services__c;
			totalValue = contractArray[a].Year_1_Year_4_Total_Billing__c;
			if (totalValue == null) totalValue = 0;
			if (totalServices == null) totalServices =0;
			system.debug(totalValue);
			system.debug(totalServices);
			Decimal totalNewTermValue = totalValue - totalServices;
			system.debug(totalNewTermValue);
			
			User[]  u = [select id from user where id = :contractArray[a].account.Client_Relations_Account_Owner__c];
			string ownerSFId = '';
			if (u.size() > 0) {
				ownerSFId=u[0].id;
			}
			else 
			{
				//User[]  u2 = [select id from user where id = :contractArray[a].account.ownerid];
				//if (u2.size() > 0) ownerSFId = u2[0].id; 
				ownerSFId = contractArray[a].account.Ownerid;
			}
			system.debug('enddate');
			system.debug(contractArray[a].enddate);
			system.debug(ownerSFId);
			
			
			
						
            //Create the opportunity
            Opportunity o = new Opportunity (
            AccountID = contractArray[a].AccountId
            ,name=contractArray[a].account.name + ' - ' + products 
            ,Opportunity_Start_Date__c = contractArray[a].enddate +1
            ,Product__c = product
            ,Related_Renewal_Contract__c = contractArray[a].id
            ,CloseDate = contractArray[a].enddate + 1
            ,StageName = '8-Closed Won'
            ,ownerID = ownerSFId
            ,amount = totalNewTermValue
            ,Software_Amount__c = totalNewTermValue
            ,Support_Amount__c = totalPerpSupport
            ,Existing_Customer__c = True
            
            );
            insert o;
            	
			  			
			  			
			  					}
  						}	
  				
  				return true;		
			}
			catch (exception e)
					{
						handleErrorAndSendEmail('Error creating opportunity  ' + MSSubscriptionID,e.getmessage());
						return false;	
					}
			}
			
			
			
			
			public static boolean changeContractUserCount(String MSSubscriptionID, String userCount) 
			{
			
			try
			{
				
			system.debug('in the change contract user count function');
			
  				
  				Contract [] contractArray = [Select id, product__c, description from Contract where MSSubscriptionID__c = :MSSubscriptionID];
  						
  						if (contractArray.size() > 0)
  						
  						{
  							
		  						system.debug('found a contract array - now need to update user count.');
		  						for(Integer a = 0; a < contractArray.size(); a++)
			  						{
			  						system.debug('changed user count for ' + contractArray[a].id);
			  						system.debug(contractArray[a].product__c);
			  						if (contractArray[a].product__c == 'Patent Companion') contractArray[a].Patent_Companion_Users__c = decimal.valueOf(userCount); 
			  						if (contractArray[a].product__c == 'EagleEye' | contractArray[a].product__c == 'Drafting Companion') contractArray[a].EagleEye_Users__c = decimal.valueOf(userCount); 
			  						contractArray[a].Description = String.valueof(date.today()) + 'User count updated via secure portal' + '\r\n' + contractArray[a].Description;
			  						update contractArray[a];
									}
						return true;			
  						}	
  						else
  						{
  						handleErrorAndSendEmail('Error changing user count for contract ' + MSSubscriptionID ,'No contract found for passed in ID.');
  						return false;
  						}
  						
			}
			catch (exception e)
					{
						handleErrorAndSendEmail('Error changing user count contract  ' + MSSubscriptionID,e.getmessage());
						return false;	
					}
			}
			
			public static boolean changeContractEndDate(String MSSubscriptionID, String subscriptionExpirationDate) 
			{
			
			try
			{
				
			system.debug('in the change contract end date function');
			
  				Contract [] contractArray = [Select id, startDate, description, endDate from Contract where MSSubscriptionID__c = :MSSubscriptionID];
  						
  						if (contractArray.size() > 0)
  						
  						{
  							
		  						system.debug('found a contract array - now need to update end date.');
		  						for(Integer a = 0; a < contractArray.size(); a++)
			  						{
			  						system.debug('changing end date for ' + contractArray[a].id);
			  						system.debug(Date.parse(subscriptionExpirationDate));
			  						system.debug(contractArray[a].startdate);
			  						contractArray[a].enddate = Date.parse(subscriptionExpirationDate);
			  						contractArray[a].Description = String.valueof(date.today()) + 'Contract End Date changed by Secure Portal user' + '\r\n' + contractArray[a].Description;
			  						update contractArray[a];
									}
  						return true;
  						}	
  				else {
  						handleErrorAndSendEmail('Error changing end date for ' + MSSubscriptionID,'No Contract found for passed in ID');
  				return false;	
  				}
  						
			}
			catch (exception e)
					{
						handleErrorAndSendEmail('Error changing end date' + MSSubscriptionID,e.getmessage());
						return false;	
					}
			}
			
			
			public static boolean cancelContracts(String MSSubscriptionID) 
			{
			
			try
			{
				
			system.debug('in the cancel function');
			
  				
  				Contract [] contractArray = [Select id from Contract where MSSubscriptionID__c = :MSSubscriptionID];
  						
  						if (contractArray.size() > 0)
  						
  						{
  							
		  						system.debug('found a contract array - now need to drop them.');
		  						for(Integer a = 0; a < contractArray.size(); a++)
			  						{
			  						system.debug('set status to dropped for contract contract #' + contractArray[a].id);
			  						contractArray[a].status = 'DROPPED';
			  						contractArray[a].Description = 'Contract dropped via customer request via Secure portal';
			  						update contractArray[a];
									}
  						}	
  				return true;
  						
			}
			catch (exception e)
					{
						handleErrorAndSendEmail('Error cancelling contract  ' + MSSubscriptionID,e.getmessage());
						return false;	
					}
			}
				
			
			public static boolean updateContractFeatures(string productFeatures, string MSSubscriptionID, string product)
			{
 			try {
 			RecordType rt = [select Id from RecordType where Name = 'User Licenses' and SobjectType = 'Contract_Product__c' limit 1];
			String[] productFeaturesArray = productFeatures.split('--',0); 			
 			Contract checkContract = [Select ID from Contract where MSSubscriptionID__c = :MSSubscriptionID];
 			deleteContractProducts(checkContract.id);
			createContractProduct(checkContract.id, product, rt.id);	
				for (Integer i = 0; i < productFeaturesArray.size(); i++)
					 {  
								
    				createContractProduct (checkContract.id, productFeaturesArray[i], rt.id);	
    												
					 }
				return true;
			}
			catch (exception e)
			{
						handleErrorAndSendEmail('Error udpating contract features for  contract  ' + MSSubscriptionID,e.getmessage());
						return false;	
			
				
			}
			
			}
			
			
						    
		    public static boolean addDownloadRecord(String downloadFileName, String downloadDateTime, String userEmail, String MSSecureContactID,String emailDomain, String domainBody, String leadSource)
		    {
		    String DLContactID = '';
		    String DLAccountID = '';
		     system.debug(downloadDateTime);
		    Datetime downloadDateTimeAsDatetime = Datetime.parse(downloadDateTime);	
		   
		    system.debug(downloadDateTimeAsDatetime);
		    
		    try
		    {
		    	contact [] DLContact = [select id, AccountId, account.name from contact where MSSecureContactID__c = :MSSecureContactID limit 1];
		    	
							
							if (DLContact.size() == 0 | DLContact.size() == null)
							{
							handleErrorAndSendEmail('Error creating download record-no contact found for specified MSSecureContactID','ERROR!');
							return false;
							//createContact(MSSecureContactID,userEmail,emailDomain,domainBody,leadSource);
							//changeContactDetails(MSSecureContactID, 'testfirst','testlast', userEmail, 'accountname', 'true', '5551212');
							//DLContact = [Select AccountId, Id, account.Name  From Contact Where MSSecureContactID__c = :MSSecureContactID];
							
							} else
							{
							DLContactID = DLContact[0].ID;
							DLAccountID = DLContact[0].Account.ID;
							}
							//Create the download record			
							
							Download__c newDownload = new Download__c();
							newDownload.Contact__c = DLContactId;
							newDownload.Account__c = DLAccountId;
							newDownload.fileDownloaded__C = downloadFileName;
							newDownload.whenDownloaded__c = downloadDateTimeAsDatetime;
							insert newDownload;
							return true;
		    	
		    	
		    }	
		    	catch (exception e)
		    	{
		    		handleErrorAndSendEmail('Error creating download record',e.getmessage());
		    		return false;
		    	}
		    	
		    }
		    
		    
}