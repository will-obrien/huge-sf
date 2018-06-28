@isTest
public class OpportunityViewTest {

    @isTest
    static void testGetItems() {
        Opportunity o1 = new Opportunity(CloseDate=Date.newInstance(1960, 2, 17), StageName = 'Needs Analysis', Name = 'Test Opp 1');
        Opportunity o2 = new Opportunity(CloseDate=Date.newInstance(1961, 3, 19), StageName = 'Needs Analysis', Name = 'Test Opp 2');

        insert o1;
        insert o2;

        string o1Id = [SELECT Id FROM Opportunity WHERE CloseDate = 1960-02-17].Id;
        string o2Id = [SELECT Id FROM Opportunity WHERE CloseDate = 1961-03-19].Id;
        
        Id pricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             isActive = true
        );
        insert prod;
        
        PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        insert pbEntry;
        
        OpportunityLineItem oli1 = new OpportunityLineItem(
             OpportunityId = o1Id,
             Quantity = 5,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 2 * pbEntry.UnitPrice
        );
        
        OpportunityLineItem oli2 = new OpportunityLineItem(
             OpportunityId = o2Id,
             Quantity = 3,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 4 * pbEntry.UnitPrice
        );
        
        OpportunityLineItem oli3 = new OpportunityLineItem(
             OpportunityId = o2Id,
             Quantity = 13,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 14 * pbEntry.UnitPrice
        );
        
        insert oli1;
        insert oli2;
        insert oli3;

        o1 = [SELECT Id, Name, StageName, CloseDate, HasOpportunityLineItem FROM Opportunity WHERE CloseDate = 1960-02-17];
        o2 = [SELECT Id, Name, StageName, CloseDate, HasOpportunityLineItem FROM Opportunity WHERE CloseDate = 1961-03-19];
    
        OpportunityView ov = new OpportunityView();
        System.assertEquals(o1.hasOpportunityLineItem,true);
        System.assertEquals(o2.hasOpportunityLineItem,true);
        
        
        List<SelectOption> resultList = new List<SelectOption>();
        
        resultList.add(new SelectOption('Test Opp 1','Test Opp 1'));
        resultList.add(new SelectOption('Test Opp 2','Test Opp 2'));
        System.assertEquals(ov.getItems(),resultList);
    }

    @isTest
    static void testSelectedItem() {
        OpportunityView oV = new OpportunityView();
        oV.selectedItem = 'test';
        System.assertEquals(oV.selectedItem,'test');
    }
    
    @isTest
    static void testOppListToTable() {
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        
        Opportunity o1 = new Opportunity(CloseDate=Date.newInstance(1960, 2, 17), StageName = 'Needs Analysis', Name = 'Test Opp 1');
        
        Id pricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             isActive = true
        );

        PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        
        OpportunityLineItem oli1 = new OpportunityLineItem(
             OpportunityId = o1.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 2 * pbEntry.UnitPrice
        );

        oliList.add(oli1);
        OpportunityView ov = new OpportunityView();
        System.assertEquals(ov.oppListToTable(oliList), '<table id="customTable"><tr><th>Name:</th><td>null</td></tr><tr><th>Description:</th><td>null</td></tr><tr><th>OpportunityId:</th><td>null</td></tr><tr><th>Quantity:</th><td>5</td></tr><tr><th>ListPrice:</th><td>null</td></tr><tr><th>PricebookEntryId:</th><td>null</td></tr><tr><th>Product2Id:</th><td>null</td></tr><tr><th>ProductCode:</th><td>null</td></tr><tr><th>ServiceDate:</th><td>null</td></tr><tr><th>SortOrder:</th><td>null</td></tr><tr><th>TotalPrice:</th><td>200.00</td></tr><tr><th>UnitPrice:</th><td>null</td></tr></td></tr></table>');
    }

    @isTest
    static void testGetOpportunityLineItems() {
        Opportunity o1 = new Opportunity(CloseDate=Date.newInstance(1960, 2, 17), StageName = 'Needs Analysis', Name = 'Test Opp 1');
        
        insert o1;
        
        Opportunity oppFromDB = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp 1'];
        
        Id pricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             isActive = true
        );
        
        insert prod;

        PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        
        insert pbEntry;

        OpportunityLineItem oli1 = new OpportunityLineItem(
             OpportunityId = oppFromDB.Id,
             Quantity = 5,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 2 * pbEntry.UnitPrice
        );

        insert oli1;

        OpportunityView ov = new OpportunityView();

        List<OpportunityLineItem> oliList = [SELECT Name, Description, OpportunityId, Quantity, ListPrice, PricebookEntryId, Product2Id, ProductCode, ServiceDate, SortOrder, TotalPrice, UnitPrice FROM OpportunityLineItem WHERE OpportunityId = :oppFromDB.Id];
        
        System.assertEquals(ov.getOpportunityLineItems(oppFromDB.Id),oliList);
    }
    
    @isTest
    static void testGetBuiltTable() {

        Opportunity o1 = new Opportunity(CloseDate=Date.newInstance(1960, 2, 17), StageName = 'Needs Analysis', Name = 'Test Opp 1');
        Opportunity o2 = new Opportunity(CloseDate=Date.newInstance(1961, 3, 19), StageName = 'Needs Analysis', Name = 'Test Opp 2');

        insert o1;
        insert o2;

        string o1Id = [SELECT Id FROM Opportunity WHERE CloseDate = 1960-02-17].Id;
        string o2Id = [SELECT Id FROM Opportunity WHERE CloseDate = 1961-03-19].Id;
        
        Id pricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             isActive = true
        );
        insert prod;
        
        PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        insert pbEntry;
        
        OpportunityLineItem oli1 = new OpportunityLineItem(
             OpportunityId = o1Id,
             Quantity = 5,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 2 * pbEntry.UnitPrice
        );
        
        OpportunityLineItem oli2 = new OpportunityLineItem(
             OpportunityId = o2Id,
             Quantity = 3,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 4 * pbEntry.UnitPrice
        );
        
        OpportunityLineItem oli3 = new OpportunityLineItem(
             OpportunityId = o2Id,
             Quantity = 13,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 14 * pbEntry.UnitPrice
        );
        
        insert oli1;
        insert oli2;
        insert oli3;
        
        o1 = [SELECT Id, Name, StageName, CloseDate, HasOpportunityLineItem FROM Opportunity WHERE CloseDate = 1960-02-17];
        o2 = [SELECT Id, Name, StageName, CloseDate, HasOpportunityLineItem FROM Opportunity WHERE CloseDate = 1961-03-19];
    
        OpportunityView ov = new OpportunityView();
    
        ov.selectedItem = o2.Name;

        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(o1);
        opportunityList.add(o2);
        
        ov.opportunities = opportunityList;

        List<OpportunityLineItem> resultOLI = [SELECT Name, Quantity, ListPrice, OpportunityId, PricebookEntryId, Product2Id, ProductCode, ServiceDate, SortOrder, TotalPrice, UnitPrice FROM OpportunityLineItem WHERE OpportunityId = :o2Id];
        
        String result = '';
        result = result + '<table id="customTable"><tr><th>Name:</th><td>' + resultOLI.get(0).Name + '</td><td>' + resultOLI.get(1).Name + '</td></tr><tr><th>Description:</th><td>null</td><td>null</td></tr>';
        result = result + '<tr><th>OpportunityId:</th><td>' + resultOLI.get(0).OpportunityId + '</td><td>' + resultOLI.get(1).OpportunityId + '</td></tr>';
        result = result + '<tr><th>Quantity:</th><td>' + resultOLI.get(0).Quantity + '</td><td>' + resultOLI.get(1).Quantity + '</td></tr>';
        result = result + '<tr><th>ListPrice:</th><td>' + resultOLI.get(0).ListPrice + '</td><td>' + resultOLI.get(1).ListPrice + '</td></tr>';
        result = result + '<tr><th>PricebookEntryId:</th><td>' + resultOLI.get(0).PricebookEntryId + '</td><td>' + resultOLI.get(1).PricebookEntryId + '</td></tr>';
        result = result + '<tr><th>Product2Id:</th><td>' + resultOLI.get(0).Product2Id + '</td><td>' + resultOLI.get(1).Product2Id + '</td></tr>';
        result = result + '<tr><th>ProductCode:</th><td>' + resultOLI.get(0).ProductCode + '</td><td>' + resultOLI.get(1).ProductCode + '</td></tr><tr><th>ServiceDate:</th><td>';
        result = result + resultOLI.get(0).ServiceDate + '</td><td>' + resultOLI.get(1).ServiceDate + '</td></tr><tr><th>SortOrder:</th><td>' + resultOLI.get(0).SortOrder + '</td><td>' + resultOLI.get(1).SortOrder;
        result = result + '</td></tr><tr><th>TotalPrice:</th><td>' + resultOLI.get(0).TotalPrice + '</td><td>' + resultOLI.get(1).TotalPrice + '</td></tr><tr><th>UnitPrice:</th><td>';
        result = result + resultOLI.get(0).UnitPrice + '</td><td>' + resultOLI.get(1).UnitPrice + '</td></tr></td></tr></table>';

        System.assertEquals(ov.getBuiltTable(),result);
    }
}