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
*   3/1/16   - sm: initial development complete
*   4/4/16   - sm: code cleanup and comments
*   
**********************************************************************************************************************/
global with sharing class RocketGateIntegrationHelper {
    
    // inner exception class
    public class RocketGateIntegrationException extends Exception{}
    
    private static String MTI_AUTH_ENDPOINT = 'https://products.markettraders.com/payments/auth';
    private static String MTI_CAPTURE_ENDPOINT = 'https://products.markettraders.com/payments/capture';
    private static String TEST_PURCH_ENDPOINT = 'http://dev.products.markettraders.com/payments/purchase';
    private static String MTI_PURCH_ENDPOINT = 'https://products.markettraders.com/payments/purchase';
    
    /**************************************
    *
    *   @description:
    *   requestAuthorization - assemble payload and callout to RocketGate for authorization
    *  
    **/
    public static RocketGateResponseBody requestPurchase(Payment_Source__c pmtSrc, String acctId, Decimal amount) {

        // ================ AUTHORIZATION ================================================
        
        RocketGateRequestBody requestBody = new RocketGateRequestBody();
        requestBody.addParam('amount',String.valueOf(amount));
        requestBody.addParam('ccNum', pmtSrc.Credit_Card_Number__c);
        requestBody.addParam('cvv', pmtSrc.Credit_Card_CVV__c);
        requestBody.addParam('expMonth', pmtSrc.Credit_Card_Exp_Month__c);
        requestBody.addParam('expYear', pmtSrc.Credit_Card_Exp_Year__c);
        requestBody.addParam('customerId', acctId);
        requestBody.addParam('billingZip', pmtSrc.Billing_Postal_Code__c);
        //requestBody.addParam('bFirstName', acct.FirstName);
        //requestBody.addParam('bLastName', acct.LastName);
        
        System.debug('@@@@ requestParams: ' + requestBody.getParams());
        
        Http h = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(TEST_PURCH_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('content-type','application/json'); 
        req.setBody(requestBody.getParams());
        HTTPResponse resp = h.send(req);
        
        System.debug('@@@@ resp body: ' + resp.getBody());
        
        RocketGateResponseBody rgResp = new RocketGateResponseBody();
        if (resp.getStatusCode() == 200) {
            rgResp = (RocketGateResponseBody)JSON.deserialize(resp.getBody(), RocketGateResponseBody.class);
        }
        
        System.debug('@@@@ gateway response (auth): ' + rgResp);
        
        return rgResp;
    }
    
        
    /**************************************
    *
    *   @description:
    *   requestAuthorization - assemble payload and callout to RocketGate for authorization
    *  
    **/
/*    public static RocketGateResponseBody requestAuthorization(Payment_Source__c pmtSrc, String acctId, Decimal amount) {

        // ================ AUTHORIZATION ================================================
        
        RocketGateRequestBody requestBody = new RocketGateRequestBody();
        requestBody.addParam('amount',String.valueOf(amount));
        requestBody.addParam('ccNum', pmtSrc.Credit_Card_Number__c);
        requestBody.addParam('cvv', pmtSrc.Credit_Card_CVV__c);
        requestBody.addParam('expMonth', pmtSrc.Credit_Card_Exp_Month__c);
        requestBody.addParam('expYear', pmtSrc.Credit_Card_Exp_Year__c);
        requestBody.addParam('customerId', acctId);
        requestBody.addParam('billingZip', pmtSrc.Billing_Postal_Code__c);
        //requestBody.addParam('bFirstName', acct.FirstName);
        //requestBody.addParam('bLastName', acct.LastName);
        
        System.debug('@@@@ requestParams: ' + requestBody.getParams());
        
        Http h = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(MTI_AUTH_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('content-type','application/json'); 
        req.setBody(requestBody.getParams());
        HTTPResponse resp = h.send(req);
        
        System.debug('@@@@ resp body: ' + resp.getBody());
        
        RocketGateResponseBody rgResp = new RocketGateResponseBody();
        if (resp.getStatusCode() == 200) {
            rgResp = (RocketGateResponseBody)JSON.deserialize(resp.getBody(), RocketGateResponseBody.class);
        }
        
        System.debug('@@@@ gateway response (auth): ' + rgResp);
        
        return rgResp;
    }
*/    
    
    /**************************************
    *
    *   @description:
    *   requestCapture - assemble payload and callout to RocketGate for capture
    *  
    **/
/*  private static RocketGateResponseBody requestCapture(String transactionId) {
        RocketGateRequestBody requestBody = new RocketGateRequestBody();
        requestBody.addParam('transactionId', transactionId);
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(MTI_CAPTURE_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('content-type','application/json'); 
        req.setBody(requestBody.getParams());
        HTTPResponse resp = h.send(req);
        
        RocketGateResponseBody rgResp = null;
        if (resp.getStatusCode() == 200) {
            rgResp = (RocketGateResponseBody)JSON.deserialize(resp.getBody(), RocketGateResponseBody.class);
        }
        
        System.debug('gateway response (capt): ' + rgResp);
        
        return rgResp;
    }
*/
    
    
    //============================================================================================================================
    //      SUPPORT CLASSES
    //============================================================================================================================  
    
    
    // response body
    public class RocketGateResponseBody {
        public String success;
        public String responseCode;
        public String authCode;
        public String failReason;
        public String errorText;
        public String transactionId;
        
        public RocketGateResponseBody() {
            success = '';
            responseCode = '';
            authCode = '';
            failReason = '';
            errorText = '';
            transactionId = '';
        }
    }
    
    
    // request body
    public class RocketGateRequestBody {
        
        public Map<String, String> params = new Map<String, String>();
        
        public RocketGateRequestBody() {
        }
        
        public void addParam(String paramKey, String paramVal) {
            if (!params.containsKey(paramKey)) {
                params.put(paramKey, paramVal);
            }
        }
        
        public void removeParam(String paramKey) {
            if (params.containsKey(paramKey)) {
                params.remove(paramKey);
            }
        }
        
        public String getParams() {
            String paramsList = '{';
            for (String paramKey : params.keySet()) {
                paramsList += '"' + paramKey + '":"' + params.get(paramKey) + '",'; 
            }
            
            if (paramsList.length() > 0) {
                paramsList = paramsList.substring(0, paramsList.length() - 1);  // remove trailing comma
            }
            
            paramsList += '}';
            return paramsList;
        }
    }
}