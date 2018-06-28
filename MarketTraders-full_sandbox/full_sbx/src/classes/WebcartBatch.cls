/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       3/13/2015
*   Author:             Anthony Malena
*   Last Modified:      2/7/2016
*   Last Modified By:   Sean Murphy
*
*   12/18/15 - sm: modification to doWorkPayments to handle rounding error for price paid
*	2/7/16 - sm: modification to doWorkPayments to improve distribution of sale among products
*   
**********************************************************************************************************************/

/********************************
*
* @description: used to batch process payments from infusionsoft
* 
**/
global class WebcartBatch implements Database.Batchable<integer>, Database.AllowsCallouts, Database.Stateful { //WebcartHelper.webCartItemPayment
	/*
    Here is how to kick off this batch job
    WebcartBatch b = new WebcartBatch(0, WebcartHelper.TBL_SAVED_PAYMENTS); 
    database.executebatch(b, 1);
    */
    global string webCartReportName = '';
    global integer sequenceNumber = 0;
    global boolean moreRecords = false;
    global boolean doProcessRecords = true; //Set this to false if we do not want to process records.   This would be done the first time they are entered.
    global boolean markAsProcessed = false;
    global boolean startDeclineJob = false;

    global WebcartBatch(integer sequenceNumberParam, string reportName) { //string reportName
      	webCartReportName = reportName;
        sequenceNumber = sequenceNumberParam;
    }

    global Iterable<integer> start(Database.BatchableContext info) {  //WebcartHelper.webCartItemPayment
    	if (webCartReportName == webcartHelper.TBL_SAVED_PAYMENTS) {
        	//Uncomment for version 1.1
          	//webCartHelper.doProductPull(); //For version 1.1
       	}
       	return new WebcartBatchIterable(sequenceNumber); //WebcartHelper.INFUSIONSOFT, webCartReportName
    }     

    global void execute(Database.BatchableContext BC, List<integer> scope) { //WebcartHelper.webCartItemPayment
        if (webCartReportName == webcartHelper.TBL_SAVED_PAYMENTS) {
        	doWorkPayments(scope);
        }
        else if (webCartReportName == webcartHelper.TBL_SAVED_DECLINES) {
            doWorkDeclines(scope);
        }    
    } 

    public void doWorkPayments(List<integer> scope) {
        Map<String, Decimal> productIDToAssignAmountMap = new Map<String, Decimal>();
        Integer amtIndex = 0;
        Integer indexCount = 0;
        Integer totalInSet = 0;
        Boolean isMultipleProducts = false;
        Decimal totalPaymentValue = 0;
        Decimal totalProductsValue = 0;
        Decimal specificProductValue = 0;
        Decimal totalSoFar = 0;
        List<WebcartHelper.webCartItemAction> wciList;
        //This is in a loop but there should only be 1 because we cannot do a save of any new Access or Refreh Token between API calls
        List<Webcart_Payment__c> wpList = new List<Webcart_Payment__c>();
        Set<string> paymentIDSet = new Set<string>();
        String productIDs = '';
        List<string> prodIDSplitList = new List<string>();
        Set<string> prodIDSplitSet = new Set<string>();
        Webcart_Payment__c wpItem;
        WebcartHelper.fillProductPriceMap();
        
        for (Integer i : scope) {
        	paymentIDSet = new set<string>();
            wciList = new list<WebcartHelper.webCartItemAction>();
            String xmlBodyResponse = WebcartHelper.callWebCart(WebcartHelper.INFUSIONSOFT, webCartReportName, true, sequenceNumber); //webcartHelper.TBL_SAVED_PAYMENTS
           	WebcartHelper.checkforRefreshTokenSaveNeeded(webCartReportName);
           	//Response with no records: <?xml version="1.0" encoding="UTF-8"?><methodResponse><params><param><value><array><data/></array></value></param></params></methodResponse>
           	if (xmlBodyResponse.contains('<array><data/></array>') || xmlBodyResponse.contains('<methodResponse>') == false) {
            	break; //There is no more data
           	}
           
           	wciList = WebcartHelper.parseWebCartToList(xmlBodyResponse);
           	if (wciList.size() > 0) {
              	moreRecords = true;
              
              	for (WebcartHelper.webCartItemAction wciItem : wciList) {
                  	amtIndex = 0;
                  	isMultipleProducts = false;
                 	//For version 1.1 if there multiples then split and create multiple Webcart_Payment__c rows 
                  	productIDs = wciItem.actionMap.get(WebcartHelper.PMT_FLD_ProductIds); 
                  	if (string.isBlank(productIDs)) {
                    	continue;
                    	//productIDs = '';
                  	}
                  	//else{
                  	//    if (productIDs.contains(',')) {
                 	//         list<string> prodIDSplitSet = productIDs.split(',');
                 	//     productIDs = prodIDSplitSet[0];
                 	//       }  
                 	// }        
                 
                 	if (productIDs.contains(',')) {
                    	isMultipleProducts = true;
                 	}
                  
                  	prodIDSplitList = productIDs.split(',');		// list of products
                  	prodIDSplitSet = new set<string>();
                  	prodIDSplitSet.addAll(prodIDSplitList);			// add products to set
                  	totalSoFar = 0;
                  	Decimal saleBalanceRemaining;
                  	Decimal listBalanceRemaining;
                  	//Compute Amounts
                  	if (isMultipleProducts) {
                      	indexCount = 1;
                      	totalInSet = prodIDSplitList.size();		// number of products
                      	totalPaymentValue = WebcartHelper.convertWebcartValtoDecimal(wciItem.actionMap.get(WebcartHelper.PMT_FLD_PayAmt));	// total payment
                      	totalProductsValue = WebcartHelper.getTotalProductsValue(prodIDSplitSet);		// sum of product prices
						
						saleBalanceRemaining = totalPaymentValue;                      	
                      	listBalanceRemaining = totalProductsValue;
                      	
                      	for (string sProdItem : prodIDSplitList) {
                        	if (indexCount == totalInSet) {
                            	//Assign the rest
                            	specificProductValue = totalPaymentValue - totalSoFar;
                        	}
                        	else {
                            	//Get a percentage for this product 
                            	//aac 10.16.15 added check for totalProductsvalue as 0 to replace with just 0
                            	specificProductValue = (saleBalanceRemaining == 0) ? 0 : saleBalanceRemaining * (WebcartHelper.productIdToPriceMap.get(sProdItem) / listBalanceRemaining);
                            	specificProductValue = specificProductValue.setScale(2);
                            	
                        	}
                        
                        	//This will control to make sure the grand total does not go higher than the total payment
                        	if ((totalSoFar + specificProductValue) > totalPaymentValue) {
                            	specificProductValue = totalPaymentValue - totalSoFar;
                        	}
                        
                        	totalSoFar += specificProductValue;
                        	
                        	saleBalanceRemaining -= specificProductValue;
                        	listBalanceRemaining -= WebcartHelper.productIdToPriceMap.get(sProdItem);
                        	// set the remaining products
                        
                        	productIDToAssignAmountMap.put(sProdItem, specificProductValue);
                      	}
                  	}
                  
                  	/*
                  	//tmpStr = webCartMap.get(WebcartHelper.PMT_FLD_PayAmt); //PMT_FLD_SaleTotal contained negative and 0 dollar values.  Not valid
        			//system.debug('PMT_FLD_PayAmt: ' + tmpStr);
        			decSaleTotalTmp = productPaymentAmount; //convertWebcartValtoDecimal(tmpStr);
        			*/
                  
                  	for (String sProdItem : prodIDSplitList) {
                      	//Put into custom object as save
                      	wpItem = new Webcart_Payment__c();
                      	if (string.isBlank(sProdItem)) {
                        	sProdItem = '99999';
                      	}
                      
                      	wpItem.Product_ID__c = sProdItem;
                      	wpItem.Payment_ID__c = wciItem.actionMap.get(WebcartHelper.PMT_FLD_PaymentId); //WebcartHelper; 'PaymentId'
                      	wpItem.Payment_Product_ID__c = wpItem.Payment_ID__c + '-' + wpItem.Product_ID__c;               
                      	wpItem.Payment_XML__c = wciItem.actionXML;
                      	wpItem.Webcart_Keys_and_Values__c = WebcartHelper.getKeyValuePairsFromMap(wciItem.actionMap);
                      	wpItem.Payment_Date__c = WebcartHelper.convertWebCartStringToDateTime(wciItem.actionMap.get(WebcartHelper.PMT_FLD_Date));
                      	wpItem.Dollar_Amount__c = WebcartHelper.convertWebcartValtoDecimal(wciItem.actionMap.get(WebcartHelper.PMT_FLD_PayAmt));
                      	wpItem.Email_Address__c = wciItem.actionMap.get(WebcartHelper.PMT_FLD_BatchEmailAddress);
                      	wpItem.Payment_Type__c = wciItem.actionMap.get(WebcartHelper.PMT_FLD_PayType);
                      	wpItem.Shipping_Country__c = wciItem.actionMap.get(WebcartHelper.PMT_FLD_ShippingCountry);
                      	wpItem.Billing_Country__c = wciItem.actionMap.get(WebcartHelper.PMT_FLD_BillingCountry);
                      
                      	if (isMultipleProducts) {
                        	wpItem.Product_Payment_Amount__c = productIDToAssignAmountMap.get(sProdItem);
                        	amtIndex += 1;
                      	}
                      	else {
                        	wpItem.Product_Payment_Amount__c = wpItem.Dollar_Amount__c;
                      	}             
                      
                      	if (markAsProcessed) {
                        	wpItem.Processed__c = true;
                        	//wpItem.Last_Process_Attempted__c = dateTime.Now();
                        	wpItem.Processing_Error__c = 'Marked processed as a CATCHUP ONLY - not processed by Integration';
                      	}
                      
                      	if (string.isBlank(wpItem.Payment_Product_ID__c) == false) {
                        	if (paymentIDSet.contains(wpItem.Payment_Product_ID__c) == false) {
                            	wpList.add(wpItem);
                            	paymentIDSet.add(wpItem.Payment_Product_ID__c);
                        	}
                        	else {
                            	system.debug('duplicate payment ID: ' + wpItem.Payment_Product_ID__c);
                        	}                    
                      	}
                      	else {
                        	system.debug('PaymentID blank');
                      	}
                  	}
              	}
        	}         
        } 
        
        if (wpList.size() > 0) {
            upsert wpList Payment_Product_ID__c; //Payment_ID__c
        }
    }
    
    
    public void doWorkDeclines(List<integer> scope) {
        List<WebcartHelper.webCartItemAction> wciList;
        //This is in a loop but there should only be 1 because we cannot do a save of any new Access or Refreh Token between API calls
        List<Webcart_Decline__c> wpList = new List<Webcart_Decline__c>();
        Set<String> declineIDSet = new Set<String>();
        string productIDs = '';
        List<String> prodIDSplitSet = new List<String>();
        Webcart_Decline__c wpItem;
        
		for (integer i : scope) {
        	declineIDSet = new set<string>();
           	wciList = new list<WebcartHelper.webCartItemAction>();
           	String xmlBodyResponse = WebcartHelper.callWebCart(WebcartHelper.INFUSIONSOFT, webCartReportName, true, sequenceNumber); //webcartHelper.TBL_SAVED_PAYMENTS
           	WebcartHelper.checkforRefreshTokenSaveNeeded(webCartReportName);
           	//Response with no records: <?xml version="1.0" encoding="UTF-8"?><methodResponse><params><param><value><array><data/></array></value></param></params></methodResponse>
           	if (xmlBodyResponse.contains('<array><data/></array>')) {
            	break; //There is no more data
           	}
           
           	wciList = WebcartHelper.parseWebCartToList(xmlBodyResponse);
           
           	if (wciList.size() > 0) {
            	moreRecords = true;
              	for (WebcartHelper.webCartItemAction wciItem : wciList) {
                	//For version 1.1 if there multiples then split and create multiple Webcart_Payment__c rows 
                  	productIDs = wciItem.actionMap.get(WebcartHelper.PMT_FLD_ProductIds); 
                  
                  	if (string.isBlank(productIDs)) {
                    	continue;
                    	//productIDs = '';
                  	}
                  	//else{
                  	//    if (productIDs.contains(',')) {
                  	//      list<string> prodIDSplitSet = productIDs.split(',');
                  	//      productIDs = prodIDSplitSet[0];
                  	//    }    
                  	//}                       
                  
                  	prodIDSplitSet = productIDs.split(',');   
                  	for (string sProdItem : prodIDSplitSet) {
                    	//Put into custom object as save
                      	wpItem = new Webcart_Decline__c();
                      	if (string.isBlank(sProdItem)) {
                        	sProdItem = '99999';
                      	}
                      	wpItem.Product_ID__c = sProdItem;
                      	wpItem.Decline_ID__c = wciItem.actionMap.get(WebcartHelper.PMT_FLD_InvoiceId); //WebcartHelper;
                      	wpItem.Decline_Product_ID__c = wpItem.Decline_ID__c + '-' + wpItem.Product_ID__c;
                      	wpItem.Decline_XML__c = wciItem.actionXML;
                      	wpItem.Webcart_Keys_and_Values__c = WebcartHelper.getKeyValuePairsFromMap(wciItem.actionMap);
                      	wpItem.Decline_Date__c = WebcartHelper.convertWebCartStringToDateTime(wciItem.actionMap.get(WebcartHelper.PMT_FLD_Date));
                      	wpItem.Dollar_Amount__c = WebcartHelper.convertWebcartValtoDecimal(wciItem.actionMap.get(WebcartHelper.PMT_FLD_InvTotal));
                      	wpItem.Email_Address__c = wciItem.actionMap.get(WebcartHelper.PMT_FLD_BatchEmailAddress);
                      	wpItem.Billing_Country__c = wciItem.actionMap.get(WebcartHelper.PMT_FLD_BillingCountry);
                      	
                      	if (markAsProcessed) {
                        	wpItem.Processed__c = true;
                        	//wpItem.Last_Process_Attempted__c = dateTime.Now();
                        	wpItem.Processing_Error__c = 'Marked processed as a CATCHUP ONLY - not processed by Integration';
                      	}
                      
                      	if (string.isBlank(wpItem.Decline_Product_ID__c) == false) {
                        	if (declineIDSet.contains(wpItem.Decline_Product_ID__c) == false) {
                            	wpList.add(wpItem);
                            	declineIDSet.add(wpItem.Decline_Product_ID__c);
                        	}
                        	else {
                            	system.debug('duplicate decline ID: ' + wpItem.Decline_Product_ID__c);
                        	}                    
                      	}
                      	else {
                        	system.debug('DeclineID blank');
                      	}
					}   
              	} 
			}         
        } 
        
        if (wpList.size() > 0) {
            system.debug('Count to upsert: ' + wpList.size());
            upsert wpList Decline_Product_ID__c; //Decline_ID__c
        }
    }


    global void finish(Database.BatchableContext BC) {
        if (test.isRunningTest()) {
            moreRecords = false; //We only want to run this once or we get the error Too many async jobs enqueued for this apex test context
        }
        
        if (moreRecords) { //TODO! && false
            WebcartBatch b = new WebcartBatch(sequenceNumber + 1, webCartReportName); 
            b.startDeclineJob = startDeclineJob;
            b.doProcessRecords = doProcessRecords;
            b.markAsProcessed = markAsProcessed;
            database.executebatch(b, 1); //WebcartHelper.getWebCartBatchSize(WebcartHelper.INFUSIONSOFT)
        }
        else {
            //Call batch job to query out the rows and check if they need to be processed
            if (doProcessRecords) {
                WebcartBatchProcess b = new WebcartBatchProcess(webCartReportName); 
                if (startDeclineJob) {
                    b.startDeclineJob = true;
                }
                database.executebatch(b, 1);
                //Maybe bulkify in the future: database.executebatch(b, WebcartHelper.getWebCartBatchSize(WebcartHelper.INFUSIONSOFT));
            }           
        }
    }
}