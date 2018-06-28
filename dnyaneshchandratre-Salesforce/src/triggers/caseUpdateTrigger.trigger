trigger caseUpdateTrigger on Case (before insert, before update) {

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            caseUpdateHandler.updateCase(Trigger.new);
        }
        if(Trigger.isUpdate) {
            caseUpdateHandler.updateCase(Trigger.new);
        }
    }
}