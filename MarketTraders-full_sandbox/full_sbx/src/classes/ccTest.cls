@isTest(SeeAllData=true)

private class ccTest{
    
    private static testmethod void myTestMethod1(){
        
        
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new createBillings(5));
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                    NextFireTime
                    FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(0, ct.TimesTriggered);
    }
    /*
    private static testmethod void myTestMethod2(){
        // The query used by the batch job. 
          
        createBillingBatch logObj = new createBillingBatch();

       Test.startTest();
        //TODO find opp with good open close month
       logObj.query = 'Select id from opportunity where stageName =  \'Closed Won\' and billing_created__c = true  LIMIT 1';
       Database.executeBatch(logObj ,10);
       Test.stopTest();

    }
    */
  /*  
    private static testmethod void myTestMethod2a(){
        // The query used by the batch job. 
          
        createBillingBatch logObj = new createBillingBatch();
        List<AcctSeed__Accounting_Period__c> accountPeriod = [
                    SELECT id,AcctSeed__Start_Date__c, AcctSeed__End_Date__c
                    from AcctSeed__Accounting_Period__c 
                    where AcctSeed__Status__c = 'Open'
                    LIMIT 1
                ];
        
       Test.startTest();
        //TODO find opp with good open OPEN month
       logObj.query = 'Select id from opportunity where stageName =  \'Closed Won\' and billing_created__c = true and closeDate > ' + accountPeriod[0].AcctSeed__Start_Date__c + ' and closeDate < ' + accountPeriod[0].AcctSeed__End_Date__c + ' LIMIT 1';
       Database.executeBatch(logObj ,10);
       Test.stopTest();

    }
  */  
    private static testmethod void myTestMethod3(){
    
    //List<opportunity> opps = [Select id,accountid from opportunity where stageName =  'Closed Won' and billing_created__c = true and closeDate > date.today() +60  LIMIT 1];
    
    // create account
          /*
          Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
          User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standardusermtitest@testorgmti.com');
    
          System.runAs(u) {
          */
            Account testAcct = new Account();
            testAcct.Name = 'test account';
            insert testAcct;
            
            Product2 prod = new Product2(Name = 'Test Product'
                                         );
            insert prod;
            
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prod.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            // create opportunity
            
            List<AcctSeed__Accounting_Period__c> accountPeriod = [
                    SELECT id,AcctSeed__Start_Date__c, AcctSeed__End_Date__c
                    from AcctSeed__Accounting_Period__c 
                    where AcctSeed__Status__c = 'Open'
                    order by AcctSeed__Start_Date__c
                    LIMIT 1
                ];
        
            Opportunity testOpp = new Opportunity();
            testOpp.Name = 'test opp';
            testOpp.CloseDate = accountPeriod[0].AcctSeed__Start_Date__c;
            testOpp.AccountId = testAcct.Id;
            testOpp.StageName = 'Closed Won';
            testOpp.Sub_Stage__c = 'Payment Plan';
            testOpp.Payment_Plan__c = 'In-House Financed';
            testOpp.Amount = 1000.0;
            
            insert testOpp;
            
            testOpp.product__c = prod.id;
            update testOpp;
            
            // create payment terms
            Payment_Terms__c testTerms = new Payment_Terms__c();
            testTerms.Account__c = testAcct.Id;
            testTerms.Opportunity__c = testOpp.Id;
            testTerms.Active__c = true;
            testTerms.Discount__c = 100.0;
            testTerms.First_Payment_Term__c = true;
            insert testTerms;
            
            // create payment activities
            List<Payment_Activity__c> testActs = new List<Payment_Activity__c>();
            Date testDate = Date.today();
            Payment_Activity__c testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-5);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Declined';
            testPmtAct.Date__c = Date.today().addMonths(-4);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Declined';
            testPmtAct.Date__c = Date.today().addMonths(-3);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-2);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-1);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            Test.startTest();
            
            insert testActs;
            createBillingBatch logObj = new createBillingBatch();
            logObj.query = 'Select id from opportunity where id = \'' + testOpp.id + '\' LIMIT 1';
            Database.executeBatch(logObj ,10);
            
            Test.stopTest();
        }
       // 
    private static testmethod void myTestMethod4(){
    
    //List<opportunity> opps = [Select id,accountid from opportunity where stageName =  'Closed Won' and billing_created__c = true and closeDate > date.today() +60  LIMIT 1];
    
    // create account
          /*
          Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
          User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standardusermtitest@testorgmti.com');
    
          System.runAs(u) {
          */
            Account testAcct = new Account();
            testAcct.Name = 'test account';
            insert testAcct;
            
            Product2 prod = new Product2(Name = 'Test Product'
                                         );
            insert prod;
            
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prod.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            // create opportunity
            
            List<AcctSeed__Accounting_Period__c> accountPeriod = [
                    SELECT id,AcctSeed__Start_Date__c, AcctSeed__End_Date__c
                    from AcctSeed__Accounting_Period__c 
                    where AcctSeed__Status__c = 'Open'
                    order by AcctSeed__Start_Date__c
                    LIMIT 1
                ];
        
            Opportunity testOpp = new Opportunity();
            testOpp.Name = 'test opp';
            testOpp.CloseDate = accountPeriod[0].AcctSeed__Start_Date__c;
            testOpp.AccountId = testAcct.Id;
            testOpp.StageName = 'Closed Won';
            testOpp.Sub_Stage__c = 'Payment Plan';
            testOpp.Payment_Plan__c = 'In-House Financed';
            testOpp.Amount = 1000.0;
            
            insert testOpp;
        
            OpportunityLineItem NewRec = new OpportunityLineItem();
            NewRec.UnitPrice=200;
            NewRec.Quantity=3;
            NewRec.OpportunityId=testOpp.Id;
            NewRec.PricebookEntryId=standardPrice.id;
            //NewRec.Product2id =product.id;
            insert NewRec;
            
            testOpp.product__c = prod.id;
            update testOpp;
            
            // create payment terms
            Payment_Terms__c testTerms = new Payment_Terms__c();
            testTerms.Account__c = testAcct.Id;
            testTerms.Opportunity__c = testOpp.Id;
            testTerms.Active__c = true;
            testTerms.Discount__c = 100.0;
            testTerms.First_Payment_Term__c = true;
            insert testTerms;
            
            // create payment activities
            List<Payment_Activity__c> testActs = new List<Payment_Activity__c>();
            Date testDate = Date.today();
            Payment_Activity__c testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-5);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Declined';
            testPmtAct.Date__c = Date.today().addMonths(-4);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Declined';
            testPmtAct.Date__c = Date.today().addMonths(-3);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-2);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-1);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            Test.startTest();
            
            insert testActs;
            createBillingBatch logObj = new createBillingBatch();
            logObj.query = 'Select id from opportunity where id = \'' + testOpp.id + '\' LIMIT 1';
            Database.executeBatch(logObj ,10);
            
            Test.stopTest();
       // }
    
    }
    
    private static testmethod void myTestMethod5(){
    
    //List<opportunity> opps = [Select id,accountid from opportunity where stageName =  'Closed Won' and billing_created__c = true and closeDate > date.today() +60  LIMIT 1];
    
    // create account
          /*
          Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
          User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standardusermtitest@testorgmti.com');
    
          System.runAs(u) {
          */
            Account testAcct = new Account();
            testAcct.Name = 'test account';
            insert testAcct;
            
            Product2 prod = new Product2(Name = 'Test Product'
                                         );
            insert prod;
            
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prod.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            // create opportunity
            
            List<AcctSeed__Accounting_Period__c> accountPeriod = [
                    SELECT id,AcctSeed__Start_Date__c, AcctSeed__End_Date__c
                    from AcctSeed__Accounting_Period__c 
                    where AcctSeed__Status__c = 'Closed'
                    LIMIT 1
                ];
        
        	AcctSeed__Accounting_Period__c newPer = new AcctSeed__Accounting_Period__c();
        	newPer.AcctSeed__End_Date__c = date.valueof('2001-01-30');
         	newPer.AcctSeed__Start_Date__c = date.valueof('2001-01-01');
            newPer.AcctSeed__Status__c = 'Closed';
            NewPer.name = '2001-01';
            insert newPer;
        
            Opportunity testOpp = new Opportunity();
            testOpp.Name = 'test opp';
            //testOpp.CloseDate = accountPeriod[0].AcctSeed__Start_Date__c;
            testOpp.CloseDate = newPer.AcctSeed__Start_Date__c;
            testOpp.AccountId = testAcct.Id;
            testOpp.StageName = 'Closed Won';
            testOpp.Sub_Stage__c = 'Payment Plan';
            testOpp.Payment_Plan__c = 'In-House Financed';
            testOpp.Amount = 1000.0;
            
            insert testOpp;
        
            OpportunityLineItem NewRec = new OpportunityLineItem();
            NewRec.UnitPrice=200;
            NewRec.Quantity=3;
            NewRec.OpportunityId=testOpp.Id;
            NewRec.PricebookEntryId=standardPrice.id;
            //NewRec.Product2id =product.id;
            insert NewRec;
            
            testOpp.product__c = prod.id;
            update testOpp;
            
            // create payment terms
            Payment_Terms__c testTerms = new Payment_Terms__c();
            testTerms.Account__c = testAcct.Id;
            testTerms.Opportunity__c = testOpp.Id;
            testTerms.Active__c = true;
            testTerms.Discount__c = 100.0;
            testTerms.First_Payment_Term__c = true;
            insert testTerms;
            
            // create payment activities
            List<Payment_Activity__c> testActs = new List<Payment_Activity__c>();
            Date testDate = Date.today();
            Payment_Activity__c testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-5);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Declined';
            testPmtAct.Date__c = Date.today().addMonths(-4);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Declined';
            testPmtAct.Date__c = Date.today().addMonths(-3);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-2);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-1);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            Test.startTest();
            
            insert testActs;
            createBillingBatch logObj = new createBillingBatch();
            logObj.query = 'Select id from opportunity where id = \'' + testOpp.id + '\' LIMIT 1';
            Database.executeBatch(logObj ,10);
            
            Test.stopTest();
       // }
    
    }
    
    private static testmethod void myTestMethod6(){
    
    //List<opportunity> opps = [Select id,accountid from opportunity where stageName =  'Closed Won' and billing_created__c = true and closeDate > date.today() +60  LIMIT 1];
    
    // create account
          /*
          Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
          User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standardusermtitest@testorgmti.com');
    
          System.runAs(u) {
          */
            Account testAcct = new Account();
            testAcct.Name = 'test account';
            insert testAcct;
            
            Product2 prod = new Product2(Name = 'Test Product'
                                         );
            insert prod;
            
            Id pricebookId = Test.getStandardPricebookId();
            
            PricebookEntry standardPrice = new PricebookEntry(
                Pricebook2Id = pricebookId, Product2Id = prod.Id,
                UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            // create opportunity
            
            List<AcctSeed__Accounting_Period__c> accountPeriod = [
                    SELECT id,AcctSeed__Start_Date__c, AcctSeed__End_Date__c
                    from AcctSeed__Accounting_Period__c 
                    where AcctSeed__Status__c = 'Closed'
                    LIMIT 1
                ];
        
        AcctSeed__Accounting_Period__c newPer = new AcctSeed__Accounting_Period__c();
        	newPer.AcctSeed__End_Date__c = date.valueof('2001-01-30');
         	newPer.AcctSeed__Start_Date__c = date.valueof('2001-01-01');
            newPer.AcctSeed__Status__c = 'Closed';
             NewPer.name = '2001-01';
            insert newPer;
        
            Opportunity testOpp = new Opportunity();
            testOpp.Name = 'test opp';
            //testOpp.CloseDate = accountPeriod[0].AcctSeed__Start_Date__c;
        testOpp.CloseDate = newPer.AcctSeed__Start_Date__c;
            testOpp.AccountId = testAcct.Id;
            testOpp.StageName = 'Closed Won';
            testOpp.Sub_Stage__c = 'Payment Plan';
            testOpp.Payment_Plan__c = 'In-House Financed';
            testOpp.Amount = 1000.0;
            
            insert testOpp;
        
            OpportunityLineItem NewRec = new OpportunityLineItem();
            NewRec.UnitPrice=200;
            NewRec.Quantity=3;
            NewRec.OpportunityId=testOpp.Id;
            NewRec.PricebookEntryId=standardPrice.id;
            //NewRec.Product2id =product.id;
            insert NewRec;
            
            testOpp.product__c = prod.id;
            update testOpp;
            
            // create payment terms
            Payment_Terms__c testTerms = new Payment_Terms__c();
            testTerms.Account__c = testAcct.Id;
            testTerms.Opportunity__c = testOpp.Id;
            testTerms.Active__c = true;
            testTerms.Discount__c = 100.0;
            testTerms.First_Payment_Term__c = true;
            insert testTerms;
            
            // create payment activities
            List<Payment_Activity__c> testActs = new List<Payment_Activity__c>();
            Date testDate = Date.today();
            Payment_Activity__c testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-5);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Declined';
            testPmtAct.Date__c = Date.today().addMonths(-4);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Declined';
            testPmtAct.Date__c = Date.today().addMonths(-3);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-2);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            testPmtAct = new Payment_Activity__c();
            testPmtAct.Payment_Terms__c = testTerms.Id;
            testPmtAct.Opportunity__c = testOpp.Id;
            testPmtAct.Amount__c = 100.0;
            testPmtAct.Payment_Status__c = 'Paid';
            testPmtAct.Outcome__c = 'Approved';
            testPmtAct.Date__c = Date.today().addMonths(-1);
            testPmtAct.Payment_Activity_Type__c = 'Paid';
            testPmtAct.Authorization_Decline_Number__c = 'test';
            testActs.add(testPmtAct);
            
            Test.startTest();
            
            insert testActs;
            update testActs[0];
            
            PaymentActivityHelper.calcStreaks(testActs);
            // calculate cash
            PaymentActivityHelper.aggTotal(testActs);
            PaymentActivityHelper.createCashReceipt(testActs);
            
            Test.stopTest();
       // }
    
    }

    
}