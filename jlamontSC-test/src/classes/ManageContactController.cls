//**************************************************************************/
// (c) 2014 Appirio, Inc.
//
// Description : Controller class for the page "ManageContact".
//                  
// Original  : February 16, 2014  : KapiL Choudhary(Appirio India) 
//      
//  June 2016 Mark Maslow - Add duplicate checking        
//  2107/01/20      Vernon Baas         Adding support for Org Contacts on
//                                                      KnowWho record type Account 
//
//  2017/01/23		Mark Maslow - Add campaignsetter functionality
//  2107/02/13      Vernon Baas         Adding functionality to explicitly set Contact
//  										record type, for support of adding Org
//  										contacts to KW directory Accounts
// ***************************************************************************/
public with sharing class ManageContactController implements CampaignSetter {
    public Integer noOfContacts {get;set;}
    public Boolean contactRequired {get;set;}
    public Boolean isHideExistinContacts {get;set;}
    private final Account account;
    public list<Contact> contactList {get;set;}
    public list<contactWrapper> contactWrapperList{get;set;}
    private Id houseHoldType,organizationalType,contactHHType,contactOrgType;
    private boolean isValidContactAttached;
    private integer existingContactsCount;
    private boolean isAlreadyPreferredFound;
    private set<string> emailIdSet ;
    private boolean isAddressAttached;
    public Boolean isPrimaryEmailShow{get;set;}
    private Boolean isPreferredFoundInCurrentList;
  private List<rC_Bios__Account_Address__c> accountaddresses;

    public List<Contact> dupList {get; set;}
    private Boolean dupsAccepted = false;

    //================================================================//
  //Constructor
  //================================================================//
  public ManageContactController(ApexPages.StandardController controller) {
    this.account = (Account)controller.getRecord();
    isAddressAttached =false;
    isHideExistinContacts = true;
    isPrimaryEmailShow = false;
    contactWrapperList = new list<contactWrapper>();
    existingContactsCount =0;
    contactList = new List<contact>();
    isAlreadyPreferredFound = false;
    isPreferredFoundInCurrentList = false;
    
    //Private email (to those that have edit security to this field)
    if (Schema.sObjectType.Contact.fields.Private_Email__c.isUpdateable()){
         isPrimaryEmailShow = true;
    }
    
    houseHoldType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    organizationalType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
    contactHHType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    contactOrgType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Organizational').getRecordTypeId();
    String dQuery='Select ';
    for(Schema.FieldSetMember fsFields : Schema.SObjectType.contact.fieldSets.rC_Bios_Contact_Component.getFields()){
        dQuery+=  fsFields.getFieldPath() + ',';
    }
    if(dQuery.endsWith(',')){
        dQuery = dQuery.substringBeforeLast(',') + ' from Contact where accountid=\''+account.id +'\' order by CreatedDate';
        contactList = database.query(dQuery);
        for(Contact con :  contactList){
            if(con.rC_Bios__Preferred_Contact__c ){
            isAlreadyPreferredFound = true;
            }
        }
    }
    
    system.debug('dQuery>>> '+dQuery);
    //if( houseHoldType== account.RecordTypeId){
      contactRequired = true;
      noOfContacts = 1;
      contactWrapper cW = new contactWrapper();
      if(existingContactsCount == 0 && !isAlreadyPreferredFound){
        cW.contactRec.rC_Bios__Preferred_Contact__c = true;
      }
      contactWrapperList.add(cW);
    //}else {
    //  contactRequired = false;
    //}  
    isValidContactAttached = true;
    
    /* Just include on page and will be included with Standard Controller
    for(account acc : [select rC_Bios__Preferred_Billing_Address__c, rC_Bios__Preferred_Shipping_Address__c from account where id=:account.id]){
    */
        if(account.rC_Bios__Preferred_Billing_Address__c != null || account.rC_Bios__Preferred_Shipping_Address__c != null){
            isAddressAttached = true;
        //Get Account Addresses
        accountaddresses = [SELECT   
                                 Id,
                                 rC_Bios__Active__c,
                                 kwrc__KW_Error_Code__c,
                                 kwrc__ZTDM_Expiry_Date__c,
                                 kwrc__KWD_Last_Processed_DT__c,
                                 kwrc__Latitude__c, 
                                 kwrc__Longitude__c,
                                 kwrc__ZDM_Location__c,
                                 kwrc__PO_Box__c,
                                 kwrc__Zip_4__c,
                                 kwrc__KW_USSenateDistrict__c,
                                 kwrc__KW_USSenateDesc__c,
                                 kwrc__KW_USHouseDistrict__c,
                                 kwrc__KW_USHouseDesc__c,
                                 kwrc__KW_StateSenateDistrict__c,
                                 kwrc__KW_StateSenateDesc__c,
                                 kwrc__KW_StateHouseDistrict__c,
                                 kwrc__KW_StateHouseDesc__c,
                                 kwrc__KW_CountyCode__c,
                                 kwrc__KW_CountyName__c,
                                 kwrc__KW_CountyDistrict__c,
                                 kwrc__KW_CountyDistrictDesc__c,
                                 kwrc__KW_MunicipalType__c,
                                 kwrc__KW_MunicipalCode__c,
                                 kwrc__KW_MunicipalName__c,
                                 kwrc__KW_MunicipalDistrict__c,
                                 kwrc__KW_MunicipalDistrictDesc__c,
                                 kwrc__Elected_Officials_Ids__c,
                                 kwrc__ZDM_Location__Longitude__s,
                                 kwrc__ZDM_Location__Latitude__s,
                                 kwrc__USPS_City__c,
                                 kwrc__USPS_Zip__c,
                                 kwrc__USPS_State__c,
                                 kwrc__USPS_Street__c,
                                 kwrc__USPS_Street_2__c,
                                 kwrc__USPS_Verified__c,
                                 kwrc__KnowWho_Address_Update__c,
                                 rC_Bios__Type__c, 
                                 rC_Bios__Seasonal_Start_Month__c,
                                 rC_Bios__Seasonal_End_Month__c,
                                 rC_Bios__Seasonal_Start_Day__c,
                                 rC_Bios__Seasonal_End_Day__c,
                                 rC_Bios__Start_Date__c,
                                 rC_Bios__End_Date__c,
                                 rC_Bios__Preferred_Billing__c, 
                                 rC_Bios__Preferred_Shipping__c,
                                 rC_Bios__Do_Not_Mail__c,
                                 rC_Bios__Original_Street_Line_1__c,
                                 rC_Bios__Original_City__c,
                                 rC_Bios__Original_State__c,
                                 rC_Bios__Original_Country__c,
                                 rC_Bios__Original_Postal_Code__c,
                                 rC_Bios__Original_Street_Line_2__c,
                                 rC_Bios__Address__c,
                                 rC_Bios__Address__r.rC_Bios__City__c, 
                                 rC_Bios__Address__r.rC_Bios__Street_Line_1__c,
                                 rC_Bios__Address__r.rC_Bios__Street_Line_2__c,
                                 rC_Bios__Address__r.rC_Bios__State__c,
                                 rC_Bios__Address__r.rC_Bios__Country__c,
                                 rC_Bios__Address__r.rC_Bios__ZIP__c,
                                 OrgName__c,
                                 OrgName2__c
                                 FROM rC_Bios__Account_Address__c 
                                 WHERE rC_Bios__Account__c = :account.Id AND rC_Bios__Active__c = TRUE];

  }
}

    public void contactsToCreate(){
        integer totalContacts = integer.valueOf(noOfContacts);
        integer existingContactInList;
        if(contactWrapperList == null || contactWrapperList.isEmpty()){
            existingContactInList = 0;
        }
        else{
            integer existingCount =0;
            
            existingContactInList = contactWrapperList.size() - existingContactsCount;
        }
        if(totalContacts > existingContactInList){
            // add extra contact in list
            for(integer i=existingContactInList;i<totalContacts; i++){
                contactWrapperList.add(new contactWrapper());
            }
        }
        if(totalContacts < existingContactInList){
            // remove  extra contact from list
            for(integer i= totalContacts;i < existingContactInList; i++){
                integer listSize = contactWrapperList.size();
                contactWrapperList.remove(listSize-1);
            }
        }
    
    }
    private boolean validateContacts(){
    List<Contact> lstContactToBeAdd = new List<Contact>();
    Boolean IsPreferredContactFound = false;
    integer selectedCount = 0;
    emailIdSet = new set<string>();
    // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ' lstContactToBeAdd '+lstContactToBeAdd+' :::: isAddressValid ::'+isAddressValid +' ::isValidContactAttached ::'+isValidContactAttached));
  
    for(contactWrapper cw : contactWrapperLIst){
        contact con = cw.contactRec;
        if(con.rC_Bios__Preferred_Contact__c){
            selectedCount++;
        }
        if(con.rC_Bios__Preferred_Contact__c && !IsPreferredContactFound){
          IsPreferredContactFound = true;
        }
        boolean isValidEmail = false;
          boolean isValidPhone  = false;  
          if(con.rC_Bios__Preferred_Email__c != null){
             if(con.rC_Bios__Preferred_Email__c == 'Work' && con.rC_Bios__Work_Email__c != null){
                  isValidEmail = true;
                 }else if(con.rC_Bios__Preferred_Email__c == 'Home' && con.rC_Bios__Home_Email__c != null){
                      isValidEmail = true;
                 }else if(con.rC_Bios__Preferred_Email__c == 'Other' && con.rC_Bios__Other_Email__c != null){
                      isValidEmail = true;
                 } else if(con.rC_Bios__Preferred_Email__c == 'Assistant' && con.rC_Bios__Assistant_Email__c != null){
                      isValidEmail = true;
                 } else {
                     isValidContactAttached =  false;
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, con.rC_Bios__Preferred_Email__c + ' Email: Required field when marked as preferred'));
               return false;
                 }
          } else if(!con.rC_Bios__Preferred_Contact__c) {
                isValidEmail = true;
            }
          
           if(con.rC_Bios__Preferred_Phone__c != null){
             if(con.rC_Bios__Preferred_Phone__c == 'Work' && con.rC_Bios__Work_Phone__c != null){
                  isValidPhone = true;
                 }else if(con.rC_Bios__Preferred_Phone__c == 'Home' && con.HomePhone != null){
                      isValidPhone = true;
                 }else if(con.rC_Bios__Preferred_Phone__c == 'Mobile' && con.MobilePhone != null){
                      isValidPhone = true;
                 }
                 else if(con.rC_Bios__Preferred_Phone__c == 'Assistant' && con.AssistantPhone != null){
                      isValidPhone = true;
                 }
                 else if(con.rC_Bios__Preferred_Phone__c == 'Other' && con.OtherPhone != null){
                      isValidPhone = true;
                 } else {
                     isValidContactAttached =  false;
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, con.rC_Bios__Preferred_Phone__c + ' Phone: Required field when marked as preferred'));
               return false;
                 }
          } else if(!con.rC_Bios__Preferred_Contact__c) {
            isValidPhone = true;
        }
        
        if(houseHoldType == account.RecordTypeId){
           if(!isAddressAttached && !isValidEmail && !isValidPhone ){
              isValidContactAttached =  false;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Account record must have at least 1 method of contact (Either Postal Address or Email/Phone on Preferred Contact)'));
              return false;
           }
        // VB: 2016/01/20 - Explicitly including Org Account here
        //              to Exclude non-HH/Org Account Types from thes validation
        } else if(organizationalType == account.RecordTypeId) {
           if(!isAddressAttached && !isValidPhone){
              isValidContactAttached = false;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Account record must have at least 1 method of contact (Either Postal Address or Phone on Preferred Contact)'));
              return false;
           }
        }
        
        if(con.lastname == null || con.lastname == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Last name is required for saving a contact.'));
            return false;
        }
        
        if(String.isBlank(con.FirstName)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Required fields are missing: [First Name]'));
            return false;
        }

        //if(String.isBlank(con.Club_Fullname__c)){
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Required fields are missing: [Club System Salutation]'));
        //    return false;
        //}
        
        lstContactToBeAdd.add(con);
    }
    
    
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ' lstContactToBeAdd '+lstContactToBeAdd+' :::: isAddressValid ::'+isAddressValid +' ::isValidContactAttached ::'+isValidContactAttached));
    if(houseHoldType != account.RecordTypeId){
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ' Check for Valid Address'));
           if(lstContactToBeAdd.isEmpty()){
              isValidContactAttached = false;
           }
    }   
    
     if(isAlreadyPreferredFound){
        IsPreferredContactFound = true;
     }
     
     if(selectedCount > 0) {
        isPreferredFoundInCurrentList = true;
     }
     
     if(selectedCount > 1){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'multiple preferred contacts are selected.'));
        return false;
     }
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, ' 11 >>> '+isValidContactAttached));
    if(!lstContactToBeAdd.isEmpty() && !IsPreferredContactFound){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'At least one of contact is specified as the preferred contact.'));
        return false;
    }
    
    if(lstContactToBeAdd.isEmpty() && contactRequired){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please add at least one contact.'));
        return false;
     }
    
     return true;
  }
  
private pagereference insertAccountContacts(){

	system.debug('::METHOD insertAccountContacts::::::');
      
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'METHOD insertAccountContacts:::'));

	if(contactWrapperList!=null && contactWrapperList.isEmpty() == FALSE){
		list<contact> conList = new list<contact>();
            
		for(contactWrapper cW : contactWrapperList){
			cw.contactRec.AccountId = account.id;
            
            // VB: 2017/02/13 - Adding in record type function to determine Contact record types
            // 		If the Account is a HH, then all Contacts will be HH record type,
            // 		otherwise we can default to Org for Org Accounts and KnowWho Accounts.
			if(houseHoldType == account.RecordTypeId){
				cw.contactRec.RecordTypeId = contactHHType;
			} else {
				// Record type is assumed to be Org or KW Record Type
                cw.contactRec.RecordTypeId = contactOrgType;
			}
            
			//Update Contact Address Fields
			Boolean bPreferredBillingFound = FALSE;
			Boolean bPreferredShippingFound = FALSE;
      
			if (accountaddresses != NULL && accountaddresses.size() > 0) {

                for (rC_Bios__Account_Address__c aa: accountaddresses) {
            
					if (aa.rC_Bios__Preferred_Billing__c) {
						bPreferredBillingFound = TRUE;
						String sMailingStreet = aa.rC_Bios__Original_Street_Line_1__c;
						if (String.IsEmpty(aa.rC_Bios__Original_Street_Line_2__c) == FALSE) {
							sMailingStreet += '\n' + aa.rC_Bios__Original_Street_Line_2__c;
						}
						cw.contactRec.MailingStreet = sMailingStreet;
						cw.contactRec.MailingCity = aa.rC_Bios__Original_City__c;
						cw.contactRec.MailingState = aa.rC_Bios__Original_State__c;
						cw.contactRec.MailingPostalCode = aa.rC_Bios__Original_Postal_Code__c;
						cw.contactRec.MailingCountry = aa.rC_Bios__Original_Country__c;

						//Set ZDM Fields when address is preferred Billing
						kwzd.KWD_Process_JSON_Response.updateTargetfromSourceObject(aa, 'kwrc__', cw.contactRec, 'kwzd__');
					}  

					if (aa.rC_Bios__Preferred_Shipping__c) {//Is this address also preferred Shipping?
						bPreferredShippingFound = TRUE;
						String sMailingStreet = aa.rC_Bios__Original_Street_Line_1__c;
						if (String.IsEmpty(aa.rC_Bios__Original_Street_Line_2__c) == FALSE) {
							sMailingStreet += '\n' + aa.rC_Bios__Original_Street_Line_2__c;
						}
						cw.contactRec.OtherStreet = sMailingStreet;
						cw.contactRec.OtherCity = aa.rC_Bios__Original_City__c;
						cw.contactRec.OtherState = aa.rC_Bios__Original_State__c;
						cw.contactRec.OtherPostalCode = aa.rC_Bios__Original_Postal_Code__c;
						cw.contactRec.OtherCountry = aa.rC_Bios__Original_Country__c;
					}

					//If we've found both billing and shipping, no need to keep looking
					if (bPreferredBillingFound && bPreferredShippingFound) {
						break;  
					}
				}
			}
			conList.add(cw.contactRec);
        }

        if(!conList.isEmpty()){
                if( ! dupsAccepted ) {
                        DupCheck.DupCheckContact dcc = new DupCheck.DupCheckContact();
                        Contact firstContact = conList.get(0);
                        dcc.city = firstContact.MailingCity;
                        dcc.state = firstContact.MailingState;
                        dcc.street = firstContact.MailingStreet;
                        dcc.postalCode = firstContact.MailingPostalCode;
                                List<Contact> dccContacts = new List<Contact>();
                        for(Contact ct : conList) {
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
                                        return null;
                                }
                }
 
            try{
                if(isPreferredFoundInCurrentList && isAlreadyPreferredFound) {
                    for(Contact cnt : contactList) {
                        cnt.rC_Bios__Preferred_Contact__c = false;
                    }
                    update contactList;
                }
                upsert conList;
                contactWrapperList = new list<contactWrapper>();
                noOfContacts = 1;
        contactWrapperList.add(new contactWrapper());
            }
            catch(exception ex){
                String errMessage = ex.getMessage();
                if(errMessage.contains('Private_Email__c duplicates value')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Private Email already exist with contact. It should be unique'));
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, errMessage));
                }
                return null;
            }
            return new Pagereference('/'+account.id);
        }
    }
    return null;
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
                for(contactWrapper wrapper : contactWrapperList) {
                        wrapper.contactRec.Original_Campaign__c = camp.Id;                      
                }
        }
  public Pagereference saveContacts(){
    if(validateContacts()){
        return insertAccountContacts();
    }
    return null;
  }
   public Pagereference saveAndClose(){
    if(validateContacts()){
        return insertAccountContacts();
    }
    return null;
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
        public PageReference acceptDups() {
                dupsAccepted = true;
                return saveContacts();
        }

  public void updatePreferred(){
        system.debug(':: Update Preferred ::::');
    }
  
  public Pagereference cancelNewAccount(){
    return new Pagereference('/'+account.id);
   }
   public class contactWrapper{
    public contact contactRec{get;set;}
    public boolean isExisting {get;set;}
    public contactWrapper(){
        contactRec = new contact(Random_Number__c = Integer.valueOf(Math.random() * (100*100)));
        
    }
   }
}