public with sharing class WarehouseDataInstall {
    
    public WarehouseDataInstall() {}

    public static boolean getHasData() {
        return [SELECT Id from Merchandise__c].size() > 0;
    }
    
    public PageReference createData() {
        /* Create Contact */
        Contact contact = new Contact(FirstName='Lloyd',LastName='Benjamin',MobilePhone='415-555-9473');
        insert contact;
        
        /* Create Accounts */
        Account a1 = new Account(Name='San Francisco Telecom',Type='Technology Partner',Industry='Telecommunications',BillingStreet='1040 Gateway Blvd',BillingCity='South San Francisco',BillingState='CA',BillingPostalCode='94080',ShippingStreet='1040 Gateway Blvd',ShippingCity='South San Francisco',ShippingState='CA',ShippingPostalCode='94080',Phone='415-555-6246',Business_Hours__c='9am - 6pm, M-F',Location__Latitude__s=37.6622, Location__Longitude__s=-122.3959);
        insert a1;
        
        Account a2 = new Account(Name='Barbary Coast Wireless',Type='Customer - Direct',Industry='Telecommunications',BillingStreet='1133 Pacific Ave.',BillingCity='San Francisco',BillingState='CA',BillingPostalCode='94133',ShippingStreet='1133 Pacific Ave.',ShippingCity='San Francisco',ShippingState='CA',ShippingPostalCode='94133',Phone='415-555-3284',Business_Hours__c='8am - 7pm, M-F',Location__Latitude__s=37.79616, Location__Longitude__s=-122.4140, NumberOfEmployees=10,ParentId=a1.Id);
        insert a2;
        
        /*Create Account Contacts */
        List<AccountContactRole> aContacts = new List<AccountContactRole>();
        aContacts.add(new AccountContactRole(ContactId=contact.Id, AccountId=a1.Id));
        aContacts.add(new AccountContactRole(ContactId=contact.Id, AccountId=a2.Id));
        insert aContacts;
        
        /* Create Warehouses */
        List<Warehouse__c> warehouses = new List<Warehouse__c>();
        warehouses.add(new Warehouse__c(Name='Ferry Building Depot',Phone__c='(415)555-2575',Street_Address__c='1 Market St',Location__Latitude__s=37.79302, Location__Longitude__s=-122.394507,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='Aloha Warehouse',Phone__c='(415)555-7553',Street_Address__c='1731 Buchanan St',Location__Latitude__s=37.786108, Location__Longitude__s=-122.430152,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='Big Tech Warehouse',Phone__c='(415)555-4201',Street_Address__c='201 11th St',Location__Latitude__s=37.773133, Location__Longitude__s=-122.415069,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='S H Frank & Company',Phone__c='(415)555-1551',Street_Address__c='3075 17th St',Location__Latitude__s=37.763662, Location__Longitude__s=-122.414464,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='San Francisco Tech Mart',Phone__c='(415)555-4328',Street_Address__c='640 Brannan St',Location__Latitude__s=37.77587, Location__Longitude__s=-122.399902,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='Ferguson Home and Office',Phone__c='(415)555-1897',Street_Address__c='435 Valencia St',Location__Latitude__s=37.765987, Location__Longitude__s=-122.421686,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='Graybar Electric Company',Phone__c='(415)555-6766',Street_Address__c='559 6th St',Location__Latitude__s=37.765987, Location__Longitude__s=-122.421686,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='Kelly Paper Source',Phone__c='(415)555-0420',Street_Address__c='1375 Howard St',Location__Latitude__s=37.773563, Location__Longitude__s=-122.413726,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='Public Bikes',Phone__c='(415)555-1234',Street_Address__c='5800 Geary Blvd',Location__Latitude__s=37.780496, Location__Longitude__s=-122.481756,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='TriMarket Economy Fixtures',Phone__c='(415)555-7541',Street_Address__c='3119 Clement St',Location__Latitude__s=37.781448, Location__Longitude__s=-122.492744,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='Antique Furniture Outlet',Phone__c='(415)555-6745',Street_Address__c='5800 3rd St',Location__Latitude__s=37.725304, Location__Longitude__s=-122.394762,City__c='San Francisco'));
        warehouses.add(new Warehouse__c(Name='Marin Factory Store',Phone__c='(415)555-4321',Street_Address__c='590 E Blithedale Ave',Location__Latitude__s=37.900254, Location__Longitude__s=-122.529019,City__c='Mill Valley'));       
        warehouses.add(new Warehouse__c(Name='Oaklandia',Phone__c='(415)555-2244',Street_Address__c='1807 Telegraph Ave',Location__Latitude__s=37.906037, Location__Longitude__s=-122.544976,City__c='Oakland'));
        insert warehouses;
        
        /* Create Merchandise */
        List<Merchandise__c> m = new List<Merchandise__c>();
        m.add(new Merchandise__c(Name='Laptop',Price__c=500,Quantity__c=1000, Warehouse__c=warehouses[0].Id));
        m.add(new Merchandise__c(Name='Desktop',Price__c=1000,Quantity__c=500, Warehouse__c=warehouses[1].Id));
        m.add(new Merchandise__c(Name='Tablet',Price__c=300,Quantity__c=5000, Warehouse__c=warehouses[2].Id));
        m.add(new Merchandise__c(Name='Rack Server',Price__c=3245.99,Quantity__c=500, Warehouse__c=warehouses[3].Id));
        m.add(new Merchandise__c(Name='Windows Laptop',Price__c=445.99,Quantity__c=50, Warehouse__c=warehouses[4].Id));
        m.add(new Merchandise__c(Name='MacBook Air',Price__c=1345.00,Quantity__c=50, Warehouse__c=warehouses[5].Id));
        m.add(new Merchandise__c(Name='MacBook Pro',Price__c=1845.00,Quantity__c=50, Warehouse__c=warehouses[6].Id));
        m.add(new Merchandise__c(Name='Android',Price__c=1399.99,Quantity__c=250, Warehouse__c=warehouses[7].Id));
        m.add(new Merchandise__c(Name='iPhone 5S Gold',Price__c=600.00,Quantity__c=750, Warehouse__c=warehouses[8].Id));
        m.add(new Merchandise__c(Name='iPhone 5C Green',Price__c=600.00,Quantity__c=1200, Warehouse__c=warehouses[9].Id));
        m.add(new Merchandise__c(Name='iPhone 5S Gold',Price__c=600.00,Quantity__c=550, Warehouse__c=warehouses[10].Id));
        m.add(new Merchandise__c(Name='iPhone 5C Red',Price__c=600.00,Quantity__c=1850, Warehouse__c=warehouses[11].Id));  
        m.add(new Merchandise__c(Name='iPhone 5C Blue',Price__c=600.00,Quantity__c=2050, Warehouse__c=warehouses[12].Id));
        
        m.add(new Merchandise__c(Name='iPhone 5S Gold',Price__c=600.00,Quantity__c=750, Warehouse__c=warehouses[2].Id));
        m.add(new Merchandise__c(Name='iPhone 5C Green',Price__c=600.00,Quantity__c=1200, Warehouse__c=warehouses[5].Id));
        m.add(new Merchandise__c(Name='iPhone 5S Gold',Price__c=600.00,Quantity__c=550, Warehouse__c=warehouses[6].Id));
        m.add(new Merchandise__c(Name='iPhone 5C Red',Price__c=600.00,Quantity__c=1850, Warehouse__c=warehouses[8].Id));  
        m.add(new Merchandise__c(Name='iPhone 5C Blue',Price__c=600.00,Quantity__c=2050, Warehouse__c=warehouses[9].Id)); 
        
        m.add(new Merchandise__c(Name='iPhone 5S Gold',Price__c=600.00,Quantity__c=375, Warehouse__c=warehouses[5].Id));
        m.add(new Merchandise__c(Name='iPhone 5C Green',Price__c=600.00,Quantity__c=1400, Warehouse__c=warehouses[2].Id));
        m.add(new Merchandise__c(Name='iPhone 5S Gold',Price__c=600.00,Quantity__c=600, Warehouse__c=warehouses[8].Id));
        m.add(new Merchandise__c(Name='iPhone 5C Red',Price__c=600.00,Quantity__c=1475, Warehouse__c=warehouses[9].Id));  
        m.add(new Merchandise__c(Name='iPhone 5C Blue',Price__c=600.00,Quantity__c=1230, Warehouse__c=warehouses[2].Id));
        insert m;
        
        /* Create Invoices with line items */
        for (Integer i=0; i<=9; i++) {
            Invoice__c inv = new Invoice__c(Status__c=(i < 3 ? 'Closed' : 'Open'),Account__c=(i < 5 ? a1.Id : a2.Id));
            insert inv;
            
            Line_Item__c li = new Line_Item__c
              (Quantity__c=1, Merchandise__c=m[i].Id,Invoice__c=inv.Id);
            insert li;       
        }

        return null;
    }
    
    
    @isTest
    public static void testWarehouseDataInstall() {
        WarehouseDataInstall wdi = new WarehouseDataInstall();
        if(!WarehouseDataInstall.getHasData()) {
            wdi.createData();
        }
        System.assertEquals(true,WarehouseDataInstall.getHasData());
    }

}