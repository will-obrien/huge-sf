@IsTest
public class AcknowledgeBatchUploadDonationsTest {
	@IsTest
    public static void myUnitTest() {

		Campaign testCampaign = new Campaign();
		testCampaign.Name = 'test camp';
        testCampaign.External_ID__c = testCampaign.Name;
		testCampaign.Type = 'Promotion';
		testCampaign.Status = 'Planned';
		testCampaign.Autoresponder_External_Key__c  = 'triggered-send-test';
		insert testCampaign;
    	
    	rC_Connect__Batch_Upload__c upload = new rC_Connect__Batch_Upload__c(
			rC_Connect__Giving_Paid__c = true,    		
			rC_Connect__Contact_1_Email__c = 'mmaslow00@gmail.com',
    		rC_Connect__Contact_1_First_Name__c = 'Mark',
    		rC_Connect__Contact_1_Last_Name__c = 'Maslow',
    		rC_Connect__Giving_Giving_Amount__c = 24.00,
    		rC_Connect__Giving_Close_Date__c = System.Today(),
    		Form_Campaign__c = testCampaign.Id
    	);
    	insert upload;
    	
    	
    	rC_Connect__Batch_Upload__c savedUpload =
    		[select 
    			rC_Connect__Giving_Paid__c, 
    			rC_Connect__Contact_1_Email__c,
    			rC_Connect__Contact_1_First_Name__c,
    			rC_Connect__Contact_1_Last_Name__c,
    			rC_Connect__Giving_Giving_Amount__c,
    			rC_Connect__Giving_Close_Date__c,
    			General_Accounting_Unit__c,
				rC_Connect__Batch_Upload_Contact_1_Matched__c,
				Confirmation_Number__c,
    			Autoresponder_External_Key__c
    		 from rC_Connect__Batch_Upload__c
    		 limit 1
    		];
    	
    	List<rC_Connect__Batch_Upload__c> testList = new List<rC_Connect__Batch_Upload__c>();
    	testList.add(savedUpload);
    	new AcknowledgeBatchUploadDonations().acknowledge(testList, null);
    	Map<Id, rC_Connect__Batch_Upload__c> oldMap = new Map<Id, rC_Connect__Batch_Upload__c>();
    	rC_Connect__Batch_Upload__c oldVersion = savedUpload.clone(true, true);
    	oldVersion.rC_Connect__Giving_Paid__c = false;
    	oldMap.put(oldVersion.Id, oldVersion);
    	new AcknowledgeBatchUploadDonations().acknowledge(testList, oldMap);
    }
}