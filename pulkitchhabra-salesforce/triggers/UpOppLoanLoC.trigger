trigger UpOppLoanLoC on Opportunity (after update) {
    Set<OpportunityLineItem> oliSet = new Set<OpportunityLineItem>([Select Id, OpportunityId, Type__c from OpportunityLineItem where Type__c = 'Loan' Or Type__c = 'Lines Of Credit']);
    List<Opportunity> UpOpp = new List<Opportunity>();
    for(Opportunity opp :trigger.new){
        if(opp.StageName == 'Closed Won'){
            for(OpportunityLineItem oli :oliSet){
                if(opp.Id == oli.OpportunityId){
                    Opportunity o = new Opportunity(Id = opp.Id,
                                                   Pulkit__UCC_Filing__c = 'Full UCC-1',
                                                   Pulkit__UCC_Filing_Reason__c = 'Loan',
                                                   Pulkit__UCC_Request_Date__c = Date.today());
                    update o;
                }
            }
        }
    }
}