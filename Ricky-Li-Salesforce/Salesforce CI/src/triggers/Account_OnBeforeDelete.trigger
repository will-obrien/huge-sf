trigger Account_OnBeforeDelete on Account (Before Delete) {
   Set <Id> AccountIds = new Set <Id>();
    for(Account a : trigger.old){
        AccountIds.add(a.Id);
    }
    List <AccountHistoricalSummary__c> listAHS = [Select Id from AccountHistoricalSummary__c where Account_id__c in : AccountIds];
    Delete listAHS;
}