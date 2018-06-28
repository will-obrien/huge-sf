trigger chapterMemberUpdates on Chapter_Member__c (before update) {
    List<Chapter_Member__c> cms = Trigger.new;
    for (Chapter_Member__c c:cms){
        Chapter_Member__c cOld = System.Trigger.oldMap.get(c.Id);
        if(!cOld.Director__c && c.Director__c) {
            
            List<Contact> lstContact = [SELECT Id, Name, AccountId FROM Contact WHERE Id = :c.Contact__c];
            if( lstContact != null && lstContact.size() > 0 ) {
                String accountId = lstContact[0].AccountId;
                List<Account> lstAccount = [SELECT Id, Name FROM Account where Id =  :accountId];
                if( lstAccount != null && lstAccount.size() > 0 ) {

                    Set<Id> setAccIds = new Set<Id>(); 
                    setAccIds.add(accountId );
                    
                    Opportunity newOpp = new Opportunity();
                    newOpp.put('AccountId',accountId);
                    newOpp.put('Name','Free Chapter Membership');
                    newOpp.put('StageName','Closed Won');
                    newOpp.put('CloseDate',system.today());
                    newOpp.put('Eligible_for_Membership_Extension__c',true);
                    
                    
                    insert newOpp;
                    opportunityTriggerUtils.updateContracts(setAccIds, newOpp); 
                }
            }
        }
    }
}