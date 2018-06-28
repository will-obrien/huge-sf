trigger Check on CheckOpp__c (before insert,before update,after delete, after undelete) {
    public list<checkOpp__c> opp=new list<checkOpp__c>();
     public list<checkOpp__c> opp1=new list<checkOpp__c>();
     public list<checkOpp__c> opp2=new list<checkOpp__c>();
     public list<checkOpp__c> opp3=new list<checkOpp__c>();
     public list<checkOpp__c> opp4=new list<checkOpp__c>();
    if(trigger.isInsert){
        for(CheckOpp__c c:trigger.new){
            opp1=[select check__c from CheckOpp__c];
            if(opp1.size()<1){
                if(c.check__c==false){
                    c.check__c=true;
                }
            }    
            list<CheckOpp__c> chk=[select check__c from CheckOpp__c];
            for(checkOpp__c con:chk){
                if(con.Check__c== c.check__c){
                    con.check__c=false;
                    opp.add(con);  
                }
             }update opp;
        }
    }
     if(trigger.isUpdate){
         list<CheckOpp__c> cl=[select Check__c from CheckOpp__c];
         if(triggercheck.test==false){
         triggercheck.test=true;
         for(CheckOpp__c c:trigger.new){
           // checkOpp__c check=trigger.oldMap.get(c.id);
             
              for(CheckoPP__C cin:cl){
                  if(cin.check__c==c.check__c){
                      cin.check__c=false;
                     opp2.add(cin);
                  }
              }
         }update opp2;
     }
     }
    
    
     if(trigger.isDelete){
         opp3= [select check__c from checkopp__c];
         if(triggercheck.test == false){
            triggercheck.test = true;
             for(checkopp__c cin:trigger.old){
                 if(cin.check__c == true){
                     for(integer i=0;i<=0;i++){
                        opp3[i].check__c=true;
                        // opp3.add();
                     }
                }
            }  update opp3;
  
         }
     }
     if(trigger.isUndelete){
         opp4=[select check__c from checkopp__c];
         if(triggercheck.test==false){
         triggercheck.test=true;
         for(checkopp__c d : trigger.new){
             if(d.check__c == true){
                 for(integer i=0;i<=0;i++){
                     opp4[i].check__c = false;
                 }
             }
         }update opp4;
     }}
 }