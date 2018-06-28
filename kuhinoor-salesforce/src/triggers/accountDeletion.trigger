trigger accountDeletion on Account (Before insert) {
    //  prevent the deletion if Account has related objects
    /*
    for(Account acc : [SELECT Id FROM account WHERE id IN (SELECT AccountId FROM contact) AND id IN : trigger.old]){
        Trigger.oldMap.get(acc.id).addError('CanNot delete this Account');        
    }
    */
    boolean bln = trigger.oldMap.isEmpty()?true:false;
}