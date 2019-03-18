trigger Attachment_QuoteCount on Attachment (before delete, after insert, after undelete) {

    /*set<Id> QuoteIds = new set<Id>();
    list<Attachment> attachments;

    if (Trigger.isDelete) {
        attachments = Trigger.old;
    } else {
        attachments = Trigger.new;
    }

    for (Attachment attachment : attachments) {
        QuoteIds.add(attachment.ParentId);
    }

    QuoteAttachmentCount.updateQuoteIds(QuoteIds , Trigger.isDelete);*/
}