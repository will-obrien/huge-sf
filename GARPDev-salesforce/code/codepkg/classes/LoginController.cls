/*********************************************
Name: LoginController
Description: VF controller for custom Community login page
    
Created/Modified By        Created/Modified Date        Comments
---------------------------------------------------------------------------
1. Billy Meyers             09/15/2014                   Version 1.0
*********************************************/
global with sharing class LoginController {
    
    global String username {get; set;}
    global String password {get; set;}   
    global String firstName {get; set;}
    global String lastName {get; set;}
    global String country {get; set;}
    global String company {get; set;}
    global String industry {get; set;}
    global String jobFunction {get; set;}
    
    global String emailForPasswordReset {get; set;}
    global Boolean passwordResetSuccessful {get; set;}
    global Boolean passwordResetEmailNotFound {get; set;}
    
    global String action {get; set;}
    global String actionId {get; set;}
    global String start {get; set;}
    global String gotoParam {get; set;}
    
    global Boolean newUser {get; set;}
    
    //global String debugInfo {get; set;}
    
    global List<SelectOption> countryList {
        get {
            if (countryList == null) {
                countryList = new List<SelectOption> {new SelectOption('', '-- Please Select --')};
                for (String country : COUNTRIES) {
                    countryList.add(new SelectOption(country, country));
                }
            }
            return countryList;
        }
        set;}    
    global List<SelectOption> industryList {
        get {
            if (industryList == null) {
                industryList = new List<SelectOption> {new SelectOption('', '-- Please Select --')};
                for (String industry : INDUSTRIES) {
                    industryList.add(new SelectOption(industry, industry));
                }
            }
            return industryList;
        }
        set;}
    global List<SelectOption> jobFunctionList {
        get {
            if (jobFunctionList == null) {
                jobFunctionList = new List<SelectOption> {new SelectOption('', '-- Please Select --')};
                for (String jobFunction : JOBFUNCTIONS) {
                    jobFunctionList.add(new SelectOption(jobFunction, jobFunction));
                }
            }
            return jobFunctionList;
        }
        set;}
    
    //public class TestException extends Exception {}
    
    global LoginController() {
        action = ApexPages.currentPage().getParameters().get('action');
        actionId = ApexPages.currentPage().getParameters().get('id');
        start = ApexPages.currentPage().getParameters().get('start');
        gotoParam = ApexPages.currentPage().getParameters().get('goto');

        system.debug('Login Action1:' + action + ':' + start + ':' + gotoParam + ':' + actionId);
        
        String registerParam = ApexPages.currentPage().getParameters().get('register');
        if (registerParam != null && Boolean.valueOf(registerParam)) {
            newUser = true;
        } else {
            newUser = false; 
        }
        passwordResetSuccessful = false;
        passwordResetEmailNotFound = false;
    }
    
    global PageReference init() {
    
        username =  ApexPages.currentPage().getParameters().get('username');
        password = ApexPages.currentPage().getParameters().get('password');

        //debugInfo += '<h1>ALL INCOMING HEADERS</h1>';
        //for (string key: ApexPages.currentPage().getHeaders().keySet()) {
        //    debugInfo += key + ' = ' + ApexPages.currentPage().getHeaders().get(key) + '<br />';
        //}        
        
        if (ApexPages.currentPage().getHeaders().get('CipherSuite') == null) {
			return new PageReference('https://' + ApexPages.currentPage().getHeaders().get('Host') + '/Login');
        }
        
        if(username != null && password != null) {
            return login();
        } else {   
            return checkIsLoggedIn();
        }
    }
    
    global PageReference checkIsLoggedIn() {
        User u = [SELECT Id, IsPortalEnabled FROM User WHERE Id = :UserInfo.getUserId()];
        if (u.IsPortalEnabled) {
            String redirectUrl = '/sfdcApp';
            redirectUrl += start != null ? '#!/' + start : '';
            return new PageReference(redirectUrl);
        }
        return null;
    }
    
    global PageReference login() {        
        String redirectUrl = '/sfdcApp?login=1';
        redirectUrl += start != null ? '#!/' + start : '';
        
        system.debug('Login Action2:' + action + ':' + gotoParam + ':' + redirectUrl);
        
        if (action != null) { 
            if (action == 'meeting'){
                redirectUrl = '/apex/RegisterForMeeting?id=' + actionId;
            } else if (action == 'jobtarget') {
                redirectUrl = '/apex/RegisterForJobTarget?goto=' + gotoParam;
            }
        }
        
        system.debug('redirectUrl:'+ redirectUrl);
        
        return Site.login(username, password, redirectUrl);
    }
    
    global PageReference resetPassword() {
        List<User> u = [SELECT Id, Email FROM User WHERE Email = :emailForPasswordReset AND IsPortalEnabled=true];
        if (u.isEmpty()) {
            passwordResetEmailNotFound = true;
        } else {
            passwordResetSuccessful = Site.forgotPassword(emailForPasswordReset);
        }       
        return null;
    }
    
    global PageReference resetPasswordResetSuccessful() {
        passwordResetSuccessful = false;
        passwordResetEmailNotFound = false;
        return null;
    }
    
    global Boolean getHasErrors() {
        return ApexPages.hasMessages(ApexPages.Severity.Error);
    }
    
    
    private boolean createMember(List<contact> lstcont) {
        
        
       contact c = lstcont[0];
        
        //Create an opportunity
        Contact con = [Select ID,Name,AccountID from contact where ID =: c.id];
        system.debug('Contact received from the login page ***'+con);
        contactExtn conextn = new contactExtn();
        Opportunity oppty = new Opportunity();
        oppty = conextn.createOpportunity(con,con.name,False);
        oppty.Eligible_for_Membership_Extension__c= false;
        
        //Adding Affiliate product to the opportunity
        conextn.createOppLineItems(oppty.ID,'AFREE','4999',con,'0.00');
        
        //Creating an Affiliate Contract
        ID contractID;
        contractID = conextn.createContract(con.AccountID,oppty.ID,con.ID,'Affiliate',True);
        
        
        
        //Close the opportunity
        oppty.Amount = 0.00;
        oppty.StageName = 'Closed';
        update oppty;
        
        con.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contact','Member');
        con.do_not_fire__c = False;
        update con;
        return true;
        
    }
        
    global PageReference register() {
        System.SavePoint sp = Database.setSavePoint();
        Id leadId;
        Registration.wrapperCreateOrder order;
        
        //System.assert(false, 'BOOM!' + order);
        
        system.debug('register:'+order);

        
        try {           
            TempAccount userData = getUserData();
            
            //System.assert(false, 'BOOM!'+ userData);
            
            if (Registration.GetMember(userData)){
                
                system.debug('GetMember Yes');
                
                List<Contact> lstCont = Registration.GetBussinessContact(userData);
                
                //System.assert(false, 'BOOM!!'+ lstCont);
                
                if (lstCont != null && lstCont.size() > 0){
                    
                    createMember(lstCont);
                    Contact newCont = lstCont[0];
                    
                    PageReference pr = new PageReference('/sfdcApp#!/registration_information/' + newCont.Id);
                    if(action != null) {
                        if(action == 'meeting'){                                
                            pr.getParameters().put('action', action);
                            pr.getParameters().put('id', actionId);
                            pr.getParameters().put('userid', newCont.Id);
                            pr.getParameters().put('success', String.valueOf(Registration.chapterMeetingRegister(newCont.Id, actionId, true)));
                        } else if (action == 'jobtarget'){
                            pr.getParameters().put('action', action);
                            pr.getParameters().put('userid', newCont.Id);
                        }
                    }
                    return pr;
                    
                } else {        
                    
                    system.debug('Member Exists:'+userData);
                
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The email you provided is already in our system. Please log in instead.'));
                    return null;
                }
                
            } else {
                
                leadId = Registration.SetLead(userData);
                
                system.debug('userData:'+userData);
                
                if (leadId != null) {
                    userData.Id = leadId;
                    order = Registration.createOrder(userData);
                    
                    system.debug('userData:'+userData);
                    
                    if (order.contactId != null) {
                        //throw new TestException('order.contactId: ' + order.contactId);
                        //PageReference pr = Page.SignupConfirm;
                        Lead convertedLead = [SELECT ConvertedContactId FROM Lead where id =: userData.Id];                    
                        
                        system.debug('convertedLead:'+convertedLead);
                        
                        
                        PageReference pr = new PageReference('/sfdcApp#!/registration_information/' + convertedLead.ConvertedContactId);
                        if(action != null) {
                            if(action == 'meeting'){                                
                                pr.getParameters().put('action', action);
                                pr.getParameters().put('id', actionId);
                                pr.getParameters().put('userid', convertedLead.ConvertedContactId);
                                pr.getParameters().put('success', String.valueOf(Registration.chapterMeetingRegister(convertedLead.ConvertedContactId, actionId, true)));
                            } else if (action == 'jobtarget'){
                                pr.getParameters().put('action', action);
                                pr.getParameters().put('userid', convertedLead.ConvertedContactId);
                            }
                        }
                        return pr;
                    }                  
                }
            }       
        } catch(Exception e) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            Database.rollback(sp);
            return null;
        }               
        
        //If it makes it to this point, something went wrong
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an unexpected error.'));
        System.debug('Error registering new user. leadId is ' + leadId + ', order is ' + order); 
        Database.rollback(sp);
        return null;
    }
    
    private TempAccount getUserData(){
        TempAccount objData = new TempAccount();
        objData.FirstName = firstName;
        objData.LastName = lastName;
        objData.Email = username;
        objData.MailingCountry = country;
        objData.BillingCountry = country;
        objData.Company = company;
        objData.JobFunction = jobFunction;
        objData.Organization = industry;
        objData.Industry = industry;
        objData.Membership_Type = 'AFREE';
        objData.garpMembership_Type = 'AFREE';
        objData.ACCA = false;
        objData.CA = false;
        objData.CFA = false;
        objData.CMA = false;
        objData.CPA = false;
        objData.InSchool = false;
        objData.OtherDesignation = false;
        objData.PMP = false;
        objData.autoRenew = false;
        objData.erpSwitch = false;
        objData.frmSwitch = false;
        objData.graduationDate = 'Invalid Date';
        objData.hasBooks = false;
        objData.isErpChecked = false;
        objData.isFbrChecked = false;
        objData.isFrmChecked = false;
        objData.isIcbrChecked = false;
        objData.isStudentChecked = false;
        objData.productcode = new List<String>(); 
        TempAccount.productDefinition productDefition = new TempAccount.productDefinition();
        productDefition.GLCode = '4999';
        productDefition.ProductCode = 'AFREE';
        objData.productcode1 = new TempAccount.productDefinition[]{ productDefition };   
        objData.siteName = 'undefined';
        objData.isWorking = false;
        objData.jobTarget = false;       
        objData.referral = '';
        objData.sameShip = 'true';
        objData.switchFeeEnabled = false;
        objData.eppHelp = false;
        return objData;
    }
    
    public static List<String> COUNTRIES = new List<String> {
         'Afghanistan'
        ,'Åland Islands'
        ,'Albania'
        ,'Algeria'
        ,'American Samoa'
        ,'Andorra'
        ,'Angola'
        ,'Anguilla'
        ,'Antarctica'
        ,'Antigua and Barbuda'
        ,'Argentina'
        ,'Armenia'
        ,'Aruba'
        ,'Australia'
        ,'Austria'
        ,'Azerbaijan'
        ,'Bahamas'
        ,'Bahrain'
        ,'Bangladesh'
        ,'Barbados'
        ,'Belarus'
        ,'Belgium'
        ,'Belize'
        ,'Benin'
        ,'Bermuda'
        ,'Bhutan'
        ,'Bolivia'
        ,'Bonaire'
        ,'Bosnia and Herzegovina'
        ,'Botswana'
        ,'Bouvet Island'
        ,'Brazil'
        ,'British Indian Ocean Territory'
        ,'British Virgin Islands'
        ,'Brunei'
        ,'Bulgaria'
        ,'Burkina Faso'
        ,'Burundi'
        ,'Cambodia'
        ,'Cameroon'
        ,'Canada'
        ,'Cape Verde'
        ,'Cayman Islands'
        ,'Central African Republic'
        ,'Chad'
        ,'Chile'
        ,'China'
        ,'Christmas Island'
        ,'Cocos (Keeling) Islands'
        ,'Colombia'
        ,'Comoros'
        ,'Republic of the Congo'
        ,'Democratic Republic of the Congo'
        ,'Cook Islands'
        ,'Costa Rica'
        ,'Côte d\'Ivoire'
        ,'Croatia'
        ,'Cuba'
        ,'Curaçao'
        ,'Cyprus'
        ,'Czech Republic'
        ,'Denmark'
        ,'Djibouti'
        ,'Dominica'
        ,'Dominican Republic'
        ,'Ecuador'
        ,'Egypt'
        ,'El Salvador'
        ,'Equatorial Guinea'
        ,'Eritrea'
        ,'Estonia'
        ,'Ethiopia'
        ,'Falkland Islands'
        ,'Faroe Islands'
        ,'Fiji'
        ,'Finland'
        ,'France'
        ,'French Guiana'
        ,'French Polynesia'
        ,'French Southern and Antarctic Lands'
        ,'Gabon'
        ,'Gambia'
        ,'Georgia'
        ,'Germany'
        ,'Ghana'
        ,'Gibraltar'
        ,'Greece'
        ,'Greenland'
        ,'Grenada'
        ,'Guadeloupe'
        ,'Guam'
        ,'Guatemala'
        ,'Guernsey'
        ,'Guinea'
        ,'Guinea-Bissau'
        ,'Guyana'
        ,'Haiti'
        ,'Heard Island and McDonald Islands'
        ,'Vatican City'
        ,'Honduras'
        ,'Hong Kong'
        ,'Hungary'
        ,'Iceland'
        ,'India'
        ,'Indonesia'
        ,'Iran'
        ,'Iraq'
        ,'Ireland'
        ,'Isle of Man'
        ,'Israel'
        ,'Italy'
        ,'Jamaica'
        ,'Japan'
        ,'Jersey'
        ,'Jordan'
        ,'Kazakhstan'
        ,'Kenya'
        ,'Kiribati'
        ,'Kuwait'
        ,'Kyrgyzstan'
        ,'Laos'
        ,'Latvia'
        ,'Lebanon'
        ,'Lesotho'
        ,'Liberia'
        ,'Libya'
        ,'Liechtenstein'
        ,'Lithuania'
        ,'Luxembourg'
        ,'Macau'
        ,'Macedonia'
        ,'Madagascar'
        ,'Malawi'
        ,'Malaysia'
        ,'Maldives'
        ,'Mali'
        ,'Malta'
        ,'Marshall Islands'
        ,'Martinique'
        ,'Mauritania'
        ,'Mauritius'
        ,'Mayotte'
        ,'Mexico'
        ,'Micronesia'
        ,'Moldova'
        ,'Monaco'
        ,'Mongolia'
        ,'Montenegro'
        ,'Montserrat'
        ,'Morocco'
        ,'Mozambique'
        ,'Myanmar'
        ,'Namibia'
        ,'Nauru'
        ,'Nepal'
        ,'Netherlands'
        ,'New Caledonia'
        ,'New Zealand'
        ,'Nicaragua'
        ,'Niger'
        ,'Nigeria'
        ,'Niue'
        ,'Norfolk Island'
        ,'North Korea'
        ,'Northern Mariana Islands'
        ,'Norway'
        ,'Oman'
        ,'Pakistan'
        ,'Palau'
        ,'Palestine'
        ,'Panama'
        ,'Papua New Guinea'
        ,'Paraguay'
        ,'Peru'
        ,'Philippines'
        ,'Pitcairn Islands'
        ,'Poland'
        ,'Portugal'
        ,'Puerto Rico'
        ,'Qatar'
        ,'Republic of Kosovo'
        ,'Réunion'
        ,'Romania'
        ,'Russia'
        ,'Rwanda'
        ,'Saint Barthélemy'
        ,'Saint Helena'
        ,'Saint Kitts and Nevis'
        ,'Saint Lucia'
        ,'Saint Martin'
        ,'Saint Pierre and Miquelon'
        ,'Saint Vincent and the Grenadines'
        ,'Samoa'
        ,'San Marino'
        ,'São Tomé and Príncipe'
        ,'Saudi Arabia'
        ,'Senegal'
        ,'Serbia'
        ,'Seychelles'
        ,'Sierra Leone'
        ,'Singapore'
        ,'Sint Maarten'
        ,'Slovakia'
        ,'Slovenia'
        ,'Solomon Islands'
        ,'Somalia'
        ,'South Africa'
        ,'South Georgia'
        ,'South Korea'
        ,'South Sudan'
        ,'Spain'
        ,'Sri Lanka'
        ,'Sudan'
        ,'Suriname'
        ,'Svalbard and Jan Mayen'
        ,'Swaziland'
        ,'Sweden'
        ,'Switzerland'
        ,'Syria'
        ,'Taiwan'
        ,'Tajikistan'
        ,'Tanzania'
        ,'Thailand'
        ,'Timor-Leste'
        ,'Togo'
        ,'Tokelau'
        ,'Tonga'
        ,'Trinidad and Tobago'
        ,'Tunisia'
        ,'Turkey'
        ,'Turkmenistan'
        ,'Turks and Caicos Islands'
        ,'Tuvalu'
        ,'Uganda'
        ,'Ukraine'
        ,'United Arab Emirates'
        ,'United Kingdom'
        ,'United States '
        ,'United States Minor Outlying Islands'
        ,'United States Virgin Islands'
        ,'Uruguay'
        ,'Uzbekistan'
        ,'Vanuatu'
        ,'Venezuela'
        ,'Vietnam'
        ,'Wallis and Futuna'
        ,'Western Sahara'
        ,'Yemen'
        ,'Zambia'
        ,'Zimbabwe'
    };  
    public static List<String> JOBFUNCTIONS = new List<String> {
         'Accountant'
        ,'Analyst'
        ,'Auditor'
        ,'Banker'
        ,'Consultant'
        ,'Developer'
        ,'Engineer'
        ,'Manager'
        ,'Researcher'
        ,'Trader'
        ,'Trainer/Instructor'
        ,'Other'
    };   
    public static List<String> INDUSTRIES = new List<String> {
        'Accounting'
        ,'Analytics'
        ,'Asset Liability Management'
        ,'Audit'
        ,'Commodities Risk'
        ,'Consulting'
        ,'Corporate Finance'
        ,'Corporate Risk Management'
        ,'Credit Risk'
        ,'Derivatives'
        ,'Derivatives Risk'
        ,'Economics'
        ,'Education/Training'
        ,'Emerging Markets Risk'
        ,'Energy Risk'
        ,'Equities Risk'
        ,'Finance/Banking'
        ,'Financial Administration'
        ,'Financial Control'
        ,'Financial Engineering'
        ,'Financial Services'
        ,'Firm-Wide Risk Management'
        ,'Fixed Income Risk'
        ,'Foreign Exchange Risk'
        ,'General Management'
        ,'Insurance Risk'
        ,'International Finance'
        ,'Investment Banking'
        ,'Investment Management'
        ,'Legal/Compliance'
        ,'Market Risk'
        ,'Model Risk'
        ,'Operational Risk'
        ,'Operations'
        ,'Regulation'
        ,'Research'
        ,'Risk Management'
        ,'Sales/Trading'
        ,'Structured Products'
        ,'Technology'
        ,'Accounting'
        ,'Asset Management'
        ,'Audit'
        ,'Capital Markets'
        ,'Commodities'
        ,'Compliance'
        ,'Consulting'
        ,'Corporate Banking'
        ,'Credit Risk'
        ,'Derivatives'
        ,'Energy'
        ,'Finance'
        ,'Fixed Income'
        ,'Investment Banking'
        ,'Investment Management'
        ,'IT'
        ,'Management'
        ,'Market risk'
        ,'Operational Risk'
        ,'Operations'
        ,'Retail Banking'
        ,'Research'
        ,'Risk Management'
        ,'Trading'
        ,'Training'
        ,'Treasury'
        ,'Wealth Management'
        ,'Other'
    };
}