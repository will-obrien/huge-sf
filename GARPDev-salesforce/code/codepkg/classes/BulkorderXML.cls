public with sharing class BulkorderXML {
    
    
    public static string internationalShipping(List<Bulk_Orders__c> lstBO)
    {
        String sXML = '';
        for(Bulk_Orders__c BO : lstBO)
        {
            
            sXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">\n';
            String strShippName = BO.Shipping_Attention__c;
            String strCompanyName = BO.Shipping_Company__c == null ? strShippName : BO.Shipping_Company__c;
            sXML += '<ShipTo>\n';
            sXML += '<CustomerID></CustomerID>\n';
            sXML += '<CompanyOrName>'+strCompanyName+'</CompanyOrName>\n';
            sXML += '<Attention>'+strShippName+'</Attention>\n';
            sXML += '<Address1>'+CheckNull(BO.Shipping_Address_1__c)+'</Address1>\n';
            sXML += '<Address2>'+CheckNull(BO.Shipping_Address_2__c)+'</Address2>\n';
            sXML += '<Address3>'+CheckNull(BO.Shipping_Address_3__c)+'</Address3>\n';
            sXML += '<CountryTerritory>'+CheckNull(BO.Country_Code_for_UPS__c)+'</CountryTerritory>\n';
            sXML += '<PostalCode>'+CheckNull(BO.Shipping_Postal_Code__c)+'</PostalCode>\n';
            sXML += '<CityOrTown>'+CheckNull(BO.Shipping_City__c)+'</CityOrTown>\n';
            sXML += '<StateProvinceCounty>'+CheckNull(BO.Shipping_State_Provence__c)+'</StateProvinceCounty>\n';
            sXML += '<Telephone>'+CheckNull(BO.Shipping_Phone_Number__c)+'</Telephone>\n';
            sXML += '<FaxNumber></FaxNumber>\n';
            sXML += '<EmailAddress>'+CheckNull(BO.E_mail__c)+'</EmailAddress>\n';
            sXML += '<TaxIDNumber></TaxIDNumber>\n';
            sXML += '<ReceiverUpsAccountNumber></ReceiverUpsAccountNumber>\n';
            sXML += '<LocationID></LocationID>\n';
            sXML += '<ResidentialIndicator></ResidentialIndicator>\n';
            sXML += '</ShipTo>\n';
            sXML += '<ShipFrom>\n';
            sXML += '<CompanyOrName>GLOBAL ASSN OF RISK PROFSSNLS</CompanyOrName>\n';
            sXML += '<Attention>SHIPPER</Attention>\n';
            sXML += '<Address1>111 TOWN SQUARE PLACE</Address1>\n';
            sXML += '<Address2>SUITE 1215</Address2>\n';
            sXML += '<CountryTerritory>US</CountryTerritory>\n';
            sXML += '<PostalCode>07310</PostalCode>\n';
            sXML += '<CityOrTown>Jersey City</CityOrTown>\n';
            sXML += '<StateProvinceCounty>NJ</StateProvinceCounty>\n';
            sXML += '</ShipFrom>\n';
            sXML += '<ShipmentInformation>\n';
            sXML += '<ServiceType>'+CheckNull(BO.UPS_service_code_for_XML__c)+'</ServiceType>\n';
            sXML += '<NumberOfPackages>1</NumberOfPackages>\n';
            sXML += '<DescriptionOfGoods>Education Materials</DescriptionOfGoods>\n';
            sXML += '<ShipperNumber>7699YE</ShipperNumber>\n';
            sXML += '<BillingOption>PP</BillingOption>\n'; 
            sXML += '<BillTransportationTo>SHP</BillTransportationTo>\n';
            if(BO.Duty_Tax_To_GARP__c)
                sXML += '<BillDutyTaxTo>SHP</BillDutyTaxTo>\n';
            sXML += '<QVNOption>\n';
            sXML += '<QVNRecipientAndNotificationTypes>\n';
            sXML += '<EMailAddress>'+CheckNull(BO.E_mail__c)+'</EMailAddress>\n';
            sXML += '<Ship>1</Ship>\n';
            sXML += '<Exception>1</Exception>\n';
            sXML += '<Delivery>1</Delivery>\n';
            sXML += '</QVNRecipientAndNotificationTypes>\n';
            sXML += '<SubjectLine>Shipping confirmation of your order</SubjectLine>\n';
            sXML += '</QVNOption>\n';
            sXML += '</ShipmentInformation>\n';
            sXML += '<Package>\n';
            sXML += '<PackageType>CP</PackageType>\n';
            sXML += '<Weight>'+CheckNull(String.valueOf(BO.Weight__c))+'</Weight>\n';
            sXML += '<TrackingNumber></TrackingNumber>\n';
            sXML += '<LargePackageIndicator></LargePackageIndicator>\n';
            sXML += '<Reference1>'+CheckNull(BO.Product_Id__c)+'</Reference1>\n';
            sXML += '<Reference2>'+CheckNull(BO.Name)+'</Reference2>\n';
            sXML += '</Package>\n';
            sXML += '<InternationalDocumentation>\n';
            sXML += '<InvoiceReasonForExport>Sale</InvoiceReasonForExport>\n';
            sXML += '<InvoiceCurrencyCode>US</InvoiceCurrencyCode>\n';
            sXML += '</InternationalDocumentation>\n';       
            sXML += '<Goods>\n';
            sXML +='<DescriptionOfGood>'+CheckNull(BO.Product_Names__c)+'</DescriptionOfGood>\n';
            sXML +='<Inv-NAFTA-CO-CountryTerritoryOfOrigin>United States</Inv-NAFTA-CO-CountryTerritoryOfOrigin>\n';
            sXML +='<InvoiceUnits>1</InvoiceUnits>\n';
            sXML +='<InvoiceUnitOfMeasure>Piece</InvoiceUnitOfMeasure>\n';
            sXML +='<Invoice-SED-UnitPrice>'+CheckNull(BO.Customs_cost__c)+'</Invoice-SED-UnitPrice>\n';
            sXML +='</Goods>\n';
            sXML += '</OpenShipment>\n';
            
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

    
    
    public static string domesticShipping(List<Bulk_Orders__c> lstBO)
    {
        String sXML = '';
        for(Bulk_Orders__c BO : lstBO)
        {
           sXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">\n';
            String strShippName = BO.Shipping_Attention__c;
            String strCompanyName = BO.Shipping_Company__c == null ? strShippName : BO.Shipping_Company__c;
            sXML += '<ShipTo>\n';
            sXML += '<CustomerID></CustomerID>';
            sXML += '<CompanyOrName>'+strCompanyName+'</CompanyOrName>\n';
            sXML += '<Attention>'+strShippName+'</Attention>';
            sXML += '<Address1>'+CheckNull(BO.Shipping_Address_1__c)+'</Address1>\n';
            sXML += '<Address2>'+CheckNull(BO.Shipping_Address_2__c)+'</Address2>\n';
            sXML += '<Address3>'+CheckNull(BO.Shipping_Address_3__c)+'</Address3>\n';
            sXML += '<CountryTerritory>'+CheckNull(BO.Country_Code_for_UPS__c)+'</CountryTerritory>\n';
            sXML += '<PostalCode>'+CheckNull(BO.Shipping_Postal_Code__c)+'</PostalCode>\n';
            sXML += '<CityOrTown>'+CheckNull(BO.Shipping_City__c)+'</CityOrTown>\n';
            sXML += '<StateProvinceCounty>'+CheckNull(BO.Shipping_State_Provence__c)+'</StateProvinceCounty>\n';
            sXML += '<Telephone>'+CheckNull(BO.Shipping_Phone_Number__c)+'</Telephone>\n';
            sXML += '<FaxNumber></FaxNumber>\n';
            sXML += '<EmailAddress>'+CheckNull(BO.E_mail__c)+'</EmailAddress>\n';
            sXML += '<TaxIDNumber></TaxIDNumber>\n';
            sXML += '<ReceiverUpsAccountNumber></ReceiverUpsAccountNumber>\n';
            sXML += '<LocationID></LocationID>\n';
            sXML += '<ResidentialIndicator></ResidentialIndicator>\n';
            sXML += '</ShipTo>\n';
            sXML += '<ShipFrom>\n';
            sXML += '<CompanyOrName>GLOBAL ASSN OF RISK PROFSSNLS</CompanyOrName>\n';
            sXML += '<Attention>SHIPPER</Attention>\n';
            sXML += '<Address1>111 TOWN SQUARE PLACE</Address1>\n';
            sXML += '<Address2>SUITE 1215</Address2>\n';
            sXML += '<CountryTerritory>US</CountryTerritory>\n';
            sXML += '<PostalCode>07310</PostalCode>\n';
            sXML += '<CityOrTown>Jersey City</CityOrTown>\n';
            sXML += '<StateProvinceCounty>NJ</StateProvinceCounty>\n';
            sXML += '</ShipFrom>\n';
            sXML += '<ShipmentInformation>\n';
            sXML += '<ServiceType>'+CheckNull(BO.UPS_Service_Code_For_Xml__c)+'</ServiceType>\n';
            sXML += '<NumberOfPackages>1</NumberOfPackages>\n';
            sXML += '<DescriptionOfGoods>Education Materials</DescriptionOfGoods>\n';
            sXML += '<ShipperNumber>7699YE</ShipperNumber>\n';
            sXML += '<BillingOption>PP</BillingOption>\n';
            sXML += '<BillTransportationTo>SHP</BillTransportationTo>\n';
            sXML += '<QVNOption>\n';
            sXML += '<QVNRecipientAndNotificationTypes>\n';
            sXML += '<EMailAddress>'+CheckNull(BO.E_mail__c)+'</EMailAddress>\n';
            sXML += '<Ship>1</Ship>\n';
            sXML += '<Exception>1</Exception>\n';
            sXML += '<Delivery>1</Delivery>\n';
            sXML += '</QVNRecipientAndNotificationTypes>\n';
            sXML += '<SubjectLine>Shipping confirmation of your order</SubjectLine>\n';
            sXML += '</QVNOption>\n';
            sXML += '</ShipmentInformation>\n';
            sXML += '<Package>\n';
            sXML += '<PackageType>CP</PackageType>\n';
            sXML += '<Weight>'+CheckNull(BO.Weight__c)+'</Weight>\n';
            sXML += '<TrackingNumber></TrackingNumber>\n';
            sXML += '<LargePackageIndicator></LargePackageIndicator>\n';
            sXML += '<Reference1>'+CheckNull(BO.Product_Id__c)+'</Reference1>\n';
            sXML += '<Reference2>'+CheckNull(BO.Name)+'</Reference2>\n';
            sXML += '</Package>\n';
            sXML += '</OpenShipment>\n';
    
        }
            
        return sXML;    
    
    }
    
    public static String invoicelessXML(List<Bulk_Orders__c> lstBO)
    {
        String sXML = '';
        for(Bulk_Orders__c BO : lstBO)
        {       
            
           sXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">\n';
            String strShippName = BO.Shipping_Attention__c;
            String strCompanyName = BO.Shipping_Company__c == null ? strShippName : BO.Shipping_Company__c;
            sXML += '<ShipTo>\n';
            sXML += '<CustomerID></CustomerID>\n';
            sXML += '<CompanyOrName>'+strCompanyName+'</CompanyOrName>\n';
            sXML += '<Attention>'+strShippName+'</Attention>\n';
            sXML += '<Address1>'+CheckNull(BO.Shipping_Address_1__c)+'</Address1>\n';
            sXML += '<Address2>'+CheckNull(BO.Shipping_Address_2__c)+'</Address2>\n';
            sXML += '<Address3>'+CheckNull(BO.Shipping_Address_3__c)+'</Address3>\n';
            sXML += '<CountryTerritory>'+CheckNull(BO.Country_Code_for_UPS__c)+'</CountryTerritory>\n';
            sXML += '<PostalCode>'+CheckNull(BO.Shipping_Postal_Code__c)+'</PostalCode>\n';
            sXML += '<CityOrTown>'+CheckNull(BO.Shipping_City__c)+'</CityOrTown>\n';
            sXML += '<StateProvinceCounty>'+CheckNull(BO.Shipping_State_Provence__c)+'</StateProvinceCounty>\n';
            sXML += '<Telephone>'+CheckNull(BO.Shipping_Phone_Number__c)+'</Telephone>\n';
            sXML += '<FaxNumber></FaxNumber>\n';
            sXML += '<EmailAddress>'+CheckNull(BO.E_mail__c)+'</EmailAddress>\n';
            sXML += '<TaxIDNumber></TaxIDNumber>\n';
            sXML += '<ReceiverUpsAccountNumber></ReceiverUpsAccountNumber>\n';
            sXML += '<LocationID></LocationID>\n';
            sXML += '<ResidentialIndicator></ResidentialIndicator>\n';
            sXML += '</ShipTo>\n';
            sXML += '<ShipFrom>\n';
            sXML += '<CompanyOrName>GLOBAL ASSN OF RISK PROFSSNLS</CompanyOrName>\n';
            sXML += '<Attention>SHIPPER</Attention>\n';
            sXML += '<Address1>111 TOWN SQUARE PLACE</Address1>\n';
            sXML += '<Address2>SUITE 1215</Address2>\n';
            sXML += '<CountryTerritory>US</CountryTerritory>\n';
            sXML += '<PostalCode>07310</PostalCode>\n';
            sXML += '<CityOrTown>Jersey City</CityOrTown>\n';
            sXML += '<StateProvinceCounty>NJ</StateProvinceCounty>\n';
            sXML += '</ShipFrom>\n';
            sXML += '<ShipmentInformation>\n';
            sXML += '<ServiceType>'+CheckNull(BO.UPS_Service_Code_For_Xml__c)+'</ServiceType>\n';
            sXML += '<NumberOfPackages>1</NumberOfPackages>\n';
            sXML += '<DescriptionOfGoods>Education Materials</DescriptionOfGoods>\n';
            sXML += '<ShipperNumber>7699YE</ShipperNumber>\n';
            sXML += '<BillingOption>PP</BillingOption>\n';
            sXML += '<BillTransportationTo>SHP</BillTransportationTo>\n';
            if(BO.Duty_Tax_to_Garp__c)
                sXML += '<BillDutyTaxTo>SHP</BillDutyTaxTo>\n';
            sXML += '<QVNOption>\n';
            sXML += '<QVNRecipientAndNotificationTypes>\n';
            sXML += '<EMailAddress>'+CheckNull(BO.E_mail__c)+'</EMailAddress>\n';
            sXML += '<Ship>1</Ship>\n';
            sXML += '<Exception>1</Exception>\n';
            sXML += '<Delivery>1</Delivery>\n';
            sXML += '</QVNRecipientAndNotificationTypes>\n';
            sXML += '<SubjectLine>Shipping confirmation of your order</SubjectLine>\n';
            sXML += '</QVNOption>\n';
            sXML += '</ShipmentInformation>\n';
            sXML += '<Package>\n';
            sXML += '<PackageType>CP</PackageType>\n';
            sXML += '<Weight>'+CheckNull(BO.Weight__c)+'</Weight>\n';
            sXML += '<TrackingNumber></TrackingNumber>\n';
            sXML += '<LargePackageIndicator></LargePackageIndicator>\n';
            sXML += '<Reference1>'+CheckNull(BO.Product_Id__c)+'</Reference1>\n';
            sXML += '<Reference2>'+CheckNull(BO.Name)+'</Reference2>';
            sXML += '</Package>\n';
            sXML += '<InternationalDocumentation>\n';
            sXML += '<InvoiceReasonForExport>Sale</InvoiceReasonForExport>\n';
            sXML += '<InvoiceCurrencyCode>US</InvoiceCurrencyCode>\n';
            sXML += '</InternationalDocumentation>\n';
            sXML += '<Goods>\n';
            sXML +='<DescriptionOfGood>'+CheckNull(BO.Product_Names__c)+'</DescriptionOfGood>\n';
            sXML +='<Inv-NAFTA-CO-CountryTerritoryOfOrigin>United States</Inv-NAFTA-CO-CountryTerritoryOfOrigin>\n';
            sXML +='<InvoiceUnits>1</InvoiceUnits>\n';
            sXML +='<InvoiceUnitOfMeasure>Piece</InvoiceUnitOfMeasure>\n';
            sXML +='<Invoice-SED-UnitPrice>'+CheckNull(BO.Customs_cost__c)+'</Invoice-SED-UnitPrice>\n';
            sXML +='</Goods>\n';
            sXML += '</OpenShipment>\n';
            
        }
        return sXML;
        
    }
    }