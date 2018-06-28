global class GuidedSellingFlowPluginImpl implements zqu.SelectProductComponentOptions.IGuidedSellingFlowPlugin{  
   public List<ID> getFlows(Id quoteId){
      List < Id > flowIds = new List < Id >();
 
      if(String.isBlank(quoteId)) return flowIds;
 
      // Retrieve the quote based on Id
      List < zqu__Quote__c > quoteList = [SELECT Name, zqu__SubscriptionType__c FROM zqu__Quote__c WHERE Id = :quoteId];
      if(quoteList.isEmpty()) return flowIds;
       
      // Determine the string to query flows based on the subscription type of the quote
      String flowName = quoteList[0].zqu__SubscriptionType__c == 'New Subscription' ? 'Tax Free%' : '%Amend%"';
 
      // Query for flows based on the name and IncludeInProductSelector flag
      List < zqu__GuidedSellingFlow__c > flows = [SELECT Id FROM zqu__GuidedSellingFlow__c WHERE zqu__IncludeInProductSelector__c = true AND (Name like :flowName)];
      if(flows.isEmpty()) return flowIds;
 
      // If flows were found, add their ids to the result list
      for(zqu__GuidedSellingFlow__c flow : flows) {
         flowIds.add(flow.Id);
      }
      return flowIds;
    }
 }