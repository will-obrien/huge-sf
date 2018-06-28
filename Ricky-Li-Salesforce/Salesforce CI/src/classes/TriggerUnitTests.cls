@isTest
 
Private class TriggerUnitTests {
  public static testmethod void InsertLeadTest() {
          Lead lead = new Lead(Company='QAS Test Lead',
                                        LastName='Smith',
                                        Street = 'Hamilton Ave',
                                        Country = 'US',
                                        State = 'NY',
                                        PostalCode = '10606',
                                        City = 'White Plains');
          insert lead;       
    }
 
     public static testmethod void InsertContractTest() {
          Account account = new Account(Name='QAS Test Account',                                   
                      ShippingStreet = 'Hamilton Ave',
                      ShippingCountry = 'US',
                      ShippingState = 'NY',
                      ShippingPostalCode = '10606',
                      ShippingCity = 'White Plains', BillingState='ON', BillingCountry = 'Canada');
                      
          insert account;       
         
          Contract contract = new Contract(Name='QAS Contract test name',
                                        StartDate = Date.today(),
                                        ContractTerm=1,
                                        AccountId = account.Id);
          insert contract;       
    }
   
    public static testmethod void InsertAccountTest() {
          Account account = new Account(Name='QAS Test Account',                                   
                      ShippingStreet = 'Hamilton Ave',
                      ShippingCountry = 'US',
                      ShippingState = 'NY',
                      ShippingPostalCode = '10606',
                      ShippingCity = 'White Plains', BillingState='ON', BillingCountry = 'Canada');
          insert account;    
    }
 
     public static testmethod void InsertContactTest() {
          Contact contact = new Contact(LastName='Smith');
          insert contact;       
    }
}