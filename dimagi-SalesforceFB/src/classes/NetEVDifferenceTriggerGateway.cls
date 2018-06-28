/**
 * Helper class for retrieving old Pipeline_Snapshot__c records to create NetEVDiff records.
 */
public class NetEVDifferenceTriggerGateway {

    public static final String NEW_OPP = 'New Opp EV';
    public static final String INCREASED = 'Increased EV';
    public static final String DECREASED = 'Decreased EV';
    public static final String NO_CHANGE = 'No Change';
    public static final String LOST = 'Closed Opp - Lost / No Go';
    public static final String WON = 'Closed Opp - Won';

    public NetEVDifferenceTriggerGateway() {}

    /**
     * Used by Pipeline_Snapshot__c trigger. Creates new NetDiff records for given snapshots from one month
     * (It creates only for NEW_OPP, INCREASED, DECREASED, NO_CHANGE other detla types are handled by batch job).
     */
    public void processLastMonthSnapshots(List<Pipeline_Snapshot__c> triggerSnapshots) {
        if (triggerSnapshots.size() == 0) {
            return;
        }
        Set<Id> opps = new Set<Id>();
        Date currentDate = triggerSnapshots[0].Month_Date__c;
        Date firstDate = currentDate.toStartOfMonth();
        Date lastDate = firstDate.addDays(Date.daysInMonth(currentDate.year() , currentDate.month())).addDays(-1);
        List<Pipeline_Snapshot__c> snapshots = new List<Pipeline_Snapshot__c>();
        // For now we don't want Total
        for(Pipeline_Snapshot__c snapshot : triggerSnapshots) {
            if (!String.isBlank(snapshot.Opportunity__c) && snapshot.Stage__c != 'Total') {
                opps.add(snapshot.Opportunity__c);
                snapshots.add(snapshot);
            }
        }

        Map<Id, Pipeline_Snapshot__c> priorMonthSnapshotRecords = getPriorMonthSnapshots(currentDate, opps);
        List<Pipeline_Snapshot_EV_DIff__c> snapShotDiffs = new List<Pipeline_Snapshot_EV_DIff__c>();
        List<Pipeline_Snapshot_EV_DIff__c> oldDiffs = [SELECT Id, Pipeline_Snapshot__c FROM Pipeline_Snapshot_EV_DIff__c WHERE Month_Date__c >=: firstDate
                            AND Month_Date__c <=: lastDate];
        Set<Id> pipelineSnapshotsToSkip = new Set<Id>();
        for (Pipeline_Snapshot_EV_DIff__c evDiff : oldDiffs) {
            pipelineSnapshotsToSkip.add(evDiff.Pipeline_Snapshot__c);
        }

        for (Pipeline_Snapshot__c lastMonthSnapshot : snapshots) {
            // We don't want duplicates for Snapshots
            if (pipelineSnapshotsToSkip.contains(lastMonthSnapshot.Id)) {
                continue;
            }

            Pipeline_Snapshot__c priorMonthSnapShot = priorMonthSnapshotRecords.get(lastMonthSnapshot.Opportunity__c);
            Pipeline_Snapshot_EV_DIff__c snapShotsDiff = new Pipeline_Snapshot_EV_DIff__c();
            snapShotsDiff.Name = lastMonthSnapshot.Name;
            snapShotsDiff.Month_Date__c = lastMonthSnapshot.Month_Date__c;
            snapShotsDiff.Pipeline_Snapshot__c = lastMonthSnapshot.Id;
            snapShotsDiff.Opportunity_Name__c = lastMonthSnapshot.Opportunity_Name__c;
            snapShotsDiff.Opportunity__c = lastMonthSnapshot.Opportunity__c;

            if (priorMonthSnapShot != null) {
                snapShotsDiff = calculateDiff(snapShotsDiff, lastMonthSnapshot, priorMonthSnapShot);
                snapShotsDiff.Delta_Type__c = getDeltaType(snapShotsDiff);
            } else {
                snapShotsDiff.Delta_Type__c = NEW_OPP;
                snapShotsDiff.DIFF_12_Month_Cash_Minus_Expense_Income__c = lastMonthSnapshot.X12_Month_Cash_Minus_Expense_Income_EV__c != null ? lastMonthSnapshot.X12_Month_Cash_Minus_Expense_Income_EV__c: 0;
                snapShotsDiff.DIFF_18_Month_Cash_Minus_Expenses_Income__c = lastMonthSnapshot.X18_Month_Cash_Minus_Expenses_Income_EV__c != null ?  lastMonthSnapshot.X18_Month_Cash_Minus_Expenses_Income_EV__c: 0;
                snapShotsDiff.DIFF_24_Month_Cash_Minus_Expense_Income__c = lastMonthSnapshot.X24_Month_Cash_Minus_Expense_Income_EV__c != null ? lastMonthSnapshot.X24_Month_Cash_Minus_Expense_Income_EV__c: 0;
                snapShotsDiff.DIFF_Amount_Minus_Expense_Income__c = lastMonthSnapshot.Opportunity_Amount_Minus_Expense_Income__c != null ? lastMonthSnapshot.Opportunity_Amount_Minus_Expense_Income__c: 0;
                snapShotsDiff.DIFF_Expected_Value_Minus_Expense__c = lastMonthSnapshot.Expected_Value_Minus_Expense__c != null ? lastMonthSnapshot.Expected_Value_Minus_Expense__c: 0;
                snapShotsDiff.Monthly_Recurring_Revenue_MRR__c = lastMonthSnapshot.Monthly_Recurring_Revenue_MRR__c != null ? lastMonthSnapshot.Monthly_Recurring_Revenue_MRR__c: 0;
                snapShotsDiff.Expected_Monthly_Recurring_Revenue_MRR__c = lastMonthSnapshot.Expected_Monthly_Recurring_Revenue_MRR__c != null ? lastMonthSnapshot.Expected_Monthly_Recurring_Revenue_MRR__c: 0;
            }

            snapShotDiffs.add(snapShotsDiff);
        }

        if (snapShotDiffs.size() > 0) {
            insert snapShotDiffs;
        }
    }

    @future
    public static void processPriorMonthSnapshotsWithClosedStatus(Date executeDate) {
        Date currentDate = executeDate;
        Date firstDate = currentDate.toStartOfMonth();
        currentDate = firstDate.addDays(date.daysInMonth(currentDate.year() , currentDate.month())).addDays(-1);

        List<Pipeline_Snapshot__c> records = [SELECT Id, Name, Opportunity__c, Opportunity__r.StageName,
                            Month_Date__c, Amount_Minus_Expense_Income__c, Opportunity_Name__c,
                            X12_Month_Cash_Minus_Expense_Income_EV__c ,
                            X18_Month_Cash_Minus_Expenses_Income_EV__c,
                            X24_Month_Cash_Minus_Expense_Income_EV__c,
                            Opportunity_Amount_Minus_Expense_Income__c,
                            Expected_Value_Minus_Expense__c,
                            Stage__c, Monthly_Recurring_Revenue_MRR__c,
                            Expected_Monthly_Recurring_Revenue_MRR__c
                            FROM Pipeline_Snapshot__c
                            WHERE Month_Date__c >=: firstDate
                            AND Month_Date__c <=: currentDate
                            AND Source_Type__c = 'Opportunity'
                            AND Stage__c != 'Total'];

        Map<Id, Pipeline_Snapshot__c> priorMonthSnapshotRecords = getPriorMonthSnapshotsForDate(firstDate);
        for (Pipeline_Snapshot__c snapshot : records) {
            if (!String.isBlank(snapshot.Opportunity__c) && priorMonthSnapshotRecords.containsKey(snapshot.Opportunity__c)) {
                priorMonthSnapshotRecords.remove(snapshot.Opportunity__c);
            }
        }

        List<Pipeline_Snapshot_EV_DIff__c> snapShotDiffs = new List<Pipeline_Snapshot_EV_DIff__c>();

        for (Pipeline_Snapshot__c snapshot : priorMonthSnapshotRecords.values()) {
            Pipeline_Snapshot_EV_DIff__c snapShotsDiff = new Pipeline_Snapshot_EV_DIff__c();
            String nameSuffix = ' - ' + currentDate.month() + '/' + currentDate.year();
            String namePrefix = snapshot.Opportunity_Name__c;

            if (namePrefix != null && namePrefix.length() + nameSuffix.length() > 80) {
                Integer charsToCut = namePrefix.length() - (namePrefix.length() + nameSuffix.length() - 80);
                namePrefix = namePrefix.subString(0, charsToCut);
            }

            snapShotsDiff.Name = namePrefix + nameSuffix;
            snapShotsDiff.Opportunity_Name__c = snapshot.Opportunity_Name__c;
            snapShotsDiff.Opportunity__c = snapshot.Opportunity__c;
            snapShotsDiff.Month_Date__c = currentDate;

            snapShotsDiff.Pipeline_Snapshot__c = snapshot.Id;

            snapShotsDiff.DIFF_12_Month_Cash_Minus_Expense_Income__c = (snapshot.Opportunity__r.X12Month_Cash_Minus_Expenses_EV__c != null ? snapshot.Opportunity__r.X12Month_Cash_Minus_Expenses_EV__c : 0)
                                     - (snapshot.X12_Month_Cash_Minus_Expense_Income_EV__c != null ? snapshot.X12_Month_Cash_Minus_Expense_Income_EV__c : 0);
            snapShotsDiff.DIFF_18_Month_Cash_Minus_Expenses_Income__c = (snapshot.Opportunity__r.X18_Month_Cash_Minus_Expenses_EV__c != null ? snapshot.Opportunity__r.X18_Month_Cash_Minus_Expenses_EV__c : 0)
                                     - (snapshot.X18_Month_Cash_Minus_Expenses_Income_EV__c != null ? snapshot.X18_Month_Cash_Minus_Expenses_Income_EV__c : 0);
            snapShotsDiff.DIFF_24_Month_Cash_Minus_Expense_Income__c = (snapshot.Opportunity__r.X24_Month_Cash_Minus_Expense_EV__c != null ? snapshot.Opportunity__r.X24_Month_Cash_Minus_Expense_EV__c : 0)
                                     - (snapshot.X24_Month_Cash_Minus_Expense_Income_EV__c != null ? snapshot.X24_Month_Cash_Minus_Expense_Income_EV__c : 0);
            snapShotsDiff.DIFF_Amount_Minus_Expense_Income__c = (snapshot.Opportunity__r.Amount_Minus_Expense_Income__c != null ? snapshot.Opportunity__r.Amount_Minus_Expense_Income__c : 0 )
                                     - (snapshot.Opportunity_Amount_Minus_Expense_Income__c != null ? snapshot.Opportunity_Amount_Minus_Expense_Income__c : 0);
            snapShotsDiff.DIFF_Expected_Value_Minus_Expense__c = (snapshot.Opportunity__r.Expected_Value_Minus_Income__c != null ? snapshot.Opportunity__r.Expected_Value_Minus_Income__c : 0)
                                     - (snapshot.Expected_Value_Minus_Expense__c != null ? snapshot.Expected_Value_Minus_Expense__c : 0);
            snapShotsDiff.Expected_Monthly_Recurring_Revenue_MRR__c = (snapshot.Opportunity__r.Expected_Monthly_Recurring_Revenue_MRR__c != null ? snapshot.Opportunity__r.Expected_Monthly_Recurring_Revenue_MRR__c : 0)
                                     - (snapshot.Expected_Monthly_Recurring_Revenue_MRR__c != null ? snapshot.Expected_Monthly_Recurring_Revenue_MRR__c : 0);
            snapShotsDiff.Monthly_Recurring_Revenue_MRR__c = (snapshot.Opportunity__r.Monthly_Recurring_Revenue_MRR__c != null ? snapshot.Opportunity__r.Monthly_Recurring_Revenue_MRR__c : 0)
                                     - (snapshot.Monthly_Recurring_Revenue_MRR__c != null ? snapshot.Monthly_Recurring_Revenue_MRR__c : 0);
            snapShotsDiff.Prior_Snapshot_date__c = snapshot.Month_Date__c;

            if(snapshot.Opportunity__r.StageName == 'Closed - Won') {
                snapShotsDiff.Delta_Type__c = WON;
                snapShotDiffs.add(snapShotsDiff);
            } else {
                snapShotsDiff.Delta_Type__c = LOST;
                snapShotDiffs.add(snapShotsDiff);
            }
        }

        if (snapShotDiffs.size() > 0) {
            insert snapShotDiffs;
        }
    }

    /**
     * Returns prior month snapshots for given date and Opportunity set.
     */
    public Map<Id, Pipeline_Snapshot__c> getPriorMonthSnapshots(Date currentDate, Set<Id> opps) {
        Date prevMonthDate = currentDate.addMonths(-1);
        Date firstDate = prevMonthDate.toStartOfMonth();
        Date lastDate = firstDate.addDays(date.daysInMonth(prevMonthDate.year() , prevMonthDate.month())).addDays(-1);

        List<Pipeline_Snapshot__c> lastMonthSnapShotsList = [SELECT Name, Opportunity__c, Opportunity__r.StageName,
                                                   Month_Date__c, Amount_Minus_Expense_Income__c, Opportunity_Name__c,
                                                   X12_Month_Cash_Minus_Expense_Income_EV__c ,
                                                   X18_Month_Cash_Minus_Expenses_Income_EV__c,
                                                   X24_Month_Cash_Minus_Expense_Income_EV__c,
                                                   Opportunity_Amount_Minus_Expense_Income__c,
                                                   Expected_Value_Minus_Expense__c, Monthly_Recurring_Revenue_MRR__c,
                                                   Expected_Monthly_Recurring_Revenue_MRR__c
                                                   FROM Pipeline_Snapshot__c
                                                   WHERE Month_Date__c >= :firstDate AND Month_Date__c <= :lastDate
                                                   AND Opportunity__c in :opps AND Stage__c != 'Total'];

        Map<Id, Pipeline_Snapshot__c> lastMonthSnapShotsMap = new Map<Id, Pipeline_Snapshot__c>();
        for(Pipeline_Snapshot__c snapshotObject : lastMonthSnapShotsList) {
            lastMonthSnapShotsMap.put(snapshotObject.Opportunity__c, snapshotObject);
        }

        return lastMonthSnapShotsMap;
    }

    /**
     * Returns prior month snapshots for given date.
     */
    public static Map<Id, Pipeline_Snapshot__c> getPriorMonthSnapshotsForDate(Date currentDate) {
        Date prevMonthDate = currentDate.addMonths(-1);
        Date firstDate = prevMonthDate.toStartOfMonth();
        Date lastDate = firstDate.addDays(date.daysInMonth(prevMonthDate.year() , prevMonthDate.month())).addDays(-1);

        List<Pipeline_Snapshot__c> lastMonthSnapShotsList = [SELECT Name, Opportunity__c, Opportunity__r.StageName,
                Month_Date__c, Amount_Minus_Expense_Income__c, Opportunity_Name__c,
                X12_Month_Cash_Minus_Expense_Income_EV__c ,
                X18_Month_Cash_Minus_Expenses_Income_EV__c,
                X24_Month_Cash_Minus_Expense_Income_EV__c,
                Opportunity_Amount_Minus_Expense_Income__c,
                Expected_Value_Minus_Expense__c, Monthly_Recurring_Revenue_MRR__c,
                Expected_Monthly_Recurring_Revenue_MRR__c,
                Opportunity__r.X12Month_Cash_Minus_Expenses_EV__c,
                Opportunity__r.X18_Month_Cash_Minus_Expenses_EV__c,
                Opportunity__r.X24_Month_Cash_Minus_Expense_EV__c,
                Opportunity__r.Amount_Minus_Expense_Income__c,
                Opportunity__r.Expected_Value_Minus_Income__c,
                Opportunity__r.Expected_Monthly_Recurring_Revenue_MRR__c,
                Opportunity__r.Monthly_Recurring_Revenue_MRR__c
                FROM Pipeline_Snapshot__c
                WHERE Month_Date__c >= :firstDate AND Month_Date__c <= :lastDate
                AND Source_Type__c = 'Opportunity'
                AND Opportunity__c != null
                AND Stage__c != 'Total'];

        Map<Id, Pipeline_Snapshot__c> lastMonthSnapShotsMap = new Map<Id, Pipeline_Snapshot__c>();
        for(Pipeline_Snapshot__c snapshotObject : lastMonthSnapShotsList) {
            lastMonthSnapShotsMap.put(snapshotObject.Opportunity__c, snapshotObject);
        }

        return lastMonthSnapShotsMap;
    }

    public Pipeline_Snapshot_EV_DIff__c calculateDiff(Pipeline_Snapshot_EV_DIff__c diff, Pipeline_Snapshot__c lastSnapshot, Pipeline_Snapshot__c priorSnapshot) {
        diff.DIFF_12_Month_Cash_Minus_Expense_Income__c = (lastSnapshot.X12_Month_Cash_Minus_Expense_Income_EV__c != null ? lastSnapshot.X12_Month_Cash_Minus_Expense_Income_EV__c : 0) - (priorSnapshot.X12_Month_Cash_Minus_Expense_Income_EV__c != null ? priorSnapshot.X12_Month_Cash_Minus_Expense_Income_EV__c : 0);
        diff.DIFF_18_Month_Cash_Minus_Expenses_Income__c = (lastSnapshot.X18_Month_Cash_Minus_Expenses_Income_EV__c != null ? lastSnapshot.X18_Month_Cash_Minus_Expenses_Income_EV__c : 0) - (priorSnapshot.X18_Month_Cash_Minus_Expenses_Income_EV__c != null ? priorSnapshot.X18_Month_Cash_Minus_Expenses_Income_EV__c : 0);
        diff.DIFF_24_Month_Cash_Minus_Expense_Income__c = (lastSnapshot.X24_Month_Cash_Minus_Expense_Income_EV__c != null ? lastSnapshot.X24_Month_Cash_Minus_Expense_Income_EV__c : 0) - (priorSnapshot.X24_Month_Cash_Minus_Expense_Income_EV__c != null ? priorSnapshot.X24_Month_Cash_Minus_Expense_Income_EV__c : 0);
        diff.DIFF_Amount_Minus_Expense_Income__c = (lastSnapshot.Opportunity_Amount_Minus_Expense_Income__c != null ? lastSnapshot.Opportunity_Amount_Minus_Expense_Income__c : 0) - (priorSnapshot.Opportunity_Amount_Minus_Expense_Income__c != null ? priorSnapshot.Opportunity_Amount_Minus_Expense_Income__c : 0);
        diff.DIFF_Expected_Value_Minus_Expense__c = (lastSnapshot.Expected_Value_Minus_Expense__c != null ? lastSnapshot.Expected_Value_Minus_Expense__c : 0) - (priorSnapshot.Expected_Value_Minus_Expense__c != null ? priorSnapshot.Expected_Value_Minus_Expense__c : 0);
        diff.Prior_Snapshot_date__c = priorSnapshot.Month_Date__c;
        diff.Monthly_Recurring_Revenue_MRR__c = (lastSnapshot.Monthly_Recurring_Revenue_MRR__c != null ? lastSnapshot.Monthly_Recurring_Revenue_MRR__c : 0) - (priorSnapshot.Monthly_Recurring_Revenue_MRR__c != null ? priorSnapshot.Monthly_Recurring_Revenue_MRR__c : 0);
        diff.Expected_Monthly_Recurring_Revenue_MRR__c = (lastSnapshot.Expected_Monthly_Recurring_Revenue_MRR__c != null ? lastSnapshot.Expected_Monthly_Recurring_Revenue_MRR__c : 0) - (priorSnapshot.Expected_Monthly_Recurring_Revenue_MRR__c != null ? priorSnapshot.Expected_Monthly_Recurring_Revenue_MRR__c : 0);

        return diff;
    }

    public String getDeltaType(Pipeline_Snapshot_EV_DIff__c diffObj) {
        Decimal diff = diffObj.DIFF_Expected_Value_Minus_Expense__c;
        if(diff > 0) {
            return INCREASED;
        } else if(diff < 0) {
            return DECREASED;
        }
        return NO_CHANGE;
    }
}