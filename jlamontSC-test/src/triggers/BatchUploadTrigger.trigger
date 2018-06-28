// *************************************************************************/
// rC_Connect__Batch_Upload__c Trigger
//      VB: This class is a wrapper for the KnowWho ZDM Single 
//          Address record service to update Batch Upload records
//           
//  2015/03/31      Peter Churchill     Original
//  2015/04/06      Vernon Baas         Commenting
//  2015/06         Mark Maslow         Clean up. Add call to AcknowledgeBatchUploadDonations
//  2015/12         Mark Maslow         Add call to BatchUploadAdjustNames
//  2016/03			Mark Maslow			Add call to BatchUploadBeforeInsertUpdate
//  2016/07         Mark Maslow         If updating account addresses, return immediately
// *************************************************************************/
trigger BatchUploadTrigger on rC_Connect__Batch_Upload__c (before insert, before update, after insert, after update) {

	if(BatchUploadTriggerHandler.updatingAccountAddress) {
		return;
	}
    AcknowledgeBatchUploadDonations uploadDonations = new AcknowledgeBatchUploadDonations();
    BatchUploadTriggerHandler buTriggerHandler = new BatchUploadTriggerHandler();

    // VB: Try to check to see if this has been run before.  
    //      This static value is defined in the BatchUploadTriggerHandler class

    if(BatchUploadTriggerHandler.isUpdateTrigger == NULL) {
        if (Trigger.isBefore && Trigger.IsInsert) {
            buTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isAfter && Trigger.IsUpdate) {
            buTriggerHandler.afterUpdate(Trigger.new);
        }
    }
    if( ! AcknowledgeBatchUploadDonations.donationsAcknowledged ) {
        if(Trigger.isAfter) {
            if(Trigger.isInsert) {
                uploadDonations.acknowledge(Trigger.new, null);
            }
            else if(Trigger.isUpdate) {
                uploadDonations.acknowledge(Trigger.new, Trigger.oldMap);
            }
        }
    }
    if(Trigger.isUpdate && Trigger.isAfter) {
        if( ! BatchUploadPostCommitProcessing.processingComplete) {
            BatchUploadPostCommitProcessing.afterBUUpdate(Trigger.New);
        }
        if( ! BatchUploadAdjustNames.namesAdjusted) {
            BatchUploadAdjustNames.adjustNames(Trigger.new, Trigger.oldMap);
        }
        if( ! BatchUploadPostFlaggedProcessing.flaggedBatchesProcessed) {
        	BatchUploadPostFlaggedProcessing.process(Trigger.new);
        }
    }
    if(Trigger.isBefore) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            if( ! BatchUploadBeforeInsertUpdate.processingComplete) {
                BatchUploadBeforeInsertUpdate.process(Trigger.new);
            }
        }
    }
}