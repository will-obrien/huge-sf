trigger checkboxTrigger on checkBoxTrigger__c (before insert,before update ) {
    list<checkBoxTrigger__c> recrdlst = new  list<checkBoxTrigger__c>([select test__c from checkBoxTrigger__c ]);
    list<checkBoxTrigger__c> isCheckLst = new   list<checkBoxTrigger__c>();
    public  id ids;
     if(Trigger.isInsert ){
          for(checkBoxTrigger__c  obj : Trigger.new){           
              if(obj.test__c = true){
                  for(checkBoxTrigger__c objRec : recrdlst ){
                      if( objRec.test__c = true){                         
                          ids =  objRec.id;        
                          system.debug('@@@@@@@@@'+ids);     
                            objRec.test__c = false;         
                      }                     
                  }
           }
    }
   UPDATE recrdlst;
     }
     
     
      if(trigger.isUpdate ){
      system.debug('#########'+ids);
          isCheckLst = [SELECT Id, lightingprefix__test__c FROM lightingprefix__checkBoxTrigger__c where id =: ids];
          for(checkBoxTrigger__c  obj : Trigger.new ){
              if(obj.test__c = false){
              
                    for(checkBoxTrigger__c obj1  : isCheckLst ){                        
                        obj1.test__c = true;
                    }
              }
          }
          UPDATE isCheckLst ;
      }
     
}