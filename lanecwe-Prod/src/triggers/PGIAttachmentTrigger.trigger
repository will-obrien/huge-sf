/**
 * This trigger checks if attachment is allowed to delete for certain quote statuses or not.
 *
 * @author Amit M.
 * @version 1.0
 */
trigger PGIAttachmentTrigger on Attachment (before delete) {

    /* Stores instance of trigger helper class. */
    PGIAttachmentTriggerHelper triggerHelper = new PGIAttachmentTriggerHelper();
    
    if (Trigger.isBefore && Trigger.isDelete)
    {
        triggerHelper.onBeforeDelete();
    }
}