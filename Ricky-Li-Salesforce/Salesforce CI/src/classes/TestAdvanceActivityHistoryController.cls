@isTest(SeeAllData=true)
Public Class TestAdvanceActivityHistoryController{
    static testmethod void TestAdvanceActivityHistory(){
    	//Agency
    	 User adminUser = [Select Id from user where IsActive = true and firstName = 'Ricky' and lastName = 'Li' limit 1];
         Account acc = new Account(Name='Test', BillingState='ON', BillingCountry = 'Canada', OwnerId = adminUser.Id);
         insert acc;
         
         Task newTask = new Task(
			OwnerId = acc.OwnerId,
			Subject = 'Other',
			Priority = 'Normal',
			status = 'Completed',
			description = 'New Work'
		);
		insert newTask;
         
	    ApexPages.StandardController sc = new ApexPages.standardController(newTask);
	    AdvanceActivityHistoryController controller = new AdvanceActivityHistoryController(sc);
	    
	    //controller.runSearch();
	    controller.toggleSort();
	    //controller.deleteActivity();

    }
}