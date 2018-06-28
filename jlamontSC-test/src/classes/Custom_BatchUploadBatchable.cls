global class Custom_BatchUploadBatchable implements Database.Batchable<sObject>, Database.Stateful {
    
    global String query;
    public static Map<String, Schema.SObjectField> BATCH_UPLOAD_FIELD_MAP = Schema.SObjectType.rC_Connect__Batch_Upload__c.fields.getMap();
    public static List<Schema.SObjectField> BATCH_UPLOAD_FIELD_MAP_VALUES = BATCH_UPLOAD_FIELD_MAP.values();
    public Set<Id> batchUploadIdSet = new Set<Id>();

    Custom_Batch_Upload_Batch_Settings__c SETTINGS = Custom_Batch_Upload_Batch_Settings__c.getInstance();

    Integer delay = SETTINGS.Subsequent_Batch_Delay__c != null ? (Integer)SETTINGS.Subsequent_Batch_Delay__c : 5;
    Integer batchSize = SETTINGS.Batch_Size__c != null ? (Integer)SETTINGS.Batch_Size__c : 1;
    Integer limitRecords = SETTINGS.Limit_Number_of_Records__c != null ? (Integer)SETTINGS.Limit_Number_of_Records__c : 800;
    Boolean isReschedule = SETTINGS.Re_schedule_After_Finish__c != null && SETTINGS.Re_schedule_After_Finish__c == true;
    
    global Custom_BatchUploadBatchable() {
        this.query = '';
    }
    
    global Custom_BatchUploadBatchable(String query) {
        this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext batchableContext) {
        if (String.isBlank(query)) {
            query = getQuery();
        }
        
        String processQuery = query + ' AND ' + rC_Connect__Batch_Upload__c.rC_Connect__Batch_Upload_Status__c
            + '    IN (\'To Process\', \'Processed\', \'New\')'
            + ' LIMIT ' + limitRecords;
        
        rC_Connect__Batch_Upload__c[] batchUploadList = Database.query(processQuery);
        batchUploadIdSet.addAll(new Map<Id,rC_Connect__Batch_Upload__c>(batchUploadList).keyset());
        
        query += ' AND ' + rC_Connect__Batch_Upload__c.rC_Connect__Batch_Upload_Status__c
            +  '  IN (\'Processing - To Process\', \'Processing - Processed\', \'Processing - New\')'
            +  ' AND Id IN :batchUploadIdSet'
            +  ' LIMIT ' + limitRecords;
        
        for(rC_Connect__Batch_Upload__c batchUpload:batchUploadList) {
            batchUpload.rC_Connect__Batch_Upload_Status__c = 'Processing - ' + batchUpload.rC_Connect__Batch_Upload_Status__c;
        }
        update batchUploadList;
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext batchableContext, List<sObject> objectList) {
        rC_Connect.BatchUploadBatchable batchUploadBatchable = new rC_Connect.BatchUploadBatchable('');
        batchUploadBatchable.execute(null,objectList);
    }
    
    global void finish(Database.BatchableContext batchableContext) {
        if (isReschedule && !Test.isRunningTest()) {
            System.scheduleBatch(new Custom_BatchUploadBatchable()
                , Custom_BatchUploadBatchable.class.getName() + '-' + System.now()
                , delay
                , batchSize);
        }
    }
    
    public static String getQuery() {
        String queryNew = '';
        for(Schema.SObjectField batchUploadField: BATCH_UPLOAD_FIELD_MAP_VALUES) {
            if (batchUploadField.getDescribe().isAccessible()) {
                if (queryNew.length() != 0) {
                    queryNew += ', ';
                }

                queryNew += batchUploadField.getDescribe().getName();
            }
        }

        queryNew = 'SELECT ' + queryNew
              + '  FROM ' + SobjectType.rC_Connect__Batch_Upload__c.Name
              + ' WHERE Id != null';
        return queryNew;
    }
}