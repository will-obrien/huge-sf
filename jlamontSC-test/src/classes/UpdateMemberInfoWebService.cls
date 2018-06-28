/*********************************************************************************************************
Name              : CallReportExtension
Created By        : Dipika Gupta (Appirio JDC)
Created Date      : Feb 13, 2013
Description       : T-249591 web service class to update contact/user fields-
                    first name, last name, email, password
***********************************************************************************************************/
global class UpdateMemberInfoWebService {
    //webservice method is defined along with it's parameters
    webService static boolean updateUserContact(String FirstName,String LastName, String EmailId,String Phone, string Prefix, string Suffix,
                                      String newpassword,string userId,String AddressLine1, String AddressLine2,String City, String State, String Zip, String Country ) {
        boolean isUpdate = false;
        if (Prefix !='' && Prefix !=null){
          boolean hasPeriod = Prefix.endsWith('.');
          if (hasPeriod == true){
          integer prefixLength = Prefix.length();
          Prefix = prefix.substring(0, prefixLength-1);
          }
        }
        
        
        //enclosed in a try/catch loop so we can revert if there is an error
        try{
        
            String keyPrefix;
            list<User> listUserObject;
        
                listUserObject = [SELECT ID,Email,FirstName,LastName,Contact.FirstName, Phone, Contact.rC_Bios__Preferred_Phone__c,
                                  Contact.LastName, ContactId,Contact.rC_Bios__Home_Email__c,Contact.HomePhone,Contact.rC_Bios__Salutation__c,
                                  Contact.rC_Bios__Suffix__c,Contact.Club_FullName__c,AccountId FROM User where ID =: userId ];
                if(listUserObject.size() == 1){
                    User updateUser = listUserObject.get(0);
                    system.debug('::updateUser Account Id ::'+updateUser.AccountId);
                    system.debug(':::updateUser:::'+updateUser);
                    
                    //Checks to update the user object
                    //Only the email, phone, First/Last Name, or password will be updated
                    if(EmailId != null && EmailId!= '' && updateUser.Email != EmailId && EmailId!='NULL'){
                        updateUser.Email = EmailId;
                        isUpdate = true;
                    }
                    if(Phone != null && Phone!= '' && updateUser.Phone != Phone){
                      updateUser.Phone = Phone;
                      isUpdate = true;
                    }
                    if(Phone == 'NULL'){
                      updateUser.Phone = '';
                      isUpdate = true;
                    }
                                        
                    if(LastName != null && LastName!= '' && updateUser.LastName != LastName && LastName!='NULL'){
                        updateUser.LastName = LastName;
                        isUpdate = true;
                    }
                    
                    if(FirstName != null && FirstName!= '' && updateUser.FirstName != FirstName && FirstName!='NULL'){
                        updateUser.FirstName = FirstName;
                        isUpdate = true;
                    }
                    listUserObject.get(0).FirstName = (FirstName != null && FirstName!= '')? FirstName: listUserObject.get(0).FirstName;

                    if(newpassword != null && newpassword!= ''){
                        system.debug('--------'+newpassword);
                        system.setPassword(listUserObject.get(0).id, newpassword);
                        isUpdate = true;
                    }
                    if(isUpdate = true && !test.isRunningTest()){
                        update listUserObject;
                    }
                    
                    // Update Associated Account from User for Updated fields 
                    if(updateUser.AccountId!=null){
                        Account updateUserAccount =new Account(Id=updateUser.AccountId);
                        
                        if(updateAccount(updateUserAccount, FirstName, LastName, EmailId, Phone, Prefix, Suffix,
                                         AddressLine1, AddressLine2, City, State, Zip, Country)){
                            update updateUserAccount;
                            
                            isUpdate = true;
                        }
                        //Updates the Account Address
                        updateAccountAddress(updateUser.AccountId, AddressLine1, AddressLine2, City, State, Zip, Country);
                    }
                    
                    //If passed Id is contactId, fetch contact and update contact fields
                    if(updateUser.ContactId!=null){
                        Contact updateUserContact =new Contact(Id=updateUser.ContactId,
                                                               FirstName= updateUser.Contact.FirstName,
                                                               LastName =  updateUser.Contact.LastName,
                                                               HomePhone = updateUser.Contact.HomePhone,
                                                               rC_Bios__Home_Email__c = updateUser.Contact.rC_Bios__Home_Email__c,
                                                               Salutation = updateUser.Contact.rC_Bios__Salutation__c,
                                                               rC_Bios__Suffix__c = updateUser.Contact.rC_Bios__Suffix__c,
                                                               Club_FullName__c = updateUser.Contact.Club_FullName__c);
                        if(updateContact(updateUserContact, FirstName, LastName, EmailId, Phone, Prefix, Suffix,
                                         AddressLine1, AddressLine2, City, State, Zip, Country)){
                            update updateUserContact;
                            isUpdate = true;
                        }
                    }
                    
                    
                    
                }
        }catch(Exception e){
            isUpdate = false;
            system.debug('Exception is ::'+e);
            system.debug('----Error-->>'+e.getMessage());
        }
        return isUpdate;
    }
    
    
     private static boolean updateAccount(Account updateUserAccount,String FirstName,String LastName,String EmailId,String Phone, string Prefix, string Suffix,
                                         String AddressLine1, String AddressLine2,String City, String State, String Zip, String Country  ){
           boolean isUpdateAccount = false;
           system.debug('updateUserAccount: ' + updateUserAccount);
           
           //We will only update the Email and Phone on an Account
           if(EmailId != null && EmailId!= '' && updateUserAccount.Email__c != EmailId && EmailId!='NULL'){
             updateUserAccount.Email__c= EmailId;
             isUpdateAccount = true;
           }
                          
           if(Phone != null && Phone!= '' && updateUserAccount.Phone != Phone){
              updateUserAccount.Phone = Phone;
              isUpdateAccount = true;
           }
           
           if(Phone == 'NULL'){
              updateUserAccount.Phone = '';
              isUpdateAccount = true;
           }
           return isUpdateAccount;
    }
    
    /*
    *  Update Account address if any changes are there 
    */
     public static boolean updateAccountAddress(Id accountId,String AddressLine1,
                                      String AddressLine2,String City, String State, String Zip, String Country){
           
           
           rC_Bios__Account_Address__c updateAccountAddress; 
           for( rC_Bios__Account_Address__c updateAcctAddr :[Select id,rC_Bios__Account__c,rC_Bios__Original_Street_Line_1__c,
                                                               rC_Bios__Original_Street_Line_2__c,rC_Bios__Active__c,rC_Bios__Original_City__c,
                                                               rC_Bios__Original_State__c,rC_Bios__Original_Country__c,rC_Bios__Original_Postal_Code__c
                                                               ,rC_Bios__Preferred_Billing__c from rC_Bios__Account_Address__c where rC_Bios__Account__c =:accountId]){
              
              //If More then One Address then consider rC_Bios__Preferred_Billing__c
              if(updateAccountAddress == null || updateAcctAddr.rC_Bios__Preferred_Billing__c){
                  updateAccountAddress = updateAcctAddr;
              }                                                
           }
           
           
           
           boolean isUpdateAccountAddress = false;
           
           if(updateAccountAddress == null){
              updateAccountAddress = new rC_Bios__Account_Address__c();
              updateAccountAddress.rC_Bios__Account__c = accountId;
           }
           
           if(City != null && City!= '' && City!='NULL'){
              updateAccountAddress.rC_Bios__Original_City__c = City;
              isUpdateAccountAddress = true;
           }
               
           if(State != null && State!= '' && State!='NULL'){
              updateAccountAddress.rC_Bios__Original_State__c = State;
              isUpdateAccountAddress = true;
           } 
              
           if(Zip != null && Zip!= '' && Zip!='NULL'){
              updateAccountAddress.rC_Bios__Original_Postal_Code__c = Zip;
              isUpdateAccountAddress = true;
           }
               
           if(Country != null && Country!= ''){
             updateAccountAddress.rC_Bios__Original_Country__c  = Country;
             isUpdateAccountAddress = true;
           }
           if(Country == 'NULL'){
             updateAccountAddress.rC_Bios__Original_Country__c  = '';
             isUpdateAccountAddress = true;
           }
           
           if(AddressLine1 != null && AddressLine1 !='' && AddressLine1!='NULL'){
               updateAccountAddress.rC_Bios__Original_Street_Line_1__c = AddressLine1;
               isUpdateAccountAddress = true;
           }
           
           if(AddressLine2 != null && AddressLine2 !=''){
               updateAccountAddress.rC_Bios__Original_Street_Line_2__c = AddressLine2;
               isUpdateAccountAddress = true;
           }
           if(AddressLine2 == 'NULL'){
               updateAccountAddress.rC_Bios__Original_Street_Line_2__c = '';
               isUpdateAccountAddress = true;
           }
          
           if(isUpdateAccountAddress){                                  
             updateAccountAddress.rC_Bios__Active__c = true;
             upsert updateAccountAddress;
           }
          
           return isUpdateAccountAddress;
    }
    
    
    private static boolean updateContact(Contact con,String FirstName,String LastName,String EmailId,String Phone, string Prefix, string Suffix,
                                         String AddressLine1, String AddressLine2,String City, String State, String Zip, String Country  ){
           boolean isUpdateContact = false;
           system.debug('updateContact ' + con);
           if(EmailId != null && EmailId!= '' && con.Email != EmailId && EmailId!='NULL'){
             con.Email = EmailId;
             isUpdateContact = true;
           }
           if(LastName != null && LastName!= '' && con.LastName !=LastName && LastName!='NULL'){
             con.LastName = LastName;
             isUpdateContact = true;
           }
           
           if(FirstName != null && FirstName!= '' && con.FirstName != FirstName && FirstName!='NULL'){
             con.FirstName = FirstName;
             isUpdateContact = true;
           }
           
           if(EmailId != null && EmailId!= '' && con.rC_Bios__Home_Email__c != EmailId && EmailId!='NULL'){
              con.rC_Bios__Home_Email__c = EmailId;
              isUpdateContact = true;
           } 
       
           if(Phone != null && Phone!= '' && con.HomePhone != Phone){
              con.HomePhone = Phone;
              isUpdateContact = true;
           }
           
           //Phone can be set to a null value
           if(Phone == 'NULL'){
              con.HomePhone = '';
              con.rC_Bios__Preferred_Phone__c = '';
              isUpdateContact = true;
           }
           
           if(Prefix != null && Prefix!= '' && con.Salutation != Prefix){
              con.Salutation = Prefix;
              isUpdateContact = true;
           }
           
           //Salutation can be set to a null value
           if(Prefix == 'NULL'){
              con.Salutation = '';
              isUpdateContact = true;
           }
        
           if(Suffix != null && Suffix!= '' && con.rC_Bios__Suffix__c != Suffix){
              con.rC_Bios__Suffix__c = Suffix;
              isUpdateContact = true;
           }
           
           //Suffix (jr, sr, etc) can be set to a null value
           if(Suffix == 'NULL'){
              con.rC_Bios__Suffix__c = '';
              isUpdateContact = true;
           }
           
           
           return isUpdateContact;
    }
    
}