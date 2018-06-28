public class UPSServices
    {

/*
List<wrapperUtils.upsWrapper> lst = UPSServices.getUPSPrice ('1505','NORTHUMBERLAND','MOMMOUTH JUNCTION','US','NJ','08852');

List<wrapperUtils.upsWrapper> lst1 = UPSServices.getPriceWebResponse('4530-6 Pierre de Coubertin','Montreal','CA','QC','H1V 3V5');
system.debug('lst == '+lst1);


List<wrapperUtils.upsWrapper> lst1 = UPSServices.getUPSPrice('4530-6','Pierre de Coubertin','Montreal','CANADA','QC','H1V3V5');
system.debug('lst == '+lst1);


*/
        public static List<wrapperUtils.addressWrapper> lstAddressWrapper = new List<wrapperUtils.addressWrapper>();
        public static  List<wrapperUtils.upsWrapper> getUPSPrice(string strAddress1,string strAddress2,string strCity,string strCountry,
                                                                            string strStateCode,string strZip,List<String> lstProdCodes)
        {
            HttpResponse addressResponse = getWebResponse(strAddress1,strAddress2,strCity,strCountry,strZip,strStateCode);
            if(addressResponse == null)
                throw new GARPexception('Some issue with the HTTP request');
            system.debug('response  == '+addressResponse.getBody());
            boolean bISSuccess  = false;
            if(strCountry == 'US')
                bISSuccess = isSuccess(addressResponse);
            else
                bISSuccess = true;
            if(bISSuccess)
               return  getPriceWebResponse(strAddress1 + ' ' +strAddress2,strCity,strCountry,strZip,strStateCode,lstProdCodes);
            else
            {
                List<wrapperUtils.upsWrapper> upsServiceWrapper = new List<wrapperUtils.upsWrapper>();
                wrapperUtils.upsWrapper objUPSWrapper = new wrapperUtils.upsWrapper();
                objUPSWrapper.lstMatchingAddress = lstAddressWrapper;
                upsServiceWrapper.add(objUPSWrapper);
                system.debug('upsServiceWrapper  == '+upsServiceWrapper);
                return upsServiceWrapper;
            }
            //return null;
        }
        
        public static HttpResponse getWebResponse(string strAddress1,string strAddress2,string strCity,string strCountry,string strZip, string strStateCode) {
        
            HttpRequest req = new HttpRequest();
           // req.setEndpoint('https://wwwcie.ups.com/ups.app/xml/AV');
            req.setEndpoint('https://onlinetools.ups.com/ups.app/xml/XAV');
            req.setMethod('POST');
            string strXML = prepXML(strAddress1,strAddress2,strCity,strCountry,strZip,strStateCode);
            system.debug(strXML);
            req.setBody(strXML);
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded'); 
            system.debug(req);
            Http httpVal = new Http();
            HttpResponse res = httpVal.send(req);
            system.debug('UPS ADdress Response == '+res.getBody());
            return res;
        }

        public static List<wrapperUtils.upsWrapper> getPriceWebResponse(string strAddress,string strCity,string strCountry,string strZip, string strStateCode,List<String> lstProdCodes) {
        
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://wwwcie.ups.com/ups.app/xml/Rate');
            //req.setEndpoint('https://onlinetools.ups.com/ups.app/xml/Rate');
            req.setMethod('POST');
            decimal dWeight = getWeightByProdCodes(lstProdCodes);
            string strXML = prepPriceXML(strCountry,strZip,dWeight);
            system.debug(strXML);
            req.setBody(strXML);
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded'); 
            system.debug(req);
            Http httpVal = new Http();
            HttpResponse res = httpVal.send(req);
            system.debug('Price Resp == '+res.getBody());
            return getPriceQuotes(res,strCountry);
            //return res;
        }
        
       public static decimal getWeightByProdCodes(List<String> lstProdCodes)
       {
            try
            {
                 AggregateResult[] groupedResults = [SELECT SUM(Weight__c)total from product2 where ProductCode in: lstProdCodes]; 
                 decimal dWeight = (decimal) groupedResults[0].get('total');
                 return dWeight;
            }
            catch(exception ex)
            {
                return 1;
            }
       
       }
        
      public static string prepXML(string strAddress1,string strAddress2,string strCity,string strCountry,string strZip, string strStateCode)
        {
                 string sUPSAccessLiscenseNumber = 'DC3972F4C25D1D04'; //''8C3765DFFF2F98C0'
            string sUPSUserID = 'garpups';
            string sUPSPassword = '7y8uSAi8o9';
            string sXML = '<?xml version="1.0"?>';
            sXML = sXML + ' <AccessRequest xml:lang="en-US">';
            sXML = sXML + '       <AccessLicenseNumber>' + sUPSAccessLiscenseNumber + '</AccessLicenseNumber>';
            sXML = sXML + '       <UserId>' + sUPSUserID + '</UserId>';
            sXML = sXML + '       <Password>' + sUPSPassword + '</Password>';
            sXML = sXML + ' </AccessRequest>';
            sXML = sXML + '<?xml version="1.0"?>';
            sXML = sXML + ' <AddressValidationRequest xml:lang="en-US">';
            sXML = sXML + '       <Request>';
            sXML = sXML + '              <TransactionReference>';
            sXML = sXML + '                     <CustomerContext>Address Validation</CustomerContext>';
            sXML = sXML + '                     <XpciVersion>1.0001</XpciVersion>';
            sXML = sXML + '              </TransactionReference>';
            sXML = sXML + '              <RequestAction>XAV</RequestAction>';
            sXML = sXML + '              <RequestOption>1</RequestOption>';
            sXML = sXML + '       </Request>';
            sXML = sXML + '              <MaximumListSize>3</MaximumListSize>';
            sXML = sXML + '       <AddressKeyFormat>';
            sXML = sXML + '              <AddressLine>' + strAddress1 + '</AddressLine>';
             sXML = sXML + '              <AddressLine>' + strAddress2 + '</AddressLine>';
            sXML = sXML + '              <PoliticalDivision2>' + strCity + '</PoliticalDivision2>';
            sXML = sXML + '              <PoliticalDivision1>' + strStateCode + '</PoliticalDivision1>';
            sXML = sXML + '              <PostcodePrimaryLow>' + strZip + '</PostcodePrimaryLow>';
            sXML = sXML + '              <CountryCode>' + strCountry + '</CountryCode>';
            sXML = sXML + '       </AddressKeyFormat>';
            sXML = sXML + '</AddressValidationRequest>';
                system.debug('strXML === '+sXML);
                return sXML;
        
        } 

        public static string prepPriceXML(string strCountryCode,string strShipToPOCode,decimal iWeight)
        {
                 string sUPSAccessLiscenseNumber = 'DC3972F4C25D1D04'; //''8C3765DFFF2F98C0'
            string sUPSUserID = 'garpups';
            string sUPSPassword = '7y8uSAi8o9';
            string strFromPOCode = '08831';
            string sXML = '<?xml version="1.0"?>';
                sXML = sXML + ' <AccessRequest xml:lang="en-US">';
                sXML = sXML + '       <AccessLicenseNumber>' + sUPSAccessLiscenseNumber + '</AccessLicenseNumber>';
                sXML = sXML + '       <UserId>' + sUPSUserID + '</UserId>';
                sXML = sXML + '       <Password>' + sUPSPassword + '</Password>';
                sXML = sXML + ' </AccessRequest>';
                sXML = sXML + '<?xml version="1.0"?>';
                sXML = sXML + ' <RatingServiceSelectionRequest xml:lang="en-US">';
                sXML = sXML + '       <Request>';
                sXML = sXML + '              <TransactionReference>';
                sXML = sXML + '                     <CustomerContext>Rating and Service</CustomerContext>';
                sXML = sXML + '                     <XpciVersion>1.0001</XpciVersion>';
                sXML = sXML + '              </TransactionReference>';
                sXML = sXML + '              <RequestAction>Rate</RequestAction>';
                sXML = sXML + '              <RequestOption>shop</RequestOption>';
                sXML = sXML + '       </Request>';
                sXML = sXML + '       <PickupType>';
                sXML = sXML + '              <Code>01</Code>';
                sXML = sXML + '       </PickupType>';
                sXML = sXML + '       <Shipment>';
                sXML = sXML + '              <Shipper>';
                sXML = sXML + '                     <Address>';
                sXML = sXML + '                            <PostalCode>' + strFromPOCode+ '</PostalCode>';
                sXML = sXML + '                     </Address>';
                sXML = sXML + '              </Shipper>';
                sXML = sXML + '              <ShipTo>';
                sXML = sXML + '                     <Address>';
                sXML = sXML + '                            <PostalCode>' + strShipToPOCode + '</PostalCode>';
                sXML = sXML + '                            <CountryCode>' + strCountryCode + '</CountryCode>';
                sXML = sXML + '                     </Address>';
                sXML = sXML + '              </ShipTo>';
                sXML = sXML + '              <Service>';
                sXML = sXML + '                     <Code>11</Code>';
                sXML = sXML + '              </Service>';
                sXML = sXML + '              <Package>';
                sXML = sXML + '                     <PackagingType>';
                sXML = sXML + '                            <Code>02</Code>';
                sXML = sXML + '                            <Description>Package</Description>';
                sXML = sXML + '                     </PackagingType>';
                sXML = sXML + '                     <Description>Rate Shopping</Description>';
                sXML = sXML + '                     <PackageWeight>';
                sXML = sXML + '                            <Weight>' + iWeight + '</Weight>';
                sXML = sXML + '                     </PackageWeight>';
                sXML = sXML + '              </Package>';
                sXML = sXML + '              <ShipmentServiceOptions/>';
                sXML = sXML + '       </Shipment>';
                sXML = sXML + '</RatingServiceSelectionRequest>';
                return sXML;
     
        
        } 

        public static boolean isSuccess(HTTPResponse response)
        {
            try
            {
                Dom.Document doc = response.getBodyDocument();
                System.debug('doc TEXT == '+doc);
                //Retrieve the root element for this document.
                Dom.XMLNode responseNode = doc.getRootElement();
                boolean bIsSuccess = false;
                System.debug('responseNode == '+responseNode);
                System.debug('responseNode 1== '+responseNode.getChildElements());
                System.debug('sucess 1== '+responseNode.getChildElement('ValidAddressIndicator',null));
                bIsSuccess = (responseNode.getChildElement('ValidAddressIndicator',null)) != null;
                if(!bIsSuccess)
                {
                    for(DOM.XMLNode node : responseNode.getChildElements())
                    {
                        if(node.getName() == 'AddressKeyFormat')
                        {
                            system.debug('NOD === '+Node);
                            wrapperUtils.addressWrapper objAddWrapper = new wrapperUtils.addressWrapper();
                            system.debug('objAddWrapper2 === '+node.getChildElement('AddressLine',null).getText());
                            objAddWrapper.strAddress = node.getChildElement('AddressLine',null).getText();
                            objAddWrapper.strCity = node.getChildElement('PoliticalDivision2',null).getText();
                            objAddWrapper.strStateCode = node.getChildElement('PoliticalDivision1',null).getText();
                            objAddWrapper.strZipCode = node.getChildElement('PostcodePrimaryLow',null).getText();
                            lstAddressWrapper.add(objAddWrapper);
                        }
                        system.debug('objAddWrapper == '+lstAddressWrapper);    
                    }
                
                }
                return bIsSuccess;
                /*system.debug('DIRECT VAL == '+responseNode.getChildElement('Response',null).getChildElement('ResponseStatusCode',null).getText());
                System.debug('responseNode TEXT == '+responseNode);
                System.debug('responseNode.getChildElements() == '+responseNode.getChildElements());
                List<Dom.XMLNode> lstNodes = new List<Dom.XMLNode>();
               
               
                /*for(Dom.xmlNode xmlDOM : responseNode.getChildElement('Response',null))
                {
                    if(xmlDOM.getNodeType() == DOM.XMLNodeType.ELEMENT && xmlDOM.getName() == 'ResponseStatusDescription')
                    {
                        system.debug('DESC == '+ xmlDOM.getText().trim());
                        bIsSuccess = (xmlDOM.getText().trim() == 'Success' ? true : false);
        
                    }
        
                }
                System.debug('lstNodes == '+lstNodes);*/
                 
             }
             catch(exception ex)
             {
                 throw ex;
                 return false;
             }

        }

        public static List<wrapperUtils.upsWrapper> getPriceQuotes(HTTPResponse response,string strCountryCode)
        {
            try
            {
                Dom.Document doc = response.getBodyDocument();
                
                Dom.XMLNode responseNode = doc.getRootElement();
                boolean bIsSuccess = false;
                system.debug('responseNode == '+responseNode);
                 Dom.XMLNode priceNode =   responseNode;
                system.debug('responseNode  Cgild== '+responseNode.getChildElement('Response',null));
                bIsSuccess = responseNode.getChildElement('Response',null).getChildElement('ResponseStatusCode',null).getText() == '1';
                Map<String,Decimal> mapShipDetails = new Map<String,Decimal>();

                if(bIsSuccess)
                {
                    for(Dom.xmlNode childNode : responseNode.getChildElements())
                    {
                        system.debug('TESTEST 111=== '+childNode);
                        String strServiceCode = '';
                        decimal dAmount = 0;
                        if(childNode.getChildElement('Service',null) != null)
                        {
                            //system.debug('Code 1== ' + childNode.getChildElement('Service',null).getChildElement('Code',null).getText());
                            strServiceCode = childNode.getChildElement('Service',null).getChildElement('Code',null).getText();

                        }
                        if(childNode.getChildElement('ServiceOptionsCharges',null) != null)
                        {
                           //system.debug('Code 2== ' + childNode.getChildElement('TotalCharges',null).getChildElement('MonetaryValue',null).getText());
                           dAmount = decimal.valueOf(childNode.getChildElement('TotalCharges',null).getChildElement('MonetaryValue',null).getText());

                        }
                        if(strServiceCode != '')
                         mapShipDetails.put(strServiceCode,dAmount);
                        
                    }
                    system.debug('mapShipDetails == '+mapShipDetails);

                }
                if(mapShipDetails.size() > 0)
                 return prepareWrapper(mapShipDetails,strCountryCode);
                else
                    return null;
                
             }
             catch(exception ex)
             {
                 return null;
             }

        }

        public static List<wrapperUtils.upsWrapper> prepareWrapper(Map<String,Decimal> mapUPSPrice,string strCountryCode)
        {
                List<wrapperUtils.upsWrapper> lstUPSDetails = new List<wrapperUtils.upsWrapper>();
                wrapperUtils.upsWrapper objUPS = null;
                decimal dDiscount = 50;
                if(strCountryCode == 'US' || strCountryCode == 'CA')
                    dDiscount = 30;
    
                if(strCountryCode == 'CA')
                {
                    objUPS = new wrapperUtils.upsWrapper();
                    objUPS.strUPSDesc = getUPSDesc('65');
                    objUPS.dPrice = calDiscount(mapUPSPrice.get('65'),dDiscount,strCountryCode);
                    objUPS.lstMatchingAddress=null;
                    lstUPSDetails.add(objUPS);
                    return lstUPSDetails;
                } else {
                    for(String strKey : mapUPSPrice.keySet())
                    {
                        
                        objUPS = new wrapperUtils.upsWrapper();
                        objUPS.strUPSDesc = getUPSDesc(strKey);
                        objUPS.dPrice = calDiscount(mapUPSPrice.get(strKey),dDiscount,strCountryCode);
                        objUPS.lstMatchingAddress=null;
    					system.debug('Add lstUPSDetails=== '+objUPS);
                        
                        //Boolean found=false;
                        //for(wrapperUtils.upsWrapper upsw : lstUPSDetails) {
                        //    if(upsw.strUPSDesc == objUPS.strUPSDesc && upsw.dPrice == objUPS.dPrice)
                        //        found=true;
                        //}
                        //if(found == false)
						lstUPSDetails.add(objUPS);
                    }
                }
                return lstUPSDetails;

        }

        public static string getUPSDesc(string strCode)
        {
            string strReturnVal = '';
            if(strCode == '01')
                strReturnVal = 'UPS Next Day Air';
            else if(strCode == '02')
                strReturnVal  = 'UPS 2nd Day Air';
            else if(strCode == '03')
                strReturnVal  = 'UPS Ground';
            else if(strCode == '07')
                strReturnVal  = 'UPS Worldwide Express';
            else if(strCode == '08')
                strReturnVal  = 'UPS Worldwide Expedited';
            else if(strCode == '11')
                strReturnVal  = 'UPS Standard';
            else if(strCode == '12')
                strReturnVal  = 'UPS 3 Day Select';
            else if(strCode == '13')
                strReturnVal  = 'UPS Next Day Air Saver';
            else if(strCode == '14')
                strReturnVal  = 'UPS Next Day Air Early A.M.';
            else if(strCode == '54')
                strReturnVal  = 'UPS Worldwide Express Plus';
            else if(strCode == '59')
                strReturnVal  = 'UPS 2nd Day Air A.M.';
            else if(strCode == '65')
                strReturnVal  = 'UPS Saver';

            return strReturnVal;

        }

        public static decimal calDiscount(decimal dPrice,decimal dDiscPercentage,string strCountry)
        {

            decimal dRetPrice = (dPrice * dDiscPercentage) / 100;
            if(dRetPrice < 12) dRetPrice = 12;
            return dRetPrice;
        }


     




    }