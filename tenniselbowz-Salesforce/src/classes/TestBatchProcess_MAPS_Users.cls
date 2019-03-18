/**
 *
 */
@isTest
private class TestBatchProcess_MAPS_Users {
	@isTest(seeAllData=true)
    static void testUsers()
	 {
	 	//create user roles that align with our custom setting
	 	//UserRole pr = new UserRole(Name = 'Service');
	 	//insert pr;
	 	/*UserRole r = [select Id from UserRole where Name = 'MCP'];
	 	
	 	//create users
	 	User u = new User(Alias = 'standt'
                          , Email='standarduser@daikintest.com'
                          , EmailEncodingKey='UTF-8'
                          , LastName='Testing'
                          , LanguageLocaleKey='en_US'
                          , LocaleSidKey='en_US'
                          , ProfileId = UserInfo.getProfileId()
                          , TimeZoneSidKey='America/Los_Angeles'
                          , UserName='standarduser@daikintest.com'
                          , isActive = true
                          , UserRoleId = r.Id
                          , Exclude_User_for_Quota_Planning__c = false);
	 	
	 	insert u;
	 	//create custom setting values
	 	Maps_LOB__c mapsLob = new Maps_LOB__c(name = 'MCP', Field_Identifier__c = 'MCP');
	 	insert mapsLob;
	 	
	 	//create quota records
	 	Sales_Rep_Quota__c sq = new Sales_Rep_Quota__c();
	 	sq.User__c = UserInfo.getUserId();//u.Id;
	 	
	 	//dynamicaly give all the quata fields the same value
	 	Schema.DescribeSObjectResult d = Sales_Rep_Quota__c.sObjectType.getDescribe();
	 	Map<String, Schema.Sobjectfield> mapFieldList = d.fields.getMap();
        for(Schema.SObjectField field : mapFieldList.values())  
        {  
            Schema.DescribeFieldResult fieldResult = field.getDescribe();  
            if(fieldResult.getSOAPType().name() == 'Double' && fieldResult.isUpdateable())  
            {  
                sq.put(fieldResult.getName(), 100);
            }  
        }
        
        insert sq;
	 	
	 	//create Opportunities
	 	Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678',McQuay_Gear__c = 'NO',Industry = 'HealthCare');
		insert acc;
		Opportunity opp=new Opportunity();
		
		opp.Name = 'TEST OPP';
		opp.AccountId = acc.Id;
		opp.Opp_City__c = 'ALPHARETTA';
		opp.Opp_State__c = 'GA';
		opp.StageName = 'Closed Won';
		opp.Probability = 1.00;
		opp.Amount = 100.00;
		opp.ForecastCategoryName = 'Pipeline';
		opp.CloseDate = system.today().addDays(-1);
		opp.Description = 'TEST OPP CREATED';
		opp.Type = 'Existing Business';
		opp.Project_Bill_Process__c = 'POC / SOV';
		opp.Region_Territory__c = 'Southeast';
		opp.OwnerId = UserInfo.getUserId();//u.Id;
		insert opp;
	 	*/
	 	//execute the batch process
	 	Test.startTest();
	 	    BatchProcess_MAPS_Users b = new BatchProcess_MAPS_Users();
	 	    //b.testUsers = new set<Id>{u.Id};
	 		Database.executeBatch(b, 2000);
	 	
		 	//verify that we have at least one record
		 	//System.assert([select Id from MAPS_Reporting__c ].size() > 0);//where Summary_Type_Id__c = :u.Id and Summary_Level__c = 'MCP'
		 	//System.Debug([select Closed_Won_MTD__c, Closed_Won_v_Quota_MTD__c from MAPS_Reporting__c where Summary_Type_Id__c = :u.Id and Summary_Level__c = 'MCP']);
	 	Test.stopTest();
	 }
	 
	@isTest(seeAllData=true)
    static void testRoles()
	 {
	 	//create user roles that align with our custom setting
	 	//UserRole pr = new UserRole(Name = 'Service');
	 	//insert pr;
	 	/*UserRole r = [select Id from UserRole where Name = 'MCP'];
	 	
	 	//create users
	 	User u = new User(Alias = 'standt'
                          , Email='standarduser@daikintest.com'
                          , EmailEncodingKey='UTF-8'
                          , LastName='Testing'
                          , LanguageLocaleKey='en_US'
                          , LocaleSidKey='en_US'
                          , ProfileId = UserInfo.getProfileId()
                          , TimeZoneSidKey='America/Los_Angeles'
                          , UserName='standarduser@daikintest.com'
                          , isActive = true
                          , UserRoleId = r.Id
                          , Exclude_User_for_Quota_Planning__c = false);
	 	
	 	insert u;
	 	//create custom setting values
	 	Maps_LOB__c mapsLob = new Maps_LOB__c(name = 'MCP', Field_Identifier__c = 'MCP');
	 	insert mapsLob;
	 	
	 	//create quota records
	 	Sales_Rep_Quota__c sq = new Sales_Rep_Quota__c();
	 	sq.User__c = UserInfo.getUserId();//u.Id;
	 	
	 	//dynamicaly give all the quata fields the same value
	 	Schema.DescribeSObjectResult d = Sales_Rep_Quota__c.sObjectType.getDescribe();
	 	Map<String, Schema.Sobjectfield> mapFieldList = d.fields.getMap();
        for(Schema.SObjectField field : mapFieldList.values())  
        {  
            Schema.DescribeFieldResult fieldResult = field.getDescribe();  
            if(fieldResult.getSOAPType().name() == 'Double' && fieldResult.isUpdateable())  
            {  
                sq.put(fieldResult.getName(), 100);
            }  
        }
        
        insert sq;
	 	
	 	//create Opportunities
	 	Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678',McQuay_Gear__c = 'NO',Industry = 'HealthCare');
		insert acc;
		Opportunity opp=new Opportunity();
		
		opp.Name = 'TEST OPP';
		opp.AccountId = acc.Id;
		opp.Opp_City__c = 'ALPHARETTA';
		opp.Opp_State__c = 'GA';
		opp.StageName = 'Closed Won';
		opp.Probability = 1.00;
		opp.Amount = 100.00;
		opp.ForecastCategoryName = 'Pipeline';
		opp.CloseDate = system.today().addDays(-1);
		opp.Description = 'TEST OPP CREATED';
		opp.Type = 'Existing Business';
		opp.Project_Bill_Process__c = 'POC / SOV';
		opp.Region_Territory__c = 'Southeast';
		opp.OwnerId = UserInfo.getUserId();//u.Id;
		insert opp;
	 	*/
	 	//execute the batch process
	 	Test.startTest();
	 	    BatchProcess_MAPS_Roles b = new BatchProcess_MAPS_Roles();
	 	    //b.testUsers = new set<Id>{u.Id};
	 		Database.executeBatch(b, 1000);
	 	
		 	//verify that we have at least one record
		 	//System.assert([select Id from MAPS_Reporting__c ].size() > 0);//where Summary_Type_Id__c = :u.Id and Summary_Level__c = 'MCP'
		 	//System.Debug([select Closed_Won_MTD__c, Closed_Won_v_Quota_MTD__c from MAPS_Reporting__c where Summary_Type_Id__c = :u.Id and Summary_Level__c = 'MCP']);
	 	Test.stopTest();
	 }
	 
	 @isTest(seeAllData=true)
     static void testTotals()
	 {
	 	//create user roles that align with our custom setting
	 	//UserRole pr = new UserRole(Name = 'Service');
	 	//insert pr;
	 	/*UserRole r = [select Id from UserRole where Name = 'MCP'];
	 	
	 	//create users
	 	User u = new User(Alias = 'standt'
                          , Email='standarduser@daikintest.com'
                          , EmailEncodingKey='UTF-8'
                          , LastName='Testing'
                          , LanguageLocaleKey='en_US'
                          , LocaleSidKey='en_US'
                          , ProfileId = UserInfo.getProfileId()
                          , TimeZoneSidKey='America/Los_Angeles'
                          , UserName='standarduser@daikintest.com'
                          , isActive = true
                          , UserRoleId = r.Id
                          , Exclude_User_for_Quota_Planning__c = false);
	 	
	 	insert u;
	 	//create custom setting values
	 	Maps_LOB__c mapsLob = new Maps_LOB__c(name = 'MCP', Field_Identifier__c = 'MCP');
	 	insert mapsLob;
	 	
	 	//create quota records
	 	Sales_Rep_Quota__c sq = new Sales_Rep_Quota__c();
	 	sq.User__c = UserInfo.getUserId();//u.Id;
	 	
	 	//dynamicaly give all the quata fields the same value
	 	Schema.DescribeSObjectResult d = Sales_Rep_Quota__c.sObjectType.getDescribe();
	 	Map<String, Schema.Sobjectfield> mapFieldList = d.fields.getMap();
        for(Schema.SObjectField field : mapFieldList.values())  
        {  
            Schema.DescribeFieldResult fieldResult = field.getDescribe();  
            if(fieldResult.getSOAPType().name() == 'Double' && fieldResult.isUpdateable())  
            {  
                sq.put(fieldResult.getName(), 100);
            }  
        }
        
        insert sq;
	 	
	 	//create Opportunities
	 	Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678',McQuay_Gear__c = 'NO',Industry = 'HealthCare');
		insert acc;
		Opportunity opp=new Opportunity();
		
		opp.Name = 'TEST OPP';
		opp.AccountId = acc.Id;
		opp.Opp_City__c = 'ALPHARETTA';
		opp.Opp_State__c = 'GA';
		opp.StageName = 'Closed Won';
		opp.Probability = 1.00;
		opp.Amount = 100.00;
		opp.ForecastCategoryName = 'Pipeline';
		opp.CloseDate = system.today().addDays(-1);
		opp.Description = 'TEST OPP CREATED';
		opp.Type = 'Existing Business';
		opp.Project_Bill_Process__c = 'POC / SOV';
		opp.Region_Territory__c = 'Southeast';
		opp.OwnerId = UserInfo.getUserId();//u.Id;
		insert opp;
	 	*/
	 	//execute the batch process
	 	Test.startTest();
	 	    BatchProcess_MAPS_Total b = new BatchProcess_MAPS_Total();
	 	    //b.testUsers = new set<Id>{u.Id};
	 		Database.executeBatch(b, 1000);
	 	
		 	//verify that we have at least one record
		 	//System.assert([select Id from MAPS_Reporting__c ].size() > 0);//where Summary_Type_Id__c = :u.Id and Summary_Level__c = 'MCP'
		 	//System.Debug([select Closed_Won_MTD__c, Closed_Won_v_Quota_MTD__c from MAPS_Reporting__c where Summary_Type_Id__c = :u.Id and Summary_Level__c = 'MCP']);
	 	Test.stopTest();
	 }
	 
	 @isTest(seeAllData=true)
     static void testTotals_User()
	 {
	 	//create user roles that align with our custom setting
	 	//UserRole pr = new UserRole(Name = 'Service');
	 	//insert pr;
	 	/*UserRole r = [select Id from UserRole where Name = 'MCP'];
	 	
	 	//create users
	 	User u = new User(Alias = 'standt'
                          , Email='standarduser@daikintest.com'
                          , EmailEncodingKey='UTF-8'
                          , LastName='Testing'
                          , LanguageLocaleKey='en_US'
                          , LocaleSidKey='en_US'
                          , ProfileId = UserInfo.getProfileId()
                          , TimeZoneSidKey='America/Los_Angeles'
                          , UserName='standarduser@daikintest.com'
                          , isActive = true
                          , UserRoleId = r.Id
                          , Exclude_User_for_Quota_Planning__c = false);
	 	
	 	insert u;
	 	//create custom setting values
	 	Maps_LOB__c mapsLob = new Maps_LOB__c(name = 'MCP', Field_Identifier__c = 'MCP');
	 	insert mapsLob;
	 	
	 	//create quota records
	 	Sales_Rep_Quota__c sq = new Sales_Rep_Quota__c();
	 	sq.User__c = UserInfo.getUserId();//u.Id;
	 	
	 	//dynamicaly give all the quata fields the same value
	 	Schema.DescribeSObjectResult d = Sales_Rep_Quota__c.sObjectType.getDescribe();
	 	Map<String, Schema.Sobjectfield> mapFieldList = d.fields.getMap();
        for(Schema.SObjectField field : mapFieldList.values())  
        {  
            Schema.DescribeFieldResult fieldResult = field.getDescribe();  
            if(fieldResult.getSOAPType().name() == 'Double' && fieldResult.isUpdateable())  
            {  
                sq.put(fieldResult.getName(), 100);
            }  
        }
        
        insert sq;
	 	
	 	//create Opportunities
	 	Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678',McQuay_Gear__c = 'NO',Industry = 'HealthCare');
		insert acc;
		Opportunity opp=new Opportunity();
		
		opp.Name = 'TEST OPP';
		opp.AccountId = acc.Id;
		opp.Opp_City__c = 'ALPHARETTA';
		opp.Opp_State__c = 'GA';
		opp.StageName = 'Closed Won';
		opp.Probability = 1.00;
		opp.Amount = 100.00;
		opp.ForecastCategoryName = 'Pipeline';
		opp.CloseDate = system.today().addDays(-1);
		opp.Description = 'TEST OPP CREATED';
		opp.Type = 'Existing Business';
		opp.Project_Bill_Process__c = 'POC / SOV';
		opp.Region_Territory__c = 'Southeast';
		opp.OwnerId = UserInfo.getUserId();//u.Id;
		insert opp;
	 	*/
	 	//execute the batch process
	 	Test.startTest();
	 	    BatchProcess_MAPS_Total_User b = new BatchProcess_MAPS_Total_User();
	 	    //b.testUsers = new set<Id>{u.Id};
	 		Database.executeBatch(b, 1000);
	 	
		 	//verify that we have at least one record
		 	//System.assert([select Id from MAPS_Reporting__c ].size() > 0);//where Summary_Type_Id__c = :u.Id and Summary_Level__c = 'MCP'
		 	//System.Debug([select Closed_Won_MTD__c, Closed_Won_v_Quota_MTD__c from MAPS_Reporting__c where Summary_Type_Id__c = :u.Id and Summary_Level__c = 'MCP']);
	 	Test.stopTest();
	 }
}