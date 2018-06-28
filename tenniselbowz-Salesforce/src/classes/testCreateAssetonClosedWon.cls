@isTest 

private class testCreateAssetonClosedWon {
    
    static testMethod void testCreateAssetonClosedWon(){
        
        //Account a = [select Id from Account limit 1];
        
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.Type = 'Architect';
        a.Industry = 'Healthcare';
        
        insert a;  
        
        PricebookEntry pbID = [select Id from PricebookEntry where IsActive = true limit 1];
        Opportunity o = new Opportunity();
        OpportunityLineItem ol = new OpportunityLineItem();
        
        o.AccountId = a.Id;
        o.Name = 'test';
        o.StageName = 'D-Proposal/Bid-Not Daikin Specified';
        o.CloseDate = date.today();
        o.Vertical_Market__c = 'Healthcare';
        insert o;
        
        ol.OpportunityId = o.Id;
        ol.Quantity = 1;
        ol.UnitPrice = 2.00;
        ol.PricebookEntryId = pbId.Id;
        
        insert ol;
        
        o.StageName= 'Order-Won-Crdt Release, Submittal signed';
        o.Won_Lost_Reason__c = 'Price';
        update o;
        
        delete ol;
        delete o;
        
        
        
    }
    
    
}