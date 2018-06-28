public class cancelRecurringPayments {
    @Future  (callout=true)
    public static void cancelRecurringPays(String strProfileId)
    {
          Http h = new Http();
          HttpRequest req = new HttpRequest();
          String url = 'https://api-3t.sandbox.paypal.com/2.0/';
          string un = 'rob.cohen_api1.garp.com';
          string pw = '1396888252';
          string sig = 'AFcWxV21C7fd0v3bYYYRCpSSRl31A0UEIumLoG8JKpJcf-zAjLfgZKvj';
          
          
          String strCancelRecurring;
          strCancelRecurring =  '<soap:Envelope xmlns:soap=' + '\'' + 'http://schemas.xmlsoap.org/soap/envelope/'  + '\'' + ' xmlns:xsi=' + '\''+ 'http://www.w3.org/2001/XMLSchema-instance'  + '\'' + ' xmlns:xsd=' + '\''+ 'http://www.w3.org/2001/XMLSchema' + '\'' + '>';
          strCancelRecurring += '<soap:Header><RequesterCredentials xmlns="urn:ebay:api:PayPalAPI"><Credentials xmlns="urn:ebay:apis:eBLBaseComponents">';
          strCancelRecurring += '<Username>' + un + '</Username><ebl:Password xmlns:ebl="urn:ebay:apis:eBLBaseComponents">' + pw;
          strCancelRecurring += '</ebl:Password><Signature>' + sig + '</Signature>';
          strCancelRecurring += '</Credentials>';
          strCancelRecurring += '</RequesterCredentials>';
          strCancelRecurring += '</soap:Header><soap:Body>';
          strCancelRecurring += '<ManageRecurringPaymentsProfileStatusReq xmlns="urn:ebay:api:PayPalAPI"><ManageRecurringPaymentsProfileStatusRequest><Version xmlns="urn:ebay:apis:eBLBaseComponents">58.0</Version><ManageRecurringPaymentsProfileStatusRequestDetails xmlns="urn:ebay:apis:eBLBaseComponents"> <ProfileID>'+strProfileId+'</ProfileID> <Action>Cancel</Action> </ManageRecurringPaymentsProfileStatusRequestDetails> </ManageRecurringPaymentsProfileStatusRequest> </ManageRecurringPaymentsProfileStatusReq>';
          strCancelRecurring += '</soap:Body></soap:Envelope>';
        
          system.debug('XML REQ ==' + strCancelRecurring);
          req.setBody(strCancelRecurring);
          
          req.setEndpoint(url);
          req.setMethod('POST');
          req.setHeader('Content-length', '1753' );
          req.setHeader('Content-Type', 'text/xml;charset=UTF-8'); 
          req.setHeader('SOAPAction','');
          req.setHeader('Host','api-aa.sandbox.paypal.com');
          HttpResponse res = h.send(req);
          String xml = res.getBody();
          system.debug('XML' + xml);
          
    
    }
    
    @Future  (callout=true)
    public static void updatePaymentAmount(String strProfileId,decimal dAmount,date dtNextPaymentDate)
    {
          Http h = new Http();
          HttpRequest req = new HttpRequest();
          String url = 'https://api-3t.sandbox.paypal.com/2.0/';
          string un = 'rob.cohen_api1.garp.com';
          string pw = '1396888252';
          string sig = 'AFcWxV21C7fd0v3bYYYRCpSSRl31A0UEIumLoG8JKpJcf-zAjLfgZKvj';
          
          
          String strCancelRecurring;
          /*strCancelRecurring =  '<soap:Envelope xmlns:soap=' + '\'' + 'http://schemas.xmlsoap.org/soap/envelope/'  + '\'' + ' xmlns:xsi=' + '\''+ 'http://www.w3.org/2001/XMLSchema-instance'  + '\'' + ' xmlns:xsd=' + '\''+ 'http://www.w3.org/2001/XMLSchema' + '\'' + '>';
          strCancelRecurring += '<soap:Header><RequesterCredentials xmlns="urn:ebay:api:PayPalAPI"><Credentials xmlns="urn:ebay:apis:eBLBaseComponents">';
          strCancelRecurring += '<Username>' + un + '</Username><ebl:Password xmlns:ebl="urn:ebay:apis:eBLBaseComponents">' + pw;
          strCancelRecurring += '</ebl:Password><Signature>' + sig + '</Signature>';
          strCancelRecurring += '</Credentials>';
          strCancelRecurring += '</RequesterCredentials>';
          strCancelRecurring += '</soap:Header><soap:Body>';
          strCancelRecurring += '<UpdateRecurringPaymentsProfileReq xmlns="urn:ebay:api:PayPalAPI"><UpdateRecurringPaymentsProfileRequest><Version xmlns="urn:ebay:apis:eBLBaseComponents">58.0</Version><UpdateRecurringPaymentsProfileRequestDetails xmlns="urn:ebay:apis:eBLBaseComponents"> <ProfileID>'+strProfileId+'</ProfileID><Amount>'+dAmount+'</Amount><PROFILESTARTDATE>'+dtNextPaymentDate+'</PROFILESTARTDATE></UpdateRecurringPaymentsProfileRequestDetails> </UpdateRecurringPaymentsProfileRequest> </UpdateRecurringPaymentsProfileReq>';
          strCancelRecurring += '</soap:Body></soap:Envelope>';
         */
         strCancelRecurring = '<soapenv:Envelope  xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:ns="urn:ebay:api:PayPalAPI" xmlns:ebl="urn:ebay:apis:eBLBaseComponents" xmlns:cc="urn:ebay:apis:CoreComponentTypes" xmlns:ed="urn:ebay:apis:EnhancedDataTypes" >';
          strCancelRecurring += '<soapenv:Header>';
            strCancelRecurring += '<ns:RequesterCredentials>';
              strCancelRecurring += '<ebl:Credentials>';
                strCancelRecurring += '<ebl:Username>'+un+'</ebl:Username>';
                strCancelRecurring += '<ebl:Password>'+pw+'</ebl:Password>';
                strCancelRecurring += '<ebl:Signature>'+sig+'</ebl:Signature>';
              strCancelRecurring += '</ebl:Credentials>';
           strCancelRecurring += ' </ns:RequesterCredentials>';
         strCancelRecurring += ' </soapenv:Header>';
          strCancelRecurring += '<soapenv:Body>';
            strCancelRecurring += '<ns:UpdateRecurringPaymentsProfileReq>';
              strCancelRecurring += '<ns:UpdateRecurringPaymentsProfileRequest>';
                strCancelRecurring += '<ebl:UpdateRecurringPaymentsProfileRequestDetails>';
                  strCancelRecurring += '<ebl:ProfileID>'+strProfileId+'</ebl:ProfileID>';
                  strCancelRecurring += '<ebl:Amount currencyID="USD">'+dAmount+'</ebl:Amount>';
                  strCancelRecurring += '<ebl:BillingStartDate>'+dtNextPaymentDate+'</ebl:BillingStartDate>';
                strCancelRecurring += '</ebl:UpdateRecurringPaymentsProfileRequestDetails>';
                strCancelRecurring += '<ebl:Version>94.0</ebl:Version>';
              strCancelRecurring += '</ns:UpdateRecurringPaymentsProfileRequest>';
           strCancelRecurring += ' </ns:UpdateRecurringPaymentsProfileReq>';
          strCancelRecurring += '</soapenv:Body>';
        strCancelRecurring += '</soapenv:Envelope>';

         
          req.setBody(strCancelRecurring);
          
          req.setEndpoint(url);
          req.setMethod('POST');
          req.setHeader('Content-length', '1753' );
          req.setHeader('Content-Type', 'text/xml;charset=UTF-8'); 
          req.setHeader('SOAPAction','');
          req.setHeader('Host','api-aa.sandbox.paypal.com');
          req.setTimeout(2000); 
           system.debug('XML REQ ==' + req);
          HttpResponse res = h.send(req);
          String xml = res.getBody();
          system.debug('OUTPUT FROM CALLOUT' + xml);
          
    
    }
    
    

}