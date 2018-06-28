trigger setAddress on Contact (Before insert){
    set<id> ids = new Set<id>();
    map<id,Account> rel_map = new map<id,Account>();
    list<RecordType> rt = [SELECT id FROM recordtype WHERE name='store' AND sobjectType='contact'];
   if(rt.size() >0 ){
       for(contact con : trigger.new){
        if(rt[0].id == con.recordTypeId && con.accountid != null){
            ids.add(con.accountid);
            system.debug('*********'+con.Account.name+'------->>'+con.lastname);           
        }      
    }
    system.debug('@@@@@@'+ids);
     rel_map  =  new map<id,Account>([SELECT name FROM account WHERE id IN : ids]);
       system.debug('-------- Size : '+rel_map);
        for(contact c : trigger.new){
            if(rt[0].id == c.recordTypeId && c.accountid!= null){
                 system.debug('##########'+ rel_map.get(c.accountid).name+'-------- Size : '+rel_map.size());
                 c.Account_number__c = rel_map.get(c.accountid).id;
           }          
        }
   }    
}