@isTest
private class BatchUploadPostFlaggedProcessingTest {
    static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static rC_Connect__Batch_Upload__c bu1, bu2, bu3, bu4, bu5;
	static rC_Bios__Account_Address__c addr1, addr2;
	
    static testMethod void test1() {
        setup(1);
        Test.startTest();
        BatchUploadPostFlaggedProcessing.process(new List<rC_Connect__Batch_Upload__c> { bu1 });
        Test.stopTest();
        rC_Bios__Account_Address__c testAddr = [
        select 
        	rC_Bios__Original_Street_Line_1__c 
        	from rC_Bios__Account_Address__c
        	where Id = :addr1.Id
        ];
        System.assertEquals('After', testAddr.rC_Bios__Original_Street_Line_1__c);
    }
    static testMethod void test2() {
        setup(2);
        BatchUploadPostFlaggedProcessing.flaggedBatchesProcessed = false;
        BatchUploadPostFlaggedProcessing.process(new List<rC_Connect__Batch_Upload__c> { bu2 });
    }
    static testMethod void test3() {
        setup(3);
        BatchUploadPostFlaggedProcessing.flaggedBatchesProcessed = false;
        BatchUploadPostFlaggedProcessing.process(new List<rC_Connect__Batch_Upload__c> { bu3 });
        rC_Connect__Batch_Upload__c bu = [
        	select 
        		rC_Connect__Batch_Upload_Flagged_Reason__c 
        	from rC_Connect__Batch_Upload__c
        	where Id = :bu3.Id
        ];
        System.assertEquals('Account has multiple addresses. Please find and update preferred address.', bu.rC_Connect__Batch_Upload_Flagged_Reason__c);

        BatchUploadPostFlaggedProcessing.flaggedBatchesProcessed = true;
        BatchUploadPostFlaggedProcessing.process(new List<rC_Connect__Batch_Upload__c> { bu3 });
        
    }
    
    static testMethod void test4() {
        setup(4);
        BatchUploadPostFlaggedProcessing.flaggedBatchesProcessed = false;
        BatchUploadPostFlaggedProcessing.process(new List<rC_Connect__Batch_Upload__c> { bu4 });
    }
    
    static testMethod void test5() {
        setup(5);
        BatchUploadPostFlaggedProcessing.flaggedBatchesProcessed = false;
        BatchUploadPostFlaggedProcessing.process(new List<rC_Connect__Batch_Upload__c> { bu5 });
    }
    
	private static void setup(Integer variant) {
		Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
		addr1 = new rC_Bios__Account_Address__c(
			rC_Bios__Account__c = account1.Id, 
			rC_Bios__Type__c = 'Home',
			rC_Bios__Original_Street_Line_1__c = 'Before',
			rC_Bios__Preferred_Billing__c = true			
		);
		insert addr1;
		
		if(variant == 1) {
			bu1 = new rC_Connect__Batch_Upload__c(
				rC_Connect__Batch_Upload_Status__c = 'Flagged',
				Flagged_Reset_By__c = 'test',
				kwrc__USPS_Verified__c = true,
				rC_Connect__Batch_Upload_Account_Matched__c = account1.Id,
				rC_Connect__Address_Type__c = 'Home',
				rC_Connect__Address_Street_Line_1__c = 'After',
				rC_Connect__Batch_Upload_Flagged_Technical_Reason__c = 'Address Type already exists for Account'
			);
			insert bu1;
		}
		else if(variant == 2) {
			bu2 = new rC_Connect__Batch_Upload__c(
				rC_Connect__Batch_Upload_Status__c = 'Flagged',
				Flagged_Reset_By__c = 'test',
				kwrc__USPS_Verified__c = false,
				//rC_Connect__Batch_Upload_Account_Matched__c = account1.Id,
				rC_Connect__Batch_Upload_Flagged_Technical_Reason__c = 'Address Type already exists for Account',
		        rC_Connect__Address_Street_Line_1__c = 'Unknown'
			);
			insert bu2;
            

		}
		else if(variant == 3) {
			addr2 = new rC_Bios__Account_Address__c(
				rC_Bios__Account__c = account1.Id, 
				rC_Bios__Type__c = 'Work',
				rC_Bios__Original_Street_Line_1__c = 'Before',
				rC_Bios__Preferred_Billing__c = true			
			);
			insert addr2;

			bu3 = new rC_Connect__Batch_Upload__c(
				rC_Connect__Batch_Upload_Status__c = 'Flagged',
				Flagged_Reset_By__c = 'test',
				kwrc__USPS_Verified__c = true,
				rC_Connect__Batch_Upload_Account_Matched__c = account1.Id,
				rC_Connect__Batch_Upload_Flagged_Technical_Reason__c = 'Address Type already exists for Account',
				rC_Connect__Address_Type__c = 'Work',
		        rC_Connect__Address_Street_Line_1__c = 'Before'
			);
			insert bu3;
		}	
        
		else if(variant == 4) {

            bu4 = new rC_Connect__Batch_Upload__c(
				rC_Connect__Batch_Upload_Status__c = 'Flagged',
				Flagged_Reset_By__c = 'test',
				kwrc__USPS_Verified__c = true,
				rC_Connect__Batch_Upload_Account_Matched__c = account1.Id,
				rC_Connect__Batch_Upload_Flagged_Technical_Reason__c = 'Address Type may not be Changed'
			);
			insert bu4;
		}
        
		else if(variant == 5) {

            bu5 = new rC_Connect__Batch_Upload__c(
				rC_Connect__Batch_Upload_Status__c = 'Flagged',
				Flagged_Reset_By__c = 'test',
				kwrc__USPS_Verified__c = true,
				rC_Connect__Batch_Upload_Account_Matched__c = account1.Id,
				rC_Connect__Batch_Upload_Flagged_Technical_Reason__c = 'first error: UNABLE_TO_LOCK_ROW, unable to obtain exclusive access to this record'
			);
			insert bu5;
		}        
	}
}