//******************************************************************************************
//
//  MS_Contact_Evaluate_EagleEye_Eval_Request
//
//  Creates an evaluation contract and contract product when someone checks the contact field 
//  EagleEye Eval Requested
//  History:
//  3/19/13    Robb Allen  - created
// ******************************************************************************************

trigger MS_Contact_Evaluate_EagleEye_Eval_Request on Contact (before insert, before update) {

string accountName = '';
string contactName = '';
string accountId = '';

	for (Integer idx = 0; idx < trigger.new.size(); idx++)
	{


//if (system.trigger.isInsert && trigger.new[idx].EagleEvalSendRequested__c == True && trigger.new[idx].Web_Active_User__c == True && trigger.new[idx].SitecoreUsername__c != null )

// if (system.trigger.isInsert && trigger.new[idx].EagleEye_Eval_Requested__c == True && trigger.new[idx].Web_Active_User__c == True)
//			{
//				
//				system.debug('We are in the insert trigger.');
//				//Get the contact's account name
//		contact thisContact = [select account.name from contact where contact.id = :trigger.new[idx].id];		
//		system.debug('accountname='+ thisContact.account.name);
//		accountName = thisContact.account.name;
       
				//Create the eval contract
		        
                          
				//GET THE DETAILS OF THE CONTACT TO USE 
//				contract newContract = new contract();
//				newContract.AccountId = trigger.new[idx].AccountId;
//				newContract.StartDate = date.today();
//				newContract.EndDate = date.today().AddDays(30);
//				newContract.Contract_Type__c = 'Evaluation';
//				newContract.Description = 'EagleEye 30 Day Evaluation - Requested By ' + trigger.new[idx].Name;
//				newContract.Name = accountName + ' - ' + date.today().year() + '/' + date.today().month() + '/' + date.today().day() + ' EagleEye Eval';
//				
//				insert newContract;
//	            contract_product__c newCP = new contract_product__c();
//				newCP.Contract__c = newContract.id;
//				newCP.Product__c = 'EagleEye';
//				insert newCP;
//				
//				trigger.new[idx].EagleEvalSendRequested__c = True;
//			}
		
		
			//below "if" line is for new website.  When sitecore site goes live, uncomment this and remove existing active one.
	
	//if (system.trigger.isUpdate && trigger.old[idx].EagleEye_Eval_Requested__c == False && trigger.new[idx].EagleEye_Eval_Requested__c == True && trigger.new[idx].Web_Active_User__c == True && trigger.new[idx].SitecoreUsername__c != null)
//if (system.trigger.isUpdate && trigger.old[idx].EagleEye_Eval_Requested__c == False && trigger.new[idx].EagleEye_Eval_Requested__c == True && trigger.new[idx].EagleEye_Eval_Sent__c == null)
if (system.trigger.isUpdate && 
	(
	(trigger.old[idx].EagleEye_Eval_Requested_Picklist__c == null && trigger.new[idx].EagleEye_Eval_Requested_Picklist__c == 'Requested') 
	//|| 
//		(trigger.old[idx].EagleEye_Eval_Requested__c == 'Requested' && trigger.new[idx].EagleEye_Eval_Requested__c == 'Extension') ||
//		(trigger.old[idx].EagleEye_Eval_Requested__c == 'Extension' && trigger.new[idx].EagleEye_Eval_Requested__c == 'Reset Evaluation--already extended once') ||
//		(trigger.old[idx].EagleEye_Eval_Requested__c == 'Requested' && trigger.new[idx].EagleEye_Eval_Requested__c == 'Reset Evaluation--already extended once')
	)
	 && trigger.new[idx].EagleEye_Eval_Sent__c == null)
{
	
		//Get the contact's account name
		contact thisContact = [select account.name, account.id, name from contact where contact.id = :trigger.new[0].id];	
			
		accountName = thisContact.account.name;
		accountId = thisContact.account.id;
		contactName = thisContact.Name;
		
		account thisAccount = [select account.name, account.id from account where account.id = :accountId];
        system.debug('OK - in the update trigger');
					//Create the eval contract
				contract newContract = new contract();
				newContract.AccountId = trigger.new[idx].AccountId;
				newContract.StartDate = date.today();
				newContract.EndDate = date.today().AddDays(60);
				newContract.Activation_End_Date_WF__c = date.today().AddDays(60);
				newContract.Contract_Type__c = 'Evaluation';
				newContract.Description = 'EagleEye 30 Day Evaluation - Requested By ' + contactName;
				newcontract.Name = accountName + ' - ' + date.today().year() + '/' + date.today().month() + '/' + date.today().day() + ' EagleEye Eval';
				//newcontract.Original_Contract_Date__c = date.today();
				//newcontract.Original_Contract_Name__c = 'Microsystems Software License Agreement';
				//newcontract.Addendum_Number__c = '1';
				//newcontract.Currency_Type__c = 'US - Dollars';
				newcontract.Contract_Term_Length_Yrs__c = 0;
				insert newContract;
				
				//Create the eval contract's contract product			
				contract_product__c newCP = new contract_product__c();
				newCP.Contract__c = newContract.id;
				newCP.Product__c = 'EagleEye Eval';
				insert newCP;
				
				//set the indicator that we sent the EE eval
				trigger.new[idx].EagleEvalSendRequested__c = True;
				
				//set the EE field on the accont record
				thisAccount.EagleEye_Eval_Requested__c = True;
				update thisAccount;
								
}


		

	}  //End loop










}