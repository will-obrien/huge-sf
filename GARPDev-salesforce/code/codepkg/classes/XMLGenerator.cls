public with sharing class XMLGenerator {
    
    
   public static string internationalShipping(List<Opportunity> lstOpp)
    {
        String sXML = '';
        for(Opportunity opp : lstOpp)
        {
            
            /*String[] arrStreetInfo = opp.Shipping_Street__c.split('\n');
            String s1 = '';
            String s2 = '';
            String s3 = '';
            if (arrStreetInfo != null && arrStreetInfo.size() > 0)
                s1 = arrStreetInfo[0];
            if (arrStreetInfo != null && arrStreetInfo.size() > 1)
                s2 = arrStreetInfo[1];
            if (arrStreetInfo != null && arrStreetInfo.size() > 2)
                s3 = arrStreetInfo[2];*/
            
           sXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">\n';
            String strShippName = opp.Shipping_First_Name__c + ' ' + opp.Shipping_Last_Name__c;
            String strCompanyName = opp.Shipping_Company_Name__c == null ? strShippName : opp.Shipping_Company_Name__c;
            sXML += '<ShipTo>\n';
            sXML += '<CustomerID></CustomerID>\n';
            sXML += '<CompanyOrName>'+strCompanyName+'</CompanyOrName>\n';
            sXML += '<Attention>'+strShippName+'</Attention>\n';
            sXML += '<Address1>'+CheckNull(opp.Shipping_Address1__c)+'</Address1>\n';
            sXML += '<Address2>'+CheckNull(opp.Shipping_Address2__c)+'</Address2>\n';
            sXML += '<Address3>'+CheckNull(opp.Shipping_Address3__c)+'</Address3>\n';
            sXML += '<CountryTerritory>'+CheckNull(opp.Country_Code_for_UPS__c)+'</CountryTerritory>\n';
            sXML += '<PostalCode>'+CheckNull(opp.Shipping_Postal_Code__c)+'</PostalCode>\n';
            sXML += '<CityOrTown>'+CheckNull(opp.Shipping_City__c)+'</CityOrTown>\n';
            sXML += '<StateProvinceCounty>'+StateCodes.getStateId(opp.Shipping_Country__c,opp.Shipping_State__c)+'</StateProvinceCounty>\n';
            sXML += '<Telephone>'+CheckNull(opp.Shipping_Phone_No__c)+'</Telephone>\n';
            sXML += '<FaxNumber></FaxNumber>\n';
            sXML += '<EmailAddress>'+CheckNull(opp.Shipping_E_mail__c)+'</EmailAddress>\n';
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
            sXML += '<ServiceType>'+CheckNull(opp.UPS_Service_Code_For_Xml__c)+'</ServiceType>\n';
            sXML += '<NumberOfPackages>1</NumberOfPackages>\n';
            sXML += '<DescriptionOfGoods>Education Materials</DescriptionOfGoods>\n';
            sXML += '<ShipperNumber>7699YE</ShipperNumber>\n';
            sXML += '<BillingOption>PP</BillingOption>\n';
            
            sXML += '<BillTransportationTo>SHP</BillTransportationTo>\n';
            if(opp.Duty_Tax_to_Garp__c)
                sXML += '<BillDutyTaxTo>SHP</BillDutyTaxTo>\n';
            sXML += '<QVNOption>\n';
            sXML += '<QVNRecipientAndNotificationTypes>\n';
            sXML += '<EMailAddress>'+CheckNull(opp.Shipping_E_mail__c)+'</EMailAddress>\n';
            sXML += '<Ship>1</Ship>\n';
            sXML += '<Exception>1</Exception>\n';
            sXML += '<Delivery>1</Delivery>\n';
            sXML += '</QVNRecipientAndNotificationTypes>\n';
            sXML += '<SubjectLine>Shipping confirmation of your order</SubjectLine>\n';
            sXML += '</QVNOption>\n';
            sXML += '</ShipmentInformation>\n';
            sXML += '<Package>\n';
            sXML += '<PackageType>CP</PackageType>\n';
            sXML += '<Weight>'+CheckNull(String.valueOf(opp.Total_Package_Weight__c))+'</Weight>\n';
            sXML += '<TrackingNumber></TrackingNumber>\n';
            sXML += '<LargePackageIndicator></LargePackageIndicator>\n';
            sXML += '<Reference1>'+CheckNull(opp.Display_Invoice_Number__c)+'</Reference1>\n';
            sXML += '<Reference2>'+CheckNull(opp.Product_Ids__c)+'</Reference2>';
            sXML += '</Package>\n';
            sXML += '<InternationalDocumentation>\n';
            sXML += '<InvoiceReasonForExport>Sale</InvoiceReasonForExport>\n';
            sXML += '<InvoiceCurrencyCode>US</InvoiceCurrencyCode>\n';
            sXML += '</InternationalDocumentation>\n';
           
            String strGoodsXML = '';
            if(opp.Product_Names__c != null && opp.Product_Names__c != '')
            {
                String[] arrCustomCost = new String[]{};    
                if(opp.Customs_Cost__c != null)
                    arrCustomCost = opp.Customs_Cost__c.split(',');
                Integer iterator = 0;
                for(String strName : opp.Product_Names__c.split(','))
                {

                    strGoodsXML += '<Goods>';
                    strGoodsXML +='<DescriptionOfGood>'+strName+'</DescriptionOfGood>\n';
                    strGoodsXML +='<Inv-NAFTA-CO-CountryTerritoryOfOrigin>United States</Inv-NAFTA-CO-CountryTerritoryOfOrigin>\n';
                    strGoodsXML +='<InvoiceUnits>1</InvoiceUnits>\n';
                    strGoodsXML +='<InvoiceUnitOfMeasure>Piece</InvoiceUnitOfMeasure>\n';
                    if(arrCustomCost.size() >0)
                    strGoodsXML +='<Invoice-SED-UnitPrice>'+arrCustomCost[iterator]+'</Invoice-SED-UnitPrice>\n';
                    strGoodsXML +='</Goods>\n';

                    iterator++;

                }


            }

            sXML += strGoodsXML;
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

    
    
    public static string domesticShipping(List<Opportunity> lstOpp)
    {
        String sXML = '';
        for(Opportunity opp : lstOpp)
        {
            //String strAddress = opp.Shipping_Street__c;

            /*String[] arrStreetInfo = strAddress.split('\n');
            String s1 = '';
            String s2 = '';
            String s3 = '';
            if (arrStreetInfo != null && arrStreetInfo.size() > 0)
                s1 = arrStreetInfo[0];
            if (arrStreetInfo != null && arrStreetInfo.size() > 1)
                s2 = arrStreetInfo[1];
            if (arrStreetInfo != null && arrStreetInfo.size() > 2)
                s3 = arrStreetInfo[2];*/
            
            sXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">\n';
            String strShippName = opp.Shipping_First_Name__c + ' ' + opp.Shipping_Last_Name__c;
            String strCompanyName = opp.Shipping_Company_Name__c == null ? strShippName : opp.Shipping_Company_Name__c;
            sXML += '<ShipTo>\n';
            sXML += '<CustomerID></CustomerID>\n';
            sXML += '<CompanyOrName>'+strCompanyName+'</CompanyOrName>\n';
            sXML += '<Attention>'+strShippName+'</Attention>\n';
            sXML += '<Address1>'+CheckNull(opp.Shipping_Address1__c)+'</Address1>\n';
            sXML += '<Address2>'+CheckNull(opp.Shipping_Address2__c)+'</Address2>\n';
            sXML += '<Address3>'+CheckNull(opp.Shipping_Address3__c)+'</Address3>\n';
            sXML += '<CountryTerritory>'+CheckNull(opp.Country_Code_for_UPS__c)+'</CountryTerritory>\n';
            sXML += '<PostalCode>'+CheckNull(opp.Shipping_Postal_Code__c)+'</PostalCode>\n';
            sXML += '<CityOrTown>'+CheckNull(opp.Shipping_City__c)+'</CityOrTown>\n';
            sXML += '<StateProvinceCounty>'+StateCodes.getStateId(opp.Shipping_Country__c,opp.Shipping_State__c)+'</StateProvinceCounty>\n';
            sXML += '<Telephone>'+CheckNull(opp.Shipping_Phone_No__c)+'</Telephone>\n';
            sXML += '<FaxNumber></FaxNumber>\n';
            sXML += '<EmailAddress>'+CheckNull(opp.Shipping_E_mail__c)+'</EmailAddress>\n';
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
            sXML += '<ServiceType>'+CheckNull(opp.UPS_Service_Code_For_Xml__c)+'</ServiceType>\n';
            sXML += '<NumberOfPackages>1</NumberOfPackages>\n';
            sXML += '<DescriptionOfGoods>Education Materials</DescriptionOfGoods>\n';
            sXML += '<ShipperNumber>7699YE</ShipperNumber>\n';
            sXML += '<BillingOption>PP</BillingOption>\n';
            sXML += '<BillTransportationTo>SHP</BillTransportationTo>\n';
            sXML += '<QVNOption>\n';
            sXML += '<QVNRecipientAndNotificationTypes>\n';
            sXML += '<EMailAddress>'+CheckNull(opp.Shipping_E_mail__c)+'</EMailAddress>\n';
            sXML += '<Ship>1</Ship>\n';
            sXML += '<Exception>1</Exception>\n';
            sXML += '<Delivery>1</Delivery>\n';
            sXML += '</QVNRecipientAndNotificationTypes>\n';
            sXML += '<SubjectLine>Shipping confirmation of your order</SubjectLine>\n';
            sXML += '</QVNOption>\n';
            sXML += '</ShipmentInformation>\n';
            sXML += '<Package>\n';
            sXML += '<PackageType>CP</PackageType>\n';
            sXML += '<Weight>'+CheckNull(String.valueOf(opp.Total_Package_Weight__c))+'</Weight>\n';
            sXML += '<TrackingNumber></TrackingNumber>\n';
            sXML += '<LargePackageIndicator></LargePackageIndicator>\n';
            sXML += '<Reference1>'+CheckNull(opp.Display_Invoice_Number__c)+'</Reference1>\n';
            sXML += '<Reference2>'+CheckNull(opp.Product_Ids__c)+'</Reference2>\n';
            sXML += '</Package>\n';
            sXML += '</OpenShipment>\n';
    
        }
            
        return sXML;    
    
    }
    
    public static String invoicelessXML(List<opportunity> lstOpp)
    {
        String sXML = '';
        for(Opportunity opp : lstOpp)
        {       
            /*String[] arrStreetInfo = opp.Shipping_Street__c.split('\n');
            String s1 = '';
            String s2 = '';
            String s3 = '';
            if (arrStreetInfo != null && arrStreetInfo.size() > 0)
                s1 = arrStreetInfo[0];
            if (arrStreetInfo != null && arrStreetInfo.size() > 1)
                s2 = arrStreetInfo[1];
            if (arrStreetInfo != null && arrStreetInfo.size() > 2)
                s3 = arrStreetInfo[2];*/
            
            sXML += '<OpenShipment ShipmentOption="SP" ProcessStatus="">\n';
            String strShippName = opp.Shipping_First_Name__c + ' ' + opp.Shipping_Last_Name__c;
            String strCompanyName = opp.Shipping_Company_Name__c == null ? strShippName : opp.Shipping_Company_Name__c;
            sXML += '<ShipTo>\n';
            sXML += '<CustomerID></CustomerID>\n';
            sXML += '<CompanyOrName>'+strCompanyName+'</CompanyOrName>\n';
            sXML += '<Attention>'+strShippName+'</Attention>\n';
            sXML += '<Address1>'+CheckNull(opp.Shipping_Address1__c)+'</Address1>\n';
            sXML += '<Address2>'+CheckNull(opp.Shipping_Address2__c)+'</Address2>\n';
            sXML += '<Address3>'+CheckNull(opp.Shipping_Address3__c)+'</Address3>\n';
            sXML += '<CountryTerritory>'+CheckNull(opp.Country_Code_for_UPS__c)+'</CountryTerritory>\n';
            sXML += '<PostalCode>'+CheckNull(opp.Shipping_Postal_Code__c)+'</PostalCode>\n';
            sXML += '<CityOrTown>'+CheckNull(opp.Shipping_City__c)+'</CityOrTown>\n';
            sXML += '<StateProvinceCounty>'+StateCodes.getStateId(opp.Shipping_Country__c,opp.Shipping_State__c)+'</StateProvinceCounty>\n';
            sXML += '<Telephone>'+CheckNull(opp.Shipping_Phone_No__c)+'</Telephone>\n';
            sXML += '<FaxNumber></FaxNumber>\n';
            sXML += '<EmailAddress>'+CheckNull(opp.Shipping_E_mail__c)+'</EmailAddress>\n';
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
            sXML += '<ServiceType>'+CheckNull(opp.UPS_Service_Code_For_Xml__c)+'</ServiceType>\n';
            sXML += '<NumberOfPackages>1</NumberOfPackages>\n';
            sXML += '<DescriptionOfGoods>Education Materials</DescriptionOfGoods>\n';
            sXML += '<ShipperNumber>7699YE</ShipperNumber>\n';
            sXML += '<BillingOption>PP</BillingOption>\n';
            sXML += '<BillTransportationTo>SHP</BillTransportationTo>\n';
            if(opp.Duty_Tax_to_Garp__c)
                sXML += '<BillDutyTaxTo>SHP</BillDutyTaxTo>\n';
            sXML += '<QVNOption>\n';
            sXML += '<QVNRecipientAndNotificationTypes>\n';
            sXML += '<EMailAddress>'+CheckNull(opp.Shipping_E_mail__c)+'</EMailAddress>\n';
            sXML += '<Ship>1</Ship>\n';
            sXML += '<Exception>1</Exception>\n';
            sXML += '<Delivery>1</Delivery>\n';
            sXML += '</QVNRecipientAndNotificationTypes>\n';
            sXML += '<SubjectLine>Shipping confirmation of your order</SubjectLine>\n';
            sXML += '</QVNOption>\n';
            sXML += '</ShipmentInformation>\n';
            sXML += '<Package>\n';
            sXML += '<PackageType>CP</PackageType>\n';
            sXML += '<Weight>'+CheckNull(String.valueOf(opp.Total_Package_Weight__c))+'</Weight>\n';
            sXML += '<TrackingNumber></TrackingNumber>\n';
            sXML += '<LargePackageIndicator></LargePackageIndicator>\n';
            sXML += '<Reference1>'+CheckNull(opp.Display_Invoice_Number__c)+'</Reference1>\n';
            sXML += '<Reference2>'+CheckNull(opp.Product_Ids__c)+'</Reference2>\n';
            sXML += '</Package>\n';
            sXML += '<InternationalDocumentation>\n';
            sXML += '<InvoiceReasonForExport>Sale</InvoiceReasonForExport>\n';
            sXML += '<InvoiceCurrencyCode>US</InvoiceCurrencyCode>\n';
            sXML += '</InternationalDocumentation>\n';
            
            String strGoodsXML = '';
            if(opp.Product_Names__c != null && opp.Product_Names__c != '')
            {
                    
                
                String[] arrCustomCost = opp.Customs_Cost__c.split(',');
                Integer iterator = 0;
                for(String strName : opp.Product_Names__c.split(','))
                {

                    strGoodsXML += '<Goods>\n';
                    strGoodsXML +='<DescriptionOfGood>'+strName+'</DescriptionOfGood>\n';
                    strGoodsXML +='<Inv-NAFTA-CO-CountryTerritoryOfOrigin>United States</Inv-NAFTA-CO-CountryTerritoryOfOrigin>\n';
                    strGoodsXML +='<InvoiceUnits>1</InvoiceUnits>\n';
                    strGoodsXML +='<InvoiceUnitOfMeasure>Piece</InvoiceUnitOfMeasure>\n';
                    strGoodsXML +='<Invoice-SED-UnitPrice>'+arrCustomCost[iterator]+'</Invoice-SED-UnitPrice>\n';
                    strGoodsXML +='</Goods>\n';

                    iterator++;

                }


            }

            sXML += strGoodsXML;
            sXML += '</OpenShipment>\n';
            
        }
        return sXML;
        
    
    }
    
    public static String writeExcelBody(List<Opportunity> lstOpp)
    {
        Map<Id,List<OpportunityLineItem>> mapLineItems = new Map<Id,List<OpportunityLineItem>>();
        
        for(OpportunityLineItem objLineItem : [select id,ProductCode,Product2.Product_ID__c,Product2.Name,Quantity,OpportunityId from OpportunityLineItem where OpportunityId in: lstOpp])

        {
            if(mapLineItems.containsKey(objLineItem.OpportunityId))
                mapLineItems.get(objLineItem.OpportunityId).add(objLineItem);
            else
                mapLineItems.put(objLineItem.OpportunityId,new List<OpportunityLineItem>{objLineItem});
        }
        //SNO\tCompanyName\tAttention\tAddressLine1\tAddressLine2\tAddressLine3\tCity\tState\tCountry\tPostalCode\tWorkPhone\tFaxNumber\tEmailAddress\tServiceType\tFRM1H\tFRM2H\t4030\tCBRNM\tCBRM\tFCBR\tFBRNM\tInvoice Number\tlength\tTotalQuantity'
        string strExcelBody = '';
        Integer iSerialNo  = 0;
        for(Opportunity obj : lstOpp)
        {
            String[] arrStreetInfo ;
            if(obj.Shipping_Street__c != null){
                arrStreetInfo = obj.Shipping_Street__c.split('\n');
            }
            String s1 = '';
            String s2 = '';
            String s3 = '';
            if (arrStreetInfo != null && arrStreetInfo.size() > 0)
                s1 = arrStreetInfo[0];
            if (arrStreetInfo != null && arrStreetInfo.size() > 1)
                s2 = arrStreetInfo[1];
            if (arrStreetInfo != null && arrStreetInfo.size() > 2)
                s3 = arrStreetInfo[2];

            String strAddress = '';
            if(obj.Shipping_Street__c != null)
                strAddress = obj.Shipping_Street__c.replace(',','').replace('\r\n',';');
            String strShippName = obj.Shipping_First_Name__c + ' ' + obj.Shipping_Last_Name__c;
            String strCompanyName = obj.Shipping_Company_Name__c == null ? strShippName : obj.Shipping_Company_Name__c;
            if(strCompanyName.indexOf(',') >= 0)
                strCompanyName = strCompanyName.substring(0,strCompanyName.indexOf(','));
            
            strExcelBody += iSerialNo + 1 + ',' + formatCSValue(strCompanyName) + ',' + formatCSValue(obj.Shipping_First_Name__c) + ',' + formatCSValue(obj.Shipping_Address1__c)+ ',' + formatCSValue(obj.Shipping_Address2__c)+ ',' + formatCSValue(obj.Shipping_Address3__c)+ ',' + formatCSValue(obj.Shipping_City__c)+ ',' + formatCSValue(obj.Shipping_State__c)+ ',' + formatCSValue(obj.Shipping_Country__c)+ ',' + formatCSValue(obj.Shipping_Postal_Code__c)+ ',' + formatCSValue(obj.Shipping_Phone_No__c)+ ',' + '' + ',' +formatCSValue(obj.Shipping_E_mail__c)+ ',' + formatCSValue(obj.Shipping_Serive_Selected__c);
            //FRM1H,FRM2H,4030, CBRNM, CBRM,FCBR,FBRNM 
            String strOppLineItemRow = ',2504,2505,914,861,2372';
            Integer iQuantity = 0;
            system.debug('mapLineItems == '+mapLineItems);
            //Update Line Items information
            if(mapLineItems.containsKey(obj.Id))
            {
                for(OpportunityLineItem objOppLine : mapLineItems.get(obj.Id))
                {
                    system.debug('objOppLine == '+objOppLine);
                    if(objOppLine.Product2.Product_ID__c == null) continue;
                    if(strOppLineItemRow.indexOf(objOppLine.Product2.Product_ID__c) >= 0)
                    {
                        strOppLineItemRow = strOppLineItemRow.replace(objOppLine.Product2.Product_ID__c,'1');
                        iQuantity++;
                    }
                    else
                        strOppLineItemRow = strOppLineItemRow.replace(objOppLine.Product2.Product_ID__c,'0');
                    
                }


            }
            strOppLineItemRow = strOppLineItemRow.replace('2504','').replace('2505','').replace('914','').replace('861','').replace('2372','');
            //Append Opporutnity and line itme info
            strExcelBody += strOppLineItemRow;
            //Add final infomration
            strExcelBody += ',' + obj.Display_Invoice_Number__c + ',' + ''+ ',' + iQuantity;
            strExcelBody = strExcelBody.replace('null','');
            strExcelBody += '\r\n';

            iSerialNo++;
            
        }
        
        return strExcelBody;
    }

    public static string formatCSValue(string val)
    {
        if(val == null) return '';
        return val.escapeCsv();
    }

    public class EmailBodyWrapper
    {

        public String Product_Name;
        public String Product_ID;
        public Decimal Quantity;
    }

    public static string PrepareBodyTable(List<Opportunity> lstOpps)
    {
        Set<String> setProdIds = new Set<String>{'2504','2505','914','861','2372'};
        Map<String,EmailBodyWrapper> mapProdQuantity = new Map<String,EmailBodyWrapper>();
        for(OpportunityLineItem objLineItem : [select id,ProductCode,Product2.Product_ID__c,Product2.Name,Quantity,OpportunityId from OpportunityLineItem where OpportunityId in : lstOpps and Product2.Product_ID__c in : setProdIds])
        {
            if(mapProdQuantity.containsKey(objLineItem.Product2.Product_ID__c))
            {
                EmailBodyWrapper objWrapper = mapProdQuantity.get(objLineItem.Product2.Product_ID__c);
                objWrapper.Quantity = objWrapper.Quantity + (objLineItem.Quantity == null ? 0 : objLineItem.Quantity);
                mapProdQuantity.put(objLineItem.Product2.Product_ID__c, objWrapper);
            }
            else
            {
                EmailBodyWrapper objWrapper =  new EmailBodyWrapper();
                objWrapper.Quantity = (objLineItem.Quantity == null ? 0 : objLineItem.Quantity);
                objWrapper.Product_ID = objLineItem.Product2.Product_ID__c;
                objWrapper.Product_Name = objLineItem.Product2.Name;
                mapProdQuantity.put(objLineItem.Product2.Product_ID__c,objWrapper);

            }
                
        }

        String strBody = '';
        strBody += '<HTML>';
        strBody += '<Table border="2">';
        strBody += '<TR>';
        strBody += '<TD>';
        strBody += 'Product Name';  
        strBody += '</TD>';
        //strBody += '</TR>';
       // strBody += '<TR>';
        strBody += '<TD>';
        strBody += 'Product Id';  
        strBody += '</TD>';
        //strBody += '</TR>';
        //strBody += '<TR>';
        strBody += '<TD>';
        strBody += 'Quantity';  
        strBody += '</TD>';
        strBody += '</TR>';
        for(String strID : mapProdQuantity.keySet())
        {
            EmailBodyWrapper objWrap = mapProdQuantity.get(strID);
            strBody += '<TR>';
            strBody += '<TD>';
            strBody += objWrap.Product_Name;
            strBody += '</TD>';
            
            
            strBody += '<TD>';
            strBody += objWrap.Product_ID;
            strBody += '</TD>';
            
            strBody += '<TD>';
            strBody += objWrap.Quantity;
            strBody += '</TD>';
            strBody += '</TR>';

        }

        strBody += '</Table>';
        strBody += '</HTML>';

        return strBody;

    }
    
    

}