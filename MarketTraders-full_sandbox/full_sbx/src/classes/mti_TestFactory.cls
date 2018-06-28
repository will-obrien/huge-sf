public class mti_TestFactory {
		
	public mti_TestFactory() {
		
	}
    
    public User getStandardTestUser(boolean preinsert) {
        Profile p = [SELECT Id FROM Profile WHERE Name='MTI Client Services (Fronter/Closer)']; 
        UserRole r = [SELECT Id FROM UserRole WHERE Name='Closer'];
        String firstName = this.generateRandomString(10);
        String lastName = this.generateRandomString(15);
        String alias = firstName.substring(0,0) + lastName.substring(0,4);
        String email = this.generateRandomEmail();
      	User u = new User(Alias = alias, Email=email, 
     		EmailEncodingKey='UTF-8', LastName=lastName, LanguageLocaleKey='en_US', 
  			LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=r.Id, 
      		TimeZoneSidKey='America/Los_Angeles', UserName=email
      	);
        if(preinsert)
            Database.insert(u);
        return u;
    }

	public list<Opportunity> getTestOpportunities(list<Account> testAccounts,String product,boolean preinsert) {
		list<Opportunity> testOpportunities = new list<Opportunity>();
		for(Account testAccount : testAccounts) {
			Opportunity testOpportunity = this.getTestOpportunity(testAccount,product,false);
			testOpportunities.add(testOpportunity);
		}
		if(preinsert)
			Database.insert(testOpportunities);
		return testOpportunities;
	}
	
	public Opportunity getTestOpportunity(Account testAccount,String product,boolean preinsert) {
		Opportunity testOpportunity = New  Opportunity();
    	testOpportunity.Name = this.generateRandomString(10);
        testOpportunity.CloseDate = Date.today().addDays(30);
        testOpportunity.Product__c = product;
        testOpportunity.StageName = 'New Deal';
        testOpportunity.AccountId = testAccount.id;
        if(preinsert)
        	Database.insert(testOpportunity);
        return testOpportunity;
	}
	
	public list<Account> getTestPersonAccounts(integer numberOfPersonAccounts,boolean preinsert) {
		list<Account> testPersonAccounts = new list<Account>();
		for(integer x = 0; x < numberOfPersonAccounts; x++) {
			Account testAccount = getTestPersonAccount(false);
			testPersonAccounts.add(testAccount);
		}
		if(preinsert)
			Database.insert(testPersonAccounts);
		return testPersonAccounts;
	}
	
	public Account getTestPersonAccount(boolean preinsert) {
		Account testAccount = new Account();
		testAccount.FirstName = this.generateRandomString(10);
		testAccount.LastName = this.generateRandomString(25);
		testAccount.PersonEmail = this.generateRandomEmail();
		testAccount.Alternate_Email__c = this.generateRandomEmail();
		testAccount.Phone = this.generateRandomNumberAsString(10);
		testAccount.Country_List__c = 'United States';
		if(preinsert)
			Database.insert(testAccount);
		return testAccount;
	}
	
	public list<Lead> getTestLeads(integer numberOfLeads,boolean preinsert) {
		list<Lead> leads = new list<Lead>();
		for(integer x = 0; x < numberOfLeads; x++) {
			Lead testLead = getTestLead(false);
			leads.add(testLead);
		}
		if(preinsert)
			Database.insert(leads);
		return leads;
	}
	
	public Lead getTestLead(boolean preinsert) {
		Lead lead = new Lead();
	    lead.FirstName = this.generateRandomString(10);
	    lead.LastName = this.generateRandomString(25);
	    lead.leadSource = this.generateRandomString(25);
	    lead.Email = this.generateRandomEmail();
	    lead.Phone = this.generateRandomNumberAsString(10);
	    lead.Alternate_Email__c =  this.generateRandomEmail();
	    lead.CountryList__c = 'United States';
	    if(preinsert)
	    	Database.insert(lead);
	    return lead;
	}

	public RecordType getRecordType(SObject record) {
		try{
			Id recordId = (Id)record.get('Id');
			String objectName = record.getSObjectType().getDescribe().getName();
			String SOQL = 'SELECT Id,RecordTypeId FROM ' + objectName + ' WHERE Id = :recordId';
			record = Database.query(SOQL);
			Id recordTypeId = (Id)record.get('RecordTypeId');
			if(recordTypeId == null)
				return null;
			RecordType recordType = [SELECT id,Name FROM RecordType WHERE Id = :recordTypeId];
			return recordType;
		}catch(Exception ex){
			return null;
		}
	}

	public Pricebook2 getTestPriceBook2(String name,boolean preinsert) {
		Pricebook2 testPriceBook2 = new Pricebook2();
		testPriceBook2.Name = name;
		testPriceBook2.Description = 'just testing';
		if(preinsert)
			Database.insert(testPriceBook2);
		return testPriceBook2;
	}
	
	public Product2 getTestProduct2(String name,boolean isActive,boolean preinsert) {
		Product2 testProduct2 = new Product2();
		testProduct2.Name = name;
		testProduct2.IsActive = isActive;
		testProduct2.Family = 'test';
		if(preinsert)
			Database.insert(testProduct2);
		return testProduct2;
	}
	
	public PricebookEntry getTestPricebookEntry(Pricebook2 testPriceBook2,Product2 testProduct2,decimal unitPrice,boolean preinsert) {
		PricebookEntry standardPriceBookEntry = new PricebookEntry();
		standardPriceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
		standardPriceBookEntry.UnitPrice = unitPrice;
		standardPriceBookEntry.Product2Id = testProduct2.Id;
		standardPriceBookEntry.isActive = true;
		Database.insert(standardPriceBookEntry);
		
		PricebookEntry testPriceBookEntry = new PricebookEntry();
		testPriceBookEntry.Pricebook2Id = testPriceBook2.Id;
		testPriceBookEntry.UnitPrice = unitPrice;
		testPriceBookEntry.Product2Id = testProduct2.Id;
		testPriceBookEntry.UseStandardPrice = false;
		testPriceBookEntry.isActive = true;
		if(preinsert)
			Database.insert(testPriceBookEntry);
		return testPriceBookEntry;
	}
	
	public OpportunityLineItem getTestOpportunityLineItem(Opportunity testOpportunity,PricebookEntry testPriceBookEntry,boolean preinsert) {
		OpportunityLineItem testLineItem = new OpportunityLineItem();
		testLineItem.OpportunityId = testOpportunity.Id;
		testLineItem.Quantity = 1;
		testLineItem.TotalPrice = testPriceBookEntry.UnitPrice;
		testLineItem.PricebookEntryId = testPriceBookEntry.Id;
		testLineItem.ServiceDate = Date.today().addDays(5);
		if(preinsert)
			Database.insert(testLineItem);
		return testLineItem;
	}
	
    public String getRandomCreditCardType(){
   		list<String> availableCardTypes = new list<String>{'Visa','MasterCard','American Express','Discover','Diners Club'};
   		Integer rand = Math.round(Math.random()*4);
   		return availableCardTypes[rand];
   	}
   	
   	public Webinar_Credentials__c getWebinarCredentials(boolean preinsert) {
   		Webinar_Credentials__c credentials = new Webinar_Credentials__c();
   		credentials.Name = 'test';
   		credentials.Org_ID__c = '123123';
   		credentials.Credentials_ID__c = this.generateRandomNumberAsString(8);
   		credentials.Token__c = 'asdagascvs23542sv';
   		credentials.Provider__c = 'Citrix';
   		if(preinsert)
   			Database.insert(credentials);
   		return credentials;
   	}
   	
   	public Webinar__c getWebinar(Webinar_Credentials__c credentials,boolean preinsert) {
   		Webinar__c webinar = new Webinar__c();
   		webinar.Name = this.generateRandomString(6);
   		webinar.Webinar_Id__c = this.generateRandomNumberAsString(8);
   		webinar.Event_Date_Time__c = DateTime.now();
   		webinar.Webinar_Credentials__c = credentials.Id;
   		webinar.DiscountDollar__c = this.generateRandomNumberAsString(4);
	 	webinar.DiscountPercent__c = this.generateRandomNumberAsString(2);
   		if(preinsert)
   			Database.insert(webinar);
   		return webinar;
   	}
   	
   	public list<Task> getTasks(Webinar__c webinar,String status,set<Id> whoIds,boolean preinsert) {
   		list<Task> tasks = new list<Task>();
   		for(Id whoId : whoIds){
   			tasks.add(this.getTask(webinar,status,whoId,false));
   		}
   		if(preinsert)
   			Database.insert(tasks);
   		return tasks;
   	}
   	
   	public Task getTask(Webinar__c webinar,String status,Id whoId,boolean preinsert) {
   		Task task = new Task();
   		task.Subject = 'Webinar';
   		task.Priority = 'Normal';
   		task.ActivityDate = webinar.Event_Date_Time__c.Date();
   		task.Event_Name__c = webinar.Name;
   		task.Webinar_Id__c = webinar.Webinar_Id__c;
   		task.Event_Date_Time__c = webinar.Event_Date_Time__c;
   		task.Activity_Type__c = 'UTP OnDemand';
   		task.Webinar_Type__c = 'Webinar';
   		task.Registered__c = true;
   		task.Attended__c = this.generateRandomBoolean();
   		task.Status = status;
   		task.WhoId = whoId;
   		task.Registration_Date__c = Date.today();
   		if(preinsert)
   			Database.insert(task);
   		return task;
   	}
    
    public list<et4ae5__SendDefinition__c> getTestSendDefinitions(integer numberOfDefinitions,boolean preinsert) {
        list<et4ae5__SendDefinition__c> testSendDefinitions = new list<et4ae5__SendDefinition__c>();
        for(integer x = 0; x < numberOfDefinitions; x++){
            String jobId = this.getRandomNumberAsString(8);
            et4ae5__SendDefinition__c testSendDefinition = this.getTestSendDefinition(jobId,false);
            testSendDefinitions.add(testSendDefinition);
        }
        if(preinsert)
            Database.insert(testSendDefinitions);
        return testSendDefinitions;
    }
    
    public et4ae5__SendDefinition__c getTestSendDefinition(String jobId,boolean preinsert) {
        et4ae5__SendDefinition__c testSendDefinition = new et4ae5__SendDefinition__c();
        testSendDefinition.et4ae5__JobId__c = jobId;
        if(preinsert)
            Database.insert(testSendDefinition);
        return testSendDefinition;
    }
    
    public list<et4ae5__IndividualEmailResult__c> getTestIndividualEmailResults(set<Id> relatedIds,et4ae5__SendDefinition__c sendDefinition,boolean preinsert){
    	 list<et4ae5__IndividualEmailResult__c> testIndividualEmailResults = new list<et4ae5__IndividualEmailResult__c>();
        for(Id relatedId : relatedIds){
            et4ae5__IndividualEmailResult__c testResult = this.getTestIndividualEmailResult(relatedId,sendDefinition,false);
            testIndividualEmailResults.add(testResult);
        }
        if(preinsert)
            Database.insert(testIndividualEmailResults);
        return testIndividualEmailResults;
    }
    
    Public et4ae5__IndividualEmailResult__c getTestIndividualEmailResult(Id relatedId,et4ae5__SendDefinition__c sendDefinition,boolean preinsert) {
        et4ae5__IndividualEmailResult__c testResult = new et4ae5__IndividualEmailResult__c();
        if(String.valueOf(relatedId).substring(0,3) == '00Q'){
   			testResult.et4ae5__Lead__c = relatedId;
   		}else{
   			testResult.et4ae5__Contact__c = relatedId;
   		}
        testResult.et4ae5__SendDefinition__c = sendDefinition.Id;
        if(preinsert)
            Database.insert(testResult);
        return testResult;
    }
   	
   	public list<Webinar_Attendance__c> getWebinarAttendances(Webinar__c webinar,String status,set<Id> whoIds,boolean preinsert) {
   		list<Webinar_Attendance__c> webinarAttendances = new list<Webinar_Attendance__c>();
   		for(Id whoId : whoIds){
   			webinarAttendances.add(this.getWebinarAttendance(webinar,status,whoId,false));
   		}
   		if(preinsert)
   			Database.insert(webinarAttendances);
   		return webinarAttendances;
   	}
   	
   	public Webinar_Attendance__c getWebinarAttendance(Webinar__c webinar,String status,Id whoId,boolean preinsert) {
   		Webinar_Attendance__c webinarAttendance = new Webinar_Attendance__c();
   		if(String.valueOf(WhoId).substring(0,3) == '00Q'){
   			webinarAttendance.Lead__c = whoId;
   		}else{
   			webinarAttendance.Account__c = whoId;
   		}
   		webinarAttendance.Attended__c = true;
   		webinarAttendance.Status__c = status;
		webinarAttendance.Duration__c = 0;
		webinarAttendance.Registration_Date__c = Date.today();
		webinarAttendance.Webinar__c = webinar.id;
		if(preinsert)
			Database.insert(webinarAttendance);
		return webinarAttendance;
   	}
   	
   	public String getRandomNumberAsString(integer numberLength){
   		list<String> availableNumbers = new list<String>{'1','2','3','4','5','6','7','8','9','0'};
   		String randomNumberString = '';
   		while(randomNumberString.length() < numberLength){
   			Integer rand = Math.round(Math.random()*9);
   			String randomNumber = availableNumbers[rand];
   			randomNumberString += randomNumber;
   		}
   		return randomNumberString;
   	}
   	
   	public String generateRandomNumberAsString(integer len) {
   		list<String> availableNumbers = new list<String>{'1','2','3','4','5','6','7','8','9','0'};
   		String randomNumberString = '';
   		while(randomNumberString.length() < len){
   			Integer rand = Math.round(Math.random()*9);
   			String randomNumber = availableNumbers[rand];
   			randomNumberString += randomNumber;
   		}
   		return randomNumberString;
   	}
   	
   	public integer generateRandomNumber(integer len) {
   		return Integer.valueOf(this.generateRandomNumberAsString(len));
   	}
   	
   	public boolean generateRandomBoolean() {
   		if(Math.random() > .5)
   			return true;
   		return false;
   	}
   	
   	public String generateRandomString(Integer len) {
	    final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
	    String randStr = '';
	    while (randStr.length() < len) {
	       Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
	       randStr += chars.substring(idx, idx+1);
	    }
	    return randStr; 
	}
	
	public String generateRandomEmail() {
		string email = this.generateRandomString(8);
		email += '@';
		email += this.generateRandomString(5);
		email += '.com';
		return email;
	}
    
}