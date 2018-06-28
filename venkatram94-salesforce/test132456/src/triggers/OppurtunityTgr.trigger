trigger OppurtunityTgr on Opportunity (before insert) {
     for(Opportunity op:Trigger.new){
         integer closDate = op.CloseDate.daysBetween(Date.today());
          if(closDate <30) {
              op.CloseDate = Date.today()+30; 
          }
     } 
}