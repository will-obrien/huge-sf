public class pgiupdateQuoteStatus
{
	public static void updateQuoteStatus(List<Attachment> attachments, boolean isDelete)
	{  
		set<Id> QuoteIds = new set<Id>();
		if(attachments != null){
			for (Attachment attachment : attachments) {
	        	QuoteIds.add(attachment.ParentId);
	   		}
		}
   		
		map<Id, Quote> Quotes;
	 	if (QuoteIds== null) {
			Quotes = new map<Id, Quote>([select Id from Quote]);           
		}
		else {
		  	Quotes = new map<Id, Quote>([select Id, Status from Quote where Id in :QuoteIds]);
		}
        List<Quote> quoteList = new List<Quote>();
        if (Quotes != null && !Quotes.isEmpty())
        {
        	for (Quote c : Quotes.values()) 
		    {
				if(isDelete){
		            c.status =QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ReadyforContract.name()).StatusValue__c;
		 			quoteList.add(c);
		        }
			}
        }
        if (!quoteList.isEmpty() && !PGIAppConstants.FROM_CANCEL_CONTRACT_TRIGGER)
        {
        	update quoteList;
        }
    }
}