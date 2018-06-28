/***********************************
 * Test_ExtensionAccountMergeReader
 * 
 * @description: 
 * extension class for visualforce page - ViewMergedAccounts
 * Visualforce page displays attachment which is a JSON serialized 
 * document of the Account merged to the current Account viewed.
 * 
 * *********************************/

@isTest
public class Test_ExtensionAccountMergeReader {
	
	private static testMethod void unitTest() {
		
        Map<String, ID> recmapacct = recTypeIDAccount();
        
		Account testacct = new Account();
        testacct.RecordTypeID = recmapacct.get('Person Account'); 
        testacct.FirstName = 'testfname';
        testacct.LastName = 'testlname';
        testacct.PersonEmail = 'testmti@testmti.com';
        insert testacct;
		
		Account testacctdup = new Account();
        testacctdup.RecordTypeID = recmapacct.get('Person Account'); 
        testacctdup.FirstName = 'testfname2';
        testacctdup.LastName = 'testlname2';
		testacctdup.PersonEmail = 'testmti@testmti.com';
        insert testacctdup;

		Attachment duplicateAcctAttachment = new Attachment();
		duplicateAcctAttachment.ContentType = '.json';
		duplicateAcctAttachment.Description = 'This document contains the values of a merged lead';
		duplicateAcctAttachment.Name = 'Merged Account:' + DateTime.now();
		duplicateAcctAttachment.ParentId = testacct.id;
		duplicateAcctAttachment.body = Blob.valueOf(JSON.serialize(testacctdup));
		Database.insert(duplicateAcctAttachment);
		
        list<AccountHistory> acctFieldHistory = [SELECT Id,NewValue,OldValue,AccountId,Field,CreatedDate FROM AccountHistory WHERE AccountId = :testacctdup.Id ORDER BY CreatedDate limit 50000];
        Attachment duplicateAccountHistoryAttachment = new Attachment();
        duplicateAccountHistoryAttachment.ContentType = '.json';
        duplicateAccountHistoryAttachment.Description = 'This document contains the history of a merged account';
        duplicateAccountHistoryAttachment.Name = 'Merged Account History:' + testacctdup.Id;
        duplicateAccountHistoryAttachment.ParentId = testacct.id;
        duplicateAccountHistoryAttachment.body = Blob.valueOf(JSON.serialize(acctFieldHistory));

		ApexPages.StandardController controller = new ApexPages.StandardController(testacct);
				
		Lead_Merger__c mergerSetting = new Lead_Merger__c();
		mergerSetting.Name = 'Email';
		mergerSetting.Field_Name__c = 'PersonEmail';
		Database.insert(mergerSetting);
		
		test.startTest();

			Extension_AccountMergeReader reader = new Extension_AccountMergeReader(controller);
        	reader.getMergedAccounts();  
    		Set<id> testkeys = reader.accountMergeMap.keyset();
			List<id> listkeys = new List<id>();
         	listkeys.addAll(testkeys);
        	reader.selectedMergedAccountId = listkeys[0];
        	reader.setAccount();
        	reader.getMergedAccountSection();
        	reader.getMergedAccountSectionItem('Name','name');
        	reader.selectedMergedAccountId = null;
        	reader.setAccount();
        	
			
		test.stopTest();
		
	}
      public static Map<String, ID> recTypeIDAccount(){
        
        Map<String, ID> newmap = new Map<String, ID>();
        Schema.DescribeSObjectResult describeopp = Schema.SObjectType.Account;
        List<Schema.RecordTypeInfo> rtInfos = describeopp.getRecordTypeInfos();
        
        for(Schema.RecordTypeInfo rtInfo : rtInfos){ 
            newmap.put(rtInfo.getName(), rtInfo.getRecordTypeId());
        }
        
        return newmap;
    }
}