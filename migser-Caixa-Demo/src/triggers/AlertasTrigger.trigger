trigger AlertasTrigger on Alerts__c (after insert) {
	//Larry Baxter PA ID: 0015800000328gNAAQ
	//Larry Baxter Jones: 001580000084bySAAQ
	/*Set<Id> ids = Trigger.newMap.keySet();
	List<Alerts__c> alertas = [SELECT Id, Name, Account__c, Channel__c, CreatedById, Description__c,
								Creation_date__c, Source__c, OwnerId, Type__c, LastModifiedById
						from Alerts__c
						where id in :ids and Account__c = '0015800000328gNAAQ'];
	List<Alerts__c> nuevas_alertas = new List<Alerts__c>();
	for (Alerts__c a : alertas ) {
		Alerts__c nueva =new Alerts__c (Account__c='001580000084bySAAQ',
										Channel__c=a.Channel__c, CreatedById=a.CreatedById,
										Description__c=a.Description__c,Creation_date__c=a.Creation_date__c, 
										Source__c=a.Source__c,OwnerId=a.OwnerId,Type__c=a.Type__c,
										LastModifiedById=a.LastModifiedById);
		nuevas_alertas.add(nueva);
	}
	insert(nuevas_alertas);
	*/
	Set<Id> ids = Trigger.newMap.keySet();
	List<Alerts__c> alertas = [SELECT Id, Name, Account__c, Channel__c, CreatedById, Description__c,
								Creation_date__c, Source__c, OwnerId, Type__c, LastModifiedById
						from Alerts__c
						where id in :ids];

	Set<ID> acc_ids = new Set<ID>();

   	for (Alerts__c a : alertas) {
   		if (a.Account__c!=null) {
   			acc_ids.add(a.Account__c);
   		} 
   	}
	
	Map<ID, Account> accounts = new Map<ID, Account>([SELECT Id, Riesgo_abandono__c
														 FROM Account
														 where id in :acc_ids]);

	List<Account> acc_upd = new List<Account>();

	for( Alerts__c a : Trigger.new ) {
		if (a.Description__c.equals('ATENCIÓN: el cliente está en riesgo de abandono ALTO')) {
			Account acc = accounts.get(a.Account__c);
			acc.Riesgo_abandono__c = 'Alto';
			acc_upd.add(acc); 
		}
	}
	update(acc_upd);
}