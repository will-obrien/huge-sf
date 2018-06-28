public with sharing class hqInt_ManualRunController {

    public String phaseOneServer { get; set;}
    public String phaseTwoServer { get; set;}
    public List<SelectOption> serverCodes { get; set;}
    public Boolean batchIsRunning { get; set;}
    public Boolean phase2Running { get; set;}
    public String batchSubmittedDate { get; set;}
    public AsyncApexJob batchClassJob { get; set;}
    public list <JobWrapper> phase2Jobs { get; set;}

    public hqInt_ManualRunController() {
        List<String> values = HqBatchJobHelper.getCommcareServers(true);
        this.serverCodes = new List<SelectOption>();
        for (String val : values) {
            this.serverCodes.add(new SelectOption(val, val));
        }
        this.phaseOneServer = values[0];
        this.phaseTwoServer = values[0];
        fetchRunningInstances();
        fetchRunningInstancesPhase2();
    }

    public void fetchRunningInstances() {
        this.batchIsRunning = false;
        ApexClass batchClass;
        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
        if (settings.Is_Domain_Job_Running__c == true) {
            this.batchIsRunning = true;
            this.phaseOneServer = settings.Server_Code__c;
        }

        try {
            batchClass = [SELECT Id FROM ApexClass WHERE Name='HqBatchFetchDataDomains' LIMIT 1];
        } catch(exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Class not found'));
        }

        batchClassJob = null;
        AsyncApexJob[] batchClassJobList = [SELECT Id, JobItemsProcessed, TotalJobItems, createdDate FROM AsyncApexJob WHERE ApexClassID = :batchClass.Id
                                                AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing') ORDER BY createdDate DESC LIMIT 1];

        if(batchClassJobList != null && batchClassJobList.size() > 0) {
            this.batchIsRunning = true;
            this.batchClassJob = batchClassJobList[0];
            this.batchSubmittedDate = batchClassJobList[0].createdDate.format();
        }
    }

    public PageReference runBatchJob() {
        fetchRunningInstances();
        if(!this.batchIsRunning) {
            Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
            settings.Is_Domain_Job_Running__c = true;
            update settings;
            Database.executeBatch(new HqBatchFetchDataDomains(this.phaseOneServer, new List<String>()), 1);
        }

        fetchRunningInstances();
        return null;
    }

    //FOR phase 2
    public void fetchRunningInstancesPhase2() {
        List <String> objectNames = new List <String>();
        objectNames.add(accounting_feature__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_BillingAccountAdmin__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_Softwareplan__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_Subscriber__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_Featurerate__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_SoftwareProductRate__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_SoftwarePlanVersion__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_PaymentMethod__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_BillingContactInfo__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_Paymentrecord__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_Billingaccount__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_Subscription__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_Invoice__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_LineItems__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_SubscriptionAdjustment__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_CreditLine__c.SObjectType.getDescribe().getLabel());
        objectNames.add(Accounting_CreditAdjustment__c.SObjectType.getDescribe().getLabel());

        this.phase2Running = false;
        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
        this.phase2Running = settings.Is_Job_Running__c;
        String customObject = settings.Job_Helper_Field__c;
        this.phaseTwoServer = this.phase2Running == true ? settings.Server_Code__c : this.phaseTwoServer;

        this.batchClassJob = null;
        AsyncApexJob[] batchClassJobList = [SELECT Id, JobItemsProcessed, TotalJobItems, createdDate, ApexClass.Id, ApexClass.Name, Status, CompletedDate
                                            FROM AsyncApexJob
                                            WHERE ApexClass.Name = 'HqBatchFetchDataObjects' AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing')
                                            ORDER BY createdDate DESC LIMIT 1];

        if(batchClassJobList != null && batchClassJobList.size() > 0) {
            this.phase2Running = true;
            this.batchClassJob = batchClassJobList[0];
        }

        phase2Jobs = new List<JobWrapper>();

        for (String jobName : objectNames) {
            JobWrapper jobWrapper = new jobWrapper();
            jobWrapper.jobName = jobName;
            phase2Jobs.add(jobWrapper);
        }

        JobWrapper jobWrapper;
        for (JobWrapper job : phase2Jobs) {
            if (job.jobName == customObject) {
                jobWrapper = job;
                break;
            }
        }

        if (jobWrapper != null && batchClassJob != null) {
            jobWrapper.jobItemsProcessed = batchClassJob.JobItemsProcessed;
            jobWrapper.totalJobItems = batchClassJob.TotalJobItems;
            jobWrapper.isRunning = true;
        }
    }

    public PageReference runBatchJobPhase2() {
        fetchRunningInstancesPhase2();

        if (this.phase2Running == false) {
            Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
            settings.Job_Start_Date__c = Date.today();
            settings.Is_Job_Running__c = true;
            update settings;

            HqBatchJobHelper.runNextBatchJob(1, this.phaseTwoServer, new List<String>());
        }

        fetchRunningInstancesPhase2();
        return null;
    }

    public class JobWrapper {
        public String jobName { get; set;}
        public Boolean isRunning { get; set;}
        public Integer jobItemsProcessed { get; set;}
        public Integer totalJobItems { get; set;}
    }
}