/*
    Test class: Contract_Clause_Test
*/

trigger Contract_Article_Trigger on Contract_Article__c (before insert, before update, before delete){
/*
    if(trigger.isBefore && trigger.isInsert){
        Set<Id> clauseId = new Set<Id>();
        
        for(Contract_Clause__c c : trigger.new){
            clauseId.add(c.Clause__c);
        }
        
        Map<Id, String> textClauseMap = Contract_Clause_Handler.getClauseDescription(clauseId);
        
        for(Contract_Clause__c c : trigger.new){
            c.Description__c = textClauseMap.get(c.Clause__c);
        }
    }

    if(trigger.isBefore && trigger.isUpdate){
        for(Contract_Clause__c c : trigger.new){
            if(c.Order__c == trigger.oldMap.get(c.Id).Order__c){
                if(!c.Can_be_Changed__c){
                    c.addError(System.Label.CCT02);
                }
            }
        }
    }
    
    if(trigger.isBefore && trigger.isDelete){
        if(trigger.old.size() == 1){
            for(Contract_Clause__c c : trigger.old){
                if(!c.Can_be_Removed__c && c.Order_Lock__c){
                    c.addError(System.Label.CCT01);
                }
            }
        }
    }
*/
}