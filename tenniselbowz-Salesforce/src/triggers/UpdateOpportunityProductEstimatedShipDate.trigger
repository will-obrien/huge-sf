trigger UpdateOpportunityProductEstimatedShipDate on Opportunity (after update) {
     for(Opportunity o: trigger.new){ 
     
      String existingOpportunityStageName = trigger.oldMap.get(o.Id).StageName;
     
      if(o.StageName == 'Won' && existingOpportunityStageName != o.StageName && o.HasOpportunityLineItem == true){
         String opptyId = o.Id;
         OpportunityLineItem[] OLI = [Select ServiceDate  
                                      From OpportunityLineItem 
                                      where OpportunityId = :opptyId];
         for(OpportunityLineItem ol: OLI){
             ol.ServiceDate = o.CloseDate + 45;
       }
      update OLI;
     }
    }
}