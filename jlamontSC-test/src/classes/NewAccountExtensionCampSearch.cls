// *************************************************************************/
// NewAccountExtensionKW Class
//      VB: This class appears to be a wrapper for the KnowWho ZDM Single 
//          Address record service.  Given a rC Account Address, it maps
//          the fields returned from the KW ZDM to the rC object.
//           
//  2015/03/30      Peter Churchill     Original
//  2015/04/06      Vernon Baas         Commenting
//  2015/06/22      Mark Maslow         Replace Country USA, US or United States with empty string
//  2016/06/20		Mark Maslow			Change in support of Duplicate Checking
//  2107/01/17      Mark Maslow         Copy Original Campaign from Account to Contacts 
// *************************************************************************/
public with sharing class NewAccountExtensionCampSearch implements CampaignSetter {

    private final Account account;
    public rC_Bios__Account_Address__c accountAddress{get;set;}
    
    public Boolean showOverride{get;set;}           // ? Display the checkbox to allow the user to override the verification?
    public Boolean isOverride{get;set;}             // This should probably be called 'non-USA Address'
    public Boolean isPrimaryEmailShow{get;set;}
    public Boolean isAddressValid {get;set;}
    public String validationSatus {get;set;}
    public Boolean contactRequired {get;set;}       // This should be called: isHouseholdAccount
    public Integer noOfContacts {get;set;}
    public list<Contact> contactList {get;set;}
    private Id houseHoldType,hhContactType,orgContactType;
    private boolean isValidContactAttached;
    public boolean isInvalidTestAddress;
    public boolean showAccountType {get;set;}
    private String sAddressState; //Store address state for final processing
    public List<Contact> dupList {get; set;}
    public List<Account> dupAccountList {get; set;}
    private Boolean dupsAccepted = false;
    private Boolean dupAccountsAccepted = false;

    //================================================================//
    //Constructor
    //================================================================//
    public NewAccountExtensionCampSearch(ApexPages.StandardController controller) {
        this.account = (Account)controller.getRecord();
        contactList = new List<contact>();
        isPrimaryEmailShow = false;
        houseHoldType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        hhContactType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        orgContactType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Organizational').getRecordTypeId();
        isAddressValid = false;
        isInvalidTestAddress = false;
        isOverride = false;
        showOverride = false;
        sAddressState = '';
    
        if(houseHoldType == account.RecordTypeId){
            showAccountType = false;
            contactRequired = true;
            noOfContacts = 1;
            accountAddress = new rC_Bios__Account_Address__c(rC_Bios__Type__c = 'Home');
            contactList.add(new Contact(rC_Bios__Preferred_Contact__c=true, Random_Number__c = Integer.valueOf(Math.random() * (100*100))));
        } else {
            accountAddress = new rC_Bios__Account_Address__c(rC_Bios__Type__c = 'Business');
            contactRequired = false;
            showAccountType = true;
        }  
    
        //Private email (to those that have edit security to this field)
        if (Schema.sObjectType.Contact.fields.Private_Email__c.isUpdateable()){
            isPrimaryEmailShow = true;
        }
        isValidContactAttached = true;
    }
    
	public List<SelectOption> getItems() {
    	List<SelectOption> options = new List<SelectOption>();
        	options.add(new SelectOption('','--None--'));
        	options.add(new SelectOption('AL','AL (Alabama)'));
			options.add(new SelectOption('AK','AK (Alaska)'));
			options.add(new SelectOption('AZ','AZ (Arizona)'));
			options.add(new SelectOption('AR','AR (Arkansas)'));
			options.add(new SelectOption('CA','CA (California)'));
			options.add(new SelectOption('CO','CO (Colorado)'));
			options.add(new SelectOption('CT','CT (Connecticut)'));
			options.add(new SelectOption('DE','DE (Delaware)'));
			options.add(new SelectOption('DC','DC (District of Columbia)'));
			options.add(new SelectOption('FL','FL (Florida)'));
			options.add(new SelectOption('GA','GA (Georgia)'));
			options.add(new SelectOption('HI','HI (Hawaii)'));
			options.add(new SelectOption('ID','ID (Idaho)'));
			options.add(new SelectOption('IL','IL (Illinois)'));
			options.add(new SelectOption('IN','IN (Indiana)'));
			options.add(new SelectOption('IA','IA (Iowa)'));
			options.add(new SelectOption('KS','KS (Kansas)'));
			options.add(new SelectOption('KY','KY (Kentucky)'));
			options.add(new SelectOption('LA','LA (Louisiana)'));
			options.add(new SelectOption('ME','ME (Maine)'));
			options.add(new SelectOption('MD','MD (Maryland)'));
			options.add(new SelectOption('MA','MA (Massachusetts)'));
			options.add(new SelectOption('MI','MI (Michigan)'));
			options.add(new SelectOption('MN','MN (Minnesota)'));
			options.add(new SelectOption('MS','MS (Mississippi)'));
			options.add(new SelectOption('MO','MO (Missouri)'));
			options.add(new SelectOption('MT','MT (Montana)'));
			options.add(new SelectOption('NE','NE (Nebraska)'));
			options.add(new SelectOption('NV','NV (Nevada)'));
			options.add(new SelectOption('NH','NH (New Hampshire)'));
			options.add(new SelectOption('NJ','NJ (New Jersey)'));
			options.add(new SelectOption('NM','NM (New Mexico)'));
			options.add(new SelectOption('NY','NY (New York)'));
			options.add(new SelectOption('NC','NC (North Carolina)'));
			options.add(new SelectOption('ND','ND (North Dakota)'));
			options.add(new SelectOption('OH','OH (Ohio)'));
			options.add(new SelectOption('OK','OK (Oklahoma)'));
			options.add(new SelectOption('OR','OR (Oregon)'));
			options.add(new SelectOption('PA','PA (Pennsylvania)'));
			options.add(new SelectOption('RI','RI (Rhode Island)'));
			options.add(new SelectOption('SC','SC (South Carolina)'));
			options.add(new SelectOption('SD','SD (South Dakota)'));
			options.add(new SelectOption('TN','TN (Tennessee)'));
			options.add(new SelectOption('TX','TX (Texas)'));
			options.add(new SelectOption('UT','UT (Utah)'));
			options.add(new SelectOption('VT','VT (Vermont)'));
			options.add(new SelectOption('VA','VA (Virginia)'));
			options.add(new SelectOption('WA','WA (Washington)'));
			options.add(new SelectOption('WV','WV (West Virginia)'));
			options.add(new SelectOption('WI','WI (Wisconsin)'));
			options.add(new SelectOption('WY','WY (Wyoming)'));
        	options.add(new SelectOption('AA','AA (Armed Forces-Americas)'));
        	options.add(new SelectOption('AE','AE (Armed Forces-Europe)'));
        	options.add(new SelectOption('AP','AP (Armed Forces-Pacific)'));
        	options.add(new SelectOption('AS','AS (American Samoa)'));
        	options.add(new SelectOption('GU','GU (Guam)'));
        	options.add(new SelectOption('MP','MP (N. Mariana Islands)'));
			options.add(new SelectOption('PR','PR (Puerto Rico)'));
			options.add(new SelectOption('VI','VI (Virgin Islands)'));        
			options.add(new SelectOption('AB','AB (Alberta)'));
			options.add(new SelectOption('BC','BC (British Columbia)'));
			options.add(new SelectOption('MB','MB (Manitoba)'));
			options.add(new SelectOption('NB','NB (New Brunswick)'));
			options.add(new SelectOption('NL','NL (Newfoundland/Labrador)'));
			options.add(new SelectOption('NS','NS (Nova Scotia)'));
        	options.add(new SelectOption('NT','NT (Northwest Territories)'));
        	options.add(new SelectOption('NU','NU (Nunavut)'));
			options.add(new SelectOption('ON','ON (Ontario)'));
			options.add(new SelectOption('PE','PE (Prince Edward Island)'));
			options.add(new SelectOption('QC','QC (Quebec)'));
			options.add(new SelectOption('SK','SK (Saskatchewan)'));
        	options.add(new SelectOption('YT','YT (Yukon)'));
        	
            return options;
        }
    
  
	private CampaignSearchController campSearchController;
	public CampaignSearchController getCampSearchController() {
		return campSearchController;
	}
	public void setCampSearchController(CampaignSearchController controller) {
		campSearchController = controller;
	}
	public CampaignSetter getThis() {
		return this;
	}
	public void setSelectedCampaign(Campaign camp) {
		account.Original_Campaign__c = camp.Id;
	}
    public PageReference saveAccount(){
        isValidContactAttached = true;
        String addressType = '';
        KnowWhoAccountAddressService kws = new KnowWhoAccountAddressService();

        system.debug(':showOverride:::' + showOverride);
        
        //First, if override is true, save and move on
        if(isOverride) {
            isAddressValid = true; 

        }
        else if (checkCountryUSA() == FALSE ) {//If Not USA, don't validate - save and move on
                    isOverride = true;
                    isAddressValid = true;
        }

        else {
            sAddressState = CheckAddressState();

            if (sAddressState == 'Empty') {//Save and move on
                isAddressValid = false; //don't create address record
                showOverride = false;
            }
            //Check Country
            else if (sAddressState == 'Partial') {//Don't continue with save = give user option to override
                isAddressValid = false;
                showOverride = true;
                //Check State if USA
                if (checkCountryUSA() && accountAddress.rC_Bios__Original_State__c != null) {
                    checkState();
                    return null;
                }
            }
            else {//Full Address 
                        //Check the state
                        if (!checkState()) {
                            return null;
                        }
                        else {
                            // Perform the ZDM Address validation                
                                try {
                                    kws.getAddressInfo(accountAddress);
                                } 
                                catch(Exception e) {
                                    
                                    // If the ZDM fails
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'There was a problem with the address verification. Please try again.'));
                                    showOverride = true;
                                    //if(accountAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                                    //  accountAddress.rC_Bios__Original_Postal_Code__c = '';
                                    //}
                                    
                                    isAddressValid = false;
                                    return null;
                                }

                            // Did the ZDM return an error?                
                            if (kws.bError) {
                                
                                // Return the KnowWho error message and allow the user to overwrite the address
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, kws.sErrorMessage));
                                showOverride = true;

                                // Valid address but couldn't verify
                                if (kws.bUnVerifiedError) {
                                    isAddressValid = true;
                                    //accountaddress = kws.updatedAddress;
                                    return null;    
                                } else {
                                    isAddressValid = false;
                                    return null;    
                                }
                            }
                            else {
                                
                                // QUESTION: This got pulled? How do the values get placed?
                                //Answer: We pass the instance of account address into KW class, so gets updated there
                                //accountaddress = kws.updatedAddress;
                                //
                                // ZDM did not return an error
                                isAddressValid = true;
                                showOverride = false;
                            }
                        } 
            }//Full Address End
        }//end no override      

        if(validateAccountAddress()){
            if(this.account.RecordTypeId != houseHoldType) {
            	if( ! dupAccountsAccepted ) {
     				dupAccountList = DupCheck.dupCheckAccount(this.account);
     				if( ! dupAccountList.isEmpty()) {
     					return null;
     				}
            	}
            }
            
            system.debug(':: Account Address And Contact Validated :::');
            Savepoint sp = Database.setSavepoint();
            try {
                Id insertedAccountId  = insertAccount();
                return new Pagereference('/'+insertedAccountId);
            } catch(Exception ex) {
                Database.rollback(sp);
                this.account.id=null;           
                this.accountAddress.id = null;
                for(contact con : contactList) {
                    con.Id = null;
                }
                String errMessage = ex.getMessage();
                if(errMessage.contains('Private_Email__c duplicates value')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Private Email already exist with contact. It should be unique'));
                } else if(errMessage.contains('Contact can be either Primary or Secondary')) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Contact can be either Primary or Secondary, Please Correct.'));
                } else if(errMessage.contains('Required field when marked as preferred:')) {
                    //Do Nothing, Managed Package is automatically adding error message, putting condition to stop 2 page messages being added.
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Selected preferred email/phone can not be left blank'));
                }
            }
        } 
        else{
            if(!isValidContactAttached) {
                if(houseHoldType == account.RecordTypeId) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Account record must have at least 1 method of contact (Either Full Postal Address or Email/Phone on Preferred Contact)'));
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Account record must have at least 1 method of contact (Either Full Postal Address or Phone on Preferred Contact)'));
                }
            }
        }
        //Resst flag
        return null;
    }

    // Confirm that the address is complete enough to be ZDM'd
    //      It should have Street1, City, State, and either
    //          be a domestic address with a 2-char state or
    //          be a non-USA address
    //  This version properly converts the Country to USA, if left to US
    private String CheckAddressState(){
    String sAddressReturn = 'Complete';
        
        // Is the address empty?
        if( 
            accountAddress.rC_Bios__Original_Street_Line_1__c == null && 
            accountAddress.rC_Bios__Original_State__c == null && 
            accountAddress.rC_Bios__Original_City__c == null && 
            accountAddress.rC_Bios__Original_Postal_Code__c == NULL) {
            
            sAddressReturn = 'Empty';
        }   
        else {
        //Is there a full address though?
            if (
                accountAddress.rC_Bios__Original_Street_Line_1__c == null || 
                accountAddress.rC_Bios__Original_State__c == null || 
                accountAddress.rC_Bios__Original_City__c == null || 
                accountAddress.rC_Bios__Original_Postal_Code__c == NULL) {
                
                sAddressReturn = 'Partial';
                
            }

        }
        return sAddressReturn;
    }
        /*
            // If any of the fields has a value, add the error message.
            // If all three fields were blank, assume it was intentional and 
            //      the checks for email and phone will catch if this is a problem.
            if( rcAddressValidate.rC_Bios__Original_Street_Line_1__c != null || 
                rcAddressValidate.rC_Bios__Original_State__c != null || 
                rcAddressValidate.rC_Bios__Original_City__c != null) {

                // TODO: Improve the error messaging?
                //      "Either remove all of these"
                // Throw the error
                ApexPages.addMessage(
                        new ApexPages.Message(ApexPages.severity.Error, 
                        'Street 1, City, and State can not be left blank. ::: '));
                
                // VB: Guessing this was you Peter?
                //bContinue = FALSE;
                //
            }
            return false;
        */  
         
        

    private Boolean checkCountryUSA() {
                // If the Country was blank/null, default the Country to USA
                // this also converts validated values into USA ( e.g. US, UniTed STATES )
            
                if (accountAddress.rC_Bios__Original_Country__c  == null || 
                    KnowWhoAccountAddressService.bCheckUSA(accountAddress.rC_Bios__Original_Country__c)) {
            
                    accountAddress.rC_Bios__Original_Country__c = 'USA';
                    return TRUE;
                }
                return FALSE;
    }   

    private Boolean checkState() {
    
                // If the state is not two characters long for USA
                if(accountAddress.rC_Bios__Original_State__c.length() != 2){
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 
                    'Please enter a two letter state abbreviation'));
                    return false;
                }
            return TRUE;
            
    }
        // At this point, we have a Street1, City, & State and either 
        //          KW validates the address to the US or 
        //          we have a non-USA address, which does not need to be validated.
        //      OR
        //          The address was left intentionally blank
        //return true;
    //}  
    
  private id insertAccount(){
    system.debug('::METHOD insertAccount::::::isAddressValid::'+isAddressValid+'::isOverride::'+isOverride);
        if(isAddressValid){
            insert this.account;
            //Insert Contacts before Account so Contacts updated by Trigger
            insertAccountContacts(this.account.id);

                accountAddress.rC_Bios__Preferred_Billing__c = true;
                accountAddress.rC_Bios__Preferred_Shipping__c = true;
                accountAddress.rC_Bios__Active__c = true;
                accountAddress.rC_Bios__Account__c = this.account.Id;
                
                //MM Change 6/22/2015 Start
                if(accountAddress.rC_Bios__Original_Country__c == 'US' ||
                   accountAddress.rC_Bios__Original_Country__c == 'USA' ||
                   accountAddress.rC_Bios__Original_Country__c == 'United States') {
                       accountAddress.rC_Bios__Original_Country__c = '';
                }
                //MM Change 6/22/2015 End
                
                insert accountAddress;
        }else{
        //Just insert account and contacts
            insert this.account;
            insertAccountContacts(this.account.id);
        }
        
        return this.account.Id;
  }
    
  private Id insertAccountContacts(Id accountId){
    system.debug('::METHOD insertAccountContacts::::::');
    if(contactList!=null && !contactList.isEmpty()){
            //list<rC_Bios__Contact_Address__c> contactAddressList = new list<rC_Bios__Contact_Address__c>();
            for(contact con : contactList){
            	
            	// VB: 2017/01/20
            	//	Now explicitly enforce matching record type as rC_Bios setting has been
            	//		disabled and we support adding Org Contacts to KW Record Type Accounts.
		        if(houseHoldType == account.RecordTypeId) {
		        	con.RecordTypeId = hhContactType;
		        } else {
		        	// Record type is assumed to be Org or KW Record Type
		        	con.RecordTypeId = orgContactType;
		        }
				// VB: 2017/01/20            	
                con.AccountId =     accountId;
                con.Original_Campaign__c = this.account.Original_Campaign__c;
            }
            insert contactList;
            
            boolean isVarified = false;
    }
    return null;
  }
    
    // VB: Looking?
    private boolean validateAccountAddress(){
        // 
        if(validateContacts()){
            // 
            if(isValidContactAttached){
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
  
    // 
    private boolean validateContacts(){
        //
        List<Contact> lstContactToBeAdd = new List<Contact>();  // LIST of contacts, not Last or First!
        boolean IspreferredContactFound = false;
        Integer pContactCount = 0;
        set<string> emailIdSet = new set<string>();
        
        // Step through all of the contacts
        for(contact con : contactList){
            
            // Count the preferred contacts, erroring if we find more than one.
            if(con.rC_Bios__Preferred_Contact__c){
                pContactCount++;
                if(pContactCount >=2){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Multiple preferred contacts are selected.'));
                    return false;
                }
            }
            
            // FN Check
            if(String.isBlank(con.FirstName)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Required fields are missing: [First Name]'));
                return false;
            }
            
            // Club System Salutation Check
            if(String.isBlank(con.Club_FullName__c)){
				// If we have a first name
	            if(!String.isBlank(con.FirstName)){
	            	
	            	// If we have a last name
	            	if(!String.isBlank(con.LastName)){
	            		// Substring down the FN & LN
	            		//String tempName = con.FirstName.substring(0,20) + con.LastName.substring(0,22);
            			String tempName = con.FirstName + ' ' + con.LastName;
            			//con.Club_FullName__c = tempName.substring(0,30);
            			con.Club_FullName__c = tempName;
	            	
	            	} else { // No Last Name
            			con.Club_FullName__c = con.FirstName.substring(0,20);
	            	}
	            }
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Required fields are missing: [Club System Salutation]'));
                //return false;
            }
            
            // If the current contact is preferred, and we have not yet encountered a preferred contact
            if(con.rC_Bios__Preferred_Contact__c  && !IspreferredContactFound){
                // Record a preferred contact was found
                IspreferredContactFound = true;
            }
            
            boolean isValidEmail = false;   // Start from false and 
            boolean isValidPhone = false;  

            // If the Contacts Preferred email type has a value
            if(con.rC_Bios__Preferred_Email__c != null){
                
                // Depending on the preferred email type, confirm the appropriate email field has a value 
                if(con.rC_Bios__Preferred_Email__c == 'Work' && con.rC_Bios__Work_Email__c != null) {
                    isValidEmail = true;
                } else if(con.rC_Bios__Preferred_Email__c == 'Home' && con.rC_Bios__Home_Email__c != null) {
                    isValidEmail = true;
                } else if(con.rC_Bios__Preferred_Email__c == 'Other' && con.rC_Bios__Other_Email__c != null) {
                    isValidEmail = true;
                } else if(con.rC_Bios__Preferred_Email__c == 'Assistant' && con.rC_Bios__Assistant_Email__c != null) {
                    isValidEmail = true;
                } 
            } else if(!con.rC_Bios__Preferred_Contact__c) {  // If the Contact is not a Preferred Contact

                // WARNING: If the contact is NOT the preferred contact
                //      In the case of multiple preferred contacts, this email will validate on the FIRST contact
                //
                // If the Contact is not preferred, then the email is automatically valid???
                isValidEmail = true;
            }
      
            // If the Contacts Preferred phone type has a value
            system.debug('PC' + con.rC_Bios__Preferred_Contact__c);
            if(con.rC_Bios__Preferred_Phone__c != null){
                
                // Depending on the preferred phone type, confirm the appropriate phone field has a value 
                if(con.rC_Bios__Preferred_Phone__c == 'Work' && con.rC_Bios__Work_Phone__c != null){
                    isValidPhone = true;
                }else if(con.rC_Bios__Preferred_Phone__c == 'Home' && con.HomePhone != null){
                    isValidPhone = true;
                }else if(con.rC_Bios__Preferred_Phone__c == 'Mobile' && con.MobilePhone != null){
                    isValidPhone = true;
                }else if(con.AssistantPhone == 'Assistant' && con.AssistantPhone != null){
                    isValidPhone = true;
                }else if(con.OtherPhone == 'Other' && con.OtherPhone != null){
                    isValidPhone = true;
                }  
            } else if(!con.rC_Bios__Preferred_Contact__c) {  // If the Contact is not a Preferred Contact
                
                // WARNING: If the contact is NOT the preferred contact
                //      In the case of multiple preferred contacts, this email will validate on the FIRST contact
                //
                // If the Contact is not preferred, then the email is automatically valid???
                //      on the 2nd iteration...
                isValidPhone = true;
            }
        
            // If the Account is a Household record type
            if(houseHoldType == account.RecordTypeId){
                
                // A household Contact must have at least one:
                //      Valid Email
                //      Valid Phone
                //      Valid FullAddress


                if(!isValidEmail && !isValidPhone) {
                //Peter C April 2015 - if only partial address, must have phone or email as well
                //Check Address Type
                    if(!isAddressValid || sAddressState == 'Partial') {
                        isValidContactAttached =  false;
                    }
                }    
            }
            else { // The Account is an Organization type? 
                // WARNING: Lord help us if we add a 3rd Account record type.
                
                // VB: WARNING: Really? An Org Contact only needs an address or phone?  not an email?  
                
                // An organizational Contact must have at least one:
                //      Valid Phone
                //      Valid Address
                //PNC April 2015 - Must be full valid address if not phone supplied
                if(!isValidPhone) {
                    if(!isAddressValid || sAddressState == 'Partial') {
                        isValidContactAttached =  false;
                    }
                }   
            }
                
            // If anything triggered a failure
            if(!isValidContactAttached){
                return false;
            }

            // Add the Contact to the list of Contacts to be added
            lstContactToBeAdd.add(con);
        }
        // Finished looping through all of the Contacts

        // If the Account is a household    
        if(houseHoldType != account.RecordTypeId){
            
            // If there are no Contacts to add to this account AND...
            if(lstContactToBeAdd.isEmpty() && !isAddressValid){
                isValidContactAttached = false;
            }
        }
        
        // If we did have a contact to be added, but there was no preferred Contact found
        if(!lstContactToBeAdd.isEmpty() && !IspreferredContactFound){
            
            // TODO: Better error message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'At least one of contact is specified as the preferred contact.'));
            return false;
        }

        // If no (valid?) contacts were encountered, and it's a Household Account
        if(lstContactToBeAdd.isEmpty() && contactRequired){
            
            // Throw the error to add a Contact
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please add at least one contact.'));
            return false;
        }
     
     	if( ! dupsAccepted ) {
     		DupCheck.DupCheckContact dcc = new DupCheck.DupCheckContact();
     		dcc.city = accountAddress.rC_Bios__Original_City__c;
     		dcc.state = accountAddress.rC_Bios__Original_State__c;
     		dcc.street = accountAddress.rC_Bios__Original_Street_Line_1__c;
     		dcc.postalCode = accountAddress.rC_Bios__Original_Postal_Code__c;
			List<Contact> dccContacts = new List<Contact>();
			for(Contact ct : contactList) {
				Contact ctToCheck = ct.clone(true); //Preserve Id to be able to create link
				if(ctToCheck.rC_Bios__Preferred_Email__c == 'Work') {
					ctToCheck.Email = ct.rC_Bios__Work_Email__c;
				}
				else if(ctToCheck.rC_Bios__Preferred_Email__c == 'Home') {
					ctToCheck.Email = ct.rC_Bios__Home_Email__c;
				}
				else if(ctToCheck.rC_Bios__Preferred_Email__c == 'Other') {
					ctToCheck.Email = ct.rC_Bios__Other_Email__c;
				}
				else if(ctToCheck.rC_Bios__Preferred_Email__c == 'Assistant') {
					ctToCheck.Email = ct.rC_Bios__Assistant_Email__c;
				}

				if(ctToCheck.rC_Bios__Preferred_Phone__c == 'Work') {
					ctToCheck.Phone = ct.rC_Bios__Work_Phone__c;
				}
				else if(ctToCheck.rC_Bios__Preferred_Phone__c == 'Home') {
					ctToCheck.Phone = ct.HomePhone;
				}
				else if(ctToCheck.rC_Bios__Preferred_Phone__c == 'Other') {
					ctToCheck.Phone = ct.OtherPhone;
				}
				else if(ctToCheck.rC_Bios__Preferred_Phone__c == 'Assistant') {
					ctToCheck.Phone = ct.AssistantPhone;
				}
				else if(ctToCheck.rC_Bios__Preferred_Phone__c == 'Mobile') {
					ctToCheck.Phone = ct.MobilePhone;
				}

				dccContacts.add(ctToCheck);
			}
			dcc.contactList = dccContacts;
		 	dupList = new DupCheck().checkContacts(dcc);
	 		if( ! dupList.isEmpty()) {
	 			return false;
	 		}
		}
     	
        return true;
    }
    public PageReference acceptDups() {
    	dupsAccepted = true;
    	return saveAccount();
    }

    public PageReference acceptAccountDups() {
    	dupAccountsAccepted = true;
    	return saveAccount();
    }
  
  public void contactsToCreate(){
        integer totalContacts = integer.valueOf(noOfContacts);
        integer existingContactInList;
        if(contactList == null ||contactList.isEmpty()){
            existingContactInList = 0;
        }
        else{
            existingContactInList = contactList.size();
        }
        if(totalContacts > existingContactInList){
            // add extra contact in list
            for(integer i=existingContactInList;i<totalContacts; i++){
                if(i==0){
                   contactList.add(new Contact(rC_Bios__Preferred_Contact__c=true, Random_Number__c = Integer.valueOf(Math.random() * (100*100))));
                }else{
                    contactList.add(new Contact(Random_Number__c = Integer.valueOf(Math.random() * (100*100))));
                }
            }
        }
        if(totalContacts < existingContactInList){
            // remove  extra contact from list
            for(integer i= totalContacts;i < existingContactInList; i++){
                integer listSize = contactList.size();
                contactList.remove(listSize-1);
            }
        }
    
    }
    
public void updatePreferred(){
    system.debug(':: Update Preferred ::::');
}
  
public Pagereference cancelNewAccount(){
    return new Pagereference('/001/o');
}
	public Boolean getHasDups() {
		if( ! dupsAccepted ) {
			if(dupList != null) {
				if( ! dupList.isEmpty()) {
					return true;
				}
			}
		}
		return false;
	}  
	public Boolean getHasDupAccounts() {
		if( ! dupAccountsAccepted ) {
			if(dupAccountList != null) {
				if( ! dupAccountList.isEmpty()) {
					return true;
				}
			}
		}
		return false;
	}  
 }