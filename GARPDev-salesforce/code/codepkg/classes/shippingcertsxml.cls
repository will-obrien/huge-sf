public with sharing class shippingcertsxml {
    
    
    public static string internationalShipping(List<certificate_shipping__c> lstcerts)
    {
        String sXML = '';
        for(certificate_shipping__c certs : lstcerts)
        {
            
            sXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">';
            String strShippName = certs.Shipping_Attention__c;
            String strCompanyName = certs.Shipping_Company_Name__c == null ? strShippName : certs.Shipping_Company_Name__c;
            sXML += '<ShipTo>';
            sXML += '<CustomerID></CustomerID>';
            sXML += '<CompanyOrName>'+strCompanyName+'</CompanyOrName>';
            sXML += '<Attention>'+strShippName+'</Attention>';
            sXML += '<Address1>'+CheckNull(certs.Shipping_Address1__c)+'</Address1>';
            sXML += '<Address2>'+CheckNull(certs.Shipping_Address2__c)+'</Address2>';
            sXML += '<Address3>'+CheckNull(certs.Shipping_Address3__c)+'</Address3>';
            sXML += '<CountryTerritory>'+CheckNull(certs.Country_Code_for_UPS__c)+'</CountryTerritory>';
            sXML += '<PostalCode>'+CheckNull(certs.Shipping_Postal_Code__c)+'</PostalCode>';
            sXML += '<CityOrTown>'+CheckNull(certs.Shipping_City__c)+'</CityOrTown>';
            sXML += '<StateProvinceCounty>'+StateCodes.getStateId(certs.Shipping_Country__c,certs.Shipping_State__c)+'</StateProvinceCounty>';
            sXML += '<Telephone>'+CheckNull(certs.Shipping_Phone_No__c)+'</Telephone>';
            sXML += '<FaxNumber></FaxNumber>';
            sXML += '<EmailAddress>'+CheckNull(certs.Shipping_E_mail__c)+'</EmailAddress>';
            sXML += '<TaxIDNumber></TaxIDNumber>';
            sXML += '<ReceiverUpsAccountNumber></ReceiverUpsAccountNumber>';
            sXML += '<LocationID></LocationID>';
            sXML += '<ResidentialIndicator></ResidentialIndicator>';
            sXML += '</ShipTo>';
            sXML += '<ShipFrom>';
            sXML += '<CompanyOrName>GLOBAL ASSN OF RISK PROFSSNLS</CompanyOrName>';
            sXML += '<Attention>SHIPPER</Attention>';
            sXML += '<Address1>111 TOWN SQUARE PLACE</Address1>';
            sXML += '<Address2>SUITE 1215</Address2>';
            sXML += '<CountryTerritory>US</CountryTerritory>';
            sXML += '<PostalCode>07310</PostalCode>';
            sXML += '<CityOrTown>Jersey City</CityOrTown>';
            sXML += '<StateProvinceCounty>NJ</StateProvinceCounty>';
            sXML += '</ShipFrom>';
            sXML += '<ShipmentInformation>';
            sXML += '<ServiceType>'+CheckNull(certs.UPS_Service_Code_For_Xml__c)+'</ServiceType>';
            sXML += '<NumberOfPackages>1</NumberOfPackages>';
            sXML += '<DescriptionOfGoods>Education Materials</DescriptionOfGoods>';
            sXML += '<ShipperNumber>7699YE</ShipperNumber>';
            sXML += '<BillingOption>PP</BillingOption>'; 
            sXML += '<BillTransportationTo>SHP</BillTransportationTo>';
            if(certs.Duty_Tax_to_Garp__c)
                sXML += '<BillDutyTaxTo>SHP</BillDutyTaxTo>';
            sXML += '<QVNOption>';
            sXML += '<QVNRecipientAndNotificationTypes>';
            sXML += '<EMailAddress>'+CheckNull(certs.Shipping_E_mail__c)+'</EMailAddress>';
            sXML += '<Ship>1</Ship>';
            sXML += '<Exception>1</Exception>';
            sXML += '<Delivery>1</Delivery>';
            sXML += '</QVNRecipientAndNotificationTypes>';
            sXML += '<SubjectLine>Shipping confirmation of your order</SubjectLine>';
            sXML += '</QVNOption>';
            sXML += '</ShipmentInformation>';
            sXML += '<Package>';
            sXML += '<PackageType>CP</PackageType>';
            sXML += '<Weight>'+CheckNull(String.valueOf(certs.Total_Package_Weight__c))+'</Weight>';
            sXML += '<TrackingNumber></TrackingNumber>';
            sXML += '<LargePackageIndicator></LargePackageIndicator>';
            sXML += '<Reference1>'+CheckNull(certs.Name)+'</Reference1>';
            sXML += '<Reference2>'+CheckNull(certs.Garp_id__c)+'</Reference2>';
            sXML += '</Package>';
            sXML += '<InternationalDocumentation>';
            sXML += '<InvoiceReasonForExport>Sale</InvoiceReasonForExport>';
            sXML += '<InvoiceCurrencyCode>US</InvoiceCurrencyCode>';
            sXML += '</InternationalDocumentation>';       
            String strGoodsXML = '';
            sXML += strGoodsXML;
            sXML += '</OpenShipment>';
            
        }
        return sXML;
        }
    
    

    public static string CheckNull(String strValue)
    {
        if(strValue == null)
            return '';
        else
            return strValue;

    }

    
    
    public static string domesticShipping(List<certificate_shipping__c> lstcerts)
    {
        String sXML = '';
        for(certificate_shipping__c certs : lstcerts)
        {
            
            sXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">';
            String strShippName = certs.Shipping_Attention__c;
            String strCompanyName = certs.Shipping_Company_Name__c == null ? strShippName : certs.Shipping_Company_Name__c;
            sXML += '<ShipTo>';
            sXML += '<CustomerID></CustomerID>';
            sXML += '<CompanyOrName>'+strCompanyName+'</CompanyOrName>';
            sXML += '<Attention>'+strShippName+'</Attention>';
            sXML += '<Address1>'+CheckNull(certs.Shipping_Address1__c)+'</Address1>';
            sXML += '<Address2>'+CheckNull(certs.Shipping_Address2__c)+'</Address2>';
            sXML += '<Address3>'+CheckNull(certs.Shipping_Address3__c)+'</Address3>';
            sXML += '<CountryTerritory>'+CheckNull(certs.Country_Code_for_UPS__c)+'</CountryTerritory>';
            sXML += '<PostalCode>'+CheckNull(certs.Shipping_Postal_Code__c)+'</PostalCode>';
            sXML += '<CityOrTown>'+CheckNull(certs.Shipping_City__c)+'</CityOrTown>';
            sXML += '<StateProvinceCounty>'+StateCodes.getStateId(certs.Shipping_Country__c,certs.Shipping_State__c)+'</StateProvinceCounty>';
            sXML += '<Telephone>'+CheckNull(certs.Shipping_Phone_No__c)+'</Telephone>';
            sXML += '<FaxNumber></FaxNumber>';
            sXML += '<EmailAddress>'+CheckNull(certs.Shipping_E_mail__c)+'</EmailAddress>';
            sXML += '<TaxIDNumber></TaxIDNumber>';
            sXML += '<ReceiverUpsAccountNumber></ReceiverUpsAccountNumber>';
            sXML += '<LocationID></LocationID>';
            sXML += '<ResidentialIndicator></ResidentialIndicator>';
            sXML += '</ShipTo>';
            sXML += '<ShipFrom>';
            sXML += '<CompanyOrName>GLOBAL ASSN OF RISK PROFSSNLS</CompanyOrName>';
            sXML += '<Attention>SHIPPER</Attention>';
            sXML += '<Address1>111 TOWN SQUARE PLACE</Address1>';
            sXML += '<Address2>SUITE 1215</Address2>';
            sXML += '<CountryTerritory>US</CountryTerritory>';
            sXML += '<PostalCode>07310</PostalCode>';
            sXML += '<CityOrTown>Jersey City</CityOrTown>';
            sXML += '<StateProvinceCounty>NJ</StateProvinceCounty>';
            sXML += '</ShipFrom>';
            sXML += '<ShipmentInformation>';
            sXML += '<ServiceType>'+CheckNull(certs.UPS_Service_Code_For_Xml__c)+'</ServiceType>';
            sXML += '<NumberOfPackages>1</NumberOfPackages>';
            sXML += '<DescriptionOfGoods>Education Materials</DescriptionOfGoods>';
            sXML += '<ShipperNumber>7699YE</ShipperNumber>';
            sXML += '<BillingOption>PP</BillingOption>';
            sXML += '<BillTransportationTo>SHP</BillTransportationTo>';
            sXML += '<QVNOption>';
            sXML += '<QVNRecipientAndNotificationTypes>';
            sXML += '<EMailAddress>'+CheckNull(certs.Shipping_E_mail__c)+'</EMailAddress>';
            sXML += '<Ship>1</Ship>';
            sXML += '<Exception>1</Exception>';
            sXML += '<Delivery>1</Delivery>';
            sXML += '</QVNRecipientAndNotificationTypes>';
            sXML += '<SubjectLine>Shipping confirmation of your order</SubjectLine>';
            sXML += '</QVNOption>';
            sXML += '</ShipmentInformation>';
            sXML += '<Package>';
            sXML += '<PackageType>CP</PackageType>';
            sXML += '<Weight>'+CheckNull(String.valueOf(certs.Total_Package_Weight__c))+'</Weight>';
            sXML += '<TrackingNumber></TrackingNumber>';
            sXML += '<LargePackageIndicator></LargePackageIndicator>';
            sXML += '<Reference1>'+CheckNull(certs.Name)+'</Reference1>';
            sXML += '<Reference2>'+CheckNull(certs.Garp_id__c)+'</Reference2>';
            sXML += '</Package>';
            sXML += '</OpenShipment>';
    
        }
            
        return sXML;    
    
    }
    
    public static String invoicelessXML(List<certificate_shipping__c> lstcerts)
    {
        String sXML = '';
        for(certificate_shipping__c certs : lstcerts)
        {       
            
            sXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">';
            String strShippName = certs.Shipping_Attention__c;
            String strCompanyName = certs.Shipping_Company_Name__c == null ? strShippName : certs.Shipping_Company_Name__c;
            sXML += '<ShipTo>';
            sXML += '<CustomerID></CustomerID>';
            sXML += '<CompanyOrName>'+strCompanyName+'</CompanyOrName>';
            sXML += '<Attention>'+strShippName+'</Attention>';
            sXML += '<Address1>'+CheckNull(certs.Shipping_Address1__c)+'</Address1>';
            sXML += '<Address2>'+CheckNull(certs.Shipping_Address2__c)+'</Address2>';
            sXML += '<Address3>'+CheckNull(certs.Shipping_Address3__c)+'</Address3>';
            sXML += '<CountryTerritory>'+CheckNull(certs.Country_Code_for_UPS__c)+'</CountryTerritory>';
            sXML += '<PostalCode>'+CheckNull(certs.Shipping_Postal_Code__c)+'</PostalCode>';
            sXML += '<CityOrTown>'+CheckNull(certs.Shipping_City__c)+'</CityOrTown>';
            sXML += '<StateProvinceCounty>'+StateCodes.getStateId(certs.Shipping_Country__c,certs.Shipping_State__c)+'</StateProvinceCounty>';
            sXML += '<Telephone>'+CheckNull(certs.Shipping_Phone_No__c)+'</Telephone>';
            sXML += '<FaxNumber></FaxNumber>';
            sXML += '<EmailAddress>'+CheckNull(certs.Shipping_E_mail__c)+'</EmailAddress>';
            sXML += '<TaxIDNumber></TaxIDNumber>';
            sXML += '<ReceiverUpsAccountNumber></ReceiverUpsAccountNumber>';
            sXML += '<LocationID></LocationID>';
            sXML += '<ResidentialIndicator></ResidentialIndicator>';
            sXML += '</ShipTo>';
            sXML += '<ShipFrom>';
            sXML += '<CompanyOrName>GLOBAL ASSN OF RISK PROFSSNLS</CompanyOrName>';
            sXML += '<Attention>SHIPPER</Attention>';
            sXML += '<Address1>111 TOWN SQUARE PLACE</Address1>';
            sXML += '<Address2>SUITE 1215</Address2>';
            sXML += '<CountryTerritory>US</CountryTerritory>';
            sXML += '<PostalCode>07310</PostalCode>';
            sXML += '<CityOrTown>Jersey City</CityOrTown>';
            sXML += '<StateProvinceCounty>NJ</StateProvinceCounty>';
            sXML += '</ShipFrom>';
            sXML += '<ShipmentInformation>';
            sXML += '<ServiceType>'+CheckNull(certs.UPS_Service_Code_For_Xml__c)+'</ServiceType>';
            sXML += '<NumberOfPackages>1</NumberOfPackages>';
            sXML += '<DescriptionOfGoods>Education Materials</DescriptionOfGoods>';
            sXML += '<ShipperNumber>7699YE</ShipperNumber>';
            sXML += '<BillingOption>PP</BillingOption>';
            sXML += '<BillTransportationTo>SHP</BillTransportationTo>';
            if(certs.Duty_Tax_to_Garp__c)
                sXML += '<BillDutyTaxTo>SHP</BillDutyTaxTo>';
            sXML += '<QVNOption>';
            sXML += '<QVNRecipientAndNotificationTypes>';
            sXML += '<EMailAddress>'+CheckNull(certs.Shipping_E_mail__c)+'</EMailAddress>';
            sXML += '<Ship>1</Ship>';
            sXML += '<Exception>1</Exception>';
            sXML += '<Delivery>1</Delivery>';
            sXML += '</QVNRecipientAndNotificationTypes>';
            sXML += '<SubjectLine>Shipping confirmation of your order</SubjectLine>';
            sXML += '</QVNOption>';
            sXML += '</ShipmentInformation>';
            sXML += '<Package>';
            sXML += '<PackageType>CP</PackageType>';
            sXML += '<Weight>'+CheckNull(String.valueOf(certs.Total_Package_Weight__c))+'</Weight>';
            sXML += '<TrackingNumber></TrackingNumber>';
            sXML += '<LargePackageIndicator></LargePackageIndicator>';
            sXML += '<Reference1>'+CheckNull(certs.Name)+'</Reference1>';
            sXML += '<Reference2>'+CheckNull(certs.Garp_id__c)+'</Reference2>';
            sXML += '</Package>';
            sXML += '<InternationalDocumentation>';
            sXML += '<InvoiceReasonForExport>Sale</InvoiceReasonForExport>';
            sXML += '<InvoiceCurrencyCode>US</InvoiceCurrencyCode>';
            sXML += '</InternationalDocumentation>';
            
            String strGoodsXML = '';
            sXML += strGoodsXML;
            sXML += '</OpenShipment>';
            
        }
        return sXML;
        
    }
    }