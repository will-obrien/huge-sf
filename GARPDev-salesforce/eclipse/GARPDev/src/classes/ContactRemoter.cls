public without sharing class ContactRemoter {
    public class TempAccount {
        public String Email {get;set;}
        public String HomePhone {get;set;}
        public String FirstName {get;set;}
        public String LastName {get;set;}
        public String AccountId {get;set;}
        public String MailingStreet {get;set;}
        public String MailingCity {get;set;}
        public String MailingCountry {get;set;}
        public String MailingPostalCode {get;set;}
        public String MailingState {get;set;}
        public String BillingStreet {get;set;}
        public String BillingCity {get;set;}
        public String BillingCountry {get;set;}
        public String BillingPostalCode {get;set;}
        public String BillingState {get;set;}
        public String BillingPhoneNumber {get;set;}
        public String Company {get;set;}
        public String EmailVerify {get;set;}
        public String JobFunction {get;set;}
        public String Membership_Type {get;set;}
        public String Middle_Initial {get;set;}
        public String MobilePhone {get;set;}
        public String NickName {get;set;}
        public String Organization {get;set;}
        public String Salutation {get;set;}
        public String School_Course {get;set;}
        public String Title {get;set;}
        public String Years_of_Experience {get;set;}
        public String Degree_Program_Name {get;set;}
        public string sameShip {get;set;}
        public string promotion {get;set;}
        public string agreement {get;set;}
        public string timeStamp {get;set;}
        public string billingForeignState {get;set;}
        public string billingZipCode {get;set;}
        public string billingAddress {get;set;}
    }
    @RemoteAction
    public static void addAccount(TempAccount contact){
   contact conlist = [select ID,Primary_Email__C from contact where Primary_Email__C =:contact.Email];
            system.debug('@@@@@@@@:'+conlist);
      if(conlist != null){
       
        /*Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {contact.Email};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('support@brooklyntronic.com');
        mail.setSubject('Welcome to Garp!');
        mail.setPlainTextBody('Your Account has been created.');
        mail.setHtmlBody('<p>Your Account has been created.</p>');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
        Contact acct = new Contact(id =conlist.id );
        
        acct.Primary_Email__c = contact.Email.toLowercase();
        acct.LastName = contact.LastName;
        acct.MailingCity = contact.MailingCity;
        acct.MailingCountry = contact.MailingCountry;
        acct.MailingStreet = contact.MailingStreet;
        acct.Email = contact.Email;
        acct.HomePhone = contact.HomePhone;
        acct.FirstName = contact.FirstName;
        acct.MailingPostalCode = contact.MailingPostalCode;
        acct.MailingState = contact.MailingState;
        acct.Company__c = contact.Company;
        acct.Job_Function__c = contact.JobFunction;
        acct.Membership_Type__c = contact.Membership_Type;
        acct.Middle_Initial__c = contact.Middle_Initial;
        acct.MobilePhone = contact.MobilePhone;
        acct.NickName__c = contact.NickName;
        acct.Salutation = contact.Salutation;
        acct.School_Course__c = contact.School_Course;
        acct.Title = contact.Title;
        acct.Years_of_Experience__c = contact.Years_of_Experience;
        acct.Degree_Program_Name__c = contact.Degree_Program_Name;
        acct.NickName__c = contact.NickName;
        update acct;
    }}
    @RemoteAction
    public static void addContactInfo (TempAccount contact){
        Contact acct = new Contact();
        acct.Primary_Email__c = contact.Email;
        acct.FirstName = contact.FirstName;
        acct.LastName = contact.LastName;
        acct.MailingCity = contact.MailingCity;
        acct.MailingCountry = contact.MailingCountry;
        acct.MailingStreet = contact.MailingStreet;
        insert(acct);
        
    }
        
 @RemoteAction
    public static Id GetMember(Lead lead){
        ID leadId = Registration.GetMember(lead.Email,lead.FirstName,lead.LastName);
        return leadId;
        
    }
    
    @RemoteAction
    public static void convertLead(Lead leadRecord){
        Registration.convertLead(leadRecord);
        
    }
}