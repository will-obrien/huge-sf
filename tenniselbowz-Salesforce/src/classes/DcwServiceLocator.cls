public with sharing class DcwServiceLocator {
	
	

	public string country{get;set;}
	public string stateProvence{get;set;}
	public string city{get;set;}
	public string zipCode{get;set;}
	
	Integer pageGet = 0;
	list<ServiceLocation> serviceLocations;
	public class ServiceLocation
	{
		public String CompanyName{get;set;}
		public String Address1{get;set;}
		public String Address2{get;set;}
		public String Address3{get;set;}
		public String City{get;set;}
		public String StateOrProvince{get;set;}
		public String PostalCode{get;set;}
		public String Country{get;set;}
		public String Phone{get;set;}
		public String Email{get;set;}
		public String WebSite{get;set;}
		public String CompanyID{get;set;}
		public String Id{get;set;}
		public String context{get;set;}
	}
	
	public DcwServiceLocator()
	{
		serviceLocations = new list<ServiceLocation>();
	}
	
	public list<ServiceLocation> getServiceLocations()
	{
		String canadaState = '';
		
		
		String countryId = DCW_Country_Id_Map__c.getInstance(country) == null ? '' : DCW_Country_Id_Map__c.getInstance(country).DCW_Country_Id__c;
		
		
		if(country != null && 'CA,CAN,Canada'.containsIgnoreCase(country) )
		  countryId = '38';
		  
		if(country != null && 'US,USA,United States'.containsIgnoreCase(country) )
		  countryId = '218';
		  
		if(countryId == '38')
		{
		  zipCode = '';
		  canadaState = CanadianProvinces__c.getInstance(stateProvence)==null?'':CanadianProvinces__c.getInstance(stateProvence).Province__c;//'Ontario';//
		  stateProvence = '';
		  
		}
		else if(countryId != '218')
		{
			canadaState = '';
			stateProvence = '';
		}
		   
		  
		string filters =  
		              '<daik:filters>'
			            +'<daik:PartnerTypeCode>SVC</daik:PartnerTypeCode>'
			            +'<daik:ProductName>(Any)</daik:ProductName>'
			            +'<daik:CountryID>'+countryId+'</daik:CountryID>'
			            +'<daik:State>'+stateProvence+'</daik:State>'
			            +'<daik:CanadianProvince>'+canadaState+'</daik:CanadianProvince>'
			            +'<daik:PostalCode>'+zipCode+'</daik:PostalCode>'
			         +'</daik:filters>';
	    
	    
	    System.debug(':::SOAP:::: '+getSoapRequest(filters));
	    if (pageGet == 0){
			appendServiceList(getSoapRequest(filters), serviceLocations, 'Service Office');
			
			appendServiceList(getSoapRequest(filters.replace('>SVC<', '>REP<')), serviceLocations, 'Sales Office');
			
			//International Only no US or Canada
			if(!(countryId == '38' || countryId == '218'))
				appendServiceList(getSoapRequest(filters.replace('>SVC<', '>DIS<')), serviceLocations, 'Distributor');
			
			System.debug('::::::serviceLocations>>::::'+serviceLocations);
			pageGet ++;
	    }
		
        //return the ServiceLocation List
        return serviceLocations;
	}
    
    public void appendServiceList(string soapRequest, list<ServiceLocation> serviceLocations, string context)
    {
    	Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setTimeout(120000); //long timeout
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction','http://daikinmcquay.com/FindPartners');
        
        req.setEndpoint('http://application.daikinapplied.com/Daikin.McQuay.PartnerLocator/PartnerLocator.asmx');//should configure this
        //add the SOAP message to the body of the request
        req.setBody(soapRequest);
        string bodyRes = '';
        
        //create a xml object for structuring the response string
        Dom.Document resDomDoc = new Dom.Document();
        HttpResponse res = new HttpResponse();
        
        
        try 
        {
        	
            set<String> repsOfficeIdSet = new set<String>();
            if(!Test.isRunningTest())
    		{
	            //send the http request
	            res = h.send(req);
	            //pull the response into the xml object
	            resDomDoc = res.getBodyDocument();
    		}
    		else
    		{
    			resDomDoc.load(getTestResponse());
    		}
            
            Dom.XMLNode envelopeElement = resDomDoc.getRootElement();
            Dom.XMLNode bodyElement = envelopeElement.getChildElements().get(0);
            Dom.XMLNode partnerResponse =  bodyElement.getChildElements().get(0);
            Dom.XMLNode partnersResult =  partnerResponse.getChildElements().get(0);
            Dom.XMLNode diffgram = partnersResult.getChildElements().get(1);
            if(diffgram.getChildElements().size() < 1)
              return;
            
            Dom.XMLNode PartnerDS = diffgram.getChildElements().get(0);
            
            //iterate through the List of partners loading the ServiceLocation object list
            for(Dom.XMLNode partner : PartnerDS.getChildren())
            {
            	ServiceLocation loc= new ServiceLocation();
            	loc.context = context;
            	for(Dom.XMLNode partnerField : partner.getChildren())
                {
                	if(partnerField.getName() == 'CompanyName')
                	  loc.CompanyName = partnerField.getText();
                	if(partnerField.getName() == 'Address1')
                	  loc.Address1 = partnerField.getText();
                	if(partnerField.getName() == 'Address2')
                	  loc.Address2 = partnerField.getText();
                	if(partnerField.getName() == 'Address3')
                	  loc.Address3 = partnerField.getText();
                	if(partnerField.getName() == 'City')
                	  loc.City = partnerField.getText();
                	if(partnerField.getName() == 'StateOrProvince')
                	  loc.StateOrProvince = partnerField.getText();
                	if(partnerField.getName() == 'Phone')
                	  loc.Phone = partnerField.getText();
                	if(partnerField.getName() == 'Email')
                	  loc.Email = partnerField.getText();
                	if(partnerField.getName() == 'Country')
                	  loc.Country = partnerField.getText();
                	if(partnerField.getName() == 'WebSite')
                	  loc.WebSite = partnerField.getText();
                	if(partnerField.getName() == 'PostalCode')
                	  loc.PostalCode = partnerField.getText();
                	if(partnerField.getName() == 'CompanyName')
                	  loc.CompanyName = partnerField.getText();
                	if(partnerField.getName() == 'CompanyID')
                	{
                	  loc.CompanyID = partnerField.getText();
                	  repsOfficeIdSet.add(loc.CompanyID);
                	}
                }
            	serviceLocations.add(loc);
				
            }
            
            for(Account a : [Select Id, Rep_Office_ID__c from Account where Rep_Office_ID__c in :repsOfficeIdSet])
            {
            	for(ServiceLocation s : serviceLocations)
            	{
            		if(a.Rep_Office_ID__c == s.CompanyId)
            		   s.Id = a.Id;
            	}
            }
            
        } 
        catch(System.CalloutException e) 
        {
            System.debug('Callout error: '+ e);
        }
        
    }
    
    public  string getSoapRequest(String filters)
    {
    	return '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:daik="http://daikinmcquay.com/">'
			   +'<soapenv:Header/>'
			   +'<soapenv:Body>'
			     +' <daik:FindPartners>'
			         + filters
			         +'<daik:localeIdUI>133</daik:localeIdUI>'
			      +'</daik:FindPartners>'
			   +'</soapenv:Body>'
			+'</soapenv:Envelope>';
    }
    
    public string getTestResponse()
    {
    	return
    	'<?xml version="1.0" encoding="utf-8"?>'+
	    '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
  		'<soap:Body>'+
    		'<FindPartnersResponse xmlns="http://daikinmcquay.com/">'+
      			'<FindPartnersResult>'+
      				'<Schema>cc</Schema>'+
      				'<diffgram>'+
      				   '<PartnerDS>'+
      				   		'<PartnerDSc>'+
      				   			'<CompanyName>x</CompanyName>'+
      				   			'<Address1>x</Address1>'+
      				   			'<Address2>x</Address2>'+
      				   			'<Address3>x</Address3>'+
      				   			'<City>x</City>'+
      				   			'<StateOrProvince>x</StateOrProvince>'+
      				   			'<Phone>x</Phone>'+
      				   			'<Email>x</Email>'+
      				   			'<Country>x</Country>'+
      				   			'<WebSite>x</WebSite>'+
      				   			'<PostalCode>x</PostalCode>'+
      				   			'<CompanyName>x</CompanyName>'+
      				   			'<CompanyID>x</CompanyID>'+
      				   		'</PartnerDSc>'+
      				   '</PartnerDS>'+
      				
      				'</diffgram>'+
      			
      			'</FindPartnersResult>'+
    		'</FindPartnersResponse>'+
  		'</soap:Body>'+
		'</soap:Envelope>';
    }
    

}