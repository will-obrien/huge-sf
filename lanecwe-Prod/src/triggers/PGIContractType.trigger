trigger PGIContractType on QuoteLineItem (after insert,after update,after delete) {
	// check if current user profile is not "PGI Contract Manager"
	if (PGIAppStaticResources.currentUserProfile != null 
		&& !PGIAppConstants.PROFILES_CANNOT_UPDATE_CONTRACT_TYPES.contains(PGIAppStaticResources.currentUserProfile.Name))
	{
	    list<QuoteLineItem> quotelinelst=new list<QuoteLineItem>();
	     set<Id> quoteIdlst=new set<Id>();
	    if(trigger.isInsert||trigger.isUpdate)
	    {
	         quotelinelst=Trigger.new;
	        
	    }
	    else if(trigger.isDelete)
	         {
	           quotelinelst=Trigger.old;
	         
	         }
	    
	    for(QuoteLineItem quoteLine:quotelinelst){
	       quoteIdlst.add(quoteLine.QuoteId); 
	    }
	    PGIQuoteLineItemTriggerUtilities.updateContractType(quoteIdlst);
	}
}