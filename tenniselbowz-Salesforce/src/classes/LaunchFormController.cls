public without sharing class LaunchFormController {
    public String action { get; set; }
    public String formType { get; set; }
    public String formURLName {get; set;}
    public String status {get; set;}
    public String callfunc {get;set;}  // used to call javascript function from apex code
    public String jobSiteAddress {get; set;}
    public String customerName {get; set;}
    public Boolean disableCustName {get;set;} // flag that is used to enable/disable customer name field on the page
    public Boolean disableAddrId {get;set;} // flag that is used to enable/disable address id field on the page
    public Boolean disableDate {get;set;} // flag that is used to enable/disable date field on the page
    
    String siteHostPartial = 'daikinapplied';
    String url1=URL.getCurrentRequestUrl().toExternalForm();
    String url2=URL.getSalesforceBaseUrl().toExternalForm();
    String url3=ApexPages.currentPage().getUrl();
    String host=URL.getCurrentRequestUrl().getHost();
    @TestVisible Boolean forceDotComSite = host.contains(siteHostPartial); // This will be True if the url contains 'daikinapplied' in the host part of the url
    @TestVisible String sessionId = ApexPages.currentPage().getParameters().get('SessionID');
    
    // Use Custom Settings
    JHA_Form_App_Config_Settings__c salesPortalAuthUrl = JHA_Form_App_Config_Settings__c.getInstance('SALES_PORTAL_AUTH_URL');  // https://salestest.daikinapplied.com/biz/autologsession2?returnurl=
    JHA_Form_App_Config_Settings__c authWebServiceHost = JHA_Form_App_Config_Settings__c.getInstance('AUTH_WEB_SERVICE_HOST');  // applicationtest.daikinapplied.com:443
    JHA_Form_App_Config_Settings__c authWebServiceEndpoint = JHA_Form_App_Config_Settings__c.getInstance('AUTH_WEB_SERVICE_ENDPOINT');  // https://applicationtest.daikinapplied.com/McQuayToolsSrvc/Authentication.asmx
    JHA_Form_App_Config_Settings__c tempUri = JHA_Form_App_Config_Settings__c.getInstance('TEMP_URI');  // http://tempuri.org/
    

	@TestVisible String epriseLoginId = null;
    @TestVisible String firstName = null;
    @TestVisible String lastName = null;
    @TestVisible String email = null;
    
    public JHA_Form__c jhaForm {get; set;}
    public Address__c addr {get; set;}
    
	List<SelectOption> actions = null;
    public List<SelectOption> getActions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('New','Create new form')); 
        options.add(new SelectOption('Recent','Open most recent form')); 
        options.add(new SelectOption('Specific','Open specific date form'));
        return options; 
    }
    
    List<SelectOption> formTypes = null;
    public List<SelectOption> getFormTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        options.add(new SelectOption('JHA','Job Hazardous Assessment form')); 
        options.add(new SelectOption('Inspection','Inspection form')); 
        options.add(new SelectOption('Operations','Operations form'));
        options.add(new SelectOption('Warranty/Startup','Warranty/Start Up form'));
        options.add(new SelectOption('Other','Other form'));
        return options; 
    }
    
    
    public LaunchFormController() {
        System.debug('LaunchFormController()');
        
        jhaForm = new JHA_Form__c();
        addr = new Address__c();
        
        status = null;
        jobSiteAddress = null;
        customerName = null;
        
        // Set default for Action radio buttons to "Create new form"
        action = 'New';
        
        // Disable all the input fields for the default action
        disableCustName = true;
        disableAddrId = true;
        disableDate = true;
        
        //callfunc = '<script> disableAllInputFields(); </script>';
        
        //status= 'url1=' + url1 + ',  url2=' + url2 + ', url3=' + url3 + ', host=' + host;
        //For the force.com site: url1=http://nadev-daikinapplied.cs45.force.com/LaunchForm/apex/Launch_Form, url2=http://nadev-daikinapplied.cs45.force.com, url3=/apex/Launch_Form, host=nadev-daikinapplied.cs45.force.com
    }
    
    
    public PageReference loginSalesPortal() {
        // Action method that gets called when page is requested by the server, before the page is rendered and after the constructor.
        // <apex:page ... action="{!loginSalesPortal}" >
        System.debug('loginSalesPortal()');
        
        if (forceDotComSite) {
            // Check if the querystring parameter, SessionID exists. If it does make sure it is still valid before continuing.
            // If it's valid then get user information
            // else redirect user to the Sales Portal page to login first
            
            //sessionId = ApexPages.currentPage().getParameters().get('SessionID');
            String redirectURL = salesPortalAuthUrl.App_Config_Setting__c + url2 + '/LaunchForm';  //https://salestest.daikinapplied.com/biz/autologsession2?returnurl=http://nadev-daikinapplied.cs45.force.com/LaunchForm
            System.debug(sessionId);
            System.debug(redirectURL);
            
            if (String.isNotBlank(sessionId)) {
                // Check if session id is valid
                if (isSessionIdValid(sessionId)) {
                    System.debug('Session Id is valid');
                    
                    // Get user information
                    getUserInfoBySessionId(sessionId);
                    
                    return null; // Refresh page
                }
                else {
                    // Session Id is invalid so redirect user to the Sales Portal page to login
                    System.debug('Session Id is invalid');
                    PageReference pageRef = new PageReference(redirectURL);
                    pageRef.setRedirect(true);
                    return pageRef;
                }
            }
            else {
                // No session id was passed so redirect user to the Sales Portal page to login
                System.debug('No Session Id provided ' + redirectURL);
                PageReference pageRef = new PageReference(redirectURL);
                pageRef.setRedirect(true);
                System.debug(pageRef.getUrl());
                return pageRef;
            }
        }
        else {
            return null;  // Refresh page
        }
        
    }
    
    
    private Boolean isSessionIdValid(String id) {
        String valid = null;
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(30000); // set timeout in milliseconds
        req.setMethod('POST');
        req.setHeader('Accept-Encoding','gzip,deflate');
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        
        req.setHeader('Host', authWebServiceHost.App_Config_Setting__c);
        
        req.setEndpoint(authWebServiceEndpoint.App_Config_Setting__c);
        
        req.setHeader('SOAPAction', tempUri.App_Config_Setting__c + 'ValidateSession');
        
        String requestString = '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
          '<soap:Body>' +
            '<ValidateSession xmlns="' + tempUri.App_Config_Setting__c + '">' +
              '<sessionId>' + id + '</sessionId>' +
            '</ValidateSession>' +
          '</soap:Body>' +
        '</soap:Envelope>';
        
        req.setHeader('Content-Length',String.valueOf(requestString.length()));
        
        req.setBody(requestString);
        HttpResponse res = h.send(req);
        //string bodyRes=res.getBody();
        //System.debug(bodyRes);
        
        Dom.Document doc = res.getBodyDocument(); System.debug(doc.toXmlString());
        Dom.XMLNode root = doc.getRootElement(); System.debug(root.getName()); System.debug(root.getNamespace());
        Dom.XMLNode child1 = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/'); System.debug(child1.getName()); System.debug(child1.getNamespace());
        Dom.XMLNode child1_1 = child1.getChildElement('ValidateSessionResponse', tempUri.App_Config_Setting__c); System.debug(child1_1.getName()); System.debug(child1_1.getNamespace());
        Dom.XMLNode child1_1_1 = child1_1.getChildElement('ValidateSessionResult', tempUri.App_Config_Setting__c); System.debug(child1_1_1.getName()); System.debug(child1_1_1.getNamespace());
        
        // Get the session validity from the body result xml
        valid = child1_1_1.getText(); System.debug(valid);

        if (valid != null) {
            if (valid.equalsIgnoreCase('true'))
                return true;
            else
                return false;
        }
        else {
            return false;
        }
    }
    
    
    private void getUserInfoBySessionId(String id) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(30000); // set timeout in milliseconds
        req.setMethod('POST');
        req.setHeader('Accept-Encoding','gzip,deflate');
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        
        req.setHeader('Host', authWebServiceHost.App_Config_Setting__c);
        
        req.setEndpoint(authWebServiceEndpoint.App_Config_Setting__c);
        
        req.setHeader('SOAPAction', tempUri.App_Config_Setting__c + 'GetUserInfoBySessionId');
        
        String requestString = '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
          '<soap:Body>' +
            '<GetUserInfoBySessionId xmlns="' + tempUri.App_Config_Setting__c + '">' +
              '<sessionId>' + id + '</sessionId>' +
            '</GetUserInfoBySessionId>' +
          '</soap:Body>' +
        '</soap:Envelope>';
        
        req.setHeader('Content-Length',String.valueOf(requestString.length()));
        
        req.setBody(requestString);
        HttpResponse res = h.send(req);
        //string bodyRes=res.getBody();
        //System.debug(bodyRes);
        
        Dom.Document doc = res.getBodyDocument(); System.debug(doc.toXmlString());
        Dom.XMLNode root = doc.getRootElement(); System.debug(root.getName()); System.debug(root.getNamespace());
        Dom.XMLNode child1 = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/'); System.debug(child1.getName()); System.debug(child1.getNamespace());
        Dom.XMLNode child1_1 = child1.getChildElement('GetUserInfoBySessionIdResponse', tempUri.App_Config_Setting__c); System.debug(child1_1.getName()); System.debug(child1_1.getNamespace());
        Dom.XMLNode child1_1_1 = child1_1.getChildElement('GetUserInfoBySessionIdResult', tempUri.App_Config_Setting__c); System.debug(child1_1_1.getName()); System.debug(child1_1_1.getNamespace());
        Dom.XMLNode child1_1_1_1a = child1_1_1.getChildElement('LoginId', tempUri.App_Config_Setting__c); System.debug(child1_1_1_1a.getName()); System.debug(child1_1_1_1a.getNamespace());
        Dom.XMLNode child1_1_1_1b = child1_1_1.getChildElement('FirstName', tempUri.App_Config_Setting__c); System.debug(child1_1_1_1b.getName()); System.debug(child1_1_1_1b.getNamespace());
        Dom.XMLNode child1_1_1_1c = child1_1_1.getChildElement('LastName', tempUri.App_Config_Setting__c); System.debug(child1_1_1_1c.getName()); System.debug(child1_1_1_1c.getNamespace());
        Dom.XMLNode child1_1_1_1d = child1_1_1.getChildElement('Email', tempUri.App_Config_Setting__c); System.debug(child1_1_1_1d.getName()); System.debug(child1_1_1_1d.getNamespace());
        
        // Get the eprise login id from the body result xml
        epriseLoginId = child1_1_1_1a.getText(); System.debug(epriseLoginId);
        
        // Get the first name from the body result xml
        firstName = child1_1_1_1b.getText(); System.debug(firstName);
        
        // Get the last name from the body result xml
        lastName = child1_1_1_1c.getText(); System.debug(lastName);
        
        // Get the email address from the body result xml
        email = child1_1_1_1d.getText(); System.debug(email);
    }
    
    
    public void setdisableFieldFlags() {
        // Gets called when any of the Action radio buttons are selected
        // Set the disable field flags based on the Action selected
        status = '';
        
        if (action == 'New') {
            jhaForm.Jobsite_Address__c = null;
            jhaForm.Date__c = null;
            jobSiteAddress = '';
        	customerName = '';
			disableCustName = true;
        	disableAddrId = true;
        	disableDate = true;
        }
        else if (action == 'Recent') {
            jhaForm.Date__c = null;
            disableCustName = false;
        	disableAddrId = false;
        	disableDate = true;
        }
        else if (action == 'Specific') {
            jhaForm.Date__c = null;
            disableCustName = false;
        	disableAddrId = false;
        	disableDate = false;
        }
    }
    
    
    public void retrieveAddressAndAccount() {
        // Gets called when an Address Id is selected
        Account acctTemp = null;
        Address__c addrTemp = null;
        Account_Address__c acctAddrJunctionObj = null;
        status = '';
        jobSiteAddress = '';
        customerName = '';
        
        try {
            addrTemp = [SELECT Id, Name, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, Address_Name__c, Postal_Code__c, City__c, Country__c, State_Province__c FROM Address__c WHERE id = :jhaForm.Jobsite_Address__c];

            if (String.isNotEmpty(addrTemp.Address_Line_1__c))
                jobSiteAddress = addrTemp.Address_Line_1__c;
            if (String.isNotEmpty(addrTemp.Address_Line_2__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Address_Line_2__c;
            if (String.isNotEmpty(addrTemp.Address_Line_3__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Address_Line_3__c;
            if (String.isNotEmpty(addrTemp.Address_Line_4__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Address_Line_4__c;
            if (String.isNotEmpty(addrTemp.City__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.City__c;
            if (String.isNotEmpty(addrTemp.State_Province__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.State_Province__c;
            if (String.isNotEmpty(addrTemp.Postal_Code__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Postal_Code__c;
            if (String.isNotEmpty(addrTemp.Country__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Country__c;
            
            acctAddrJunctionObj = [SELECT Id, Name, Account__c, Address__c, Active__c, Physical__c FROM Account_Address__c WHERE Address__c = :addrTemp.Id];
                
            jhaForm.Customer_Name__c = acctAddrJunctionObj.Account__c;
                
            acctTemp = [SELECT Id, Name, Physical_Address__c FROM Account WHERE Id = :jhaForm.Customer_Name__c];
                    
            customerName = acctTemp.Name;
        }
        catch (QueryException e) {
            if (addrTemp == null) {
                status = 'Error: Address does not exist!';
            }
            else if (acctAddrJunctionObj == null) {
                status = 'Warning: No Account exists for this Address!';
            }
            else if (acctTemp == null) {
                status = 'Warning: No Customer Account exists!'; // Shouldn't ever reach this point
            }
            else {
                status = e.getMessage();
            }
        }
        finally {
            
        }
    }
    
    
    public PageReference get() {
        // Gets called when the Submit button is clicked
        string formId = null;
        JHA_Form__c jhaFormTemp1 = null;
        JHA_Form__c jhaFormTemp2 = null;
        
        System.debug('Action: ' + action); // if nothing picked then null
        System.debug('Form Type: ' + formtype); // if nothing picked then None
        System.debug('Form URL Name (beginning): ' + formURLName);
        
        formURLName = '';
        status = '';
        
        if (action == 'New') {
            if (formType == 'JHA') {
                if (forceDotComSite) {formURLName = url2 + '/LaunchForm/JHA_Form' + '?epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                else {formURLName = '/apex/JHA_Form' + '?epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                
                status = 'Success';
            }
            else if (formType == 'Inspection') {
                status = 'Create new Inspection form not implemented yet!';
            }
            else if (formType == 'Operations') {
                status = 'Create new Operations form not implemented yet!';
            }
            else if (formType == 'Warranty/Startup') {
                status = 'Create new Warranty/Start Up form not implemented yet!';
            }
            else if (formType == 'Other') {
                status = 'Create new Other form not implemented yet!';
            }
            else {
                status = 'Undefined Form Type!';
            }
        }
        else if (action == 'Recent') {
            if (formType == 'JHA') {
                // Get the most recent jha form via CreatedDate for the given Address Id
                try {
                    jhaFormTemp1 = [SELECT Id, Name, Customer_Name__c, Date__c, Employee__c, Evaluation_Type__c, Facility_Type__c, Jobsite_Address__c, Special_Comments__c FROM JHA_Form__c WHERE Jobsite_Address__c = :jhaForm.Jobsite_Address__c ORDER By CreatedDate DESC LIMIT 1];
                    formId = jhaFormTemp1.Id;
                    if (forceDotComSite) {formURLName = url2 + '/LaunchForm/JHA_Form?id=' + formId + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                	else {formURLName = '/apex/JHA_Form?id=' + formId + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                	
                	status = 'Success';
                }
                catch (QueryException e) {
                    status = 'No forms exist for the address!';
                }
            }
            else if (formType == 'Inspection') {
                status = 'Open most recent Inspection form not implemented yet!';
            }
            else if (formType == 'Operations') {
                status = 'Open most recent Operations form not implemented yet!';
            }
            else if (formType == 'Warranty/Startup') {
                status = 'Open most recent Warranty/Start Up form not implemented yet!';
            }
            else if (formType == 'Other') {
                status = 'Open most recent Other form not implemented yet!';
            }
            else {
                status = 'Undefined Form Type!';
            }
        }
        else if (action == 'Specific') {
            if (formType == 'JHA') {
                // Get the form whose Date__c is closest to the specified date (jhaForm.Date__c) for the given Address Id
                try {
                    // Check if the specified date field has a value or not
                    if (jhaForm.Date__c != null) {
                        // Check if there are 1 or more JHA Form records whose Date__c field equals the specified date. If there are then grab the most recent.
                        Integer recCount = [SELECT count() FROM JHA_Form__c WHERE Jobsite_Address__c = :jhaForm.Jobsite_Address__c AND Date__c = :jhaForm.Date__c];
                        if (recCount > 0) {
                            jhaFormTemp1 = [SELECT Id, Name, Customer_Name__c, Date__c, Employee__c, Evaluation_Type__c, Facility_Type__c, Jobsite_Address__c, Special_Comments__c FROM JHA_Form__c WHERE Jobsite_Address__c = :jhaForm.Jobsite_Address__c AND Date__c = :jhaForm.Date__c ORDER By CreatedDate DESC LIMIT 1];
                        }
                        else {
                            // Get the jha form record whose top date is <= to the specified date (lower bound)
                    		jhaFormTemp1 = [SELECT Id, Name, Customer_Name__c, Date__c, Employee__c, Evaluation_Type__c, Facility_Type__c, Jobsite_Address__c, Special_Comments__c FROM JHA_Form__c WHERE Jobsite_Address__c = :jhaForm.Jobsite_Address__c AND Date__c <= :jhaForm.Date__c ORDER By CreatedDate DESC LIMIT 1];
                			
                    		// Get the jha form record whose bottom date is >= to the specified date (upper bound)
                    		jhaFormTemp2 = [SELECT Id, Name, Customer_Name__c, Date__c, Employee__c, Evaluation_Type__c, Facility_Type__c, Jobsite_Address__c, Special_Comments__c FROM JHA_Form__c WHERE Jobsite_Address__c = :jhaForm.Jobsite_Address__c AND Date__c >= :jhaForm.Date__c ORDER By CreatedDate ASC LIMIT 1];
                        }
                    }
                }
                catch (QueryException e1) {
                    if (jhaFormTemp1 == null) {
                        try {
                            jhaFormTemp2 = [SELECT Id, Name, Customer_Name__c, Date__c, Employee__c, Evaluation_Type__c, Facility_Type__c, Jobsite_Address__c, Special_Comments__c FROM JHA_Form__c WHERE Jobsite_Address__c = :jhaForm.Jobsite_Address__c AND Date__c >= :jhaForm.Date__c ORDER By CreatedDate ASC LIMIT 1];
                        }
                        catch (QueryException e2) {
                            status = 'No forms exist for the address!';
                        }
                    }
                    else if (jhaFormTemp2 == null) {
                        // Do nothing
                    }
                }
                
                if (jhaForm.Date__c == null) {
                        status = 'Invalid date!';
                }
                else if ((jhaFormTemp1 != null) && (jhaFormTemp2 != null)) {
                    // Figure out which one is closest to the specified date
                    // Is jhaFormTemp1.Date__c OR jhaFormTemp2.Date__c Closest to jhaForm.Date__c
                    Integer numOfDays1 = math.abs(jhaForm.Date__c.daysBetween(jhaFormTemp1.Date__c));
                    Integer numOfDays2 = math.abs(jhaForm.Date__c.daysBetween(jhaFormTemp2.Date__c));
                    if (numOfDays1 < numOfDays2) {
                        formId = jhaFormTemp1.Id;
                    }
                    else {
                        formId = jhaFormTemp2.Id;
                    }
                    
                    if (forceDotComSite) {formURLName = url2 + '/LaunchForm/JHA_Form?id=' + formId + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                	else {formURLName = '/apex/JHA_Form?id=' + formId + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                    
                	status = 'Success';
                }
                else if ((jhaFormTemp1 != null) && (jhaFormTemp2 == null)) {
                    formId = jhaFormTemp1.Id;
                    
                    if (forceDotComSite) {formURLName = url2 + '/LaunchForm/JHA_Form?id=' + formId + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                	else {formURLName = '/apex/JHA_Form?id=' + formId + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                    
                	status = 'Success';
                }
                else if ((jhaFormTemp1 == null) && (jhaFormTemp2 != null)) {
                    formId = jhaFormTemp2.Id;
                    
                    if (forceDotComSite) {formURLName = url2 + '/LaunchForm/JHA_Form?id=' + formId + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                	else {formURLName = '/apex/JHA_Form?id=' + formId + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                    
                	status = 'Success';
                }
                else if ((jhaFormTemp1 == null) && (jhaFormTemp2 == null)) {
                    status = 'No forms exist for the address!';
                }
            }
            else if (formType == 'Inspection') {
                status = 'Open specific date Inspection form not implemented yet!';
            }
            else if (formType == 'Operations') {
                status = 'Open specific date Operations form not implemented yet!';
            }
            else if (formType == 'Warranty/Startup') {
                status = 'Open specific date Warranty/Start Up form not implemented yet!';
            }
            else if (formType == 'Other') {
                status = 'Open specific date Other form not implemented yet!';
            }
            else {
                status = 'Undefined Form Type!';
            }
        }
        else {
            status = 'Undefined Action!';
        }
        
        System.debug('Form URL Name (end): ' + formURLName);
        
        return null;
    }
}