/*
    Test class: Contract_Test
*/

trigger Contract_Trigger on Contract (after insert, after update){

    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        List<Contract> contracts = new List<Contract>();
        
        for(Contract c : trigger.new){
            if(trigger.isInsert || (trigger.isUpdate && c.Contract_Template__c != trigger.oldMap.get(c.Id).Contract_Template__c)){
                contracts.add(c);
            }
        }
        
        if(contracts.size() > 0){
            Contract_Handler.insertArticle(contracts);
        }
    }

}