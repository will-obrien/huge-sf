public class DE_DataResetCtrl_DOS {
    
    public Account dataAccount {get;set;}
    public Integer dataAccountSize {get;set;}
    
    public DE_DataResetCtrl_DOS() {
        
        try {
               dataAccount = [SELECT AnnualRevenue,BillingCountry,BillingPostalCode,
                               BillingState,BillingStreet,DandbCompanyId,Description,DunsNumber,
                               NaicsCode,NaicsDesc,NumberOfEmployees,Ownership,salesedgedemo__campaign__pc,
                               Sic,SicDesc,Site,TickerSymbol,YearStarted, (SELECT Id, Name FROM Contacts WHERE Name != 'Marc Benioff')
                               FROM Account
                               WHERE Name = 'Salesforce.com, Inc.']; //  AND RecordTypeId = '0121a000000benLAAQ'
                               
              dataAccountSize = dataAccount.Contacts.size();
        } catch(Exception e) {
            
                System.Debug('Error finding Account (Salesforce.com, Inc.): ' + e);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.Error,'Error finding Account (Salesforce.com, Inc.): ' + e);
        }
    
    }
    
    public void resetAccountFields() {
    
        try {
            dataAccount.AnnualRevenue = null;
            dataAccount.BillingCountry = null;
            dataAccount.BillingPostalCode = null;
            dataAccount.BillingState = null;
            dataAccount.BillingStreet = null;
            dataAccount.DandbCompanyId = null;
            dataAccount.Description = null;
            dataAccount.DunsNumber = null;
            dataAccount.NaicsCode = null;
            dataAccount.NaicsDesc = null;
            dataAccount.NumberOfEmployees = null;
            dataAccount.Ownership = null;
            dataAccount.Sic = null;
            dataAccount.SicDesc = null;
            dataAccount.Site = null;
            dataAccount.TickerSymbol = null;
            dataAccount.YearStarted = null;
            
            update dataAccount;
            
        } catch (Exception e) {
            System.Debug('Error resetting fields: ' + e);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.Error,'Error resetting fields: ' + e);
        }
    }
    
    public void resetContacts() {
        try {
            delete dataAccount.Contacts;
        } catch (Exception e) {
            System.Debug('Error deleting associated Contacts: ' + e);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.Error,'Error deleting associated Contacts: ' + e);
        }
    }

}