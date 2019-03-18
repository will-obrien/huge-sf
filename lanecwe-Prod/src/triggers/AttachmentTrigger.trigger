trigger AttachmentTrigger on Attachment (before delete, after delete, after insert, after update, after undelete){ 
	if(Trigger.isBefore){
		if(Trigger.isDelete){
			PGIAttachmentTriggerHelper triggerHelper = new PGIAttachmentTriggerHelper();
			triggerHelper.onBeforeDelete();
			QuoteAttachmentCount.updateQuoteIds(Trigger.old, Trigger.isDelete);
		}
	}
	else if (Trigger.isAfter){
		if(Trigger.isInsert){
			QuoteAttachmentCount.updateQuoteIds(Trigger.new, Trigger.isDelete);
			AttachmentUtil.doThis(Trigger.new);
		}
		else if(Trigger.isUndelete){
			QuoteAttachmentCount.updateQuoteIds(Trigger.new, Trigger.isDelete);
		}
		else if(Trigger.isUpdate){
			AttachmentUtil.doThis(Trigger.new);
		}
		else if(Trigger.isDelete){
			pgiupdateQuoteStatus.updateQuoteStatus(Trigger.old, Trigger.isDelete);
		}
	}
}