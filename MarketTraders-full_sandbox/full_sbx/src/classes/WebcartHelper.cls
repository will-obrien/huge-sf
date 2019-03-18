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
*   Date Created:       ???
*   Author:             ???
*   Last Modified:      10/20/2015
*   Last Modified By:   Asha Calderon
*
*   10.20.1 aac - added new fields for product2 - Opportunity_RecType__c, Num_Subscription_Days__c, Vertical__c & pb_startdat e_api_name__c 
*    to make webcart more scalable
*   
**********************************************************************************************************************/
global with sharing class WebcartHelper {  
    
    global static final boolean IS_VERSION_1_1 = true;
    global static final string INFUSIONSOFT = 'Infusionsoft';
    global static final string TBL_PAYMENT = 'Payment';
    global static final string TBL_SAVED_PAYMENTS = 'Saved_Payments';
    global static final string TBL_SAVED_DECLINES = 'Saved_Declines';
    global static final string TBL_REPORT_COLUMNS = 'Report_Columns';
    global static final string TBL_QUERY_PRODUCTS = 'Query_Product';
    global static final string PMT_FLD_Id = 'Id';
    global static final string PMT_FLD_ContactId = 'ContactId';
    global static final string PMT_FLD_Company = 'Company';
    global static final string PMT_FLD_FirstName = 'FirstName';
    global static final string PMT_FLD_LastName = 'LastName';
    global static final string PMT_FLD_FullName = 'FullName';
    global static final string PMT_FLD_Phone = 'Phone';
    global static final string PMT_FLD_BatchEmailAddress = 'BatchEmailAddress';
    global static final string PMT_FLD_ShippingAddressType = 'AddressType'; //ShippingAddressType
    global static final string PMT_FLD_ShippingStreetAddress1 = 'Address2Street1'; //ShippingStreetAddress1
    global static final string PMT_FLD_ShippingStreetAddress2 = 'Address2Street2'; //ShippingStreetAddress2
    global static final string PMT_FLD_ShippingCity = 'City2'; //ShippingCity
    global static final string PMT_FLD_ShippingState = 'State2'; //ShippingState
    global static final string PMT_FLD_ShippingZip = 'PostalCode2'; //ShippingZip
    global static final string PMT_FLD_ShippingCountry = 'Country2'; //ShippingCountry
    global static final string PMT_FLD_ReferralPartner = 'ReferralPartner';
    global static final string PMT_FLD_ReferralPartnerId = 'ReferralPartnerId';
    global static final string PMT_FLD_PromoCode = 'PromoCode';
    global static final string PMT_FLD_ProductIds = 'ProductIds';
    global static final string PMT_FLD_SaleTotal = 'SaleTotal';
    global static final string PMT_FLD_PayType = 'PayType'; //This has now been filtered to only be 'Credit Card' on the report side.
    global static final string PMT_FLD_DateSent = 'DateSent';
    global static final string PMT_FLD_Date = 'Date'; 
    global static final string PMT_FLD_PaymentId = 'PaymentId';
    global static final string PMT_FLD_PayAmt = 'PayAmt'; 
    //Added fields with Declines
    global static final string PMT_FLD_InvoiceId = 'InvoiceId';
    global static final string PMT_FLD_Products = 'Products';
    global static final string PMT_FLD_InvTotal = 'InvTotal';
    global static final string PMT_FLD_Sale = 'Sale';
    global static final string PMT_FLD_Name = 'Name';
    global static final string PMT_FLD_AutoCharge = 'AutoCharge';
    global static final string PMT_FLD_Leadsource = 'Leadsource';
    global static final string PMT_FLD_BillingStreetAddress1 = 'StreetAddress1'; //BillingStreetAddress1
    global static final string PMT_FLD_BillingStreetAddress2 = 'StreetAddress2'; //BillingStreetAddress2
    global static final string PMT_FLD_BillingCity = 'City'; //BillingCity
    global static final string PMT_FLD_State = 'State2'; //State
    global static final string PMT_FLD_BillingState = 'State'; //BillingState
    global static final string PMT_FLD_BillingZip = 'PostalCode'; //BillingZip
    global static final string PMT_FLD_BillingCountry = 'Country'; //BillingCountry
    global static final string PROCESSED_SUCCESS = 'Success';
    global static final string PROCESSED_DECLINE = 'Decline';
    global static final string PRODUCT_NOT_FOUND = 'Product ID #';
    global static final string PRODUCT_NOT_FOUND_END = ' not mapped in Salesforce at this time.';

    public static boolean refreshTokenCalled = false;
    public static accessTokenItems atiRefresh;

  /***************************
  * @method: getWebCartBatchSize
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns batch size for the key in webcart custom setting
  *
  **/ 
    public static integer getWebCartBatchSize(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return integer.valueOf(Webcart__c.getInstance(keyName).Batch_Size__c);
        }else{
            return 1;
        }
    }

  /***************************
  * @method: getWebCartPassword
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns Password__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartPassword(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).Password__c;
        }else{
            return '';
        }
    }

  /***************************
  * @method: getWebCartUsername
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns Username__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartUsername(string keyName){ //'Infusionsoft'
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).Username__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: getWebCartRedirectURI
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns Redirect_URI__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartRedirectURI(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).Redirect_URI__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: getWebCartClientID
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns Client_ID__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartClientID(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).Client_ID__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: getWebCartClientSecret
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns Client_Secret__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartClientSecret(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).Client_Secret__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: getWebCartAuthorizationCode
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns Authorization_Code__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartAuthorizationCode(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).Authorization_Code__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: getWebCartAccessToken
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns Access_Token__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartAccessToken(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).Access_Token__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: getWebCartRefreshToken
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns Refresh_Token__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartRefreshToken(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).Refresh_Token__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: getWebCartPaymentsReportNumber
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns PaymentsReportNumber__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartPaymentsReportNumber(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).PaymentsReportNumber__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: getWebCartPaymentsReportUserID
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns PaymentsReportUserId__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartPaymentsReportUserID(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).PaymentsReportUserId__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: getWebCartDeclinesReportNumber
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns DeclinesReportNumber__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartDeclinesReportNumber(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).DeclinesReportNumber__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: getWebCartDeclinesReportUserID
  * @param:  keyName - key for custom setting webcart value 
  * @description: returns DeclinesUserId__c for the key in webcart custom setting
  *
  **/ 
    public static string getWebCartDeclinesReportUserID(string keyName){ 
        if (Webcart__c.getInstance(keyName) != null) {  
            return Webcart__c.getInstance(keyName).DeclinesUserId__c;
        }else{
            return '';
        }
    }
    
  /***************************
  * @method: doProductPull
  * @param:  sequenceNumber
  * @description: gets the data from the callout and determines if response is bad 
  * parses xml data returned from callout
  * processes ~1000 records
  *
  **/ 
    //IS_VERSION_1_1
    public static boolean doProductPull(integer sequenceNumber){
        string xmlBodyResponse = '';
        xmlBodyResponse = callWebCart(INFUSIONSOFT, TBL_QUERY_PRODUCTS, true, sequenceNumber);
        WebcartHelper.checkforRefreshTokenSaveNeeded(INFUSIONSOFT);
        system.debug('Product XML Response: ' + xmlBodyResponse);

        if(xmlBodyResponse.contains('<array><data/></array>') || xmlBodyResponse.contains('<h1>Developer Inactive</h1>')){
          return false; //There is no more data or the token is bad
        }
        if(xmlBodyResponse.contains('<methodResponse>') == false){
            return false; //There is some other error
        }
        integer recordsProcessed = WebcartHelper.parseProductsAndInsert(xmlBodyResponse);
        if(recordsProcessed >= 1000){
            return true;
        }else{
            return false;
        }
        
    }
    
  /***************************
  * @method: parseProductsAndInsert
  * @param: xmlResponseBody - xml string returned from callout 
  * @description:  parses the records from the returned xml puts each product returned into a webcart_product__c record
  * adds the record to a list and returns the number of records inserted
  *
  **/ 
    //Return the number of records inserted
    public static integer parseProductsAndInsert(string xmlResponseBody){
        string dataPart = getValueFromXMLString(xmlResponseBody, 'data');
        //integer uniqueValue = 10000;
        //There can be a thousand values.
        divideString(dataPart, '</struct></value>');
        list<String> paymentList = new list<String>();
        if(allLines <> null){
            paymentList.addAll(allLines);
        }
        webCartItemAction wbi;
        list<Webcart_Product__c> wcProdList = new list<Webcart_Product__c>();
        Webcart_Product__c wcProdItem;

        for(string s : paymentList){
            if(s.startsWith('<value><struct>')){
                s = s.replace('<value><struct>', '');
            }
            wbi = createActionClass(s);
            //Now create the new Webcart_Product__c
            wcProdItem = new Webcart_Product__c();
            wcProdItem.Webcart_Site__c = 'Infusionsoft';
            wcProdItem.Bottom_HTML__c = wbi.actionMap.get('BottomHTML'); //RichText
            wcProdItem.City_Taxable__c = convertWebcartValtoInteger(wbi.actionMap.get('CityTaxable'));
            wcProdItem.Country_Taxable__c = convertWebcartValtoInteger(wbi.actionMap.get('CountryTaxable'));
            //HTML code is not supported in the Salesforce HTML editor. HTML code is treated as text.
            //https://help.salesforce.com/HTViewHelpDoc?id=fields_using_rich_text_area.htm
            wcProdItem.Description__c = wbi.actionMap.get('Description'); //RichText
            wcProdItem.Hide_In_Store__c = convertWebcartValtoInteger(wbi.actionMap.get('HideInStore'));
            wcProdItem.Is_Package__c = convertWebcartValtoInteger(wbi.actionMap.get('IsPackage'));
            wcProdItem.Needs_Digital_Delivery__c = convertWebcartValtoInteger(wbi.actionMap.get('NeedsDigitalDelivery'));
            wcProdItem.Product_Name__c = wbi.actionMap.get('ProductName');
            wcProdItem.Product_Price__c = convertWebcartValtoDecimal(wbi.actionMap.get('ProductPrice'));
            wcProdItem.Shipping_Time__c = wbi.actionMap.get('ShippingTime');
            //Short Description: data value too large: 
            wcProdItem.Short_Description__c = wbi.actionMap.get('ShortDescription');
            wcProdItem.Sku__c = wbi.actionMap.get('Sku');
            wcProdItem.State_Taxable__c = convertWebcartValtoInteger(wbi.actionMap.get('StateTaxable'));
            wcProdItem.Status__c = convertWebcartValtoInteger(wbi.actionMap.get('Status'));
            wcProdItem.Taxable__c = convertWebcartValtoInteger(wbi.actionMap.get('Taxable'));
            wcProdItem.Top_HTML__c = wbi.actionMap.get('TopHTML'); //RichText
            wcProdItem.Weight__c = convertWebcartValtoDecimal(wbi.actionMap.get('Weight'));
            wcProdItem.Shippable__c = convertWebcartValtoInteger(wbi.actionMap.get('Shippable'));
            wcProdItem.Inventory_Limit__c = convertWebcartValtoInteger(wbi.actionMap.get('InventoryLimit'));
            wcProdItem.Inventory_Notifiee__c = wbi.actionMap.get('InventoryNotifiee');
            system.debug('ID Value: ' + wbi.actionMap.get('Id'));
            wcProdItem.Product_ID__c = wbi.actionMap.get('Id'); //convertWebcartValtoInteger(wbi.actionMap.get('Id')); //wbi.actionMap.get('Id');
            if(string.isBlank(wcProdItem.Product_ID__c)){
                //wcProdItem.Product_ID__c = string.ValueOf(uniqueValue);
                //uniqueValue += 1;
            }else{
                wcProdList.add(wcProdItem);
            }
            
        }
        if(wcProdList.size() > 0){
            //insert wcProdList;
            upsert wcProdList Product_ID__c;
            
            //First error: Upsert failed. First exception on row 18; first error: DUPLICATE_VALUE, 
            //  Duplicate external id specified: live forex market trading - subscription: [Product_Name__c]
            
        }
        return paymentList.size();

    }
    
  /***************************
  * @method: callWebCart
  * @param:  webCartName - used to call the custom setting webcart__c which houses the integration data (token, username, etc.)
  * @param:  tableToQuery - determines which table is being accessed from integration compares to static variables for table names
  * @param:  isFirstCall - used for debug and if token is expired
  * @param:  sequenceNumber - integer passed to the xml request method
  * @description: sets up the callout variables and calls the methods to do callout
  *
  **/   
    public static string callWebCart(string webCartName, string tableToQuery, boolean isFirstCall, integer sequenceNumber){
        if(isFirstCall){
            system.debug('callWebCart - Make API call: ' + tableToQuery);
        }else{
            system.debug('callWebCart - get new Access Token - Make API call: ' + tableToQuery);
        }
        
        string apiKey = WebcartHelper.getWebCartClientID(webCartName);
        string accessToken = '';
        if(refreshTokenCalled){
            system.debug('Use New Access Token: ' + atiRefresh.accessToken);
            accessToken = atiRefresh.accessToken;
        }else{
            accessToken = WebcartHelper.getWebCartAccessToken(webCartName);
            system.debug('Use Existing Access Token: ' + accessToken);
        }
        string xmlBody = '';
        //Invoice XML
        //xmlBody = getInvoiceXMLRequest(apiKey); //This one works
        if(tableToQuery == TBL_PAYMENT){
            xmlBody = getPaymentXMLRequest(apiKey);
        }else if(tableToQuery == TBL_SAVED_PAYMENTS){ //getDeclinesXMLRequest
            xmlBody = getPayentsMadeXMLRequest(apiKey, webCartName, string.ValueOf(sequenceNumber));
            //xmlBody = getSavedFilterXMLRequest(apiKey);
        }else if(tableToQuery == TBL_SAVED_DECLINES){
            xmlBody = getDeclinesXMLRequest(apiKey, webCartName, string.ValueOf(sequenceNumber));
        }else if(tableToQuery == TBL_REPORT_COLUMNS){
            xmlBody = getAllReportColumns(apiKey, getWebCartPaymentsReportNumber(webCartName), 
                        getWebCartPaymentsReportUserID(webCartName));
        }else if(tableToQuery == TBL_QUERY_PRODUCTS){
            xmlBody = getProductXMLRequest(apiKey, string.ValueOf(sequenceNumber));
        }else{
            return 'Invalid Table';
        }

        system.debug('XML Body to Send: ' + xmlBody);
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','application/xml'); 
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        req.setHeader('Content-Length',string.valueOf(xmlBody.length()));     
        req.setEndpoint('https://api.infusionsoft.com/crm/xmlrpc/v1?access_token=' + accessToken);
        req.setMethod('POST');
        req.setTimeout(60000);
        req.setBody(xmlBody);
        
        // Send the request, and return a response    
        string bodyValue = '';
        if(test.isRunningTest()){
          //bodyValue = getExampleInvoiceXMLResult();
          if(tableToQuery == TBL_SAVED_DECLINES){
            bodyValue = getExampleDeclineXMLResult();
          }else if(tableToQuery == TBL_QUERY_PRODUCTS){
            bodyValue = getExampleProductXMLResult();
          }else{
            bodyValue = getExamplePaymentXMLResult();
          }       
        }else{
          HttpResponse res = h.send(req);
          bodyValue = res.getBody();
        }

        system.debug('bodyValue response: ' + bodyValue);
        if((bodyValue == '<h1>Developer Inactive</h1>' || bodyValue == '<h1>Not Authorized</h1>') && isFirstCall == true){
            //Get new Access Token using the refresh token
            system.debug('Access Token not valid.  Get another one with Refresh Token');
            refreshTokenCalled = true;
            atiRefresh = new accessTokenItems(); //Create this object and 
            atiRefresh = retrieveWebcartAccessTokenViaRefreshToken(webCartName);
            if(string.isBlank(atiRefresh.accessToken) || string.isBlank(atiRefresh.refreshToken)){
                system.debug('Error getting new access token: ' + atiRefresh.valuetoShow);
                return atiRefresh.valuetoShow;
            }else{
                system.debug('New Access Token via Refresh Token: accessToken: ' + atiRefresh.accessToken);
                system.debug('New Access Token via Refresh Token: refreshToken: ' + atiRefresh.refreshToken);
                system.debug('New Access Token via Refresh Token: expiresIn: ' + atiRefresh.expiresIn);
            }
            
            //Call this same routine again
            return callWebCart(webCartName, tableToQuery, false, sequenceNumber);
        }

        System.debug(bodyValue);

        return bodyValue;
    }
    
  /***************************
  * @innerclass: accessTokenItems
  *
  **/ 
    global class accessTokenItems{
        public string valueToShow{get;set;}
        public string accessToken{get;set;}
        public string refreshToken{get;set;}
        public string expiresIn{get;set;}
        public string scope{get;set;}
        public string bodyResponse{get;set;}
        public boolean isError{get;set;}
    }

    public static boolean doAccessPointError = false;
    
  /***************************
  * @method: retrieveWebcartAccessToken
  * @param: authorizationCode - authorization code for http callout body 
  * @param: webCartName - key for infusionsoft variables stored in webcart__c custom setting
  *
  **/       
    public static accessTokenItems retrieveWebcartAccessToken(string authorizationCode, string webCartName){
        //Now exchange the authorization code for an access token and a refresh token. 
        //This is described at https://developer.infusionsoft.com/docs/read/Getting_Started_With_OAuth2
        accessTokenItems acti = new accessTokenItems();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        string endPointValue = 'https://api.infusionsoft.com/token';    
        req.setEndpoint(endPointValue);
        
        string bodyRequest = '';
        bodyRequest += 'client_id=' + EncodingUtil.urlEncode(WebcartHelper.getWebCartClientID(webCartName), 'UTF-8'); 
        bodyRequest += '&client_secret=' + EncodingUtil.urlEncode(WebcartHelper.getWebCartClientSecret(webCartName), 'UTF-8');
        bodyRequest += '&code=' + EncodingUtil.urlEncode(authorizationCode, 'UTF-8');       
        bodyRequest += '&redirect_uri=' + EncodingUtil.urlEncode(WebcartHelper.getWebCartRedirectURI(webCartName), 'UTF-8'); 
        bodyRequest += '&grant_type=authorization_code';
        system.debug('bodyRequest: ' + bodyRequest);
        req.setBody(bodyRequest);       
        req.setHeader('Content-length', string.ValueOf(bodyRequest.length()));  
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setMethod('POST');
        req.setTimeout(10000);
        if(test.isRunningTest()){
          //bodyValue = getExampleInvoiceXMLResult();
          if(doAccessPointError){
            acti.bodyResponse = '{"error":"failure"}';
          }else{
            acti.bodyResponse = '{"access_token":"9uzfyptnfvgq2j96b3m87z6z","token_type":"bearer","expires_in":28800,"refresh_token":"g4xcffhk6qbgngnxve78cj6t","scope":"full&#124;vk207.infusionsoft.com"}';
          }       
        }else{
          HttpResponse res = h.send(req);
          acti.bodyResponse = res.getBody();
        }
                
        map<string, string> jsonValues = new map<string, string>();     
        system.debug('Response Body: ' + acti.bodyResponse);

        string accessToken = '';
        jsonValues = parseJSONToMap(acti.bodyResponse);
        if(jsonValues.containsKey('error')){
            //Just some debug lines to see the request and response
            acti.valuetoShow = 'Get Access Token Error: ' + acti.bodyResponse + '; end point value: ' + endPointValue + '; request: ' +
                req.toString() + '; request headers: ' + req.getHeader('Content-Type') + '; ' + req.getHeader('charset') + 
                '; request body: ' + req.getBody(); 
            acti.isError = true;        
        }else{
            //Get Values
            /*
            {
                "token_type": "bearer",
                "access_token": "c6lvewpoz8uinazzudt4dayr",
                "expires_in": 3600,
                "refresh_token": "ndpgqhct7gucd8hgbhu6uhbl",
                "scope":"full|example.infusionsoft.com"
            }   
            */
            acti.isError = false;
            acti.accessToken = jsonValues.get('access_token');
            acti.refreshToken = jsonValues.get('refresh_token');
            acti.expiresIn = jsonValues.get('expires_in');
            acti.scope = jsonValues.get('scope');       
            acti.valuetoShow = 'My Access Token is: ' + accessToken;    
        }   
        return acti;    
    }
    
  /***************************
  * @method: retrieveWebcartAccessTokenViaRefreshToken
  * @param:  webCartName - key for infusionsoft variables stored in webcart__c custom setting
  *
  **/ 
    public static accessTokenItems retrieveWebcartAccessTokenViaRefreshToken(string webCartName){
        //Now exchange the refresh token for an access token and a refresh token. 
        //This is described at https://developer.infusionsoft.com/docs/read/Getting_Started_With_OAuth2
        accessTokenItems acti = new accessTokenItems();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        string endPointValue = 'https://api.infusionsoft.com/token';    
        req.setEndpoint(endPointValue);
        
        string bodyRequest = '';
        bodyRequest += 'grant_type=refresh_token'; //refresh_token or authorization_code
        bodyRequest += '&refresh_token=' + EncodingUtil.urlEncode(WebcartHelper.getWebCartRefreshToken(webCartName), 'UTF-8');
        system.debug('bodyRequest: ' + bodyRequest);
        req.setBody(bodyRequest);       
        string authString = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(WebcartHelper.getWebCartClientID(webCartName) + ':' + WebcartHelper.getWebCartClientSecret(webCartName)));
    
        req.setHeader('Authorization', authString); //Base64 Encoded
        req.setHeader('Content-length', string.ValueOf(bodyRequest.length()));  
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setMethod('POST');
        req.setTimeout(10000);
                
        map<string, string> jsonValues = new map<string, string>();
        if(test.isRunningTest()){
          //bodyValue = getExampleInvoiceXMLResult();
          if(doAccessPointError){
            acti.bodyResponse = '{"error":"failure"}';
          }else{
            acti.bodyResponse = '{"access_token":"9uzfyptnfvgq2j96b3m87z6z","token_type":"bearer","expires_in":28800,"refresh_token":"g4xcffhk6qbgngnxve78cj6t","scope":"full&#124;vk207.infusionsoft.com"}';
          }       
        }else{
          HttpResponse res = h.send(req);
          acti.bodyResponse = res.getBody();
        }
        
        system.debug('Response Body: ' + acti.bodyResponse);

        string accessToken = '';
        jsonValues = parseJSONToMap(acti.bodyResponse);
        if(jsonValues.containsKey('error')){
            //Just some debug lines to see the request and response
            acti.valuetoShow = 'Get Access Token from Refresh Token Error: ' + acti.bodyResponse + '; end point value: ' + endPointValue + '; request: ' +
                req.toString() + '; request headers: ' + req.getHeader('Content-Type') + '; ' + req.getHeader('Authorization') + 
                '; request body: ' + req.getBody(); 
            acti.isError = true;        
        }else{
            //Get Values
            /*
            {
                "token_type": "bearer",
                "access_token": "c6lvewpoz8uinazzudt4dayr",
                "expires_in": 3600,
                "refresh_token": "ndpgqhct7gucd8hgbhu6uhbl",
                "scope":"full|example.infusionsoft.com"
            }   
            */
            acti.isError = false;
            acti.accessToken = jsonValues.get('access_token');
            acti.refreshToken = jsonValues.get('refresh_token');
            acti.expiresIn = jsonValues.get('expires_in');
            acti.scope = jsonValues.get('scope');       
            acti.valuetoShow = 'My Access Token is: ' + accessToken;    
        }   
        return acti;    
    }
    
  /***************************
  * @method: parseJSONToMap
  * @param:  JSONValue - used to create JSON parser
  *
  **/ 
    public static map<string, string> parseJSONToMap(string JSONValue){
        JSONParser parser = JSON.createParser(JSONValue);
        map<string, string> jsonMap = new map<string, string>();
        string keyValue = '';
        string tempValue = '';
        while (parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                keyValue = parser.getText();
                parser.nextToken();
                tempValue = parser.getText();
                jsonMap.put(keyValue, tempValue);               
            }
        }
        return jsonMap;
    }

 /***************************
  * @innerclass: webCartItemAction
  *
  **/ 
    //This class will be used to interate through when the Webcart API return values come back
    global class webCartItemAction{
        public map<string, string> actionMap;
        public string actionXML;
    }

 /***************************
  * @method: getKeyValuePairsFromMap
  * @param:  myMap
  *
  **/ 
    public static string getKeyValuePairsFromMap(map<string, string> myMap){
        string tempStr = '';
        for(string s : myMap.keyset()){
            if(tempStr != ''){
                tempStr += '\r\n'; //,
            }
            tempStr += s + ' = ' + myMap.get(s);
        }
        return tempStr;
    }

 /***************************
  * @method: parseWebCartToList
  * @param:  xmlResponseBody - xml response from callout
  * @description: parses through xml and puts into list of payments
  *
  **/ 
    public static list<webCartItemAction> parseWebCartToList(string xmlResponseBody){
        list<webCartItemAction> wciActionList = new list<webCartItemAction>();

        string dataPart = getValueFromXMLString(xmlResponseBody, 'data');

        //There can be a thousand values.
        divideString(dataPart, '</struct></value>');
        list<String> paymentList = new list<String>();
        if(allLines <> null){
            paymentList.addAll(allLines);
        }
    //public void divideString(String input, string breakValue) {
        //divideString(dataPart)
        //Regex too complicated salesforce apex
        //list<String> paymentList = retrieveListBySplit(dataPart, '<value><struct>', '</struct></value>');
        webCartItemAction wbi;

        for(string s : paymentList){
            if(s.startsWith('<value><struct>')){
                s = s.replace('<value><struct>', '');
            }
            wbi = createActionClass(s);
            wciActionList.add(wbi);
        }

        return wciActionList;
    }
 /***************************
  * @method: createActionClass
  * @param:  parseMe
  *
  **/ 
    public static webCartItemAction createActionClass(string parseMe){
        string name = '';
        string value = '';
        list<String> memberList = retrieveListBySplit(parseMe, 'member');
        webCartItemAction wbi = new webCartItemAction();
        wbi.actionMap = new map<string, string>();
        wbi.actionXML = parseMe;
        for(string s2 : memberList){
            system.debug('parsing: ' + s2);
            name = getValueFromXMLString(s2, 'name');
            value = getValueFromXMLString(s2, 'value');
            system.debug('parsing value: ' + value);
            value = getSubValue(value);
            system.debug('parsing value2: ' + value);
            system.debug('parsing name: ' + name);
            wbi.actionMap.put(name, value);
        }
        return wbi;
    }

 /***************************
  * @method: getSubValue
  * @param:  valueToParse
  *
  **/ 
    public static string getSubValue(string valueToParse){
        set<string> subTagSet = new set<string>();
        subTagSet.add('i4'); //integer, number
        subTagSet.add('dateTime.iso8601');
        subTagSet.add('double');
        for(string s : subTagSet){
            if(valueToParse.contains('<' + s + '>')){
                return getValueFromXMLString(valueToParse, s);
            }
        }
        return valueToParse;
    }
  
    //Below here are XML Request values
  
 /***************************
  * @method: getProductXMLRequest
  * @param:  sequenceNumber - variable for the xml request
  * @param:  apiKey - variable for the xml request
  *
  **/ 
    public static string getProductXMLRequest(string apiKey, string sequenceNumber){
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<methodCall>' +
                '<methodName>DataService.query</methodName>' +
                    '<params>' +
                        '<param><value><string>' + apiKey + '</string></value></param>' +
                        '<param><value><string>Product</string></value></param>' + //table
                        '<param><value><int>1000</int></value></param>' + //limit - The number of records to pull (max 1000)
                        '<param><value><int>' + sequenceNumber + '</int></value></param>' + //page 0 is the first page - What page of data to pull (in case there are more than 1000 records). The paging starts with 0
                        '<param><value><struct><member><name>ProductName</name><value><string>%</string></value></member></struct></value></param>' + //Where Clause
                        '<param><value><array><data>' +
                            '<value><string>ProductName</string></value>' + //Fields to bring back
                            '<value><string>Id</string></value>' +
                            '<value><string>ShortDescription</string></value>' +
                            '<value><string>Description</string></value>' +
                            '<value><string>ProductPrice</string></value>' +
                            '<value><string>Sku</string></value>' +
                            '<value><string>Taxable</string></value>' +
                            '<value><string>CountryTaxable</string></value>' +
                            '<value><string>StateTaxable</string></value>' +
                            '<value><string>CityTaxable</string></value>' +
                            '<value><string>Weight</string></value>' +
                            '<value><string>IsPackage</string></value>' +
                            '<value><string>NeedsDigitalDelivery</string></value>' +
                            '<value><string>HideInStore</string></value>' +
                            '<value><string>Status</string></value>' +
                            '<value><string>TopHTML</string></value>' +
                            '<value><string>BottomHTML</string></value>' +
                            '<value><string>ShippingTime</string></value>' +
                            '<value><string>InventoryLimit</string></value>' +
                            '<value><string>InventoryNotifiee</string></value>' +
                            '<value><string>Shippable</string></value>' +
                        '</data></array></value></param>' +
                        '<param><value><string>ProductName</string></value></param>' + //Order By
                        '<param><value><boolean>0</boolean></value></param>' + //1 = Descending
                    '</params>' +
                '</methodCall>';
    }

 /***************************
  * @method: getPaymentXMLRequest
  * @param:  apiKey - variable for the xml request
  *
  **/ 
    public static string getPaymentXMLRequest(string apiKey){
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<methodCall>' +
                '<methodName>DataService.query</methodName>' +
                    '<params>' +
                        '<param><value><string>' + apiKey + '</string></value></param>' +
                        '<param><value><string>Payment</string></value></param>' + //table
                        '<param><value><int>101</int></value></param>' + //limit - The number of records to pull (max 1000)
                        '<param><value><int>0</int></value></param>' + //page 0 is the first page - What page of data to pull (in case there are more than 1000 records). The paging starts with 0
                        '<param><value><struct><member><name>UserId</name><value><string>%</string></value></member></struct></value></param>' + //Where Clause
                        '<param><value><array><data>' +
                            '<value><string>PayDate</string></value>' + //Fields to bring back
                            '<value><string>UserId</string></value>' +
                            '<value><string>PayAmt</string></value>' +
                            '<value><string>PayType</string></value>' +
                            '<value><string>ContactId</string></value>' +
                            '<value><string>PayNote</string></value>' +
                            '<value><string>InvoiceId</string></value>' +
                            '<value><string>RefundId</string></value>' +
                            '<value><string>Commission</string></value>' +
                            '<value><string>Synced</string></value>' +
                        '</data></array></value></param>' +
                        '<param><value><string>PayDate</string></value></param>' + //Order By
                        '<param><value><boolean>1</boolean></value></param>' + //1 = Descending
                    '</params>' +
                '</methodCall>';
    }

 /***************************
  * @method: getSavedFilterXMLRequest
  * @param:  apiKey - variable for the xml request
  *
  **/
    public static string getSavedFilterXMLRequest(string apiKey){
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<methodCall>' +
                '<methodName>DataService.query</methodName>' +
                    '<params>' +
                        '<param><value><string>' + apiKey + '</string></value></param>' +
                        '<param><value><string>SavedFilter</string></value></param>' + //table
                        '<param><value><int>101</int></value></param>' + //limit - The number of records to pull (max 1000)
                        '<param><value><int>0</int></value></param>' + //page 0 is the first page - What page of data to pull (in case there are more than 1000 records). The paging starts with 0
                        '<param><value><struct><member><name>UserId</name><value><string>%</string></value></member></struct></value></param>' + //Where Clause
                        '<param><value><array><data>' +
                            '<value><string>FilterName</string></value>' + //Fields to bring back
                            '<value><string>Id</string></value>' +
                            '<value><string>ReportStoredName</string></value>' +
                            '<value><string>UserId</string></value>' +
                        '</data></array></value></param>' +
                        '<param><value><string>UserId</string></value></param>' + //Order By
                        '<param><value><boolean>1</boolean></value></param>' + //1 = Descending
                    '</params>' +
                '</methodCall>';
    }

 /***************************
  * @method: getPayentsMadeXMLRequest
  * @param:  webCartName - key for infusionsoft variables stored in webcart__c custom setting
  * @param:  apiKey - variable for the xml request 
  * @param:  sequenceNumber - variable for the xml request   
  *
  **/ 
    public static string getPayentsMadeXMLRequest(string apiKey, string webCartName, string sequenceNumber){
        return getReportRequestXMLRequest(apiKey, getWebCartPaymentsReportNumber(webCartName), 
                        getWebCartPaymentsReportUserID(webCartName), sequenceNumber); //148, 150, 120, 122 fail with 0 fail
        //124 with 1 works
        /*
        Response on this one was...
        <?xml version="1.0" encoding="UTF-8"?>
           <methodResponse><fault><value><struct>
           <member>
             <name>faultCode</name>
             <value><i4>3</i4></value>
            </member>
            <member>
             <name>faultString</name>
             <value>[Unexpected]Unable to get saved search results</value>
            </member></struct></value></fault></methodResponse>
        */
        //return getReportRequestXMLRequest(apiKey, '124', '1'); //This one works!
    } 
  
 /***************************
  * @method: getDeclinesXMLRequest
  * @param:  webCartName - key for infusionsoft variables stored in webcart__c custom setting
  * @param:  apiKey - variable for the xml request 
  * @param:  sequenceNumber - variable for the xml request   
  *
  **/     
    public static string getDeclinesXMLRequest(string apiKey, string webCartName, string sequenceNumber){
        return getReportRequestXMLRequest(apiKey, getWebCartDeclinesReportNumber(webCartName), 
                        getWebCartDeclinesReportUserID(webCartName), sequenceNumber);
    }

 /***************************
  * @method: createFieldXML
  * @param:  fieldSet
  *
  **/ 
    public static string createFieldXML(set<string> fieldSet){     
        string xmlValue = '';
        string xmlValues = '';

        for(string s : fieldSet){
            xmlValue = '<value><string>' + s + '</string></value>';
            xmlValues += xmlValue;
        }

        return xmlValues;
    }

 /***************************
  * @method: getFieldSet
  * @param:  savedSearchID
  *
  **/ 
    public static set<string> getFieldSet(string savedSearchID){
        set<string> fieldSet = new set<string>();

        if(savedSearchID == '160'){ //148
            fieldSet.add(PMT_FLD_Id);
            fieldSet.add(PMT_FLD_ContactId);
            fieldSet.add(PMT_FLD_Company);
            fieldSet.add(PMT_FLD_FirstName);
            fieldSet.add(PMT_FLD_LastName);
            fieldSet.add(PMT_FLD_FullName);         
            fieldSet.add(PMT_FLD_Phone);
            fieldSet.add(PMT_FLD_BatchEmailAddress);
            fieldSet.add(PMT_FLD_ShippingAddressType);
            fieldSet.add(PMT_FLD_ShippingStreetAddress1);
            fieldSet.add(PMT_FLD_ShippingStreetAddress2);
            fieldSet.add(PMT_FLD_ShippingCity);
            fieldSet.add(PMT_FLD_ShippingState);
            fieldSet.add(PMT_FLD_ShippingZip);
            fieldSet.add(PMT_FLD_ShippingCountry);
            fieldSet.add(PMT_FLD_ReferralPartner);
            fieldSet.add(PMT_FLD_ReferralPartnerId);
            fieldSet.add(PMT_FLD_PromoCode);
            fieldSet.add(PMT_FLD_ProductIds); //Comma separated list
            //This one returns an error: [DatabaseError]Column not found in resultset:ProductNames
            //http://community.infusionsoft.com/showthread.php/17811-SavedSearch-API-Error-4-Column-not-found-in-resultset-ProductName
            //fieldSet.add('ProductNames');
            fieldSet.add(PMT_FLD_SaleTotal);
            fieldSet.add(PMT_FLD_PayType);
            fieldSet.add(PMT_FLD_DateSent);
            fieldSet.add(PMT_FLD_Date); 
            fieldSet.add(PMT_FLD_PaymentId);
            fieldSet.add(PMT_FLD_PayAmt);
            fieldSet.add(PMT_FLD_BillingCountry);
        }
        if(savedSearchID == '162'){ //150

            fieldSet.add(PMT_FLD_InvoiceId); //InvoiceId
            fieldSet.add(PMT_FLD_Date); 
            //fieldSet.add(PMT_FLD_Products);   //'Products'
            fieldSet.add(PMT_FLD_InvTotal); //'InvTotal'
            fieldSet.add(PMT_FLD_Id);
            fieldSet.add(PMT_FLD_Sale); //'Sale'
            fieldSet.add(PMT_FLD_Name); //'Name'  
            fieldSet.add(PMT_FLD_AutoCharge); //'AutoCharge'
            fieldSet.add(PMT_FLD_FirstName);
            fieldSet.add(PMT_FLD_LastName);
            fieldSet.add(PMT_FLD_BatchEmailAddress);
            fieldSet.add(PMT_FLD_Phone);
            fieldSet.add(PMT_FLD_FullName);         
            fieldSet.add(PMT_FLD_Leadsource); //Leadsource
            fieldSet.add(PMT_FLD_BillingStreetAddress1); //BillingStreetAddress1
            fieldSet.add(PMT_FLD_BillingStreetAddress2); //BillingStreetAddress2
            fieldSet.add(PMT_FLD_BillingCity); //BillingCity
            fieldSet.add(PMT_FLD_State); //State
            fieldSet.add(PMT_FLD_BillingState); //BillingState
            fieldSet.add(PMT_FLD_BillingZip); //BillingZip
            fieldSet.add(PMT_FLD_BillingCountry); //BillingCountry
            fieldSet.add(PMT_FLD_ReferralPartner); //ReferralPartner
            fieldSet.add(PMT_FLD_ReferralPartnerId); //ReferralPartnerId
            fieldSet.add(PMT_FLD_ProductIds); //ProductIds

            /*

            <?xml version="1.0" encoding="UTF-8"?><methodResponse><params><param><value><struct>
                <member><name>Id</name><value>Id</value></member>
                <member><name>InvoiceId</name><value>Invoice Id</value></member>
                <member><name>ContactId</name><value>ContactId</value></member>
                <member><name>Sale</name><value>Sale</value></member>
                <member><name>Description</name><value>Description</value></member>
                <member><name>Name</name><value>Name</value></member>
                <member><name>Company</name><value>Company</value></member>
                <member><name>FirstName</name><value>First Name</value></member>
                <member><name>LastName</name><value>Last Name</value></member>
                <member><name>FullName</name><value>Full Name</value></member>
                <member><name>SpouseName</name><value>Spouse Name</value></member>
                <member><name>Phone</name><value>Phone</value></member>
                <member><name>BatchEmailAddress</name><value>Batch Email Address</value></member>
                <member><name>BillingStreetAddress1</name><value>Billing Street Address 1</value></member>
                <member><name>BillingStreetAddress2</name><value>Billing Street Address 2</value></member>
                <member><name>BillingCity</name><value>Billing City</value></member>
                <member><name>State</name><value>State</value></member>
                <member><name>BillingState</name><value>Billing State</value></member>
                <member><name>BillingZip</name><value>Billing Zip</value></member>
                <member><name>BillingCountry</name><value>Billing Country</value></member>
                <member><name>ShippingAddressType</name><value>Shipping Address Type</value></member>
                <member><name>ShippingStreetAddress1</name><value>Shipping Street Address 1</value></member>
                <member><name>ShippingStreetAddress2</name><value>Shipping Street Address 2</value></member>
                <member><name>ShippingCity</name><value>Shipping City</value></member>
                <member><name>ShippingState</name><value>Shipping State</value></member>
                <member><name>ShippingZip</name><value>Shipping Zip</value></member>
                <member><name>ShippingCountry</name><value>Shipping Country</value></member>
                <member><name>AutoCharge</name><value>Auto Charge</value></member>
                <member><name>ReferralPartner</name><value>Referral Partner</value></member>
                <member><name>ReferralPartnerId</name><value>Referral Partner Id</value></member>
                <member><name>PromoCode</name><value>Promo Code</value></member>
                <member><name>Source</name><value>Source</value></member>
                <member><name>ProductIds</name><value>Product Ids</value></member>
                <member><name>Products</name><value>Products</value></member>
                <member><name>JobClass</name><value>Job Class</value></member>
                <member><name>_Return</name><value>Return</value></member>
                <member><name>InvTotal</name><value>Inv Total</value></member>
                <member><name>Balance</name><value>Balance</value></member>
                <member><name>DateSent</name><value>Date Sent</value></member>
                <member><name>Date</name><value>Date</value></member>
                <member><name>LeadsourceId</name><value>Leadsource Id</value></member>
                <member><name>Leadsource</name><value>Leadsource</value></member>
                <member><name>Tags</name><value>Tag Ids</value></member>
                <member><name>Custom_ContactUsComments</name><value>Contact Us Comments</value></member>
                <member><name>Custom_RefundFormInfo</name><value>Refund Form Info</value></member>
                <member><name>Custom_RefundInfoForm2</name><value>Refund Info Form 2</value></member>
                <member><name>Custom_LeadSourceDetails</name><value>Lead Source Details</value></member>
                <member><name>Custom_SubscriptionEndDate</name><value>Subscription End Date</value></member>
                <member><name>Custom_channel</name><value>Channel</value></member>
                <member><name>Custom_channelid</name><value>Channel_id</value></member>
                <member><name>Custom_AppointmentCoreContactID</name><value>AppointmentCore Contact ID</value></member>
            </struct></value></param></params></methodResponse>
            */
        }
        return fieldSet;
    }

 /***************************
  * @method: getAllReportColumns
  * @param:  apiKey - variable for xml request api key
  * @param:  savedSearchID - variable for xml request Saved Search ID
  * @param:  userID - variable for xml request userID
  *
  **/ 
    public static string getAllReportColumns(string apiKey, string savedSearchID, string userID){
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<methodCall>' +
                '<methodName>SearchService.getAllReportColumns</methodName>' +
                    '<params>' +
                        '<param><value><string>' + apiKey + '</string></value></param>' + //apiKey
                        '<param><value><int>' + savedSearchID + '</int></value></param>' + //Saved Search ID
                        '<param><value><int>' + userID + '</int></value></param>' + //userID
                    '</params>' +
                '</methodCall>';         
    }

 /***************************
  * @method: getReportRequestXMLRequest
  * @param:  savedSearchID - variable for xml request Saved Search ID
  * @param:  apiKey - variable for xml request api key
  * @param:  sequenceNumber - variable for xml request page number
  * @param:  userID - variable for xml request userID
  *
  **/ 
    public static string getReportRequestXMLRequest(string apiKey, string savedSearchID, string userID, string sequenceNumber){
        
        //This works with 142, 384
        string fieldValues = createFieldXML(getFieldSet(savedSearchID));
        
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<methodCall>' +
                '<methodName>SearchService.getSavedSearchResults</methodName>' +
                    '<params>' +
                        '<param><value><string>' + apiKey + '</string></value></param>' + //apiKey
                        '<param><value><int>' + savedSearchID + '</int></value></param>' + //Saved Search ID
                        '<param><value><int>' + userID + '</int></value></param>' + //userID
                        '<param><value><int>'+ sequenceNumber + '</int></value></param>' + //page number
                        '<param><value><array><data>' +
                            fieldValues +
                            //'<value><string>Id</string></value>' + //Fields for report
                            //'<value><string>ContactId</string></value>' +
                        '</data></array></value></param>' +
                    '</params>' +
                '</methodCall>';
        

        //This works with 142, 384
        //[DatabaseError]Column not found in resultset:ProductNames
        //Does it need to be Product Names?
        /*
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<methodCall>' +
                '<methodName>SearchService.getSavedSearchResultsAllFields</methodName>' +
                    '<params>' +
                        '<param><value><string>' + apiKey + '</string></value></param>' + //apiKey
                        '<param><value><int>' + savedSearchID + '</int></value></param>' + //Saved Search ID
                        '<param><value><int>' + userID + '</int></value></param>' + //userID
                        '<param><value><int>0</int></value></param>' + //page number
                    '</params>' +
                '</methodCall>';
        */  
        //This returns the available report columns.  It does not return any rows of values
        
    }

 /***************************
  * @method: getInvoiceXMLRequest
  * @param:  apiKey - variable for xml request api key
  *
  **/ 
    public static string getInvoiceXMLRequest(string apiKey){
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<methodCall>' +
                '<methodName>DataService.query</methodName>' +
                '<params>' +
                    '<param><value><string>' + apiKey + '</string></value></param>' +
                    '<param><value><string>Invoice</string></value></param>' + //table
                    '<param><value><int>22</int></value></param>' + //limit - The number of records to pull (max 1000)
                    '<param><value><int>0</int></value></param>' + //page 0 is the first page - What page of data to pull (in case there are more than 1000 records). The paging starts with 0
                    '<param>' + //Query Where Clause "ContactID = 23"
                        '<value><struct><member><name>ContactId</name><value><string>23</string></value></member></struct></value>' +
                    '</param>' +
                    '<param>' + //Array of fields to return
                        '<value>' +
                         '<array>' +
                            '<data>' +
                                '<value><string>ContactId</string></value>' +
                                '<value><string>JobId</string></value>' +
                            '</data>' +
                         '</array>' +
                        '</value>' +
                    '</param>' +
                    '<param>' + ////Order by
                        '<value><string>JobId</string></value>' + 
                    '</param>' +
                    '<param>' + //Ascending/Descending 0 = Ascending; 1 = Descending
                        '<value><boolean>0</boolean></value>' +
                    '</param>' +
                '</params>' +
            '</methodCall>';
    }

 /***************************
  * @method: getExampleSavedFilterXMLResult
  *
  **/ 
    public static string getExampleSavedFilterXMLResult(){
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<methodResponse><params><param><value><array><data>' +
               '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>AdvContactSearch</value></member>' +
                 '<member><name>FilterName</name><value>Hot Leads</value></member>' +
                 '<member><name>Id</name><value><i4>120</i4></value></member>' +
                 '<member><name>UserId</name><value>0</value></member>' +
               '</struct></value>' +
               '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>AdvContactSearch</value></member>' +
                 '<member><name>FilterName</name><value>Hot Leads 1</value></member>' +
                 '<member><name>Id</name><value><i4>122</i4></value></member>' +
                 '<member><name>UserId</name><value>0</value></member>' +
               '</struct></value>' +
               '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>AdvContactSearch</value></member>' +
                 '<member><name>FilterName</name><value>Import - 12/08/2014 10:06 AM</value></member>' +
                 '<member><name>Id</name><value><i4>136</i4></value></member>' +
                 '<member><name>UserId</name><value>0</value></member>' +
               '</struct></value>' +
               '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>AdvContactSearch</value></member>' +
                 '<member><name>FilterName</name><value>Import - 12/08/2014 2:57 PM</value></member>' +
                 '<member><name>Id</name><value><i4>138</i4></value></member>' +
                 '<member><name>UserId</name><value>0</value></member>' +
               '</struct></value>' +
               '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>LeadSourceIncome</value></member>' +
                 '<member><name>FilterName</name><value>Orders by Lead Source</value></member>' +
                 '<member><name>Id</name><value><i4>144</i4></value></member>' +
                 '<member><name>UserId</name><value>0,</value></member>' +
               '</struct></value>' +
               '<value><struct>' +  //THIS IS THE FIRST REPORT TO GET ALL PAYMENTS MADE - https://vk207.infusionsoft.com/Reports/searchTemplate.jsp?filterId=148&reportClass=PaymentsReport
                 '<member><name>ReportStoredName</name><value>PaymentsReport</value></member>' +
                 '<member><name>FilterName</name><value>Payment Report Processing Admin v1</value></member>' +
                 '<member><name>Id</name><value><i4>148</i4></value></member>' + //<h1>Not Authorized</h1>
                 '<member><name>UserId</name><value>0,</value></member>' +
               '</struct></value>' +
               '<value><struct>' +   //THIS IS THE SECOND REPORT TO GET ALL DECLINES - https://vk207.infusionsoft.com/Reports/searchTemplate.jsp?filterId=150&reportClass=AllSales
                 '<member><name>ReportStoredName</name><value>AllSales</value></member>' +
                 '<member><name>FilterName</name><value>Decline Report Processing Admin v1</value></member>' +
                 '<member><name>Id</name><value><i4>150</i4></value></member>' + //[Unexpected]Unable to get saved search results
                 '<member><name>UserId</name><value>0,</value></member>' +
               '</struct></value>' +
               '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>AllSales</value></member>' +
                 '<member><name>FilterName</name><value>Daily Manual Sale Processing Report v1</value></member>' +
                 '<member><name>Id</name><value><i4>124</i4></value></member>' + //Works
                 '<member><name>UserId</name><value>1,</value></member>' +
               '</struct></value>' +
               '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>AdvContactSearch</value></member>' +
                 '<member><name>FilterName</name><value>All Orders</value></member>' +
                 '<member><name>Id</name><value><i4>126</i4></value></member>' + //Works
                 '<member><name>UserId</name><value>1,</value></member>' +
                '</struct></value>' +
                '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>OrderSearch</value></member>' +
                 '<member><name>FilterName</name><value>Orders - Today</value></member>' +
                 '<member><name>Id</name><value><i4>140</i4></value></member>' +
                 '<member><name>UserId</name><value>1,</value></member>' +
                '</struct></value>' +
                '<value><struct><member><name>ReportStoredName</name><value>AllSales</value></member>' +
                 '<member><name>FilterName</name><value>Daily Manual Sale Processing Report v2</value></member>' +
                 '<member><name>Id</name><value><i4>146</i4></value></member>' +
                 '<member><name>UserId</name><value>1,</value></member>' +
                '</struct></value>' +
                '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>AllSales</value></member>' +
                 '<member><name>FilterName</name><value>All Sales</value></member>' +
                 '<member><name>Id</name><value><i4>152</i4></value></member>' +
                 '<member><name>UserId</name><value>1,</value></member>' +
                '</struct></value>' +
                '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>AdvContactSearch</value></member>' +
                 '<member><name>FilterName</name><value>EGFX Contacts (Today)</value></member>' +
                 '<member><name>Id</name><value><i4>158</i4></value></member>' +  //Works
                 '<member><name>UserId</name><value>16448,</value></member>' +
                '</struct></value>' +
                '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>AdvContactSearch</value></member>' +
                 '<member><name>FilterName</name><value>Contacts_Source</value></member>' +
                 '<member><name>Id</name><value><i4>142</i4></value></member>' + //works
                 '<member><name>UserId</name><value>384,</value></member>' +
                '</struct></value>' +
                '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>PaymentsReport</value></member>' +
                 '<member><name>FilterName</name><value>Jose Baerga</value></member>' +
                 '<member><name>Id</name><value><i4>154</i4></value></member>' + //works
                 '<member><name>UserId</name><value>384,</value></member>' +
                '</struct></value>' +
                '<value><struct>' +
                 '<member><name>ReportStoredName</name><value>PaymentsReport</value></member>' +
                 '<member><name>FilterName</name><value>EGFX Sales</value></member>' +
                 '<member><name>Id</name><value><i4>156</i4></value></member>' + //works
                 '<member><name>UserId</name><value>384,</value></member>' +
                '</struct></value>' +
              '</data></array></value></param></params></methodResponse>';

    }

 /***************************
  * @method: getExampleDeclineXMLResult
  *
  **/ 
    public static string getExampleDeclineXMLResult(){
        return '<?xml version="1.0" encoding="UTF-8"?><methodResponse><params><param><value><array><data><value><struct>' +
                '<member><name>Id</name><value><i4>8046</i4></value></member>' +
                '<member><name>InvoiceId</name><value><i4>8046</i4></value></member>' +
                '<member><name>Sale</name><value>Order Form</value></member>' +
                '<member><name>Name</name><value>Test Test</value></member>' +
                '<member><name>FirstName</name><value>Test</value></member>' +
                '<member><name>LastName</name><value>Test</value></member>' +
                '<member><name>FullName</name><value>Test Test</value></member>' +
                '<member><name>Phone</name><value></value></member>' +
                '<member><name>BatchEmailAddress</name><value>test@test.com</value></member>' +
                '<member><name>BillingStreetAddress1</name><value>Test</value></member>' +
                '<member><name>BillingCity</name><value>Test</value></member>' +
                '<member><name>BillingState</name><value>test</value></member>' +
                '<member><name>BillingZip</name><value>test</value></member>' +
                '<member><name>BillingCountry</name><value>United States</value></member>' +
                '<member><name>AutoCharge</name><value><i4>1</i4></value></member>' +
                '<member><name>ReferralPartner</name><value>BE_Webinars</value></member>' +
                '<member><name>ReferralPartnerId</name><value><i4>28</i4></value></member>' +
                '<member><name>ProductIds</name><value>2</value></member>' +
                '<member><name>InvTotal</name><value><double>597.0</double></value></member>' +
                '<member><name>Date</name><value><dateTime.iso8601>20150309T11:39:19</dateTime.iso8601></value></member>' +
                '<member><name>Leadsource</name><value>www.markettraders.com</value></member>' +
                '</struct></value></data></array></value></param></params></methodResponse>';
    }

 /***************************
  * @method: getExampleProductXMLResult
  *
  **/ 
    public static string getExampleProductXMLResult(){
        return '<?xml version="1.0" encoding="UTF-8"?>' +
                '<methodResponse><params><param><value><array><data>' +
                  '<value><struct>' +
                      '<member><name>ShortDescription</name><value>This offer is no longer available. </value></member>' +
                      '<member><name>Status</name><value><i4>1</i4></value></member>' +
                      '<member><name>Id</name><value>2</value></member>' +
                      '<member><name>CityTaxable</name><value><i4>0</i4></value></member>' +
                      '<member><name>HideInStore</name><value><i4>0</i4></value></member>' +
                      '<member><name>Weight</name><value><double>0.0</double></value></member>' +
                      '<member><name>IsPackage</name><value><i4>0</i4></value></member>' +
                      '<member><name>Taxable</name><value><i4>0</i4></value></member>' +
                      '<member><name>StateTaxable</name><value><i4>0</i4></value></member>' +
                      '<member><name>NeedsDigitalDelivery</name><value><i4>1</i4></value></member>' +
                      '<member><name>ProductName</name><value>VIP Trading Challenge - March 9th</value></member>' +
                      '<member><name>ProductPrice</name><value><double>0.0</double></value></member>' +
                      '<member><name>CountryTaxable</name><value><i4>0</i4></value></member>' +
                  '</struct></value>' +
                  '<value><struct>' +
                      '<member><name>ShortDescription</name><value>This offer is no longer available. </value></member>' +
                      '<member><name>Status</name><value><i4>0</i4></value></member>' +
                      '<member><name>Id</name><value>4</value></member>' +
                      '<member><name>CityTaxable</name><value><i4>0</i4></value></member>' +
                      '<member><name>HideInStore</name><value><i4>0</i4></value></member>' +
                      '<member><name>Weight</name><value><double>0.0</double></value></member>' +
                      '<member><name>IsPackage</name><value><i4>0</i4></value></member>' +
                      '<member><name>Taxable</name><value><i4>0</i4></value></member>' +
                      '<member><name>StateTaxable</name><value><i4>0</i4></value></member>' +
                      '<member><name>NeedsDigitalDelivery</name><value><i4>1</i4></value></member>' +
                      '<member><name>ProductName</name><value>VIP Trading Challenge </value></member>' +
                      '<member><name>ProductPrice</name><value><double>1000.0</double></value></member>' +
                      '<member><name>CountryTaxable</name><value><i4>0</i4></value></member>' +
                  '</struct></value>' +
                  '<value><struct>' +
                      '<member><name>Description</name><value>&lt;p&gt;&lt;span data-sheets-value="[null,2,&amp;quot;-Pre-Buy and Pre-Sell Conditions to easily plan trade\n\n-Pre-Determined Risk:Reward to help you decide if it fits your equity management guidelines \n\n-Customize your scanning time frames to fit your trading style (short-term for scalping, mid-term for swings, long-term for position trading)\n\n-Create watch lists for your favorite Forex Pairs (Majors, Exotics, Low-Volatility, High-Volatility, Trending vs. Non-Trending)&amp;quot;]" data-sheets-userformat="[null,null,513,[null,0],null,null,null,null,null,null,null,null,0]"&gt;-Pre-Buy and Pre-Sell Conditions to easily plan trade&lt;br /&gt;&lt;br /&gt;-Pre-Determined Risk:Reward to help you decide if it fits your equity management guidelines &lt;br /&gt;&lt;br /&gt;-Customize your scanning time frames to fit your trading style (short-term for scalping, mid-term for swings, long-term for position trading)&lt;br /&gt;&lt;br /&gt;-Create watch lists for your favorite Forex Pairs (Majors, Exotics, Low-Volatility, High-Volatility, Trending vs. Non-Trending)&lt;/span&gt;&lt;/p&gt;</value></member>' +
                      '<member><name>ShortDescription</name><value>6 months of MTI\'s latest revolution in trading technology, the Ultimate Market Scanner. Gain exclusive access to the software that scans the market\'s pairs for you and identifies key trade set ups with a few clicks of a mouse. </value></member>' +
                      '<member><name>Sku</name><value>UMS6m</value></member>' +
                      '<member><name>Status</name><value><i4>0</i4></value></member>' +
                      '<member><name>Id</name><value>6</value></member>' +
                      '<member><name>CityTaxable</name><value><i4>0</i4></value></member>' +
                      '<member><name>HideInStore</name><value><i4>0</i4></value></member>' +
                      '<member><name>Weight</name><value><double>0.0</double></value></member>' +
                      '<member><name>IsPackage</name><value><i4>0</i4></value></member>' +
                      '<member><name>Taxable</name><value><i4>0</i4></value></member>' +
                      '<member><name>StateTaxable</name><value><i4>0</i4></value></member>' +
                      '<member><name>NeedsDigitalDelivery</name><value><i4>1</i4></value></member>' +
                      '<member><name>ProductName</name><value>VIP Trading Challenge </value></member>' +
                      '<member><name>ProductPrice</name><value><double>1000.0</double></value></member>' +
                      '<member><name>CountryTaxable</name><value><i4>0</i4></value></member>' +
                  '</struct></value>' +
                '</data></array></value></param></params></methodResponse>';
    }

 /***************************
  * @method: getExamplePaymentXMLResult
  *
  **/ 
    public static string getExamplePaymentXMLResult(){
        return '?xml version="1.0" encoding="UTF-8"?>' +
            '<methodResponse><params><param><value><array><data><value><struct>' +
                '<member><name>Phone</name><value>44 0742124634</value></member>' +
                '<member><name>ShippingStreetAddress2</name><value>Hounslow</value></member>' +
                '<member><name>ShippingStreetAddress1</name><value>60 Brabazon Road</value></member>' +
                '<member><name>PromoCode</name><value>Unknown</value></member>' +
                '<member><name>ShippingZip</name><value>TW5 9LT</value></member>' +
                '<member><name>ShippingState</name><value>Middlesex</value></member>' +
                '<member><name>ShippingAddressType</name><value></value></member>' +
                '<member><name>ProductIds</name><value>2</value></member>' +  
                '<member><name>LastName</name><value>Rebensteigerova</value></member>' +
                '<member><name>SaleTotal</name><value><double>147.0</double></value></member>' +
                '<member><name>Date</name><value><dateTime.iso8601>20150214T03:23:00</dateTime.iso8601></value></member>' +
                '<member><name>DateSent</name><value></value></member>' +
                '<member><name>ReferralPartnerId</name><value><i4>0</i4></value></member>' +
                '<member><name>FullName</name><value>Ms Libuse Rebensteigerova</value></member>' +
                '<member><name>BatchEmailAddress</name><value>1ocerbil@gmail.com</value></member>' +
                '<member><name>ShippingCity</name><value>London</value></member>' +
                '<member><name>FirstName</name><value>Ms Libuse</value></member>' +
                '<member><name>Id</name><value><i4>5290</i4></value></member>' +
                '<member><name>ContactId</name><value><i4>258</i4></value></member>' +
                '<member><name>Company</name><value></value></member>' +
                '<member><name>PayType</name><value>Credit Card</value></member>' +
                '<member><name>ReferralPartner</name><value>No Referral Partner</value></member>' +
                '<member><name>PaymentId</name><value><i4>5016</i4></value></member>' +
                '<member><name>PayAmt</name><value><double>1.0</double></value></member>' +
            '</struct></value></data></array></value></param></params></methodResponse>';
    }

 /***************************
  * @method: getExamplePaymentXMLResult2
  *
  **/ 
    public static string getExamplePaymentXMLResult2(){
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<methodResponse>' +
             '<params>' +
              '<param>' +
               '<value>' +
                '<array>' +
                 '<data>' +
                  '<value>' +
                   '<struct>' +
                    '<member>' +
                     '<name>Commission</name>' +
                     '<value><i4>0</i4></value>' +
                    '</member>' +
                    '<member>' +
                     '<name>RefundId</name>' +
                     '<value><i4>0</i4></value>' +
                    '</member>' +
                    '<member>' +
                     '<name>PayNote</name>' +
                     '<value>Invoice Ids: 2</value>' +
                    '</member>' +
                    '<member>' +
                     '<name>InvoiceId</name>' +
                     '<value>2</value>' +
                    '</member>' +
                    '<member>' +
                     '<name>ContactId</name>' +
                     '<value><i4>6</i4></value>' +
                    '</member>' +
                    '<member>' +
                     '<name>UserId</name>' +
                     '<value><i4>0</i4></value>' +
                    '</member>' +
                    '<member>' +
                     '<name>PayAmt</name>' +
                     '<value><double>1.0</double></value>' +
                    '</member>' +
                    '<member>' +
                     '<name>PayType</name>' +
                     '<value>Credit Card</value>' +
                    '</member>' +
                    '<member>' +
                     '<name>PayDate</name>' +
                     '<value><dateTime.iso8601>20141009T12:45:55</dateTime.iso8601></value>' +
                    '</member>' +
                    '<member>' +
                     '<name>Synced</name>' +
                     '<value><boolean>0</boolean></value>' +
                    '</member>' +
                   '</struct>' +
                  '</value>' +
                  '<value><struct><member><name>Commission</name><value><i4>0</i4></value></member>' +
                   '<member><name>RefundId</name><value><i4>0</i4></value></member>' +
                   '<member><name>PayNote</name><value>Invoice Ids: 4</value></member>' +
                   '<member><name>InvoiceId</name><value>4</value></member>' +
                   '<member><name>ContactId</name><value><i4>10</i4></value></member>' +
                   '<member><name>UserId</name><value><i4>0</i4></value></member>' +
                   '<member><name>PayAmt</name><value><double>1.0</double></value></member>' +
                   '<member><name>PayType</name><value>Credit Card</value></member>' +
                   '<member><name>PayDate</name><value><dateTime.iso8601>20141017T16:14:47</dateTime.iso8601></value></member>' +
                   '<member><name>Synced</name><value><boolean>0</boolean></value></member>' +
                  '</struct></value>' +
                 '</data></array></value></param></params></methodResponse>';
    }

 /***************************
  * @method: getExampleInvoiceXMLResult
  *
  **/ 
    public static string getExampleInvoiceXMLResult(){
        return '<?xml version="1.0"?>' +
            '<methodResponse>' +
             '<params>' +
              '<param>' +
               '<value>' +
                '<array>' +
                    '<data>' +
                        '<value>' +
                            '<struct>' +
                                '<member>' +
                                    '<name>Email</name>' +
                                    '<value>George.Smith@hotmail.com</value>' +
                                '</member>' +
                                '<member>' +
                                    '<name>FirstName</name>' +
                                    '<value>GEORGE c</value>' +
                                '</member>' +
                                '<member>' +
                                    '<name>LastName</name>' +
                                    '<value>SMITH</value>' +
                                '</member>' +
                            '</struct>' +
                        '</value>' +
                        '<value>' +
                            '<struct>' +
                                '<member>' +
                                    '<name>Email</name>' +
                                    '<value>SallyKay@yahoo.com</value>' +
                                '</member>' +
                                '<member>' +
                                    '<name>FirstName</name>' +
                                    '<value>Sally Grace</value>' +
                                '</member>' +
                                '<member>' +
                                    '<name>LastName</name>' +
                                    '<value>Kay</value>' +
                                '</member>' +
                            '</struct>' +
                        '</value>' +
                    '</data>' +
                '</array>' +
               '</value>' +
              '</param>' +
             '</params>' +
            '</methodResponse>';
    }

 /***************************
  * @method: getValueFromXMLString
  * @param:  xmlString
  * @param:  keyField
  *
  **/ 
    public static String getValueFromXMLString(String xmlString, String keyField) {
        String valueFound = '';
        if(xmlString.contains('<' + keyField + '>') && xmlString.contains('</' + keyField + '>')){
          try{
            valueFound = xmlString.substring(xmlString.indexOf('<' + keyField + '>') + keyField.length() + 2, xmlString.indexOf('</' + keyField + '>'));
          }catch (exception e){
            system.debug('Error in getValueFromXMLString. Details: ' + e.getMessage() + ' keyfield: ' + keyfield);
          }
        }
        return valueFound;
    }

 /***************************
  * @method: retrieveListBySplit
  * @param:  splitMe
  * @param:  splitValue
  *
  **/ 
    @TestVisible
    private static list<String> retrieveListBySplit(string splitMe, string splitValue){
        string sTemp = '';
        list<string> returnListTemp = new list<string>();
        list<string> returnListFinal = new list<string>();
        if(string.isBlank(splitMe)){
          return returnListFinal;
        }
        splitMe = splitMe.trim();
        returnListTemp = splitMe.split('</' + splitValue + '>');
        for(string s : returnListTemp){
          s = s.trim();
          if(s.startsWith('<' + splitValue + '>')){
            sTemp = '<' + splitValue + '>';
            s = s.substring(sTemp.length());
          }
          returnListFinal.add(s);
        }
        return returnListFinal;
    } 

    public static List<String> allLines {get; set;}

 /***************************
  * @method: divideString
  * @param:  input
  * @param:  breakValue  
  *
  **/ 
    public static void divideString(String input, string breakValue) {
        if(allLines == null){
            allLines = new List<string>();
        }
        Integer pivot = input.indexOf(breakValue, Integer.valueOf(Math.floor(input.length() / 2)) );
        if(pivot <= 0){
            return;
        }
        String left = input.substring(0,pivot);
        String right = input.substring(pivot);

        if ( pivot < 100000 ) {
            // split left and right chunks, add to allLines
            List<String> leftLines = left.split(breakValue);
            List<String> rightLines = right.split(breakValue);
            allLines.addAll(leftLines);
            allLines.addAll(rightLines);
        } else {
            // divide and conquer!
            divideString(left, breakValue);
            divideString(right, breakValue);
        }
    }

 /***************************
  * @method: retrieveListBySplit
  * @param:  splitMe
  * @param:  splitValueStart
  * @param:  splitValueEnd  
  *
  **/ 
    @TestVisible
    private static list<String> retrieveListBySplit(string splitMe, string splitValueStart, string splitValueEnd){
        string sTemp = '';
        list<string> returnListTemp = new list<string>();
        list<string> returnListFinal = new list<string>();
        if(string.isBlank(splitMe)){
          return returnListFinal;
        }
        splitMe = splitMe.trim();
        returnListTemp = splitMe.split(splitValueEnd);
        for(string s : returnListTemp){
          s = s.trim();
          if(s.startsWith(splitValueStart)){
            s = s.substring(splitValueStart.length());
          }
          returnListFinal.add(s);
        }
        return returnListFinal;
    } 

 /***************************
  * @method: createBatchList
  * @param:  sequenceNumber
  *
  **/ 
    public static list<integer> createBatchList(integer sequenceNumber){
        integer minNumber = sequenceNumber * 10;
        integer maxNumber = minNumber + 9;
        list<Integer> wciList = new list<Integer>();
        for(integer i = minNumber; i<=maxNumber; i++ ){
         wciList.add(i);
        }
        return wciList;
    }
/*
    public static void insertForEmail(string body, string subject, string email1, string email2){
        Email_Request__c er = new Email_Request__c();
        er.body__c = body;
        er.subject__c = subject;
        er.Email_Address_1__c = email1;
        er.Email_Address_2__c = email2;
        insert er;
    }
*/
    
 /***************************
  * @method: getSetOfSuccessPayments
  * @param:  scope
  *
  **/ 
    public static set<string> getSetOfSuccessPayments(List<WebcartHelper.webCartItemAction> scope){
        //return getSetOfProcessedPayments(scope, PMT_FLD_PaymentId, PROCESSED_SUCCESS);
        set<string> matchIDSet = new set<string>();

        for(WebcartHelper.webCartItemAction wbItem : scope){
            matchIDSet.add(wbItem.actionMap.get(PMT_FLD_PaymentId));    
        }

        list<Webcart_Payment__c> wbPaymentList = new list<Webcart_Payment__c>();
        wbPaymentList = [Select ID, Payment_ID__c
                         From Webcart_Payment__c
                         Where Payment_ID__c = :matchIDSet];
        set<string> alreadyProcessedSet = new set<string>();
        for(Webcart_Payment__c wpItem : wbPaymentList){
            alreadyProcessedSet.add(wpItem.Payment_ID__c);
        }

        return alreadyProcessedSet;
    }
    
 /***************************
  * @method: getSetOfDeclinedPayments
  * @param:  scope
  *
  **/ 
    public static set<string> getSetOfDeclinedPayments(List<WebcartHelper.webCartItemAction> scope){
        //return getSetOfProcessedPayments(scope, PMT_FLD_PaymentId, PROCESSED_DECLINE);
        set<string> matchIDSet = new set<string>();

        for(WebcartHelper.webCartItemAction wbItem : scope){
            matchIDSet.add(wbItem.actionMap.get(PMT_FLD_InvoiceId));    
        }

        list<Webcart_Decline__c> wbDeclineList = new list<Webcart_Decline__c>();
        wbDeclineList = [Select ID, Decline_ID__c
                         From Webcart_Decline__c
                         Where Decline_ID__c = :matchIDSet];
        set<string> alreadyProcessedSet = new set<string>();
        for(Webcart_Decline__c wpItem : wbDeclineList){
            alreadyProcessedSet.add(wpItem.Decline_ID__c);
        }

        return alreadyProcessedSet;
    }
    /*
    public static set<string> getSetOfProcessedPayments(List<WebcartHelper.webCartItemAction> scope, string fieldName, string typeValue){
        set<string> paymentIDSet = new set<string>();

        for(WebcartHelper.webCartItemAction wbItem : scope){
            paymentIDSet.add(wbItem.actionMap.get(fieldName));  
        }

        list<Webcart_Payment__c> wbPaymentList = new list<Webcart_Payment__c>();
        wbPaymentList = [Select ID, Payment_ID__c
                         From Webcart_Payment__c
                         Where Payment_ID__c = :paymentIDSet AND Type__c = :typeValue];
        set<string> alreadyProcessedSet = new set<string>();
        for(Webcart_Payment__c wpItem : wbPaymentList){
            alreadyProcessedSet.add(wpItem.Payment_ID__c);
        }

        return alreadyProcessedSet;
    }
    */
    
 /***************************
  * @method: getOnlyAccountIDToUse
  * @param:  webCartMap
  *
  **/ 
    //Do not deal with Leads or Creating an Account.  Just get the account ID
    public static string getOnlyAccountIDToUse(map<string, string> webCartMap){
        string accountID = null;
        list<Account> accList = new list<Account>();
        string emailAddress = webCartMap.get(WebcartHelper.PMT_FLD_BatchEmailAddress);

        accList = [Select ID, Name, Personemail 
                    from Account 
                    where Personemail = :emailAddress];
        if(accList.size() < 1){

        }else if(accList.size() > 1){
            //TODO: Do we need to merge these into one PersonAccount?
            accountID = accList[0].ID;
        }else{
            accountID = accList[0].ID;
        }
        return accountID;
    }
    
 /***************************
  * @method: getAccountIDToUse
  * @param:  webCartMap
  * @param:  webCartProductID 
  *
  **/ 
    public static string getAccountIDToUse(map<string, string> webCartMap, string webCartProductID){
        string accountID = null;
        list<Account> accList = new list<Account>();
        list<Lead> leadList = new list<Lead>();
        list<Contact> conList = new list<Contact>();
        string emailAddress = webCartMap.get(WebcartHelper.PMT_FLD_BatchEmailAddress);

        accList = [Select ID, Name, Personemail 
                    from Account 
                    where Personemail = :emailAddress];
        if(accList.size() < 1){

        }else if(accList.size() > 1){
            //TODO: Do we need to merge these into one PersonAccount?
            accountID = accList[0].ID;
            return accountID;
        }else{
            accountID = accList[0].ID;
            return accountID;
        }

        LeadStatus convertStatus = [SELECT Id, MasterLabel 
                                    FROM LeadStatus 
                                    WHERE IsConverted = true and MasterLabel = 'Merged To Account' LIMIT 1];

        leadList = [Select ID, email, Name
                    From Lead
                    Where email = :emailAddress AND IsConverted = false];
        for(Lead l : leadList){
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.id);
            lc.setConvertedStatus(convertStatus.MasterLabel);

            if(string.isBlank(accountID) == false){
                //Merge into existing account
                lc.setAccountID(accountID);
            }   
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            if(lcr.isSuccess()){
                accountID = lcr.getAccountId();
            }   
        }

        if(string.isBlank(accountID)){
            //No account or lead so create a new one
            RecordType personAccountRecordType =  [SELECT Id 
                                                    FROM RecordType 
                                                    WHERE Name = 'Person Account' and SObjectType = 'Account'];
            Account aNew = new Account();
            aNew.FirstName = TrimAndProper(webCartMap.get(WebcartHelper.PMT_FLD_FirstName));
            aNew.LastName = TrimAndProper(webCartMap.get(WebcartHelper.PMT_FLD_LastName));
            aNew.Phone = TrimOnly(webCartMap.get(WebcartHelper.PMT_FLD_Phone));
            aNew.ShippingStreet = TrimAndProper(webCartMap.get(WebcartHelper.PMT_FLD_ShippingStreetAddress1));
            if(string.isBlank(webCartMap.get(WebcartHelper.PMT_FLD_ShippingStreetAddress2)) == false){
                aNew.ShippingStreet += ' - ' + TrimAndProper(webCartMap.get(WebcartHelper.PMT_FLD_ShippingStreetAddress2)); ///r/n
            }
            aNew.ShippingCity = TrimAndProper(webCartMap.get(WebcartHelper.PMT_FLD_ShippingCity));
            aNew.ShippingState = TrimAndUpper(webCartMap.get(WebcartHelper.PMT_FLD_ShippingState));
            aNew.ShippingPostalCode = TrimAndUpper(webCartMap.get(WebcartHelper.PMT_FLD_ShippingZip));
            aNew.ShippingCountry = TrimAndProper(webCartMap.get(WebcartHelper.PMT_FLD_ShippingCountry));
            aNew.BillingCountry = TrimAndProper(webCartMap.get(WebcartHelper.PMT_FLD_BillingCountry));
            if(string.isBlank(aNew.ShippingCountry) == false){
                aNew.Country_List__c = aNew.ShippingCountry;
            }else if(string.isBlank(aNew.BillingCountry) == false){
                aNew.Country_List__c = aNew.BillingCountry;
            }
            aNew.RecordType = personAccountRecordType;
            aNew.PersonEmail = TrimAndLower(emailAddress);
            aNew.OwnerID = '00560000000mIAOAA2'; //Next Step Financial Holdings
            insert aNew;
            accountID = aNew.ID;
            
            if(IS_VERSION_1_1){             
                Lead_Sources__c ls = new Lead_Sources__c();
                ls.Lead_Source__c = 'Infusionsoft Webcart';
                ls.Lead_Source_Detail__c = 'No known source';
                ls.Offer__c = ''; //Must pass specific InfusionSoft_ID__c Product to search for in webCartMap because that map has all Products
                list<Product2> prodList = new list<Product2>();
                prodList = [Select ID, Product_List__c From Product2 Where InfusionSoft_ID__c = :webCartProductID];
                if(prodList.size() > 0){
                    ls.Offer__c = prodList[0].Product_List__c;
                }       
                ls.Product__c = 'n/a';      
                ls.Lead_Source_Date__c = convertWebCartStringToDate(webCartMap.get(PMT_FLD_Date)); //date.Today();
                ls.Offer_Type__c = 'Online Sale';
                ls.Account__c = aNew.ID;
                insert ls;
            }
        }
/*
global static final string PMT_FLD_ContactId = 'ContactId';
    global static final string PMT_FLD_ReferralPartner = 'ReferralPartner';
    global static final string PMT_FLD_ReferralPartnerId = 'ReferralPartnerId';
    global static final string PMT_FLD_PromoCode = 'PromoCode';
    global static final string PMT_FLD_ProductIds = 'ProductIds';
    global static final string PMT_FLD_SaleTotal = 'SaleTotal';
    global static final string PMT_FLD_PayType = 'PayType';
    global static final string PMT_FLD_DateSent = 'DateSent';
    global static final string PMT_FLD_Date = 'Date';
    global static final string PMT_FLD_PaymentId = 'PaymentId';
    */
        return accountID;
    }

 /***************************
  * @method: TrimAndProper
  * @param:  entryString
  *
  **/ 
    public static string TrimAndProper(string entryString){
        if(string.isBlank(entryString)){
            return '';
        }else{
            entryString = entryString.Trim();
            list<string> splitMe = new list<string>();
            splitMe = entryString.split(' ');
            for(string s : splitMe){
                if(string.isBlank(s) == false){
                    s = s.Capitalize();
                }
            }
            entryString = string.join(splitMe, ' ');
            return entryString;
        }
    }

 /***************************
  * @method: TrimOnly
  * @param:  entryString
  *
  **/ 
    public static string TrimOnly(string entryString){
        if(string.isBlank(entryString)){
            return '';
        }else{
            return entryString.Trim();
        }
    }

 /***************************
  * @method: TrimAndLower
  * @param:  entryString
  *
  **/ 
    public static string TrimAndLower(string entryString){
        if(string.isBlank(entryString)){
            return '';
        }else{
            return entryString.Trim().ToLowerCase();
        }
    }

 /***************************
  * @method: TrimAndUpper
  * @param:  entryString
  *
  **/
    public static string TrimAndUpper(string entryString){
        if(string.isBlank(entryString)){
            return '';
        }else{
            return entryString.Trim().ToUpperCase();
        }
    }

 /***************************
  * @method: convertWebCartStringToDate
  * @param: dateTimeValue 
  *
  **/ 
    public static date convertWebCartStringToDate(string dateTimeValue){
        if(string.isBlank(dateTimeValue)){
            return null;
        }
        date dateReturn = null;
        //The String should use the standard date format ?yyyy-MM-dd HH:mm:ss? in the local time zone
        //convertWebCartStringToDate value is: 20150301T14:20:18
        system.debug('convertWebCartStringToDate value is: ' + dateTimeValue);
        //dateTimeValue is in MM/DD/YYYY format in the UI, but it is not here.   It looks like this: 20150301T14:20:18 Must switch to yyyy-MM-dd
        string year = dateTimeValue.substring(0, 4);
        string day = dateTimeValue.substring(6, 8);
        string month = dateTimeValue.substring(4, 6);
        string timeValue = dateTimeValue.substring(9, 17);
        string convertValue = year + '-' + month + '-' + day + ' ' + timeValue;
        try{
            dateReturn = date.NewInstance(integer.valueOf(year), integer.valueOf(month), integer.valueOf(day));
            //dateReturn = date.ValueOf(convertValue);
        }catch(exception e){
            system.debug('Problem date value in convertWebCartStringToDate: ' + convertValue);
        }
        return dateReturn;
    }

 /***************************
  * @method: convertWebCartStringToDateTime
  * @param: dateTimeValue 
  *
  **/ 
    public static datetime convertWebCartStringToDateTime(string dateTimeValue){
        if(string.isBlank(dateTimeValue)){
            return null;
        }
        dateTime dateTimeReturn = null;
        //The String should use the standard date format ?yyyy-MM-dd HH:mm:ss? in the local time zone
        //convertWebCartStringToDate value is: 20150301T14:20:18
        system.debug('convertWebCartStringToDateTime value is: ' + dateTimeValue);
        string convertValue;
        try{
            //dateTimeValue is in MM/DD/YYYY format in the UI, but it is not here.   It looks like this: 20150301T14:20:18 Must switch to yyyy-MM-dd
            string year = dateTimeValue.substring(0, 4);
            string day = dateTimeValue.substring(6, 8);
            string month = dateTimeValue.substring(4, 6);
            string timeValue = dateTimeValue.substring(9, 17);
            convertValue = year + '-' + month + '-' + day + ' ' + timeValue;
            string hourValue = timeValue.substring(0, 2);
            string minuteValue = timeValue.substring(3, 5);
            string secondValue = timeValue.substring(6, 8);
        
            dateTimeReturn = dateTime.newInstance(integer.valueOf(year), integer.valueOf(month), integer.valueOf(day), 
                                integer.valueOf(hourValue), integer.valueOf(minuteValue), integer.valueOf(secondValue));
            //dateReturn = date.ValueOf(convertValue);
        }catch(exception e){
            system.debug('Problem date value in convertWebCartStringToDate: ' + convertValue + ' error: ' + e.getMessage());
        }
        return dateTimeReturn;
    }

    public static map<string, decimal> productIDToPriceMap = new map<string, decimal>();

 /***************************
  * @method: fillProductPriceMap
  *
  **/ 
    public static void fillProductPriceMap(){
        productIDToPriceMap = new map<string, decimal>();
        list<Webcart_Product__c> wpList = new list<Webcart_Product__c>();
        wpList = [Select ID, Product_Price__c, Product_ID__c
                    From Webcart_Product__c];
        for(Webcart_Product__c wpItem : wpList){
            if(wpItem.Product_Price__c <> null){
                productIDToPriceMap.put(wpItem.Product_ID__c, wpItem.Product_Price__c);
            }else{
                productIDToPriceMap.put(wpItem.Product_ID__c, 0);
            }
        }
    }

 /***************************
  * @method: getTotalProductsValue
  * @param:  prodIDSet
  * //This assumes that fillProductPriceMap has already been called
  *
  **/ 
    //This assumes that fillProductPriceMap has already been called
    public static decimal getTotalProductsValue(set<string> prodIDSet){
        decimal retValDec = 0;
        for(string s : prodIDSet){
            if(productIDToPriceMap.containsKey(s) == false){
                productIDToPriceMap.put(s, 0);
            }       
            retValDec += productIDToPriceMap.get(s);    
        }

        return retValDec;
    }

/***************************
  * @method: createOpportunityAndChildDocs
  * @param:  accountID
  * @param:  webCartMap
  * @param:  webCartProductID  
  *
  **/ 
    public static string createOpportunityAndChildDocs(string accountID, map<string, string> webCartMap, string webCartProductID, decimal productPaymentAmount){
        //TODO: What priceboook?
        List<Pricebook2> pbList = [SELECT ID, Name FROM Pricebook2 WHERE Name = 'North American']; //Education  OR Name = 'Standard Price Book'
        String priceBookId = '';
        if (pbList.size() > 0) {
            priceBookId = pbList[0].ID;
        }
        else {
            if (test.isRunningTest()) {
                pricebookID = test_pricebookID;
            }
            else {
                priceBookId = null;
            }           
        }
 
        List<Product2> prodList = new List<Product2>();
        List<Account> accList = new List<Account>();
        if ((webCartProductID != null) && IS_VERSION_1_1) {
            //aac 10.20.15 added field and replaced custom settings with fields
            prodList = [SELECT ID, Product_List__c, Infusionsoft_Subscription_Next_Amount__c, Infusionsoft_Subscription_Product__c, Infusionsoft_ID__c,
                                Opportunity_RecType__c, Num_Subscription_Days__c, Vertical__c, pb_startdate_api_name__c, Opportunity_OwnerId__c, Opportunity_Owner__c
                            FROM Product2 
                            WHERE InfusionSoft_ID__c = :webCartProductID];

            String qrystr = 'Select ID, PB_UTP_Summary_Client__c, Owner.Name, Owner.ID, OwnerID, Owner.IsActive';
            
            if (prodList.size() > 0) {                        
                qrystr += (!String.isblank(prodList[0].pb_startdate_api_name__c))? ',' + prodList[0].pb_startdate_api_name__c : '';
            }
            qrystr += ' From Account Where ID = :accountID';
            accList = Database.query(qrystr);  

            if ((acclist.size() > 0) && (prodList.size() > 0)) {
                Date testdate = (prodList[0].pb_startdate_api_name__c != null && acclist[0].get(prodList[0].pb_startdate_api_name__c) != null) ? (date)acclist[0].get(prodList[0].pb_startdate_api_name__c) : null;
                System.debug(Logginglevel.ERROR,'@asha: testdate ' + testdate); 
            }
        }
        else {
            accList = [SELECT ID, PB_UTP_Summary_Client__c, Owner.Name, Owner.ID, OwnerID, Owner.IsActive
                        FROM Account
                        WHERE ID = :accountID];              
        }               

        String PB_UTP_Summary_Client = '';
        String accountOwnerName = '';
        String accountOwnerID = '';
        String strTemp = '';
        Boolean accountOwnerIsActive = false;
        if (accList.size() > 0) {
            PB_UTP_Summary_Client = accList[0].PB_UTP_Summary_Client__c;
            if (accList[0].OwnerID <> null) {
                accountOwnerName = accList[0].Owner.Name;
                accountOwnerID = accList[0].OwnerID;
                accountOwnerIsActive = accList[0].Owner.IsActive;
            }           
        } 

        String tmpStr = '';
        Decimal decSaleTotalTmp = 0;

        //With version 1.1 we send in the specific dollar amount for this product
        //system.debug('PMT_FLD_PayAmt: ' + tmpStr);
        decSaleTotalTmp = productPaymentAmount; //convertWebcartValtoDecimal(tmpStr);
        System.debug('Revenue: ' + String.ValueOf(decSaleTotalTmp));

        String oppID = '';
        Opportunity oppNew = new Opportunity();
        oppNew.AccountID = accountID;
        oppNew.Stagename = 'Pending Charge';
        oppNew.Name = 'xx';  //Workflow rules rename this
        oppNew.CloseDate = convertWebCartStringToDate(webCartMap.get(PMT_FLD_Date));
        System.debug(Logginglevel.ERROR,'CloseDate is: ' + oppNew.CloseDate);
        oppNew.Pricebook2ID = priceBookID;
        List<User> nextStepList = new List<User>();
        //nextStepList = [Select ID From User Where FirstName = 'Next Step'];
        String nextStepUser = '00560000000mIAO';
        oppNew.OwnerID = nextStepUser; //'00560000000m6A3AAI';
        oppNew.UTP_Webinar_Presenter_when_Closed_Won__c = '';
        oppNew.ContEd_Web_Presenter_when_Closed_Won__c = '';
        oppNew.AOD_Free_Trial_Active__c = false;

        if (PB_UTP_Summary_Client == 'Purchased') {
            oppNew.AOD_Free_Trial_Active__c = true;
            oppNew.UTP_Webinar_Presenter_when_Closed_Won__c = 'Josh Martinez'; //UTP_Presenter?  =TRIM(REFERENCE!$F$5)  Josh Martinez?
            oppNew.RecordTypeID = '012600000005IVFAA2'; //Continuing Education (Is a client)  Account.PB_UTP_Summary_Client__c = 'NOT Purchased'            
            if ((accountOwnerID.left(15) == nextStepUser) || (accountOwnerIsActive == false)) {
                oppNew.OwnerID = '00560000000m6A3AAI';//Derek Roth
            }
            else {
                oppNew.OwnerID = accountOwnerID;
            }
        }
        else {
            oppNew.ContEd_Web_Presenter_when_Closed_Won__c = 'Josh Martinez';
            oppNew.OwnerID = '00560000000m6A3AAI'; //Derek Roth
            oppNew.RecordTypeID = '012600000005CwxAAE'; //Education (Is not a client)  Account.PB_UTP_Summary_Client__c = 'Purchased'
        }
        
        oppNew.Product__c = 'PENDING WEBCART SALE'; //Live Market Forex Session  Product List is the field level name
        oppNew.Sub_Stage__c = ''; //Leave blank per Anthony

        oppNew.ContEd_Web_Presenter_when_Closed_Won__c = 'Josh Martinez';
        //Anthony said this was the first column in the InfusionSoft report which is the PMT_FLD_Id value
        oppNew.LMFS_Order_ID__c = webCartMap.get(WebcartHelper.PMT_FLD_Id); //webCartMap.get(WebcartHelper.PMT_FLD_PaymentId) 
        oppNew.LMFS_Order_Type__c = 'Infusionsoft Order';
        
        if (String.isBlank(oppNew.ContEd_Web_Presenter_when_Closed_Won__c) == false){
            oppNew.ContEd_Webinar_Last_Attd_when_Closed_Wo__c = oppNew.CloseDate;
        }
        
        oppNew.Sale_Invoice_First_Date_After_Down__c = oppNew.CloseDate;
        oppNew.Sale_Invoice_Qty_Payments_After_Down__c = 1;
        
        if (IS_VERSION_1_1){
            //Version 1.1
            // list<Product2> prodList = new list<Product2>();
            Boolean isInfusionsoftSubProduct = false;
            Decimal subscriptionNextAmount = 0;
            Decimal numdayssubscription = 32;
            String pbfieldapiname = '';
            String oppRecordTypeID = 'Continuing Education';
            //added aac 8.6.15 to accept more than just standard record types
            //uses Web Cart Product RecordTypeID to Owner Id Custom Setting
            
            //@info: opp record type schema map
            Map<String, ID> opprectypemap = new Map<String, ID>();
            Schema.DescribeSObjectResult describeopp = Schema.SObjectType.Opportunity;
            List<Schema.RecordTypeInfo> rtInfos = describeopp.getRecordTypeInfos();
    
            for(Schema.RecordTypeInfo rtInfo : rtInfos){ 
                opprectypemap.put(rtInfo.getName(), rtInfo.getRecordTypeId());
            }
    
            if (!String.isBlank(webCartProductID)) {          
                if (prodList.size() > 0) {
                    isInfusionsoftSubProduct = prodList[0].Infusionsoft_Subscription_Product__c;
                    //added aac 8.7.15 to allow for different opp record types
                    //changed aac 10.20.15 to allow for more scalability - removed custom setting   
                    //added check to see of subscription product first
                    
                    //get the opp rec type name from the field picklist in the product
                    String recordtypename = prodList[0].Opportunity_RecType__c;
                    //set the record type id by the product field if null then set to default - cont ed
                    oppNew.RecordTypeId = (recordtypename != null && opprectypemap.containskey(recordtypename))? opprectypemap.get(recordtypename) : oppNew.RecordTypeId;                       
                    //changed aac 10.20 - owner is derek roth unless micro product and then its the account owner
                    //changed aac 10.20 - oppNew.OwnerId = (!recordtypename.equals('Micro'))? accountOwnerID : oppNew.OwnerID;
                    //takes the value from the Opportunity Owner field on the product if the field value is Account Owner then uses the Account Owner for the //Opp Owner
                    //if anything other than Account Owner then the Opportunity Owner Id field needs to be added
                    String ownerstr = (prodList[0].Opportunity_Owner__c != null && prodList[0].Opportunity_Owner__c.equals('Account Owner') )? accountOwnerID : '';
                    ownerstr = (ownerstr.equals('') && prodList[0].Opportunity_OwnerId__c != null )? prodList[0].Opportunity_OwnerId__c : ownerstr;
                    oppNew.OwnerId = (!ownerstr.equals(''))? ownerstr : oppNew.OwnerId;
                                                
                    //default to forex vertical
                    oppNew.Product_Vertical__c = (prodList[0].Vertical__c != null)? prodList[0].Vertical__c : 'Forex';  
                                                
                    if (isInfusionsoftSubProduct) {
                        //set the default values
                        oppNew.Charting_Package__c = '1 month';
                        oppNew.Charting_Start__c = date.today();    
                        oppNew.Subscription_Next_Scheduled_Amount__c = 147;
                        oppNew.Subscription_Next_Scheduled_Quantity__c = 1; //Applies to version 1.0 and 1.1
                    
                    
                        pbfieldapiname = (!String.isblank(prodList[0].pb_startdate_api_name__c))? prodList[0].pb_startdate_api_name__c.trim() : pbfieldapiname;
                        subscriptionNextAmount = prodList[0].Infusionsoft_Subscription_Next_Amount__c;
                        numdayssubscription = (prodList[0].Num_Subscription_Days__c != null && prodList[0].Num_Subscription_Days__c != 0) ? prodList[0].Num_Subscription_Days__c : numdayssubscription;
                      if (accList.size() > 0) {
                        System.debug(Logginglevel.ERROR,'@asha:@debug: Webcarthelper : acct id- '+ accList[0].id);
                          System.debug(Logginglevel.ERROR, '@asha:@debug: WebcartHelper : acct '+ accList[0]);
                      }
                        System.debug(Logginglevel.ERROR,'@asha:@debug: Webcarthelper : pb api name - '+ pbfieldapiname);
                        System.debug(Logginglevel.ERROR,'@asha:@debug: Webcarthelper : Charting Start Now - '+ oppNew.Charting_Start__c);  
                        Date pbfieldstart = ( (accList.size() > 0) && !String.isblank(pbfieldapiname))? (Date) accList[0].get(pbfieldapiname) : null;  
                        System.debug(Logginglevel.ERROR,'@asha:@debug: Webcarthelper : Pb Field Date - '+ pbfieldstart);       
                        //pull the date from the account field 
                        oppNew.Charting_Start__c = ( pbfieldstart != null && (pbfieldstart > date.today()) )? pbfieldstart : oppNew.Charting_Start__c ;
                        System.debug(Logginglevel.ERROR,'@asha:@debug: Webcarthelper : Charting Start After - '+ oppNew.Charting_Start__c);        
                        //set subscription end to the default (1 month) if the subscription number on the product is null or 0 - default 32 numdayssubscription
                        oppNew.Charting_Expiration__c = oppNew.Charting_Start__c.adddays(Integer.valueof(numdayssubscription));
                        oppNew.Subscription_Next_Scheduled_Close__c = oppNew.Charting_Expiration__c;
                        oppNew.Subscription_Next_Scheduled_Amount__c = subscriptionNextAmount;
                        Integer monthsnum =  oppNew.Charting_Start__c.monthsBetween(oppNew.Charting_Expiration__c);
                        String monthorMonths = (monthsnum > 1)? ' months' : ' month';
                        oppNew.Charting_Package__c = monthsnum + monthorMonths;}
                    }              
                }           
            }
            else {
                //Version 1.0
                if (decSaleTotalTmp > 147) {
                    oppNew.Subscription_Next_Scheduled_Amount__c = decSaleTotalTmp;  //=IF(LOG!T3>147,LOG!T3,147)  If Sale Total Greater than 147 then use that.
                }
                else {
                    oppNew.Subscription_Next_Scheduled_Amount__c = 147;
            }
        }

        oppNew.Webcart_Promo_Code__c = webCartMap.get(PMT_FLD_PromoCode);
        oppNew.Webcart_Referral_Name__c = webCartMap.get(PMT_FLD_ReferralPartner); 

        String products = webCartMap.get(WebcartHelper.PMT_FLD_ProductIds); 
        Set<string> productSet = new Set<string>();
        List<string> productSplitList = new list<string>();

        if (String.isBlank(products) == false) {
            productSplitList = products.split(',');
            for (string s : productSplitList) {
                if (s.equals(webCartProductID)) {
                    productSet.add(s);
                }
            }
        }       

        List<PricebookEntry> pbeList = new List<PricebookEntry>();

        pbeList = [SELECT ID, Name, Pricebook2Id, ProductCode, Product2Id, UnitPrice, UseStandardPrice, 
                            Product2.InfusionSoft_ID__c, Product2.Name, Product2.Product_List__c
                    FROM PricebookEntry
                    //WHERE IsActive = true AND Pricebook2Id = :priceBookID AND Product2.InfusionSoft_ID__c = :productSet];
                    WHERE IsActive = true AND Pricebook2Id = :priceBookID AND Product2.InfusionSoft_ID__c = :webCartProductID];

        if(test.isRunningTest()){
            pbeList = [SELECT ID, Name, Pricebook2Id, ProductCode, Product2Id, UnitPrice, UseStandardPrice, 
                                Product2.InfusionSoft_ID__c, Product2.Name, Product2.Product_List__c 
                        FROM PricebookEntry
                        WHERE ID = :test_standardPrice.ID];
        }

        if ((test.isRunningTest() == false) && (pbeList.size() <> productSet.size())){
            return PRODUCT_NOT_FOUND + webCartProductID + PRODUCT_NOT_FOUND_END; //' not mapped in Salesforce at this time.'
            //return 'Error - Product(s) Not Mapped - ' + products;
        }

		System.debug(LoggingLevel.ERROR, '@@@@ Sale_Down_Payment_1_of_4_DESIRED__c: ' + oppNew.Sale_Down_Payment_1_of_4_DESIRED__c);
		System.debug(LoggingLevel.ERROR, '@@@@ Sale_Down_Payment_1_of_4_Date__c: ' + oppNew.Sale_Down_Payment_1_of_4_Date__c);
		
		System.debug(LoggingLevel.ERROR, '@@@@ Sale_Down_Payment_2_of_4__c: ' + oppNew.Sale_Down_Payment_2_of_4__c);
		System.debug(LoggingLevel.ERROR, '@@@@ Sale_Down_Payment_2_of_4_Date__c: ' + oppNew.Sale_Down_Payment_2_of_4_Date__c);
		
		System.debug(LoggingLevel.ERROR, '@@@@ Sale_Down_Payment_3_of_4__c: ' + oppNew.Sale_Down_Payment_3_of_4__c);
		System.debug(LoggingLevel.ERROR, '@@@@ Sale_Down_Payment_3_of_4_Date__c: ' + oppNew.Sale_Down_Payment_3_of_4_Date__c);
		
		System.debug(LoggingLevel.ERROR, '@@@@ Sale_Down_Payment_4_of_4__c: ' + oppNew.Sale_Down_Payment_4_of_4__c);
		System.debug(LoggingLevel.ERROR, '@@@@ Sale_Down_Payment_4_of_4_Date__c: ' + oppNew.Sale_Down_Payment_4_of_4_Date__c);
		
		System.debug(LoggingLevel.ERROR, '@@@@ Sale_Invoice_Qty_Payments_After_Down__c: ' + oppNew.Sale_Invoice_Qty_Payments_After_Down__c);
		System.debug(LoggingLevel.ERROR, '@@@@ Sale_Invoice_First_Date_After_Down__c: ' + oppNew.Sale_Invoice_First_Date_After_Down__c);

        System.debug(LoggingLevel.ERROR, '@@@@ Before insert new opp');
        insert oppNew;
        System.debug(LoggingLevel.ERROR, '@@@@ After insert new opp');
        
        String productListValue = '';
        decimal productListPrice = 0;
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        OpportunityLineItem oliTemp;
            
        //FIELD_CUSTOM_VALIDATION_EXCEPTION, Please enter an expected start date for the subscription product below.: []
        for (PricebookEntry pbeItem : pbeList) {
            //if (!String.isBlank(pbeItem.Product2.Infusionsoft_ID__c)) {
                //if (!pbeItem.Product2.Infusionsoft_ID__c.equals(webCartProductID)) {
                    //continue;
                //}
            //}
            
            if (string.isBlank(pbeItem.Product2.Product_List__c) == false) {
                productListValue = pbeItem.Product2.Product_List__c;
            }
            else {
                productListValue = '';
            }
            
            oliTemp = new OpportunityLineItem();
            oliTemp.OpportunityID = oppNew.ID;
            oliTemp.Description = '';  //TODO
            
            if (pbeItem <> null) {
                oliTemp.PricebookEntryId = pbeItem.ID; //TODO
            }               

            oliTemp.Quantity = 1;  //TODO
            oliTemp.TotalPrice = decSaleTotalTmp;
            
            if (pbeItem.Product2Id <> null) {
                if (string.isBlank(pbeItem.Product2.Name) == false) {
                    if (pbeItem.Product2.Name.Contains('MTI 4.0')) { //Needed for Opportunity Product Validation Rule
                        //Please enter an expected start date for the subscription product below.
                        oliTemp.ServiceDate = date.Today();
                    }
                }                   
            }
            
            oliList.add(oliTemp);
        }

        System.debug('Before insert new opp products');
        if (oliList.size() > 0) {
            insert oliList;
        }
        System.debug('after insert new opp products');

        //https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_opportunitylineitemschedule.htm
        List<OpportunityLineItemSchedule> olisList = new List<OpportunityLineItemSchedule>();
//        OpportunityLineItemSchedule olisItem;

//        for (OpportunityLineItem oliItem : oliList) {
//            olisItem = new OpportunityLineItemSchedule();
//            olisItem.Description = 'Paid';
//            olisItem.Type = 'Revenue';
//            olisItem.OpportunityLineItemId = oliItem.ID;
//            olisItem.Quantity = null; // Must be null since Type = Revenue - oliItem.Quantity;          
//            olisItem.Revenue = decSaleTotalTmp;
//            olisItem.ScheduleDate = oppNew.CloseDate;
//            olisList.add(olisItem);
//        }

//        System.debug('Before insert new schedule line items');
//        if (olisList.size() > 0) {
//            insert olisList;
//        }
//        System.debug('after insert new schedule line items');

        oppNew.Product__c = productListValue; //'PENDING WEBCART SALE'; //Live Market Forex Session  Product List is the field level name
        
        if (decSaleTotalTmp <= 0) {

        }
        else {
            oppNew.AVSFQB__Generate_Object__c = 'Invoice';
        }

        oppNew.Stagename = 'Closed Won';
        oppNew.Sub_Stage__c = 'Paid'; //TODO
        oppNew.Payment_Plan__c = 'In-House Paid Off';
        //FIELD_CUSTOM_VALIDATION_EXCEPTION, CLOSED WON opportunities MUST have a Close Date (which must be a date no later than today - NO FUTURE DATES
        
        if(oppNew.CloseDate > date.today()) {
            oppNew.CloseDate = date.today();
        }
        
        System.debug(LoggingLevel.ERROR, '@@@@ Before update opp to closed won');
        Handler_Account.ALLOW_WEBCHARTING_UPDATE = true;
        update oppNew;
        System.debug(LoggingLevel.ERROR, '@@@@ After update opp to closed won');

        //Where do we store the PaymentId and InvoiceId?  //TODO
        //Transaction__c - Storage object for Payments, Credits and related transactions on any given Sale (Closed Won Opportunity).
        
        Opportunity qOpp = [SELECT Id, Name, Summary_of_List_Prices__c FROM Opportunity WHERE Id = :oppNew.Id];
        
        //create payment terms
        Payment_Terms__c newTerms = new Payment_Terms__c();
        newTerms.Active__c = true;
        newTerms.First_Payment_Term__c = true;
        newTerms.Opportunity__c = oppNew.id;
        newTerms.Account__c = oppNew.accountid;
        newTerms.Discount__c =  qOpp.Summary_of_List_Prices__c - productPaymentAmount;  // per Eric Herrera; previously: productListPrice - productPaymentAmount;
        //newTerms.Sales_Price__c = oppNew.amount;  
        newTerms.Sales_Price__c = productPaymentAmount;
        
        newTerms.Payment_Terms_Type__c = 'Standard for regular sales';
        system.debug('newTerms ' + newTerms);
        insert newTerms;
        //create planned payment
        Planned_Payment__c newPPayment = new Planned_Payment__c();
        //newPPayment.Amount_Due__c = oppNew.amount;
        newPPayment.Amount_Due__c = productPaymentAmount;
        newPPayment.PP_Description__c = 'Standard - for regular sales';
        newPPayment.Due_Date__c = oppNew.CloseDate;
        newPPayment.Payment_Terms__c = newTerms.id;
        newPPayment.Status__c = 'Paid';
        newPPayment.PP_Type__c = 'Full Pay';
        system.debug('newPPayment ' + newPPayment);
        insert newPPayment;
        
        //create payment activity
        Payment_Activity__c newPA = new Payment_Activity__c();
        //newPA.Amount__c = oppNew.amount;
        newPA.Amount__c = productPaymentAmount;
        newPA.Account__c = oppNew.accountid;
        Datetime newDate = Datetime.newInstance(oppNew.CloseDate.Year(), oppNew.CloseDate.Month(), oppNew.CloseDate.Day());

        //newPA.Date__c = oppNew.CloseDate;
        newPA.Date__c = newDate;
        newPa.Opportunity__c = oppNew.id;
        newPA.Outcome__c = 'Approved';
        newPA.Payment_Status__c = 'Paid';
        newPA.Payment_Terms__c = newTerms.id;
        newPA.Payment_Type__c = 'Credit Card';
        newPA.Planned_Payment__c = newPPayment.id;
        newPA.Payment_Activity_Type__c = 'Paid';
        system.debug('newPA ' + newPA);
        insert newPA;
        //create payment
        Payment__c newPayment = new Payment__c();
        //newPayment.Amount__c = oppNew.amount;
        newPayment.Amount__c = productPaymentAmount;
        newPayment.PY_Paid_Date__c = oppNew.closeDate;
        newPayment.Payment_Activity__c = newPA.id;
        newPayment.Planned_Payment__c = newPPayment.id;
        system.debug('newPayment ' + newPayment);
        insert newPayment;

        return oppNew.ID;
    }

 /***************************
  * @method: convertWebcartValtoDecimal
  * @param:  convertString
  *
  **/ 
    public static decimal convertWebcartValtoDecimal(string convertString){
        decimal mydec = null;
        if(string.isBlank(convertString)){
            return mydec;
        }
        if(convertString.startsWith('$')){
            convertString = convertString.substring(1);
        }
        try{
            mydec = decimal.valueOf(convertString);
        }catch(exception e){

        }
        return myDec;
    }
    
 /***************************
  * @method: convertWebcartValtoInteger
  * @param:  convertString - currency to convert
  *
  *
  **/
    public static decimal convertWebcartValtoInteger(string convertString){
        integer myint = null;
        if(string.isBlank(convertString)){
            return myint;
        }
        if(convertString.startsWith('$')){
            convertString = convertString.substring(1);
        }
        try{
            myint = integer.valueOf(convertString);
        }catch(exception e){

        }
        return myint;
    }

 /***************************
  * @method: getPricebookEntryIDSet
  * @param:  products - list of products separated by a comma
  * @description: splits the product list by comma, puts the products into a set and queries PricebookEntry, returns the product list
  *
  **/ 
    public static set<string> getPricebookEntryIDSet(string products){
        system.debug('Looking for products: ' + products);
        set<string> pricebookIDSet = new set<string>();
        if(string.isBlank(products)){
            return pricebookIDSet;
        }
        list<Pricebook2> pbList = [Select ID, Name From Pricebook2 Where Name = 'North American']; //Education  OR Name = 'Standard Price Book'
        string priceBookId = '';
        if(pbList.size() > 0){
            system.debug('Found Pricebook: ' + pbList[0].ID);
            priceBookId = pbList[0].ID;
        }else{
            if(test.isRunningTest()){
                pricebookID = test_pricebookID;
            }else{
                priceBookId = null;
            }           
        }

        set<string> productSet = new set<string>();
        list<string> productSplitList = new list<string>();
        if(string.isBlank(products) == false){
            productSplitList = products.split(',');
            for(string s : productSplitList){
                productSet.add(s);
            }
        }       

        list<PricebookEntry> pbeList = new list<PricebookEntry>();
        pbeList = [Select ID, Name, Pricebook2Id, ProductCode, Product2.Product_List__c, 
                        Product2Id, UnitPrice, UseStandardPrice, Product2.InfusionSoft_ID__c, Product2.Name
                    From PricebookEntry
                    Where IsActive = true AND Pricebook2Id = :priceBookID AND Product2.InfusionSoft_ID__c = :productSet];

        if(test.isRunningTest()){
            pbeList = [Select ID, Name, Pricebook2Id, ProductCode, Product2.Product_List__c, 
                        Product2Id, UnitPrice, UseStandardPrice, Product2.InfusionSoft_ID__c, Product2.Name
                    From PricebookEntry
                    Where ID = :test_standardPrice.ID];
        }

        for(PricebookEntry pbe : pbeList){
            //pricebookIDSet.add(pbe.ID);
            pricebookIDSet.add(pbe.Product2.Product_List__c); 
        }
        
        return pricebookIDSet; //This is actually the Product List field now, now the Pricebook IDs.
    }

 /***************************
  * @method: findOwnerMatchByName
  * @param:  nameToFind - name of user to findOwnerMatchByName
  * @description: finds user ids
  *
  **/ 
    public static string findOwnerMatchByName(string nameToFind){
        list<User> userList = [Select ID From User Where Name = :nameToFind];
        if(userList.size() > 0){
            return userList[0].ID;
        }else{
            return '';
        }
    }
  
 /***************************
  * @method: checkforRefreshTokenSaveNeeded
  * @param:  webCartName - key for infusionsoft variables stored in webcart__c custom setting
  * @description: check to refresh token
  *
  **/ 
    public static void checkforRefreshTokenSaveNeeded(string webCartName){
        if(webcartHelper.refreshTokenCalled == true && (string.isBlank(webcartHelper.atiRefresh.accessToken) == false)){
          //Need to save new Access and Refresh Tokens
          if (Webcart__c.getInstance(webcartHelper.INFUSIONSOFT) != null) { 
            Webcart__c wbItem = Webcart__c.getInstance(webcartHelper.INFUSIONSOFT);
            wbItem.Access_Token__c = webcartHelper.atiRefresh.accessToken;
            wbItem.Refresh_Token__c = webcartHelper.atiRefresh.refreshToken;
            wbItem.Expires_In__c = webcartHelper.atiRefresh.expiresIn;
            update wbItem;
          }
       }
    }

 /***************************
  * @method: addWebCartCustomSetting
  * @description: test webcart custom setting
  *
  **/ 
    //Below here are methods for creating test data for test classes
    public static void addWebCartCustomSetting(){
        Webcart__c wbItem = new Webcart__c();
        wbItem.Name = INFUSIONSOFT;
        wbItem.Password__c = 'TestPwd';
        wbItem.Username__c = 'TestUN';
        wbItem.Batch_Size__c = 1;
        wbItem.Redirect_URI__c = 'http://myRedirectURL.x.com';
        wbItem.Client_ID__c = '23';
        wbItem.Client_Secret__c = '24';
        wbItem.Authorization_Code__c = '12';
        wbItem.Access_Token__c = '45';
        wbItem.Refresh_Token__c = '56';
        wbItem.PaymentsReportNumber__c = '160'; //148
        wbItem.PaymentsReportUserId__c = '1';
        wbItem.DeclinesReportNumber__c = '162'; //150
        wbItem.DeclinesUserId__c = '1';
        insert wbItem;
    }

    public static void addOppRecTypeCustomSetting(){
        //added by aac for WebCartProduct_RecTypeId_Owner__c custom setting
        WebCartProduct_RecTypeId_Owner__c testwebcartcs = new WebCartProduct_RecTypeId_Owner__c();
        testwebcartcs.name = 'product1';
        testwebcartcs.Product_Name__c = '25 Trading Tips eBook';    
        testwebcartcs.RecordType__c = 'Micro';  
        testwebcartcs.Owner__c = 'Derek Roth';  
        testwebcartcs.OwnerId__c = '00560000000m6A3AAI';
        testwebcartcs.Product_Vertical__c = 'Forex';    
        insert testwebcartcs;
 
        WebCartProduct_RecTypeId_Owner__c testwebcartcs2 = new WebCartProduct_RecTypeId_Owner__c();
        testwebcartcs2.name = 'product2';
        testwebcartcs2.Product_Name__c = 'TestPL';  
        testwebcartcs2.RecordType__c = 'Micro'; 
        testwebcartcs2.Owner__c = 'Derek Roth'; 
        testwebcartcs2.OwnerId__c = '00560000000m6A3AAI';
        testwebcartcs2.Product_Vertical__c = 'Forex';   
        insert testwebcartcs2;
        
    }
    
    public static Product2 test_prod;
    public static ID test_pricebookID;
    public static PricebookEntry test_standardPrice;
    public static Pricebook2 test_customPB;
    public static PricebookEntry test_customPrice;

 /***************************
  * @method: addPricebookEntries
  * @description: setup test price book and test product
  **/ 
    public static void addPricebookEntries() {
         // First, set up test price book entries.
         // Insert a test product.
         //InfusionSoft_ID__c must match what is in the XML return test string in getExamplePaymentXMLResult
         //'<member><name>ProductIds</name><value>2</value></member>' +  getExamplePaymentXMLResult
         test_prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', Product_List__c = 'TestPL', InfusionSoft_ID__c = '2');
         test_prod.CanUseRevenueSchedule = true;
         insert test_prod;
         // Get standard price book ID.
         // This is available irrespective of the state of SeeAllData.
         test_pricebookID = Test.getStandardPricebookId();
         // 1. Insert a price book entry for the standard price book.
         // Standard price book entries require the standard price book ID we got earlier.
         test_standardPrice = new PricebookEntry(Pricebook2Id = test_pricebookID, Product2Id = test_prod.Id,
          UnitPrice = 10000, IsActive = true);
         insert test_standardPrice; 
         // Create a custom price book
         test_customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
         insert test_customPB;
         // 2. Insert a price book entry with a custom price.
         test_customPrice = new PricebookEntry(
            Pricebook2Id = test_customPB.Id, Product2Id = test_prod.Id,
            UnitPrice = 12000, IsActive = true);
         insert test_customPrice;
    }

    //Webcart XML Pieces
    /*
        global static string TBL_PAYMENT = 'Payment';
    global static string TBL_SAVED_FILTER = 'Saved_Filter';
        */
        //string userName = getWebCartUserName(webCartName);
        //string password = getWebCartPassword(webCartName);
        

        //https://developer.infusionsoft.com/docs/read/Data_Service#query
        //https://developer.infusionsoft.com/io-docs
           //Put in my Client ID and Secret
           //On OAuth screen enter Anthony's Marketplace ID and Password
           //Click get Access Token
           //Scroll down to 
        /*
        <?xml version="1.0" encoding="UTF-8"?>
          <methodCall><methodName>DataService.query</methodName>
           <params>
            <param><value><string>myClientID</string></value></param>
            <param><value><string>Invoice</string></value></param>
            <param><value><int>101</int></value></param>
            <param><value><int>0</int></value></param>
            <param>
             <value>
              <struct>
               <member><name>ContactId</name><value><string>23</string></value></member>
              </struct>
              </value>
             </param>
             <param>
               <value><array><data><value><string>ContactId</string></value><value><string>JobId</string></value></data></array></value>
              </param>
              <param>
               <value><string>ContactId</string></value></param><param><value><boolean>1</boolean></value>
              </param>
              </params>
              </methodCall>

        */

    //Success
        /*
        <?xml version="1.0" encoding="UTF-8"?>
            <methodResponse>
                <params>
                    <param>
                        <value>
                            <array><data/></array>
                        </value>
                    </param>
                </params>
            </methodResponse>
        */

        //Error
        /*
        <?xml version="1.0" encoding="UTF-8"?>
            <methodResponse><fault><value>
                <struct>
                    <member>
                        <name>faultCode</name>
                        <value><i4>0</i4></value>
                    </member>
                    <member>
                        <name>faultString</name>
                        <value>Failed to parse XML-RPC request: Content is not allowed in prolog.</value>
                    </member>
                </struct></value></fault>
            </methodResponse>

        */

        //Error
        /*
        <?xml version="1.0" encoding="UTF-8"?>
            <methodResponse><fault><value>
                <struct>
                    <member>
                        <name>faultCode</name>
                        <value><i4>0</i4></value>
                    </member>
                    <member>
                        <name>faultString</name>
                        <value>Failed to parse XML-RPC request: Expected value element, got param</value>
                    </member>
                </struct></value></fault>
            </methodResponse>

        */
        
        //Error: <h1>596 Service Not Found</h1>
        
 /***************************
  * @method: callWebCart
  * @param:  accessToken - token for infusionsoft integration
  *
  **/ 
    public static string callWebCart(string accessToken){
        
        string xmlBody = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<methodCall>' +
                '<methodName>SearchService.getSavedSearchResults</methodName>' +
                    '<params>' +
                        '<param><value><string>myapiKey</string></value></param>' + //apiKey
                        '<param><value><int>999</int></value></param>' + //Saved Search ID
                        '<param><value><int>1</int></value></param>' + //userID
                        '<param><value><int>0</int></value></param>' + //page number, start at 0 for first 1000 records
                        '<param><value><array><data>' +
                            '<value><string>Id</string></value>' + //Fields for report
                            '<value><string>ContactId</string></value>' +
                        '</data></array></value></param>' +
                    '</params>' +
                '</methodCall>';
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','application/xml'); 
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        req.setHeader('Content-Length',string.valueOf(xmlBody.length()));     
        req.setEndpoint('https://api.infusionsoft.com/crm/xmlrpc/v1?access_token=' + accessToken);
        req.setMethod('POST');
        req.setTimeout(60000);
        req.setBody(xmlBody);
          
        string bodyValue = '';
        if(test.isRunningTest()){
          bodyValue = getExamplePaymentXMLResult();
        }else{
          HttpResponse res = h.send(req);
          bodyValue = res.getBody();
        }

        if((bodyValue == '<h1>Developer Inactive</h1>' || bodyValue == '<h1>Not Authorized</h1>')){
            //Get new Access Token using the refresh token and call the api again
        }

        return bodyValue;
    }
    
    
    public static void xmlBodyToKeyValuePairs(List<Webcart_Payment__c> newPays) {
    	String xmlBody;
    	for (Webcart_Payment__c wcPay : newPays) {
    		xmlBody = '';
	    	if ((String.isBlank(wcPay.Webcart_Keys_and_Values__c)) && (wcPay.Payment_XML__c != null) && (!wcPay.Payment_XML__c.contains('methodResponse')) && (wcPay.Payment_XML__c.startsWith('<member>')) && (wcPay.Payment_XML__c.endsWith('</member>'))){
	    		xmlBody = '<methodResponse><params><param><value><array><data><value><struct>' + wcPay.Payment_XML__c + '</struct></value></data></array></value></param></params></methodResponse>';
	    	}
	    	List<webCartItemAction> wciList = parseWebCartToList(xmlBody);
	    	String keyValPairs = '';
	    	for (webCartItemAction wciItem : wciList) {
	    		keyValPairs += WebcartHelper.getKeyValuePairsFromMap(wciItem.actionMap);
	    	}
	    	
	    	if (!String.isBlank(keyValPairs)) {
	    		wcPay.Webcart_Keys_and_Values__c = keyValPairs;
	    	}
    	}
    }
}