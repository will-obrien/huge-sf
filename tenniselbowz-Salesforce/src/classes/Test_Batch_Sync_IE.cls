/**
 * 
 */
@isTest
private class Test_Batch_Sync_IE { 

    static testMethod void testSyncUnits() {
        // Create Asset
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
        
         Account a2 = new Account(Name = 'Test2'
                              , IE_Sync_Status__c = 'Pending'
                              , IE_Account__c = true
                              );
        insert a2;
        
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
                              , IE_Asset__c = true
                              );
        insert asset;
        
        Asset asset1 = new Asset(Name = 'test'
                              , AccountId = a.Id
                              , SerialNumber='123Test'
                              , Code_String_Breakdown__c = '[{"code_sequence":"1","code_value":"W","code_description":"Product Category; WATER SOURCE HEAT PUMP"},{"code_sequence":"2","code_value":"CCH","code_description":"Unit Type; CEILING MTD./STANDARD RANGE"},{"code_sequence":"3","code_value":"2","code_description":"Design series; 2ND DESIGN"},{"code_sequence":"4","code_value":"030","code_description":"Unit Size; 30,000 BTUH NOMINAL COOLING"},{"code_sequence":"5","code_value":"E","code_description":"Controls; DDC LESS BOARD"},{"code_sequence":"6","code_value":"K","code_description":"Voltage; 460/60/3"},{"code_sequence":"7","code_value":"Y","code_description":"Cabinet Height; NONE"},{"code_sequence":"8","code_value":"R","code_description":"Return Air; RIGHT HAND RETURN AIR"},{"code_sequence":"9","code_value":"S","code_description":"Discharge Air; STRAIGHT DISCHARGE"},{"code_sequence":"10","code_value":"01","code_description":"Blower Motor; STANDARD"},{"code_sequence":"11","code_value":"YY","code_description":"Disch. Grille/Cab. Type; NONE"},{"code_sequence":"12","code_value":"A","code_description":"Construction Type; STANDARD"},{"code_sequence":"13","code_value":"C","code_description":"Water-Refrig Ht Exch Constr; Copper Inner/Steel Outer Tubes"},{"code_sequence":"14","code_value":"Y","code_description":"Heating Options; NONE"},{"code_sequence":"15","code_value":"YY","code_description":"Dehumidification; NONE"},{"code_sequence":"16","code_value":"Y","code_description":"Piping Hand; NONE"},{"code_sequence":"17","code_value":"YYY","code_description":"Thermostat Control; NONE"},{"code_sequence":"18","code_value":"YYY","code_description":"Night Control; NONE"},{"code_sequence":"19","code_value":"YYY","code_description":"Desuperheater; NONE"},{"code_sequence":"20","code_value":"A","code_description":"Refrigerant; 410A"},{"code_sequence":"21","code_value":"Y","code_description":"Power Connection; NONE"},{"code_sequence":"22","code_value":"YYY","code_description":"Cabinet Electrical; NONE"},{"code_sequence":"23","code_value":"Y","code_description":"Water Flow Control; NONE"},{"code_sequence":"24","code_value":"Y","code_description":"Color; NONE"},{"code_sequence":"25","code_value":"Y","code_description":"Outside Air; NONE"},{"code_sequence":"26","code_value":"C","code_description":"Agency Listing; ETL, CETL, ARI, MEA"},{"code_sequence":"27","code_value":"1","code_description":"Packaging; STANDARD"},{"code_sequence":"28","code_value":"Y","code_description":"Ext. Warranty; NONE"},{"code_sequence":"29","code_value":"2","code_description":"Product Style; Style 2"}]'
                              , Tag__c = 'x'
                              //, Device_ID__c = '111.222.333.444'
                              , SIM_Card_ICCID__c = '11111'
                              , Format_Number__c = '22222'
                              , Commissioned__c = false
                              , IE_ID__c = '123'
                              , IE_Sync_Status__c = 'Pending'
                              , IE_Asset__c = true);
        insert asset1;
        
        //Create Address
        Address__c addr = new Address__c(Address_Line_1__c = 'x1'
                                        ,Address_Line_2__c = 'x2'
                                        ,Address_Line_3__c = 'x3'
                                        ,Address_Line_4__c = 'x4'
                                        ,City__c = 'New York'
                                        ,State_Province__c = 'New York'
                                        ,Country__c = 'United States'
                                        //,State_Province__c = 'NY'
                                        ,Postal_Code__c = '11111'
                                        ,IE_ID__c  = 'x'
                                        ,IE_Address__c = true
                                        ,IE_Updated_Date__c = System.Now());
        
        insert addr;
        
        //Create Asset Address
        Asset_Address__c aa = new Asset_Address__c(Asset__c = asset.Id
                                                  ,Address__c = addr.Id
                                                  ,Building_Identifier__c = '123');
        insert aa;
        
        Asset_Address__c aa2 = new Asset_Address__c(Asset__c = asset1.Id
                                                  ,Address__c = addr.Id
                                                  ,Building_Identifier__c = '123');
        insert aa2;
        
        Subscription__c sub = new Subscription__c(Type__c = 'CustomRead'
                                                , Start_Date__c = System.today()
                                                , End_Date__c = System.today() + 1
                                                , Buyer_ID__c = a.Id
                                                , Asset__c = asset1.Id
                                                , IE_ID__c = '123'
                                                , IE_Updated_Date__c = System.now()
                                                , IE_Sync_Status__c = 'Pending'
                                                , IE_Subscription__c = true);
        insert sub;
        
        Subscription__c sub2 = new Subscription__c(Type__c = 'TechReadWrite'
                                                , Start_Date__c = System.today()
                                                , End_Date__c = System.today() + 1
                                                , Buyer_ID__c = a.Id
                                                , Asset__c = asset1.Id
                                                , IE_ID__c = null
                                                , IE_Updated_Date__c = System.now()
                                                , IE_Sync_Status__c = 'Pending'
                                                , IE_Subscription__c = true);
        insert sub2;
        
        Contact c = new Contact(FirstName = 'x'
                              , LastName = 'y'
                              , Middle_Name__c = 'z'
                              , Email = 'tester@daikintest.com'
                              , Phone = '3334445555'
                              , MobilePhone = '4445556666'
                              , IE_Username__c = 'tester@daikintest.com'
                              , IE_Accessed__c = true
                              , IE_Inactive__c = false
                              , IE_Updated_Date__c = null
                              , IE_ID__c = null
                              , IE_Contact__c = true
                              , IE_Sync_Status__c = 'Pending');
        insert c;
        
        Contact_Address__c ca1 = new Contact_Address__c(Contact__c = c.Id
                                                    ,Address__c = addr.Id
                                                    ,Primary_Mail_To__c = true);
        insert ca1;
        
        Contact_Subscription__c cs1 = new Contact_Subscription__c(Contact__c = c.Id
                                                                 ,Subscription__c = sub.Id
                                                                 ,Asset__c = asset1.Id 
                                                                 ,Role__c = 'X;Y;Z');
        insert cs1;
        
        Contact c2 = new Contact(FirstName = 'x'
                              , LastName = 'y'
                              , Middle_Name__c = 'z'
                              , Email = 'tester@daikintest.com'
                              , Phone = '3334445555'
                              , MobilePhone = '4445556666'
                              , IE_Username__c = 'tester@daikintest.com'
                              , IE_Accessed__c = true
                              , IE_Inactive__c = false
                              , IE_Updated_Date__c = System.now()
                              , IE_ID__c = '123456'
                              , IE_Contact__c = true
                              , IE_Sync_Status__c = 'Pending');
        insert c2;
        
        Contact_Subscription__c cs2 = new Contact_Subscription__c(Contact__c = c2.Id
                                                                 ,Subscription__c = sub.Id
                                                                 ,Asset__c = asset1.Id
                                                                 ,Role__c = 'X;Y;Z');
        insert cs2;
        
        Contact_Address__c ca2 = new Contact_Address__c(Contact__c = c2.Id
                                                        ,Address__c = addr.Id
                                                        ,Primary_Mail_To__c = true);
        insert ca2;
        
        Account_Address__c aa1 = new Account_Address__c(Account__c = a.Id
                                                       ,Address__c = addr.Id
                                                       ,Primary_Mail_To__c = true);
        insert aa1;
        
        Test.startTest();
        Database.ExecuteBatch(new Batch_Sync_IE_Unit('Pending'));
        Test.stopTest();
        
    }
    
    static testmethod void testBatch_Sync_IE_Unit_Schedular(){    
      Test.startTest(); 
      //defien the CRON Expression
      String CRON_EXP;
      CRON_EXP = '0 0 2 * * ?';
      Batch_Sync_IE_Unit_Schedular s = new Batch_Sync_IE_Unit_Schedular();
      SchedulableContext sc;
      s.execute(sc);
      System.schedule('test-Batch_Sync_IE_Unit_Schedular', CRON_EXP, s);
      Test.stopTest();
   }
}