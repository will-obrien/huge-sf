public with sharing class QuoteAttachmentCount {
	
	public static void updateAllQuotes() {
        updateQuoteIds(null,false);
    }
    
    public static void updateQuoteIds(List<Attachment> attachments, boolean isDelete) {
    	set<Id> QuoteIds = new set<Id>();
    	if(attachments != null){
	    	for (Attachment attachment : attachments) {
	        	QuoteIds.add(attachment.ParentId);
	    	}
    	}
    	
        map<Id, Quote> Quotes;

		if (!PGIAppConstants.FROM_CANCEL_CONTRACT_TRIGGER)
		{
			if (QuoteIds== null) {
            	Quotes = new map<Id, Quote>([select Id from Quote]);           
        	} else {
            	Quotes = new map<Id, Quote>([select Id, CountofQuote__c from Quote where Id in :QuoteIds]);
        	}
	        if (Quotes != null && !Quotes.isEmpty())
	        {
		        for (Quote c : Quotes.values()) {
		            c.CountofQuote__c = 0;
		        }
		        for (AggregateResult result : [select ParentId, count(Id) from Attachment where ParentId in :Quotes.keySet() group by ParentId]) {
		            decimal attachmentCount = (decimal)result.get('expr0');
		            if (isDelete) {
		                attachmentCount--;
		            }
		            Quotes.get((Id)result.get('ParentId')).CountofQuote__c = attachmentCount;
		        }
			    update Quotes.values();      
	        }
		}
    }
}