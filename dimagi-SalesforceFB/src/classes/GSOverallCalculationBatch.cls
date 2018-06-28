/**
 * Calculates GS Quality for Overall Status and for Customer Satisfaction in PRO Snapshots.
 */
public without sharing class GSOverallCalculationBatch implements Database.Batchable<Business_Unit__c>, Database.Stateful {

    private Date startDate;
    private Date endDate;
    private Date currentDate;
    private Double gsTotalOverall;
    private Double gsTotalSatisfaction;
    private Double gsTotalBudget;
    private Set<Id> snapshots;

    public GSOverallCalculationBatch() {
        this.currentDate = Date.today();
        this.gsTotalOverall = 0;
        this.gsTotalSatisfaction = 0;
        this.gsTotalBudget = 0;
    }

    public GSOverallCalculationBatch(Date currentDate) {
        this.currentDate = currentDate;
        this.gsTotalOverall = 0;
        this.gsTotalSatisfaction = 0;
        this.gsTotalBudget = 0;
    }

    public List<Business_Unit__c> start(Database.BatchableContext BC) {
        List<Date> thursDayList = PROHelper.GetAllThursDayOfMonth(this.currentDate.year(), this.currentDate.month());
        List<Date> thursDayListLastMonth = PROHelper.GetAllThursDayOfMonth(this.currentDate.addMonths(-1).year(), this.currentDate.addMonths(-1).month());
        List<Date> thursDayListNextMonth = PROHelper.GetAllThursDayOfMonth(this.currentDate.addMonths(1).year(), this.currentDate.addMonths(1).month());

        if (this.currentDate < thursDayList[1]) {
            this.startDate = thursDayListLastMonth[3];
            this.endDate = thursDayList[1];
        } else if (this.currentDate < thursDayList[3]) {
            this.startDate = thursDayList[1];
            this.endDate = thursDayList[3];
        } else {
            this.startDate = thursDayList[3];
            this.endDate = thursDayListNextMonth[1];
        }

        List<Project_Report_Out__c> pros = [SELECT Id, Contract_Snapshot__c FROM Project_Report_Out__c WHERE Contract_Snapshot__c != null
                                                AND Report_Out_Date__c >=: this.startDate AND Report_Out_Date__c <: this.endDate];

        this.snapshots = new Set<Id>();
        for (Project_Report_Out__c pro : pros) {
            this.snapshots.add(pro.Contract_Snapshot__c);
        }
        return [SELECT Id, Name FROM Business_Unit__c];
    }

    public void execute(Database.BatchableContext BC, List<Business_Unit__c> scope) {
        try {
            Map<Id, String> buMapping = new Map<Id, String>(); 
            for (Business_Unit__c bu : scope) {
                buMapping.put(bu.Id, bu.Name);
            }

            AggregateResult[] groupedResults = [SELECT Contract__r.Prime_Contracting_Business_Unit__c, SUM(Project_Quality_Overall_Status__c), SUM(Customer_Satisfaction_of_services__c),
                                                SUM(GS_Execution_Budget__c)
                                                FROM PRO_Contract_Snapshot__c WHERE Id IN: snapshots AND Contract__c != null AND Snapshot_Date__c >=: this.startDate
                                                AND Snapshot_Date__c <: this.endDate
                                                GROUP BY Contract__r.Prime_Contracting_Business_Unit__c];
            AggregateResult[] groupedResultsRevenue = [SELECT Contract__r.Prime_Contracting_Business_Unit__c, SUM(GS_Revenue__c)
                                                FROM PRO_Contract_Snapshot__c WHERE Contract__c != null AND Snapshot_Date__c >=: this.startDate
                                                AND Snapshot_Date__c <: this.endDate
                                                GROUP BY Contract__r.Prime_Contracting_Business_Unit__c];

            Sobject sobj = (Sobject) new Contract_Statistic__c(PRO_Cycle_Date__c = this.startDate , DLAC_GS_Customer_Sat__c = 0, DLAC_GS_Overall_Status__c = 0, DSA_GS_Customer_Sat__c = 0,
                                            DSA_GS_Overall_Status__c = 0, DSI_GS_Customer_Sat__c = 0, DSI_GS_Overall_Status__c = 0, DTZ_GS_Customer_Sat__c = 0, DTZ_GS_Overall_Status__c = 0,
                                            DWA_GS_Customer_Sat__c = 0, DWA_GS_Overall_Status__c = 0, Inc_GS_Customer_Sat__c = 0, Inc_GS_Overall_Status__c = 0, Myanmar_GS_Customer_Sat__c = 0,
                                            Myanmar_GS_Overall_Status__c = 0, GS_Quality_Total_Customer_Satisfaction__c = 0, GS_Quality_Total_Overall_Status__c = 0, DLAC_GS_Revenue__c = 0,
                                            DSA_GS_Revenue__c = 0, DSI_GS_Revenue__c = 0, DTZ_GS_Revenue__c = 0, DWA_GS_Revenue__c = 0, Inc_GS_Revenue__c = 0, Myanmar_GS_Revenue__c = 0);

            for (AggregateResult result : groupedResultsRevenue) {
                Id buId = (Id) result.get('Prime_Contracting_Business_Unit__c');
                if (buId == null) {
                    continue;
                }
                Double gsRevenue = (Double) result.get('expr0');
                if (gsRevenue == null) {
                    gsRevenue = 0;
                }
                String buName = buMapping.get(buId);
                String revenueField = (buName + '_GS_Revenue__c').toLowerCase();
                if (hasSObjectField(revenueField, sobj)) {
                    sobj.put(revenueField, gsRevenue);
                } else {
                    System.debug('Cannot find field with name : ' + revenueField);
                    if (!Test.isRunningTest()) {
                        EmailHelper.sendEmail(BatchDefaultSettings__c.getOrgDefaults().Error_Emails__c.split(','), 'Cannot find sObject field for GS Quality',
                                    'Cannot find fields: ' + revenueField);
                    }
                }
            }

            System.debug('groupedResults'+ groupedResults);
            for (AggregateResult result : groupedResults) {
                Id buId = (Id) result.get('Prime_Contracting_Business_Unit__c');
                if (buId == null) {
                    continue;
                }

                Double gsOverall = (Double) result.get('expr0');
                Double gsSatisfaction = (Double) result.get('expr1');
                Double gsBudget = (Double) result.get('expr2');

                this.gsTotalOverall += gsOverall != null ? gsOverall : 0;
                this.gsTotalSatisfaction += gsSatisfaction != null ? gsSatisfaction : 0;
                this.gsTotalBudget += gsBudget != null ? gsBudget : 0;

                if (gsBudget == null || gsBudget == 0 || gsOverall == null || gsSatisfaction == null) {
                    gsOverall = 0;
                    gsSatisfaction = 0;
                } else {
                    gsOverall = 100 * (gsOverall / gsBudget);
                    gsSatisfaction = 100 * (gsSatisfaction / gsBudget);
                }

                String buName = buMapping.get(buId);
                String qualityField = (buName + '_GS_Overall_Status__c').toLowerCase();
                String customerField = (buName + '_GS_Customer_Sat__c').toLowerCase();
                if (hasSObjectField(qualityField, sobj) && hasSObjectField(customerField, sobj)) {
                    sobj.put(qualityField, gsOverall);
                    sobj.put(customerField, gsSatisfaction);
                } else {
                    System.debug('Cannot find field with name : ' + qualityField + ' ' + customerField);
                    if (!Test.isRunningTest()) {
                        EmailHelper.sendEmail(BatchDefaultSettings__c.getOrgDefaults().Error_Emails__c.split(','), 'Cannot find sObject field for GS Quality',
                                    'Cannot find fields: ' + qualityField + ', ' + customerField);
                    }
                }
            }

            if (this.gsTotalBudget != 0) {
                this.gsTotalSatisfaction = 100 * (this.gsTotalSatisfaction / this.gsTotalBudget);
                this.gsTotalOverall = 100 * (this.gsTotalOverall / this.gsTotalBudget);
            } else {
                this.gsTotalSatisfaction = 0;
                this.gsTotalOverall = 0;
            }

            Contract_Statistic__c contractStats = (Contract_Statistic__c) sobj;
            contractStats.GS_Quality_Total_Overall_Status__c = this.gsTotalOverall;
            contractStats.GS_Quality_Total_Customer_Satisfaction__c = this.gsTotalSatisfaction;
            insert contractStats;

        } catch (Exception ex) {
            System.debug('Error : ' + ex);
            if (!Test.isRunningTest()) {
                BatchDefaultSettings__c settings = BatchDefaultSettings__c.getOrgDefaults();
                EmailHelper.sendEmailFromException(settings.Error_Emails__c.split(','), 'GS Quality calculation error', 'GS Quality calculation error', ex);
            }
        }
    }

    public void finish(Database.BatchableContext BC) {
    }

    private Boolean hasSObjectField(String fieldName, SObject so) {
        return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName);
    }
}