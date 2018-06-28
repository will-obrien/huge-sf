/**
 * This is helper class for PGIAttachmentTrigger. It contains the helper methods to check
 * whether attachment on quote can be delete for certain statuses.
 *
 * @author Amit M.
 * @version 1.0
 */
public with sharing class PGIAttachmentTriggerHelper {
	
	/* Stores set of quote statuses for which attachment cannot be deleted. */
	private static final Set<String> QUOTE_STATUSES_NOT_ALLOWED_FOR_DELETE = new Set<String>{PGIAppConstants.QUOTE_STATUSES[5], 
																							PGIAppConstants.QUOTE_STATUSES[6], 
																							PGIAppConstants.QUOTE_STATUSES[7], 
																							PGIAppConstants.QUOTE_STATUSES[8], 
																							PGIAppConstants.QUOTE_STATUSES[9], 
																							PGIAppConstants.QUOTE_STATUSES[10]};
	/**
	 * Collects the parend ids of the attachment objects that are in trigger context.
	 */
	public void onBeforeDelete()
	{
		Set<Id> parentIds = new Set<Id>();
		
		// This boolean is false when quote attachment is deleted by clicking 'Cancel Contract' button
		// on quote detail page.
		if (PGIAppConstants.CHECK_QUOTE_STATUS)
		{
			for (Attachment attachment : (List<Attachment>)Trigger.old)
			{
				if (attachment != null)
				{
					parentIds.add(attachment.ParentId);
				}
			}
			this.canDeleteQuoteAttachment(parentIds);
		}
		else
		{
			PGIAppConstants.CHECK_QUOTE_STATUS = true;
		}
	}
	
	/**
	 * Retrieves the Quotes for the given ids and checks if delete is allowed for the attachment or not, 
	 * based on quote status.
	 *
	 * @param parentIds set of parent ids for attachment.
	 */
	private void canDeleteQuoteAttachment(Set<Id> parentIds)
	{
		if (parentIds != null && !parentIds.isEmpty())
		{
			Map<Id, Quote> quoteMap = new Map<Id, Quote>([select id, status from quote where id IN:parentIds]);
			for (Attachment attachment : (List<Attachment>)Trigger.old)
			{
				if (attachment != null)
				{
					Quote quote = quoteMap.get(attachment.ParentId);
					if (quote != null && QUOTE_STATUSES_NOT_ALLOWED_FOR_DELETE.contains(quote.Status))
					{
						attachment.addError(system.label.PGI_CANNOT_DELETE_QUOTE_ATTACHMENT);
					}
				}
			}
		}
	}
}