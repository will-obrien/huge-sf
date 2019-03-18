trigger ContactTgr on Contact (before insert,before update,after insert) {
    if(Trigger.isInsert && Trigger.isBefore) {
        for(Contact con:Trigger.new){
            con.LeadSource = 'web';
           
        }
    }
    //trigger.newmap and tigger.oldmap
    if(Trigger.isUpdate) {
        for(Contact con:Trigger.new){
            if(con.LeadSource != Trigger.oldMap.get(con.Id).LeadSource){
                con.LeadSource.addError('Cannot Change');
            }
           
        }
    }
    /*
    if(Trigger.isInsert && Trigger.isAfter) {
        set<Id> accIds = new set<Id> ();
        for(Contact con:Trigger.new){
            accIds.add(con.AccountId);
        }
        system.debug('accids: '+accIds);
        List<Account> accList = [select id,NumberOfEmployees from Account where id IN: accIds];
        for(Account a: accList) {
            if(a.NumberOfEmployees>0) {
                a.NumberOfEmployees +=1;
            }else{
               a.NumberOfEmployees = 0;
               //NumberOfEmployees +=1;
            }
        }
        update accList;
    }*/
}