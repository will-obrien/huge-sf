trigger ContactrecordCount on Contact (after insert,after update,after delete,after undelete) {
    list<ID> Acc = new list<id>();
    map<id,list<contact>> contactCount = new map<id,list<contact>>();
    list<contact> ConList = new list<contact>();
    list<account> AcctList = new list<account>();
    list<account> contactscount = new list<account>();
    if(trigger.isInsert) {
        for(Contact con : trigger.new){
            if(con.xcount__c != null){
                Acc.add(Con.AccountId);  
            }   
         }
    }   
    if(trigger.isUpdate){
       for(contact con : trigger.old){
           if(con.xcount__c !=null){
               acc.add(con.accountId);
           }
         }
     }
    if(trigger.isDelete){
        for(contact con : trigger.old){
                acc.add(con.accountid);
            }
    
    }
    if(trigger.isUndelete){
        for(contact con : trigger.new){
            acc.add(con.accountid);
        }
    }
       
     if(Acc.size() > 0){
        ConList = [SELECT Id,xcount__c,ycount__c,AccountId FROM Contact WHERE AccountId IN : Acc];
        
        for(Contact Con : ConList) {
            if(!contactCount .containsKey(Con.AccountId)){
                contactCount .put(Con.AccountId, new List<Contact>());
                system.debug('*/*/*/*/*/*/*/*/=='+contactcount);
            }
            contactCount.get(Con.AccountId).add(Con);      
        }                       
        AcctList = [SELECT xcount__c,ycount__c,xycount__c FROM Account WHERE Id IN : contactCount.keySet()];
        //List<Contact> ContList = new List<Contact>();
        for(Account Ac : AcctList) {
            decimal xsum=0;
            decimal ysum=0;
            decimal totalsum=0;
           List<Contact> ContList = contactCount.get(Ac.Id);
            for(Contact con : ContList){
                if(con.xcount__c != null){
                xsum+=con.xcount__c;
                }
                if(con.ycount__c !=null){
                ysum+=con.ycount__c;
                }
               /* if(true)
                totalsum+= con.xcount__c+con.ycount__c;*/

               
                
            }
                ac.xcount__c = xsum;   
                ac.ycount__c = ysum; 
                ac.xycount__c = totalsum;        
            contactscount.add(ac);
        }
            update contactscount ;
       
        //update AcctList;
          
   }
   
   
           
       }