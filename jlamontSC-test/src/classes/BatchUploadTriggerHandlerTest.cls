//*********************************************************************//
// (c) 2015 Sierra Club
//
//	Test  Class for Batch Upload Trigger Handler trigger.
//	2015/05/12		Vernon Baas		Created ( oh the shame )
//  Updated: 
//**********************************************************************//   
@isTest
private class BatchUploadTriggerHandlerTest {

    static testMethod void myUnitTestOne() {

	    rC_Connect__Batch_Upload__c testBU = new rC_Connect__Batch_Upload__c(); 

		testBU.Name = 'BatchUploadTriggerHandlerTest001';

		
		testBU.rC_Connect__Batch_Upload_Status__c = 'New';
		
		testBU.rC_Connect__Address_Street_Line_1__c = '12 Parkway Ct';
		testBU.rC_Connect__Address_City__c = 'Orinda';
		testBU.rC_Connect__Address_State__c = 'CA';
		testBU.rC_Connect__Address_Postal_Code__c = '94563';
		
		testBU.rC_Connect__Contact_1_First_Name__c = 'TestFN';
		testBU.rC_Connect__Contact_1_Last_Name__c = 'TestLN';
		testBU.rC_Connect__Contact_1_Email__c = 'FN.LN@test.com';
		testBU.rC_Connect__Contact_1_Email_Type__c = 'Work';
		
    	insert testBU;
    	
    	list<rC_Connect__Batch_Upload__c> buList = 
    		[SELECT rC_Connect__Batch_Upload_Status__c,
    				rC_Connect__Address_Country__c
    			FROM rC_Connect__Batch_Upload__c 
    			WHERE id=:testBU.id];
    	
    	// Confirm the Status is "To ZDM"
    	system.assertEquals(buList[0].rC_Connect__Batch_Upload_Status__c, 'To ZDM');
    	
    	// WARNING: Not right...
    	system.assertEquals(buList[0].rC_Connect__Address_Country__c, null);

    }
    static testMethod void myUnitTestTwo() {

	    rC_Connect__Batch_Upload__c testBU = new rC_Connect__Batch_Upload__c(); 

		testBU.Name = 'BatchUploadTriggerHandlerTest002';

		
		testBU.rC_Connect__Batch_Upload_Status__c = 'New';
		
		testBU.rC_Connect__Address_Street_Line_1__c = '12 Parkway Ct';
		testBU.rC_Connect__Address_City__c = 'Orinda';
		testBU.rC_Connect__Address_State__c = 'CA';
		testBU.rC_Connect__Address_Postal_Code__c = '94563';
		testBU.rC_Connect__Address_Country__c = 'USA';
		
		testBU.rC_Connect__Contact_1_First_Name__c = 'TestFN';
		testBU.rC_Connect__Contact_1_Last_Name__c = 'TestLN';
		testBU.rC_Connect__Contact_1_Email__c = 'FN.LN@test.com';
		testBU.rC_Connect__Contact_1_Email_Type__c = 'Work';
		
    	insert testBU;
    	
    	list<rC_Connect__Batch_Upload__c> buList = 
    		[SELECT rC_Connect__Batch_Upload_Status__c,
    				rC_Connect__Address_Country__c
    			FROM rC_Connect__Batch_Upload__c 
    			WHERE id=:testBU.id];
    	
    	// Confirm the Status is "To ZDM"
    	system.assertEquals(buList[0].rC_Connect__Batch_Upload_Status__c, 'To ZDM');

    	// WARNING: Not right...
    	system.assertEquals(buList[0].rC_Connect__Address_Country__c, null);

    }
    static testMethod void myUnitTestThree() {
        Campaign camp = new Campaign (Name='Test Campaign');
        insert camp;
        
	    rC_Connect__Batch_Upload__c testBU = new rC_Connect__Batch_Upload__c(); 
		testBU.Name = 'BatchUploadTriggerHandlerTest003';
        testBU.Form_Campaign__c = camp.Id;
        insert testBU;
        
        rC_Connect__Batch_Upload__c insertedBU = [select rC_Connect__Batch_Upload_Campaign_Matched__c from rC_Connect__Batch_Upload__c where Id=:testBU.Id];
        System.assertEquals(camp.Id, insertedBU.rC_Connect__Batch_Upload_Campaign_Matched__c);
    }
    static testMethod void myUnitTestFour() {
    	List<rC_Connect__Batch_Upload__c> buList = new List<rC_Connect__Batch_Upload__c>();
    	
	    rC_Connect__Batch_Upload__c testBU1 = new rC_Connect__Batch_Upload__c(); 

		testBU1.Name = 'BatchUploadTriggerHandlerTest004';
		testBU1.rC_Connect__Batch_Upload_Status__c = 'New';
		testBU1.rC_Connect__Address_Postal_Code__c = '94563';
		buList.add(testBU1);

	    rC_Connect__Batch_Upload__c testBU2 = new rC_Connect__Batch_Upload__c(); 

		testBU2.Name = 'BatchUploadTriggerHandlerTest005';
		testBU2.rC_Connect__Batch_Upload_Status__c = 'New';
		testBU2.rC_Connect__Address_City__c = 'Orinda';
		testBU2.rC_Connect__Address_State__c = 'CA';
		buList.add(testBU2);
		
		insert buList;
		
        rC_Connect__Batch_Upload__c insertedBU = [
        	select 
        		rC_Connect__Address_Street_Line_1__c,
        		rC_Connect__Address_City__c,
				rC_Connect__Address_State__c,
				rC_Connect__Address_Postal_Code__c
			from rC_Connect__Batch_Upload__c where Id=:testBU1.Id
		];
		System.assertEquals('Unknown', insertedBU.rC_Connect__Address_Street_Line_1__c);
		System.assertEquals('Unknown', insertedBU.rC_Connect__Address_City__c);
		System.assertEquals('UN', insertedBU.rC_Connect__Address_State__c);
		System.assertEquals('94563', insertedBU.rC_Connect__Address_Postal_Code__c);
		
        insertedBU = [
        	select 
        		rC_Connect__Address_Street_Line_1__c,
        		rC_Connect__Address_City__c,
				rC_Connect__Address_State__c,
				rC_Connect__Address_Postal_Code__c
			from rC_Connect__Batch_Upload__c where Id=:testBU2.Id
		];
		System.assertEquals('Unknown', insertedBU.rC_Connect__Address_Street_Line_1__c);
		System.assertEquals('Orinda', insertedBU.rC_Connect__Address_City__c);
		System.assertEquals('CA', insertedBU.rC_Connect__Address_State__c);
		System.assertEquals('Unknown', insertedBU.rC_Connect__Address_Postal_Code__c);
		
    }        
}