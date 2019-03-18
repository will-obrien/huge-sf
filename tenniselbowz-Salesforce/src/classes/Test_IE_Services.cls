/**
 * 
 */
@isTest
private class Test_IE_Services { 
	
	static testMethod void runTest() {
		//test the Individuals service
        Account a = new Account(Name = 'Test'
                    , IE_Sync_Status__c = 'Pending'
                    , IE_ID__c = '123'
                    , IE_Account__c = true
                    );
        insert a;
        
        Account a2 = new Account(Name = 'Test'
                    			, IE_Sync_Status__c = 'Pending'
                    			, BillingStreet = '1234\n4567\n8910'
                    			, BillingCity = 'Mlps'
                    			, BIllingState = 'Minnesota'
                    			, BillingCountry = 'United States'
                    			, BillingPostalCode = '55441'
                    			);
        insert a2;
        
        a2.BillingStreet = '1235\n45678\n8911';
        update a2;
        
        a2.Warehouse_Id__c = 'wiwiwiwi';
        update a2;
        
		map<String, Id> RecordTypeNameMap = new map<String, Id>();
		for(RecordType rt : [Select Name, SobjectType, Id 
		                       from RecordType 
		                      where Name in ('TRC', 'Address', 'SFDC Integration' )])
		{
			RecordTypeNameMap.put(rt.Name+'-'+rt.SobjectType, rt.Id);
		}
		
		IE_Service_Configuration__c ie = new IE_Service_Configuration__c();
		ie.Account_RecordType__c = RecordTypeNameMap.get('TRC-Account');
		ie.Address_RecordType__c = RecordTypeNameMap.get('Address-Address__c');
		ie.Contact_RecordType__c = RecordTypeNameMap.get('SFDC Integration-Contact');
		ie.Unit_Record_Type__c = '';
		ie.DaikinAccountId__c = a.Id;
		ie.endpoint__c = 'http://daikin-iep-service-qa.cloudapp.net/SalesforceIntegration.svc';
		ie.IndividualService__c = '/Individual';
		ie.OrganizationService__c = '/Organization';
		ie.username__c = 'xxx';
		ie.password__c = 'yyy';
		ie.SubscriptionService__c = '/Subscription';
		ie.UnitService__c = '/Unit';
		
		insert ie;
		
		List<IE_Integration_Field_Set__c> fieldList = new List<IE_Integration_Field_Set__c>{new IE_Integration_Field_Set__c(Name='Account', Field_List__c=('Record_Usage__c'))
																						   ,new IE_Integration_Field_Set__c(Name='Contact', Field_List__c=('Record_Usage__c'))
																						   ,new IE_Integration_Field_Set__c(Name='Address__c', Field_List__c=('Record_Usage__c'))};
		
	  	insert fieldList;
	   
	   
       //test the CreateAccountContactAddress service
       IE_CreateAccountContactAddress.CreateAccountContactAddress res1 
       = IE_CreateAccountContactAddress.doPost(IE_CreateAccountContactAddress.getTestRequest().records);
       
       //test the IE_OrganizationService
       list<IE_IntegrationObjects.IE_Organization> Organizations = new list<IE_IntegrationObjects.IE_Organization>();
       
       IE_IntegrationObjects.IE_Address address = new IE_IntegrationObjects.IE_Address();
       address.AddressLine1 = 'AddressLine1';
       address.AddressLine2 = 'AddressLine2';
       address.AddressLine3 = 'AddressLine3';
       address.AddressLine4 = 'AddressLine4';
       address.City = 'Cityville';
       address.StateCode = 'California';
       address.ZipCode = '90210';
       address.Country= 'United States';
       
       IE_IntegrationObjects.IE_Organization orginization = new IE_IntegrationObjects.IE_Organization();
       orginization.OrganizationName = 'test Account';
       orginization.PhoneNumber = '3334445566';
       orginization.Address = address;
       
       Organizations.add(orginization);
       
       try{
       		IE_IntegrationObjects.IE_OrganizationListResponse res2 = IE_OrganizationService.doPost(Organizations);
       		System.debug('::::::::::: res2 '+res2);
       }
       catch(Exception e){}
       
       
       Contact con = new Contact(LastName='Fred', email='Test.Fred@daikinapplied.com', IE_Daikin_Subscription_Role__c='TEST');
       insert con;
       
       Contact con2 = new Contact(LastName='Fred1', email='Test1.Fred@daikinapplied.com', IE_Daikin_Subscription_Role__c='TEST'
                                 ,MailingStreet= '111\n222\n3333'
                                 ,MailingCity = 'Mpls'
                                 ,MailingState = 'Minnesota'
                                 ,MailingCountry = 'United States'
                                 ,MailingPostalCode = '55441'
                                 );
       insert con2;
       
       con2.MailingPostalCode = '80114';
       update con2;
       
       
       update a;
    
       Asset asset = new Asset(Name = 'test'
                              	, AccountId = a.Id
                              	, SerialNumber='123Test'
                              	, Code_String_Breakdown__c = '[{"code_sequence":"1","code_value":"W","code_description":"Product Category; WATER SOURCE HEAT PUMP"},{"code_sequence":"2","code_value":"CCH","code_description":"Unit Type; CEILING MTD./STANDARD RANGE"},{"code_sequence":"3","code_value":"2","code_description":"Design series; 2ND DESIGN"},{"code_sequence":"4","code_value":"030","code_description":"Unit Size; 30,000 BTUH NOMINAL COOLING"},{"code_sequence":"5","code_value":"E","code_description":"Controls; DDC LESS BOARD"},{"code_sequence":"6","code_value":"K","code_description":"Voltage; 460/60/3"},{"code_sequence":"7","code_value":"Y","code_description":"Cabinet Height; NONE"},{"code_sequence":"8","code_value":"R","code_description":"Return Air; RIGHT HAND RETURN AIR"},{"code_sequence":"9","code_value":"S","code_description":"Discharge Air; STRAIGHT DISCHARGE"},{"code_sequence":"10","code_value":"01","code_description":"Blower Motor; STANDARD"},{"code_sequence":"11","code_value":"YY","code_description":"Disch. Grille/Cab. Type; NONE"},{"code_sequence":"12","code_value":"A","code_description":"Construction Type; STANDARD"},{"code_sequence":"13","code_value":"C","code_description":"Water-Refrig Ht Exch Constr; Copper Inner/Steel Outer Tubes"},{"code_sequence":"14","code_value":"Y","code_description":"Heating Options; NONE"},{"code_sequence":"15","code_value":"YY","code_description":"Dehumidification; NONE"},{"code_sequence":"16","code_value":"Y","code_description":"Piping Hand; NONE"},{"code_sequence":"17","code_value":"YYY","code_description":"Thermostat Control; NONE"},{"code_sequence":"18","code_value":"YYY","code_description":"Night Control; NONE"},{"code_sequence":"19","code_value":"YYY","code_description":"Desuperheater; NONE"},{"code_sequence":"20","code_value":"A","code_description":"Refrigerant; 410A"},{"code_sequence":"21","code_value":"Y","code_description":"Power Connection; NONE"},{"code_sequence":"22","code_value":"YYY","code_description":"Cabinet Electrical; NONE"},{"code_sequence":"23","code_value":"Y","code_description":"Water Flow Control; NONE"},{"code_sequence":"24","code_value":"Y","code_description":"Color; NONE"},{"code_sequence":"25","code_value":"Y","code_description":"Outside Air; NONE"},{"code_sequence":"26","code_value":"C","code_description":"Agency Listing; ETL, CETL, ARI, MEA"},{"code_sequence":"27","code_value":"1","code_description":"Packaging; STANDARD"},{"code_sequence":"28","code_value":"Y","code_description":"Ext. Warranty; NONE"},{"code_sequence":"29","code_value":"2","code_description":"Product Style; Style 2"}]'
                              	, Tag__c = 'x'
				                ////,  Device_ID__c = '111.222.333.444'
				                ,  SIM_Card_ICCID__c = '11111'
				                ,  Format_Number__c = '22222'
				                , Commissioned__c = false
				                , IE_ID__c = null
				                , IE_Sync_Status__c = 'Pending'
                    			, IE_Asset__c = true);
       insert asset;
       
       

       
       Subscription__c sub = new Subscription__c(Type__c = 'CustomRead'
                          , Start_Date__c = System.today()
                          , End_Date__c = System.today() + 1
                          , Buyer_ID__c = a.Id
                          , Asset__c = asset.Id
                          , IE_ID__c = '123'
                          , IE_Updated_Date__c = System.now()
                          , IE_Sync_Status__c = 'Pending'
                          , IE_Subscription__c = true);
        insert sub;
        
        update sub;
       
       list<IE_IntegrationObjects.IE_User> Individuals = new list<IE_IntegrationObjects.IE_User>();
       list<IE_IntegrationObjects.IE_Role> Roles = new list<IE_IntegrationObjects.IE_Role>();
       IE_IntegrationObjects.IE_Role role = new IE_IntegrationObjects.IE_Role();
       role.MasterAdmin = 'true';
       role.Type = 'Customer';
       role.UnitSFDCId = asset.Id;
       Roles.add(role);
       
       IE_IntegrationObjects.IE_User individual = new IE_IntegrationObjects.IE_User();
       individual.FirstName	 = 'test first';
       individual.LastName	 = 'test Last';
       individual.EmailAddress = 'testFirst.testLast@daikinapplied.com';
       individual.CellPhone	 = '3334445566';
       individual.WorkPhone	 = '8887776655';
       individual.Address = address;
       individual.Roles = Roles;
       individual.OrganizationSFDCId = a.Id;
       
       Individuals.add(individual);
       
       
       IE_IntegrationObjects.IE_UserListResponse res3 = IE_IndividualService.doPost(Individuals);
	   res3 = IE_IndividualService.doPut(res3.Individuals);
	   
	   
	   
	   //Test the Unit Service
	   list<IE_IntegrationObjects.IE_Unit> Units = new list<IE_IntegrationObjects.IE_Unit>();
	   IE_IntegrationObjects.IE_Unit unit = new IE_IntegrationObjects.IE_Unit();
	   unit.Commissioned = true;
	   unit.LastModifiedDate = System.now();
	   unit.SFDCId = asset.Id;
	   Units.add(unit);
	   
	   IE_IntegrationObjects.IE_UnitListResponse res4 = IE_UnitService.doPut(Units);

	   //test the catch blocks
	   unit.SFDCId = null;
	   res4 = IE_UnitService.doPut(Units);
	   
	   unit.SFDCId = 'xxx';
	   res4 = IE_UnitService.doPut(Units);
	   
	   Product2 p = new Product2(Product_Group__c = 'IE Gateway', Name = 'Test Gateway');
	   insert p;
	   
	   Product2 p2 = new Product2(Product_Group__c = 'IE EMM', Name = 'Test IE EMM');
	   insert p2;
	   
	   
	   
	   asset.IE_Asset__c = true;
	   asset.Commissioned__c = true;
	   update asset;
	}   
	
	static testMethod void runTest2(){   
	   
	   System.debug(':::::::TEST CHECKPOINT 1::::::');
	   
	   Account a = new Account(Name = 'Test'
                    , IE_Sync_Status__c = 'Pending'
                    , IE_ID__c = '123'
                    , IE_Account__c = true
                    );
       insert a;

       Contact con = new Contact(LastName='Fred', email='Test.Fred@daikinapplied.com', IE_Daikin_Subscription_Role__c='TEST');
       insert con;
       

       Product2 p = new Product2(Product_Group__c = 'IE Gateway', Name = 'Test Gateway');
	   insert p;

		map<String, Id> RecordTypeNameMap = new map<String, Id>();
		for(RecordType rt : [Select Name, SobjectType, Id 
		                       from RecordType 
		                      where Name in ('TRC', 'Address', 'SFDC Integration' )])
		{
			RecordTypeNameMap.put(rt.Name+'-'+rt.SobjectType, rt.Id);
		}

	   IE_Service_Configuration__c ie = new IE_Service_Configuration__c();
		ie.Account_RecordType__c = RecordTypeNameMap.get('TRC-Account');
		ie.Address_RecordType__c = RecordTypeNameMap.get('Address-Address__c');
		ie.Contact_RecordType__c = RecordTypeNameMap.get('SFDC Integration-Contact');
		ie.Unit_Record_Type__c = '';
		ie.DaikinAccountId__c = a.Id;
		ie.endpoint__c = 'http://daikin-iep-service-qa.cloudapp.net/SalesforceIntegration.svc';
		ie.IndividualService__c = '/Individual';
		ie.OrganizationService__c = '/Organization';
		ie.username__c = 'xxx';
		ie.password__c = 'yyy';
		ie.SubscriptionService__c = '/Subscription';
		ie.UnitService__c = '/Unit';
		
		insert ie;

	   Asset asset = new Asset(Name = 'test'
                              	, AccountId = a.Id
                              	, SerialNumber='123Test'
                              	, Code_String_Breakdown__c = '[{"code_sequence":"1","code_value":"W","code_description":"Product Category; WATER SOURCE HEAT PUMP"},{"code_sequence":"2","code_value":"CCH","code_description":"Unit Type; CEILING MTD./STANDARD RANGE"},{"code_sequence":"3","code_value":"2","code_description":"Design series; 2ND DESIGN"},{"code_sequence":"4","code_value":"030","code_description":"Unit Size; 30,000 BTUH NOMINAL COOLING"},{"code_sequence":"5","code_value":"E","code_description":"Controls; DDC LESS BOARD"},{"code_sequence":"6","code_value":"K","code_description":"Voltage; 460/60/3"},{"code_sequence":"7","code_value":"Y","code_description":"Cabinet Height; NONE"},{"code_sequence":"8","code_value":"R","code_description":"Return Air; RIGHT HAND RETURN AIR"},{"code_sequence":"9","code_value":"S","code_description":"Discharge Air; STRAIGHT DISCHARGE"},{"code_sequence":"10","code_value":"01","code_description":"Blower Motor; STANDARD"},{"code_sequence":"11","code_value":"YY","code_description":"Disch. Grille/Cab. Type; NONE"},{"code_sequence":"12","code_value":"A","code_description":"Construction Type; STANDARD"},{"code_sequence":"13","code_value":"C","code_description":"Water-Refrig Ht Exch Constr; Copper Inner/Steel Outer Tubes"},{"code_sequence":"14","code_value":"Y","code_description":"Heating Options; NONE"},{"code_sequence":"15","code_value":"YY","code_description":"Dehumidification; NONE"},{"code_sequence":"16","code_value":"Y","code_description":"Piping Hand; NONE"},{"code_sequence":"17","code_value":"YYY","code_description":"Thermostat Control; NONE"},{"code_sequence":"18","code_value":"YYY","code_description":"Night Control; NONE"},{"code_sequence":"19","code_value":"YYY","code_description":"Desuperheater; NONE"},{"code_sequence":"20","code_value":"A","code_description":"Refrigerant; 410A"},{"code_sequence":"21","code_value":"Y","code_description":"Power Connection; NONE"},{"code_sequence":"22","code_value":"YYY","code_description":"Cabinet Electrical; NONE"},{"code_sequence":"23","code_value":"Y","code_description":"Water Flow Control; NONE"},{"code_sequence":"24","code_value":"Y","code_description":"Color; NONE"},{"code_sequence":"25","code_value":"Y","code_description":"Outside Air; NONE"},{"code_sequence":"26","code_value":"C","code_description":"Agency Listing; ETL, CETL, ARI, MEA"},{"code_sequence":"27","code_value":"1","code_description":"Packaging; STANDARD"},{"code_sequence":"28","code_value":"Y","code_description":"Ext. Warranty; NONE"},{"code_sequence":"29","code_value":"2","code_description":"Product Style; Style 2"}]'
                              	, Tag__c = 'x'
				                ////,  Device_ID__c = '111.222.333.444'
				                ,  SIM_Card_ICCID__c = '11111'
				                ,  Format_Number__c = '22222'
				                , Commissioned__c = false
				                , IE_ID__c = null
				                , IE_Sync_Status__c = 'Pending'
                    			, IE_Asset__c = true);
       insert asset;

       Subscription__c sub = new Subscription__c(Type__c = 'CustomRead'
                          , Start_Date__c = System.today()
                          , End_Date__c = System.today() + 1
                          , Buyer_ID__c = a.Id
                          , Asset__c = asset.Id
                          , IE_ID__c = '123'
                          , IE_Updated_Date__c = System.now()
                          , IE_Sync_Status__c = 'Pending'
                          , IE_Subscription__c = true);
        insert sub;


	   Asset assetG = new Asset(Name = 'test and explode'
                              	, AccountId = a.Id
                              	, SerialNumber='UNKNOWN'
                              	, Tag__c = 'x'
				                //,  Device_ID__c = '111.222.333.444'
				                ,  SIM_Card_ICCID__c = '11111'
				                ,  Format_Number__c = '22222'
				                , Commissioned__c = false
				                , IE_ID__c = null
				                , IE_Sync_Status__c = 'Pending'
                    			, IE_Asset__c = true
                    			, Product2Id = p.Id
                    			,Parent_Asset__c = asset.Id);
       insert assetG;
       update assetG;

       System.debug(':::::::TEST CHECKPOINT 3::::::');
   	   Address__c addr = new Address__c(Address_Line_1__c = 'test'
								  , Address_Line_2__c = 'test'
								  , Address_Line_3__c = 'test'
								  , Address_Line_4__c = 'test'
								  , City__c 			='test'
								  , Country__c			=  'United States'
								  , State_Province__c 	= 'California'
								  , Postal_Code__c 		= '90210'
								  , Address_Name__c 	= 'test');
       insert addr;
	   Asset_Address__c aaa = new Asset_Address__c(Asset__c = asset.Id
                                                 ,Address__c = addr.Id);
       insert aaa;
       
       aaa.Asset__c = assetG.Id;
       update aaa;
	   update addr;
	   
	   Account_Address__c aa = new Account_Address__c(Account__c = a.Id, Address__c = addr.Id, Physical__c = true);
	   insert aa;
	   
	   update aa;
	   
	   Contact_Address__c ca = new Contact_Address__c(Contact__c = con.Id, Address__c = addr.Id, Primary_Mail_To__c = true);
	   
	   insert ca;
	   
	   update ca;
	   /*
	   Account_Address__c aa = [Select Id from Account_Address__c limit 1];
	   update aa;
	   
	   Contact_Address__c ca = [Select Id from Contact_Address__c limit 1];
	   update ca;
	   */
	   Contact c = new Contact(LastName='Fred1', email='Test1.Fred@daikinapplied.com', IE_Daikin_Subscription_Role__c='TEST'
                                 ,MailingStreet= '111\n222\n3333'
                                 ,MailingCity = 'Mpls'
                                 ,MailingState = 'Minnesota'
                                 ,MailingCountry = 'United States'
                                 ,MailingPostalCode = '55441'
                                 );
       insert c;
	   
	   
	   try{
	   	 delete a;
	   } catch(Exception e){}
	   
	   list<Subscription__c> subs = [Select Id from Subscription__c where Asset__c = :asset.Id];
	   try{
	   		delete subs;
	   }
	   catch(Exception e){}//deliberate error raised
	   try{
	   	 
	   	 delete asset;
	   }catch(Exception e){System.debug(':::::::DELETE ASSET ERROR::::::'+e);}
	   
	   try{
	   	 asset.Record_Usage__c = null;
	   	 update asset;
	   	 delete asset;
	   }catch(Exception e){System.debug(':::::::DELETE ASSET ERROR::::::'+e);}
	   
	   
	   try{
	   	 delete addr;
	   }catch(Exception e){}
	   
	   try{
	   	 delete c;
	   }catch(Exception e){}
	   
	   try{
	   	 delete sub;
	   }catch(Exception e){}
       
    }
    
    static testMethod void testIndividualErrorHandling()
    {
    	Account a = new Account(Name = 'Test'
                    , IE_Sync_Status__c = 'Pending'
                    , IE_ID__c = '123'
                    , IE_Account__c = true
                    );
        insert a;
       	
       	
       	map<String, Id> RecordTypeNameMap = new map<String, Id>();
		for(RecordType rt : [Select Name, SobjectType, Id 
		                       from RecordType 
		                      where Name in ('TRC', 'Address', 'SFDC Integration' )])
		{
			RecordTypeNameMap.put(rt.Name+'-'+rt.SobjectType, rt.Id);
		}
		
        IE_Service_Configuration__c ie = new IE_Service_Configuration__c();
		ie.Account_RecordType__c = RecordTypeNameMap.get('TRC-Account');
		ie.Address_RecordType__c = RecordTypeNameMap.get('Address-Address__c');
		ie.Contact_RecordType__c = RecordTypeNameMap.get('SFDC Integration-Contact');
		ie.Unit_Record_Type__c = '';
		ie.DaikinAccountId__c = a.Id;
		ie.endpoint__c = 'http://daikin-iep-service-qa.cloudapp.net/SalesforceIntegration.svc';
		ie.IndividualService__c = '/Individual';
		ie.OrganizationService__c = '/Organization';
		ie.username__c = 'xxx';
		ie.password__c = 'yyy';
		ie.SubscriptionService__c = '/Subscription';
		ie.UnitService__c = '/Unit';
		
		insert ie;
       
    
       Asset asset = new Asset(Name = 'test'
                              	, AccountId = a.Id
                              	, SerialNumber='123Test'
                              	, Code_String_Breakdown__c = '[{"code_sequence":"1","code_value":"W","code_description":"Product Category; WATER SOURCE HEAT PUMP"},{"code_sequence":"2","code_value":"CCH","code_description":"Unit Type; CEILING MTD./STANDARD RANGE"},{"code_sequence":"3","code_value":"2","code_description":"Design series; 2ND DESIGN"},{"code_sequence":"4","code_value":"030","code_description":"Unit Size; 30,000 BTUH NOMINAL COOLING"},{"code_sequence":"5","code_value":"E","code_description":"Controls; DDC LESS BOARD"},{"code_sequence":"6","code_value":"K","code_description":"Voltage; 460/60/3"},{"code_sequence":"7","code_value":"Y","code_description":"Cabinet Height; NONE"},{"code_sequence":"8","code_value":"R","code_description":"Return Air; RIGHT HAND RETURN AIR"},{"code_sequence":"9","code_value":"S","code_description":"Discharge Air; STRAIGHT DISCHARGE"},{"code_sequence":"10","code_value":"01","code_description":"Blower Motor; STANDARD"},{"code_sequence":"11","code_value":"YY","code_description":"Disch. Grille/Cab. Type; NONE"},{"code_sequence":"12","code_value":"A","code_description":"Construction Type; STANDARD"},{"code_sequence":"13","code_value":"C","code_description":"Water-Refrig Ht Exch Constr; Copper Inner/Steel Outer Tubes"},{"code_sequence":"14","code_value":"Y","code_description":"Heating Options; NONE"},{"code_sequence":"15","code_value":"YY","code_description":"Dehumidification; NONE"},{"code_sequence":"16","code_value":"Y","code_description":"Piping Hand; NONE"},{"code_sequence":"17","code_value":"YYY","code_description":"Thermostat Control; NONE"},{"code_sequence":"18","code_value":"YYY","code_description":"Night Control; NONE"},{"code_sequence":"19","code_value":"YYY","code_description":"Desuperheater; NONE"},{"code_sequence":"20","code_value":"A","code_description":"Refrigerant; 410A"},{"code_sequence":"21","code_value":"Y","code_description":"Power Connection; NONE"},{"code_sequence":"22","code_value":"YYY","code_description":"Cabinet Electrical; NONE"},{"code_sequence":"23","code_value":"Y","code_description":"Water Flow Control; NONE"},{"code_sequence":"24","code_value":"Y","code_description":"Color; NONE"},{"code_sequence":"25","code_value":"Y","code_description":"Outside Air; NONE"},{"code_sequence":"26","code_value":"C","code_description":"Agency Listing; ETL, CETL, ARI, MEA"},{"code_sequence":"27","code_value":"1","code_description":"Packaging; STANDARD"},{"code_sequence":"28","code_value":"Y","code_description":"Ext. Warranty; NONE"},{"code_sequence":"29","code_value":"2","code_description":"Product Style; Style 2"}]'
                              	, Tag__c = 'x'
				                //, Device_ID__c = '111.222.333.444'
				                , SIM_Card_ICCID__c = '11111'
				                , Format_Number__c = '22222'
				                , Commissioned__c = false
				                , IE_ID__c = null
				                , IE_Sync_Status__c = 'Pending'
                    			, IE_Asset__c = true);
       insert asset;
       
       Subscription__c sub = new Subscription__c(Type__c = 'CustomRead'
                          , Start_Date__c = System.today()
                          , End_Date__c = System.today() + 1
                          , Buyer_ID__c = a.Id
                          , Asset__c = asset.Id
                          , IE_ID__c = '123'
                          , IE_Updated_Date__c = System.now()
                          , IE_Sync_Status__c = 'Pending'
                          , IE_Subscription__c = true);
        insert sub;
    	
       list<IE_IntegrationObjects.IE_User> Individuals = new list<IE_IntegrationObjects.IE_User>();
       list<IE_IntegrationObjects.IE_Role> Roles = new list<IE_IntegrationObjects.IE_Role>();
       
       IE_IntegrationObjects.IE_Role role = new IE_IntegrationObjects.IE_Role();
       role.MasterAdmin = 'true';
       role.Type = 'Customer';
       role.UnitSFDCId = asset.Id;
       Roles.add(role);
       
       IE_IntegrationObjects.IE_Address address = new IE_IntegrationObjects.IE_Address();
       address.AddressLine1 = 'AddressLine1';
       address.AddressLine2 = 'AddressLine2';
       address.AddressLine3 = 'AddressLine3';
       address.AddressLine4 = 'AddressLine4';
       address.City = 'Cityville';
       address.StateCode = 'California';
       address.ZipCode = '90210';
       address.Country= 'United States';
       
       
       IE_IntegrationObjects.IE_User individual = new IE_IntegrationObjects.IE_User();
       individual.FirstName	 = 'test first';
       individual.LastName	 = 'test Last';
       individual.EmailAddress = 'testFirst.testLast@daikinapplied.com';
       individual.CellPhone	 = '3334445566';
       individual.WorkPhone	 = '8887776655';
       individual.Address = address;
       individual.Roles = Roles;
       individual.OrganizationSFDCId = null;
       
       Individuals.add(individual);

       
       
       IE_IntegrationObjects.IE_User individual2 = new IE_IntegrationObjects.IE_User();
       individual2.FirstName	 = 'test first2';
       individual2.LastName	 = 'test Last2';
       individual2.EmailAddress = 'testFirst2.testLast@daikinapplied.com';
       individual2.CellPhone	 = '3334445566';
       individual2.WorkPhone	 = '8887776655';
       individual2.Address = address;
       individual2.Roles = Roles;
       individual2.OrganizationSFDCId = a.Id;
       
       Individuals.add(individual2);
       
       IE_IntegrationObjects.IE_UserListResponse res3 = IE_IndividualService.doPost(Individuals);
       
       System.Debug('::::::res3::::'+ res3);
	   //res3 = IE_IndividualService.doPut(res3.Individuals);
    }
    
    static testMethod void testAddressControllers()
    {
    	
		//test the Individuals service
        Account a = new Account(Name = 'Test'
                    , IE_Sync_Status__c = 'Pending'
                    , IE_ID__c = '123'
                    , IE_Account__c = true
                    );
        insert a;
		map<String, Id> RecordTypeNameMap = new map<String, Id>();
		for(RecordType rt : [Select Name, SobjectType, Id 
		                       from RecordType 
		                      where Name in ('TRC', 'Address', 'SFDC Integration' )])
		{
			RecordTypeNameMap.put(rt.Name+'-'+rt.SobjectType, rt.Id);
		}
		
		IE_Service_Configuration__c ie = new IE_Service_Configuration__c();
		ie.Account_RecordType__c = RecordTypeNameMap.get('TRC-Account');
		ie.Address_RecordType__c = RecordTypeNameMap.get('Address-Address__c');
		ie.Contact_RecordType__c = RecordTypeNameMap.get('SFDC Integration-Contact');
		ie.Unit_Record_Type__c = '';
		ie.DaikinAccountId__c = a.Id;
		ie.endpoint__c = 'http://daikin-iep-service-qa.cloudapp.net/SalesforceIntegration.svc';
		ie.IndividualService__c = '/Individual';
		ie.OrganizationService__c = '/Organization';
		ie.username__c = 'xxx';
		ie.password__c = 'yyy';
		ie.SubscriptionService__c = '/Subscription';
		ie.UnitService__c = '/Unit';
		
		insert ie;
		
		List<IE_Integration_Field_Set__c> fieldList = new List<IE_Integration_Field_Set__c>{new IE_Integration_Field_Set__c(Name='Account', Field_List__c=('Record_Usage__c'))
																						   ,new IE_Integration_Field_Set__c(Name='Contact', Field_List__c=('Record_Usage__c'))
																						   ,new IE_Integration_Field_Set__c(Name='Address__c', Field_List__c=('Record_Usage__c'))};
		
	  	insert fieldList;
	   
	   
      
       
       
	   Address__c addr = new Address__c(Address_Line_1__c = 'test'
									  , Address_Line_2__c = 'test'
									  , Address_Line_3__c = 'test'
									  , Address_Line_4__c = 'test'
									  , City__c 			='test'
									  , Country__c			=  'United States'
									  , State_Province__c 	= 'California'
									  , Postal_Code__c 		= '90210'
									  , Address_Name__c 	= 'test');
       insert addr;
       
       Contact con = new Contact(LastName='Fred', email='Test.Fred@daikinapplied.com', IE_Daikin_Subscription_Role__c='TEST', AccountId = a.Id);
       insert con;
       
       Contact con2 = new Contact(LastName='Fred2', email='Test.Fred2@daikinapplied.com', IE_Daikin_Subscription_Role__c='TEST', AccountId = a.Id);
       insert con2;
       
       
       Asset asset = new Asset(Name = 'test'
                              	, AccountId = a.Id
                              	, SerialNumber='123Test'
                              	, Code_String_Breakdown__c = '[{"code_sequence":"1","code_value":"W","code_description":"Product Category; WATER SOURCE HEAT PUMP"},{"code_sequence":"2","code_value":"CCH","code_description":"Unit Type; CEILING MTD./STANDARD RANGE"},{"code_sequence":"3","code_value":"2","code_description":"Design series; 2ND DESIGN"},{"code_sequence":"4","code_value":"030","code_description":"Unit Size; 30,000 BTUH NOMINAL COOLING"},{"code_sequence":"5","code_value":"E","code_description":"Controls; DDC LESS BOARD"},{"code_sequence":"6","code_value":"K","code_description":"Voltage; 460/60/3"},{"code_sequence":"7","code_value":"Y","code_description":"Cabinet Height; NONE"},{"code_sequence":"8","code_value":"R","code_description":"Return Air; RIGHT HAND RETURN AIR"},{"code_sequence":"9","code_value":"S","code_description":"Discharge Air; STRAIGHT DISCHARGE"},{"code_sequence":"10","code_value":"01","code_description":"Blower Motor; STANDARD"},{"code_sequence":"11","code_value":"YY","code_description":"Disch. Grille/Cab. Type; NONE"},{"code_sequence":"12","code_value":"A","code_description":"Construction Type; STANDARD"},{"code_sequence":"13","code_value":"C","code_description":"Water-Refrig Ht Exch Constr; Copper Inner/Steel Outer Tubes"},{"code_sequence":"14","code_value":"Y","code_description":"Heating Options; NONE"},{"code_sequence":"15","code_value":"YY","code_description":"Dehumidification; NONE"},{"code_sequence":"16","code_value":"Y","code_description":"Piping Hand; NONE"},{"code_sequence":"17","code_value":"YYY","code_description":"Thermostat Control; NONE"},{"code_sequence":"18","code_value":"YYY","code_description":"Night Control; NONE"},{"code_sequence":"19","code_value":"YYY","code_description":"Desuperheater; NONE"},{"code_sequence":"20","code_value":"A","code_description":"Refrigerant; 410A"},{"code_sequence":"21","code_value":"Y","code_description":"Power Connection; NONE"},{"code_sequence":"22","code_value":"YYY","code_description":"Cabinet Electrical; NONE"},{"code_sequence":"23","code_value":"Y","code_description":"Water Flow Control; NONE"},{"code_sequence":"24","code_value":"Y","code_description":"Color; NONE"},{"code_sequence":"25","code_value":"Y","code_description":"Outside Air; NONE"},{"code_sequence":"26","code_value":"C","code_description":"Agency Listing; ETL, CETL, ARI, MEA"},{"code_sequence":"27","code_value":"1","code_description":"Packaging; STANDARD"},{"code_sequence":"28","code_value":"Y","code_description":"Ext. Warranty; NONE"},{"code_sequence":"29","code_value":"2","code_description":"Product Style; Style 2"}]'
                              	, Tag__c = 'x'
				                ////,  Device_ID__c = '111.222.333.444'
				                ,  SIM_Card_ICCID__c = '11111'
				                ,  Format_Number__c = '22222'
				                , Commissioned__c = false
				                , IE_ID__c = null
				                , IE_Sync_Status__c = 'Pending'
                    			, IE_Asset__c = true
                    			, Asset_Address__c = addr.Id);
       insert asset;
       
       
	   
	   Product2 p = new Product2(Product_Group__c = 'IE Gateway', Name = 'Test Gateway');
	   insert p;
	   
	   
	   
	   asset.IE_Asset__c = true;
	   asset.Commissioned__c = true;
	   update asset;
	   
	   System.debug(':::::::TEST CHECKPOINT 1::::::');
	   
	   Asset assetG = new Asset(Name = 'test and explode'
                              	, AccountId = a.Id
                              	, SerialNumber='UNKNOWN'
                              	, Tag__c = 'x'
				                //,  Device_ID__c = '111.222.333.444'
				                , SIM_Card_ICCID__c = '11111'
				                , Format_Number__c = '22222'
				                , Commissioned__c = false
				                , IE_ID__c = null
				                , IE_Sync_Status__c = 'Pending'
                    			, IE_Asset__c = true
                    			, Product2Id = p.Id
                    			, Parent_Asset__c = asset.Id
                    			, Asset_Address__c = addr.Id);
       insert assetG;
       Test.startTest();
       
	   TriggerUtility.limitAccountExecution = true;
	   Account_Address__c aa = new Account_Address__c(Account__c = a.Id, Address__c = addr.Id, Mail_To__c = true);
	   insert aa;
	   
	   Contact_Address__c ca = new Contact_Address__c(Contact__c = con.Id, Address__c = addr.Id, Mail_To__c = true);
	   insert ca;
	   
	   Contact_Address__c ca2 = new Contact_Address__c(Contact__c = con2.Id, Address__c = addr.Id, Primary_Mail_To__c = true);
	   insert ca2;
	   
	   ApexPages.StandardController assetCtl = new ApexPages.StandardController(asset);
	   AssetAddressDetail assCtl = new AssetAddressDetail(assetCtl);
	   assCtl.selectAddress();
	   assCtl.save();
	   
	   asset.Asset_Address__c = null;
	   update asset;
	   
	   assetCtl = new ApexPages.StandardController(asset);
	   assCtl = new AssetAddressDetail(assetCtl);
	   assCtl.selectAddress();
	   
	   update addr;
	   
	   try{
	   		delete addr;
	   }
	   catch(Exception e){}
	   Test.stopTest();
       
    
    }
    
    static testMethod void testAddressControllers2()
    {
    	
		//test the Individuals service
        Account a = new Account(Name = 'Test'
                    , IE_Sync_Status__c = 'Pending'
                    , IE_ID__c = '123'
                    , IE_Account__c = true
                    );
        insert a;
		map<String, Id> RecordTypeNameMap = new map<String, Id>();
		for(RecordType rt : [Select Name, SobjectType, Id 
		                       from RecordType 
		                      where Name in ('TRC', 'Address', 'SFDC Integration' )])
		{
			RecordTypeNameMap.put(rt.Name+'-'+rt.SobjectType, rt.Id);
		}
		
		IE_Service_Configuration__c ie = new IE_Service_Configuration__c();
		ie.Account_RecordType__c = RecordTypeNameMap.get('TRC-Account');
		ie.Address_RecordType__c = RecordTypeNameMap.get('Address-Address__c');
		ie.Contact_RecordType__c = RecordTypeNameMap.get('SFDC Integration-Contact');
		ie.Unit_Record_Type__c = '';
		ie.DaikinAccountId__c = a.Id;
		ie.endpoint__c = 'http://daikin-iep-service-qa.cloudapp.net/SalesforceIntegration.svc';
		ie.IndividualService__c = '/Individual';
		ie.OrganizationService__c = '/Organization';
		ie.username__c = 'xxx';
		ie.password__c = 'yyy';
		ie.SubscriptionService__c = '/Subscription';
		ie.UnitService__c = '/Unit';
		
		insert ie;
		
		List<IE_Integration_Field_Set__c> fieldList = new List<IE_Integration_Field_Set__c>{new IE_Integration_Field_Set__c(Name='Account', Field_List__c=('Record_Usage__c'))
																						   ,new IE_Integration_Field_Set__c(Name='Contact', Field_List__c=('Record_Usage__c'))
																						   ,new IE_Integration_Field_Set__c(Name='Address__c', Field_List__c=('Record_Usage__c'))};
		
	  	insert fieldList;
	   
	   
      
       
       
	   Address__c addr = new Address__c(Address_Line_1__c = 'test'
									  , Address_Line_2__c = 'test'
									  , Address_Line_3__c = 'test'
									  , Address_Line_4__c = 'test'
									  , City__c 			='test'
									  , Country__c			=  'United States'
									  , State_Province__c 	= 'California'
									  , Postal_Code__c 		= '90210'
									  , Address_Name__c 	= 'test');
       insert addr;
       
       Contact con = new Contact(LastName='Fred', email='Test.Fred@daikinapplied.com', IE_Daikin_Subscription_Role__c='TEST', AccountId = a.Id);
       insert con;
       
       Contact con2 = new Contact(LastName='Fred2', email='Test.Fred2@daikinapplied.com', IE_Daikin_Subscription_Role__c='TEST', AccountId = a.Id);
       insert con2;
       
       
       Asset asset = new Asset(Name = 'test'
                              	, AccountId = a.Id
                              	, SerialNumber='123Test'
                              	, Code_String_Breakdown__c = '[{"code_sequence":"1","code_value":"W","code_description":"Product Category; WATER SOURCE HEAT PUMP"},{"code_sequence":"2","code_value":"CCH","code_description":"Unit Type; CEILING MTD./STANDARD RANGE"},{"code_sequence":"3","code_value":"2","code_description":"Design series; 2ND DESIGN"},{"code_sequence":"4","code_value":"030","code_description":"Unit Size; 30,000 BTUH NOMINAL COOLING"},{"code_sequence":"5","code_value":"E","code_description":"Controls; DDC LESS BOARD"},{"code_sequence":"6","code_value":"K","code_description":"Voltage; 460/60/3"},{"code_sequence":"7","code_value":"Y","code_description":"Cabinet Height; NONE"},{"code_sequence":"8","code_value":"R","code_description":"Return Air; RIGHT HAND RETURN AIR"},{"code_sequence":"9","code_value":"S","code_description":"Discharge Air; STRAIGHT DISCHARGE"},{"code_sequence":"10","code_value":"01","code_description":"Blower Motor; STANDARD"},{"code_sequence":"11","code_value":"YY","code_description":"Disch. Grille/Cab. Type; NONE"},{"code_sequence":"12","code_value":"A","code_description":"Construction Type; STANDARD"},{"code_sequence":"13","code_value":"C","code_description":"Water-Refrig Ht Exch Constr; Copper Inner/Steel Outer Tubes"},{"code_sequence":"14","code_value":"Y","code_description":"Heating Options; NONE"},{"code_sequence":"15","code_value":"YY","code_description":"Dehumidification; NONE"},{"code_sequence":"16","code_value":"Y","code_description":"Piping Hand; NONE"},{"code_sequence":"17","code_value":"YYY","code_description":"Thermostat Control; NONE"},{"code_sequence":"18","code_value":"YYY","code_description":"Night Control; NONE"},{"code_sequence":"19","code_value":"YYY","code_description":"Desuperheater; NONE"},{"code_sequence":"20","code_value":"A","code_description":"Refrigerant; 410A"},{"code_sequence":"21","code_value":"Y","code_description":"Power Connection; NONE"},{"code_sequence":"22","code_value":"YYY","code_description":"Cabinet Electrical; NONE"},{"code_sequence":"23","code_value":"Y","code_description":"Water Flow Control; NONE"},{"code_sequence":"24","code_value":"Y","code_description":"Color; NONE"},{"code_sequence":"25","code_value":"Y","code_description":"Outside Air; NONE"},{"code_sequence":"26","code_value":"C","code_description":"Agency Listing; ETL, CETL, ARI, MEA"},{"code_sequence":"27","code_value":"1","code_description":"Packaging; STANDARD"},{"code_sequence":"28","code_value":"Y","code_description":"Ext. Warranty; NONE"},{"code_sequence":"29","code_value":"2","code_description":"Product Style; Style 2"}]'
                              	, Tag__c = 'x'
				                ////,  Device_ID__c = '111.222.333.444'
				                ,  SIM_Card_ICCID__c = '11111'
				                ,  Format_Number__c = '22222'
				                , Commissioned__c = false
				                , IE_ID__c = null
				                , IE_Sync_Status__c = 'Pending'
                    			, IE_Asset__c = true
                    			, Asset_Address__c = addr.Id);
       insert asset;
       
	   TriggerUtility.limitAccountExecution = true;
	   Account_Address__c aa = new Account_Address__c(Account__c = a.Id, Address__c = addr.Id, Mail_To__c = true);
	   insert aa;
	   
	   Contact_Address__c ca = new Contact_Address__c(Contact__c = con.Id, Address__c = addr.Id, Mail_To__c = true);
	   insert ca;
	   
	   Contact_Address__c ca2 = new Contact_Address__c(Contact__c = con2.Id, Address__c = addr.Id, Primary_Mail_To__c = true);
	   insert ca2;
	   Test.startTest();
	   ApexPages.StandardController assetCtl = new ApexPages.StandardController(aa);
	   AccountAddressDetail accCtl = new AccountAddressDetail(assetCtl);
	   accCtl.selectAddress();
	   accCtl.returnUrl = '/'+a.Id;
	   accCtl.save();
	   
	   assetCtl = new ApexPages.StandardController(ca);
	   ContactAddressDetail conCtl = new ContactAddressDetail(assetCtl);
	   conCtl.selectAddress();
	   conCtl.returnUrl = '/'+con.Id;
	   conCtl.save();
	   
       update addr;
	   Test.stopTest();
       
    
    }

}