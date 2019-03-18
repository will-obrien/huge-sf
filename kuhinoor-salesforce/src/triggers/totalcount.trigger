trigger totalcount on Contact (after insert,after update,after delete) {
    map<id,list<contact>> contactCount = new map<id,list<contact>>();
    list<id> AcctIds = new list<id>();
    list<contact> ConList = new list<contact>();
    list<account> AcctList = new list<account>();
    list<account> contactscount = new list<account>();
     list<account> updateAcctList = new list<account>();
     
       if(trigger.isInsert || trigger.isUpdate) {
        for(Contact con : trigger.new){
        if(String.isNotBlank(Con.AccountId)){
                AcctIds.add(Con.AccountId);  
            }   
         }
    }
    if(trigger.isUpdate){
        for(contact c : trigger.old){
        if(String.isNotBlank(C.AccountId)){
                AcctIds.add(C.AccountId);
            }
        }
    }
    
     /*if(trigger.isUPdate){
        for(Contact con : trigger.new){
        if(String.isNotBlank(Con.AccountId)){
                AcctIds.add(Con.AccountId);  
            }   
         }
    }*/
    
    
    
    //for delete code .....................
      if(trigger.isDelete) {
        for(Contact Con : trigger.Old) {
            AcctIds.add(Con.AccountId);     
        }  
    }     
    
     if(AcctIds.size() > 0){
        ConList = [SELECT Id, AccountId FROM Contact WHERE AccountId IN : AcctIds];
        
        for(Contact Con : ConList) {
            if(!contactCount .containsKey(Con.AccountId)){
                contactCount .put(Con.AccountId, new List<Contact>());
            }
            contactCount.get(Con.AccountId).add(Con);      
        }                           
        
        System.debug('Account Id and Contact List Map is ' + contactCount );
    
    
      AcctList = [SELECT count__c FROM Account WHERE Id IN : AcctIds];
        
        for(Account Acc : AcctList) {
            List<Contact> ContList = new List<Contact>();
            ContList = contactCount.get(Acc.Id);
            Acc.count__c = ContList.size();
           // contactscount .add(acc);
        }    
            
        update AcctList;
      
       
        //System.debug('Account List is ' + AcctList);
    
   /* contactlist=[select firstname from contact where accountid in :AcctIds];
    list<contact> conlist
   contactCount .put('AcctIds',contactlist);
   list<contact> con=contactCount .get(AcctIds)
   integer i=0;
   for(contact c : con){
       i++;*/
   }
   
 
}