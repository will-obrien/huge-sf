trigger SeatReduction on Ticket__c (after insert) {
	Set<ID> consertIdSet = new Set<ID>(); 
	for(Ticket__c ticket : Trigger.new){
		consertIdSet.add(ticket.ConcertName__c);
	}
	List<Concert__c> consertName = [SELECT ID,AvailableSeats__c FROM Concert__c WHERE ID IN: consertIdSet];
	List<Concert__c> updatedConcert = new List<Concert__c>();
	for(Concert__c concert : consertName)
	{
		concert.AvailableSeats__c--;
		updatedConcert.add(concert);
	}

	update updatedConcert;

}