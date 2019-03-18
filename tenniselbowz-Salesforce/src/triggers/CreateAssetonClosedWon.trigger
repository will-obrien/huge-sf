trigger CreateAssetonClosedWon on Opportunity (after insert, after update) {
     for(Opportunity o: trigger.new){ 
      if(o.isWon == true && o.HasOpportunityLineItem == true){
         String opptyId = o.Id;
         OpportunityLineItem[] OLI = [Select Total_Selling_Price_w_Log_Disc__c, Quantity, PricebookEntry.Product2Id, PricebookEntry.Product2.Name, PricebookEntry.Product2.Create_Multiple_Assets__c, Description, Converted_to_Asset__c  
                                      From OpportunityLineItem 
                                      where OpportunityId = :opptyId and Converted_to_Asset__c = false];
         Asset[] ast = new Asset[]{};
         Asset a = new Asset();
         Double qty = 1;
         Double originalQty = 0;
         Double originalPrice =0;
         for(OpportunityLineItem ol: OLI){
            originalQty = ol.Quantity;
            originalPrice = ol.Total_Selling_Price_w_Log_Disc__c;
            if (ol.PricebookEntry.Product2.Create_Multiple_Assets__c){
                qty = ol.Quantity;
                originalPrice = ol.Total_Selling_Price_w_Log_Disc__c / originalQty;
                originalQty = 1;
                }
            else
                qty = 1;
                
            for(Double counter = qty; counter > 0; counter--){    
                a = new Asset();
                a.AccountId = o.AccountId;
                a.Product2Id = ol.PricebookEntry.Product2Id;
                a.Quantity = originalQty;
                a.Price =  originalPrice;
                a.PurchaseDate = o.CloseDate;
                a.Status = 'Purchased';
                a.Description = ol.Description;
                a.Name = ol.PricebookEntry.Product2.Name;
                a.IsCompetitorProduct = false;
                a.Opportunity__c = o.Id;
                ast.add(a);
            }
            ol.Converted_to_Asset__c = true;
       }
      update OLI; 
      insert ast;
     }
    }
}