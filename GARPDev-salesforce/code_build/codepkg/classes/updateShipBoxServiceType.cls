global class updateShipBoxServiceType implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{
   global String strUSA = 'US';
   boolean bIsActive = true;
   global string strQuery = 'select id,Active__c,Exam_Boxes__c,Fax__c,Proctor_Boxes__c,Reference_2__c,ShipToAddress1__c,ShipToAddress2__c,ShipToAddress3__c,ShipToAttention__c,ShipToCityorTown__c,ShipToCompanyorName__c,ShipToCountryTerritory__c,SiteCode__c,Site_ID__c,SiteName__c,Value__c,Weight__c from Shipping_Boxes__c where Active__c =: bIsActive';
    global set<String> setInvoiceLessCountries = new set<String>{'AS', 'AU', 'AT', 'AZ', 'BE', 'KH', 'CA', 'IC', 'CN', 'CK', 'HR', 'CY', 'CZ', 'DK','DO', 'EN', 'EE', 'FJ', 'FI', 'FR', 'PF', 'DE', 'GU', 'GG', 'HO', 'HK', 'HU', 'IN','ID', 'IE', 'IT', 'JP', 'JE', 'KI', 'KO', 'LV', 'LI', 'LT', 'LU', 'MO', 'M3', 'MY','MV', 'MT', 'MH', 'MX', 'FM', 'MC', 'MN', 'NP', 'NL', 'NC', 'NZ', 'NB', 'MP', 'NO','PW', 'PG', 'PH', 'PL', 'PO', 'PT', 'PR', 'RO', 'RT', 'SP', 'SF', 'SG', 'SK', 'SI','SB', 'ZA', 'KR', 'ES', 'SX', 'UV', 'VL', 'SE', 'CH', 'SY', 'TA', 'TW', 'TH', 'TL','TI', 'TO', 'TU', 'TV', 'GB', 'VI', 'VU', 'VA', 'VN', 'WL', 'WF', 'WS', 'YA'};
     global updateShipBoxServiceType(){
        
     }
     
     // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('strQuery == '+strQuery);
        return Database.getQueryLocator(strQuery);
     }
    
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Shipping_Boxes__c> scope){
        
        system.debug('scope == '+scope);
        List<Shipping_Boxes__c> lstShipping = new List<Shipping_Boxes__c>();
        for(Shipping_Boxes__c obj : scope)   
        {
          // if(obj.Id != 'a05f00000048nT2') continue;
          // obj.Active__c = false;
           if(obj.ShipToCountryTerritory__c == 'US')
           {
                obj.Service_type__c = '3DS';
                 lstShipping.add(obj);
           }
           else
            lstShipping.add(callUpsService(obj));
            
        }
        
        update lstShipping;
        
    }
    
    private Shipping_Boxes__c callUpsService(Shipping_Boxes__c objShipping)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://wwwcie.ups.com/ups.app/xml/Rate');
        //req.setEndpoint('https://onlinetools.ups.com/ups.app/xml/Rate');
        req.setMethod('POST');
        decimal dWeight = 1;
        string strXML = UPSServices.prepPriceXML(objShipping.ShipToCountryTerritory__c,'07310',dWeight);
        system.debug(strXML);
        req.setBody(strXML);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded'); 
        system.debug(req);
        Http httpVal = new Http();
        HttpResponse res = httpVal.send(req);
        system.debug('Price Resp == '+res.getBody());
        Dom.Document doc = res.getBodyDocument();
        Dom.XMLNode responseNode = doc.getRootElement();
        Set<String> setCodes = new Set<String>();
        for(DOM.XMLNode node : responseNode.getChildElements())
        {
            system.debug('node == '+node);
            if(node.getName() == 'RatedShipment')
            {
                system.debug('Child node == '+node);
                for(DOM.XMLNode serviceNode :node.getChildElements())
                {
                    if('Service' == serviceNode.getName())
                    {
                        system.debug('serviceNode == '+serviceNode);
                        setCodes.add(serviceNode.getChildElement('Code',null).getText());
                    }
                }
            }
             
        }
        
        if(setCodes.contains('65'))
            objShipping.Service_type__c = 'SV';
        else if(setCodes.contains('07'))
            objShipping.Service_type__c = 'ES';
        else if(setCodes.contains('08'))
            objShipping.Service_type__c = 'EX';
            
        return objShipping;
                
        
    }
   
    global void finish(Database.BatchableContext BC){
        
       
    }
 }