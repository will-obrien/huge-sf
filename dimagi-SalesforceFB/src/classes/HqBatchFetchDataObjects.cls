/**
 * Batch for synchronization Accounting custom objects form Commcare HQ.
 */
public class HqBatchFetchDataObjects implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {

    public static final String EMAIL_SUBJECT = 'CommCare Salesforce Job Run Report - ';

    public Integer batchNo;
    private CommcareToSalesforceSettings__c serverSettings;
    private String customObject;
    private Integer successfullyLoadedRecords;
    private Integer apiLimitParameter;
    private HqAccountingProcessHelper hqHelper;
    private List<String> nextServers;
    private String serverCode;

    public HqBatchFetchDataObjects(Integer batchNo, String customObject, String serverCode, String urlSuffix, List<String> nextServers) {
        System.debug('Job created with : ' + batchNo + ' ' + customObject + ' ' + serverCode);
        this.serverCode = serverCode;
        this.nextServers = nextServers;
        this.serverSettings = CommcareToSalesforceSettings__c.getInstance(serverCode);
        this.batchNo = batchNo;
        this.customObject = customObject;
        this.successfullyLoadedRecords = 0;

        if (this.serverSettings == null) {
            Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
            EmailHelper.sendEmail(settings.Error_Emails__c.split(','), 'Commcare sync Error', 'Cannot find server settings with name : ' + this.serverCode);
            HqBatchJobHelper.endBatchJobs();
            NoDataFoundException ex = new NoDataFoundException();
            ex.setMessage('Cannot find settings for server with given code : ' + serverCode);
            throw ex;
        }

        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
        settings.Server_Code__c = serverCode;
        settings.Job_Helper_Field__c = customObject;
        update settings;

        this.apiLimitParameter = this.serverSettings.API_Limit_Parameter__c != null ? Integer.valueOf(this.serverSettings.API_Limit_Parameter__c)
                            : 10;
        this.hqHelper = new HqAccountingProcessHelper(this.serverSettings, urlSuffix);
    }

    public Iterable<Integer> start(Database.BatchableContext BC) {
        Integer totalCount = this.hqHelper.getTotalCount();

        if (totalCount == null) {
            return new List<Integer>();
        }

        List<Integer> listOffset = new List<Integer>();
        for(Integer i = 0; i <= totalCount / this.apiLimitParameter; i++) {
          listOffset.add(i * this.apiLimitParameter);
        }
        if(Test.isRunningTest()) {
            listOffset = new List<Integer>{0};
        }

        return listOffset;
    }

    public void execute(Database.BatchableContext info, List<Integer> offsetList) {
        Boolean success = false;
        Integer requests = 0;
        Exception e;
        while (!success && requests < 3) {
            try {
                this.successfullyLoadedRecords += this.hqHelper.processAccounting(offsetList[0]);
                success = true;
            } catch(Exception ex) {
                e = ex;
                requests++;
            }
        }

        if (success == false && e != null) {
            System.debug('Failed at offset with limit param ' + this.apiLimitParameter);
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
            hqInt_BatchErrorLogger.logError(info.getJobId(), '\n Object : ' + this.customObject + ' failed at offset with limit param '
                    + this.apiLimitParameter +' : '+ String.valueOf(offsetList[0]), e.getMessage(), e.getStackTraceString());
        }
     }

    public void finish(Database.BatchableContext info) {
        if (this.batchNo >= 16) {
            Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
            this.serverSettings.Last_Run_Date__c = settings.Job_Start_Date__c;
            update this.serverSettings;
        }

        if(!Test.IsRunningTest()) {
            String subject = this.serverCode + ' - ' + EMAIL_SUBJECT + this.customObject + ' Object';
            String emailBody = 'Total Successfully loaded ' + this.customObject + ' records = ' + successfullyLoadedRecords + '\n\n';
            hqInt_BatchErrorLogger.sendErrorEmails(info.getJobId(), subject, emailBody);
            HqBatchJobHelper.runNextBatchJob(this.batchNo + 1, this.serverCode, this.nextServers);
        }
    }
}