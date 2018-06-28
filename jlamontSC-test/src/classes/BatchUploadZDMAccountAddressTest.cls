@isTest
private class BatchUploadZDMAccountAddressTest {
    static Id accountHouseholdTypeId;
    static Account account1, account2;
    private static final Double SFLat = 37.788513;
    private static final Double SFLng = -122.399940;
    private static final Double OakLat = 37.810299;
    private static final Double OakLng = -122.265997;

    static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    }

    static testMethod void mainTest() {

        account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
        );
        account2 = new Account(
            Name='Account2',
            RecordTypeId = accountHouseholdTypeId
        );
	    List<Account> accountList = new List<Account>();
        accountList.add(account1);
        accountList.add(account2);
        insert accountList;
        rC_Bios__Account_Address__c addr1 = new rC_Bios__Account_Address__c(
        	rC_Bios__Account__c = account1.Id,
        	rC_Bios__Original_Street_Line_1__c = '85 Second St.',
        	rC_Bios__Original_City__c = 'San Francisco',
			rC_Bios__Original_State__c = 'CA',
        	rC_Bios__Original_Postal_Code__c = '94105'
        );
        rC_Bios__Account_Address__c addr2 = new rC_Bios__Account_Address__c(
        	rC_Bios__Account__c = account2.Id,
        	rC_Bios__Original_Street_Line_1__c = '2101 Webster St.',
        	rC_Bios__Original_City__c = 'Oakland',
			rC_Bios__Original_State__c = 'CA',
        	rC_Bios__Original_Postal_Code__c = '94612'
        );
	    List<rC_Bios__Account_Address__c> acctAddrList = new List<rC_Bios__Account_Address__c>();
        acctAddrList.add(addr1);
        acctAddrList.add(addr2);
        insert acctAddrList;

		List<rC_Bios__Address__c> addrList = [
        	select Id, rC_Bios__Street_Line_1__c, rC_Bios__City__c from rC_Bios__Address__c
        ];
        List<rC_Connect__Batch_Upload__c> buList1 = new List<rC_Connect__Batch_Upload__c>();
        
        for(rC_Bios__Address__c addr : addrList) {
			rC_Connect__Batch_Upload__c bu = new rC_Connect__Batch_Upload__c(
				rC_Connect__Batch_Upload_Address_Matched__c = addr.Id,
				rC_Connect__Address_Status__c = 'Inserted',
				kwrc__USPS_Street__c = addr.rC_Bios__Street_Line_1__c,
				kwrc__Latitude__c = addr.rC_Bios__City__c == 'San Francisco' ? SFLat : OakLat,
				kwrc__Longitude__c = addr.rC_Bios__City__c == 'San Francisco' ? SFLng : OakLng
			);
			buList1.add(bu);
        }
        insert buList1;
        
        //Insert will set status to Pending - update to set it to Committed
		List<rC_Connect__Batch_Upload__c> buList2 = new List<rC_Connect__Batch_Upload__c>();
		for(rC_Connect__Batch_Upload__c bu : buList1) {
			bu.rC_Connect__Batch_Upload_Status__c = 'Committed';
			buList2.add(bu);
		}
		BatchUploadTriggerHandler.updatingAccountAddress = true;
		update buList2;
        
        Test.startTest();
        new BatchUploadZDMAccountAddress().execute(null);
        Test.stopTest();
        
        acctAddrList = [
        	select rC_Bios__Address__c, rC_Bios__Original_City__c, kwrc__Latitude__c, kwrc__Longitude__c from rC_Bios__Account_Address__c
        ];
        
		Boolean addr1Matched = false;
		Boolean addr2Matched = false;        
        for(rC_Bios__Account_Address__c addr : acctAddrList) {
        	if(addr.rC_Bios__Original_City__c == 'San Francisco') {
        		if(addr.kwrc__Latitude__c == SFLat && addr.kwrc__Longitude__c == SFLng) {
        			addr1Matched = true;
        		}
        	}
        	else {
        		if(addr.kwrc__Latitude__c == OakLat && addr.kwrc__Longitude__c == OakLng) {
        			addr2Matched = true;
        		}
        	}
        }
        System.assert(addr1Matched && addr2Matched);
        
        List<rC_Connect__Batch_Upload__c> buList = [
        	select Id, AccountAddressUpdated__c from rC_Connect__Batch_Upload__c
        ];
        for(rC_Connect__Batch_Upload__c bu : buList) {
        	System.assert(bu.AccountAddressUpdated__c);
        }
        System.assertEquals(2, buList.size());
    }
    static testMethod void testEmptyList() {
        Test.startTest();
        new BatchUploadZDMAccountAddress().execute(null);
        Test.stopTest();
    }
}