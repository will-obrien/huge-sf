public class TestData {
    
    public static Account createAgency()
    {
        RecordType rt = [select Id, Name from RecordType where Name = 'Agency' limit 1];
        
        Account agency = new Account(RecordTypeId = rt.Id,
                                            Name='SellOfVacation',          
                                          ShippingStreet = 'Hamilton Ave',
                                          ShippingCountry = 'US',
                                          ShippingState = 'NY',
                                          ShippingPostalCode = '10606',
                                          ShippingCity = 'White Plains',
                                          BillingStreet = 'Hamilton Ave',
                                          BillingCountry = 'US',
                                          BillingState = 'NY',
                                          BillingPostalCode = '10606',
                                          BillingCity = 'White Plains');
        insert agency;
        
        agency = [select Id, Name, BillingStreet, BillingCountry, BillingCity, BillingState,
                                    ShippingStreet, ShippingCountry, ShippingState, ShippingPostalCode, ShippingCity 
                                    //, BrochureCountry__c
                            from Account where Id = :agency.Id];
        
        return agency;
    }
    
    public static Contact createAgent(Account agency)
    {
        Contact agent = new Contact(FirstName = 'Lily', LastName = 'Smith', MailingStreet = '123 Main Street', AccountId = agency.Id);
        insert agent;
        agent = [select FirstName, LastName, Id, AccountId, MailingStreet, MailingCountry, BrochureCountry__c from Contact where Id = :agent.Id];
        return agent; 
    }
    
    public static Account createTraveller()
    {
        RecordType rt = [select Id, Name from RecordType where Name = 'Traveller' limit 1];
            
        Account traveller = new Account(RecordTypeId = rt.Id, 
                                            FirstName='John',          
                                            LastName = 'Doe',
                                            Salutation = 'Mr',
                                            BillingStreet = '123 Main St.',
                                            BillingCountry = 'Australia',
                                            ShippingStreet = '123 Main St.',
                                            ShippingCountry = 'Australia'
                                          );
        insert traveller;  
        traveller = [select Id, FirstName, LastName, Salutation, BillingStreet, BillingCountry, ShippingStreet, ShippingCountry, BrochureCountry__c 
                                from Account where Id = : traveller.Id];
        return traveller;
    }


    public static Brochure__c createBrochure()
    {
        Brochure__c sampleBrochure = new Brochure__c(Name = '2012 Asia', Description__c = 'Sample Desc');
        insert sampleBrochure;
        sampleBrochure = [select Id, Name, Description__c from Brochure__c where Id = : sampleBrochure.Id];
        return sampleBrochure;      
    }
    
    
    public static Brochure__c createRestrictedBrochure()
    {
       Brochure__c sampleRestrictedBrochure = new Brochure__c(Name = '2012 Earth', Description__c = 'Sample Desc', Countries_Not_Eligible__c = 'AU');
       
       insert sampleRestrictedBrochure;
       sampleRestrictedBrochure = [select Id, Name, Description__c, Countries_Not_Eligible__c from Brochure__c where Id = : sampleRestrictedBrochure.Id];
       return sampleRestrictedBrochure;
    }
    
    
    public static Lead createLead()
    {
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Lead', Country = 'East Timor');
        insert testLead;
        testLead = [select FirstName, LastName, Country from Lead where Id = :testLead.Id];
        return testLead;
    }
    
}