public class pretestboxXmlCreator
{

    public static string CheckNull(String strValue)
    {
        if(strValue == null) {
            return '';
        } else {
            strValue = strValue.replace('&', '&amp;');
            return strValue;
        }
    }


   
    
    public static string DomesticProctored(List<Shipping_Boxes__c> lstShipInfo)
    {
        String strDomesticXML = '';
        for(Shipping_Boxes__c objShipInfo : lstShipInfo)
        {
            string strFaxNumber = objShipInfo.Fax__c == null ? '' : objShipInfo.Fax__c;
            strDomesticXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">\n';
            strDomesticXML+='<ShipTo>\n';
            strDomesticXML+='<CustomerID></CustomerID>\n';
            strDomesticXML+='<CompanyOrName>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Company__c)+'</CompanyOrName>\n';
            strDomesticXML+='<Attention>'+CheckNull(objShipInfo.Pre_Test_Box_Attention__c)+'</Attention>\n';
            strDomesticXML+='<Address1>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Address_1__c)+'</Address1>\n';
            strDomesticXML+='<Address2>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Address_2__c)+'</Address2>\n';
            strDomesticXML+='<Address3>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Address_3__c)+'</Address3>\n';
            strDomesticXML+='<CountryTerritory>'+CheckNull(objShipInfo.Pre_Test_Box_Country_Code_for_UPS__c)+'</CountryTerritory>\n';
            strDomesticXML+='<PostalCode>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Postal_Code__c)+'</PostalCode>\n';
            strDomesticXML+='<CityOrTown>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_City__c)+'</CityOrTown>\n';
            strDomesticXML+='<StateProvinceCounty>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_State_Provence__c)+'</StateProvinceCounty>\n';
            strDomesticXML+='<Telephone>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Phone_Number__c)+'</Telephone>\n';
            strDomesticXML+='<FaxNumber>'+CheckNull(objShipInfo.Fax__c)+'</FaxNumber>\n';
            strDomesticXML+='<EmailAddress>'+CheckNull(objShipInfo.Pre_Test_Box_E_mail__c)+'</EmailAddress>\n';
            strDomesticXML+='<TaxIDNumber></TaxIDNumber>\n';
            strDomesticXML+='<ReceiverUpsAccountNumber>999999</ReceiverUpsAccountNumber>\n';
            strDomesticXML+='<LocationID></LocationID>\n';
            strDomesticXML+='<ResidentialIndicator></ResidentialIndicator>\n';
            strDomesticXML+='</ShipTo>\n';
            strDomesticXML+='<ShipFrom>\n';
            strDomesticXML+='<CompanyOrName>GLOBAL ASSN OF RISK PROFSSNLS</CompanyOrName>\n';
            strDomesticXML+='<Attention>SHIPPER</Attention>\n';
            strDomesticXML+='<Address1>111 TOWN SQUARE PLACE</Address1>\n';
            strDomesticXML+='<Address2>SUITE 1215</Address2>\n';
            strDomesticXML+='<CountryTerritory>US</CountryTerritory>\n';
            strDomesticXML+='<PostalCode>07310</PostalCode>\n';
            strDomesticXML+='<CityOrTown>Jersey City</CityOrTown>\n';
            strDomesticXML+='<StateProvinceCounty>NJ</StateProvinceCounty>\n';
            strDomesticXML+='</ShipFrom>\n';
            strDomesticXML+='<ShipmentInformation>\n';
            strDomesticXML+='<ServiceType>'+CheckNull(objShipInfo.Pre_Test_Box_UPS_service_code_for_XML__c)+'</ServiceType>\n';
            strDomesticXML+='<NumberOfPackages>1</NumberOfPackages>\n';
            strDomesticXML+='<DescriptionOfGoods>Documents</DescriptionOfGoods>\n';
            strDomesticXML+='<ShipperNumber>A3R489</ShipperNumber>\n';
            strDomesticXML+='<BillingOption>PP</BillingOption>\n';
            strDomesticXML+='<BillTransportationTo>SHP</BillTransportationTo>\n';
            strDomesticXML+='<BillDutyTaxTo>SHP</BillDutyTaxTo>\n';
            strDomesticXML+='</ShipmentInformation>\n';
            strDomesticXML+='<Package>\n';
            strDomesticXML+='<PackageType>CP</PackageType>\n';
            strDomesticXML+='<Weight>'+CheckNull(objShipInfo.Weight__c)+'</Weight>\n';
            strDomesticXML+='<TrackingNumber></TrackingNumber>\n';
            strDomesticXML+='<LargePackageIndicator></LargePackageIndicator>\n';
            strDomesticXML+='<Reference1>'+CheckNull(objShipInfo.Name)+'</Reference1>\n';
            strDomesticXML+='<Reference2>'+CheckNull(objShipInfo.Pre_Test_Box_Reference_2__c)+'</Reference2>\n';
            strDomesticXML+='<DeliveryConfirmation>\n';
            strDomesticXML+='<SignatureRequired>1</SignatureRequired>\n';
            strDomesticXML+='</DeliveryConfirmation>\n';
            strDomesticXML+='</Package>\n';
            strDomesticXML+='</OpenShipment>\n';
        }
        return strDomesticXML;

    }
    
    public static string InvoiceProctored(List<Shipping_Boxes__c> lstShipInfo)
    {
        String strInvoiceXML = '';
        for(Shipping_Boxes__c objShipInfo : lstShipInfo)
        {
             strInvoiceXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">\n';
            strInvoiceXML+='<ShipTo>\n';
            strInvoiceXML+='<CustomerID></CustomerID>\n';
            strInvoiceXML+='<CompanyOrName>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Company__c)+'</CompanyOrName>\n';
            strInvoiceXML+='<Attention>'+CheckNull(objShipInfo.Pre_Test_Box_Attention__c)+'</Attention>\n';
            strInvoiceXML+='<Address1>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Address_1__c)+'</Address1>\n';
            strInvoiceXML+='<Address2>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Address_2__c)+'</Address2>\n';
            strInvoiceXML+='<Address3>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Address_3__c)+'</Address3>\n';
            strInvoiceXML+='<CountryTerritory>'+CheckNull(objShipInfo.Pre_Test_Box_Country_Code_for_UPS__c)+'</CountryTerritory>\n';
            strInvoiceXML+='<PostalCode>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Postal_Code__c)+'</PostalCode>\n';
            strInvoiceXML+='<CityOrTown>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_City__c)+'</CityOrTown>\n';
            strInvoiceXML+='<StateProvinceCounty>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_State_Provence__c)+'</StateProvinceCounty>\n';
            strInvoiceXML+='<Telephone>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Phone_Number__c)+'</Telephone>\n';
            strInvoiceXML+='<FaxNumber>'+CheckNull(objShipInfo.Fax__c)+'</FaxNumber>\n';
            strInvoiceXML+='<EmailAddress>'+CheckNull(objShipInfo.Pre_Test_Box_E_mail__c)+'</EmailAddress>\n';
            strInvoiceXML+='<TaxIDNumber></TaxIDNumber>\n';
            strInvoiceXML+='<ReceiverUpsAccountNumber>999999</ReceiverUpsAccountNumber>\n';
            strInvoiceXML+='<LocationID></LocationID>\n';
            strInvoiceXML+='<ResidentialIndicator></ResidentialIndicator>\n';
            strInvoiceXML+='</ShipTo>\n';
            strInvoiceXML+='<ShipFrom>\n';
            strInvoiceXML+='<CompanyOrName>GLOBAL ASSN OF RISK PROFSSNLS</CompanyOrName>\n';
            strInvoiceXML+='<Attention>SHIPPER</Attention>\n';
            strInvoiceXML+='<Address1>111 TOWN SQUARE PLACE</Address1>\n';
            strInvoiceXML+='<Address2>SUITE 1215</Address2>\n';
            strInvoiceXML+='<CountryTerritory>US</CountryTerritory>\n';
            strInvoiceXML+='<PostalCode>07310</PostalCode>\n';
            strInvoiceXML+='<CityOrTown>Jersey City</CityOrTown>\n';
            strInvoiceXML+='<StateProvinceCounty>NJ</StateProvinceCounty>\n';
            strInvoiceXML+='</ShipFrom>\n';
            strInvoiceXML+='<ShipmentInformation>\n';
            strInvoiceXML+='<ServiceType>'+CheckNull(objShipInfo.Pre_Test_Box_UPS_service_code_for_XML__c)+'</ServiceType>\n';
            strInvoiceXML+='<NumberOfPackages>1</NumberOfPackages>\n';
            strInvoiceXML+='<DescriptionOfGoods>Documents</DescriptionOfGoods>\n';
            strInvoiceXML+='<ShipperNumber>A3R489</ShipperNumber>\n';
            strInvoiceXML+='<BillingOption>PP</BillingOption>\n';
            strInvoiceXML+='<BillTransportationTo>SHP</BillTransportationTo>\n';
            strInvoiceXML+='<BillDutyTaxTo>SHP</BillDutyTaxTo>\n';
            strInvoiceXML+='<DeliveryConfirmation>\n';
            strInvoiceXML+='<SignatureRequired>1</SignatureRequired>\n';
            strInvoiceXML+='</DeliveryConfirmation>\n';
            strInvoiceXML+='</ShipmentInformation>\n';
            strInvoiceXML+='<Package>\n';
            strInvoiceXML+='<PackageType>CP</PackageType>\n';
            strInvoiceXML+='<Weight>'+CheckNull(objShipInfo.Weight__c)+'</Weight>\n';
            strInvoiceXML+='<TrackingNumber></TrackingNumber>\n';
            strInvoiceXML+='<LargePackageIndicator></LargePackageIndicator>\n';
            strInvoiceXML+='<Reference1>'+CheckNull(objShipInfo.Name)+'</Reference1>\n';
            strInvoiceXML+='<Reference2>'+CheckNull(objShipInfo.Pre_Test_Box_Reference_2__c)+'</Reference2>\n';
            strInvoiceXML+='</Package>\n';
            strInvoiceXML+='<InternationalDocumentation>\n';
            strInvoiceXML+='<InvoiceTermOfSale>FOB</InvoiceTermOfSale>\n';
            strInvoiceXML+='<InvoiceReasonForExport>Intercompany Data</InvoiceReasonForExport>\n';
            strInvoiceXML+='<InvoiceCurrencyCode>US</InvoiceCurrencyCode>\n';
            strInvoiceXML+='</InternationalDocumentation>\n';
            strInvoiceXML+='<Goods>\n';
            strInvoiceXML+='<DescriptionOfGood>Documents</DescriptionOfGood>\n';
            strInvoiceXML+='<Inv-NAFTA-CO-CountryTerritoryOfOrigin>United States</Inv-NAFTA-CO-CountryTerritoryOfOrigin>\n';
            strInvoiceXML+='<InvoiceUnits>1</InvoiceUnits>\n';
            strInvoiceXML+='<InvoiceUnitOfMeasure>Packet</InvoiceUnitOfMeasure>\n';
            strInvoiceXML+='<Invoice-SED-UnitPrice>35</Invoice-SED-UnitPrice>\n';
            strInvoiceXML+='</Goods>\n';
            strInvoiceXML+='</OpenShipment>\n';
        }
        return strInvoiceXML;

    
    }
    
    public static string InvoiceLessProctored(List<Shipping_Boxes__c> lstShipInfo)
    {
        String strInvoiceLessXML = '';
        for(Shipping_Boxes__c objShipInfo : lstShipInfo)
        {
            strInvoiceLessXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">\n';
            strInvoiceLessXML+='<ShipTo>\n';
            strInvoiceLessXML+='<CustomerID></CustomerID>\n';
            strInvoiceLessXML+='<CompanyOrName>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Company__c)+'</CompanyOrName>\n';
            strInvoiceLessXML+='<Attention>'+CheckNull(objShipInfo.Pre_Test_Box_Attention__c)+'</Attention>\n';
            strInvoiceLessXML+='<Address1>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Address_1__c)+'</Address1>\n';
            strInvoiceLessXML+='<Address2>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Address_2__c)+'</Address2>\n';
            strInvoiceLessXML+='<Address3>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Address_3__c)+'</Address3>\n';
            strInvoiceLessXML+='<CountryTerritory>'+CheckNull(objShipInfo.Pre_Test_Box_Country_Code_for_UPS__c)+'</CountryTerritory>\n';
            strInvoiceLessXML+='<PostalCode>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Postal_Code__c)+'</PostalCode>\n';
            strInvoiceLessXML+='<CityOrTown>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_City__c)+'</CityOrTown>\n';
            strInvoiceLessXML+='<StateProvinceCounty>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_State_Provence__c)+'</StateProvinceCounty>\n';
            strInvoiceLessXML+='<Telephone>'+CheckNull(objShipInfo.Pre_Test_Box_Shipping_Phone_Number__c)+'</Telephone>\n';
            strInvoiceLessXML+='<FaxNumber>'+CheckNull(objShipInfo.Fax__c)+'</FaxNumber>\n';
            strInvoiceLessXML+='<EmailAddress>'+CheckNull(objShipInfo.Pre_Test_Box_E_mail__c)+'</EmailAddress>\n';
            strInvoiceLessXML+='<TaxIDNumber></TaxIDNumber>\n';
            strInvoiceLessXML+='<ReceiverUpsAccountNumber>999999</ReceiverUpsAccountNumber>\n';
            strInvoiceLessXML+='<LocationID></LocationID>\n';
            strInvoiceLessXML+='<ResidentialIndicator></ResidentialIndicator>\n';
            strInvoiceLessXML+='</ShipTo>\n';
            strInvoiceLessXML+='<ShipFrom>\n';
            strInvoiceLessXML+='<CompanyOrName>GLOBAL ASSN OF RISK PROFSSNLS</CompanyOrName>\n';
            strInvoiceLessXML+='<Attention>SHIPPER</Attention>\n';
            strInvoiceLessXML+='<Address1>111 TOWN SQUARE PLACE</Address1>\n';
            strInvoiceLessXML+='<Address2>SUITE 1215</Address2>\n';
            strInvoiceLessXML+='<CountryTerritory>US</CountryTerritory>\n';
            strInvoiceLessXML+='<PostalCode>07310</PostalCode>\n';
            strInvoiceLessXML+='<CityOrTown>Jersey City</CityOrTown>\n';
            strInvoiceLessXML+='<StateProvinceCounty>NJ</StateProvinceCounty>\n';
            strInvoiceLessXML+='</ShipFrom>\n';
            strInvoiceLessXML+='<ShipmentInformation>\n';
            strInvoiceLessXML+='<ServiceType>'+CheckNull(objShipInfo.Pre_Test_Box_UPS_service_code_for_XML__c)+'</ServiceType>\n';
            strInvoiceLessXML+='<NumberOfPackages>1</NumberOfPackages>\n';
            strInvoiceLessXML+='<DescriptionOfGoods>Documents</DescriptionOfGoods>\n';
            strInvoiceLessXML+='<ShipperNumber>A3R489</ShipperNumber>\n';
            strInvoiceLessXML+='<BillingOption>PP</BillingOption>\n';
            strInvoiceLessXML+='<BillTransportationTo>SHP</BillTransportationTo>\n';
            strInvoiceLessXML+='<BillDutyTaxTo>SHP</BillDutyTaxTo>\n';
            strInvoiceLessXML+='<DeliveryConfirmation>\n';
            strInvoiceLessXML+='<SignatureRequired>1</SignatureRequired>\n';
            strInvoiceLessXML+='</DeliveryConfirmation>\n';
            strInvoiceLessXML+='</ShipmentInformation>\n';
            strInvoiceLessXML+='<Package>\n';
            strInvoiceLessXML+='<PackageType>CP</PackageType>\n';
            strInvoiceLessXML+='<Weight>'+CheckNull(objShipInfo.Weight__c)+'</Weight>\n';
            strInvoiceLessXML+='<TrackingNumber></TrackingNumber>\n';
            strInvoiceLessXML+='<LargePackageIndicator></LargePackageIndicator>\n';
            strInvoiceLessXML+='<Reference1>'+CheckNull(objShipInfo.Name)+'</Reference1>\n';
            strInvoiceLessXML+='<Reference2>'+CheckNull(objShipInfo.Pre_Test_Box_Reference_2__c)+'</Reference2>\n';
            strInvoiceLessXML+='</Package>\n';
            strInvoiceLessXML+='<InternationalDocumentation>\n';
            strInvoiceLessXML+='<InvoiceTermOfSale>FOB</InvoiceTermOfSale><InvoiceReasonForExport>NOT FOR RESALE TESTING MATERIALS</InvoiceReasonForExport>\n';
            strInvoiceLessXML+='<InvoiceCurrencyCode>US</InvoiceCurrencyCode>\n';
            strInvoiceLessXML+='</InternationalDocumentation>\n';
            strInvoiceLessXML+='<Goods>\n';
            strInvoiceLessXML+='<DescriptionOfGood>Documents</DescriptionOfGood>\n';
            strInvoiceLessXML+='<Inv-NAFTA-CO-CountryTerritoryOfOrigin>United States</Inv-NAFTA-CO-CountryTerritoryOfOrigin>\n';
            strInvoiceLessXML+='<InvoiceUnits>1</InvoiceUnits>\n';
            strInvoiceLessXML+='<InvoiceUnitOfMeasure>Piece</InvoiceUnitOfMeasure>\n';
            strInvoiceLessXML+='<Invoice-SED-UnitPrice>35</Invoice-SED-UnitPrice>\n';
            strInvoiceLessXML+='</Goods>\n';
            strInvoiceLessXML+='</OpenShipment>\n';
        }
        return  strInvoiceLessXML;
    }

}