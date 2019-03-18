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
*   Date Created:       2/26/2016
*   Author:             Sean Murphy
*   Last Modified:      4/4/2016
*   Last Modified By:   Sean Murphy
*
*   2/26/16  - sm: class created
*	3/1/16   - sm: initial development complete
*   4/4/16   - sm: code cleanup and comments
*   
**********************************************************************************************************************/
global without sharing class MockRocketGateResponseGenerator implements HttpCalloutMock {
	
	// HttpMockCallout interface methods
	global HTTPResponse respond(HTTPRequest req) {
		HttpResponse resp = new HttpResponse();
		resp.setBody('{"success":true,"responseCode":"0","authCode":"283023","transactionId":"11000153E405FCDB"}');
		resp.setStatusCode(200);
		return resp;
	}
}