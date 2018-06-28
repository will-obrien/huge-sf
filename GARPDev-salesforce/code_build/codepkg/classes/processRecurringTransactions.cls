global class processRecurringTransactions implements Database.Batchable<SObject>, Database.Stateful,Database.AllowsCallouts
{
    global PayPal_Recurring_Settings__c payPalSettings;
    global List<ChargentSFA__Transaction__c> lstTransactions = new List<ChargentSFA__Transaction__c>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String strStatus = 'Approved';
        payPalSettings = PayPal_Recurring_Settings__c.getOrgDefaults();
        return Database.getQueryLocator('select id,ChargentSFA__Amount__c,ChargentSFA__Opportunity__c,ChargentSFA__Opportunity__r.Display_Invoice_Number__c,ChargentSFA__Opportunity__r.account.Profile_ID__c from ChargentSFA__Transaction__c where ChargentSFA__Recurring__c = true and (ChargentSFA__Gateway_Date__c = TODAY or Charge_Now__c = true) and ChargentSFA__Response_Status__c !=: strStatus and ChargentSFA__Opportunity__r.account.Profile_ID__c != null');
     }
    
    
    global void execute(Database.BatchableContext BC, List<ChargentSFA__Transaction__c> scope){

        for(ChargentSFA__Transaction__c obj : scope)
        {
            String strBody = '<?xml version="1.0" encoding="UTF-8" ?>';
            strBody += '<XMLPayRequest Timeout="30" version="2.0">';
            strBody += '<RequestData>';
            strBody += '<Vendor>'+payPalSettings.Vendor__c+'</Vendor>';
            strBody += '<Partner>'+payPalSettings.Partner__c+'</Partner>';
            strBody += '<RecurringProfiles>';
            strBody += '<RecurringProfile Id="1">';
            strBody += '<Modify>';
            strBody += '<ProfileID>'+ obj.ChargentSFA__Opportunity__r.account.Profile_ID__c +'</ProfileID>';
            strBody += '<Tender>';
            strBody += '<Card>';
            strBody += '</Card>';
            strBody += '</Tender>';
            strBody += '<Transactions>';
            strBody += '<Transaction>RepeatSale</Transaction>';
           
            strBody += '</Transactions>';
            strBody += '<RPData>';
            strBody += '<Name>Test Profile</Name>';
            strBody += '<ExtData Name="CURRENCY" Value="USD"></ExtData>';
            strBody += '<TotalAmt>'+obj.ChargentSFA__Amount__c +'</TotalAmt>';
            //strBody += '<Start>12122020</Start>';
            //strBody += '<Term>0</Term>';
            //strBody += '<PayPeriod>Yearly</PayPeriod>';
            //strBody += '<EMail>a.com</EMail>';
            strBody += '<OptionalTrans>Sale</OptionalTrans>';
            strBody += '<OptionalTransAmt>'+obj.ChargentSFA__Amount__c +'</OptionalTransAmt>';
            strBody += '<Comment>'+obj.ChargentSFA__Opportunity__r.Display_Invoice_Number__c+'</Comment>';
            strBody += '</RPData>';
            strBody += '</Modify>';
            strBody += '</RecurringProfile>';
            strBody += '</RecurringProfiles>';
            strBody += '</RequestData>';
            strBody += '<RequestAuth>';
            strBody += '<UserPass>';
            strBody += '<User>'+payPalSettings.UserName__c+'</User>';
            strBody += '<Password>'+payPalSettings.Password__c+'</Password>';
            strBody += '</UserPass>';
            strBody += '</RequestAuth>';
            strBody += '</XMLPayRequest>';

            HttpRequest req = new HttpRequest();
            req.setEndpoint(payPalSettings.EndPoint__c);
            req.setMethod('POST');
            req.setBody(strBody);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            //System.debug(res.getBody());
            Dom.Document doc = new Dom.Document();
            doc.load(res.getBody());
            Dom.XMLNode payPalResponse = doc.getRootElement();

            String message;
            String txnRef;
            String authCode = '';
            String response;

            string nameSpace = 'http://www.paypal.com/XMLPay';
            try
            {
            
                response = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('RecurringProfileResults',nameSpace).getChildElement('RecurringProfileResult',nameSpace).getChildElement('Result',nameSpace).getText());
                
                
                message = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('RecurringProfileResults',nameSpace).getChildElement('RecurringProfileResult',nameSpace).getChildElement('Message',nameSpace).getText());


                txnRef = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('RecurringProfileResults',nameSpace).getChildElement('RecurringProfileResult',nameSpace).getChildElement('ExtData',nameSpace).getAttributeValue('Value',null));
                
                if(response == '0')
                {
                    authCode = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('RecurringProfileResults',nameSpace).getChildElement('RecurringProfileResult',nameSpace).getChildElement('TransactionResult',namespace).getChildElement('AuthCode',nameSpace).getText());
                }

                

            }
            catch(exception ex)
            {
                message = ex.getMessage();

            }
            finally
            {
                system.debug('Message ='+message);
                string resBody = res.getBody();
                ChargentSFA__Transaction__c newTransaction = new ChargentSFA__Transaction__c();
                newTransaction.ChargentSFA__Gateway_Response__c = (resBody != null && resBody.length() > 32768) ? resBody.substring(0) : resBody;
                newTransaction.ChargentSFA__Opportunity__c = obj.ChargentSFA__Opportunity__c;
                newTransaction.ChargentSFA__Type__c = 'Charge';
                newTransaction.ChargentSFA__Response_Message__c = (message != null && message.length() > 127) ? message.substring(0,125) : message;           
                newTransaction.ChargentSFA__Response_Status__c = (message != null && message.length() > 32) ? message.substring(0,32) : message;   
                newTransaction.ChargentSFA__Amount__c = obj.ChargentSFA__Amount__c;
                newTransaction.ChargentSFA__Payment_Method__c = 'Credit Card';
                newTransaction.ChargentSFA__Gateway_Date__c = system.now();
                newTransaction.ChargentSFA__Recurring__c = true;
                newTransaction.ChargentSFA__Gateway__c = payPalSettings.Paypal_GateWay_ID__c;//'a1lf000000045VS'; //a0A4000000uA1fUEAS
                newTransaction.ChargentSFA__Gateway_ID__c = txnRef;
                newTransaction.ChargentSFA__Tokenization__c = txnRef;
                newTransaction.ChargentSFA__Authorization__c = authCode;
                newTransaction.ChargentSFA__Response__c = response;
                lstTransactions.add(newTransaction);

            }
            

        }



    }
   
    global void finish(Database.BatchableContext BC){
        Database.SaveResult[] saveResult;
        if(!lstTransactions.isEmpty())
           saveResult =  Database.Insert(lstTransactions,false);
           
        system.debug('saveResult == '+saveResult);

        try
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {payPalSettings.Email_Address__c});
            mail.setReplyTo(payPalSettings.Email_Address__c);
            mail.setSenderDisplayName('Paypal Processing');
            mail.setSubject('Paypal Batch Process Completed');
            mail.setPlainTextBody('Paypal Batch Process has completed');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(exception ex)
        {

        }
    }

}