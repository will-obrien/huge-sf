trigger ChangeValueBeforeAccountUpdate on Account (before update) {
    for(Account a:trigger.new){
        Account oldAccount = Trigger.oldMap.get(a.ID);
        if(oldAccount.Workflow_Sub_Territory__c != a.Workflow_Sub_Territory__c){
        //check if Workflow_Sub_Territory__c field has been change
            if(a.Workflow_Sub_Territory__c != null && a.Exclude_from_Sub_Territory_Assignment__c != true){
                a.Sub_Territory__c = a.Workflow_Sub_Territory__c;
            }
        }
        //override sub territory (stop fire sub territory assignment workflow)
        /*if(!a.IsPersonAccount && oldAccount.Sub_Territory__c != a.Sub_Territory__c){
            a.Exclude_from_Sub_Territory_Assignment__c = true;
        }*/
    }
}