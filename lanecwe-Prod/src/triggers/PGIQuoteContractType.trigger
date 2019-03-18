trigger PGIQuoteContractType  on Quote (after insert,after update) {

	// check if current user profile is not "PGI Contract Manager"
	if (PGIAppStaticResources.currentUserProfile != null 
		&& !PGIAppConstants.PROFILES_CANNOT_UPDATE_CONTRACT_TYPES.contains(PGIAppStaticResources.currentUserProfile.Name))
	{ 
	    If(PGIOppSolnTriggerHelper.ExecutedTriggers.contains('PGIQuoteContractType'))
	        return;
	    PGIOppSolnTriggerHelper.ExecutedTriggers.add('PGIQuoteContractType');
	    string profilename=[select name from profile where id=:userinfo.getProfileId()].name ;
	    list<Quote > quotelst=new list<Quote >();
	    set<Id> quoteIdlst=new set<Id>();
	    if(trigger.isInsert||trigger.isUpdate)
	    {
	         quotelst=Trigger.new;
	    }
	    for(Quote quote:quotelst){
	       quoteIdlst.add(quote.Id); 
	    }
		PGIQuoteLineItemTriggerUtilities.updateContractType(quoteIdlst);
	}
}