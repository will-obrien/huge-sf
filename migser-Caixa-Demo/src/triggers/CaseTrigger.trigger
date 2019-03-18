trigger CaseTrigger on Case (after insert) {

	Set<Id> ids = Trigger.newMap.keySet();
	List<Case> casos = [SELECT Id, Segmento__c, FirstName__c, LastName__c, Accountid
						from Case
						where id in :ids
   							 and Accountid <> null];
   	Set<ID> acc_ids = new Set<ID>();

   	for (Case c : casos) {
   		acc_ids.add(c.AccountId);
   	}

   	Map<ID, Account> accounts = new Map<ID, Account>([SELECT Id, 
															 Segmento__c,
															 FirstName,
															 LastName,															 
															 IsPersonAccount,
															 ownerid
														 FROM Account
														 where id in :acc_ids ]);
   	for(Case c : casos){
		
		Account cuenta = accounts.get(c.accountid);

		
		c.Segmento__c = cuenta.Segmento__c;
		c.FirstName__c = cuenta.FirstName;
		c.LastName__c = cuenta.LastName;
		c.accountowner__c = cuenta.OwnerId;

	}

	update casos;
}