/*********************************************************************
Name : UpdateExistingLeadsAndContacts 
Created On : dec 19, 2011  
Created By : Lalit Bohra
Description : Trigger on Lead UpdateExistingLeadsAndContacts 
modifications : New changes being made in lead insertion scenario (28/12/2011)
**********************************************************************/

trigger UpdateExistingLeadsAndContacts on Lead (before insert) {  
    if(Trigger.new != null && (Trigger.new[0].Z_Source__c != 'eCommerce' && Trigger.new[0].Z_Source__c != 'Salesgateway')){
   /*if(!(Test.isRunningTest())){
   Bypassrules__c profileCustomSetting = Bypassrules__c.getInstance(UserInfo.getUserId());
    if(!(profileCustomSetting.Trigger_Objects__c.contains('Lead')
       && profileCustomSetting.Disable_Triggers__c)){*/
    //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
    // getting the PGI Integration User Id for updating the lead.LeadSource when ever record is being inserted by PGI ntegration User.
    if(test.isRunningTest() || UserInfo.GetUserId() == PGIAppConstants.PGI_INTEGRATION_USERID){ 
        //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
        Boolean isInActiveTrigger = false;
        if(!Test.isRunningTest()){
            isInActiveTrigger = Trigger_Settings__c.getInstance(UserInfo.getProfileId()).InactivateUpdateExistingLeadsAndContacts__c;
        }

        if(isInActiveTrigger == false){    
            set<String> DuplicateEmailSet= new set<String>();
            list<Lead> LeadUpsertList = new list<Lead>();   
            list<Contact> ContactUpsertList = new list<Contact>(); 
            set<Id> LeadsUpdatedWithUserIds = new set<Id>();
            set<String> UserIdSet = new set<String>();  
            set<String> LeadEmailSet = new set<String>();
            map<String,Lead> LeadMapOnEmail= new map<String,Lead>(); 
            set<String> ConvertedContactsEmail= new set<String>();
            set<String> LeadsEmails = new set<String>();    
            set<String> LeadsByUserIdTobeDeleted= new set<String>();
            map<String,Id> UserEmailMap = new map<String,Id>();
            set<String> LeadContactsEmailSet = new set<String>(); 
            set<String> LeadContactsUserIdSet = new set<String>();
            set<String> LeadSalesRepEmailSet = new set<String>();
            map<String,Contact> ContactEmailMap = new map<String,Contact>();
            Id SysAdminId;
            list<database.LeadConvert> listLeadConverts= new list<database.LeadConvert>();
            String convertedStatus=null;
            set<Id> leadOwnerIdSet = new set<Id>();
            
            for(Lead objLead:trigger.new){
                    // a new update is being made when ever data gets inerted from pgi integration user the standard field company will get 
                    // populated with 'Unknown Trials'. T-20423 
                    objLead.Company='Unknown Trials';
                    
                    // if this lead is inserted by Pgi Integration user we will change the Lead source as Customer DB. dated 28/12/2011 
                    if(objLead.OwnerId == PGIAppConstants.PGI_INTEGRATION_USERID && objLead.LeadSource != 'Customer DB'){              
                        objLead.LeadSource = 'Customer DB';
                    }
                    // storing all the IM User Id in set
                    if(objLead.IM_USER_ID__c != null && objLead.IM_USER_ID__c !='' && objLead.Email==null){
                        UserIdSet.add(objLead.IM_USER_ID__c);
                    }   
                    // storing all the Lead Emails in set
                    if(objLead.Email != null && objLead.Email !=''){
                        LeadEmailSet.add(objLead.Email);
                    } 
                    
                    // storing all the Lead TESLA_SALESMANAGER_ID__c in set for fetching all the users 
                    if(objLead.IM_SALESREP_EMAIL__c != null && objLead.IM_SALESREP_EMAIL__c !=''){
                        LeadSalesRepEmailSet.add(objLead.IM_SALESREP_EMAIL__c);
                    } 
                    
                    // Creating a map of leads where we will use Email as key for storing values
                    if(!LeadMapOnEmail.ContainsKey(objLead.Email)){
                        LeadMapOnEmail.put(objLead.Email,objLead);
                    }
                    
                    leadOwnerIdSet.add(objLead.OwnerId);
            }
            
            
                 //This below list data will be required for making a lead converted.
                list<LeadStatus> LeadStatusList=[Select MasterLabel from LeadStatus Where IsConverted=true limit 1];       
                if(LeadStatusList !=  null && LeadStatusList.size()>0){
                    convertedStatus=LeadStatusList.get(0).MasterLabel;
                }
                
               // getting the system administrator id for updating the lead records where lead.to_be_deleted is true
                SysAdminId= PGIAppConstants.PGI_INTEGRATION_USERID;
               
                system.debug('------------ UserIdSet'+UserIdSet);
                system.debug('------------ LeadEmailSet'+LeadEmailSet);
                system.debug('------------ LeadMapOnEmail'+LeadMapOnEmail);
                system.debug('------------ LeadSalesRepEmailSet'+LeadSalesRepEmailSet);
                
                // getting all the existing contact on basis of IM User Id field
                if(UserIdSet != null && UserIdSet.size()>0){
                    for(Contact con:[Select id,IM_USER_ID__c from Contact where IM_USER_ID__c in:UserIdSet]){
                        LeadContactsUserIdSet.add(con.IM_USER_ID__c);
                    }
                    system.debug('------------ LeadContactsUserIdSet'+LeadContactsUserIdSet);
                }   
                
                if(LeadEmailSet != null && LeadEmailSet.size()>0){
                    // We are fetching existing contacts where we have an match of email id versus Lead email set and IM_USER_ID__c 
                    // should not match with lead IM_USER_ID__c 
                   for(Contact con:[Select id,AccountId,Email,IM_AVGATTENDEES__c,IM_BILLINGSTARTDATE__c,IM_BILLTOFIRSTNAME__c,IM_BILLTOLASTNAME__c,IM_COMPANY__c,IM_CREDITCARDONFILE__c,IM_LAST_IMEET_ROOM_LOGIN__c
                        ,IM_LAST_ROOM_LOGIN__c,IM_LOCATION__c,IM_MAXATTENDEES__c,IM_MEETINGSLAST30DAYS__c,IM_MEETINGSLAST60DAYS__c,IM_MEETINGSLAST90DAYS__c,
                        IM_MOSTRECENTMEETING__c,IM_OFFEREXPIRES__c,IM_PGI_ACCT_ID__c,IM_PGICLIENTID__c,IM_PHONE_1__c,IM_PHONE_2__c,IM_ROOM_URL__c,IM_SIGN_UP_DATE__c,
                        IM_TEXT_NOTIFICATION__c,IM_TOTAL_MEETINGS__c,IM_UPDATED_AT__c,IM_USAGEDELETEDATE__c,IM_USER_ID__c,IM_WEBCAMUSED__c,IM_ACCOUNT_CANCELLED__c 
                        from Contact where Email in:LeadEmailSet and IM_USER_ID__c not in: LeadContactsUserIdSet And AccountId != null]){
                        
                        // updating contact fields from new lead fields
                        if(LeadMapOnEmail.ContainsKey(con.Email)){              
                            Lead NewLead=LeadMapOnEmail.get(con.Email);
                            UpdateExistingContactFromNewLead(con,NewLead);
                            ContactUpsertList.add(con);
                            LeadContactsEmailSet.add(con.Email);
                            if(!ContactEmailMap.ContainsKey(con.Email)){
                                ContactEmailMap.put(con.Email,con);
                            }
                            // Update new lead with to be deleted status =true as we have updated the existing contact with this lead information in system                
                             system.debug('------------ NewLead.To_be_Deleted__c'+NewLead.To_be_Deleted__c);
                            NewLead.To_be_Deleted__c=true;
                        }            
                    }
                   system.debug('------------ LeadContactsEmailSet'+LeadContactsEmailSet);
                    // updating existing contacts
                    if(ContactUpsertList != null && ContactUpsertList.size()>0){
                        update ContactUpsertList;
                    }
                    
                     // updating existing leads on basis of Email address 
                     list<Lead> ExistingLeadList=[Select OwnerId,IsConverted,Id,Email,To_be_Deleted__c,Company_Name_Kana__c,Company_Name_Kanji__c,Department__c,IM_ACCOUNT_CANCELLED__c,
                     IM_AVGATTENDEES__c,IM_BILLINGSTARTDATE__c,IM_BILLTOFIRSTNAME__c,IM_BILLTOLASTNAME__c,IM_COMPANY__c,IM_CREDITCARDONFILE__c,IM_LAST_IMEET_ROOM_LOGIN__c,
                     IM_LAST_ROOM_LOGIN__c,IM_LOCATION__c,IM_MAXATTENDEES__c,IM_MEETINGSLAST30DAYS__c,IM_MEETINGSLAST60DAYS__c,IM_MEETINGSLAST90DAYS__c,IM_MOSTRECENTMEETING__c
                     ,IM_OFFEREXPIRES__c,IM_PGI_ACCT_ID__c,IM_PGICLIENTID__c,IM_PHONE_1__c,IM_PHONE_2__c,IM_ROOM_URL__c,TESLA_SALESMANAGER_ID__c,IM_SIGN_UP_DATE__c,
                     IM_TEXT_NOTIFICATION__c,IM_TOTAL_MEETINGS__c,IM_UPDATED_AT__c,IM_USAGEDELETEDATE__c,IM_USER_ID__c,IM_WEBCAMUSED__c,
                      Industry__c, Notes__c,Number_of_Licenses_Users__c,Omniture_Campaign_Code__c,Product_Interest__c,Referring_URL__c,
                     Channel__c,ConvertedContactId From Lead l where Email in:LeadEmailSet and To_be_Deleted__c=false and IsConverted=false];
                     set<Id> ExistingLeadOwnerIdSet= new set<Id>();
                     
                     for(Lead objLead:ExistingLeadList){
                        ExistingLeadOwnerIdSet.add(objLead.OwnerId);
                     }                   
                     map<Id,User>  UserWithoutQueueMap=new map<Id,User>([Select id from User where Id in:ExistingLeadOwnerIdSet]);
                     list<Lead> LeadsWithUserAsQueue= new list<Lead>();
                     system.debug('--------------------- ExistingLeadList'+ExistingLeadList);
                       system.debug('--------------------- UserWithoutQueueMap'+UserWithoutQueueMap);
                    for(Lead objExistingLead:ExistingLeadList){
                        // here we will update only those leads which does not have converted into contact yet
                        //if(!LeadContactsUserIdSet.Contains(objExistingLead.IM_USER_ID__c)  && !LeadContactsEmailSet.Contains(objExistingLead.Email)){
                         // if(objExistingLead.IsConverted==false){
                            //here we need to update leads from LeadMapOnEmail map; 
                            if(LeadMapOnEmail.ContainsKey(objExistingLead.Email)){
                                Lead NewLead=LeadMapOnEmail.get(objExistingLead.Email);
                                system.debug('-------------- updating records');   
                                if(!DuplicateEmailSet.Contains(objExistingLead.Email)){
                                    UpdateLeadFields(objExistingLead,NewLead);
                                    DuplicateEmailSet.add(objExistingLead.Email);
                                    
                                }
                                 LeadUpsertList.add(objExistingLead);
                                // converting the existing lead into converted lead.Here we can not convert the existing lead if the associated contact with lead 
                                // does not have account.          
                                system.debug('-------------------- objExistingLead.Email'+objExistingLead.Email);
                                 system.debug('-------------------- LeadContactsEmailSet'+LeadContactsEmailSet);  
                                  system.debug('-------------------- ContactEmailMap'+ContactEmailMap);              
                                if(LeadContactsEmailSet.Contains(objExistingLead.Email) && ContactEmailMap.ContainsKey(objExistingLead.Email)
                                && ContactEmailMap.get(objExistingLead.Email).AccountId != null){
                               
                                    if(UserWithoutQueueMap.ContainsKey(objExistingLead.OwnerId)){   
                                      
                                        database.LeadConvert leadConvert = new Database.LeadConvert();
                                        leadConvert.leadId = objExistingLead.Id;                           
                                        leadConvert.contactId = ContactEmailMap.get(objExistingLead.Email).Id;
                                        leadConvert.accountId = ContactEmailMap.get(objExistingLead.Email).AccountId;                           
                                        leadConvert.convertedStatus=convertedStatus;
                                         // Added by JP to avoid creation of Opportunities on Lead Conversion -Jan 9,2013
                                        leadConvert.setDoNotCreateOpportunity(true);
                                         // End
                                        system.debug('-----------------------------leadConvert'+leadConvert);
                                        listLeadConverts.add(leadConvert);
                                    }
                                    else{
                                        LeadsWithUserAsQueue.add(objExistingLead);
                                    }
                                }
                               
                                // updating the new records with to be deleted = true and making the external id to change with 
                                //dummy text since these external id will be copy to existing records;
                               system.debug('------------ NewLead.To_be_Deleted__c'+NewLead.To_be_Deleted__c);
                                NewLead.To_be_Deleted__c=true;   
                                if(NewLead.is1__Chat_ID__c != null && NewLead.is1__Chat_ID__c!='' &&  !NewLead.is1__Chat_ID__c.Contains('_Duplicate')){  
                                    system.debug('---------- before NewLead.is1__Chat_ID__c'+NewLead.is1__Chat_ID__c); 
                                    NewLead.is1__Chat_ID__c=NewLead.is1__Chat_ID__c+'_Duplicate';
                                   system.debug('---------- After NewLead.is1__Chat_ID__c'+NewLead.is1__Chat_ID__c);
                                }
                                if(NewLead.is1__Mail_ID__c != null && NewLead.is1__Mail_ID__c!='' &&  !NewLead.is1__Mail_ID__c.Contains('_Duplicate')){
                                    NewLead.is1__Mail_ID__c=NewLead.is1__Mail_ID__c+'_Duplicate';           
                                }                                
                                if(NewLead.IM_USER_ID__c != null && NewLead.IM_USER_ID__c!='' &&  !NewLead.IM_USER_ID__c.Contains('_Duplicate')){
                                    NewLead.IM_USER_ID__c=NewLead.IM_USER_ID__c+'_Duplicate';           
                                }   
                            }                   
                        //}
                    }
                    // updating the existing leads with new leads information
                    if(LeadUpsertList != null && LeadUpsertList.size()>0){
                        system.debug('------------ LeadUpsertList'+LeadUpsertList);
                        update LeadUpsertList;
                    }
                    if(LeadsWithUserAsQueue.size()>0){
                       system.debug('-----------------------------LeadsWithUserAsQueue'+LeadsWithUserAsQueue);
                      system.debug('-----------------------------LeadsWithUserAsQueue.size()'+LeadsWithUserAsQueue.size());
                        for(Lead lead:LeadsWithUserAsQueue){
                            lead.OwnerId=PGIAppConstants.PGI_INTEGRATION_USERID;
                            lead.Ignore_Assignment_Rule__c=true;
                        }
                        update LeadsWithUserAsQueue;
                        for(Lead lead:LeadsWithUserAsQueue){
                            database.LeadConvert leadConvert = new Database.LeadConvert();
                            leadConvert.leadId = lead.Id;                           
                            leadConvert.contactId = ContactEmailMap.get(lead.Email).Id;
                            leadConvert.accountId = ContactEmailMap.get(lead.Email).AccountId;                           
                            leadConvert.convertedStatus=convertedStatus;
                            // Added by JP to avoid creation of Opportunities on Lead Conversion -Jan 9,2013
                            leadConvert.setDoNotCreateOpportunity(true);
                            // End
                            system.debug('-----------------------------leadConvert'+leadConvert);
                            listLeadConverts.add(leadConvert);
                        }
                    }
                    // inserting the new leadStatus list for updating existing leads as converted           
                    if(listLeadConverts != null && listLeadConverts.size()>0){
                        system.debug('------------ listLeadConverts'+listLeadConverts);
                        system.debug('------------ listLeadConverts.size()'+listLeadConverts.size());
                        Database.convertLead(listLeadConverts);
                    }        
                }// end (if(LeadEmailSet != null && LeadEmailSet.size()>0))
                
                if(LeadSalesRepEmailSet != null && LeadSalesRepEmailSet.size()>0){
                    // creatng a user map for updating the owner of new leads  
                    for(User user:[Select Id,UserName from User where UserName in:LeadSalesRepEmailSet]){
                        if(!UserEmailMap.containsKey(user.UserName)){
                            UserEmailMap.put(user.UserName,user.Id);
                        }
                    }
                    system.debug('------------ UserEmailMap'+UserEmailMap);     
                }
                
                map<Id, User> nonAdminUserMap = new map<Id, User>([SELECT Id, Name, Region__c, Channel__c, Location__c, Manager.Name FROM User WHERE Id in :leadOwnerIdSet AND (NOT Profile.Name like:'System Administrator%')]);
                                                
                // Assignment of sales rep to as owner of Lead.  
                //list<AssignmentRule> AssignmentRuleList=[Select a.Name, a.Id From AssignmentRule a where Name='Round Robin'];
                for(Lead objLead:trigger.new){   
                    system.debug('------------------- objLead.TESLA_SALESMANAGER_ID__c'+objLead.TESLA_SALESMANAGER_ID__c);
                    system.debug('------------------- objLead.To_be_Deleted__c'+objLead.To_be_Deleted__c);           
                    if(objLead.IM_SALESREP_EMAIL__c != null  && objLead.IM_SALESREP_EMAIL__c != '' && 
                    UserEmailMap.ContainsKey(objLead.IM_SALESREP_EMAIL__c) &&               
                    objLead.OwnerId != UserEmailMap.get(objLead.IM_SALESREP_EMAIL__c) && objLead.To_be_Deleted__c==false){
                        system.debug('------------ Changing owner+objLead.Email'+objLead.Email);
                        objLead.OwnerId=UserEmailMap.get(objLead.IM_SALESREP_EMAIL__c);
                        system.debug('------------------ objLead.OwnerId'+objLead.OwnerId);
                        // need to put code her for putting the non admin user data issue I-16579.
                        
                        if(nonAdminUserMap != null && nonAdminUserMap.ContainsKey(objLead.OwnerId)){
                            system.debug(' --------------- putting owner values to lead ');
                            User user = nonAdminUserMap.get(objLead.OwnerId);
                            objLead.Owner_Region__c = user.Region__c;                         
                            objLead.Channel__c = user.Channel__c;
                            objLead.Location__c = user.Location__c;
                            objLead.Supervisor__c = user.Manager.Name;
                            objLead.Ignore_Assignment_Rule__c=true;
                        }
                    }        
                    // condition for running the assignment rule if we cant assign user      
                    /*else if(!UserEmailMap.ContainsKey(objLead.IM_SALESREP_EMAIL__c) && objLead.To_be_Deleted__c==false &&
                    AssignmentRuleList != null && AssignmentRuleList.size()>0){ */
                     else if(!UserEmailMap.ContainsKey(objLead.IM_SALESREP_EMAIL__c) && objLead.To_be_Deleted__c==false){ 
                        //system.debug('------------ calling the AssignmentRule');
                        //system.debug('---------------- objLead.Round_Robin_ID__c'+ objLead.Round_Robin_ID__c);
                        database.DMLOptions dmo = new database.DMLOptions();     
                        dmo.AssignmentRuleHeader.UseDefaultRule= true;  
                        //system.debug('------------ aalist.get(0).Id;   '+AssignmentRuleList.get(0).Id);
                        //dmo.AssignmentRuleHeader.assignmentRuleID=AssignmentRuleList.get(0).Id;           
                        objLead.setOptions(dmo); 
                    }
                    // here we need to update the all leads owner to  system administrator where leads.to_be_deleted=true
                    else if(objLead.To_be_Deleted__c==true && SysAdminId != null){
                        system.debug('------------ Changing owner as sys admin');
                        objLead.OwnerId=SysAdminId;
                    }           
                }
            }
        //} 
      }
}    
        // this function will copy new lead fields to existing contact
        private void UpdateExistingContactFromNewLead(Contact ExistingContact,Lead NewLead){
            
            try{       
             //   system.debug('we are calling  UpdateExistingContactFromNewLead------------------');
             //   system.debug('------------------ NewLead'+ NewLead);
             
             system.debug('------------------ ExistingContactId'+ ExistingContact.id);
                if(NewLead.IM_AVGATTENDEES__c != null){
                    ExistingContact.IM_AVGATTENDEES__c=NewLead.IM_AVGATTENDEES__c;
                }
                if(NewLead.IM_BILLINGSTARTDATE__c != null){
                    ExistingContact.IM_BILLINGSTARTDATE__c=NewLead.IM_BILLINGSTARTDATE__c;
                }
                if(NewLead.IM_BILLTOFIRSTNAME__c != null && NewLead.IM_BILLTOFIRSTNAME__c !=''){
                    ExistingContact.IM_BILLTOFIRSTNAME__c=NewLead.IM_BILLTOFIRSTNAME__c;
                }
                if(NewLead.IM_BILLTOLASTNAME__c != null && NewLead.IM_BILLTOLASTNAME__c !=''){
                    ExistingContact.IM_BILLTOLASTNAME__c=NewLead.IM_BILLTOLASTNAME__c;
                }
                if(NewLead.IM_COMPANY__c != null && NewLead.IM_COMPANY__c !=''){
                    ExistingContact.IM_COMPANY__c=NewLead.IM_COMPANY__c;
                }
                if(NewLead.IM_CREDITCARDONFILE__c != null){
                    ExistingContact.IM_CREDITCARDONFILE__c=NewLead.IM_CREDITCARDONFILE__c;
                }
                if(NewLead.IM_LAST_IMEET_ROOM_LOGIN__c != null){
                    ExistingContact.IM_LAST_IMEET_ROOM_LOGIN__c=NewLead.IM_LAST_IMEET_ROOM_LOGIN__c;
                }
                if(NewLead.IM_LAST_ROOM_LOGIN__c != null){
                    ExistingContact.IM_LAST_ROOM_LOGIN__c=NewLead.IM_LAST_ROOM_LOGIN__c;
                }
                if(NewLead.IM_LOCATION__c != null && NewLead.IM_LOCATION__c !=''){
                    ExistingContact.IM_LOCATION__c=NewLead.IM_LOCATION__c;
                }
                if(NewLead.IM_MAXATTENDEES__c != null){
                    ExistingContact.IM_MAXATTENDEES__c=NewLead.IM_MAXATTENDEES__c;
                }
                if(NewLead.IM_MEETINGSLAST30DAYS__c != null){
                    ExistingContact.IM_MEETINGSLAST30DAYS__c=NewLead.IM_MEETINGSLAST30DAYS__c;
                }
                if(NewLead.IM_MEETINGSLAST60DAYS__c != null){
                    ExistingContact.IM_MEETINGSLAST60DAYS__c=NewLead.IM_MEETINGSLAST60DAYS__c;
                }
                if(NewLead.IM_MEETINGSLAST90DAYS__c != null){
                    ExistingContact.IM_MEETINGSLAST90DAYS__c=NewLead.IM_MEETINGSLAST90DAYS__c;
                }
                if(NewLead.IM_MOSTRECENTMEETING__c != null){
                    ExistingContact.IM_MOSTRECENTMEETING__c=NewLead.IM_MOSTRECENTMEETING__c;
                }
                if(NewLead.IM_OFFEREXPIRES__c != null){
                    ExistingContact.IM_OFFEREXPIRES__c=NewLead.IM_OFFEREXPIRES__c;
                }
                if(NewLead.IM_PGI_ACCT_ID__c != null && NewLead.IM_PGI_ACCT_ID__c !=''){
                    ExistingContact.IM_PGI_ACCT_ID__c=NewLead.IM_PGI_ACCT_ID__c;
                }
                if(NewLead.IM_PGICLIENTID__c != null && NewLead.IM_PGICLIENTID__c !=''){
                    ExistingContact.IM_PGICLIENTID__c=NewLead.IM_PGICLIENTID__c;
                }
                if(NewLead.IM_PHONE_1__c != null && NewLead.IM_PHONE_1__c !=''){
                    ExistingContact.IM_PHONE_1__c=NewLead.IM_PHONE_1__c;
                }
                if(NewLead.IM_PHONE_2__c != null && NewLead.IM_PHONE_2__c !=''){
                    ExistingContact.IM_PHONE_2__c=NewLead.IM_PHONE_2__c;
                }
                if(NewLead.IM_ROOM_URL__c != null && NewLead.IM_ROOM_URL__c !=''){
                    ExistingContact.IM_ROOM_URL__c=NewLead.IM_ROOM_URL__c;
                }           
                if(NewLead.IM_SIGN_UP_DATE__c != null){
                    ExistingContact.IM_SIGN_UP_DATE__c=NewLead.IM_SIGN_UP_DATE__c;
                }
                if(NewLead.IM_TEXT_NOTIFICATION__c != null && NewLead.IM_TEXT_NOTIFICATION__c !=''){
                    ExistingContact.IM_TEXT_NOTIFICATION__c=NewLead.IM_TEXT_NOTIFICATION__c;
                }
                if(NewLead.IM_TOTAL_MEETINGS__c != null){
                    ExistingContact.IM_TOTAL_MEETINGS__c=NewLead.IM_TOTAL_MEETINGS__c;
                }           
                if(NewLead.IM_UPDATED_AT__c != null ){
                    ExistingContact.IM_UPDATED_AT__c=NewLead.IM_UPDATED_AT__c;
                }
                if(NewLead.IM_USAGEDELETEDATE__c != null ){
                    ExistingContact.IM_USAGEDELETEDATE__c=NewLead.IM_USAGEDELETEDATE__c;
                }
                if(NewLead.IM_USER_ID__c != null && NewLead.IM_USER_ID__c !=''){
                    ExistingContact.IM_USER_ID__c=NewLead.IM_USER_ID__c;
                }
                if(NewLead.IM_WEBCAMUSED__c != null){
                    ExistingContact.IM_WEBCAMUSED__c=NewLead.IM_WEBCAMUSED__c;
                }       
                if(NewLead.IM_ACCOUNT_CANCELLED__c != null){
                    ExistingContact.IM_ACCOUNT_CANCELLED__c=NewLead.IM_ACCOUNT_CANCELLED__c;
                }  
            }
            catch(exception ex){
               // system.debug('----------- exception '+ex);
            }
        }
        
        
        // this function will copy new lead fields to existing lead
        private void UpdateLeadFields(Lead OldLead,Lead NewLead){        
            try{
                system.debug('we are calling  UpdateLeadFields------------------');
                system.debug('------------------ NewLead'+ NewLead);
              
                if(NewLead.Company_Name_Kana__c != null && NewLead.Company_Name_Kana__c !=''){
                    OldLead.Company_Name_Kana__c=NewLead.Company_Name_Kana__c;
                }
                if(NewLead.Company_Name_Kanji__c != null && NewLead.Company_Name_Kanji__c !=''){
                    OldLead.Company_Name_Kanji__c=NewLead.Company_Name_Kanji__c;
                }
                if(NewLead.Department__c != null && NewLead.Department__c !=''){
                    OldLead.Department__c=NewLead.Department__c;
                }       
                if(NewLead.IM_ACCOUNT_CANCELLED__c != null){
                    OldLead.IM_ACCOUNT_CANCELLED__c=NewLead.IM_ACCOUNT_CANCELLED__c;
                }       
                if(NewLead.IM_AVGATTENDEES__c != null){
                    OldLead.IM_AVGATTENDEES__c=NewLead.IM_AVGATTENDEES__c;
                }
                if(NewLead.IM_BILLINGSTARTDATE__c != null){
                    OldLead.IM_BILLINGSTARTDATE__c=NewLead.IM_BILLINGSTARTDATE__c;
                }
                if(NewLead.IM_BILLTOFIRSTNAME__c != null && NewLead.IM_BILLTOFIRSTNAME__c !=''){
                    OldLead.IM_BILLTOFIRSTNAME__c=NewLead.IM_BILLTOFIRSTNAME__c;
                }
                if(NewLead.IM_BILLTOLASTNAME__c != null && NewLead.IM_BILLTOLASTNAME__c !=''){
                    OldLead.IM_BILLTOLASTNAME__c=NewLead.IM_BILLTOLASTNAME__c;
                }
                if(NewLead.IM_COMPANY__c != null && NewLead.IM_COMPANY__c !=''){
                    OldLead.IM_COMPANY__c=NewLead.IM_COMPANY__c;
                }
                if(NewLead.IM_CREDITCARDONFILE__c != null){
                    OldLead.IM_CREDITCARDONFILE__c=NewLead.IM_CREDITCARDONFILE__c;
                }
                if(NewLead.IM_LAST_IMEET_ROOM_LOGIN__c != null){
                    OldLead.IM_LAST_IMEET_ROOM_LOGIN__c=NewLead.IM_LAST_IMEET_ROOM_LOGIN__c;
                }
                if(NewLead.IM_LAST_ROOM_LOGIN__c != null){
                    OldLead.IM_LAST_ROOM_LOGIN__c=NewLead.IM_LAST_ROOM_LOGIN__c;
                }
                if(NewLead.IM_LOCATION__c != null && NewLead.IM_LOCATION__c !=''){
                    OldLead.IM_LOCATION__c=NewLead.IM_LOCATION__c;
                }
                if(NewLead.IM_MAXATTENDEES__c != null){
                    OldLead.IM_MAXATTENDEES__c=NewLead.IM_MAXATTENDEES__c;
                }
                if(NewLead.IM_MEETINGSLAST30DAYS__c != null){
                    OldLead.IM_MEETINGSLAST30DAYS__c=NewLead.IM_MEETINGSLAST30DAYS__c;
                }
                if(NewLead.IM_MEETINGSLAST60DAYS__c != null){
                    OldLead.IM_MEETINGSLAST60DAYS__c=NewLead.IM_MEETINGSLAST60DAYS__c;
                }
                if(NewLead.IM_MEETINGSLAST90DAYS__c != null){
                    OldLead.IM_MEETINGSLAST90DAYS__c=NewLead.IM_MEETINGSLAST90DAYS__c;
                }
                if(NewLead.IM_MOSTRECENTMEETING__c != null){
                    OldLead.IM_MOSTRECENTMEETING__c=NewLead.IM_MOSTRECENTMEETING__c;
                }
                if(NewLead.IM_OFFEREXPIRES__c != null){
                    OldLead.IM_OFFEREXPIRES__c=NewLead.IM_OFFEREXPIRES__c;
                }
                if(NewLead.IM_PGI_ACCT_ID__c != null && NewLead.IM_PGI_ACCT_ID__c !=''){
                    OldLead.IM_PGI_ACCT_ID__c=NewLead.IM_PGI_ACCT_ID__c;
                }
                if(NewLead.IM_PGICLIENTID__c != null && NewLead.IM_PGICLIENTID__c !=''){
                    OldLead.IM_PGICLIENTID__c=NewLead.IM_PGICLIENTID__c;
                }
                if(NewLead.IM_PHONE_1__c != null && NewLead.IM_PHONE_1__c !=''){
                    OldLead.IM_PHONE_1__c=NewLead.IM_PHONE_1__c;
                }
                if(NewLead.IM_PHONE_2__c != null && NewLead.IM_PHONE_2__c !=''){
                    OldLead.IM_PHONE_2__c=NewLead.IM_PHONE_2__c;
                }
                if(NewLead.IM_ROOM_URL__c != null && NewLead.IM_ROOM_URL__c !=''){
                    OldLead.IM_ROOM_URL__c=NewLead.IM_ROOM_URL__c;
                }
                if(NewLead.TESLA_SALESMANAGER_ID__c != null && NewLead.TESLA_SALESMANAGER_ID__c !=''){
                    OldLead.TESLA_SALESMANAGER_ID__c=NewLead.TESLA_SALESMANAGER_ID__c;
                }
                if(NewLead.IM_SIGN_UP_DATE__c != null){
                    OldLead.IM_SIGN_UP_DATE__c=NewLead.IM_SIGN_UP_DATE__c;
                }
                if(NewLead.IM_TEXT_NOTIFICATION__c != null && NewLead.IM_TEXT_NOTIFICATION__c !=''){
                    OldLead.IM_TEXT_NOTIFICATION__c=NewLead.IM_TEXT_NOTIFICATION__c;
                }
                if(NewLead.IM_TOTAL_MEETINGS__c != null){
                    OldLead.IM_TOTAL_MEETINGS__c=NewLead.IM_TOTAL_MEETINGS__c;
                }
                if(NewLead.IM_UPDATED_AT__c != null ){
                    OldLead.IM_UPDATED_AT__c=NewLead.IM_UPDATED_AT__c;
                }
                if(NewLead.IM_USAGEDELETEDATE__c != null ){
                    OldLead.IM_USAGEDELETEDATE__c=NewLead.IM_USAGEDELETEDATE__c;
                }
                if(NewLead.IM_USER_ID__c != null && NewLead.IM_USER_ID__c !=''){
                    OldLead.IM_USER_ID__c=NewLead.IM_USER_ID__c;
                }
                if(NewLead.IM_WEBCAMUSED__c != null){
                    OldLead.IM_WEBCAMUSED__c=NewLead.IM_WEBCAMUSED__c;
                }
                 if(NewLead.Industry__c != null && NewLead.Industry__c !=''){            
                    OldLead.Industry__c=NewLead.Industry__c;
                }

                if(NewLead.Notes__c != null && NewLead.Notes__c !=''){
                    OldLead.Notes__c=NewLead.Notes__c;
                }
                if(NewLead.Number_of_Licenses_Users__c != null){
                    OldLead.Number_of_Licenses_Users__c=NewLead.Number_of_Licenses_Users__c;
                }
                if(NewLead.Omniture_Campaign_Code__c != null && NewLead.Omniture_Campaign_Code__c !=''){
                    OldLead.Omniture_Campaign_Code__c=NewLead.Omniture_Campaign_Code__c;
                }
              
                if(NewLead.Product_Interest__c != null && NewLead.Product_Interest__c !=''){
                    OldLead.Product_Interest__c=NewLead.Product_Interest__c;
                }
                if(NewLead.Referring_URL__c != null && NewLead.Referring_URL__c !=''){
                    OldLead.Referring_URL__c=NewLead.Referring_URL__c;
                }
  
                
                if(NewLead.Channel__c != null && NewLead.Channel__c !=''){
                    OldLead.Channel__c=NewLead.Channel__c;
                }  
    
            }
            catch(exception ex){
               // system.debug('----------- exception '+ex);
            } 
        }
       
}