@isTest
public class Test_Custom_BatchUploadBatchable {
    public static final String BATCHSTATUS_COMMITTED = 'Committed';
    @IsTest
  public static void test_BU_Processing() {
        String methodName = 'test_BU_Processing';
      
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(FirstName = 'Test FirstName', LastName = 'Test LastName', AccountId = account.Id);
        insert contact;
        
        Campaign campaign = new Campaign(Name = 'Test Campaign');
        insert campaign;
        
        rC_Connect__Batch_Upload__c  batchUpload = new rC_Connect__Batch_Upload__c();
        batchUpload.name = 'Test BU';
        batchUpload.rC_Connect__Batch_Upload_Account_Matched__c = account.Id;
        batchUpload.rC_Connect__Batch_Upload_Contact_1_Matched__c = contact.id;
        batchUpload.rC_Connect__Batch_Upload_Campaign_Matched__c = campaign.id;
        batchUpload.rC_Connect__Batch_Upload_Status__c = 'New';
        batchUpload.rC_Connect__Exclude_Giving__c = true;
        insert batchupload;
    
        Custom_Batch_Upload_Batch_Settings__c customBUSetting = Custom_Batch_Upload_Batch_Settings__c.getInstance();
        customBUSetting.Subsequent_Batch_Delay__c = 5;
        customBUSetting.Batch_Size__c = 1;
        customBUSetting.Limit_Number_of_Records__c = 800;
        customBUSetting.Re_schedule_After_Finish__c = true;
        upsert customBUSetting;

        Test.startTest();
        Database.executeBatch(new Custom_BatchUploadBatchable(), 1);
        Test.stopTest();

        rC_Connect__Batch_Upload__c[] batchUploadlist = [
            SELECT Id
            , rC_Connect__Batch_Upload_Status__c
            , rC_Connect__Batch_Upload_Giving_Matched__c
            , rC_Connect__Batch_Upload_Flagged_Reason__c
            , rC_Connect__Batch_Upload_Flagged_Technical_Reason__c
            FROM rC_Connect__Batch_Upload__c
            WHERE Name = 'Test BU'
        ];

        system.assertEquals( BATCHSTATUS_COMMITTED
                            , batchUploadlist[0].rC_Connect__Batch_Upload_Status__c 
                            , methodName + ' failed : batchupload status is not '
                            + BATCHSTATUS_COMMITTED);

            
    }
}