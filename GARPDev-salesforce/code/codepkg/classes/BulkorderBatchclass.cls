global class BulkorderBatchclass implements Database.Batchable<sObject>,Database.Stateful{
 
    
     global string strUPS = 'New Order';
     
     global final string strQuery = 'SELECT Country_Code_for_UPS__c,Duty_Tax_To_GARP__c,Customs_cost__c,Date_Sent_to_GT__c,E_mail__c,Id,Name,OwnerId,Product_Id__c,Product_Names__c,Shipping_Address_1__c,Shipping_Address_2__c,Shipping_Address_3__c,Shipping_Attention__c,Shipping_City__c,Shipping_Company__c,Shipping_Country__c,Shipping_Phone_Number__c,Shipping_Postal_Code__c,Shipping_State_Provence__c,UPS_service_code_for_XML__c,UPS_Stage__c,Weight__c FROM Bulk_Orders__c where Ups_Stage__c =: strUPS ';
    

     global List<Bulk_Orders__c> lstDomesticOpps;
     global List<Bulk_Orders__c> lstInternationalOpps;
     global List<Bulk_Orders__c> lstInvoiceLessOpps;
     global String strInternationalXML = '';
     global String strDomesticXML = '';
     global String strInvoiceLessXML = '';
     global string strInvoiceLessExcelBodyString = '';
     global string strDomesticExcelBodyString = '';
     global string strInternationalExcelBodyString = '';
     global string strEmailBody = '';
     global string strExcelHeader = 'SNO,CompanyName,Attention,AddressLine1,AddressLine2,AddressLine3,City,State,Country,PostalCode,WorkPhone,FaxNumber,EmailAddress,ServiceType,2504,2505,914,861,2372,Invoice Number,length,TotalQuantity';
     global set<String> setInvoiceLessCountries = new set<String>{'AS', 'AU', 'AT', 'AZ', 'BE', 'KH', 'CA', 'IC', 'CN', 'CK', 'HR', 'CY', 'CZ', 'DK','DO', 'EN', 'EE', 'FJ', 'FI', 'FR', 'PF', 'DE', 'GU', 'GG', 'HO', 'HK', 'HU', 'IN','ID', 'IE', 'IT', 'JP', 'JE', 'KI', 'KO', 'LV', 'LI', 'LT', 'LU', 'MO', 'M3', 'MY','MV', 'MT', 'MH', 'MX', 'FM', 'MC', 'MN', 'NP', 'NL', 'NC', 'NZ', 'NB', 'MP', 'NO','PW', 'PG', 'PH', 'PL', 'PO', 'PT', 'PR', 'RO', 'RT', 'SP', 'SF', 'SG', 'SK', 'SI','SB', 'ZA', 'KR', 'ES', 'SX', 'UV', 'VL', 'SE', 'CH', 'SY', 'TA', 'TW', 'TH', 'TL','TI', 'TO', 'TU', 'TV', 'GB', 'VI', 'VU', 'VA', 'VN', 'WL', 'WF', 'WS', 'YA'};
     global BulkorderBatchclass(){
        
     }
     
     // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator(strQuery);
     
     }
    
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Bulk_Orders__c> scope){
        
        system.debug('scope == '+scope);
        lstDomesticOpps = new list<Bulk_Orders__c>();
        lstInternationalOpps = new list<Bulk_Orders__c>();
        List<Bulk_Orders__c> lstUpdateOpps = new List<Bulk_Orders__c>();
        lstInvoiceLessOpps = new list<Bulk_Orders__c>();
        for(Bulk_Orders__c obj : scope)   
        {
            system.debug('Obj == '+obj);
            if(setInvoiceLessCountries.contains(obj.Country_Code_for_UPS__c)) lstInvoiceLessOpps.add(obj);
            else if(obj.Country_Code_for_UPS__c == 'US') lstDomesticOpps.add(obj);
            else lstInternationalOpps.add(obj);
            
            obj.Ups_Stage__c = 'Sent to GT';
            lstUpdateOpps.add(obj);
            
            
             
        }
        
        system.debug('lstInvoiceLessOpps == '+lstInvoiceLessOpps);
        system.debug('lstInternationalOpps == '+lstInternationalOpps);
        system.debug('lstDomesticOpps == '+lstDomesticOpps);
        if(lstDomesticOpps.size() > 0)
        {
                strDomesticXML += BulkorderXML.domesticShipping(lstDomesticOpps);
               
        }
        if(lstInternationalOpps.size() > 0)
        {
                strInternationalXML += BulkorderXML.internationalShipping(lstInternationalOpps);
               
        }
        if(lstInvoiceLessOpps.size() > 0)
        {
                strInvoiceLessXML += BulkorderXML.invoicelessXML(lstInvoiceLessOpps);
                
        }
       
        update lstUpdateOpps;
   
    }
   
    global void finish(Database.BatchableContext BC){
        system.debug('strDomesticXML == '+strDomesticXML);
        system.debug('strInternationalXML == '+strInternationalXML);
        system.debug('strInvoiceLessXML == '+strInvoiceLessXML);
        system.debug('strInvoiceLessExcelBodyString == '+strInvoiceLessExcelBodyString);
        system.debug('strDomesticExcelBodyString == '+strDomesticExcelBodyString);
        system.debug('strInternationalExcelBodyString == '+strInternationalExcelBodyString);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String myString = 'StringToBlob';
        String strXMLHeder = '<?xml version="1.0" encoding="windows-1252"?>';
        string strShipMentsStart = '<OpenShipments xmlns="x-schema:OpenShipments.xdr">';
        string strShipMentsClosingTag = '</OpenShipments>';
        List<Messaging.EmailFileAttachment> lstEmailAttachments = new List<Messaging.EmailFileAttachment>();
        String strDateValue = String.valueOf(System.today().Month())+String.valueOf(System.today().Day())+String.valueOf(System.today().Year());
        if(strDomesticXML != '')
        {
            
            strDomesticXML =  strXMLHeder + strShipMentsStart + strDomesticXML +strShipMentsClosingTag;
            Blob domesticBlob = Blob.valueof(strDomesticXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            String strFieName = 'domestic'+'_'+strDateValue+'.xml';
            attachment.setFileName(strFieName);
            system.debug('domesticBlob == '+domesticBlob.toString());
            attachment.setBody(domesticBlob);
            lstEmailAttachments.add(attachment);
            
        }
        if(strInternationalXML != '')
        {
            
            strInternationalXML =  strXMLHeder + strShipMentsStart + strInternationalXML +strShipMentsClosingTag;
            Blob internationalBlob = Blob.valueof(strInternationalXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
             String strFieName = 'international'+'_'+strDateValue+'.xml';
            attachment.setFileName(strFieName);
            attachment.setBody(internationalBlob);
            lstEmailAttachments.add(attachment);
        
        }
        if(strInvoiceLessXML != '')
        {
            strInvoiceLessXML =  strXMLHeder + strShipMentsStart + strInvoiceLessXML +strShipMentsClosingTag;
            Blob invoicelessBlob = Blob.valueof(strInvoiceLessXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
           
             String strFieName = 'invoiceless'+'_'+strDateValue+'.xml';
            attachment.setFileName(strFieName);
            system.debug('invoicelessBlob == '+invoicelessBlob.toString());
            attachment.setBody(invoicelessBlob);
            lstEmailAttachments.add(attachment);
        
        }
       
       
        system.debug('lstEmailAttachments == '+lstEmailAttachments);
        mail.setFileAttachments(lstEmailAttachments);
        mail.setToAddresses(new String[] {'vvkathi@gmail.com'});
        mail.setReplyTo('vvkathi@gmail.com');
        mail.setSenderDisplayName('Bulk Order XML Files');
        mail.setSubject('XML Files');
        mail.setHTMLBody(strEmailBody);
        try {
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
        }catch(Exception e){
                    System.Debug(e);
                } 
       
    }
    }