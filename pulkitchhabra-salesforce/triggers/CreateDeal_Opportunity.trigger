trigger CreateDeal_Opportunity on Opportunity (after insert, after update, after delete){
	if(trigger.isUpdate){
        List<Deal__c> updeal= new List<Deal__c>();
        List<Deal__c> udeal= new List<Deal__c>([Select Id, Deal_Id__c, Name, Status__c from Deal__c]);
            for(Opportunity op:trigger.new){
                for(Deal__c ud:udeal){
                    if(ud.Deal_Id__c==op.Id){
                        ud.Name=op.Name;
                        ud.Status__c=op.StageName;
                        updeal.add(ud);
                    }
                }
                update updeal;
            }
    }
    else if(trigger.isInsert){
        List <Deal__c> iDeal= new List<Deal__c>();
        for(Opportunity o:trigger.new){
            Deal__c d= new Deal__c();
            d.RecordTypeId='012280000000xXP';
            d.Name=o.Name;
            d.Deal_Id__c=o.Id;
            d.Opportunity__c=o.Id;
            d.Status__c=o.StageName;
            d.Type__c='Opportunity';
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