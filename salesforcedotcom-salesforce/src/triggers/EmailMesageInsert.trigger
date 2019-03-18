trigger EmailMesageInsert on EmailMessage (before insert, after insert) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        
        System.debug('APEX>EMAILMESSAGEINSERT>BEFOREINSERT');
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
        
        System.debug('APEX>EMAILMESSAGEINSERT>AFTERINSERT');
        }
    }
}