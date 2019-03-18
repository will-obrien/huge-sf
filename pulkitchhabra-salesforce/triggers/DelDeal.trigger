trigger DelDeal on Deal__c (after insert, after update) {
    List<Deal__c> DlDeal=new List<Deal__c>();
    List<Deal__c> exDeal=new List<Deal__c>([Select Id, Status__c from Deal__c where Status__c='Closed - Converted' OR Status__c='Closed Won' OR Status__c='Closed Lost']);
    for(Deal__c d:exDeal){
        DlDeal.add(d);
    }
    delete DlDeal;

}