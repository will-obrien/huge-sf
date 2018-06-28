public class ShippingXMLS
{
    static List<Shipping_Boxes__c> lstDomesticProctored;
    static List<Shipping_Boxes__c> lstDomesticExam;
    static List<Shipping_Boxes__c> lstInvoiceProctored;
    static List<Shipping_Boxes__c> lstInvoiceExam;
    static List<Shipping_Boxes__c> lstInvoiceLessProctored;
    static List<Shipping_Boxes__c> lstInvoiceLessExam;
    
    public static void resetLists()
    {
        lstDomesticProctored = new List<Shipping_Boxes__c>();
        lstDomesticExam = new List<Shipping_Boxes__c>();
        lstInvoiceProctored = new List<Shipping_Boxes__c>();
        lstInvoiceExam = new List<Shipping_Boxes__c>();
        lstInvoiceLessProctored = new List<Shipping_Boxes__c>();
        lstInvoiceLessExam = new List<Shipping_Boxes__c>();
    }
    public static void getShippingInfo()
    {
        resetLists();
        set<String> setInvoiceLessCountries = new set<String>{'AS', 'AU', 'AT', 'AZ', 'BE', 'KH', 'CA', 'IC', 'CN', 'CK', 'HR', 'CY', 'CZ', 
                                                            'DK','DO', 'EN', 'EE', 'FJ', 'FI', 'FR', 'PF', 'DE', 'GU', 'GG', 'HO', 'HK', 'HU',
                                                            'IN','ID', 'IE', 'IT', 'JP', 'JE', 'KI', 'KO', 'LV', 'LI', 'LT', 'LU', 'MO', 'M3', 
                                                            'MY','MV', 'MT', 'MH', 'MX', 'FM', 'MC', 'MN', 'NP', 'NL', 'NC', 'NZ', 'NB', 'MP', 
                                                            'NO','PW', 'PG', 'PH', 'PL', 'PO', 'PT', 'PR', 'RO', 'RT', 'SP', 'SF', 'SG', 'SK', 
                                                            'SI','SB', 'ZA', 'KR', 'ES', 'SX', 'UV', 'VL', 'SE', 'CH', 'SY', 'TA', 'TW', 'TH', 
                                                            'TL','TI', 'TO', 'TU', 'TV', 'GB', 'VI', 'VU', 'VA', 'VN', 'WL', 'WF', 'WS', 'YA'};
 
        for(Shipping_Boxes__c obj : [select id,Name,Active__c,Exam_Boxes__c,Fax__c,Proctor_Boxes__c,Reference_2__c,ShipToAddress1__c,ShipToAddress2__c,
                                    Shiptofirst_name__c, Ship_to_last_name__c, GARP_ID__c,
                                    ShipToAddress3__c,ShipToAttention__c,ShipToCityorTown__c,ShipToCompanyorName__c,ShipToCountryTerritory__c,
                                    ShipToCustomerID__c,ShipToEmailAddress__c,ShipToPostalCode__c,ShipToStateProvinceCounty__c,ShipToTelephone__c,
                                    SiteCode__c,Site_ID__c,Duplicate_Certificate__c,Service_type__c,SiteName__c,Value__c,Weight__c from Shipping_Boxes__c where Active__c =: true])
            {
            
                    if(obj.ShipToCountryTerritory__c == 'US')
                    {
                        if(obj.Proctor_Boxes__c)
                            lstDomesticProctored.add(obj);
                        else
                            lstDomesticExam.add(obj);
                    }
                    else if(setInvoiceLessCountries.contains(obj.ShipToCountryTerritory__c))
                    {
                        if(obj.Proctor_Boxes__c)
                            lstInvoiceLessProctored.add(obj);
                        else
                            lstInvoiceLessExam.add(obj);
                    }
                    else
                    {
                        if(obj.Proctor_Boxes__c)
                            lstInvoiceProctored.add(obj);
                        else
                            lstInvoiceExam.add(obj);
                    }
            
            }
            
        String strDomesticExamXML = lstDomesticExam.size() > 0 ? domesticExamXML(lstDomesticExam) : '';
        String strDomesticProctoredXML = lstDomesticProctored.size() > 0 ? domesticProctoredXML(lstDomesticProctored) : '';
        String strInvoiceLessExamXML = lstInvoiceLessExam.size() > 0 ? InvoiceLessExamXML(lstInvoiceLessExam) : '';
        String strInvoiceLessProctoredExamXML = lstInvoiceLessProctored.size() > 0 ? InvoiceLessProctoredExamXML(lstInvoiceLessProctored) : '';
        String strInvoiceExamXML = lstInvoiceExam.size() > 0 ? InvoiceExamXML(lstInvoiceExam) : '';
        String strInvoiceProctoredXML = lstInvoiceProctored.size() > 0 ? InvoiceProctoredXML(lstInvoiceProctored) : '';
        SendEmail(strDomesticExamXML,strDomesticProctoredXML,strInvoiceLessExamXML,strInvoiceLessProctoredExamXML,strInvoiceExamXML,strInvoiceProctoredXML);
    }
    
    public static void SendEmail(string strDomesticExamXML,string strDomesticProctoredXML,string strInvoiceLessExamXML,
                                    string strInvoiceLessProctoredExamXML,string strInvoiceExamXML,string strInvoiceProctoredXML)
    {
         List<Messaging.EmailFileAttachment> lstEmailAttachments = new List<Messaging.EmailFileAttachment>();
        if(strDomesticExamXML != '')
        {
            Blob blobval = Blob.valueof(strDomesticExamXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('DomesticExam.xml');
            attachment.setBody(blobval);
            lstEmailAttachments.add(attachment);
            
        }
        if(strDomesticProctoredXML != '')
        {
            Blob blobval = Blob.valueof(strDomesticProctoredXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('DomesticProctored.xml');
            attachment.setBody(blobval);
            lstEmailAttachments.add(attachment);
        
        }
        if(strInvoiceLessExamXML != '')
        {
            Blob blobval = Blob.valueof(strInvoiceLessExamXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('InvoiceLessExam.xml');
            attachment.setBody(blobval);
            lstEmailAttachments.add(attachment);
        
        }
        if(strInvoiceLessProctoredExamXML != '')
        {
            Blob blobval = Blob.valueof(strInvoiceLessProctoredExamXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('InvoiceLessProctored.xml');
            attachment.setBody(blobval);
            lstEmailAttachments.add(attachment);
            
        }
        if(strInvoiceExamXML != '')
        {
            Blob blobval = Blob.valueof(strInvoiceExamXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('InvoiceExam.xml');
            attachment.setBody(blobval);
            lstEmailAttachments.add(attachment);
        
        }
        if(strInvoiceProctoredXML != '')
        {
            Blob blobval = Blob.valueof(strInvoiceProctoredXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('InvoiceProctored.xml');
            attachment.setBody(blobval);
            lstEmailAttachments.add(attachment);
        
        }
        system.debug('lstEmailAttachments == '+lstEmailAttachments);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setFileAttachments(lstEmailAttachments);
        mail.setToAddresses(new String[] {'alberto.garcia@garp.com'});
        mail.setReplyTo('vvkathi@gmail.com');
        mail.setSenderDisplayName('XML Files');
        mail.setSubject('XML Files');
        mail.setPlainTextBody('');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
    
    }
    
    public static string domesticProctoredXML(List<Shipping_Boxes__c> lstDomProctored)
    {
        String strDomesticProcXML = '<?xml version="1.0" encoding="windows-1252"?>';
        strDomesticProcXML += '<OpenShipments xmlns="x-schema:OpenShipments.xdr">';
        strDomesticProcXML += XMLCreator.DomesticProctored(lstDomProctored);
        strDomesticProcXML += '</OpenShipments>';
        return strDomesticProcXML;
    }
    
    public static string domesticExamXML(List<Shipping_Boxes__c> lstDomProctored)
    {
        String strDomesticProcXML = '<?xml version="1.0" encoding="windows-1252"?>';
        strDomesticProcXML += '<OpenShipments xmlns="x-schema:OpenShipments.xdr">';
        strDomesticProcXML += XMLCreator.DomesticExam(lstDomProctored);
        strDomesticProcXML += '</OpenShipments>';
        return strDomesticProcXML;
    }
    
    public static string InvoiceExamXML(List<Shipping_Boxes__c> lstDomProctored)
    {
        String strDomesticProcXML = '<?xml version="1.0" encoding="windows-1252"?>';
        strDomesticProcXML += '<OpenShipments xmlns="x-schema:OpenShipments.xdr">';
        strDomesticProcXML += XMLCreator.InvoiceForExam(lstDomProctored);
        strDomesticProcXML += '</OpenShipments>';
        return strDomesticProcXML;
    }
    
    public static string InvoiceLessExamXML(List<Shipping_Boxes__c> lstDomProctored)
    {
        String strDomesticProcXML = '<?xml version="1.0" encoding="windows-1252"?>';
        strDomesticProcXML += '<OpenShipments xmlns="x-schema:OpenShipments.xdr">';
        strDomesticProcXML += XMLCreator.InvoiceLessExam(lstDomProctored);
        strDomesticProcXML += '</OpenShipments>';
        return strDomesticProcXML;
    }
    public static string InvoiceProctoredXML(List<Shipping_Boxes__c> lstDomProctored)
    {
        String strDomesticProcXML = '<?xml version="1.0" encoding="windows-1252"?>';
        strDomesticProcXML += '<OpenShipments xmlns="x-schema:OpenShipments.xdr">';
        strDomesticProcXML += XMLCreator.InvoiceProctored(lstDomProctored);
        strDomesticProcXML += '</OpenShipments>';
        return strDomesticProcXML;
    }
    
    public static string InvoiceLessProctoredExamXML(List<Shipping_Boxes__c> lstDomProctored)
    {
        String strDomesticProcXML = '<?xml version="1.0" encoding="windows-1252"?>';
        strDomesticProcXML += '<OpenShipments xmlns="x-schema:OpenShipments.xdr">';
        strDomesticProcXML += XMLCreator.InvoiceLessProctored(lstDomProctored);
        strDomesticProcXML += '</OpenShipments>';
        return strDomesticProcXML;
    }

}