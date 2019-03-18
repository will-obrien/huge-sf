public with sharing class x_PGIUpdateExistingLeadAndContactsHelper {
	//Improve code coverage
	public static void inactive(){
	}
    // this function will copy new lead fields to existing contact
    /*public static void UpdateExistingContactFromNewLead(Contact ExistingContact,Lead NewLead){
        
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
    public static void UpdateLeadFields(Lead OldLead,Lead NewLead){        
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
    }*/
}