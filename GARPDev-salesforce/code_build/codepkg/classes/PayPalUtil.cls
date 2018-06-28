public class PayPalUtil
{
    /*
        //To Generate Profile ID

        String strBody = '<?xml version="1.0" encoding="UTF-8" ?>';
        strBody += '<XMLPayRequest Timeout="30" version="2.0">';
        strBody += '<RequestData>';
        strBody += '<Vendor>GARPNY</Vendor>';
        strBody += '<Partner>VeriSign</Partner>';
        strBody += '<RecurringProfiles>';
        strBody += '<RecurringProfile Id="1">';
        strBody += '<Add>';
        strBody += '<Tender>';
        strBody += '<Card>';
        strBody += '<CardNum>5588280010757000</CardNum>';
        strBody += '<ExpDate>201702</ExpDate>';
        strBody += '<NameOnCard>Priscella Almeida</NameOnCard>';
        strBody += '</Card>';
        strBody += '</Tender>';
        strBody += '<RPData>';
        strBody += '<Name>Test Profile</Name>';
        strBody += '<ExtData Name="CURRENCY" Value="EUR"></ExtData>';
        strBody += '<TotalAmt>1.23</TotalAmt>';
        strBody += '<Start>12122020</Start>';
        strBody += '<Term>0</Term>';
        strBody += '<PayPeriod>Yearly</PayPeriod>';
        strBody += '<EMail>a.com</EMail>';
        strBody += '<OptionalTrans>Sale</OptionalTrans>';
        strBody += '<OptionalTransAmt>12</OptionalTransAmt>';
        strBody += '<BillTo>';
        strBody += '<Address>';
        strBody += '<Street>111 Town Square Pl</Street>';
        strBody += '<City>Jersey City</City>';
        strBody += '<State>NJ</State>';
        strBody += '<Zip>07310</Zip>';
        strBody += '</Address>';
        strBody += '</BillTo>';
        strBody += '</RPData>';
        strBody += '</Add>';
        strBody += '</RecurringProfile>';
        strBody += '</RecurringProfiles>';
        strBody += '</RequestData>';
        strBody += '<RequestAuth>';
        strBody += '<UserPass>';
        strBody += '<User>GARPNY</User>';
        strBody += '<Password>garp147view</Password>';
        strBody += '</UserPass>';
        strBody += '</RequestAuth>';
        strBody += '</XMLPayRequest>';

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://payflowpro.paypal.com');
         req.setMethod('POST');
         //String username = 'myname';
         //String password = 'mypwd';

         //Blob headerValue = Blob.valueOf(username + ':' + password);
         //String authorizationHeader = 'BASIC ' +
        // EncodingUtil.base64Encode(headerValue);
         //req.setHeader('Authorization', authorizationHeader);

         // Create a new http object to send the request object
         // A response object is generated as a result of the request  
        req.setBody(strBody);
         Http http = new Http();
         HTTPResponse res = http.send(req);
         System.debug(res.getBody());
         
         
         

        ***************************************************************************************************************
        //To Charge Based on Profile ID


        String strBody = '<?xml version="1.0" encoding="UTF-8" ?>';
        strBody += '<XMLPayRequest Timeout="30" version="2.0">';
        strBody += '<RequestData>';
        strBody += '<Vendor>GARPNY</Vendor>';
        strBody += '<Partner>VeriSign</Partner>';
        strBody += '<RecurringProfiles>';
        strBody += '<RecurringProfile Id="1">';
        strBody += '<Modify>';
        strBody += '<ProfileID>RP0000088779</ProfileID>';
        strBody += '<Tender>';
        strBody += '<Card>';
        strBody += '</Card>';
        strBody += '</Tender>';
        strBody += '<Transactions>';
        strBody += '<Transaction>RepeatSale</Transaction>';
        strBody += '</Transactions>';
        strBody += '<RPData>';
        strBody += '<Name>Test Profile</Name>';
        strBody += '<ExtData Name="CURRENCY" Value="EUR"></ExtData>';
        strBody += '<TotalAmt>1.23</TotalAmt>';
        strBody += '<Start>12122020</Start>';
        strBody += '<Term>0</Term>';
        strBody += '<PayPeriod>Yearly</PayPeriod>';
        strBody += '<EMail>a.com</EMail>';
        strBody += '<OptionalTrans>Sale</OptionalTrans>';
        strBody += '<OptionalTransAmt>12</OptionalTransAmt>';
        strBody += '</RPData>';
        strBody += '</Modify>';
        strBody += '</RecurringProfile>';
        strBody += '</RecurringProfiles>';
        strBody += '</RequestData>';
        strBody += '<RequestAuth>';
        strBody += '<UserPass>';
        strBody += '<User>GARPNY</User>';
        strBody += '<Password>garp147view</Password>';
        strBody += '</UserPass>';
        strBody += '</RequestAuth>';
        strBody += '</XMLPayRequest>';

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://payflowpro.paypal.com');
         req.setMethod('POST');
         //String username = 'myname';
         //String password = 'mypwd';

         //Blob headerValue = Blob.valueOf(username + ':' + password);
         //String authorizationHeader = 'BASIC ' +
        // EncodingUtil.base64Encode(headerValue);
         //req.setHeader('Authorization', authorizationHeader);

         // Create a new http object to send the request object
         // A response object is generated as a result of the request  
        req.setBody(strBody);
         Http http = new Http();
         HTTPResponse res = http.send(req);
         System.debug(res.getBody());
    */
}