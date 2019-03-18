public without sharing class SiteQuoteApprovalController {
// ---------------------------------------------------------------------------
// SiteQuoteApproval controller for PaymentConnect
// Copyright: Linvio, Inc.
// URL: www.linvio.com
// Last Update: 01/11/2013 
// ---------------------------------------------------------------------------

 
    private AccessControllerWithoutSharing acwos; //Error: Compile Error: Invalid type: AccessControllerWithoutSharing at line 3 column 14  

    
    // Parameters
    public String cancelURL {get;set;}
    public String finishURL {get;set;}
    public String contactId {get;set;} 
    public String accountId {get;set;} 
    public String oppId {get;set;}
    
    public Boolean debug {get;set;} 
    public Boolean enableBillingInfoEdit {get;set;}
    public Boolean requireSignatory {get;set;}  // controls whether or not "Accept Terms" options are displayed
    public String signature {get;set;}
    public String lang {get;set;}
    
    private OpportunityLineItem[] lineItems;
    public Opportunity opportunity {get;set;}
    public Contact contact {get;set;}
    public Contact updatedContact {get;set;}
    public Account account {get;set;}
    public pymt__PaymentX__c payment {get;set;}
    public pymt__Payment_Profile__c paymentProfile {get;set;}
    public pymt__Processor_Connection__c processor {get;set;}
    public String processorName {get;set;}
    
    public Boolean isMultiCurrencyOrg {get;set;}
    public String oppCurrencyIsoCode {get;set;}
    public String currencySymbol {get;set;}
	public String currencyShortFormatExpression {get;set;}
	public String currencyFormatExpression {get;set;}
    
    public Boolean disableForm {get;set;}
    public Boolean hasRecurringAmount {get;set;}
    public Boolean termsAccepted {get;set;}
    public String recurringSetup {get;set;}
    
    public String shipToName {get;set;}
    public String shipToStreet {get;set;}
    public String shipToCity {get;set;}
    public String shipToState {get;set;}
    public String shipToPostalCode {get;set;}
    public String shipToCountry {get;set;}
    public String shipToCompany {get;set;}
    public String shipToPhone {get;set;}
    
    public Decimal discount {get;set;}
    public Decimal subtotal {get;set;}
    public Decimal tax {get;set;}
    public Decimal shipping {get;set;}
    public Decimal total {get;set;}
    
    private String accessKey = pymt.PaymentX.generateAccessKey();
    
	public quot__QI_Settings__c settings = quot__QI_Settings__c.getOrgDefaults();    
    
    // this handles the exception errors 
    public class LocalException extends Exception {
        String privateErrorMsg = '';
        String publicErrorMsg = '';
        public String getPrivateMessage() {
            return this.privateErrorMsg;
        }
        public LocalException( String publicMsg, String privateMsg) {
            this.setMessage(publicMsg);
            this.privateErrorMsg = privateMsg;
        }
    }

    // this method parses the URL
    public String returnURL {
        get {
            returnURL = ApexPages.currentPage().getHeaders().get('Referer');
            if (returnURL <> null && returnURL.contains('?')) {
                    returnURL = returnURL.split('\\?')[0]; // this method splits the string on ? 
            } else {
                String host = Site.getCurrentSiteURL();//Compile Error: Method was removed after version 29.0: getCurrentSiteUrl at line 78 column 31   

                if (host <> null && host.length() > 0) {
                    String pageName = '';
                    String[] urlParts = ApexPages.currentPage().getUrl().split('/');
                    if (urlParts.size()>0) {
                        pageName = urlParts[urlParts.size()-1].split('\\?')[0];  // drop off any parameters (e.g. relayscript?relay_script_test=1)
                    } 
                    returnURL = host+ pageName;
                } 
                
            }
            return returnURL;
        }
        set; 
    
    }
    
    public SiteQuoteApprovalController() {
        if (this.settings == null) this.settings = new quot__QI_Settings__c();

        this.oppId = ApexPages.currentPage().getParameters().get('id');

        this.lang = pymt.Util.assignIfNotEmpty(ApexPages.currentPage().getParameters().get('lang'),this.lang);
        if (isNullOrEmpty(this.lang)) {
            ApexPages.currentPage().getParameters().put('lang', UserInfo.getLocale());
        }
        
        this.termsAccepted = false;
        this.requireSignatory = true;  // set to false to disable options for accepting terms and conditions
        this.signature = '';
        this.hasRecurringAmount = false;
        this.isMultiCurrencyOrg = UserInfo.isMultiCurrencyOrganization();        
        
        this.debug = !isNullOrEmpty(ApexPages.currentPage().getParameters().get('debug'));
        this.enableBillingInfoEdit = false; // Initially hide billing info editor fields
        
        this.acwos = new AccessControllerWithoutSharing(); 
        
                   
        try {
            if (this.oppId == null || this.oppId == '') {
                throw new LocalException('Sorry, your quote could not be found.', 'Quote record Id is null or empty');
            }          
            
            
            this.contactId = ApexPages.currentPage().getParameters().get('cid');     // contact id
            this.contactId = pymt.Util.isValidSalesforceId(this.contactId)?this.contactId:null;  // Make sure parm is a valid SF Id
            this.accountId = ApexPages.currentPage().getParameters().get('aid');     // account id
            this.accountId = pymt.Util.isValidSalesforceId(this.accountId)?this.accountId:null;  // Make sure parm is a valid SF Id

            //this.cancelURL = ApexPages.currentPage().getURL();  //  << doesn't return the full path

            this.cancelURL = this.returnURL+'?id='+this.oppId;
            this.finishURL = '';  // may want to set this to the company home page
            
            String soql = 'Select id, name, amount, pymt__paid_off__c, owner.firstname, owner.lastname, '+
                                'description, account.name, account.billingstreet, account.billingcity, '+
                                'account.billingpostalcode, account.billingstate, account.billingcountry,  '+
                                'account.shippingstreet, account.shippingcity, '+
                                'account.shippingpostalcode, account.shippingstate, account.shippingcountry, '+ 
                                'HasOpportunityLineItem, pymt__recurring_amount__c, '+ 
                                'pymt__frequency__c, pymt__occurrences__c, pymt__period__c,  pymt__SiteQuote_Expiration__c, '+
                                'Quote_Number__c, Quote_Version__c, pymt__Invoice_Number__c, pymt__SiteQuote_Recurring_Setup__c, '+
                                'quot__Terms_and_Conditions__c, quot__Terms_and_Conditions_RT__c, '+
                                'pymt__Tax__c, pymt__Shipping__c, pymt__Total_Amount__c, '+ (isMultiCurrencyOrg?' CurrencyIsoCode, ':'') +
                                '(Select ContactId, Role, IsPrimary From OpportunityContactRoles where IsPrimary = true) '+
                                ' from Opportunity where Publish_As_Quote__c = true and id = \''+ String.escapeSingleQuotes(this.oppId)+ '\'';
            Opportunity[] opps = this.acwos.dbQuery(soql);
            if (opps.size() >0 ) {
                this.opportunity = opps[0];  // replace current opp with queries opp (to ensure all required fields have been loaded)
                // If contactId is provided as a parameter, use it, otherwise try to use the id of the primary opportunity contact
                if (isNullOrEmpty(this.contactId) && this.opportunity.opportunitycontactroles <> null && this.opportunity.opportunitycontactroles.size()>0) {
                    this.contactId = this.opportunity.opportunitycontactroles[0].ContactId;
                } 
                if (!isNullOrEmpty(this.contactId)) {
                    soql = 'Select id, accountId, name, firstname, lastname, mailingstreet, mailingcity, mailingpostalcode, mailingstate, mailingcountry, '+
                            'email from Contact where id = \''+ String.escapeSingleQuotes(this.contactId)+'\'';
                    Contact[] contacts = this.acwos.dbQuery(soql);
                    if (contacts == null || contacts.size() ==0)  {
                        throw new LocalException('Quote configuration error - contact not assigned.','Unable to find primary opportunity contact.');
                    }      
                    this.contact = contacts[0];  
                    this.updatedContact = this.contact.clone(false,true); // clone: clear id, deep clone      
                }
                // If account is provided as a parameter, use it, otherwise try to use the account from the opportunity record
                if (isNullOrEmpty(this.accountId)) {
                    this.accountId = this.opportunity.AccountId;
                } 
                if (isNullOrEmpty(this.accountId)) {
                    this.accountId = this.contact.AccountId;
                } 
                if (!isNullOrEmpty(this.accountId)) {
                    soql = 'Select id, name, billingstreet, billingcity, billingpostalcode, billingstate, billingcountry from Account where id = \''+ String.escapeSingleQuotes(this.accountId)+'\'';
                    Account[] accts = this.acwos.dbQuery(soql);
                    if (accts.size()>0) {
                        this.account = accts[0];
                    }
                }
                if (this.account <> null) {
                	this.shipToName = this.contact.firstname + ' '+ this.contact.lastname;
                	this.shipToStreet = this.account.billingstreet;
                	this.shipToCity = this.account.billingcity;
                	this.shipToState = this.account.billingstate;
                	this.shipToPostalCode = this.account.billingpostalcode;
                	this.shipToCountry = this.account.billingcountry;
                	//this.shipToPhone = this.account.phone;
                	this.shipToCompany = this.account.name;
                	
                }
                this.subtotal = this.opportunity.amount;
                this.discount = 0;
                this.tax = this.opportunity.pymt__Tax__c;
                this.shipping = this.opportunity.pymt__Shipping__c;
                this.total = this.opportunity.pymt__Total_Amount__c;
                
                Map<String,String> recurringSetupOptions = new Map<String,String>{
                                    'Recurring Payments = Total Amount'=>'Installment',
                                    'Total Amount + Recurring Payments'=>'RecurringTackedOn',
                                    'Total Amount Includes First Recurring Payment'=>'FirstRecurringIncluded'};
                this.recurringSetup = recurringSetupOptions.get(this.opportunity.pymt__SiteQuote_Recurring_Setup__c);
                if (this.recurringSetup == 'Installment' ) {
                    if (this.opportunity.pymt__Occurrences__c == null) throw new LocalException('Quote configuration error.  Installment payments must have a fixed number of occurrences.');                       
                    if (this.opportunity.pymt__Recurring_Amount__c == null 
                        || this.opportunity.pymt__Occurrences__c == 0 
                        || this.opportunity.pymt__Recurring_Amount__c == 0 
                        || Math.abs(this.opportunity.pymt__Recurring_Amount__c * this.opportunity.pymt__Occurrences__c 
                                - this.total) > 0.01 * this.opportunity.pymt__Occurrences__c) { // account for possible rounding errors
                            throw new LocalException('Quote configuration error.  Installment payments do not equal the total amount.');
                        }
                }
                if (this.recurringSetup == 'FirstRecurringIncluded' && 
                    this.total < this.opportunity.pymt__recurring_amount__c) {
                      throw new LocalException('Quote configuration error.  Total amount must be greater than or equal to the first recurring payment amount when '+
                                'including first recurring payment in total.');                         
                        
                }                    
            } else {
                throw new LocalException('Sorry, your quote could not be found or has not been published yet.', 'Quote record could not be located.');
            }
                
            
            if (this.opportunity.pymt__Recurring_Amount__c != null && this.opportunity.pymt__Recurring_Amount__c > 0 && this.opportunity.pymt__Frequency__c != null &&
                this.opportunity.pymt__Frequency__c > 0 && !isNullOrEmpty(this.opportunity.pymt__Period__c) && this.recurringSetup <> null) {
                    this.hasRecurringAmount = true;
                }
            if (this.opportunity.pymt__paid_off__c) throw new LocalException('This order has already been processed.');
            
            if (this.opportunity.pymt__sitequote_expiration__c <> null && this.opportunity.pymt__sitequote_expiration__c < Date.today()) {
                throw new LocalException('This quote has expired.');
            }
            
            if (this.contact == null) {
                throw new LocalException('Quote configuration error - contact not assigned', 'Cannot process quote without a contact record.  Please add a primary opportunity contact to the opportunity record.'); 
            }
            if (this.account == null) {
                throw new LocalException('Quote configuration error - account not assigned', 'Cannot process quote without an account record.  Please add an account to the opportunity record.'); 
            }
            
            // Retrieve default processor connection record

            Set<String> supportRecurring = new Set<String>{'Authorize.Net', 'PayPal', 'WorldPay'};
            Set<String> supported = new Set<String>{'Authorize.Net', 'PayPal', 'WorldPay', 'Google','eWay'};
            String connectionId = pymt.PaymentX.getSiteDefaultProcessorConnection(Site.getName());
			if (connectionId <> null) {
            this.processor = [Select id, pymt__default_connection__c, pymt__processor_id__c, pymt__test_mode__c, pymt__Default_Currency__c,  
                    				pymt__PP_Merchant_Id__c from pymt__Processor_Connection__c where isDeleted = false and id = :connectionId
                    			];
			}
            if (this.processor <> null ) {

                this.processorName = this.processor.pymt__processor_id__c;
                this.oppCurrencyIsoCode = this.processor.pymt__Default_Currency__c;
                if (isMultiCurrencyOrg) {
                	this.oppCurrencyIsoCode = (String)this.opportunity.get('CurrencyIsoCode');  // override processor connection default currency value using multicurrency iso code on opp (if present).
                }                    
            	this.currencySymbol = Pymt.Util.currencySymbol(this.oppCurrencyIsoCode);
                this.currencyShortFormatExpression = Pymt.Util.getShortCurrencyFormatExpression(Site.getName(),this.oppCurrencyIsoCode);                  	   
                this.currencyFormatExpression = Pymt.Util.getCurrencyFormatExpression(Site.getName(),this.oppCurrencyIsoCode);  					

                // See if the processor supports the type of payment required on this page
                if (!supported.contains(this.processor.pymt__Processor_Id__c) || 
                    (this.hasRecurringAmount && !supportRecurring.contains(this.processor.pymt__Processor_Id__c))) {
                    throw new LocalException('Configuration Error.', 'The processor connection '+ this.processorName + ' cannot be used for this quote.');              
                }
            } else {
                throw new LocalException('Configuration Error.', 'Could not find a processor connection to use for this quote.  Please check your settings.'); 
            }     
            
            getLineItems();

        
        } Catch (LocalException lex) {
            System.debug('An error encountered loading the SiteQuote page: '+lex);
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, (this.debug?lex.getPrivateMessage():lex.getMessage())));
            this.disableForm = true;                            
        } Catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error loading page.'+ ex.getMessage()));
            this.disableForm = true;
        }        
    
    }
    
    public PageReference changeBillingInformation() {
        this.enableBillingInfoEdit = true;
        return null;
    }
    
    

    // Applications my have to twice encode fully qualified URLs to get around a bug in visualforce url parsing
    // Check to see if these urls have been twice encoded  ("%3A%2F%2F" = "://")
    private String specialDecodeURLParm(String parm) {
        String result = isNullOrEmpty(parm)?'':EncodingUtil.UrlDecode(parm,'UTF-8');                                      
        if (result.contains('%3A%2F%2F')) result = Encodingutil.urlDecode(result, 'UTF-8');
        return result;
    }
    
    public OpportunityLineItem[] getLineItems() {
        if (this.lineItems == null && this.opportunity <> null && this.opportunity.HasOpportunityLineItem ) {
            this.lineItems = [Select UnitPrice, TotalPrice, SystemModstamp, SortOrder, ServiceDate, Quantity, PricebookEntryId, PricebookEntry.Name,
                pricebookentry.product2.pymt__on_Payment_Completed__c, pricebookentry.productcode,
                pricebookentry.product2.pymt__Taxable__c,
                pricebookentry.product2.pymt__Tangible__c,
                OpportunityId, ListPrice, LastModifiedDate, LastModifiedById, IsDeleted, Id, Description, CreatedDate, CreatedById 
            From OpportunityLineItem 
            where isDeleted = false and OpportunityId = :this.opportunity.Id ORDER BY SortOrder Asc];       
        }
        return this.lineItems;
        
    }

    private Boolean isURL(String str) {
        if (isNullOrEmpty(str)) return false;
        if (str.contains('https:') || str.contains('http:')) return true;
        return false;
    }
    
    private Boolean isNullOrEmpty(String astring) {
        if (astring == null) return true;
        if (astring.trim()=='') return true;
        return false;
    }

    public PageReference cancelTransaction() {
        PageReference cancelPage = null;
        if (!isNullOrEmpty(this.cancelURL)) {
            cancelPage = new PageReference(this.cancelURL);
        }
        return cancelPage;
    
    }
    
    public PageReference finishTransaction() {
        PageReference finishPage = null;
        if (!isNullOrEmpty(this.finishURL)) {
            finishPage = new PageReference(this.finishURL);
        }
        return finishPage;
    
    }   
    // Creates a Recurring Payment Profile record to be passed to the checkout page.
    public pymt__Payment_Profile__c setupRecurringPaymentProfile() {
        String recordTypeId;
            
        try {               
            if (this.paymentProfile == null) {
                this.paymentProfile = new pymt__Payment_Profile__c();
                this.paymentProfile.pymt__Contact__c = this.contactId;
                this.paymentProfile.pymt__Opportunity__c = this.opportunity.Id;
                this.paymentProfile.pymt__Account__c = this.account.Id;
            }
            String period;          
            Double frequency = 1;
            Double recurringAmount = this.opportunity.pymt__Recurring_Amount__c;
            Double occurrences = this.opportunity.pymt__Occurrences__c;
            if (this.processor.pymt__processor_id__c.equalsIgnoreCase('PayPal')){
                // Retrieve PayPal recurring payment record type to store in payment profile
                recordTypeId = [Select id from RecordType where developername like 'PayPal_Recurring_Payment'].id;
                if (this.recurringSetup == 'FirstRecurringIncluded') {
                    this.paymentProfile.pymt__Initial_Amount__c = this.total - recurringAmount;
                } else if (this.recurringSetup == 'RecurringTackedOn') {
                    this.paymentProfile.pymt__Initial_Amount__c = this.total;   
                }
                frequency = this.opportunity.pymt__Frequency__c;
                period = this.opportunity.pymt__Period__c;
                

            } else if (this.processor.pymt__processor_id__c.equalsIgnoreCase('authorize.net')){
                // Retrieve PayPal recurring payment record type to store in payment profile

                recordTypeId = [Select id from RecordType where developername like 'AuthNet_Subscription'].id;
                if (this.recurringSetup == 'FirstRecurringIncluded' || this.recurringSetup == 'RecurringTackedOn') {
                    this.paymentProfile.pymt__Trial_Amount__c = this.total;
                    this.paymentProfile.pymt__Trial_Occurrences__c = 1;
                } 
                if (this.recurringSetup == 'FirstRecurringIncluded') {
                    occurrences = occurrences == null?null:occurrences -1;   

                }               
                if (this.opportunity.pymt__Period__c.equalsIgnoreCase('Day')) {period = 'Day'; frequency = this.opportunity.pymt__Frequency__c;}
                if (this.opportunity.pymt__Period__c.equalsIgnoreCase('Week')) { period = 'Day'; frequency = this.opportunity.pymt__Frequency__c * 7;}
                if (this.opportunity.pymt__Period__c.equalsIgnoreCase('Semi/Month')) { period = 'Day'; frequency = this.opportunity.pymt__Frequency__c * 15;} // approximate of every half month as authnet doesn't offer semi-monthly option
                if (this.opportunity.pymt__Period__c.equalsIgnoreCase('Month')) {period = 'Month';frequency = this.opportunity.pymt__Frequency__c; }
                if (this.opportunity.pymt__Period__c.equalsIgnoreCase('Year')) { period = 'Month'; frequency = this.opportunity.pymt__Frequency__c * 12;}
                            
            } else if (this.processor.pymt__processor_id__c.equalsIgnoreCase('worldpay')){
                // Retrieve worldpay recurring payment record type to store in payment profile

                recordTypeId = [Select id from RecordType where developername like 'WorldPay_Recurring_Payment'].id;
                if (this.recurringSetup == 'FirstRecurringIncluded') {
                    this.paymentProfile.pymt__Initial_Amount__c = this.opportunity.pymt__total_amount__c;
                    occurrences = occurrences == null?null:occurrences -1;  

                }  else if (this.recurringSetup == 'RecurringTackedOn') {
                    this.paymentProfile.pymt__Initial_Amount__c = this.opportunity.pymt__total_amount__c;
                }
                if (this.opportunity.pymt__Period__c.equalsIgnoreCase('Day')) {period = 'Day'; frequency = this.opportunity.pymt__Frequency__c;}
                if (this.opportunity.pymt__Period__c.equalsIgnoreCase('Week')) { period = 'Week'; frequency = this.opportunity.pymt__Frequency__c * 1;}
                if (this.opportunity.pymt__Period__c.equalsIgnoreCase('Semi/Month')) { period = 'Day'; frequency = this.opportunity.pymt__Frequency__c * 15;} // approximate of every half month as authnet doesn't offer semi-monthly option
                if (this.opportunity.pymt__Period__c.equalsIgnoreCase('Month')) {period = 'Month';frequency = this.opportunity.pymt__Frequency__c; }
                if (this.opportunity.pymt__Period__c.equalsIgnoreCase('Year')) { period = 'Year'; frequency = this.opportunity.pymt__Frequency__c * 1;}

             } else {
                // recurring payments for this processor type not yet supported.
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Current default payment processor not supported for recurring payments ('+this.processorName+').'));
                return null;                
            }

            this.paymentProfile.name = this.opportunity.Name;
            this.paymentProfile.recordTypeId = recordTypeId;
            this.paymentProfile.pymt__Key__c = this.accessKey;
            this.paymentProfile.pymt__Processor_Connection__c = this.processor.Id;
            this.paymentProfile.pymt__Subscription_Start_Date__c = Date.today();
            this.paymentProfile.pymt__Subscription_Status__c = 'Not Activated';  // temporary status used until subscription has been activated
            this.paymentProfile.pymt__Period__c = period;
            this.paymentProfile.pymt__Frequency__c = frequency;
            this.paymentProfile.pymt__Amount__c = recurringAmount;  
            this.paymentProfile.pymt__Total_Occurrences__c = this.opportunity.pymt__Occurrences__c;       

            this.paymentProfile.pymt__Ship_To_Name__c = this.shipToName;
			this.paymentProfile.pymt__Ship_To_Street__c = this.shipToStreet;
			this.paymentProfile.pymt__Ship_To_City__c = this.shipToCity;
			this.paymentProfile.pymt__Ship_To_State__c = this.shipToState;
			this.paymentProfile.pymt__Ship_To_Postal_Code__c = this.shipToPostalCode;
			this.paymentProfile.pymt__Ship_To_Country__c = this.shipToCountry;
			this.paymentProfile.pymt__Ship_To_Phone__c = this.shipToPhone;
			this.paymentProfile.pymt__Ship_To_Company__c = this.shipToCompany;
            
            if (this.paymentProfile.Id == null) {
	            this.acwos.dbInsert(this.paymentProfile);
            } else {
    	        this.acwos.dbUpdate(this.paymentProfile);            	
            }
            return this.paymentProfile;
            
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error setting up payment profile: '+ex.getMessage()));

            return null;
        }
    }
    
    
    public Boolean setupPaymentRecord() {        
            
            // Setup Payment record
            if (this.payment == null) {
                this.payment = new pymt__PaymentX__c();
            }
            try {
                this.payment.name = pymt.Util.assignIfNotEmpty(this.opportunity.name,'Payment');
                this.payment.pymt__amount__c = this.total;
                this.payment.pymt__key__c = this.accessKey;
                this.payment.pymt__tax__c = this.tax;
                this.payment.pymt__shipping__c = this.shipping;
                this.payment.pymt__discount__c = (this.discount <> null && this.discount >0)?(this.discount * -1):this.discount;
                this.payment.pymt__contact__c = this.contactId;
                this.payment.pymt__status__c = 'In Process';
                this.payment.pymt__date__c = System.today();
                this.payment.pymt__Currency_ISO_Code__c = this.oppCurrencyIsoCode;
                this.payment.pymt__payment_processor__c = this.processor.pymt__processor_id__c;
                this.payment.pymt__processor_connection__c = this.processor.id;
                this.payment.pymt__opportunity__c = this.opportunity.id;  
                this.payment.pymt__account__c = this.account.id;   
                this.payment.pymt__Is_Test_Transaction__c = this.processor.pymt__Test_Mode__c;
                this.payment.pymt__log__c = ' ++++ Payment on Opportunity Sales Quote:\n'+ 'Online payment for '+
                                          this.payment.pymt__Amount__c + this.oppCurrencyIsoCode;
    			this.payment.pymt__Ship_To_Name__c = this.shipToName;
    			this.payment.pymt__Ship_To_Street__c = this.shipToStreet;
    			this.payment.pymt__Ship_To_City__c = this.shipToCity;
    			this.payment.pymt__Ship_To_State__c = this.shipToState;
    			this.payment.pymt__Ship_To_Postal_Code__c = this.shipToPostalCode;
    			this.payment.pymt__Ship_To_Country__c = this.shipToCountry;
    			this.payment.pymt__Ship_To_Phone__c = this.shipToPhone;
    			this.payment.pymt__Ship_To_Company__c = this.shipToCompany;
    
                if (this.payment.id == null) {
                    insert this.payment; 
                } else {
                    update this.payment;
                }
            
                // Insert/update related shopping cart items        
                pymt__Shopping_Cart_Item__c[] itemsToInsert = new pymt__Shopping_Cart_Item__c[]{};
                if (this.lineItems <> null) {
                    for (OpportunityLineItem lineItem :this.lineItems) {                 
                        itemsToInsert.add(new pymt__Shopping_Cart_Item__c(name = pymt.Util.firstN(lineItem.pricebookentry.name,80),
                                                                            pymt__quantity__c = lineItem.quantity,
                                                                            pymt__unit_price__c = lineItem.unitprice,
                                                                            pymt__contact__c = this.contact.id,
                                                                            pymt__product__c = lineItem.pricebookentry.product2id,
                                                                            pymt__product_code__c = lineItem.pricebookentry.productcode,
                                                                            pymt__payment__c = this.payment.id,
                                                                            pymt__Taxable__c = lineItem.pricebookentry.product2.pymt__Taxable__c,
                                                                            pymt__Tangible__c = lineItem.pricebookentry.product2.pymt__Tangible__c,
                                                                            pymt__On_Payment_Completed__c = lineItem.pricebookentry.product2.pymt__on_Payment_Completed__c
                                                                        )
                                            );
                    
                    }
                    if (itemsToInsert.size()>0) insert itemsToInsert;
                }
            } catch (Exception ex) {
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Error setting up purchase records:' + ex.getMessage()));                           
                return false;
                
                
            }
        
        return true;        
        
    }
    
    // Returns IP address of current user.
    public String getCurrentIPAddress(){
        string ipAddress;
        if (isNullOrEmpty(ipAddress)){
            ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
            if (isNullOrEmpty(ipAddress)) ipAddress='255.255.255.0';
        }
        return ipAddress;
    }   
    
    // Set up payment or payment profile records and redirect to checkout page
    public PageReference processQuote() {
        PageReference nextPage;      

        // If billing contact info changed, upsert contact 
        if (this.enableBillingInfoEdit) {
            if (pymt.Util.isNullOrEmpty(this.updatedContact.email)) {
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please provide the billing contact email address.'));                           
                return null;
            }
            Boolean isUpdate = false;
            // Determine whether we are updating an existing contact or creating a new one
            Contact tempContact;
            if (this.updatedContact.email == this.contact.email &&  !pymt.Util.isNullOrEmpty(this.contact.email)) {
                // email matches, update current contact
                isUpdate = true;
                tempContact = new Contact(id = this.contact.id);
                tempContact.accountId = this.contact.accountId;
            } else {
                // new email address, upsert this contact
                Contact[] existing = [Select id, accountId, name, firstname, lastname, email, mailingstreet, mailingcity, mailingstate, mailingpostalcode,
                                mailingcountry from Contact where email = :this.updatedContact.email limit 1];
                if (existing.size()>0) {
                    // contact with same email found, update this contact
                    isUpdate = true;
                    tempContact = new Contact(id = existing[0].id);
                    tempContact.accountId = existing[0].accountId;
                } else {
                    // no match in the database, insert new contact
                    isUpdate = false;
                    tempContact = new Contact();
                    tempContact.accountId = this.opportunity.accountId;
                }
            }

            tempContact.firstname = this.updatedContact.firstname;
            tempContact.lastname = this.updatedContact.lastname;
            tempContact.mailingstreet = this.updatedContact.mailingstreet;
            tempContact.mailingcity = this.updatedContact.mailingcity;
            tempContact.mailingstate = this.updatedContact.mailingstate;
            tempContact.mailingpostalcode = this.updatedContact.mailingpostalcode;
            tempContact.mailingcountry = this.updatedContact.mailingcountry;
            tempContact.email = this.updatedContact.email;
            tempContact.phone = this.updatedContact.phone;
            

            if (isUpdate) {
                this.acwos.dbUpdate(tempContact);                           
                 
            } else {
                this.acwos.dbInsert(tempContact);
            }
            this.contact = tempContact.clone(true, true);
            this.updatedContact = tempContact.clone(false, true); // false/true = don't preserve id, and make this a complete copy (non reference)
                
            
            // Also update opportunity roles to include the new contact as a primary contact
            Integer roleCount = [Select Count() From OpportunityContactRole where ContactId = :tempContact.id and OpportunityId = :this.opportunity.id];
            if (roleCount == 0) {
                // Contact is not currently an opportunity contact
                this.acwos.dbInsert(new OpportunityContactRole( ContactId = tempContact.id,
                                                                OpportunityId = this.opportunity.id,
                                                                IsPrimary = true,       
                                                                Role = 'Economic Buyer' 
                                                                ));
            }
            
        }
        
        if (this.requireSignatory && this.termsAccepted) {
            Task newTask = new Task(Subject = 'SiteQuote Terms & Conditions Accepted',
                                    Description='SiteQuote Terms & Conditions accepted by '+ this.signature + ' for '+
                                    this.opportunity.Name+' (Quote: '+this.opportunity.Quote_Number__c+', Version: '+
                                                            this.opportunity.Quote_Version__c+') from IP:'+ this.getCurrentIPAddress(), 
                                    whatId = this.opportunity.Id,
                                    whoId = this.contact.Id,
                                    status = 'Completed'
                                    
                                    );
            insert newTask;


            Opportunity opp = new Opportunity( Id = this.opportunity.Id, Quote_Approved__c = Datetime.now());
            this.acwos.dbUpdate(opp);
        }
        if (this.hasRecurringAmount) {
            // This is a recurring payment opportunity
            this.paymentProfile = setupRecurringPaymentProfile();
            if (this.paymentProfile == null) return null;               
            if (processorName.equalsIgnoreCase('paypal')) {
                nextPage = Page.pymt__SiteSubscribePRB;
            }   else if (processorName.equalsIgnoreCase('authorize.net')) {
                nextPage = Page.pymt__SiteSubscribeARB;     
            } else {            
                return null;  // processor is not supported for recurring payments
            }
            nextPage.getParameters().put('ppid',this.paymentProfile.Id);    // pass payment profile record  id to checkout page 
            nextPage.getParameters().put('key',this.accessKey);
        } else {
            // This is a single charge opportunity
            if (!setupPaymentRecord()) return null;                 
            nextPage = Page.pymt__SiteCheckout;     
            nextPage.getParameters().put('pid',this.payment.Id);  // pass payment record id to checkout page
            nextPage.getParameters().put('key',this.accessKey);
        }
        if (isNullOrEmpty(this.cancelURL)) {
            this.cancelURL = ApexPages.currentPage().getURL();
        }

        if (this.debug) nextPage.getParameters().put('debug', '1');
        if (!isNullOrEmpty(this.cancelURL)) nextPage.getParameters().put('cancel_url', EncodingUtil.urlEncode(this.cancelURL,'UTF-8'));        
        if (!isNullOrEmpty(this.finishURL)) nextPage.getParameters().put('finish_url', EncodingUtil.urlEncode(this.finishURL,'UTF-8'));        
        System.debug('Next page parameters:'+nextPage.getParameters());
        return nextPage;    
        
    }   
    
    
    public static testmethod void testSiteQuoteApprovalController() {
        
        // --------------- Set up records for test scenarios ------------------
        
        // Check to make sure settings record has been created, and PC is in Simulation Mode (to
        // prevent API callouts from being made during test method execution.
        pymt__Settings__c settings = new pymt__Settings__c();
        settings.name = 'ApexTestSettings';
        settings.pymt__Gateway_Simulation_Mode__c = true;                    
        insert settings;
        
        // Add processor connections
        pymt__Processor_Connection__c connection1 = new pymt__Processor_Connection__c(
                name = 'ApexTestProcessorConnection1',
                pymt__PaymentConnect_Setup__c = settings.id,
                pymt__Assigned_To_Terminal__c = true,
                pymt__Default_Connection__c = true,
                pymt__Processor_Id__c = 'Authorize.Net',
                pymt__Enabled_Card_Types__c = 'Visa;Mastercard',
                pymt__Authnet_Enable_Echecks__c = true);
            Database.SaveResult sr =    Database.insert(connection1);
            System.assert(sr.isSuccess(), 'Error inserting test processor connection object. '+sr);     
        pymt__Processor_Connection__c connection2 = new pymt__Processor_Connection__c(
                name = 'ApexTestProcessorConnection2',
                pymt__PaymentConnect_Setup__c = settings.id,
                pymt__Assigned_To_Terminal__c = true,
                pymt__Processor_Id__c = 'PayPal',
                pymt__Authnet_Enable_Echecks__c = false);
            sr =    Database.insert(connection2);
            System.assert(sr.isSuccess(), 'Error inserting test processor connection object: '+sr);     
                    
        System.assert( settings.Id <> null, 'Error finding/creating settings record for test methods to use.');
 
        // Retrieve a closed/won stage
        String stagename = [Select o.MasterLabel, o.IsClosed, o.IsActive From OpportunityStage o where o.IsClosed = true and o.IsWon = true limit 1].MasterLabel;
        
        String apexTestLabel = 'ApexTestSiteQuoteApprovalPageController';
        
        Account[] accounts = [Select id from Account where isDeleted = false and name = :apexTestLabel ];
        if (accounts != null && accounts.size() > 0) delete accounts;
        Account account = new Account( name = apexTestLabel, BillingState = 'CA' );
        insert account;
         
        Contact[] contacts = [Select id from Contact where isDeleted = false and lastname = :apexTestLabel];
        if (contacts != null && contacts.size() > 0) delete contacts;
        Contact contact = new Contact(firstname = 'Albert', 
                                      lastname = apexTestLabel,
                                      mailingstreet = '123 Test Street',
                                      mailingcity = 'Encinitas',
                                      mailingstate = 'CA',
                                      mailingpostalcode = '92024',
                                      mailingcountry = 'US',
                                      otherstreet = '456 Test Street',
                                      othercity = 'Encinitas',
                                      otherstate = 'CA',
                                      otherpostalcode = '92024',
                                      othercountry = 'US',
                                      accountId = account.id
                                      );
        insert contact;

        String oppName = apexTestLabel+'Opp';
        Opportunity[] opps = [Select id from Opportunity where isDeleted = false and name = :oppName];
        if (opps != null && opps.size() > 0) delete opps;
        Opportunity newOppNotInserted = new Opportunity(name = oppName,
                                            closedate = System.today(),
                                            stagename = stagename,
                                            Publish_As_Quote__c = true,
                                            amount = 450.00
                                            );
        Opportunity newOpp = new Opportunity(name = oppName,
                                            closedate = System.today(),
                                            stagename = stagename,
                                            Publish_As_Quote__c = true,
                                            amount = 450.00
                                            );
        insert newOpp;
        Opportunity newOppRecurring = new Opportunity(name = oppName+'-recurring',
                                            closedate = System.today(),
                                            pymt__sitequote_expiration__c = Date.today().addDays(30),
                                            stagename = stagename,
                                            amount = 1000,
                                            pymt__tax__c = 50,
                                            pymt__shipping__c = 150,
                                            pymt__recurring_amount__c = 100,
                                            Publish_As_Quote__c = true,
                                            pymt__frequency__c = 1,
                                            pymt__period__c = 'Month',
                                            pymt__occurrences__c = 12,
                                            pymt__SiteQuote_Recurring_Setup__c = 'Recurring Payments = Total Amount', 
                                            accountid = account.id
                                            );
        insert newOppRecurring;
         Opportunity newOppRecurring2 = newOppRecurring.clone(false, true); // don't clone Id, deep clone
         newOppRecurring2.pymt__SiteQuote_Recurring_Setup__c = 'Total Amount + Recurring Payments';
        insert newOppRecurring2;
        
        System.assert(newOpp.Id <> null,'Error creating test opportunity for SiteQuoteApprovalController');
        System.assert((newOppRecurring.Id <> null && newOppRecurring2.Id <> null),'Error creating recurring test opportunities for SiteQuoteApprovalController');
                
 
    System.debug('======>Begin Tests');
        // ------------------ Begin Tests -------------------------
        SiteQuoteApprovalController controller;  
      
        // No Opp -----------------
        // Provoke error for not specifying opportunity record id...
        controller = new SiteQuoteApprovalController();
        
        controller.specialDecodeURLParm('testing');
        controller.specialDecodeURLParm('%3A%2F%2F');
        controller.isURL('1123');
        controller.isURL('');
        controller.isURL('http://www.salesforce.com');
        String ipAddr = controller.getCurrentIPAddress();

        ApexPages.currentPage().getParameters().put('id',newOpp.Id);
        controller = new SiteQuoteApprovalController();

        // Test isNullOrEmpty() method
        System.assert(controller.isNullOrEmpty(null),'Failed to identify null as NullOrEmpty');
        System.assert(controller.isNullOrEmpty(''),'Failed to identify "" as NullOrEmpty');
        System.assert(controller.isNullOrEmpty(' '),'Failed to identify " " as NullOrEmpty');                                             
        
       
    System.debug('======>Paid Off');

        // Opportunity is already "Paid Off"
        newOpp.pymt__Paid_Off__c = true;
        update newOpp;
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('id',newOpp.Id);
        controller = new SiteQuoteApprovalController();
        System.assert(controller.disableForm == true, 'Expected form to be disabled after instantiating controller with paid opportunity');
                
    System.debug('=====> default processor connection: '+pymt.PaymentX.getSiteDefaultProcessorConnection(Site.getName()));            
    System.debug('======>Quote Expired');
                
        // Quote is expired
        newOpp.pymt__Paid_Off__c = false;  // undo flag for previous test scenario
        newOpp.pymt__SiteQuote_Expiration__c = Date.today().addDays(-1); // set expiration to yesterday
        update newOpp;
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('id',newOpp.Id);
        controller = new SiteQuoteApprovalController();
        System.assert(controller.disableForm == true, 'Expected form to be disabled after instantiating controller with expired quote');
        
        // set expiration to 1 month out
        newOpp.pymt__SiteQuote_Expiration__c = Date.today().addDays(30); 
        update newOpp;
        
    System.debug('======>No Contact');

        // No Contact
        ApexPages.currentPage().getParameters().put('id',newOpp.Id);
        controller = new SiteQuoteApprovalController();
        System.assert(controller.disableForm == true, 'Expected form to be disabled after instantiating controller without an opportunity contact');

        // Create opportunity contacts (primary)
        OpportunityContactRole oppContact = new OpportunityContactRole(isPrimary = true, opportunityId = newOpp.id, contactId = contact.id, role = 'Decision Maker');
        insert oppContact;
        oppContact = new OpportunityContactRole(isPrimary = true, opportunityId = newOppRecurring.id, contactId = contact.id, role = 'Decision Maker');
        insert oppContact;
        oppContact = new OpportunityContactRole(isPrimary = true, opportunityId = newOppRecurring2.id, contactId = contact.id, role = 'Decision Maker');
        insert oppContact;
                
        // Add account
        newOpp.AccountId = account.Id; 
        update newOpp;
        
        // Pass in all required parameters and process the quote
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('id',newOpp.Id);
        ApexPages.currentPage().getParameters().put('debug','1');
        ApexPages.currentPage().getParameters().put('cancel_url','http%253A%252F%252Fwww.amazon.com%252Fdummy.css');
        ApexPages.currentPage().getParameters().put('finish_url','http%253A%252F%252Fwww.amazon.com%252Fdummy.css');
        controller = new SiteQuoteApprovalController();
        //controller.getLineItems();
        controller.processQuote();
        controller.finishTransaction();

        // Pass in same parameters and add account id, and contact id as parameters 
        ApexPages.currentPage().getParameters().put('aid',account.Id);
        ApexPages.currentPage().getParameters().put('cid',contact.Id);
        controller = new SiteQuoteApprovalController();

    System.debug('======>Authnet recurring');
        
        // Process a quote with recurring payment terms using AuthNet
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('id',newOppRecurring.Id);
        ApexPages.currentPage().getParameters().put('debug','1');
        controller = new SiteQuoteApprovalController();
        
        // 
        controller.changeBillingInformation();
        controller.updatedContact.FirstName = 'Sam';
        controller.updatedContact.LastName = 'ApexTest';
        controller.updatedContact.email = 'sam.apextest@test.com';
        controller.updatedContact.mailingstreet = '123 Oak';
        controller.updatedContact.mailingcity = 'Encinitas';
        controller.updatedContact.mailingstate = 'CA';
        controller.updatedContact.mailingpostalcode = '92024';
        controller.updatedContact.mailingcountry = 'US';
        controller.processQuote();      

        // Process a quote with recurring payment terms (incorrect installment amount)
        ApexPages.currentPage().getParameters().clear();
        newOppRecurring.pymt__Recurring_Amount__c = 50; // incorrect amount - doesn't add up to total amount of opportunity over 12 payments
        update newOppRecurring;
        ApexPages.currentPage().getParameters().put('id',newOppRecurring.Id);
        ApexPages.currentPage().getParameters().put('debug','1');
        controller = new SiteQuoteApprovalController();
         
        
    System.debug('======>PayPal recurring');

        // Process a quote with recurring payment terms using PayPal (change the default payment processor and go again)
        connection2.pymt__Default_Connection__c = true;
        connection1.pymt__Default_Connection__c = false;
        update connection1; 
        update connection2;
        ApexPages.currentPage().getParameters().clear();
        ApexPages.currentPage().getParameters().put('id',newOppRecurring2.Id);
        ApexPages.currentPage().getParameters().put('debug','1');
        controller = new SiteQuoteApprovalController();
        controller.processQuote();      

    System.debug('======>PayPal recurring done');
        
    }
    
 
}