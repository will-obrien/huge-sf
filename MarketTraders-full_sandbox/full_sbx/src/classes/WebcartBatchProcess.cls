global class WebcartBatchProcess implements Database.Batchable<sObject>, Database.Stateful {
	/* How to kick off this batch job
	WebcartBatchProcess b = new WebcartBatchProcess('ReportName'); 
	database.executebatch(b, WebcartHelper.getWebCartBatchSize(WebcartHelper.INFUSIONSOFT));
	*/
	global string webCartReportName = '';
	global boolean startDeclineJob = false;
	global Boolean pullDeclineData = true;

	global WebcartBatchProcess(string reportName) {
		webCartReportName = reportName;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		
		string processingErrorValue = '';
		if(webCartReportName == WebcartHelper.TBL_SAVED_PAYMENTS){
			return Database.getQueryLocator('Select ID, Opportunity__c, Payment_ID__c, Payment_XML__c, Processed__c, ' +
										'Webcart_Keys_and_Values__c, Processing_Error__c, Last_Process_Attempted__c, ' +
										'Account__c, Billing_Country__c, Dollar_Amount__c, Email_Address__c, Payment_Date__c, ' +
										'Payment_Type__c, Shipping_Country__c, Product_ID__c, Payment_Product_ID__c, Product_Payment_Amount__c ' +
										'From Webcart_Payment__c ' +
										'Where Processed__c = false ' +
										'AND Error_Exists__c = false');
		}else if(webCartReportName == WebcartHelper.TBL_SAVED_DECLINES){
			return Database.getQueryLocator('Select ID, Opportunity__c, Decline_ID__c, Decline_XML__c, Processed__c, ' +
										'Webcart_Keys_and_Values__c, Processing_Error__c, Last_Process_Attempted__c, ' +
										'Account__c, Billing_Country__c, Decline_Date__c, Dollar_Amount__c, Email_Address__c, ' +
										'Product_ID__c, Decline_Product_ID__c ' +
										'From Webcart_Decline__c ' +
										'Where Processed__c = false ' +
										'AND Error_Exists__c = false');
		}else{
			string badValue = 'NoValuePresent';
			return Database.getQueryLocator('Select ID, Opportunity__c, Payment_ID__c, Payment_XML__c, Processed__c, ' +
										'Webcart_Keys_and_Values__c, Processing_Error__c, Last_Process_Attempted__c, ' +
										'Account__c, Billing_Country__c, Dollar_Amount__c, Email_Address__c, Payment_Date__c, ' +
										'Payment_Type__c, Shipping_Country__c, Product_ID__c, Payment_Product_ID__c, Product_Payment_Amount__c ' +
										'From Webcart_Payment__c ' +
										'Where Payment_ID__c = :badValue');
		}
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		if(webCartReportName == webcartHelper.TBL_SAVED_PAYMENTS){
   			List<Webcart_Payment__c> scopeToUpdate;
   			scopeToUpdate = doWorkPayments(scope);
   			update scopeToUpdate;
		}else if(webCartReportName == webcartHelper.TBL_SAVED_DECLINES){
			List<Webcart_Decline__c> scopeDeclineToUpdate;
			scopeDeclineToUpdate = doWorkDeclines(scope);
			update scopeDeclineToUpdate;
		}	
		//update scope; //Mark as being processed.
	}
	
	global void finish(Database.BatchableContext BC) {
		system.debug('In Finish WebcartBatchProcess: ' + startDeclineJob);
		if(startDeclineJob) {
			system.debug('In Finish WebcartBatchProcess - Try to start declines job: ' + webCartReportName);
			if(webCartReportName == WebcartHelper.TBL_SAVED_PAYMENTS){
				system.debug('In Finish WebcartBatchProcess - Kick it off!');
				//Kick off Decline job
				if (pullDeclineData) {
					WebcartBatch b = new WebcartBatch(0, WebcartHelper.TBL_SAVED_DECLINES); 
					database.executebatch(b, 1);
				}
				else {
					WebcartBatchProcess wbp = new WebcartBatchProcess(WebcartHelper.TBL_SAVED_DECLINES); 
					database.executebatch(wbp, 1);
				}
			}
		}		
	}

	public List<Webcart_Payment__c> doWorkPayments(List<Webcart_Payment__c> scope){
		List<Webcart_Payment__c> updateList = new List<Webcart_Payment__c>();
		WebcartHelper.webCartItemAction wcipItem;
		Savepoint sp;
		string oppReturnValue = '';
		string webCartProducts = '';
		
		System.debug(LoggingLevel.ERROR, '@@@ number of web payments being processed: ' + scope.size());
		
		for(Webcart_Payment__c wcItem : scope){
			System.debug(LoggingLevel.ERROR, '@@@@ processing error: ' + wcItem.Processing_Error__c);
			
			System.debug(LoggingLevel.ERROR, '@@@@ processing payment with id ' + wcItem.Id);
			if(string.isBlank(wcItem.Processing_Error__c) == false){
				continue; //Do not process rows with errors
			}
			sp = Database.setSavepoint();
			wcItem.Last_Process_Attempted__c = dateTime.Now();
			
			

			try{
				System.debug(LoggingLevel.ERROR, '@@@@ trying...');
				wcipItem = new WebcartHelper.webCartItemAction();
				wcipItem = WebcartHelper.createActionClass(wcItem.Payment_XML__c);
				System.debug(LoggingLevel.ERROR, '@@@@ setting payment date...');
				System.debug(LoggingLevel.ERROR, '@@@@ from action map: ' + wcipItem.actionMap.get(WebcartHelper.PMT_FLD_Date));
				System.debug(LoggingLevel.ERROR, '@@@@ converted: ' + WebcartHelper.convertWebCartStringToDateTime(wcipItem.actionMap.get(WebcartHelper.PMT_FLD_Date)));
				wcItem.Payment_Date__c = WebcartHelper.convertWebCartStringToDateTime(wcipItem.actionMap.get(WebcartHelper.PMT_FLD_Date));
				wcItem.Dollar_Amount__c = WebcartHelper.convertWebcartValtoDecimal(wcipItem.actionMap.get(WebcartHelper.PMT_FLD_PayAmt));
				wcItem.Email_Address__c = wcipItem.actionMap.get(WebcartHelper.PMT_FLD_BatchEmailAddress);
				wcItem.Payment_Type__c = wcipItem.actionMap.get(WebcartHelper.PMT_FLD_PayType);
				wcItem.Shipping_Country__c = wcipItem.actionMap.get(WebcartHelper.PMT_FLD_ShippingCountry);
				wcItem.Billing_Country__c = wcipItem.actionMap.get(WebcartHelper.PMT_FLD_BillingCountry);
				System.debug('@@@@ getting products....');
				webCartProducts = wcipItem.actionMap.get(WebcartHelper.PMT_FLD_ProductIds);	
				if(string.isBlank(webCartProducts) || string.isBlank(wcItem.Product_ID__c)){
					wcItem = setWebCartProcessingValues('Webcart sale has NO PRODUCT ID - skipping', false, wcItem);
					updateList.add(wcItem);
					continue;
				}
				if(string.isBlank(wcItem.Email_Address__c)){
					wcItem = setWebCartProcessingValues('Webcart sale has NO Email Address - skipping', false, wcItem);
					updateList.add(wcItem);
					continue;
				}
				string accountID = WebcartHelper.getAccountIDToUse(wcipItem.actionMap, wcItem.Product_ID__c);			
				oppReturnValue = '';
				//For Version 1.1 we need to add a new Custom Field on Webcart_Payment__c called ProductID and send it as the last param
				
				System.debug(LoggingLevel.ERROR, '@@@@ calling createOppAndChildDocs with account Id: ' + accountId);							// MSM
				System.debug(LoggingLevel.ERROR, '@@@@ calling createOppAndChildDocs with action map: ' + wcipItem.actionMap);					// MSM
				System.debug(LoggingLevel.ERROR, '@@@@ calling createOppAndChildDocs with product Id: ' + wcItem.Product_ID__c);					// MSM
				System.debug(LoggingLevel.ERROR, '@@@@ calling createOppAndChildDocs with payment amt: ' + wcItem.Product_Payment_Amount__c);	// MSM
				
				oppReturnValue = WebcartHelper.createOpportunityAndChildDocs(accountID, wcipItem.actionMap, 
						wcItem.Product_ID__c, wcItem.Product_Payment_Amount__c);
				//if(string.isBlank(oppReturnValue)){
				//	oppReturnValue = '';
				//}
				
				System.debug(LoggingLevel.ERROR, '@@@@ opp return value: ' + oppReturnValue);
				
				if(string.isBlank(oppReturnValue) || oppReturnValue.startsWith(WebcartHelper.PRODUCT_NOT_FOUND)){ //'Error - Product(s) Not Mapped'
					wcItem = setWebCartProcessingValues(oppReturnValue, false, wcItem);
					Database.rollback(sp);
				}else{
					wcItem.Opportunity__c = oppReturnValue;
					wcItem = setWebCartProcessingValues('', true, wcItem);
					if(string.isBlank(accountID) == false){
						wcItem.Account__c = accountID;
					}	
				}
			}catch(exception e){
				Database.rollback(sp);
				wcItem.Processing_Error__c = 'Error in doWorkPayments: ' + e.getMessage();
				wcItem.Error_Exists__c = true;
				system.debug('Error in doWorkPayments: ' + e.getMessage());
			}
			updateList.add(wcItem);
		}
		return updateList;
	}

	@TestVisible
	private Webcart_Payment__c setWebCartProcessingValues(string processingError, boolean processingResult, Webcart_Payment__c wcItem){
		wcItem.Processing_Error__c = processingError;
		if (!String.isBlank(processingError)) {
			wcItem.Error_Exists__c = true;
		}
		wcItem.Processed__c = processingResult;
		return wcItem;
	}

	@TestVisible
	private Webcart_Decline__c setWebCartDeclineProcessingValues(string processingError, boolean processingResult, Webcart_Decline__c wcItem){
		wcItem.Processing_Error__c = processingError;
		wcItem.Processed__c = processingResult;
		return wcItem;
	}

	public List<Webcart_Decline__c> doWorkDeclines(List<Webcart_Decline__c> scope){
		//Need to update the Opportunity
		List<Webcart_Decline__c> updateList = new List<Webcart_Decline__c>();
		WebcartHelper.webCartItemAction wcipItem;
		Savepoint sp;
		string webCartProducts = '';
		for(Webcart_Decline__c wcItem : scope){
			if(string.isBlank(wcItem.Processing_Error__c) == false){
				continue; //Do not process rows with errors
			}
			sp = Database.setSavepoint();
			wcItem.Last_Process_Attempted__c = dateTime.Now();
			try{
				wcipItem = new WebcartHelper.webCartItemAction();
				wcipItem = WebcartHelper.createActionClass(wcItem.Decline_XML__c);
				wcItem.Decline_Date__c = WebcartHelper.convertWebCartStringToDateTime(wcipItem.actionMap.get(WebcartHelper.PMT_FLD_Date));
				wcItem.Dollar_Amount__c = WebcartHelper.convertWebcartValtoDecimal(wcipItem.actionMap.get(WebcartHelper.PMT_FLD_InvTotal));
				wcItem.Email_Address__c = wcipItem.actionMap.get(WebcartHelper.PMT_FLD_BatchEmailAddress);
				wcItem.Billing_Country__c = wcipItem.actionMap.get(WebcartHelper.PMT_FLD_BillingCountry);
				string accountID = WebcartHelper.getOnlyAccountIDToUse(wcipItem.actionMap);
				if(string.isBlank(accountID) || string.isBlank(wcItem.Email_Address__c)){
					wcItem = setWebCartDeclineProcessingValues('Email match not found to link to an account. : ' + wcipItem.actionMap.get(WebcartHelper.PMT_FLD_BatchEmailAddress), false, wcItem);
					updateList.add(wcItem);
					continue;
				}
				//if(IS_VERSION_1_1){
				//For Version 1.1 we need to add a new Custom Field on Webcart_Decline__c called ProductID and use that instead
				webCartProducts = wcItem.Product_ID__c;
				/*
				webCartProducts = wcipItem.actionMap.get(WebcartHelper.PMT_FLD_ProductIds);
				if(string.isBlank(webCartProducts)){
					wcItem = setWebCartDeclineProcessingValues('Webcart decline has NO PRODUCT ID - skipping', false, wcItem);
					updateList.add(wcItem);
					continue;
				}
				*/

				//What will be returned here is the Product_List__c field on the Product2 record. 
				//  We will match this against the Product__c field on the Opportunity
				set<string> priceBookEntryIDSet = WebcartHelper.getPricebookEntryIDSet(webCartProducts);
				if(priceBookEntryIDSet == null || priceBookEntryIDSet.size() == 0){
					wcItem = setWebCartDeclineProcessingValues(WebcartHelper.PRODUCT_NOT_FOUND + 
						wcipItem.actionMap.get(WebcartHelper.PMT_FLD_ProductIds) + WebcartHelper.PRODUCT_NOT_FOUND_END, false, wcItem);
					updateList.add(wcItem);
					continue;
				}

				//Find Opportunity Product that matches
				/*
				list<OpportunityLineItem> oppLIList = new list<OpportunityLineItem>();

				oppLIList = [Select ID, OpportunityID
							From OpportunityLineItem
							Where Opportunity.AccountID = :accountID and 
							        PricebookEntryId = :priceBookEntryIDSet and 
							        Opportunity.Stagename = 'Closed Won'
							Order by Opportunity.CloseDate Desc];
				*/
				list<Opportunity> oppMatchList = new list<Opportunity>();

				system.debug('Before Match on Opp: accountID: ' + accountID);
				system.debug('Before Match on Opp: priceBookEntryIDSet: ' + priceBookEntryIDSet);
				oppMatchList = [Select ID
							From Opportunity
							Where AccountID = :accountID and 
							        Product__c = :priceBookEntryIDSet and 
							        Stagename = 'Closed Won'
							Order by CloseDate Desc];

				if(oppMatchList.size() > 0){
					Opportunity oToUpdate = new Opportunity();
					oToUpdate.ID = oppMatchList[0].ID;
					//oppNew.CloseDate = convertWebCartStringToDate(webCartMap.get(PMT_FLD_Date)); Subscription Latest Billing Decline
					oToUpdate.Subscription_Latest_Billing_Decline__c = WebcartHelper.convertWebCartStringToDate(wcipItem.actionMap.get(WebcartHelper.PMT_FLD_Date)); //Date from the webcart record of the decline payment
					update oToUpdate;
					wcItem.Opportunity__c = oToUpdate.ID;
					wcItem.Account__c = accountID;
				}else{
					wcItem = setWebCartDeclineProcessingValues('Email match not found to link to an existing Closed Won Opportunity.  Email: ' + 
									wcipItem.actionMap.get(WebcartHelper.PMT_FLD_BatchEmailAddress) + '; Account ID: ' + accountID, false, wcItem);
					updateList.add(wcItem);
					continue;
				}

				//Find Opportunity and Update it
				/*
				list<Opportunity> oppList = new list<Opportunity>();
				oppList = [Select ID, CloseDate, StageName, Subscription_Latest_Billing_Decline__c
							From Opportunity
							Where StageName = 'Closed Won'
							Order by CloseDate Desc];
							//TODO: Query by the Product List??
				Opportunity oppToUpdate;
				if(oppList.size() > 0){
					oppToUpdate = oppList[0];
					try{
						oppToUpdate.Subscription_Latest_Billing_Decline__c = date.ValueOf(wbItem.actionMap.get(WebcartHelper.PMT_FLD_Date)); //Date from the webcart record of the decline payment
					}catch(exception e){
						//Do not set the value if it was not valid
					}
				}
				if(oppToUpdate <> null){
					wcItem.Opportunity__c = oppToUpdate.ID;
				}			
				*/	
				wcItem = setWebCartDeclineProcessingValues('', true, wcItem);
			}catch(exception e){
				Database.rollback(sp);
				wcItem.Processing_Error__c = 'Error in doWorkDeclines: ' + e.getMessage();
				wcItem.Error_Exists__c = true;
				system.debug('Error in doWorkDeclines: ' + e.getMessage());
			}
			updateList.add(wcItem);
		}
		return updateList;
		//update scope;

		/*
		list<Webcart_Payment__c> wpList = new list<Webcart_Payment__c>();
		Webcart_Payment__c wpItem;
		string paymentID = ''; 
		string fieldsAndKeys = '';
		string accountID = '';

		for(WebcartHelper.webCartItemAction wbItem : scope){
			//Assume the batch size is 1 at a time!   This is not bulkified and the logic is too complex to bulkify
			
			paymentID = wbItem.actionMap.get(WebcartHelper.PMT_FLD_PaymentId);	
			system.debug(WebcartHelper.PMT_FLD_PaymentId + ': ' + paymentID); 
			if(alreadyProcessedPaymentsSet.contains(paymentID) == false){
				//Process It!    
				wpItem = new Webcart_Payment__c();
				wpItem.Payment_ID__c = paymentID;
				wpItem.Webcart_Keys_and_Values__c = WebcartHelper.getKeyValuePairsFromMap(wbItem.actionMap);
				accountID = WebcartHelper.getAccountIDToUse(wbItem.actionMap, '');
				wpItem.Opportunity__c = WebcartHelper.createOpportunityAndChildDocs(accountID, wbItem.actionMap, '');
				//wpItem.Type__c = webcartHelper.PROCESSED_DECLINE;
				wpList.add(wpItem);

				//Find Opportunity and Update it
				list<Opportunity> oppList = new list<Opportunity>();
				oppList = [Select ID, CloseDate, StageName
							From Opportunity
							Where StageName = 'Closed Won'
							Order by CloseDate Desc];
							//TODO: Query by the Product List??
				Opportunity oppToUpdate;
				if(oppList.size() > 0){
					oppToUpdate = oppList[0];
					try{
						oppToUpdate.Subscription_Latest_Billing_Decline__c = date.ValueOf(wbItem.actionMap.get(WebcartHelper.PMT_FLD_Date)); //Date from the webcart record of the decline payment
					}catch(exception e){
						//Do not set the value if it was not valid
					}
				}
			}
		}
		
		if(wpList.size() > 0){
			insert wpList;
		}
		*/
	}

	/*
	public void doWorkDeclines(List<Webcart_Decline__c> scope){
		//Need to update the Opportunities and Child Object
		set<string> alreadyProcessedPaymentsSet = WebcartHelper.getSetOfDeclinedPayments(scope); 
		system.debug('Already Processed Items: ' + alreadyProcessedPaymentsSet);
		list<Webcart_Payment__c> wpList = new list<Webcart_Payment__c>();
		Webcart_Payment__c wpItem;
		string paymentID = ''; 
		string fieldsAndKeys = '';
		string accountID = '';

		for(WebcartHelper.webCartItemAction wbItem : scope){
			//Assume the batch size is 1 at a time!   This is not bulkified and the logic is too complex to bulkify
			
			paymentID = wbItem.actionMap.get(WebcartHelper.PMT_FLD_PaymentId);	
			system.debug(WebcartHelper.PMT_FLD_PaymentId + ': ' + paymentID); 
			if(alreadyProcessedPaymentsSet.contains(paymentID) == false){
				//Process It!    
				wpItem = new Webcart_Payment__c();
				wpItem.Payment_ID__c = paymentID;
				wpItem.Webcart_Keys_and_Values__c = WebcartHelper.getKeyValuePairsFromMap(wbItem.actionMap);
				accountID = WebcartHelper.getAccountIDToUse(wbItem.actionMap, '');
				wpItem.Opportunity__c = WebcartHelper.createOpportunityAndChildDocs(accountID, wbItem.actionMap, '');
				//wpItem.Type__c = webcartHelper.PROCESSED_DECLINE;
				wpList.add(wpItem);

				//Find Opportunity and Update it
				list<Opportunity> oppList = new list<Opportunity>();
				oppList = [Select ID, CloseDate, StageName
							From Opportunity
							Where StageName = 'Closed Won'
							Order by CloseDate Desc];
							//TODO: Query by the Product List??
				Opportunity oppToUpdate;
				if(oppList.size() > 0){
					oppToUpdate = oppList[0];
					try{
						oppToUpdate.Subscription_Latest_Billing_Decline__c = date.ValueOf(wbItem.actionMap.get(WebcartHelper.PMT_FLD_Date)); //Date from the webcart record of the decline payment
					}catch(exception e){
						//Do not set the value if it was not valid
					}
				}
			}
		}

		if(wpList.size() > 0){
			insert wpList;
		}
	}
	*/

	/*
   		List<WebcartHelper.webCartItemAction> wbiScopeList = new List<WebcartHelper.webCartItemAction>();
   		WebcartHelper.webCartItemAction wciItem;
   		for(sObject sObjItem : scope){
   			wciItem = (WebcartHelper.webCartItemAction)sObjItem;
   			wciItem.Processed__c = true;
   			wbiScopeList.add(wciItem);
   		}
   		*/

	/*
	public void doWork(List<WebcartHelper.webCartItemAction> scope){
		//Need to update the Opportunities and Child Object
		set<string> alreadyProcessedPaymentsSet = WebcartHelper.getSetOfSuccessPayments(scope);
		system.debug('Already Processed Items: ' + alreadyProcessedPaymentsSet);
		list<Webcart_Payment__c> wpList = new list<Webcart_Payment__c>();
		Webcart_Payment__c wpItem;
		string paymentID = ''; 
		string fieldsAndKeys = '';
		string accountID = '';

		for(WebcartHelper.webCartItemAction wbItem : scope){
			paymentID = wbItem.actionMap.get(WebcartHelper.PMT_FLD_PaymentId);	
			system.debug(WebcartHelper.PMT_FLD_PaymentId + ': ' + paymentID); 
			if(alreadyProcessedPaymentsSet.contains(paymentID) == false){
				//Process It!    
				wpItem = new Webcart_Payment__c();
				wpItem.Payment_ID__c = paymentID;
				wpItem.Webcart_Keys_and_Values__c = WebcartHelper.getKeyValuePairsFromMap(wbItem.actionMap);
				accountID = WebcartHelper.getAccountIDToUse(wbItem.actionMap, '');
				wpItem.Opportunity__c = WebcartHelper.createOpportunityAndChildDocs(accountID, wbItem.actionMap, '');
				//wpItem.Type__c = WebcartHelper.PROCESSED_SUCCESS;
				wpList.add(wpItem);
			}
		}

		if(wpList.size() > 0){
			insert wpList;
		}
	}
	*/
	
}