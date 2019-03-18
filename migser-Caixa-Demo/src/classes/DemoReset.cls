public class DemoReset {

    public PageReference oneClickDot() {
        DataDotComDemo__c ddcDemo = null;
        DataDotComDemoHelper__c demoRecords = null;
        
        List<DataDotComDemoHelper__c> demoRecordsList = [SELECT Account__c,Contact__c,Lead__c FROM DataDotComDemoHelper__c];
        
        try {
            demoRecords = demoRecordsList[0];
        } catch(Exception e) {
            demoRecords = new DataDotComDemoHelper__c();
        }
        ddcDemo = DataDotComDemo__c.getOrgDefaults();
        
        if(ddcDemo.Id != NULL) {
            delete ddcDemo;
        }
        
        demoRecords.Account__c = dataDotCom.DemoAccount__c;
        demoRecords.Lead__c = dataDotCom.DemoLead__c;
        demoRecords.Contact__c = dataDotCom.DemoContact__c;
        update demoRecords;
        
        
        List<Account> allAccounts = [select id, Never_Reset__c from Account];
        List<Contact> allContacts = [select id, Never_Reset__c from Contact];
        List<Lead> allLeads = [select id, Never_Reset__c from Lead where IsConverted = false];
        
        for(Account a : allAccounts) {
            a.Never_Reset__c  = true;
        }
        
        for(Lead l : allLeads) {
            l.Never_Reset__c  = true;
        }
        
        for(Contact c : allContacts) {
            c.Never_Reset__c  = true;
        }
        
        update allLeads;
        update allAccounts;
        update allContacts;
        
        List<DataDotComDemoHelper__c> demoRecordsListDEL = [SELECT Account__c,Contact__c,Lead__c FROM DataDotComDemoHelper__c where id != :demoRecords.Id];
        delete demoRecordsListDEL;
        
         
        return null;
    }


    public String mode {get; set;}
    

    public Lead dataComDemoLead {get; set;}
    public Account dataComDemoAccount {get; set;}
    public Contact dataComDemoContact {get; set;}
    public String statusMessage {get; set;}
    
    public DataDotComDemoHelper__c ddcHelper {get; set;}
    
    public DataDotComDemo__c dataDotCom {get; set;}
    public DataDotComDemoAccountResetValues__c demoAccountResetValues {get; set;}
    public DataDotComDemoContactResetValues__c demoContactResetValues {get; set;}
    public DataDotComDemoLeadResetValues__c demoLeadResetValues {get; set;}
    
    
    public void setupDefaults() {
        dataDotCom = DataDotComDemo__c.getOrgDefaults();
        demoAccountResetValues = DataDotComDemoAccountResetValues__c.getOrgDefaults();
        demoContactResetValues = DataDotComDemoContactResetValues__c.getOrgDefaults();
        demoLeadResetValues = DataDotComDemoLeadResetValues__c.getOrgDefaults();
        
        if(demoAccountResetValues.Name__c == NULL) {
            demoAccountResetValues.Name__c = 'DOT Green Media';
            demoAccountResetValues.Website__c = 'www.greendotmedia.com';
            demoAccountResetValues.Industry__c = '';
            demoAccountResetValues.BillingStreet__c = '660 Sutter St'; 
            demoAccountResetValues.BillingCity__c = 'San Francisco'; 
            demoAccountResetValues.BillingState__c = 'CO';                                                                
            demoAccountResetValues.BillingPostalCode__c = '94102-1018';
            demoAccountResetValues.BillingCountry__c = 'United States';
            demoAccountResetValues.Phone__c = '415-536-1111';
            demoAccountResetValues.Fax__c = '';
            demoAccountResetValues.Site__c = '';             
            demoAccountResetValues.NumberOfEmployees__c = 50;
            demoAccountResetValues.AnnualRevenue__c = 40000;
            demoAccountResetValues.YearStarted__c = '';
            demoAccountResetValues.NaicsCode__c = '';
            demoAccountResetValues.NaicsDesc__c = '';
            demoAccountResetValues.Ownership__c = '';            
            demoAccountResetValues.Sic__c = '';
            demoAccountResetValues.SicDesc__c = '';
            demoAccountResetValues.DunsNumber__c = '';
            demoAccountResetValues.Tradestyle__c = '';
            demoAccountResetValues.Description__c = '';
        }
        
        if(demoContactResetValues.LastName__c == NULL) {            
            demoContactResetValues.FirstName__c = 'Jason'; 
            demoContactResetValues.LastName__c = 'Brennaman'; 
            demoContactResetValues.Email__c = 'jason.brennaman@greendotmedia.com';
            demoContactResetValues.Phone__c = '';
            demoContactResetValues.MobilePhone__c = null;
            demoContactResetValues.MailingStreet__c = '';
            demoContactResetValues.MailingCity__c = 'San Francisco';
            demoContactResetValues.MailingState__c = 'CA';
            demoContactResetValues.MailingCountry__c = '';
            demoContactResetValues.MailingPostalCode__c = '';
            demoContactResetValues.Title__c = 'Information Technology';
        }
        
        if(demoLeadResetValues.LastName__c == NULL) {
            demoLeadResetValues.FirstName__c = 'S';
            demoLeadResetValues.LastName__c = 'Hartman';
            demoLeadResetValues.Company__c = 'Green Dot Media';
            demoLeadResetValues.Title__c = 'Sales';
            demoLeadResetValues.Email__c = 'sarah.hartman@greendotmedia.com';
            demoLeadResetValues.Phone__c = '';
            demoLeadResetValues.CompanyDunsNumber__c = '';
            demoLeadResetValues.Street__c = '';
            demoLeadResetValues.City__c = '';
            demoLeadResetValues.Country__c = '';
            demoLeadResetValues.PostalCode__c = '';
            demoLeadResetValues.State__c = '';
            demoLeadResetValues.Industry__c = '';
            demoLeadResetValues.NumberOfEmployees__c = null;
            demoLeadResetValues.Annual_Revenue__c = null;
        }
        
        if(dataDotCom.DemoContact__c == NULL || dataDotCom.DemoLead__c == NULL || dataDotCom.DemoAccount__c == NULL) {
            DataDotComDemoHelper__c helper = [Select Lead__c, Account__c, Contact__c from DataDotComDemoHelper__c limit 1];
            
            if(dataDotCom.DemoContact__c == NULL) {
                ddcHelper.Contact__c = helper.Contact__c;
                dataDotCom.DemoContact__c = ddcHelper.Contact__c;    
            } 
            
            if(dataDotCom.DemoLead__c == NULL) {
                ddcHelper.Lead__c = helper.Lead__c;
                dataDotCom.DemoLead__c = ddcHelper.Lead__c;   
            }
            
            if(dataDotCom.DemoAccount__c == NULL) {
                ddcHelper.Account__c = helper.Account__c;
                dataDotCom.DemoAccount__c = ddcHelper.Account__c;
            }      
            
            
            ddcHelper.Reset_Date__c = Date.Today();
            dataDotCom.ResetDataDate__c = ddcHelper.Reset_Date__c;
            
            dataDotCom.Name = 'DATA.COM DEMO';
            Database.upsert(dataDotCom);
            readRecords();
        }   
    }
    
    public DemoReset() {
        ddcHelper = new DataDotComDemoHelper__c();
        dataDotCom = DataDotComDemo__c.getOrgDefaults();
                
        ddcHelper.Contact__c = dataDotCom.DemoContact__c;
        ddcHelper.Lead__c = dataDotCom.DemoLead__c;
        ddcHelper.Account__c = dataDotCom.DemoAccount__c;
        ddcHelper.Reset_Date__c = dataDotCom.ResetDataDate__c;
        
        mode = 'standard';
        
        readRecords();
        
        
    }
    
    public void readRecords() {
        try {
            dataComDemoLead = [select Name from Lead where id =: ddcHelper.Lead__c];
        } catch(Exception ex) {}
        try {
            dataComDemoContact = [select Name from Contact where id =: ddcHelper.Contact__c];
        } catch(Exception ex) {}
        try {
            dataComDemoAccount = [select Name from Account where id =: ddcHelper.Account__c];
        } catch(Exception ex) {}
    }
    
    
    public PageReference saveRecords() {
        statusMessage = '';
        dataDotCom.DemoContact__c = ddcHelper.Contact__c;
        dataDotCom.DemoLead__c = ddcHelper.Lead__c;
        dataDotCom.DemoAccount__c = ddcHelper.Account__c;
        dataDotCom.ResetDataDate__c = ddcHelper.Reset_Date__c;
        dataDotCom.Name = 'DATA.COM DEMO';
        System.debug('Save Settings');
        System.debug('DDC Contact: ' + ddcHelper.Contact__c);
        System.debug('DDC Lead: ' + ddcHelper.Lead__c);
        System.debug('DDC Account: ' + ddcHelper.Account__c);
        //dataDotCom.SetupOwnerId = Userinfo.getOrganizationId();
        
        //SetupOwnerId = 
        
        try {
            Database.upsert(dataDotCom);
            statusMessage = 'Data.com Settings Updated';    
        } catch (system.exception e) {
            ApexPages.addMessages(e);
        }
        readRecords();
        return null;
    }
    
    public PageReference resetImportedData() {
        dataDotCom.ResetDataDate__c = ddcHelper.Reset_Date__c;
        dataDotCom.Name = 'DATA.COM DEMO';
        upsert dataDotCom;
        
        List<Account> deleteAccounts = [select id, Name from Account where CreatedDate > :dataDotCom.ResetDataDate__c and Never_Reset__c = false];
        List<Contact> deleteContacts = [select id, Name from Contact where CreatedDate > :dataDotCom.ResetDataDate__c and Never_Reset__c = false];
        List<Lead> deleteLeads = [select id, Name from Lead where CreatedDate > :dataDotCom.ResetDataDate__c and Never_Reset__c = false and isConverted = false];
        

        
        
        delete deleteContacts;
        delete deleteAccounts;
        delete deleteLeads;
        
        /**
            Option One: Delete Those Associated with Delete Accounts. Assumes One to One Relationship            
        **/
        /*
        List<String> DAndBCompanyIds = new List<String>();        
        for(Account a : deleteAccounts) {
            a.Never_Reset__c  = true;
            DAndBCompanyIds.add(a.DandbCompanyId);
        }
        List<DandBCompany> DandBCompanies = [Select d.Name, d.Id From DandBCompany d where id=: DAndBCompanyIds];
        delete DandBCompanies;
        */
        

        
        List<DandBCompany> allDandBCompanyRecords = [Select d.Name, d.Id, (Select Id From Accounts) From DandBCompany d];
        List<DandBCompany> orphanedDandBCompany = new List<DandBCompany>();
        for(DandBCompany dbCompany : allDandBCompanyRecords) {
            if(dbCompany.Accounts.size() == 0) {
                orphanedDandBCompany.add(dbCompany);
            }
        }
        
        delete orphanedDandBCompany;
        


        statusMessage = 'Imported Data Deleted - ' +deleteLeads.size() + ' Leads, ' + deleteAccounts.size() +' Accounts and ' + deleteContacts.size() + ' Contacts';    
        return null;
    }


    public PageReference resetAll() {
        String fullStatusMessage = '';
        try {        
            resetContact();
            fullStatusMessage += 'Contact Reset \n';
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No Contact Record Set');
            ApexPages.addmessage(myMsg);
           
        }
        try {        
            resetAccount();
            fullStatusMessage += 'Account Reset \n';
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No Account Record Set');
            ApexPages.addmessage(myMsg);
           
        }try {        
            resetLead();
            fullStatusMessage += 'Lead Reset \n';
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No Lead Record Set');
            ApexPages.addmessage(myMsg);
           
        }
        
        statusMessage = 'All Demo Records Reset';    
        return null;
    }
    
    public PageReference QuickResetAndRedirect() {
        setupDefaults();
        Boolean success = true;
        String fullStatusMessage = '';
        try {        
            resetContact();
            fullStatusMessage += 'Contact Reset \n';
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No Contact Record Set');
            ApexPages.addmessage(myMsg);
            success = false;
        }
        try {        
            resetAccount();
            fullStatusMessage += 'Account Reset \n';
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No Account Record Set');
            ApexPages.addmessage(myMsg);
            success = false;
        }try {        
            resetLead();
            fullStatusMessage += 'Lead Reset \n';
        } catch (Exception e) {
            success = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No Lead Record Set');
            ApexPages.addmessage(myMsg);
           
        }
        
        statusMessage = fullStatusMessage;
        if(success) {
            return new PageReference('/home/home.jsp');
        } else {
            return null;
        }
    }

    public PageReference resetContact() {

        dataComDemoContact.FirstName =  demoContactResetValues.FirstName__c;
        dataComDemoContact.LastName = demoContactResetValues.LastName__c;
        dataComDemoContact.Email = demoContactResetValues.Email__c;
        dataComDemoContact.Phone = demoContactResetValues.Phone__c;
        dataComDemoContact.MobilePhone = demoContactResetValues.MobilePhone__c;
        dataComDemoContact.MailingStreet = demoContactResetValues.MailingStreet__c;
        dataComDemoContact.MailingCity = demoContactResetValues.MailingCity__c;
        dataComDemoContact.MailingState = demoContactResetValues.MailingState__c;
        dataComDemoContact.MailingCountry = demoContactResetValues.MailingCountry__c;
        dataComDemoContact.MailingPostalCode = demoContactResetValues.MailingPostalCode__c;
        dataComDemoContact.Title = demoContactResetValues.Title__c;

        /*
        dataComDemoContact.FirstName = 'Jason'; 
        dataComDemoContact.LastName = 'Brennaman'; 
        dataComDemoContact.Email = 'jason.brennaman@greendotmedia.com';
        dataComDemoContact.Phone = '';
        dataComDemoContact.MobilePhone = null;
        dataComDemoContact.MailingStreet = '';
        dataComDemoContact.MailingCity = 'San Francisco';
        dataComDemoContact.MailingState = 'CA';
        dataComDemoContact.MailingCountry = '';
        dataComDemoContact.MailingPostalCode = '';
        dataComDemoContact.Title = 'Information Technology';
        */
        upsert dataComDemoContact;
        statusMessage = 'Contact Record Reset';    
        readRecords();
        return null;
    }


    public PageReference resetAccount() {
        dataComDemoAccount.Name = demoAccountResetValues.Name__c;
        dataComDemoAccount.Website = demoAccountResetValues.Website__c;
        dataComDemoAccount.Industry = demoAccountResetValues.Industry__c;
        dataComDemoAccount.BillingStreet = demoAccountResetValues.BillingStreet__c;
        dataComDemoAccount.BillingCity = demoAccountResetValues.BillingCity__c;
        dataComDemoAccount.BillingState = demoAccountResetValues.BillingState__c;
        dataComDemoAccount.BillingPostalCode = demoAccountResetValues.BillingPostalCode__c;
        dataComDemoAccount.BillingCountry = demoAccountResetValues.BillingCountry__c;
        dataComDemoAccount.Phone = demoAccountResetValues.Phone__c;
        dataComDemoAccount.Fax = demoAccountResetValues.Fax__c;
        dataComDemoAccount.Site = demoAccountResetValues.Site__c;
        if(demoAccountResetValues.NumberOfEmployees__c == NULL) {
            dataComDemoAccount.NumberOfEmployees = NULL;
        } else {
            dataComDemoAccount.NumberOfEmployees = demoAccountResetValues.NumberOfEmployees__c.intValue();
        }    
        dataComDemoAccount.AnnualRevenue = demoAccountResetValues.AnnualRevenue__c;
        dataComDemoAccount.YearStarted = demoAccountResetValues.YearStarted__c;
        dataComDemoAccount.NaicsCode = demoAccountResetValues.NaicsCode__c;
        dataComDemoAccount.NaicsDesc = demoAccountResetValues.NaicsDesc__c;
        dataComDemoAccount.Ownership = demoAccountResetValues.Ownership__c;
        
        dataComDemoAccount.Sic = demoAccountResetValues.Sic__c;
        dataComDemoAccount.SicDesc = demoAccountResetValues.SicDesc__c;
        dataComDemoAccount.DunsNumber = demoAccountResetValues.DunsNumber__c;
        dataComDemoAccount.TradeStyle = demoAccountResetValues.Tradestyle__c;
        dataComDemoAccount.Description = demoAccountResetValues.Description__c;
        dataComDemoAccount.DandbCompanyId = NULL;
        /*
        dataComDemoAccount.Name = 'DOT Green Media';
        dataComDemoAccount.Website = 'www.greendotmedia.com';
        dataComDemoAccount.Industry = '';
        dataComDemoAccount.BillingStreet = '660 Sutter St'; 
        dataComDemoAccount.BillingCity = 'San Francisco'; 
        dataComDemoAccount.BillingState = 'CO';                                                                
        dataComDemoAccount.BillingPostalCode = '94102-1018';
        dataComDemoAccount.BillingCountry = 'United States';
        dataComDemoAccount.Phone = '415-536-1111';
        dataComDemoAccount.Fax = '';
        dataComDemoAccount.Site = ''; 
        
        dataComDemoAccount.NumberOfEmployees = 50;
        dataComDemoAccount.AnnualRevenue = 40000;
        dataComDemoAccount.YearStarted = '';
        dataComDemoAccount.NaicsCode = '';
        dataComDemoAccount.NaicsDesc = '';
        dataComDemoAccount.Ownership = '';
        
        dataComDemoAccount.Sic = '';
        dataComDemoAccount.SicDesc = '';
        dataComDemoAccount.DunsNumber = '';
        */
        
        upsert dataComDemoAccount;
        statusMessage = 'Account Record Reset';    
        readRecords();
        return null;
    }


    public PageReference resetLead() {
        dataComDemoLead.FirstName = demoLeadResetValues.FirstName__c;
        dataComDemoLead.LastName = demoLeadResetValues.LastName__c;
        dataComDemoLead.Company = demoLeadResetValues.Company__c;
        dataComDemoLead.Title = demoLeadResetValues.Title__c;
        dataComDemoLead.Email = demoLeadResetValues.Email__c;
        dataComDemoLead.Phone = demoLeadResetValues.Phone__c;
        dataComDemoLead.CompanyDunsNumber = demoLeadResetValues.CompanyDunsNumber__c;
        dataComDemoLead.Street = demoLeadResetValues.Street__c;
        dataComDemoLead.City = demoLeadResetValues.City__c;
        dataComDemoLead.Country = demoLeadResetValues.Country__c;
        dataComDemoLead.PostalCode = demoLeadResetValues.PostalCode__c;
        dataComDemoLead.State = demoLeadResetValues.State__c;
        dataComDemoLead.Industry = demoLeadResetValues.Industry__c;
        if(demoLeadResetValues.NumberOfEmployees__c == NULL) {
            dataComDemoLead.NumberOfEmployees = NULL;
        } else {
            dataComDemoLead.NumberOfEmployees = Integer.valueOf(demoLeadResetValues.NumberOfEmployees__c);
        }
        
        
        if(demoLeadResetValues.Annual_Revenue__c == NULL) {
            dataComDemoLead.AnnualRevenue = NULL;
        } else {
             dataComDemoLead.AnnualRevenue = Integer.valueOf(demoLeadResetValues.Annual_Revenue__c);
        }
        /*
            dataComDemoLead.FirstName = 'S';
            dataComDemoLead.LastName = 'Hartman';
            dataComDemoLead.Company = 'Green Dot Media';
            dataComDemoLead.Title = 'Sales';
            dataComDemoLead.Email = 'sarah.hartman@greendotmedia.com';
            dataComDemoLead.Phone = '';
            dataComDemoLead.CompanyDunsNumber = '';
            dataComDemoLead.Street = '';
            dataComDemoLead.City = '';
            dataComDemoLead.Country = '';
            dataComDemoLead.PostalCode = '';
            dataComDemoLead.State = '';
            dataComDemoLead.Industry = '';
            dataComDemoLead.NumberOfEmployees = null;
        */

        upsert dataComDemoLead;
        statusMessage = 'Lead Record Reset';    
        readRecords();
        return null;
    }
    
    
    public PageReference quickDotPrepareAndRedirect() {
        List<Account> allAccounts = [select id, Never_Reset__c from Account];
        List<Contact> allContacts = [select id, Never_Reset__c from Contact];
        List<Lead> allLeads = [select id, Never_Reset__c from Lead where IsConverted = false];
        
        for(Account a : allAccounts) {
            a.Never_Reset__c  = true;
        }
        
        for(Lead l : allLeads) {
            l.Never_Reset__c  = true;
        }
        
        for(Contact c : allContacts) {
            c.Never_Reset__c  = true;
        }
        
        update allLeads;
        update allAccounts;
        update allContacts;
        return new PageReference('/home/home.jsp');
        
    }
    public PageReference setupForDot() {
        List<Account> allAccounts = [select id, Never_Reset__c from Account];
        List<Contact> allContacts = [select id, Never_Reset__c from Contact];
        List<Lead> allLeads = [select id, Never_Reset__c from Lead where IsConverted = false];
        
        
        
        for(Lead l : allLeads) {
            l.Never_Reset__c  = true;
        }
        
        for(Contact c : allContacts) {
            c.Never_Reset__c  = true;
        }
        
        update allLeads;
        update allAccounts;
        update allContacts;
        return null;
    }
    
    public PageReference restoreDefaultValues() {
        demoLeadResetValues.FirstName__c = 'S';
        demoLeadResetValues.LastName__c = 'Hartman';
        demoLeadResetValues.Company__c = 'Green Dot Media';
        demoLeadResetValues.Title__c = 'Sales';
        demoLeadResetValues.Email__c = 'sarah.hartman@greendotmedia.com';
        demoLeadResetValues.Phone__c = '';
        demoLeadResetValues.CompanyDunsNumber__c = '';
        demoLeadResetValues.Street__c = '';
        demoLeadResetValues.City__c = '';
        demoLeadResetValues.Country__c = '';
        demoLeadResetValues.PostalCode__c = '';
        demoLeadResetValues.State__c = '';
        demoLeadResetValues.Industry__c = '';
        demoLeadResetValues.NumberOfEmployees__c = null;
        
        upsert demoLeadResetValues;
    
        demoAccountResetValues.Name__c = 'DOT Green Media';
        demoAccountResetValues.Website__c = 'www.greendotmedia.com';
        demoAccountResetValues.Industry__c = '';
        demoAccountResetValues.BillingStreet__c = '660 Sutter St'; 
        demoAccountResetValues.BillingCity__c = 'San Francisco'; 
        demoAccountResetValues.BillingState__c = 'CO';                                                                
        demoAccountResetValues.BillingPostalCode__c = '94102-1018';
        demoAccountResetValues.BillingCountry__c = 'United States';
        demoAccountResetValues.Phone__c = '415-536-1111';
        demoAccountResetValues.Fax__c = '';
        demoAccountResetValues.Site__c = ''; 
        
        demoAccountResetValues.NumberOfEmployees__c = 50;
        demoAccountResetValues.AnnualRevenue__c = 40000;
        demoAccountResetValues.YearStarted__c = '';
        demoAccountResetValues.NaicsCode__c = '';
        demoAccountResetValues.NaicsDesc__c = '';
        demoAccountResetValues.Ownership__c = '';
        
        demoAccountResetValues.Sic__c = '';
        demoAccountResetValues.SicDesc__c = '';
        demoAccountResetValues.DunsNumber__c = '';
        upsert demoAccountResetValues;
        
        demoContactResetValues.FirstName__c = 'Jason'; 
        demoContactResetValues.LastName__c = 'Brennaman'; 
        demoContactResetValues.Email__c = 'jason.brennaman@greendotmedia.com';
        demoContactResetValues.Phone__c = '';
        demoContactResetValues.MobilePhone__c = null;
        demoContactResetValues.MailingStreet__c = '';
        demoContactResetValues.MailingCity__c = 'San Francisco';
        demoContactResetValues.MailingState__c = 'CA';
        demoContactResetValues.MailingCountry__c = '';
        demoContactResetValues.MailingPostalCode__c = '';
        demoContactResetValues.Title__c = 'Information Technology';
        upsert demoContactResetValues;
        
        return null;
    }

    public PageReference updateResetValues() {
        upsert demoAccountResetValues;
        upsert demoContactResetValues;
        upsert demoLeadResetValues;
        return null;
    }
    
    public PageReference accessAdvancedMode() {
        mode = 'advanced';
        statusMessage = '';
        return null;
    }
    
    public PageReference accessStandardMode() {
        mode = 'standard';
        statusMessage = '';
        return null;
    }
}