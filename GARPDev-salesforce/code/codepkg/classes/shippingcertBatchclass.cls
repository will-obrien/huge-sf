global class shippingcertBatchclass implements Database.Batchable<sObject>,Database.Stateful{
 
     
     global string strUPS = 'New Order';
     global Date today = system.today();
     global final string strQuery = 'SELECT Id, Garp_id__c, Name, Country_Code_for_UPS__c,Customs_Cost__c, IsDeleted, Duty_Tax_to_Garp__c, Member__c, OwnerId, Product_Names__c, Shipping_Attention__c, Shipping_City__c, Shipping_Company_Name__c, Shipping_Country__c, Shipping_E_mail__c, Shipping_Phone_No__c, Shipping_Postal_Code__c, Shipping_State__c, Shipping_Address1__c, Shipping_Address2__c, Shipping_Address3__c, SystemModstamp, Total_Package_Weight__c, UPS_Service_Code_For_Xml__c, Ups_Stage__c FROM certificate_shipping__c where  Ups_Stage__c =: strUPS ';
     global List< certificate_shipping__c > lstDomesticcerts;
     global List< certificate_shipping__c > lstInternationalcerts;
     global List< certificate_shipping__c > lstInvoiceLesscerts;
     global String strInternationalXML = '';
     global String strDomesticXML = '';
     global String strInvoiceLessXML = '';
     global string strInvoiceLessExcelBodyString = '';
     global string strDomesticExcelBodyString = '';
     global string strInternationalExcelBodyString = '';
     global string strEmailBody = '';
     global string strExcelHeader = 'SNO,CompanyName,Attention,AddressLine1,AddressLine2,AddressLine3,City,State,Country,PostalCode,WorkPhone,FaxNumber,EmailAddress,ServiceType,2504,2505,914,861,2372,Invoice Number,length,TotalQuantity';
     global set<String> setInvoiceLessCountries = new set<String>{'AS', 'AU', 'AT', 'AZ', 'BE', 'KH', 'CA', 'IC', 'CN', 'CK', 'HR', 'CY', 'CZ', 'DK','DO', 'EN', 'EE', 'FJ', 'FI', 'FR', 'PF', 'DE', 'GU', 'GG', 'HO', 'HK', 'HU', 'IN','ID', 'IE', 'IT', 'JP', 'JE', 'KI', 'KO', 'LV', 'LI', 'LT', 'LU', 'MO', 'M3', 'MY','MV', 'MT', 'MH', 'MX', 'FM', 'MC', 'MN', 'NP', 'NL', 'NC', 'NZ', 'NB', 'MP', 'NO','PW', 'PG', 'PH', 'PL', 'PO', 'PT', 'PR', 'RO', 'RT', 'SP', 'SF', 'SG', 'SK', 'SI','SB', 'ZA', 'KR', 'ES', 'SX', 'UV', 'VL', 'SE', 'CH', 'SY', 'TA', 'TW', 'TH', 'TL','TI', 'TO', 'TU', 'TV', 'GB', 'VI', 'VU', 'VA', 'VN', 'WL', 'WF', 'WS', 'YA'};
     global shippingcertBatchclass(){
        
     }
     
     // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('strQuery == '+strQuery);
        return Database.getQueryLocator(strQuery);
     }
    
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<certificate_shipping__c> scope){
        
        system.debug('scope == '+scope);
        lstDomesticcerts = new list<certificate_shipping__c>();
        lstInternationalcerts = new list<certificate_shipping__c>();
        List< certificate_shipping__c > lstUpdatecerts = new List< certificate_shipping__c >();
        lstInvoiceLesscerts = new list<certificate_shipping__c>();
        for(certificate_shipping__c obj : scope)   
        {
            system.debug('Obj == '+obj);
            if(setInvoiceLessCountries.contains(obj.Country_Code_for_UPS__c)) 
                lstInvoiceLesscerts.add(obj);
            else if(obj.Country_Code_for_UPS__c == 'US') 
                lstDomesticcerts.add(obj);
            else 
                lstInternationalcerts.add(obj);
            
            obj.Ups_Stage__c = 'Sent to GT';
            lstUpdatecerts.add(obj);
            
            
             
        }
        
        system.debug('lstInvoiceLesscerts == '+lstInvoiceLesscerts);
        system.debug('lstInternationalcerts == '+lstInternationalcerts);
        system.debug('lstDomesticcerts == '+lstDomesticcerts);
        if(lstDomesticcerts.size() > 0)
        {
                strDomesticXML += shippingcertsxml.domesticShipping(lstDomesticcerts);
                
        }
        if(lstInternationalcerts.size() > 0)
        {
                strInternationalXML += shippingcertsxml.internationalShipping(lstInternationalcerts);
                
        }
        if(lstInvoiceLesscerts.size() > 0)
        {
                strInvoiceLessXML += shippingcertsxml.invoicelessXML(lstInvoiceLesscerts);
               
        }
       
        update lstUpdatecerts;
   
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
        if(strInvoiceLessExcelBodyString != '')
        {
            strInvoiceLessExcelBodyString =  strExcelHeader + '\r\n' + strInvoiceLessExcelBodyString;
            Blob InvoiceLessExcellBlob = Blob.valueof(strInvoiceLessExcelBodyString);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            
            String strFieName = 'invoiceless'+'_'+strDateValue+'.csv';
            attachment.setFileName(strFieName);
            system.debug('Invoice excellBlob == '+InvoiceLessExcellBlob.toString());
            attachment.setBody(InvoiceLessExcellBlob);
            lstEmailAttachments.add(attachment);
        
        }
        if(strDomesticExcelBodyString != '')
        {
            strDomesticExcelBodyString =  strExcelHeader + '\r\n' + strDomesticExcelBodyString;
            Blob DomesticExcellBlob = Blob.valueof(strDomesticExcelBodyString);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            String strFieName = 'domestic'+'_'+strDateValue+'.csv';
            attachment.setFileName(strFieName);
            system.debug('DomesticExcellBlob == '+DomesticExcellBlob.toString());
            attachment.setBody(DomesticExcellBlob);
            lstEmailAttachments.add(attachment);
        
        }
        if(strInternationalExcelBodyString != '')
        {
            strInternationalExcelBodyString =  strExcelHeader + '\r\n' +strInternationalExcelBodyString;
            Blob InternationalExcellBlob = Blob.valueof(strInternationalExcelBodyString);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            String strFieName = 'international'+'_'+strDateValue+'.csv';
            attachment.setFileName(strFieName);
            attachment.setBody(InternationalExcellBlob);
            lstEmailAttachments.add(attachment);
        
        }
        system.debug('lstEmailAttachments == '+lstEmailAttachments);
        mail.setFileAttachments(lstEmailAttachments);
        mail.setToAddresses(new String[] {'vvkathi@gmail.com'});
        mail.setReplyTo('vvkathi@gmail.com');
        mail.setSenderDisplayName('cert XML Files');
        mail.setSubject('XML Files');
        mail.setHTMLBody(strEmailBody);
        try {
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
        }catch(Exception e){
                    System.Debug(e);
                } 
       
    }
    }