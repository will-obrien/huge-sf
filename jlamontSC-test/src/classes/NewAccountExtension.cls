public class NewAccountExtension {
/*
  private final Account account;
  public rC_Bios__Account_Address__c accountAddress{get;set;}
  public Boolean showOverride{get;set;}
  public Boolean isOverride{get;set;}
  public Boolean isPrimaryEmailShow{get;set;}
    
  public Boolean isAddressValid {get;set;}
  public String validationSatus {get;set;}
  public Boolean contactRequired {get;set;}
  public Integer noOfContacts {get;set;}
  public list<Contact> contactList {get;set;}
  private Id houseHoldType;
  private boolean isValidContactAttached;
  public boolean isInvalidTestAddress;
  public boolean showAccountType {get;set;}
  
  
  //================================================================//
  //Constructor
  //================================================================//
  public NewAccountExtension(ApexPages.StandardController controller) {
    this.account = (Account)controller.getRecord();
    contactList = new List<contact>();
    isPrimaryEmailShow = false;
    houseHoldType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    isAddressValid = false;
    isInvalidTestAddress = false;
    isOverride = false;
        showOverride = false;
    if(houseHoldType == account.RecordTypeId){
        showAccountType = false;
      contactRequired = true;
      noOfContacts = 1;
      accountAddress = new rC_Bios__Account_Address__c(rC_Bios__Type__c = 'Home');
      contactList.add(new Contact(rC_Bios__Preferred_Contact__c=true, Random_Number__c = Integer.valueOf(Math.random() * (100*100))));
    }else {
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
  
  public PageReference saveAccount(){
     isValidContactAttached = true;
     String addressType = '';
     AddressService.AddressServiceResult result =new  AddressService.AddressServiceResult();

     if(isAddressNotEmpty(accountAddress)){
             if(!accountAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('United States') && !accountAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('USA') && !accountAddress.rC_Bios__Original_Country__c.equalsIgnoreCase('US')) {
                isOverride = true;
                isAddressValid = true;
                system.debug(':isOverride:::'+isOverride);
             }
        
           system.debug(':showOverride:::'+showOverride);
            
             if(!isOverride) {
                 System.debug('NewAccountExtension #1');
                if(!Test.isRunningTest()){
                    try {
                        result = AddressService.Validate(fetchAddress(accountAddress));
                        System.debug('result:' + result);
                    } catch(Exception e) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'The time limit to validate the address has been exceeded, please refine the address entered or override the validation.'));
                            showOverride = true;
                            if(accountAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                            accountAddress.rC_Bios__Original_Postal_Code__c = '';
                        }
                        isAddressValid = false;
                            return null;
                    }
                }else{
                    if(isInvalidTestAddress){
                        result = AddressService.validateForTest(fetchAddress(accountAddress), false,false);
                    }else{
                      result = AddressService.validateForTest(fetchAddress(accountAddress), true,false);
                    }
                }
                if(result.statusCode.equals('503')) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Address can not be validated now, Please check Override if you still want to save this.'));
                        showOverride = true;
                        if(accountAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                        accountAddress.rC_Bios__Original_Postal_Code__c = '';
                    }
                    isAddressValid = false;
                        return null;
                }
                    system.debug('::: result 11  :::'+result);
                    if(result.isValid) {
                        addressType = accountAddress.rC_Bios__Type__c;
                        copyValidatedAddress(result.addressOutput[0], accountAddress);
                        accountAddress.rC_Bios__Type__c = addressType;
                        //address.rC_Bios__Street_Line_1__c += (''+Math.random());
                        //insert addressResult.addressOutput[0];
                        isAddressValid = true;
                        showOverride = false;
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Not a valid Address Please check Override to use this'));
                        showOverride = true;
                        if(accountAddress.rC_Bios__Original_Postal_Code__c.equals('00000')) {
                        accountAddress.rC_Bios__Original_Postal_Code__c = '';
                    }
                    isAddressValid = false; 
                        return null;
                    }
             } else { 
                isAddressValid = true;
             }
     } else {
            if(String.isBlank(accountAddress.rC_Bios__Original_Street_Line_1__c) && String.isBlank(accountAddress.rC_Bios__Original_State__c) && String.isBlank(accountAddress.rC_Bios__Original_City__c)) {
                //isAddressValid = true;
        } else {
                    return null;
              }
     }
    
    system.debug('::: result 22:::'+result);
   
         
    if(validateAccountAddress()){
        system.debug(':: Account Address And Contact Validated :::');
        Savepoint sp = Database.setSavepoint();
        try{
            Id insertedAccountId  = insertAccount();
            return new Pagereference('/'+insertedAccountId);
        }catch(Exception ex){
            Database.rollback(sp);
            this.account.id=null;           
            this.accountAddress.id = null;
            for(contact con : contactList){
               con.Id = null;
                }
                String errMessage = ex.getMessage();
                if(errMessage.contains('Private_Email__c duplicates value')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Private Email already exist with contact. It should be unique'));
                } else if(errMessage.contains('Contact can be either Primary or Secondary')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Contact can be either Primary or Secondary, Please Correct.'));
                } else if(errMessage.contains('Required field when marked as preferred:')){
                    //Do Nothing, Managed Package is automatically adding error message, putting condition to stop 2 page messages being added.
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Selected preferred email/phone can not be left blank'));
                } 
        }
    }else{
        if(!isValidContactAttached){
            if(houseHoldType == account.RecordTypeId){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Account record must have at least 1 method of contact (Either Postal Address or Email/Phone on Preferred Contact)'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Account record must have at least 1 method of contact (Either Postal Address or Phone on Preferred Contact)'));
            }
        }
    }
    return null;
  }
  
  private boolean isAddressNotEmpty(rC_Bios__Account_Address__c rcAddressValidate){
    
        
        String stateCode = rcAddressValidate.rC_Bios__Original_State__c;
        if(rcAddressValidate.rC_Bios__Original_Street_Line_1__c != null && stateCode != null && rcAddressValidate.rC_Bios__Original_City__c != null){
            if((rcAddressValidate.rC_Bios__Original_Postal_Code__c == null)){   
             rcAddressValidate.rC_Bios__Original_Postal_Code__c = '00000';
            }
            if((rcAddressValidate.rC_Bios__Original_Country__c  == null)){
                rcAddressValidate.rC_Bios__Original_Country__c = 'USA';
            }
            if((rcAddressValidate.rC_Bios__Original_Country__c.equalsIgnoreCase('United States') || rcAddressValidate.rC_Bios__Original_Country__c.equalsIgnoreCase('USA') || rcAddressValidate.rC_Bios__Original_Country__c.equalsIgnoreCase('US')) && stateCode.length()>2){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please enter two letter state abbreviation'));
                if((rcAddressValidate.rC_Bios__Original_Postal_Code__c == '00000')){
                    rcAddressValidate.rC_Bios__Original_Postal_Code__c = '';
                }
                return false;
            }   
            return true;
        }else{
            if(rcAddressValidate.rC_Bios__Original_Street_Line_1__c != null || stateCode != null || rcAddressValidate.rC_Bios__Original_City__c != null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Street 1, City and State can not be left blank. Either remove all of these'));
            }
        }
        return false;
  }
  
  private id insertAccount(){
    system.debug('::METHOD insertAccount::::::isAddressValid::'+isAddressValid+'::isOverride::'+isOverride);
        if(isAddressValid){
            insert this.account;
            accountAddress.rC_Bios__Preferred_Billing__c = true;
                accountAddress.rC_Bios__Preferred_Shipping__c = true;
                accountAddress.rC_Bios__Active__c = true;
                accountAddress.rC_Bios__Account__c = this.account.Id;
                insert accountAddress;
        }else{
            insert this.account;
        }
        insertAccountContacts(this.account.id);
        return this.account.Id;
  }
    
  private Id insertAccountContacts(Id accountId){
    system.debug('::METHOD insertAccountContacts::::::');
    if(contactList!=null && !contactList.isEmpty()){
            list<rC_Bios__Contact_Address__c> contactAddressList = new list<rC_Bios__Contact_Address__c>();
            for(contact con : contactList){
                con.AccountId =     accountId;
            }
            
            insert contactList;
            
            boolean isVarified = false;
    }
    return null;
  }
    
  private boolean validateAccountAddress(){
     if(validateContacts()){
        if(isValidContactAttached){
            return true;
        }else{
            return false;
        }
     }else{
        return false;
     }
  }
  
  
  private boolean validateContacts(){
    List<Contact> lstContactToBeAdd = new List<Contact>();
    boolean IspreferredContactFound = false;
    Integer pContactCount = 0;
    set<string> emailIdSet = new set<string>();
    for(contact con : contactList){
        if(con.rC_Bios__Preferred_Contact__c){
             pContactCount++;
             if(pContactCount >=2){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Multiple preferred contacts are selected.'));
                return false;
             }
        }
        
        if(String.isBlank(con.FirstName)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Required fields are missing: [First Name]'));
        return false;
    }
    if(String.isBlank(con.Club_FullName__c)){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Required fields are missing: [Club System Salutation]'));
        return false;
    }
        
        if(con.rC_Bios__Preferred_Contact__c  && !IspreferredContactFound){
           IspreferredContactFound = true;
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
            }else if(con.rC_Bios__Preferred_Email__c == 'Assistant' && con.rC_Bios__Assistant_Email__c != null){
                isValidEmail = true;
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
            }else if(con.AssistantPhone == 'Assistant' && con.AssistantPhone != null){
              isValidPhone = true;
            }else if(con.OtherPhone == 'Other' && con.OtherPhone != null){
              isValidPhone = true;
            }  
        } else if(!con.rC_Bios__Preferred_Contact__c) {
            isValidPhone = true;
        }
        */
        /*if(con.rC_Bios__Work_Email__c != null){
            if(emailIdSet.contains(con.rC_Bios__Work_Email__c)){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Contact Already exist with Email '+con.rC_Bios__Work_Email__c+' Please specify unique email in Work Email.'));
               return false;    
            }else{
                emailIdSet.add(con.rC_Bios__Work_Email__c);
            }
        }
        if(con.rC_Bios__Home_Email__c != null){
            if(emailIdSet.contains(con.rC_Bios__Home_Email__c)){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Contact Already exist with Email '+con.rC_Bios__Home_Email__c+' Please specify unique email in Home Email .'));
               return false;    
            }else{
                emailIdSet.add(con.rC_Bios__Home_Email__c);
            }
        }
        if(con.rC_Bios__Other_Email__c != null){
            if(emailIdSet.contains(con.rC_Bios__Other_Email__c)){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Contact Already exist with Email '+con.rC_Bios__Other_Email__c+' Please specify unique email in Other Email.'));
               return false;    
            }else{
                emailIdSet.add(con.rC_Bios__Other_Email__c);
            }
        }
        if(con.rC_Bios__Assistant_Email__c != null){
            if(emailIdSet.contains(con.rC_Bios__Assistant_Email__c)){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Contact Already exist with  Email '+con.rC_Bios__Assistant_Email__c+' Please specify unique email  in Assistant Email.'));
               return false;    
            }else{
                emailIdSet.add(con.rC_Bios__Other_Email__c);
            }
        }  */
        /*
        if(houseHoldType == account.RecordTypeId){
            if(!isValidEmail && !isValidPhone && !isAddressValid){
                isValidContactAttached =  false;
            }
        } else {
            if(!isValidPhone && !isAddressValid){
                isValidContactAttached = false;
            }
        }   
        
        if(!isValidContactAttached){
            return false;
        }
        
      lstContactToBeAdd.add(con);
    }
    */
    /*if(!emailIdSet.isEmpty()){
         Set<String> emailExists = new Set<String>();
         for(contact con: [select id,email from contact where email in : emailIdSet]){
              emailExists.add(con.email);
         }
         if(!emailExists.isEmpty()){
            String emailString  = ''+emailExists+'';
            emailString = emailString.replaceAll('\\{','\\[');
            emailString = emailString.replaceAll('\\}','\\]');
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Contact Already exist with Emails '+emailString+' Please specify unique email address.'));
             return false;
         }
    }*/
    /*
    if(houseHoldType != account.RecordTypeId){
           if(lstContactToBeAdd.isEmpty() && !isAddressValid){
              isValidContactAttached = false;
           }
    }   
    if(!lstContactToBeAdd.isEmpty() && !IspreferredContactFound){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'At least one of contact is specified as the preferred contact.'));
        return false;
    }
    
    if(lstContactToBeAdd.isEmpty() && contactRequired){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Please add at least one contact.'));
        return false;
     }
     
     return true;
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
  
  private rC_Bios__Address__c fetchAddress(rC_Bios__Account_Address__c accAdd) {
    rC_Bios__Address__c address = new rC_Bios__Address__c();
    address.Id = accAdd.rC_Bios__Address__c;
    address.rC_Bios__Street_Line_1__c = accAdd.rC_Bios__Original_Street_Line_1__c;
    address.rC_Bios__Street_Line_2__c = accAdd.rC_Bios__Original_Street_Line_2__c;
    address.rC_Bios__State__c = accAdd.rC_Bios__Original_State__c;
    address.rC_Bios__Country__c = accAdd.rC_Bios__Original_Country__c;
    address.rC_Bios__City__c = accAdd.rC_Bios__Original_City__c;
    address.rC_Bios__ZIP__c = accAdd.rC_Bios__Original_Postal_Code__c;
    system.debug('In fetch Address : ' + address);
    return address;
  }
  
  private void copyValidatedAddress(rC_Bios__Address__c srcAdd, rC_Bios__Account_Address__c destAdd) {
    destAdd.rC_Bios__Original_City__c = srcAdd.rC_Bios__City__c;   
    destAdd.rC_Bios__Original_Country__c = srcAdd.rC_Bios__Country__c;
    destAdd.rC_Bios__Original_Postal_Code__c = srcAdd.rC_Bios__ZIP__c;
    destAdd.rC_Bios__Original_State__c  = srcAdd.rC_Bios__State__c;
    destAdd.rC_Bios__Original_Street_Line_1__c = srcAdd.rC_Bios__Street_Line_1__c;
    destAdd.rC_Bios__Original_Street_Line_2__c = srcAdd.rC_Bios__Street_Line_2__c;
  }
  */
}