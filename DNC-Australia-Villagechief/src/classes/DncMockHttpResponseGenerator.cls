@isTest
global class DncMockHttpResponseGenerator implements HttpCalloutMock{
    public static String testName;
    public static Map<String, boolean> washNumbersResults = new Map<String, Boolean>();
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        if ( testName == 'getAccountBalance' ){
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml; charset=utf-8');
            res.setBody(
            '<?xml version="1.0" encoding="utf-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            ' <soapenv:Body>' +
            '  <ns1:GetAccountBalanceResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem">' +
            '   <GetAccountBalanceReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap">' +
            '    <AccountBalance ErrorCode="0" TelemarketerId="18363" WashOnlyUserId="7587">123</AccountBalance>' +
            '   </GetAccountBalanceReturn>' +
            '  </ns1:GetAccountBalanceResponse>' +
            ' </soapenv:Body>' +
            '</soapenv:Envelope>');
            res.setStatusCode(200);
            return res;
        }else if ( testName == 'washNumbers' ){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml; charset=utf-8');
            String xml = '<?xml version="1.0" encoding="utf-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            ' <soapenv:Body>' +
            '  <ns1:WashNumbersResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem">' +
            '   <WashNumbersReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap">' +
            '    <NumbersSubmitted AccountBalance="500" ClientReferenceId="1234" ErrorCode="0" FinishDate="{ts 2013-10-12 00:00:00}" TelemarketerId="18363" TransactionId="9075319" WashOnlyUserId="7587">';
            
            for ( String num : washNumbersResults.keySet() ){
                xml += '     <Number Result="' + (washNumbersResults.get(num) ? 'Y' : 'N' ) + '">' + num + '</Number>';
            }
            
            xml += '    </NumbersSubmitted>' +
            '   </WashNumbersReturn>' +
            '  </ns1:WashNumbersResponse>' +
            ' </soapenv:Body>' +
            '</soapenv:Envelope>';
            res.setBody(xml);
            res.setStatusCode(200);
            return res;
        }else if ( testName == 'getWashResult' ){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml; charset=utf-8');
            res.setBody(
            '<?xml version="1.0" encoding="utf-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            ' <soapenv:Body>' +
            '  <ns1:GetWashResultResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem">' +
            '   <GetWashResultReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap">' +
            '    <NumbersSubmitted AccountBalance="" ClientReferenceId="1234" ErrorCode="0" FinishDate="2013-10-12 13:38:42.0" TelemarketerId="18363" TransactionId="9075319" WashOnlyUserId="7587">' +
            '     <Number Result="Y">0733513847</Number>' +
            '     <Number Result="N">04123</Number>' +
            '    </NumbersSubmitted>' +
            '   </GetWashResultReturn>' +
            '  </ns1:GetWashResultResponse>' +
            ' </soapenv:Body>' +
            '</soapenv:Envelope>');
            res.setStatusCode(200);
            return res;
            
        }else if ( testName == 'washNumbersError' ){
            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml; charset=utf-8');
            res.setBody(
            '<?xml version="1.0" encoding="utf-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            ' <soapenv:Body>' +
            '  <ns1:WashNumbersResponse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns1="http://rtw.dncrtelem">' +
            '   <WashNumbersReturn xsi:type="ns2:Document" xmlns:ns2="http://xml.apache.org/xml-soap">' +
            '    <NumbersSubmitted AccountBalance="" ClientReferenceId="A5BF" ErrorCode="1" FinishDate="" TelemarketerId="18363" TransactionId="" WashOnlyUserId="7587">0733513847<NumbersSubmitted>' +
            '   </WashNumbersReturn>' +
            '  </ns1:WashNumbersResponse>' +
            ' </soapenv:Body>' +
            '</soapenv:Envelope>');
            res.setStatusCode(200);
            return res;
        }else{
            system.assert(false, 'invalid testname');
            return null;
        }
        
    }
}