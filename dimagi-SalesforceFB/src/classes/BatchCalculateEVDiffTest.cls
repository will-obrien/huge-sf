@isTest
public class BatchCalculateEVDiffTest {

    @isTest
    public static void testSnapshotTriggerForSingleRecord() {
        Account snapShotAccount = new Account(Name = 'Test Account');
        insert snapShotAccount;
        Account funderAccount = new Account(Name = 'Test Funder Account');
        insert funderAccount;
        Business_Unit__c bizUnit = new Business_Unit__c(Name = 'Test Business Unit 1');
        Opportunity currentOpp = new Opportunity(Name = 'Test Opportunity 1', Business_Unit_Owner__c = bizUnit.Id, StageName = 'Stage 5 - Submitted',
                                                 CloseDate = date.today().addMonths(5), Probability = 30);
        insert currentOpp;

        Pipeline_Snapshot__c snapShot1 = new Pipeline_Snapshot__c(Opportunity__c = currentOpp.Id, Opportunity_Amount_Minus_Expense_Income__c = 2000,
                                                                                Amount_Minus_Expense_Income__c = 2000, Probability__c = 100, Opportunity_Amount__c = 2000,
                                                                                Amount__c = 2000, Account__c = snapShotAccount.Id, Country__c = 'Test Country', Duration_months__c = 4,
                                                                                Funder_Account__c = funderAccount.Id, Month_Date__c = Date.newInstance(2016, 1, 12), Source_Type__c = 'Opportunity',
                                                                                Name = 'Test PS for date  ' + Date.newInstance(2016, 1, 12));

        insert snapShot1;
        Pipeline_Snapshot__c snapShot2 = new Pipeline_Snapshot__c(Opportunity__c = currentOpp.Id, Opportunity_Amount_Minus_Expense_Income__c = 2200,
                                                                                Amount_Minus_Expense_Income__c = 4000, Probability__c = 100, Opportunity_Amount__c = 2000,
                                                                                Amount__c = 2000, Account__c = snapShotAccount.Id, Country__c = 'Test Country', Duration_months__c = 4,
                                                                                Funder_Account__c = funderAccount.Id, Month_Date__c = Date.newInstance(2016, 2, 10), Source_Type__c = 'Opportunity',
                                                                                Name = 'Test PS for date  ' + Date.newInstance(2016, 2, 10));
        insert snapShot2;
        Pipeline_Snapshot__c snapShot3 = new Pipeline_Snapshot__c(Opportunity__c = currentOpp.Id, Opportunity_Amount_Minus_Expense_Income__c = 1900,
                                                                                Amount_Minus_Expense_Income__c = 2000, Probability__c = 100, Opportunity_Amount__c = 2000,
                                                                                Amount__c = 2000, Account__c = snapShotAccount.Id, Country__c = 'Test Country', Duration_months__c = 4,
                                                                                Funder_Account__c = funderAccount.Id, Month_Date__c = Date.newInstance(2016, 3, 7), Source_Type__c = 'Opportunity',
                                                                                Name = 'Test PS for date  ' + Date.newInstance(2016, 3, 7));
        insert snapShot3;

        currentOpp.StageName = 'Closed - Won';
        update currentOpp;

        Test.startTest();
        BatchCalculateEVDiff januaryBatch = new BatchCalculateEVDiff(Date.newInstance(2016, 1, 1));
        januaryBatch.execute(null, januaryBatch.start(null));
        BatchCalculateEVDiff febBatch = new BatchCalculateEVDiff(Date.newInstance(2016, 2, 1));
        febBatch.execute(null, febBatch.start(null));
        BatchCalculateEVDiff marchBatch = new BatchCalculateEVDiff(Date.newInstance(2016, 3, 1));
        marchBatch.execute(null, marchBatch.start(null));
        marchBatch.execute(null, marchBatch.start(null));
        NetEVDifferenceTriggerGateway.processPriorMonthSnapshotsWithClosedStatus(Date.newInstance(2016, 4, 14));
        Test.stopTest();

        List<Pipeline_Snapshot_EV_DIff__c> snapShotsEVDiffAll = [SELECT Delta_Type__c, DIFF_12_Month_Cash_Minus_Expense_Income__c, DIFF_18_Month_Cash_Minus_Expenses_Income__c,
                                                                 DIFF_24_Month_Cash_Minus_Expense_Income__c, DIFF_Amount_Minus_Expense_Income__c, DIFF_Expected_Value_Minus_Expense__c,
                                                                Month_Date__c, Opportunity_Name__c FROM Pipeline_Snapshot_EV_DIff__c ORDER BY Month_Date__c ASC];
        System.debug('snapShotsEVDiffAll: ' + snapShotsEVDiffAll);
        System.assert(snapShotsEVDiffAll.size() == 4);

        System.assertEquals(NetEVDifferenceTriggerGateway.NEW_OPP , snapShotsEVDiffAll.get(0).Delta_Type__c);
        System.assertEquals(NetEVDifferenceTriggerGateway.INCREASED , snapShotsEVDiffAll.get(1).Delta_Type__c);
        System.assertEquals(NetEVDifferenceTriggerGateway.DECREASED , snapShotsEVDiffAll.get(2).Delta_Type__c);
        System.assertEquals(NetEVDifferenceTriggerGateway.WON , snapShotsEVDiffAll.get(3).Delta_Type__c);
        System.assertEquals(Date.newInstance(2016, 4, 30) , snapShotsEVDiffAll.get(3).Month_Date__c);
    }

    @isTest
    public static void testSnapshotTriggerForMultipleRecords() {
        Account snapShotAccount = new Account(Name = 'Test Account');
        insert snapShotAccount;
        Account funderAccount = new Account(Name = 'Test Funder Account');
        insert funderAccount;
        Business_Unit__c bizUnit = new Business_Unit__c(Name = 'Test Business Unit 1');
        Opportunity currentOpp1 = new Opportunity(Name = 'Test Opportunity 1', Business_Unit_Owner__c = bizUnit.Id, StageName = 'Stage 5 - Submitted',
                                                 CloseDate = date.today().addMonths(5), Probability = 30);
        Opportunity currentOpp2 = new Opportunity(Name = 'Test Opportunity 2', Business_Unit_Owner__c = bizUnit.Id, StageName = 'Stage 5 - Submitted',
                                                 CloseDate = date.today().addMonths(5), Probability = 30);
        Opportunity currentOpp3 = new Opportunity(Name = 'Test Opportunity 3', Business_Unit_Owner__c = bizUnit.Id, StageName = 'Stage 5 - Submitted',
                                                 CloseDate = date.today().addMonths(5), Probability = 30);
        insert currentOpp1;
        insert currentOpp2;
        insert currentOpp3;

        Pipeline_Snapshot__c snapShot1_1 = new Pipeline_Snapshot__c(Opportunity__c = currentOpp1.Id, Opportunity_Amount_Minus_Expense_Income__c = 2200,
                                                                                Amount_Minus_Expense_Income__c = 2000, Probability__c = 100, Opportunity_Amount__c = 2000,
                                                                                Amount__c = 2000, Account__c = snapShotAccount.Id, Country__c = 'Test Country', Duration_months__c = 4,
                                                                                Funder_Account__c = funderAccount.Id, Month_Date__c = Date.newInstance(2016, 1, 12), Source_Type__c = 'Opportunity',
                                                                                Name = 'Test PS for date  ' + Date.newInstance(2016, 1, 31));
        Pipeline_Snapshot__c snapShot1_2 = new Pipeline_Snapshot__c(Opportunity__c = currentOpp2.Id, Opportunity_Amount_Minus_Expense_Income__c = 2200,
                                                                                Amount_Minus_Expense_Income__c = 2000, Probability__c = 100, Opportunity_Amount__c = 2000,
                                                                                Amount__c = 2000, Account__c = snapShotAccount.Id, Country__c = 'Test Country', Duration_months__c = 4,
                                                                                Funder_Account__c = funderAccount.Id, Month_Date__c = Date.newInstance(2016, 1, 12), Source_Type__c = 'Opportunity',
                                                                                Name = 'Test PS for date  ' + Date.newInstance(2016, 1, 22));
        Pipeline_Snapshot__c snapShot1_3 = new Pipeline_Snapshot__c(Opportunity__c = currentOpp3.Id, Opportunity_Amount_Minus_Expense_Income__c = 2200,
                                                                                Amount_Minus_Expense_Income__c = 2000, Probability__c = 100, Opportunity_Amount__c = 2000,
                                                                                Amount__c = 2000, Account__c = snapShotAccount.Id, Country__c = 'Test Country', Duration_months__c = 4,
                                                                                Funder_Account__c = funderAccount.Id, Month_Date__c = Date.newInstance(2016, 1, 12), Source_Type__c = 'Opportunity',
                                                                                Name = 'Test PS for date  ' + Date.newInstance(2016, 1, 11));

        List<Pipeline_Snapshot__c> snapshots_1 = new List<Pipeline_Snapshot__c>();
        snapshots_1.add(snapShot1_1);
        snapshots_1.add(snapShot1_2);
        snapshots_1.add(snapShot1_3);
        insert snapshots_1;

        Pipeline_Snapshot__c snapShot2_1 = new Pipeline_Snapshot__c(Opportunity__c = currentOpp1.Id, Opportunity_Amount_Minus_Expense_Income__c = 1000,
                                                                                Amount_Minus_Expense_Income__c = 2000, Probability__c = 45, Opportunity_Amount__c = 2000,
                                                                                Amount__c = 2000, Account__c = snapShotAccount.Id, Country__c = 'Test Country', Duration_months__c = 4,
                                                                                Funder_Account__c = funderAccount.Id, Month_Date__c = Date.newInstance(2016, 2, 10), Source_Type__c = 'Opportunity',
                                                                                Name = 'Test PS for date  ' + Date.newInstance(2016, 2, 10));
        Pipeline_Snapshot__c snapShot2_2 = new Pipeline_Snapshot__c(Opportunity__c = currentOpp2.Id, Opportunity_Amount_Minus_Expense_Income__c = 2200,
                                                                                Amount_Minus_Expense_Income__c = 2000, Probability__c = 100, Opportunity_Amount__c = 2000,
                                                                                Amount__c = 2000, Account__c = snapShotAccount.Id, Country__c = 'Test Country', Duration_months__c = 4,
                                                                                Funder_Account__c = funderAccount.Id, Month_Date__c = Date.newInstance(2016, 2, 10), Source_Type__c = 'Opportunity',
                                                                                Name = 'Test PS for date  ' + Date.newInstance(2016, 2, 10));
        Pipeline_Snapshot__c snapShot2_3 = new Pipeline_Snapshot__c(Opportunity__c = currentOpp3.Id, Opportunity_Amount_Minus_Expense_Income__c = 2400,
                                                                                Amount_Minus_Expense_Income__c = 4000, Probability__c = 100, Opportunity_Amount__c = 2000,
                                                                                Amount__c = 2000, Account__c = snapShotAccount.Id, Country__c = 'Test Country', Duration_months__c = 4,
                                                                                Funder_Account__c = funderAccount.Id, Month_Date__c = Date.newInstance(2016, 2, 10), Source_Type__c = 'Opportunity',
                                                                                Name = 'Test PS for date  ' + Date.newInstance(2016, 2, 10));

        List<Pipeline_Snapshot__c> snapshots_2 = new List<Pipeline_Snapshot__c>();
        snapshots_2.add(snapShot2_1);
        snapshots_2.add(snapShot2_2);
        snapshots_2.add(snapShot2_3);
        insert snapshots_2;

        currentOpp1.StageName = 'Closed - Lost';
        update currentOpp1;
        currentOpp2.StageName = 'Closed - Won';
        update currentOpp2;
        currentOpp3.StageName = 'Closed';
        update currentOpp3;

        Test.startTest();
        BatchCalculateEVDiff januaryBatch = new BatchCalculateEVDiff(Date.newInstance(2016, 1, 1));
        januaryBatch.execute(null, januaryBatch.start(null));
        BatchCalculateEVDiff febBatch = new BatchCalculateEVDiff(Date.newInstance(2016, 2, 1));
        febBatch.execute(null, febBatch.start(null));
        febBatch.execute(null, febBatch.start(null));
        BatchCalculateEVDiff marchBatch = new BatchCalculateEVDiff(Date.newInstance(2016, 3, 1));
        marchBatch.execute(null, marchBatch.start(null));
        marchBatch.execute(null, marchBatch.start(null));
        febBatch.execute(null, febBatch.start(null));
        NetEVDifferenceTriggerGateway.processPriorMonthSnapshotsWithClosedStatus(Date.newInstance(2016, 3, 25));
        Test.stopTest();

        List<Pipeline_Snapshot_EV_DIff__c> snapShotsEVDiffAll = [SELECT Delta_Type__c, DIFF_12_Month_Cash_Minus_Expense_Income__c, DIFF_18_Month_Cash_Minus_Expenses_Income__c,
                                                                 DIFF_24_Month_Cash_Minus_Expense_Income__c, DIFF_Amount_Minus_Expense_Income__c, DIFF_Expected_Value_Minus_Expense__c,
                                                                 Month_Date__c, Opportunity_Name__c FROM Pipeline_Snapshot_EV_DIff__c
                                                                 WHERE Opportunity_Name__c =: currentOpp1.Name ORDER BY Month_Date__c ASC];

        System.assert(snapShotsEVDiffAll.size() == 3);
        System.assertEquals(NetEVDifferenceTriggerGateway.NEW_OPP , snapShotsEVDiffAll.get(0).Delta_Type__c);
        System.assertEquals(NetEVDifferenceTriggerGateway.DECREASED , snapShotsEVDiffAll.get(1).Delta_Type__c);
        System.assertEquals(NetEVDifferenceTriggerGateway.LOST , snapShotsEVDiffAll.get(2).Delta_Type__c);
        System.assertEquals(Date.newInstance(2016, 3, 31) , snapShotsEVDiffAll.get(2).Month_Date__c);

        snapShotsEVDiffAll = [SELECT Delta_Type__c, DIFF_12_Month_Cash_Minus_Expense_Income__c, DIFF_18_Month_Cash_Minus_Expenses_Income__c,
                                                                 DIFF_24_Month_Cash_Minus_Expense_Income__c, DIFF_Amount_Minus_Expense_Income__c, DIFF_Expected_Value_Minus_Expense__c,
                                                                 Month_Date__c, Opportunity_Name__c FROM Pipeline_Snapshot_EV_DIff__c
                                                                 WHERE Opportunity_Name__c =: currentOpp2.Name ORDER BY Month_Date__c ASC];

        System.assert(snapShotsEVDiffAll.size() == 3);
        System.assertEquals(NetEVDifferenceTriggerGateway.NEW_OPP , snapShotsEVDiffAll.get(0).Delta_Type__c);
        System.assertEquals(NetEVDifferenceTriggerGateway.NO_CHANGE , snapShotsEVDiffAll.get(1).Delta_Type__c);
        System.assertEquals(NetEVDifferenceTriggerGateway.WON , snapShotsEVDiffAll.get(2).Delta_Type__c);
        System.assertEquals(Date.newInstance(2016, 3, 31) , snapShotsEVDiffAll.get(2).Month_Date__c);

        snapShotsEVDiffAll = [SELECT Delta_Type__c, DIFF_12_Month_Cash_Minus_Expense_Income__c, DIFF_18_Month_Cash_Minus_Expenses_Income__c,
                                                                 DIFF_24_Month_Cash_Minus_Expense_Income__c, DIFF_Amount_Minus_Expense_Income__c, DIFF_Expected_Value_Minus_Expense__c,
                                                                 Month_Date__c, Opportunity_Name__c FROM Pipeline_Snapshot_EV_DIff__c
                                                                 WHERE Opportunity_Name__c =: currentOpp3.Name ORDER BY Month_Date__c ASC];

        System.assert(snapShotsEVDiffAll.size() == 3);
        System.assertEquals(NetEVDifferenceTriggerGateway.NEW_OPP , snapShotsEVDiffAll.get(0).Delta_Type__c);
        System.assertEquals(NetEVDifferenceTriggerGateway.INCREASED , snapShotsEVDiffAll.get(1).Delta_Type__c);
        System.assertEquals(NetEVDifferenceTriggerGateway.LOST , snapShotsEVDiffAll.get(2).Delta_Type__c);
        System.assertEquals(Date.newInstance(2016, 3, 31) , snapShotsEVDiffAll.get(2).Month_Date__c);
    }

}