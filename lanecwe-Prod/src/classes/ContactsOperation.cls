@RestResource(urlMapping='/ContactsOperation/*')
global with sharing class ContactsOperation{

    global class ContactsResponse{
        public String errorMessage;
        public String accountId;
        public list<ContactsRecord> contactsList;
    }
    
    global class ContactsRecord{
        public String ContactId;
        public String ContactOwner;
        public String Name;
        public String AccountName;
        public boolean LicenseProfile;
        public String EcommerceAccountNumber;
        public String Phone;
        public String Email;
        public String LeadSource;
        public boolean EcommerceConvert;    
    }
    
    @HttpGet
    global static ContactsOperation.ContactsResponse retrieveContacts(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        ContactsOperation.ContactsResponse  contactsResp = new ContactsOperation.ContactsResponse();
        contactsResp.accountId = accountId;
        list<ContactsRecord> ctRecordLst = new list<ContactsRecord>();
        contactsResp.contactsList = ctRecordLst;
        try{
            for(Contact ct: [select id, owner.name, name, AccountId, Account.name, License_Profile__c, 
                                ECommerce_Account_Number__c, phone, email, LeadSource, ECommerce_Convert__c, 
                                (select id from assets) from contact 
                                where 
                                    contact.accountid = :accountId  and License_Profile__c = true]){
                if(!(ct.assets <> null && ct.assets.size() > 0)){
                    ContactsRecord ctRd = new ContactsRecord();
                    ctRd.ContactId = ct.id;
                    ctRd.ContactOwner   = ct.owner.name;
                    ctRd.Name           = ct.name;
                    ctRd.AccountName        = ct.Account.name;
                    ctRd.LicenseProfile = ct.License_Profile__c;
                    ctRd.EcommerceAccountNumber = ct.ECommerce_Account_Number__c;
                    ctRd.Phone          = ct.Phone;
                    ctRd.Email          = ct.Email;
                    ctRd.LeadSource     = ct.LeadSource;
                    ctRd.EcommerceConvert = ct.ECommerce_Convert__c;
                    ctRecordLst.add(ctRd);
                }
            }
            contactsResp.contactsList = ctRecordLst;
        }
        catch(Exception e){
            contactsResp.errorMessage = e.getMessage();
        }
        
        return contactsResp;
    }
}