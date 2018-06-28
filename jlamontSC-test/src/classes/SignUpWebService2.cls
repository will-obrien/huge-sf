//*********************************************************************************************************
//Name              : SignUpWebService
//Created By        : Dipika Gupta (Appirio JDC)
//Created Date      : Feb 13, 2013
//Description       : T-249593 web service class to create new user

//Last Updated      : March 11, 2014 Kapil Choudhary(Appirio JDC) Updated class for Task T-257870.
//                  : March 31, 2014 Kapil Choudhary(Appirio JDC)
//                  : May 2 2014 Virendra updates on chatter for T-257870

global class SignUpWebService2 {
    
    
    public static SignUpResult result = new SignUpResult();
    //method to create new user
    public static Savepoint spContact = Database.setSavepoint();
    // Defines the web service and its parameters
    webService static SignUpResult createuser(String FirstName,String LastName, String EmailId,String Phone, string Prefix, string Suffix,
                                      String newpassword,string contactId,String WebsiteSystemId, String WebsiteSystemSource, String Campaign, String SubSource, 
                                      String AddressLine1, String AddressLine2,String City, String State, String Zip, String Country, String sendEmail) {
    //Fetch profile and account for community profile user.
    Profile addUpProfile = [SELECT Id FROM profile WHERE name='Addup User'];
    string userID;
    Boolean tempEmailStatus;
    //Sets the flag to determine whether to send an email to the new user upon account creation
    if (sendEmail=='Yes' || sendEmail=='yes' || sendEmail=='YES'){
      tempEmailStatus=true;
    }

    string tempCampaign = Campaign;
    Campaign siteCampaign;
    for(Campaign cmp : [SELECT Id FROM Campaign WHERE External_ID__c = :tempCampaign limit 1]){
        siteCampaign = cmp;
    }
     
     //Searches for an existing contact 
     for(Contact existingCon : [select id,FirstName,LastName,HomePhone,Website_System_Id__c,Website_Name__c,Original_Campaign__c,MailingCity,MailingState,MailingPostalCode,MailingCountry,
                               MailingStreet, CastIron_Integration_Status__c from contact where email=:EmailId AND RecordType.Name = 'Household']){
        ContactDetail usrCon = new ContactDetail();
        usrCon.Id = existingCon.id;
        usrCon.FirstName = existingCon.FirstName;
        usrCon.LastName  = existingCon.LastName;
        usrCon.Phone     = existingCon.HomePhone;
        usrCon.WebsiteSystemId = existingCon.Website_System_Id__c;
        usrCon.WebsiteSystemSource = existingCon.Website_Name__c;
        usrCon.City = existingCon.MailingCity;
        usrCon.State = existingCon.MailingState;
        usrCon.Zip = existingCon.MailingPostalCode;
        usrCon.Country = existingCon.MailingCountry ;
        usrCon.AddressLine1 = existingCon.MailingStreet;
                
        system.debug('existingCon>>> '+existingCon);
        result.userContactList.add(usrCon);
     }

  
//    The main method. We put it a try/catch loop so that if there is an error we can revert
            
    try{
        Contact con ;
         /*
        *UC-1
        *Web service is called, and provided email address does not match any existing Contacts:
        *Create a new contact using details provided.
        *Create a new Customer Community Login user associated with the Contact just created. 
        *Return UserCreated message.
       */  
        if(result.userContactList.isEmpty()){
           con = new Contact(
            rC_Bios__Home_Email__c = EmailId,
            Email = EmailId,
            HomePhone = Phone,
            Website_System_Id__c = WebsiteSystemId,
            Website_Name__c = WebsiteSystemSource,
            SubSource__c = SubSource,
            Salutation = Prefix,
            rC_Bios__Preferred_Email__c = 'Home',
            CastIron_Integration_Status__c = 'In Transit',
            rC_Bios__Preferred_Contact__c = true,
            rC_Bios__Suffix__c = Suffix);
            IF(FirstName.length() > 20){
              con.FirstName = FirstName.substring(0, 20);
            } else {
              con.FirstName = FirstName;
            }
            IF(LastName.length() > 22){
              con.LastName = LastName.substring(0, 22);
            } else {
              con.LastName = LastName;
            }
            string clubName = FirstName+ ' ' +LastName;
            If (clubName.length() > 30) {
              clubName = clubName.substring(0, 30);
            } else {
              con.Club_FullName__c = clubName;
            } 
            If (Phone!=null && Phone!=''){
              con.rC_Bios__Preferred_Phone__c = 'Home';
            }
           
           //Create New Account  and associate contact with this new account
           Id siteCampaignId;
           if(siteCampaign != null){
              con.Original_Campaign__c = siteCampaign.Id;
              siteCampaignId = siteCampaign.Id;
           }
           Id accountId = insertContactAccount(FirstName + ' ' + LastName, siteCampaignId, emailId);
           con.AccountId = accountId;
           
           insert con;

           /* Insert contact address to custom Object 
              Make the call an @future call (doing this to speed up the web service, since even if the address call fails it's not that important).
          */    
           SignUpWebService_AddressHelper.insertAccountAddress(accountId, AddressLine1, AddressLine2, City, State, Zip, Country);
      
           // Insert new User for new Contact
           userID = insertNewUser(FirstName,LastName,EmailId, Phone,con.id,addUpProfile.Id,newPassword, tempEmailStatus);
           result.userId = userID;                                 
           system.debug('New Contact'+ con);
           ContactDetail usrCon = new ContactDetail();
           usrCon.Id =     Con.id;
           usrCon.FirstName = Con.FirstName;
           usrCon.LastName  = Con.LastName;
           usrCon.Phone     = Con.Phone;
           usrCon.AccountId = accountId;
           usrCon.WebsiteSystemId = Con.Website_System_Id__c ;
           usrCon.WebsiteSystemSource = Con.Website_Name__c;
           usrCon.Campaign = Con.Original_Campaign__c;
           usrCon.City = Con.MailingCity ;
           usrCon.State = Con.MailingState ;
           usrCon.Zip  = Con.MailingPostalCode;
           usrCon.Country  = Con.MailingCountry;
           result.userContactList.add(usrCon);
           return result;
        } else if(!result.userContactList.isEmpty()){
              if(result.userContactList.size()==1){
                 /*UC-5
                  *Web service is called, and provided email address matches and existing addUp User record.
                  *Return UserAlreadyExists error message.
                 */ 
                   for(user usr : [select id from user where email =:EmailId and profileId=:addUpProfile.Id]){
                            result.messageText = 'User already exists with this email.';
                            system.debug(':: Return Result ::User Already Exist::');
                            result.isSuccess = false;
                            return result;
                   }
                   
                  /*
                  * UC-2
                  * Web service is called, and provided email address matches a single existing Contact.
                  * Create a new Customer Community Login user associated with the existing Contact.
                  * Return UserCreated message.
                  */  
                 contactId = result.userContactList.get(0).Id;
              }
              
              /*
               *UC-4
               *Web service is called, and Contact Id is provided.
               *Create a new Customer Community Login user associated with the existing Contact.
               *Return UserCreated message.
               *(New use case - and would be a follow up call after UC-3 occurs).
              */
              if(contactId != null){
                  Contact eCon = [Select Id, Website_System_Id__c from Contact WHERE Id = :contactId Limit 1];
                  eCon.Website_System_Id__c = WebsiteSystemId;
                  update eCon;
                  userID = insertNewUser(FirstName,LastName,EmailId, Phone,contactId,addUpProfile.Id,newPassword, tempEmailStatus);
                  result.messageText = 'User Successfully Created';
                  result.isSuccess = true;
                  result.userId = userID;
                  return result;
              }
        }
        
        
      }catch(Exception ex){
            result.messageText = ex.getMessage();
            result.isSuccess = false;
            system.debug('::::Exception >>>>>>>>>>>>>>>>>>>>>>'+ex);
            Database.rollback(spContact);
      }   
        /* UC-3
         *Web service is called, and provided email address matches multiple existing Contacts.
         *Return the list of Contacts to the caller, with the following fields:
         *First Name, Last Name, Phone, Id
        */
        return result;
   }
   
   private static string insertNewUser(String FirstName,String LastName, String EmailId,String Phone,
                                       string contactId, string profileId,String newPassword, Boolean sendEmailStatus){
        string aliasText = '';
            if(FirstName != null && FirstName != '' && Lastname.length()>1){
                    
                    aliasText = FirstName.substring(0,1);
            }
            if(Lastname != null && Lastname != '' && Lastname.length()>2){
                aliasText += Lastname.substring(0,3);
            }
            else{
                aliasText +=Lastname;
            }
        String myNickName = '';
        If (EmailId.length() > 40) {
          myNickName = EmailId.substring(0, 40);
        } else {
          myNickName = EmailId;
        }
       
        User usr = new User(firstName = FirstName,
                                    lastName = LastName,
                                    Email = EmailId,
                                    Phone = Phone,
                                    CommunityNickname = myNickName,
                                    languagelocalekey = 'en_US',
                                    localesidkey = UserInfo.getLocale(),
                                    emailEncodingKey = 'UTF-8',
                                    timeZoneSidKey = 'America/Los_Angeles', 
                                    profileId = profileId,
                                    userName = EmailId,
                                    Initial_Password__c = newPassword,
                                    ContactId = contactId,
                                    alias = aliasText );
            Savepoint spUsr = Database.setSavepoint();
            try {            
              insert usr;
              if(newPassword != null) {
                system.debug('=====User Id ::'+usr.Id+'::<< Set new password >>>:::'+newpassword+':::');
                system.setPassword(usr.Id, newpassword);
              }
              result.messageText = 'User Successfully Created';
              result.isSuccess = true;
            }catch(Exception ex){
              result.messageText = ex.getMessage();
              result.isSuccess = false;
              if (result.messageText.contains('DUPLICATE_USERNAME') ){
                result.messageText='Error Creating user: User name already used';
              }
              database.rollback(spContact);

            }
            if (usr.id != null){
              result.userId = usr.id;
            }
            
            system.debug('NewUser>>> '+ usr);
            
           
           // checks to see if there was an error - if there is an error no email will be sent
           // also checks the sendEmail flag to make sure it should send an email
           if (result.isSuccess==true && sendEmailStatus==true) {
             system.debug('Email Sent!');
             List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             mail.setTargetObjectId(usr.Id);
             EmailTemplate templateId = [Select Id from EmailTemplate WHERE Name='AddUP: Welcome Email_New_User' Limit 1];
             mail.setTemplateId(templateId.Id);
             mail.setSaveAsActivity(false);
             OrgWideEmailAddress owa = [Select Id from OrgWideEmailAddress WHERE DisplayName = 'AddUP' Limit 1];
             mail.setOrgWideEmailAddressId(owa.id);
             mails.add(mail);
             Messaging.sendEmail(mails);
           } else {
             system.debug('Email not sent: isSuccess=' + result.isSuccess + ' & sendEmailStatus=' + sendEmailStatus);
           } 
            
            return string.valueof(usr.Id);
    }

   
     /*
    *  Method created as per updates by Tim Parker on T-257870
    *  to Create New Account and associate contact to this account 
    */
    private static Id insertContactAccount(String accName, Id accCampaign, String accEmail){
        Account newAccount = new Account();
        Id  houseHoldType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        // Restricting Account Name to 30 characters to comply with backend system rules
        If (accName.length() > 30) {
          accName = accName.substring(0, 30);
        }
        newAccount.name = accName;
        newAccount.RecordTypeId = houseHoldType;
        newAccount.Original_Campaign__c = accCampaign;
        newAccount.Club_System_Salutation__c = accName;
        newAccount.Email__c = accEmail;
        newAccount.CastIron_Integration_Status__c = 'In Transit';
        insert newAccount;
        return newAccount.id;
    }
    
    
    global class SignUpResult{
        webservice  string messageText{get;set;}
        webservice boolean isSuccess{get;set;}
        webservice string userId{get;set;}
        webservice list<ContactDetail> userContactList{get;set;}
         public SignUpResult(){
            isSuccess = false;
            userContactList = new list<ContactDetail>();
        }
        
    }
    global class ContactDetail{
        webservice String Id{get;set;}
        public String FirstName{get;set;}
        public String LastName{get;set;}
        public String Phone{get;set;}
        public String AccountId {get;set;}
        public String WebsiteSystemId{get;set;}
        public String WebsiteSystemSource{get;set;}
        public String Campaign{get;set;}
        public String AddressLine1{get;set;}
        public String AddressLine2{get;set;}
        public String City{get;set;}
        public String State{get;set;}
        public String Zip{get;set;}
        public String Country{get;set;}
    }
}