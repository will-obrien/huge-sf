/**
 * This is the helper class for the PGI_Quote_CopyExpirationDate trigger. It contains methods to collect
 * the quotes for which service commencement date has been changed and copye the expriation date on corresponding Qlis.
 *
 * @author Amit M.
 * @version 1.0
 */
public with sharing class PGICopyExpirationDateHandler {
	
	/**
	 * Collects quotes for which service commencement date is upated.
	 *
	 * @param quoteList, list of quote objects.
	 * @param oldQuoteMap, map of old quotes in the trigger on context.
	 */
	public void collectQuotes(List<Quote> quoteList, Map<Id, Quote> oldQuoteMap)
	{
		if (quoteList != null && oldQuoteMap != null)
		{
			Set<Id> quoteIds = new Set<Id>();
			for(Quote quote : quoteList)
			{ 
				if (quote != null)
				{
					Quote oldQuote = oldQuoteMap.get(quote.Id);
					// check if service commencement date is updated, then only update the quote line items.
					if (oldQuote != null && oldQuote.Service_Commencement_Date__c != quote.Service_Commencement_Date__c)
					{
						quoteIds.add(quote.Id);
					}
				}
			}
			this.copyExpirationDateForQuoteQlis(quoteIds);
		}
	}
	
	/**
	 * Retrieves the parent QLIs for the given quote ids and copies the expiration date to Expiration_Date_Copy__c.
	 *
	 * @param quoteIds, set of quote ids.
	 */
	public void copyExpirationDateForQuoteQlis(Set<Id> quoteIds)
	{
		if (quoteIds != null && !quoteIds.isEmpty())
		{
			List<QuoteLineItem> qliList = [Select Id, Expiration_Date__c, Expiration_Date_Copy__c 
											From QuoteLineItem 
											Where QuoteId IN:quoteIds And Quote_Line_Item__c =:NULL];
			if (qliList != null && !qliList.isEmpty())
			{
				for (QuoteLineItem qli : qliList)
				{
					if (qli != null)
					{
						qli.Expiration_Date_Copy__c = qli.Expiration_Date__c;
					}
				}
				update qliList;
			}
		}
	}
}