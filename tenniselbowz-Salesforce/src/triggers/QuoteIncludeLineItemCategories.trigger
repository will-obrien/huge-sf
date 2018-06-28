trigger QuoteIncludeLineItemCategories on Apttus_Proposal__Proposal__c (Before Update) {
   /*
    Map<Id, Apttus_Proposal__Proposal__c> qL = new Map<Id, Apttus_Proposal__Proposal__c>([SELECT Id,Included_Line_Item_Categories__c FROM Apttus_Proposal__Proposal__c WHERE Id IN :Trigger.New]);
   
    for(Apttus_Proposal__Proposal__c apLoop: Trigger.new){
        //system.debug('this is debug statement:' + apLoop.id);
        apLoop.Included_Line_Item_Categories__c = '';
    }   
    
    for (Apttus_Proposal__Proposal_Line_Item__c qLI2: [SELECT Id, Apttus_QPConfig__ClassificationId__r.Name, Apttus_Proposal__Proposal__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c IN:qL.Keyset()]){
        //system.debug('in second for loop:'+ qLI2.id);
        Apttus_Proposal__Proposal__c Qt = Trigger.newmap.get(qLI2.Apttus_Proposal__Proposal__c);
        if(Qt.Included_Line_Item_Categories__c =='')
            Qt.Included_Line_Item_Categories__c  = qLI2.Apttus_QPConfig__ClassificationId__r.Name;
        else
            Qt.Included_Line_Item_Categories__c  = Qt.Included_Line_Item_Categories__c  +', ' +qLI2.Apttus_QPConfig__ClassificationId__r.Name;
    }
    */
    
    if(Trigger.isBefore && Trigger.isUpdate){                  //before update
        QuoteProposalTriggerHandler.concatenateTKClauses(Trigger.newMap, Trigger.oldMap);
    }
    
}