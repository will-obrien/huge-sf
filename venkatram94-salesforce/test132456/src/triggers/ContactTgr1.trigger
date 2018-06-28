trigger ContactTgr1 on Contact (after insert,after delete) {
    
    if(Trigger.isInsert) {
        set<Id> accIds = new set<Id> ();
            for(Contact con:Trigger.new){
                accIds.add(con.AccountId);
            }
          //  system.debug('accids: '+accIds);
            List<Account> accList = [select id,NumberOfEmployees from Account where id IN: accIds];
            for(Account a: accList) {
                if(a.NumberOfEmployees==null) {
                    a.NumberOfEmployees = 0;
                }
               // System.debug('number of emps(bef): '+a.NumberOfEmployees);
                    a.NumberOfEmployees +=1;
               System.debug('number of emps: '+a.NumberOfEmployees);
            }
            update accList;
    }

    if(Trigger.isDelete) {
        set<Id> accIds = new set<Id> ();
            for(Contact con:Trigger.new){
                accIds.add(con.AccountId);
            }
            system.debug('accids: '+accIds);
            List<Account> accList = [select id,NumberOfEmployees from Account where id IN: accIds];
            for(Account a: accList) {
                if(a.NumberOfEmployees>0) {
                  a.NumberOfEmployees -=1;
                }
               // System.debug('number of emps(bef): '+a.NumberOfEmployees);
                    
               System.debug('number of emps: '+a.NumberOfEmployees);
            }
            update accList;
    }
}