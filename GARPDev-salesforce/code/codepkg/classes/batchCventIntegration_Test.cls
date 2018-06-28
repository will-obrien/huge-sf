@isTest
public class batchCventIntegration_Test {
    static void testdata()
    {
        	Profile p = [SELECT Id FROM Profile WHERE Id = '00e40000000iraa'];
        
        	User u = new user(TimeZoneSidKey = 'America/New_York',LocaleSidKey = 'en_US', ProfileId = p.Id, Username = 'GARPSYSTEM@garp.com', CommunityNickname = 'GARP SYSTEM',Alias = 'GSystem',CurrencyIsoCode = 'USD', EmailEncodingKey = 'ISO-8859-1',LanguageLocaleKey = 'en_US',LastName = 'System', Email = 'garpsfdcsystem@garp.com');
        	insert u;
        
			Lead l = new Lead(LastName='Test Lead', Company = 'GARP', CurrencyIsoCode = 'USD', Status = 'Open', Email = 'testcontact2@contact.com');
            insert l;
            
            Lead l1 = new Lead(LastName='Test Lead', Company = 'GARP', CurrencyIsoCode = 'USD', Status = 'Open', Email = 'testcontact3@contact.com');
            insert l1;
        
          Lead l2 = new Lead(LastName='Test Lead', Company = 'GARP', CurrencyIsoCode = 'USD', Status = 'Open', Email = 'testcontact4@contact.com');
            insert l2;
        
          
          Lead l3 = new Lead(LastName='Test Lead', Company = 'GARP', CurrencyIsoCode = 'USD', Status = 'Open', Email = 'testcontact5@contact.com');
            insert l3;
            
            Cvent_Registration_Codes__c cventcodes = new Cvent_Registration_Codes__c (Name = 'CventConvention', Subject_Line_Match__c = 'CVent Registration 2015 Convention - Single Match:', Subject_Line_No_Match__c = 'CVent Registration 2015 Convention - No Match:', Task_Creation_Check__c = 'CVent Registration 2015 Convention', Convention_Name__c = 'CVent Registration 2015 Convention', Gl_Code__c = '4060', ProductCode__c = 'CNY13');
            insert cventcodes;
            
            Individual_Membership_Codes__c membership = new Individual_Membership_Codes__c(Name = 'IndividualMembership', Gl_Code__c = '4040', memPrice__c = '195.00', Name__c = 'Individual Membership', Product_Code__c = 'MEMI');
            insert membership;
            
            Product2 prod = new Product2(Name = 'New York Convention',productCode = 'CNY13',GL_Code__c = '4060');
            insert prod;
        
            Product2 prod2 = new Product2(Name = 'Individual Membership',productCode = 'MEMI',GL_Code__c = '4040');
            insert prod2;
        
            Id pricebookId = Test.getStandardPricebookId();
        
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 195.00, IsActive = true);
            insert standardPrice;
        
            PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 195.00, IsActive = true);
            insert standardPrice2;
        
            Pricebook2 pricebook2 = new Pricebook2(Name='GARP 2015/2016', isActive=true);
            insert pricebook2;
            
            PricebookEntry Price = new PricebookEntry(Pricebook2Id = pricebook2.Id, Product2Id = prod.Id,UnitPrice = 195.00, IsActive = true);
            insert Price;
            
            PricebookEntry Price1 = new PricebookEntry(Pricebook2Id = pricebook2.Id, Product2Id = prod2.Id,UnitPrice = 195.00, IsActive = true);
            insert Price1;                  
        
            ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'test-4',ChargentBase__Active__c = true );
            insert chrgGtway;
        
            insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        
            task t3 = new task(whoid = l.id, subject = 'CVent Registration 2015 Convention - No Match:'+'testcontact2@contact.com'+':'+'200.00'+':'+'200.00', description = ':Testcompany:testcontact2@contact.com:John:Doe::Technical Lead:San Fransisco:221-123-6543:CA:1535 Ring Road:Global Association of Risk Professionals:Individual member:XCVBQWERTY:session');
            insert t3;
          
          task t4 = new task(whoid = l2.id, subject = 'CVent Registration 2015 Convention - No Match:'+'testcontact4@contact.com'+':'+'200.00'+':'+'0.00', description = ':Testcompany:testcontact4@contact.com:John:Doe::Technical Lead:San Fransisco:221-123-6543:CA:1535 Ring Road:Global Association of Risk Professionals:Individual member:XCVBQWERTY:session');
            insert t4;
          
           task t5 = new task(whoid = l1.id, subject = 'CVent Registration 2015 Convention - No Match:'+'testcontact3@contact.com'+':'+'200.00'+':'+'200.00', description = ':Testcompany:testcontact3@contact.com:John:Doe::Technical Lead:San Fransisco:221-123-6543:CA:1535 Ring Road:Global Association of Risk Professionals:Non-member:XCVBQWERTY:session');
            insert t5;
        
            task t6 = new task(whoid = l3.id, subject = 'CVent Registration 2015 Convention - No Match:'+'testcontact5@contact.com'+':'+'200.00'+':'+'0.00', description = ':Testcompany:testcontact5@contact.com:John:Doe::Technical Lead:San Fransisco:221-123-6543:CA:1535 Ring Road:Global Association of Risk Professionals:Non-member:XCVBQWERTY:session');
            insert t6;        
    }
    
     static testMethod void UnitTest_1()
    {
        testdata();
        test.startTest();
        batchCventIntegration b = new batchCventIntegration();
        database.executeBatch(b);
        test.stopTest();
    }
    
    
    
    static void testdata1()
    {
        
        	
        
         Cvent_Registration_Codes__c cventcodes = new Cvent_Registration_Codes__c (Name = 'CventConvention', Subject_Line_Match__c = 'CVent Registration 2015 Convention - Single Match:', Subject_Line_No_Match__c = 'CVent Registration 2015 Convention - No Match:', Task_Creation_Check__c = 'CVent Registration 2015 Convention', Convention_Name__c = 'CVent Registration 2015 Convention', Gl_Code__c = '4060', ProductCode__c = 'CNY13');
            insert cventcodes;
        	
        	Profile p = [SELECT Id FROM Profile WHERE Id = '00e40000000iraa'];
        
        	User u = new user(TimeZoneSidKey = 'America/New_York',LocaleSidKey = 'en_US', ProfileId = p.Id, Username = 'GARPSYSTEM@garp.com', CommunityNickname = 'GARP SYSTEM',Alias = 'GSystem',CurrencyIsoCode = 'USD', EmailEncodingKey = 'ISO-8859-1',LanguageLocaleKey = 'en_US',LastName = 'System', Email = 'garpsfdcsystem@garp.com');
        	insert u;
        
            Individual_Membership_Codes__c membership = new Individual_Membership_Codes__c(Name = 'IndividualMembership', Gl_Code__c = '4040', memPrice__c = '195.00', Name__c = 'Individual Membership', Product_Code__c = 'MEMI');
            insert membership;
            
            Product2 prod = new Product2(Name = 'New York Convention',productCode = 'CNY13',GL_Code__c = '4060');
            insert prod;
        
            Product2 prod2 = new Product2(Name = 'Individual Membership',productCode = 'MEMI',GL_Code__c = '4040');
            insert prod2;
        
            Id pricebookId = Test.getStandardPricebookId();
        
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 195.00, IsActive = true);
            insert standardPrice;
        
            PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 195.00, IsActive = true);
            insert standardPrice2;
        
            Pricebook2 pricebook2 = new Pricebook2(Name='GARP 2015/2016', isActive=true);
            insert pricebook2;
            
            PricebookEntry Price = new PricebookEntry(Pricebook2Id = pricebook2.Id, Product2Id = prod.Id,UnitPrice = 195.00, IsActive = true);
            insert Price;
            
            PricebookEntry Price1 = new PricebookEntry(Pricebook2Id = pricebook2.Id, Product2Id = prod2.Id,UnitPrice = 195.00, IsActive = true);
            insert Price1;                  
        
            Account a1 = new Account(name = 'Test Account1');
            insert a1;
        
            Contact c1 = new contact(lastname = 'Test Contact1', AccountID = a1.ID, email = 'testcontact1@contact.com', KPI_Member__c = True, Membership_Type__c = 'Individual',KPI_Membership_Payment_Status__c ='In Good Standing');
            insert c1;
            
            Contact c2 = new contact(lastname = 'Test Contact2', AccountID = a1.ID, email = 'testcontact2@contact.com', KPI_Member__c = False );
            insert c2;
        
        	 Contact c3 = new contact(lastname = 'Test Contact3', AccountID = a1.ID, email = 'testcontact3@contact.com', KPI_Member__c = True );
            insert c3;
        
        	 Contact c4 = new contact(lastname = 'Test Contact4', AccountID = a1.ID, email = 'testcontact4@contact.com', KPI_Member__c = False );
            insert c4;
        
            ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'test-4',ChargentBase__Active__c = true );
            insert chrgGtway;
        
            insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
            opportunity o1 = new Opportunity(ChargentSFA__Gateway__c = chrgGtway.id, amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,Company__c = 'GARP', accountId = a1.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15,Pay_By_Wire_Check__c=false);        
            insert o1; 
            

            OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = o1.id,PricebookEntryId = standardPrice.id, Quantity = 1, TotalPrice = 250.00);
            insert lineitem;
            OpportunityLineItem lineItem1 = new OpportunityLineItem(OpportunityId = o1.id,PricebookEntryId = standardPrice2.id, Quantity = 1, TotalPrice = 250.00);
            insert lineitem1;
            
            
            
            task t1 = new task(subject = 'CVent Registration 2015 Convention - Single Match:'+'testcontact1@contact.com'+':'+'200.00'+':'+'200.00',description = ':'+'Testcompany'+':'+'testcontact1@contact.com'+':'+'John'+':'+'Doe'+':'+':'+'Technical Lead'+':'+'San Fransisco'+':'+'221-123-6543'+':'+'CA'+':'+'1535 Ring Road'+':'+'Global Association of Risk Professionals'+':'+'Individual Member'+':'+'XCVBQWERTY'+':'+'Session'+':');
            insert t1;
        
            task t11 = new task(subject = 'CVent Registration 2015 Convention - Single Match:'+'testcontact3@contact.com'+':'+'250.00'+':'+'0.00',description = ':'+'Testcompany'+':'+'testcontact3@contact.com'+':'+'John'+':'+'Doe'+':'+':'+'Technical Lead'+':'+'San Fransisco'+':'+'221-123-6543'+':'+'CA'+':'+'1535 Ring Road'+':'+'Global Association of Risk Professionals'+':'+'Individual member'+':'+'XCVBQWERTY'+':'+'Session'+':');
            insert t11;
 
            
            task t2 = new task(subject = 'CVent Registration 2015 Convention - Single Match:'+'testcontact2@contact.com'+':'+'200.00'+':'+'200.00',description = ':'+'Testcompany'+':'+'testcontact2@contact.com'+':'+'John'+':'+'Doe'+':'+':'+'Technical Lead'+':'+'San Fransisco'+':'+'221-123-6543'+':'+'CA'+':'+'1535 Ring Road'+':'+'Global Association of Risk Professionals'+':'+'Non-member'+':'+'XCVBQWERTY'+':'+'Session'+':');
            insert t2;
        
            task t21 = new task(subject = 'CVent Registration 2015 Convention - Single Match:'+'testcontact4@contact.com'+':'+'200.00'+':'+'0.00',description = ':'+'Testcompany'+':'+'testcontact4@contact.com'+':'+'John'+':'+'Doe'+':'+':'+'Technical Lead'+':'+'San Fransisco'+':'+'221-123-6543'+':'+'CA'+':'+'1535 Ring Road'+':'+'Global Association of Risk Professionals'+':'+'Individual member'+':'+'XCVBQWERTY'+':'+'Session'+':');
            insert t21;
        
            task t22 = new task(subject = 'CVent Registration 2015 Convention - Single Match:'+'testcontact4@contact.com'+':'+'200.00'+':'+'200.00',description = ':'+'Testcompany'+':'+'testcontact4@contact.com'+':'+'John'+':'+'Doe'+':'+':'+'Technical Lead'+':'+'San Fransisco'+':'+'221-123-6543'+':'+'CA'+':'+'1535 Ring Road'+':'+'Global Association of Risk Professionals'+':'+'Individual member'+':'+'XCVBQWERTY'+':'+'Session'+':');
            insert t22;
        
            task t23 = new task(subject = 'CVent Registration 2015 Convention - Single Match:'+'testcontact2@contact.com'+':'+'200.00'+':'+'0.00',description = ':'+'Testcompany'+':'+'testcontact2@contact.com'+':'+'John'+':'+'Doe'+':'+':'+'Technical Lead'+':'+'San Fransisco'+':'+'221-123-6543'+':'+'CA'+':'+'1535 Ring Road'+':'+'Global Association of Risk Professionals'+':'+'Non-member'+':'+'XCVBQWERTY'+':'+'Session'+':');
            insert t23;
    }
    
      static testMethod void UnitTest_2()
    {
        testdata1();
        test.startTest();
        batchCventIntegration b1 = new batchCventIntegration();
        database.executeBatch(b1);
        test.stopTest();
    }

}