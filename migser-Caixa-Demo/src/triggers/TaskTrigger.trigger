trigger TaskTrigger on Task (after insert) {

	System.debug('Iniciando TriggerTask');
	
	Set<ID> ids = Trigger.newMap.keySet();


   	System.debug('TriggerTask: numero de tareas inicial: '+ids.size());

   	List<Task> tasks = [SELECT Id, subject, createddate, 
   							Accountid,motivo__c,whoid,createdbyid ,Fecha_Proxima_Renovacion__c,
   							FirstName__c, LastName__c, Phone__c, accountowner__c
   					   FROM Task 
   					   where motivo__c = 'Duplicado Poliza' 
   							 and id in :ids
   							 and Accountid <> null];
   	System.debug('TriggerTask: numero de tareas: '+tasks.size());
   	Set<ID> acc_ids = new Set<ID>();

   	for (Task t : tasks) {
   		acc_ids.add(t.AccountId);
   	}
	
	Map<ID, Account> accounts = new Map<ID, Account>([SELECT Id, PersonContactId,
															 Customer_Satisfaction_PA__c,
															 Segmento__c,
															 FirstName,
															 LastName,
															 Phone,
															 IsPersonAccount,
															 ownerid,
															 fecha_Renovacion_Proxima__c
														 FROM Account
														 where id in :acc_ids ]);

	for(Task t : tasks){
		System.debug('Procesando Tareas ');
		
		Account cuenta = accounts.get(t.accountid);

		t.Fecha_Proxima_Renovacion__c=cuenta.fecha_Renovacion_Proxima__c;
		t.Segmento__c = cuenta.Segmento__c;
		t.Customer_Satisfaction_PA__c=cuenta.Customer_Satisfaction_PA__c;
		t.FirstName__c = cuenta.FirstName;
		t.LastName__c = cuenta.LastName;
		t.Phone__c = cuenta.Phone;
		t.accountowner__c = cuenta.OwnerId;

	}

	update tasks;

	//Cambia de estado las accounts a las que se les crea una tarea a Agendadas si eran lista corta
	// 22/07/2015

	List <Task> TareasAgen = [SELECT Accountid, Account.Sistem_tica__c
   					   FROM Task 
   					   where 
   							 id in :ids
   							 and Accountid <> null
   							 and Account.Sistem_tica__c='En lista corta'];
   	List<Account> upd_acc = new List<Account>();						 
   	for (Task t : TareasAgen) {
   		Account a = new Account (id = t.Accountid, Sistem_tica__c='Agendado');
   		upd_acc.add(a);
   	}
   	update upd_acc;

		System.debug('Procesando Tareas --> OK');
		




}