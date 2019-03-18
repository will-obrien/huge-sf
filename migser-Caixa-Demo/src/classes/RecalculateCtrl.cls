public with sharing class RecalculateCtrl {
    public String CampaignId{get;set;}
    public List<Campaign_Opportunity__c> campOpptyList{get;set;}
    public set<Id> opptyIds{get;set;}
    public List<Opportunity> wonOpptyList{get;set;}
    public Campaign__c campToUpdate{get;set;}
    
    public RecalculateCtrl(ApexPages.StandardController controller) {
        CampaignId = ApexPages.currentPage().getParameters().get('id');
    }
    
    public void recalculate(){
        campOpptyList = [select Opportunity__c, Opportunity__r.Amount from Campaign_Opportunity__c where Campaign__c =: CampaignId];
        
        Double TotalOpptyAmount = 0;
        opptyIds = new set<Id>();
        for(Campaign_Opportunity__c campOppty :campOpptyList){
            opptyIds.add(campOppty.Opportunity__c);
            TotalOpptyAmount = TotalOpptyAmount+campOppty.Opportunity__r.Amount;
        }
        system.debug('Total Oppty: '+campOpptyList.size());
        system.debug('TotalOpptyAmount: '+TotalOpptyAmount);
        
        wonOpptyList = [select Id, StageName, Amount from Opportunity where Id IN: opptyIds and StageName=:'7. Design Win'];
        system.debug('wonOpptyList: '+wonOpptyList);
        
        Double TotalWonOpptyAmount = 0;
        for(Opportunity wonOppty :wonOpptyList){
            TotalWonOpptyAmount = TotalWonOpptyAmount+wonOppty.Amount;
        }
        system.debug('Total Oppty: '+wonOpptyList.size());
        system.debug('TotalWonOpptyAmount: '+TotalWonOpptyAmount);
        
        
        campToUpdate = [select Id, Num_Total_Opportunities__c, Total_Value_Opportunities__c, Num_Won_Opportunities__c, Total_Value_Won_Opportunities__c from Campaign__c where Id =: CampaignId];
        campToUpdate.Num_Total_Opportunities__c = campOpptyList.size();
        campToUpdate.Total_Value_Opportunities__c = TotalOpptyAmount;
        campToUpdate.Num_Won_Opportunities__c = wonOpptyList.size();
        campToUpdate.Total_Value_Won_Opportunities__c = TotalWonOpptyAmount;
        
        update campToUpdate;
    }

}