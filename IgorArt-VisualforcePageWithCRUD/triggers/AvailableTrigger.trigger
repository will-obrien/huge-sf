trigger AvailableTrigger on Product__c (before insert,before update) {
    
    
       for (Product__c p : Trigger.New){       
         
           if(p.Amount__c>0){
              p.Available__c=true;        
                }
           else{
              p.Available__c=false;     
               }
          }
    }