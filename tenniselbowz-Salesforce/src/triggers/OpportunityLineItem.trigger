trigger OpportunityLineItem on OpportunityLineItem (before delete) {
    if(trigger.isBefore) {
        if(trigger.isDelete) {
            new PreventDeleteHandler(trigger.old).addError();
        }
    }
}