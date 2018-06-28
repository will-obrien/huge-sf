/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MS_CloudServiceActions_TEST {

    static testMethod void myUnitTest() {
        
        
        
        
     	 // Create a new email for registering
   			Messaging.InboundEmail registerEmail = new Messaging.InboundEmail();
   			Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
    		registerEmail.subject = 'Please contact me';
    		registerEmail.fromName = 'Test From Name';
    		registerEmail.plainTextBody = '<action>REGISTER</action><emailAddress>ig88@yahoo.com</emailAddress><MSSecureContactID>a573f7e0-0f94-45c5-a573-6a674b360b38</MSSecureContactID><leadSource>Secure Portal Registration</leadSource><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer = new MS_CloudServiceActions_v2(); 
    		Test.startTest();
            Messaging.InboundEmailResult result = mailer.handleInboundEmail(registerEmail, testEnvelope);
            test.stopTest();
            System.assertEquals (result.success, True);
    }
    	static testMethod void cancelTest() {
    		
    	// Create a new email for cancelling
    		Messaging.InboundEmail cancelEmail = new Messaging.InboundEmail();
   			Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
   			cancelEmail.subject = 'Please contact me';
    		cancelEmail.fromName = 'Test From Name';
    		cancelEmail.plainTextBody = '<action>CANCEL</action><emailAddress>ig88@yahoo.com</emailAddress><MSSecureContactID>a573f7e0-0f94-45c5-a573-6a674b360b38</MSSecureContactID><leadSource>Secure Portal Registration</leadSource><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer = new MS_CloudServiceActions_v2();
    		test.startTest();
    		Messaging.InboundEmailResult result = mailer.handleInboundEmail(cancelEmail, testEnvelope);
    		test.stopTest();
    		System.assertEquals (result.success, True);
    	}
    	
    	static testMethod void updateEUDetail(){
    		//Create a new email for updating contact details- emplyment Unknown acocunt
			Messaging.InboundEmail updateContactEUDetailEmail = new Messaging.InboundEmail();
			Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
   			updateContactEUDetailEmail.subject = 'Please contact me';
    		updateContactEUDetailEmail.fromName = 'Test From Name';
    		updateContactEUDetailEmail.plainTextBody = '<action>UPDATECONTACT</action><MSSecureContactID>a573f7e0-0f94-45c5-a573-6a674b360b34</MSSecureContactID><firstName>Han</firstName><lastName>Solo</lastName><emailAddress>han.solo@gmail.com</emailAddress><accountName>MFalcon</accountName><emailOptOut>True</emailOptOut><userPhone>5551212</userPhone><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer = new MS_CloudServiceActions_v2();
    		test.startTest();
    		Messaging.InboundEmailResult result = mailer.handleInboundEmail(updateContactEUDetailEmail, testEnvelope);
    		test.stopTest();
    		System.assertEquals (result.success, True);
    	}
    	
    	static testMethod void updateDetail(){
    		
    		// Create a new email for updating contact details
    		Messaging.InboundEmail updateContactDetailEmail = new Messaging.InboundEmail();
   			Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
   			updateContactDetailEmail.subject = 'Please contact me';
    		updateContactDetailEmail.fromName = 'Test From Name';
    		updateContactDetailEmail.plainTextBody = '<action>UPDATECONTACT</action><MSSecureContactID>a573f7e0-0f94-45c5-a573-6a674b360b34</MSSecureContactID><firstName>Han</firstName><lastName>Solo</lastName><emailAddress>han.solo@MFalcon.com</emailAddress><accountName>MFalcon</accountName><emailOptOut>True</emailOptOut><userPhone>5551212</userPhone><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer = new MS_CloudServiceActions_v2();
    		test.startTest();
    		Messaging.InboundEmailResult result = mailer.handleInboundEmail(updateContactDetailEmail, testEnvelope);  
    		test.stopTest();
    		System.assertEquals (result.success, True);
    	}
    	
    	static testMethod void evalContractTest(){
    		
    		// Create a new email for eval contract
    		Messaging.InboundEmail createEvalContractEmail = new Messaging.InboundEmail();
   			Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
   			createEvalContractEmail.subject = 'Please contact me';
    		createEvalContractEmail.fromName = 'Test From Name';
    		createEvalContractEmail.plainTextBody = '<action>CREATECONTRACT</action><contractType>EVAL</contractType><MSSecureContactID> a573f7e0-0f94-45c5-a573-6a674b360b34</MSSecureContactID><MSSubscriptionID>d20a006b-79a1-4d59-8c25-cae91f47e988</MSSubscriptionID><contractLength>14</contractLength><amount>150.50</amount><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer = new MS_CloudServiceActions_v2();
    		test.startTest();
    		Messaging.InboundEmailResult result = mailer.handleInboundEmail(createEvalContractEmail, testEnvelope);
    		test.stopTest();
    		System.assertEquals (result.success, True);
    	}
    	static testMethod void individualContractTest() {
    	
    		// Create a new email for INDIVIDUAL contract
    		Messaging.InboundEmail createIndividualContractEmail = new Messaging.InboundEmail();
    		Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
   			createIndividualContractEmail.subject = 'Please contact me';
    		createIndividualContractEmail.fromName = 'Test From Name';
    		createIndividualContractEmail.plainTextBody = '<action>CREATECONTRACT</action><contractType>INDIVIDUAL</contractType><MSSecureContactID> a573f7e0-0f94-45c5-a573-6a674b360b34</MSSecureContactID><MSSubscriptionID> d20a006b-79a1-4d59-8c25-cae91f47e988</MSSubscriptionID><contractLength>90</contractLength><amount>150.50</amount><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount><productFeatures>Defined Terms|References</productFeatures>';
  			MS_CloudServiceActions_v2 mailer = new MS_CloudServiceActions_v2();
    		test.startTest();
    		Messaging.InboundEmailResult result = mailer.handleInboundEmail(createIndividualContractEmail, testEnvelope);
    		test.stopTest();
    		System.assertEquals (result.success, True);
    	}
    	
    	static testMethod void renewalContractTest(){
    		// Create a new email for RENEW contract
    		Messaging.InboundEmail createRenewalContractEmail = new Messaging.InboundEmail();
    		Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
   			createRenewalContractEmail.subject = 'Please contact me';
    		createRenewalContractEmail.fromName = 'Test From Name';
    		createRenewalContractEmail.plainTextBody = '<action>CREATECONTRACT</action><contractType>RENEW</contractType><MSSecureContactID> a573f7e0-0f94-45c5-a573-6a674b360b34</MSSecureContactID><MSSubscriptionID> d20a006b-79a1-4d59-8c25-cae91f47e988</MSSubscriptionID><contractLength>60</contractLength><amount>150.50</amount><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer = new MS_CloudServiceActions_v2();
    		test.startTest();
    		Messaging.InboundEmailResult result = mailer.handleInboundEmail(createRenewalContractEmail, testEnvelope);
    		test.stopTest();
    		System.assertEquals (result.success, True);
}
		static testMethod void groupContractTest(){

    		// Create a new email for GROUP contract
    		Messaging.InboundEmail createGroupContractEmail = new Messaging.InboundEmail();
    		Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
   			createGroupContractEmail.subject = 'Please contact me';
    		createGroupContractEmail.fromName = 'Test From Name';
    		createGroupContractEmail.plainTextBody = '<action>CREATEGROUPCONTRACT</action><MSSubscriptionID> f7a1d143-f9b6-4811-92f5-939371eef360 </MSSubscriptionID><contractLength>360</contractLength><SFAccountID> 001W000000HL4V8IAL</SFAccountID>   <contractType>GROUP</contractType><product>Patent Companion</product><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer = new MS_CloudServiceActions_v2();
    		test.startTest();
    		Messaging.InboundEmailResult result = mailer.handleInboundEmail(createGroupContractEmail, testEnvelope);
    		test.stopTest();
    		System.assertEquals (result.success, True);
		}
		
		static testMethod void associateContractTest(){
			
    		// Create a new email for ASSOCIATETOGROUP contract
    		Messaging.InboundEmail createAssociateToGroupContractEmail = new Messaging.InboundEmail();
    		Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
   			createAssociateToGroupContractEmail.subject = 'Please contact me';
    		createAssociateToGroupContractEmail.fromName = 'Test From Name';
    		createAssociateToGroupContractEmail.plainTextBody = '<action>CREATECONTRACT</action><contractType>GROUP</contractType><MSSecureContactID>a573f7e0-0f94-45c5-a573-6a674b360b34</MSSecureContactID><MSSubscriptionID>f7a1d143-f9b6-4811-92f5-939371eef360</MSSubscriptionID><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer = new MS_CloudServiceActions_v2();
    		test.startTest();
    		//mailer.handleInboundEmail(createAssociateToGroupContractEmail, testEnvelope);
    		Messaging.InboundEmailResult result = mailer.handleInboundEmail(createAssociateToGroupContractEmail, testEnvelope);
    		test.stopTest();
    		System.assertEquals (result.success, True);
    		
   			 }
   			 static testMethod void addDownloadRecordTest(){
   			 	
   			Messaging.InboundEmail addDownloadRequest = new Messaging.InboundEmail();
   			Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
    		addDownloadRequest.subject = 'Please contact me';
    		addDownloadRequest.fromName = 'Test From Name';
    		addDownloadRequest.plainTextBody = '<action>ADDDOWNLOADRECORD</action><emailAddress>taccount2@testaccount.com</emailAddress><MSSecureContactID>a573f7e0-0f94-45c5-a573-6a674b360b45</MSSecureContactID><leadSource>Secure Portal Registration</leadSource><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount><downloadFileName>EagleEyex86.exe</downloadFileName><downloadDateTime>10/23/15</downloadDateTime>';
    		MS_CloudServiceActions_v2 mailer = new MS_CloudServiceActions_v2(); 
    		Test.startTest();
            Messaging.InboundEmailResult result = mailer.handleInboundEmail(addDownloadRequest, testEnvelope);
            test.stopTest();
            System.assertEquals (result.success, True);
   			 	
   			 }
   			 
   			 
   	
   		static testMethod void registerWithExistingAccount (){
   		
   		 account accountTest = new account();
   		 accountTest.name = 'Test Account';
   		 
   		 insert accountTest;

		String accountID = accountTest.id;
				
				   		 
   		 contact testContact1 = new contact();
   		 testContact1.LastName = 'test';
   		 testContact1.Email = 'taccount1@testaccount.com';
   		 testContact1.MSSecureContactID__c = '55';
   		 insert testContact1;
   		 
   		 contract testContract1 = new contract();
   		 testContract1.name = 'test contract';
   		 testContract1.MSSubscriptionID__c = '5';
   		 testContract1.AccountId=accountID;
   		 
   		 insert testContract1;
   		    
   		
   		 
   		 	Messaging.InboundEmail registerWithExistingAccountEmail = new Messaging.InboundEmail();
   			Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
			testEnvelope.toAddress = 'cloudserviceactions@28oli8lb955onl2bepznvirmn2stps7hsyo1z1ernfbpubx4pe.r-1yk33mae.cs2.apex.sandbox.salesforce.com';
		    testEnvelope.fromAddress = 'user@acme.com';
    		registerWithExistingAccountEmail.subject = 'Please contact me';
    		registerWithExistingAccountEmail.fromName = 'Test From Name';
    		registerWithExistingAccountEmail.plainTextBody = '<action>REGISTER</action><emailAddress>taccount2@testaccount.com</emailAddress><MSSecureContactID>a573f7e0-0f94-45c5-a573-6a674b360b45</MSSecureContactID><leadSource>Secure Portal Registration</leadSource><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer7 = new MS_CloudServiceActions_v2(); 
    		Test.startTest();
            Messaging.InboundEmailResult result7 = mailer7.handleInboundEmail(registerWithExistingAccountEmail, testEnvelope);
            System.assertEquals (result7.success, True);
   			
   			// Create a new email for updating contact details
    		Messaging.InboundEmail updateContactDetailEmail2 = new Messaging.InboundEmail();
   			updateContactDetailEmail2.subject = 'Please contact me';
    		updateContactDetailEmail2.fromName = 'Test From Name';
    		updateContactDetailEmail2.plainTextBody = '<action>UPDATECONTACT</action><MSSecureContactID>a573f7e0-0f94-45c5-a573-6a674b360b45</MSSecureContactID><firstName>Test</firstName><lastName>User2</lastName><emailAddress>taccount2@testaccount.com</emailAddress><accountName>Test Account</accountName><emailOptOut>True</emailOptOut><userPhone>5551212</userPhone><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer2 = new MS_CloudServiceActions_v2();
    		Messaging.InboundEmailResult result2 = mailer2.handleInboundEmail(updateContactDetailEmail2, testEnvelope);  
			System.assertEquals (result2.success, True);
			
			Messaging.InboundEmail registerEmail = new Messaging.InboundEmail();
    		registerEmail.subject = 'Please contact me';
    		registerEmail.fromName = 'Test From Name';
    		registerEmail.plainTextBody = '<action>REGISTER</action><emailAddress>taccount1@testaccount.com</emailAddress><MSSecureContactID>a573f7e0-0f94-45c5-a573-6a674b360C21</MSSecureContactID><leadSource>Secure Portal Registration</leadSource><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer3 = new MS_CloudServiceActions_v2(); 
    		Messaging.InboundEmailResult result3 = mailer3.handleInboundEmail(registerEmail, testEnvelope);
        	System.assertEquals (result3.success, True);
   			
   			
   			Messaging.InboundEmail createIndividualContractEmail = new Messaging.InboundEmail();
    		createIndividualContractEmail.subject = 'Please contact me';
    		createIndividualContractEmail.fromName = 'Test From Name';
    		createIndividualContractEmail.plainTextBody = '<action>CREATECONTRACT</action><contractType>INDIVIDUAL</contractType><MSSecureContactID>55</MSSecureContactID><MSSubscriptionID> d20a006b-79a1-4d59-8c25-cae91f47e988</MSSubscriptionID><contractLength>90</contractLength><amount>150.50</amount><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
  			MS_CloudServiceActions_v2 mailer4 = new MS_CloudServiceActions_v2();
    		Messaging.InboundEmailResult result4 = mailer4.handleInboundEmail(createIndividualContractEmail, testEnvelope);
    		System.assertEquals (result4.success, True);
   			
   			
   			Messaging.InboundEmail createGroupContractEmail = new Messaging.InboundEmail();
    		createGroupContractEmail.subject = 'Please contact me';
    		createGroupContractEmail.fromName = 'Test From Name';
    		createGroupContractEmail.plainTextBody = '<action>CREATEGROUPCONTRACT</action><MSSubscriptionID> f7a1d143-f9b6-4811-92f5-939371eef360 </MSSubscriptionID><contractLength>360</contractLength><SFAccountID>' + accountId + '</SFAccountID>   <contractType>GROUP</contractType><product>Patent Companion</product><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer5 = new MS_CloudServiceActions_v2();
			Messaging.InboundEmailResult result5 = mailer5.handleInboundEmail(createGroupContractEmail, testEnvelope);
    		System.assertEquals (result5.success, True);
   			
   			   		Messaging.InboundEmail createRenewalContractEmail = new Messaging.InboundEmail();
 
   			createRenewalContractEmail.subject = 'Please contact me';
    		createRenewalContractEmail.fromName = 'Test From Name';
    		createRenewalContractEmail.plainTextBody = '<action>CREATECONTRACT</action><contractType>RENEW</contractType><MSSecureContactID> a573f7e0-0f94-45c5-a573-6a674b360b45</MSSecureContactID><MSSubscriptionID>5</MSSubscriptionID><contractLength>60</contractLength><amount>150.50</amount><subscriptionExpirationDate>2/3/15</subscriptionExpirationDate><userCount>124</userCount>';
    		MS_CloudServiceActions_v2 mailer6 = new MS_CloudServiceActions_v2();
    		Messaging.InboundEmailResult result6 = mailer6.handleInboundEmail(createRenewalContractEmail, testEnvelope);
    		System.assertEquals (result6.success, True);
   			
   			test.stopTest();
   		}
   		
   			 
}