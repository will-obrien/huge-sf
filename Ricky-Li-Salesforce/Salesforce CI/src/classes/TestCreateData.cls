@isTest(SEEALLDATA=TRUE)
public class TestCreateData{

    //create agency
    public static testmethod Account createAgency(){    
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
                  from Account where Id = :agency.Id];
        return agency;
    }    
    
    //create traveller
    public static testmethod Account createTraveller()
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
    
    //create Affinity
    public static testmethod Account createAffinity()
    {
        RecordType rt = [select Id, Name from RecordType where Name = 'Affinity' limit 1];
            
        Account affinity = new Account(RecordTypeId = rt.Id, 
                                              Name ='Adventure People',          
                                              ShippingStreet = 'Hamilton Ave',
	                                          ShippingCountry = 'US',
	                                          ShippingState = 'NY',
	                                          ShippingPostalCode = '10606',
	                                          ShippingCity = 'White Plains',
	                                          BillingStreet = 'Hamilton Ave',
	                                          BillingCountry = 'US',
	                                          BillingState = 'NY',
	                                          BillingPostalCode = '10606',
	                                          BillingCity = 'White Plains'
                                          );
        insert affinity;  
        affinity = [select Id, FirstName, LastName, Salutation, BillingStreet, BillingCountry, ShippingStreet, ShippingCountry, BrochureCountry__c 
                                from Account where Id = : affinity.Id];
        return affinity;
    }
    
    //create agent
    public static Contact createAgent(Account agency)
    {
        Contact agent = new Contact(FirstName = 'Lily', LastName = 'Smith', MailingStreet = '123 Main Street', AccountId = agency.Id);
        insert agent;
        agent = [select FirstName, LastName, Id, AccountId, MailingStreet, MailingCountry, BrochureCountry__c from Contact where Id = :agent.Id];
        return agent; 
    }    
    //create agent (no parameters: auto create agency)
    public static testmethod Contact createAgent()
    {
    	Account agency = createAgency();
        Contact agent = new Contact(FirstName = 'Lily', LastName = 'Smith', MailingStreet = '123 Main Street', AccountId = agency.Id);
        insert agent;
        agent = [select FirstName, LastName, Id, AccountId, MailingStreet, MailingCountry, BrochureCountry__c from Contact where Id = :agent.Id];
        return agent; 
    }
    
    //create booking
    public static booking__c createBooking(Contact agent){
    	booking__c booking = new Booking__c(Name = 'Test Booking #1', Agent__c = agent.Id);
    	insert booking;
    	booking = [select Name, Agent__c, Id from booking__c where Id = :booking.Id];    
    	return booking;
    }
    //create booking (no parameters: auto create agent)
    public static testmethod booking__c createBooking(){
    	Contact agent = createAgent();
    	booking__c booking = new Booking__c(Name = 'Test Booking #1', Agent__c = agent.Id);
    	insert booking;
    	booking = [select Name, Agent__c, Id from booking__c where Id = :booking.Id];    
    	return booking;
    }
    
    //create service
    public static service__c createService(Booking__c booking){
    	Service__c service = new Service__c(Name = 'Peru Panorama Trip',
                              Service_Type__c = 'Tour',
                              Number_Of_Days__c = 6, Add_ons__c = false,
                              Service_Status__c = 'Confirmed',
                              Supplier_Style__c = 'Canada Goose',
                              Service_Level__c = 'Basic',
                              Gross__c = 1500,
                              Confirmation_Date_Exchange_Rate__c = 0.8,
                              CurrencyISOCode = 'USD',
                              Booking__c = booking.Id,
                              Service_ID_2__c = 'A1000000'
                            ); 
        insert service;                    
        service = [select Id, Name, Service_Type__c, Number_Of_Days__c, Add_ons__c, Service_Status__c, Supplier_Style__c, 
        			Service_Level__c, Gross__c,Confirmation_Date_Exchange_Rate__c,Booking__c, Service_ID_2__c
        			from Service__c where Id = :service.Id];                    
        return service;
    }
    //create service (no parameters: auto create booking)
    public static testmethod service__c createService(){
    	Booking__c booking = createBooking();
    	Service__c service = new Service__c(Name = 'Peru Panorama Trip',
                              Service_Type__c = 'Tour',
                              Number_Of_Days__c = 6, Add_ons__c = false,
                              Service_Status__c = 'Confirmed',
                              Supplier_Style__c = 'Canada Goose',
                              Service_Level__c = 'Basic',
                              Gross__c = 1500,
                              Confirmation_Date_Exchange_Rate__c = 0.8,
                              CurrencyISOCode = 'USD',
                              Booking__c = booking.Id,
                              Service_ID_2__c = 'A1000000'
                            );
        insert service;                    
        service = [select Id, Name, Service_Type__c, Number_Of_Days__c, Add_ons__c, Service_Status__c, Supplier_Style__c, 
        			Service_Level__c, Gross__c,Confirmation_Date_Exchange_Rate__c,Booking__c, Service_ID_2__c
        			from Service__c where Id = :service.Id];   
        return service;
    }
}