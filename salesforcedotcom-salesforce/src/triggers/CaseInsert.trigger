trigger CaseInsert on Case (before insert, after insert) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        
        System.debug('APEX>CASEINSERT>BEFOREINSERT');
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
        
        System.debug('APEX>CASEINSERT>AFTERINSERT');
        }
    }
}