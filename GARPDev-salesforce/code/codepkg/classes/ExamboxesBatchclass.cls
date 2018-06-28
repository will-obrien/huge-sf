global class ExamboxesBatchclass implements Database.Batchable<sObject>,Database.Stateful{
 
     
     global string strUPS = 'New Order';
     global Date today = system.today();
     
     global final string strQuery = 'SELECT Active__c,Exam_Boxes__c,Exam_Box_Attention__c,Exam_Box_Country_Code_for_UPS__c,Exam_Box_UPS_service_code_for_XML__c,Exam_Box_UPS_Stage__c,Exam_Box_Weight__c,Fax__c,GARP_ID__c,Id,Name,Proctor__c,Reference_1_c__c,Reference_2__c,Service_type__c,ShipToAddress1__c,ShipToAddress2__c,ShipToAddress3__c,ShipToAttention__c,ShipToCityorTown__c,ShipToCompanyorName__c,ShipToCountryTerritory__c,ShipToCustomerID__c,ShipToEmailAddress__c,Pre_Test_Box_Reference_2__c,Shiptofirst_name__c,ShipToPostalCode__c,ShipToStateProvinceCounty__c,ShipToTelephone__c,Ship_To_Country_Code__c,Ship_to_last_name__c,SiteCode__c,SiteName__c,Site_ID__c,SystemModstamp,UPS_Response__c,Value__c,Weight__c FROM Shipping_Boxes__c where  Pre_Test_Box_UPS_Stage__c =: strUPS ';
   
     global List< Shipping_Boxes__c > lstDomesticcerts;
     global List< Shipping_Boxes__c > lstInternationalcerts;
     global List< Shipping_Boxes__c > lstInvoiceLesscerts;
     global String strInternationalXML = '';
     global String strDomesticXML = '';
     global String strInvoiceLessXML = '';
     global string strInvoiceLessExcelBodyString = '';
     global string strDomesticExcelBodyString = '';
     global string strInternationalExcelBodyString = '';
     global string strEmailBody = '';
     global string strExcelHeader = 'SNO,CompanyName,Attention,AddressLine1,AddressLine2,AddressLine3,City,State,Country,PostalCode,WorkPhone,FaxNumber,EmailAddress,ServiceType,2504,2505,914,861,2372,Invoice Number,length,TotalQuantity';
     global set<String> setInvoiceLessCountries = new set<String>{'AS', 'AU', 'AT', 'AZ', 'BE', 'KH', 'CA', 'IC', 'CN', 'CK', 'HR', 'CY', 'CZ', 'DK','DO', 'EN', 'EE', 'FJ', 'FI', 'FR', 'PF', 'DE', 'GU', 'GG', 'HO', 'HK', 'HU', 'IN','ID', 'IE', 'IT', 'JP', 'JE', 'KI', 'KO', 'LV', 'LI', 'LT', 'LU', 'MO', 'M3', 'MY','MV', 'MT', 'MH', 'MX', 'FM', 'MC', 'MN', 'NP', 'NL', 'NC', 'NZ', 'NB', 'MP', 'NO','PW', 'PG', 'PH', 'PL', 'PO', 'PT', 'PR', 'RO', 'RT', 'SP', 'SF', 'SG', 'SK', 'SI','SB', 'ZA', 'KR', 'ES', 'SX', 'UV', 'VL', 'SE', 'CH', 'SY', 'TA', 'TW', 'TH', 'TL','TI', 'TO', 'TU', 'TV', 'GB', 'VI', 'VU', 'VA', 'VN', 'WL', 'WF', 'WS', 'YA'};
     global ExamboxesBatchclass(){
        
     }
     
     // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('strQuery == '+strQuery);
        return Database.getQueryLocator(strQuery);
     }
    
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Shipping_Boxes__c> scope){
        
        system.debug('scope == '+scope);
        lstDomesticcerts = new list<Shipping_Boxes__c>();
        lstInternationalcerts = new list<Shipping_Boxes__c>();
        List< Shipping_Boxes__c > lstUpdatecerts = new List< Shipping_Boxes__c >();
        lstInvoiceLesscerts = new list<Shipping_Boxes__c>();
        for(Shipping_Boxes__c obj : scope)   
        {
            system.debug('Obj == '+obj);
             system.debug('Exam_Box_Country_Code_for_UPS__c == '+obj.Exam_Box_Country_Code_for_UPS__c);
            if(setInvoiceLessCountries.contains(obj.Exam_Box_Country_Code_for_UPS__c)) 
                lstInvoiceLesscerts.add(obj);
            else if(obj.Exam_Box_Country_Code_for_UPS__c == 'US') 
                lstDomesticcerts.add(obj);
            else 
                lstInternationalcerts.add(obj);
            
            obj.Exam_Box_UPS_Stage__c = 'Sent to GT';
            lstUpdatecerts.add(obj);
            
            
             
        }
        
        system.debug('lstInvoiceLesscerts == '+lstInvoiceLesscerts);
        system.debug('lstInternationalcerts == '+lstInternationalcerts);
        system.debug('lstDomesticcerts == '+lstDomesticcerts);
        if(lstDomesticcerts.size() > 0)
        {
                strDomesticXML += ExamBoxesxml.DomesticExam(lstDomesticcerts);
                
        }
        if(lstInternationalcerts.size() > 0)
        {
                strInternationalXML += ExamBoxesxml.InvoiceForExam(lstInternationalcerts);
                
        }
        if(lstInvoiceLesscerts.size() > 0)
        {
                strInvoiceLessXML += ExamBoxesxml.InvoiceLessExam(lstInvoiceLesscerts);
               
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
        
        system.debug('lstEmailAttachments == '+lstEmailAttachments);
        mail.setFileAttachments(lstEmailAttachments);
        mail.setToAddresses(new String[] {'vvkathi@gmail.com'});
        mail.setReplyTo('vvkathi@gmail.com');
        mail.setSenderDisplayName('Exam Boxes XML Files');
        mail.setSubject('XML Files');
        mail.setHTMLBody(strEmailBody);
        try {
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
        }catch(Exception e){
                    System.Debug(e);
                } 
       
    }
    }