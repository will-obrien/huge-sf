trigger CampanaTrigger on Campana__c (after insert) {
	System.debug('Iniciando Trigger... Campana__c');
	
	Set<ID> ids = Trigger.newMap.keySet();
   	List<Campana__c> campanas = [SELECT Id,  accountid__c, CampaignId__c, Lead__c
   							  FROM Campana__c WHERE 
   							  id in :ids];
   	Set<ID> acc_ids = new Set<ID>();

   	for (Campana__c c : campanas) {
   		if (c.accountid__c!=null) {
   			acc_ids.add(c.AccountId__c);
   		} 
   	}
	
	Map<ID, Account> accounts = new Map<ID, Account>([SELECT Id, PersonContactId
														 FROM Account]);


	for(Campana__c c : campanas){
		System.debug('Creando Miembros  de la campaña ');
		String lead = c.Lead__c;
		String campana = c.CampaignId__c;
		String cuenta = c.AccountId__c;
				System.debug('Campaña: ' + campana);
		System.debug('Cuenta: ' + cuenta);
		String contacto = null;
		if (cuenta!=null) {
			 contacto = accounts.get(cuenta).PersonContactId;
		} 
			System.debug('Contacto: ' + contacto);
			if (campana!=null && (contacto!=null || lead!=null)) {
				CampaignMember cm=new CampaignMember(CampaignId=campana,contactId=contacto,Status='Added', LeadId=lead);	
	    		try {
	    			insert cm; 
	    			System.debug('Insertado OK');
	    		}
	    		catch (Exception e) {
	    			System.debug('Parece que el contacto '+contacto+' ya era miembro de la campaña '+campana);
	    		}
	    		
	    	}
	    
	     
   }
}