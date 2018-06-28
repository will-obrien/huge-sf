public class DomainMonthlySnapshotBatch implements Database.Batchable<Accounting_Subscription__c>, Database.Stateful {

    private Map<String, Decimal> wamMap;
    private Map<String, Decimal> formsMap;
    private Map<String, Decimal> formsForPeriodMap;
    private Map<String, Decimal> mobileUsersMap;
    private Map<String, Decimal> recordCountMap;
    private Date currentDate;
    private Boolean error;
    private BatchDefaultSettings__c settings;

    public DomainMonthlySnapshotBatch() {
        this(Date.today());
    }

    public DomainMonthlySnapshotBatch(Date currentDate) {
        this.currentDate = currentDate;
        this.wamMap = new Map<String, Decimal> { 'Reseller' => 0, 'Managed Hosting' => 0, 'Advanced' => 0, 'Community' => 0, 'Enterprise' => 0, 'Standard' => 0, 'Pro' => 0};
        this.formsMap = new Map<String, Decimal> { 'Reseller' => 0, 'Managed Hosting' => 0, 'Advanced' => 0, 'Community' => 0, 'Enterprise' => 0, 'Standard' => 0, 'Pro' => 0};
        this.mobileUsersMap = new Map<String, Decimal> { 'Reseller' => 0, 'Managed Hosting' => 0, 'Advanced' => 0, 'Community' => 0, 'Enterprise' => 0, 'Standard' => 0, 'Pro' => 0};
        this.recordCountMap = new Map<String, Decimal> { 'Reseller' => 0, 'Managed Hosting' => 0, 'Advanced' => 0, 'Community' => 0, 'Enterprise' => 0, 'Standard' => 0, 'Pro' => 0};
        this.formsForPeriodMap = new Map<String, Decimal> { 'Reseller' => 0, 'Managed Hosting' => 0, 'Advanced' => 0, 'Community' => 0, 'Enterprise' => 0, 'Standard' => 0, 'Pro' => 0};
        this.error = false;
        this.settings = BatchDefaultSettings__c.getOrgDefaults();
    }

    public List<Accounting_Subscription__c> start(Database.BatchableContext context) { // We cannot group by formula field
       return [SELECT Id, Created_By__c, Accounting_subscriber_domain__c, Software_Plan_Edition__c, Accounting_subscriber_domain__r.Wam__c, Accounting_subscriber_domain__r.cpActiveMobileUsers__c, service_type__c,
               Accounting_subscriber_domain__r.cpAllForms__c, Accounting_subscriber_domain__r.InternalProp_self_started__c FROM Accounting_Subscription__c
               WHERE is_trial__c = false AND is_active__c = true AND Accounting_subscriber_domain__c != null AND
               Accounting_subscriber_domain__r.Likely_Real__c = true AND Accounting_subscriber_domain__r.is_test__c != 'true' AND
               Accounting_subscriber_domain__r.cpIsActive__c = true];
    }

    public void execute(Database.BatchableContext context, List<Accounting_Subscription__c> scope) {
        // TODO generate domains set and fetch latest and oldest history of record this motnh and then make forms for period calculations!!! and just summarize that value
        // I think we need regenarate all calculations from Februaryto achive that, so also history job must be updated, i hope it will ready to deplo on 10 May!!!

        try {
            Set<Id> domainsSet = new Set<Id>();
            for (Accounting_Subscription__c sub : scope) {
                domainsSet.add(sub.Accounting_subscriber_domain__c);
            }

            Map<Id, Decimal> domainStartMonthHistory = new Map<Id, Decimal>();
            Map<Id, Decimal> domainEndMonthHistory = new Map<Id, Decimal>();

            Date beginM = this.currentDate.toStartOfMonth();
            DateTime beginMDT = DateTime.newInstance(beginM.year(), beginM.month(),beginM.day());
            DateTime endMDT = DateTime.newInstance(beginM.year(), beginM.month(), Date.daysInMonth(beginM.year(), beginM.month()));

            if (!Test.isRunningTest()) {
                List<Domain__History> historyRecords = [SELECT ParentId, OldValue, NewValue, CreatedDate FROM Domain__History WHERE ParentId IN: domainsSet AND CreatedDate >=: beginMDT
                                                            AND CreatedDate <=: endMDT AND Field = 'cpAllForms__c' ORDER BY CreatedDate ASC];
                for (Domain__History hr : historyRecords) {
                    if (!domainStartMonthHistory.containsKey(hr.ParentId)) {
                        domainStartMonthHistory.put(hr.ParentId, (Decimal) (hr.OldValue != null ? hr.OldValue : 0)); // we want the oldest value of the month
                    }
                    domainEndMonthHistory.put(hr.ParentId, (Decimal) (hr.NewValue != null ? hr.NewValue : 0)); //we want latest value of the month
                }
            } else {
                domainStartMonthHistory = HqIntegrationTests.getTestDataForStartMonth(scope);
                domainEndMonthHistory = HqIntegrationTests.getTestDataForEndMonth(scope);
                System.debug('domainStartMonthHistory: ' + domainStartMonthHistory);
                System.debug('domainEndMonthHistory: ' + domainEndMonthHistory);
            }

            for (Accounting_Subscription__c sub : scope) {
                String softwarePlan = sub.Software_Plan_Edition__c;
                if (softwarePlan == '' || softwarePlan == null || softwarePlan == '-') {
                    continue; // we want skip empty plan
                }

                Decimal forPeriodValue = (domainEndMonthHistory.containsKey(sub.Accounting_subscriber_domain__c) ? domainEndMonthHistory.get(sub.Accounting_subscriber_domain__c) : 0)
                                         - (domainStartMonthHistory.containsKey(sub.Accounting_subscriber_domain__c) ? domainStartMonthHistory.get(sub.Accounting_subscriber_domain__c) : 0);
                if (forPeriodValue < 0) {
                    System.debug('Negative value!!: ' + forPeriodValue + ' in ' + sub.Accounting_subscriber_domain__c);
                        EmailHelper.sendEmail(BatchDefaultSettings__c.getOrgDefaults().Error_Emails__c.split(','), 
                            'Found Negative Value in Domain Snapshot', 'Negative value!!: ' + forPeriodValue + ' in ' + sub.Accounting_subscriber_domain__c);
                } else {
                    this.formsForPeriodMap.put(softwarePlan, this.formsForPeriodMap.get(softwarePlan)
                                        + ((domainEndMonthHistory.containsKey(sub.Accounting_subscriber_domain__c) ? domainEndMonthHistory.get(sub.Accounting_subscriber_domain__c) : 0)
                                         - (domainStartMonthHistory.containsKey(sub.Accounting_subscriber_domain__c) ? domainStartMonthHistory.get(sub.Accounting_subscriber_domain__c) : 0)));
                }
                this.wamMap.put(softwarePlan, wamMap.get(softwarePlan) + (sub.Accounting_subscriber_domain__r.Wam__c != null ? sub.Accounting_subscriber_domain__r.Wam__c : 0));
                this.formsMap.put(softwarePlan, formsMap.get(softwarePlan) + (sub.Accounting_subscriber_domain__r.cpAllForms__c != null ? sub.Accounting_subscriber_domain__r.cpAllForms__c : 0));
                this.mobileUsersMap.put(softwarePlan, mobileUsersMap.get(softwarePlan) + (sub.Accounting_subscriber_domain__r.cpActiveMobileUsers__c != null ? sub.Accounting_subscriber_domain__r.cpActiveMobileUsers__c : 0));
                this.recordCountMap.put(softwarePlan, recordCountMap.get(softwarePlan) + 1);
            }
        } catch (Exception e) {
            System.debug('Error: ' + e);
            if (!Test.isRunningTest()) {
                EmailHelper.sendEmailFromException(this.settings.Error_Emails__c.split(','), 'Cannot calculate monthy Domain Snapshots',
                                    'Error : ', e);
            }
            this.error = true;
            //throw e; // we want stop calculations and fix problems
        }
    }

    public void finish(Database.BatchableContext context) {
        try {
            if (error == false) {
                List<Domain_Monthly_Snapshot__c> snapshots = new List<Domain_Monthly_Snapshot__c>();
                for (String key : recordCountMap.keySet()) {
                    Domain_Monthly_Snapshot__c snapshot = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = key, Snapshot_Date__c = this.currentDate, Forms__c = this.formsMap.get(key),
                                                                Wam__c = this.wamMap.get(key), Forms_for_Period__c = this.formsForPeriodMap.get(key), Active_Mobile_Users__c = this.mobileUsersMap.get(key),
                                                                Scale_of_Programs__c = this.recordCountMap.get(key));
                    snapshots.add(snapshot);
                }
                insert snapshots;
            }
        } catch (Exception e) {
            System.debug('Error: ' + e);
            if (!Test.isRunningTest()) {
                EmailHelper.sendEmailFromException(this.settings.Error_Emails__c.split(','), 'Cannot calculate monthy Domain Snapshots',
                                    'Error : ', e);
            }
        }
    }
}