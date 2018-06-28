/**
 * Calculates for period fields in Pipeline Snapshot custom object.
 */
public class ForPeriodCalcSnapshotBatch implements Database.Batchable<Pipeline_Snapshot__c>, Database.Stateful {

    private Boolean forTotal;
    private Boolean forOpp;
    private Date customDate;

    public ForPeriodCalcSnapshotBatch(Boolean forTotal){
        this.forTotal = forTotal;
        this.forOpp = false;
        this.customDate = null;
    }

    public ForPeriodCalcSnapshotBatch(Boolean forTotal, Boolean forOpp){
        this.forTotal = forTotal;
        this.forOpp = forOpp;
        this.customDate = null;
    }

    public List<Pipeline_Snapshot__c> start(Database.BatchableContext context) {
        List<Pipeline_Snapshot__c> snaps = new List<Pipeline_Snapshot__c>();
        if (!forOpp) {
            return getContractPS();
        }
        return getOppPS();
    }

    public void execute(Database.BatchableContext context, List<Pipeline_Snapshot__c> snapshots) {
        if (forOpp == false) {
            calculateContractForPeriod(snapshots);
        } else {
            calculateOppForPeriod(snapshots);
        }
    }

    public void finish(Database.BatchableContext context) {
        if (this.forOpp == false && this.forTotal == false) {
            Database.executeBatch(new ForPeriodCalcSnapshotBatch(true), 50);
        } else if (this.forOpp == false  && this.forTotal == true) {
            Database.executeBatch(new ForPeriodCalcSnapshotBatch(false, true), 50);
        } else if (this.forOpp == true && this.forTotal == false) {
            Database.executeBatch(new ForPeriodCalcSnapshotBatch(true, true), 50);
        }
    }

    public void setCustomDate(Date customDate) {
        this.customDate = customDate;
    }

    private void calculateContractForPeriod(List<Pipeline_Snapshot__c> snapshots) {
        System.debug('snapshots: ' + snapshots.size());
        List<Pipeline_Snapshot__c> toUpdate = new List<Pipeline_Snapshot__c>();
        try {
            Map<Id, Pipeline_Snapshot__c> oldSnapshots = SnapshotHelper.getOldSnapshots(snapshots, forTotal);
            for (Pipeline_Snapshot__c sn : snapshots) {
                Pipeline_Snapshot__c oldSn = new Pipeline_Snapshot__c();
                if (sn.Contract__c != null && oldSnapshots.containsKey(sn.Contract__c)) {
                    oldSn = oldSnapshots.get(sn.Contract__c);
                }
                sn = SnapshotHelper.calculateForPeriod(sn, oldSn);
                toUpdate.add(sn);
            }
            update toUpdate;
        } catch(Exception ex) {
            System.debug('ERROR:' + ex);
            if (!Test.isRunningTest()) {
                BatchDefaultSettings__c settings = BatchDefaultSettings__c.getOrgDefaults();
                EmailHelper.sendEmailFromException(settings.Error_Emails__c.split(','), 'For Period calculation error', 'Period calculation error', ex);
            }
        }
    }

    private List<Pipeline_Snapshot__c> getContractPS() {
        if (this.forTotal == false) {
            return [SELECT Id, Contract__c, Work_Completed__c, Services_Spend__c, Expense_Travel_Spend__c, Product_Spend__c, Total_Calculated_Costs__c, GS_Services_Completed__c,
                    GS_Services_Completed_Handover__c, GS_Net_Income_to_Date__c, GS_Net_Income_to_Date_Handover__c,
                    Work_Completed_for_Period__c, Expense_Travel_Spend_for_Period__c, GS_Net_Income_for_Period__c, GS_Net_Income_for_Period_by_Handover__c,
                    GS_Services_Handover_Completed_for_Per__c, GS_Services_Completed_for_Period__c, Product_Spend_for_Period__c, Services_Spend_for_Period__c,
                    Total_Calculated_Costs_for_Period__c, Month_Date__c
                    FROM Pipeline_Snapshot__c WHERE CreatedDate >= YESTERDAY AND Stage__c != 'Total' AND Source_Type__c = 'Contract'];
        }
        return [SELECT Id, Contract__c, Work_Completed__c, Services_Spend__c, Expense_Travel_Spend__c, Product_Spend__c, Total_Calculated_Costs__c, GS_Services_Completed__c,
                    GS_Services_Completed_Handover__c, GS_Net_Income_to_Date__c, GS_Net_Income_to_Date_Handover__c,
                    Work_Completed_for_Period__c, Expense_Travel_Spend_for_Period__c, GS_Net_Income_for_Period__c, GS_Net_Income_for_Period_by_Handover__c,
                    GS_Services_Handover_Completed_for_Per__c, GS_Services_Completed_for_Period__c, Product_Spend_for_Period__c, Services_Spend_for_Period__c,
                    Total_Calculated_Costs_for_Period__c, Month_Date__c
                    FROM Pipeline_Snapshot__c WHERE CreatedDate >= YESTERDAY AND Stage__c = 'Total' AND Source_Type__c = 'Contract'];
    }

    private void calculateOppForPeriod(List<Pipeline_Snapshot__c> snapshots) {
        System.debug('snapshots: ' + snapshots.size());
        List<Pipeline_Snapshot__c> toUpdate = new List<Pipeline_Snapshot__c>();
        try {
            Map<Id, Pipeline_Snapshot__c> oldSnapshots = SnapshotHelper.getOldSnapshotsForOpp(snapshots, forTotal);
            for (Pipeline_Snapshot__c sn : snapshots) {
                Pipeline_Snapshot__c oldSn = new Pipeline_Snapshot__c();
                if (sn.Opportunity__c != null && oldSnapshots.containsKey(sn.Opportunity__c)) {
                    oldSn = oldSnapshots.get(sn.Opportunity__c);
                }
                toUpdate.add(new Pipeline_Snapshot__c(Id = sn.Id, Buffer_EV_for_Period__c = (sn.Buffer_EV__c != null ? sn.Buffer_EV__c : 0) - (oldSn.Buffer_EV__c != null ? oldSn.Buffer_EV__c : 0)));
            }
            update toUpdate;
        } catch(Exception ex) {
            System.debug('ERROR:' + ex);
            if (!Test.isRunningTest()) {
                BatchDefaultSettings__c settings = BatchDefaultSettings__c.getOrgDefaults();
                EmailHelper.sendEmailFromException(settings.Error_Emails__c.split(','), 'Opp: For Period calculation error', 'Period calculation error', ex);
            }
        }
    }

    private List<Pipeline_Snapshot__c> getOppPS() {
        if (this.customDate == null) {
            if (this.forTotal == false) {
                return [SELECT Id, Buffer_EV__c, Buffer_EV_for_Period__c, Month_Date__c, Opportunity__c
                    FROM Pipeline_Snapshot__c WHERE CreatedDate >= YESTERDAY AND Stage__c != 'Total' AND Source_Type__c = 'Opportunity'];
            }
            return [SELECT Id, Buffer_EV__c, Buffer_EV_for_Period__c, Month_Date__c, Opportunity__c
                    FROM Pipeline_Snapshot__c WHERE CreatedDate >= YESTERDAY AND Stage__c = 'Total' AND Source_Type__c = 'Opportunity'];
        } else {
            if (this.forTotal == false) {
                return [SELECT Id, Buffer_EV__c, Buffer_EV_for_Period__c, Month_Date__c, Opportunity__c
                    FROM Pipeline_Snapshot__c WHERE Month_Date__c =: this.customDate AND Stage__c != 'Total' AND Source_Type__c = 'Opportunity'];
            }
            return [SELECT Id, Buffer_EV__c, Buffer_EV_for_Period__c, Month_Date__c, Opportunity__c
                    FROM Pipeline_Snapshot__c WHERE Month_Date__c =: this.customDate AND Stage__c = 'Total' AND Source_Type__c = 'Opportunity'];
        }

    }

}