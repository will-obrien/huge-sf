trigger CreateDeal_Lead on Lead (after insert, after update, after delete) {
	if(trigger.IsUpdate){
        List <Deal__c> updeal=new List <Deal__c>();
        List <Deal__c> deldeal=new List <Deal__c>();
        List <Deal__c> udeal=new List <Deal__c>([Select Id, Deal_Id__c, Name, Status__c from Deal__c]);
        for(Lead ul: trigger.new){
            for(Deal__c ud: udeal){
                if(ud.Deal_ID__c==ul.id){
					if(ul.Salutation!=Null){
            			ud.Name=ul.Salutation+' '+ul.FirstName+' '+ul.LastName; 
        			}
        			else{
        				ud.Name=ul.FirstName + ' ' + ul.LastName;
        			}                   
                   ud.Status__c=ul.Status;
                   updeal.add(ud); 
                }
                else if(ud.Status__c== 'Closed - Converted'){
                    deldeal.add(ud);
                }
            }
            update updeal;
            delete deldeal;
        }
    }
    else if(trigger.IsInsert){
    List <Deal__c> ideal= new List<Deal__c>();    
    for(Lead il: trigger.new){
        Deal__c d= new Deal__c();
        d.RecordTypeId='012280000000xiT';
        if(il.Salutation!=Null){
            d.Name=il.Salutation+' '+il.FirstName+' '+il.LastName; 
        }
        else{
        	d.Name=il.FirstName + ' ' + il.LastName;
        }    
        d.Deal_Id__c= il.Id;
        d.Lead__c=il.Id;
        d.Status__c=il.Status;
        d.Type__c='Lead';
        ideal.add(d);
    }
    insert ideal;        
    }
    else if(trigger.isAfter && trigger.isDelete){
        List<Deal__c> existDeals = new List<Deal__c>([Select Id, Lead__c, Opportunity__c from Deal__c]);
        List<Deal__c> DealsToBeDel = new List<Deal__c>();
        for(Deal__c dtbd: existDeals){
            if(dtbd.Lead__c == Null && dtbd.Opportunity__c == Null){
                DealsToBeDel.add(dtbd);
            }
        }
        delete DealsToBeDel;
    }
}