@isTest(seeAllData=true)                   
private class Datacompletionbatch_Test1{    

    static
    {
        Account objAccount = new Account();
            objAccount.Name = 'Test Account';
            insert objAccount;
            Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];

            Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
            insert pbk1;

            Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = '952', isActive = true);
            insert prd1;


            PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
            insert pbe1;


           Opportunity opp = new Opportunity(accountId =objAccount.Id,LEGACY_PurchasesRefNo__c = '123456',Company__c = 'GARP',Name ='Test OPP',StageName = 'New',CloseDate = System.today().addDays(4),Pricebook2Id = pbe1.Pricebook2Id);
            insert opp;


            OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=opp.id,PriceBookEntryID=pbe1.id, quantity=4, totalprice=200);
            insert lineItem1;
            
    }
    
    static testmethod void testDatacompletionbatch6() {        
            Test.startTest();
           Datacompletionbatch6 c = new Datacompletionbatch6();
           Database.executeBatch(c);       
           Test.stopTest();       
        }
       
    }