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
*   Date Created:       2/19/2016
*   Author:             Sean Murphy
*   Last Modified:      2/23/2016
*   Last Modified By:   Sean Murphy
*
*   2/19/16 - sm: class created
*	2/23/16 - sm: code cleanup and comments
*   
**********************************************************************************************************************/

@RestResource(urlMapping='/InfusCart/*')
global without sharing class RESTWebcartController {

	@HttpPost
	global static void doProcess(String procType) {
		System.debug('@@@@ going to process as ' + procType + '....');
		if (procType != null) {
			if (procType.toLowerCase().trim() == 'payments') {
				WebcartBatchProcess wbp = new WebcartBatchProcess(WebcartHelper.TBL_SAVED_PAYMENTS); 
				wbp.startDeclineJob = false;															// process payments ONLY
				database.executebatch(wbp, 1);
			}
			else if (procType.toLowerCase() == 'declines') {
				WebcartBatchProcess wbp = new WebcartBatchProcess(WebcartHelper.TBL_SAVED_DECLINES);	// process declines ONLY 
				database.executebatch(wbp, 1);
			}
			else if (procType.toLowerCase() == 'both') {
				WebcartBatchProcess wbp = new WebcartBatchProcess(WebcartHelper.TBL_SAVED_PAYMENTS);	// process payments and declines ONLY
				wbp.startDeclineJob = true;
				wbp.pullDeclineData = false;
				database.executebatch(wbp, 1);
			}
			else if (procType.toLowerCase() == 'products') {
				WebcartPullProducts wpp = new WebcartPullProducts(0, WebcartHelper.TBL_SAVED_PAYMENTS); 
				wpp.startWebcartBatch = false;															// process products ONLY
    			database.executebatch(wpp, 1);
			}
			else if (procType.toLowerCase() == 'all') {
				WebcartPullProducts wpp = new WebcartPullProducts(0, WebcartHelper.TBL_SAVED_PAYMENTS); 
				wpp.doProcessRecords = true;
				wpp.markAsProcessed = false;
				wpp.startWebcartBatch = true;															// process payments after products
			    wpp.startDeclineJob = true;																// process declines after payments
				database.executebatch(wpp, 1);
			}
		}
	}
}