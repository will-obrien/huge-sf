@isTest
public class ContractSnapshotTest {

    static testMethod void shouldCreateSnapshotAfterSubmitingPRO() {
        ProjectReportOutController projectReportOutController = new ProjectReportOutController();

        projectReportOutController.pro = new Project_Report_Out__c();
        projectReportOutController.pro.PM_email__c = 'tomek.stalka@gmail.com';
        projectReportOutController.pro.Report_Out_Date__c = Date.today();

        DContract__c dcontract = addContract();

        projectReportOutController.reportContractId = dcontract.Id;
        projectReportOutController.contractIdName = new Map<Id, DContract__C> {};
        projectReportOutController.contractIdName.put(dcontract.Id, dcontract);
        projectReportOutController.status = 'Active';
        projectReportOutController.toMeetSchedule = 'Green';
        projectReportOutController.stayWithinScope = 'Green';
        projectReportOutController.currentSystemUsage = 'Green';
        projectReportOutController.partnerRelationship = 'Green';
        projectReportOutController.proTabContractPercntgethroughSOW = 30;

        projectReportOutController.save();

        List<PRO_Contract_Snapshot__c> snapshots = [SELECT Id, Name, Percent_Of_Work_Completed__c, Percent_Services_Budget_For_GS__c, Expected_Buffer__c,
                                                        Expense_And_Travel_Spend__c, Services_Spend__c, Total_Calculated_Costs__c, Product_Spend2__c, Net_Income_By_Deliverables_Complete__c,
                                                        Execution_Efficiency__c, Buffer_By_Deliverables_Complete__c, Budget_Used__c
                                                        FROM PRO_Contract_Snapshot__c WHERE Contract__c =: dcontract.Id];

        System.assertEquals(1, snapshots.size());
        PRO_Contract_Snapshot__c snapshot = snapshots.get(0);

        assertSnapshotData(snapshot);
    }

    static testMethod void jobShouldCreateSnapshotForActiveProject() {
        DContract__c dcontract = addContract();

        PRO_Contract_Snapshot__c proSn1 = new PRO_Contract_Snapshot__c(Contract__c = dcontract.Id, Percent_Of_Work_Completed__c = 4, Snapshot_Date__c = Date.today().addDays(-40));
        insert proSn1;
        PRO_Contract_Snapshot__c proSn2 = new PRO_Contract_Snapshot__c(Contract__c = dcontract.Id, Percent_Of_Work_Completed__c = 11, Snapshot_Date__c = Date.today().addDays(-20));
        insert proSn2;

        PROContractSnapshotBatch proContractSnapshotBatch = new PROContractSnapshotBatch();
        Database.BatchableContext bc;
        proContractSnapshotBatch.execute(bc, proContractSnapshotBatch.start(bc));


        List<PRO_Contract_Snapshot__c> snapshots = [SELECT Id, Name, Percent_Of_Work_Completed__c, Percent_Services_Budget_For_GS__c, Expected_Buffer__c,
                                                Expense_And_Travel_Spend__c, Services_Spend__c, Total_Calculated_Costs__c, Product_Spend2__c, Net_Income_By_Deliverables_Complete__c,
                                                Execution_Efficiency__c, Buffer_By_Deliverables_Complete__c, Budget_Used__c, Work_Completed_for_Period__c
                                                FROM PRO_Contract_Snapshot__c WHERE Contract__c =: dcontract.Id AND Id !=: proSn1.Id AND Id !=: proSn2.Id];

        System.assertEquals(1, snapshots.size());
        PRO_Contract_Snapshot__c snapshot = snapshots.get(0);

        assertSnapshotData(snapshot);
        System.assertEquals(19, snapshot.Work_Completed_for_Period__c);
    }

    static testMethod void shouldCalculateForPeriodInPipelineSnapshot() {
        DContract__c dcontract1 = new DContract__c(Name = 'Sample Test 1', Services_Spend__c = 100, Total_Amount_of_Contract__c = 1000);
        DContract__c dcontract2 = new DContract__c(Name = 'Sample Test 2', Services_Spend__c = 155, Total_Amount_of_Contract__c = 5500);
        DContract__c dcontract3 = new DContract__c(Name = 'Sample Test 3', Services_Spend__c = 23, Total_Amount_of_Contract__c = 222);
        insert dcontract1;
        insert dcontract2;
        insert dcontract3;

        Pipeline_Snapshot__c ps1 = new Pipeline_Snapshot__c(Source_Type__c = 'Contract', Month_Date__c = Date.today().addDays(-10), Contract__c = dcontract1.Id, Services_Spend__c = 10);
        Pipeline_Snapshot__c ps2 = new Pipeline_Snapshot__c(Source_Type__c = 'Contract', Month_Date__c = Date.today(), Contract__c = dcontract1.Id, Services_Spend__c = 76);
        Pipeline_Snapshot__c ps3 = new Pipeline_Snapshot__c(Source_Type__c = 'Contract', Month_Date__c = Date.today(), Contract__c = dcontract3.Id, Services_Spend__c = 100);
        Pipeline_Snapshot__c ps4 = new Pipeline_Snapshot__c(Source_Type__c = 'Contract', Month_Date__c = Date.today().addDays(-50), Contract__c = dcontract2.Id, Services_Spend__c = 1);
        Pipeline_Snapshot__c ps5 = new Pipeline_Snapshot__c(Source_Type__c = 'Contract', Month_Date__c = Date.today().addDays(-30), Contract__c = dcontract2.Id, Services_Spend__c = 8);
        Pipeline_Snapshot__c ps6 = new Pipeline_Snapshot__c(Source_Type__c = 'Contract', Month_Date__c = Date.today(), Contract__c = dcontract2.Id, Services_Spend__c = 11);
        insert ps1;
        insert ps2;
        insert ps3;
        insert ps4;
        insert ps5;
        insert ps6;
        Test.setCreatedDate(ps1.Id, DateTime.now().addDays(-6));
        Test.setCreatedDate(ps4.Id, DateTime.now().addDays(-6));
        Test.setCreatedDate(ps5.Id, DateTime.now().addDays(-6));

        Test.startTest();
        Database.executeBatch(new ForPeriodCalcSnapshotBatch(false), 50);
        Test.stopTest();

        Pipeline_Snapshot__c psFromDB = [SELECT Id, Services_Spend_for_Period__c FROM Pipeline_Snapshot__c WHERE Id =: ps2.Id];
        System.assertEquals(66, psFromDB.Services_Spend_for_Period__c);
        psFromDB = [SELECT Id, Services_Spend_for_Period__c FROM Pipeline_Snapshot__c WHERE Id =: ps4.Id];
        System.assertEquals(null, psFromDB.Services_Spend_for_Period__c);
        psFromDB = [SELECT Id, Services_Spend_for_Period__c FROM Pipeline_Snapshot__c WHERE Id =: ps6.Id];
        System.assertEquals(3, psFromDB.Services_Spend_for_Period__c);
    }

    static testMethod void shouldCalculateForPeriodInPipelineSnapshotOpp() {
        Business_Unit__c bizUnit = new Business_Unit__c(Name = 'Test Business Unit 1');
        //insert bizUnit;
        Opportunity opp1 = new Opportunity(Name = 'Test Opportunity 1', Business_Unit_Owner__c = bizUnit.Id, StageName = 'Stage 5 - Submitted',
                                                 CloseDate = date.today().addMonths(5), Probability = 30);
        Opportunity opp2 = new Opportunity(Name = 'Test Opportunity 2', Business_Unit_Owner__c = bizUnit.Id, StageName = 'Stage 5 - Submitted',
                                                 CloseDate = date.today().addMonths(5), Probability = 30);

        insert opp1;
        insert opp2;

        Pipeline_Snapshot__c ps1 = new Pipeline_Snapshot__c(Source_Type__c = 'Opportunity', Month_Date__c = Date.today().addDays(-30), Opportunity__c = opp1.Id,
                                                            Probability__c = 20, Expected_Buffer__c = 60, Amount_Minus_Expense_Income__c = 10000);
        Pipeline_Snapshot__c ps2 = new Pipeline_Snapshot__c(Source_Type__c = 'Opportunity', Month_Date__c = Date.today(), Opportunity__c = opp1.Id,
                                                            Probability__c = 40, Expected_Buffer__c = 80, Amount_Minus_Expense_Income__c = 10000);
        Pipeline_Snapshot__c ps3 = new Pipeline_Snapshot__c(Source_Type__c = 'Opportunity', Month_Date__c = Date.today(), Opportunity__c = opp2.Id,
                                                            Probability__c = 50, Expected_Buffer__c = 70, Amount_Minus_Expense_Income__c = 10000);

        insert ps1;
        insert ps2;
        insert ps3;

        Test.setCreatedDate(ps1.Id, DateTime.now().addDays(-30));

        Test.startTest();
        Database.executeBatch(new ForPeriodCalcSnapshotBatch(false, true), 50);
        Test.stopTest();

        // 80% * (10000 * 40%) - 60% * (10000 * 20%) = 2000
        Pipeline_Snapshot__c psFromDB = [SELECT Id, Probability__c, Expected_Buffer__c, Amount_Minus_Expense_Income__c, Buffer_EV_for_Period__c
                                         FROM Pipeline_Snapshot__c WHERE Id =: ps2.Id];
        System.debug('Value : ' + psFromDB.Expected_Buffer__c * (psFromDB.Amount_Minus_Expense_Income__c * psFromDB.Probability__c));
        System.assertEquals(2000, psFromDB.Buffer_EV_for_Period__c);
        psFromDB = [SELECT Id, Buffer_EV_for_Period__c FROM Pipeline_Snapshot__c WHERE Id =: ps3.Id];
        System.assertEquals(3500, psFromDB.Buffer_EV_for_Period__c);
    }

    static testMethod void shouldCalculateGSRevenue() {
        Business_Unit__c bu = new Business_Unit__c(Name = 'Inc');
        insert bu;

        DContract__c dcontract1 = new DContract__c(Name = 'Sample Test 1', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 10, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 1000); // 5
        DContract__c dcontract2 = new DContract__c(Name = 'Sample Test 2', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 20, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 2000); // 30
        DContract__c dcontract3 = new DContract__c(Name = 'Sample Test 3', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 30, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 3000); // 22
        DContract__c dcontract4 = new DContract__c(Name = 'Sample Test 4', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 40, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 4000); // 40
        insert dcontract1;
        insert dcontract2;
        insert dcontract3;
        insert dcontract4;

        PRO_Contract_Snapshot__c proS1 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, GS_Project_Services_Budget_Handoff_Cp__c = 1000, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                Work_Completed_for_Period__c = 5, GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 2, 9));
        PRO_Contract_Snapshot__c proS2 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, GS_Project_Services_Budget_Handoff_Cp__c = 1000, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                Work_Completed_for_Period__c = 5, GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 2, 23));
        PRO_Contract_Snapshot__c proS3 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, GS_Project_Services_Budget_Handoff_Cp__c = 1000, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                Work_Completed_for_Period__c = 5, GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 3, 9));
        PRO_Contract_Snapshot__c proS4 = new PRO_Contract_Snapshot__c(Contract__c = dcontract2.Id, GS_Project_Services_Budget_Handoff_Cp__c = 1000, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                Work_Completed_for_Period__c = 5, GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 2, 9));
        PRO_Contract_Snapshot__c proS5 = new PRO_Contract_Snapshot__c(Contract__c = dcontract2.Id, GS_Project_Services_Budget_Handoff_Cp__c = 1000, Project_Quality_Overall_Status__c = 444, Customer_Satisfaction_of_services__c = 223,
                                                                Work_Completed_for_Period__c = 3, GS_Execution_Budget__c = 1367, Snapshot_Date__c = Date.newInstance(2017, 2, 23));
        PRO_Contract_Snapshot__c proS6 = new PRO_Contract_Snapshot__c(Contract__c = dcontract3.Id, GS_Project_Services_Budget_Handoff_Cp__c = 1000, Project_Quality_Overall_Status__c = 678, Customer_Satisfaction_of_services__c = 900,
                                                                Work_Completed_for_Period__c = 7, GS_Execution_Budget__c = 1333, Snapshot_Date__c = Date.newInstance(2017, 2, 23));
        PRO_Contract_Snapshot__c proS7 = new PRO_Contract_Snapshot__c(Contract__c = dcontract3.Id, GS_Project_Services_Budget_Handoff_Cp__c = 1000, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                Work_Completed_for_Period__c = 7, GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 3, 9));
        PRO_Contract_Snapshot__c proS8 = new PRO_Contract_Snapshot__c(Contract__c = dcontract4.Id, GS_Project_Services_Budget_Handoff_Cp__c = 1000, Project_Quality_Overall_Status__c = 543, Customer_Satisfaction_of_services__c = 776,
                                                                Work_Completed_for_Period__c = 15, GS_Execution_Budget__c = 4567, Snapshot_Date__c = Date.newInstance(2017, 2, 23));

        insert proS1;
        insert proS2;
        insert proS3;
        insert proS4;
        insert proS5;
        insert proS6;
        insert proS7;
        insert proS8;

        Test.startTest();
        Database.executeBatch(new GSOverallCalculationBatch(Date.newInstance(2017, 3, 8)));
        Test.stopTest();

        Contract_Statistic__c proDromDB = [SELECT Id, Inc_GS_Revenue__c FROM Contract_Statistic__c LIMIT 1];
        Decimal value = proDromDB.Inc_GS_Revenue__c;
        System.assertEquals(300.00, value.setScale(2));
    }

    static testMethod void shouldCalculateGSQualitySituation1() {
        Business_Unit__c bu = new Business_Unit__c(Name = 'Inc');
        insert bu;
        DContract__c dcontract1 = new DContract__c(Name = 'Sample Test 1', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 10, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 1000);
        DContract__c dcontract2 = new DContract__c(Name = 'Sample Test 2', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 20, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 2000);
        DContract__c dcontract3 = new DContract__c(Name = 'Sample Test 3', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 30, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 3000);
        DContract__c dcontract4 = new DContract__c(Name = 'Sample Test 4', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 40, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 4000);
        insert dcontract1;
        insert dcontract2;
        insert dcontract3;
        insert dcontract4;

        PRO_Contract_Snapshot__c proS1 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 2, 9));
        PRO_Contract_Snapshot__c proS2 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 2, 23));
        PRO_Contract_Snapshot__c proS3 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 3, 9));
        PRO_Contract_Snapshot__c proS4 = new PRO_Contract_Snapshot__c(Contract__c = dcontract2.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 2, 9));
        PRO_Contract_Snapshot__c proS5 = new PRO_Contract_Snapshot__c(Contract__c = dcontract2.Id, Project_Quality_Overall_Status__c = 444, Customer_Satisfaction_of_services__c = 223,
                                                                GS_Execution_Budget__c = 1367, Snapshot_Date__c = Date.newInstance(2017, 2, 23));
        PRO_Contract_Snapshot__c proS6 = new PRO_Contract_Snapshot__c(Contract__c = dcontract3.Id, Project_Quality_Overall_Status__c = 678, Customer_Satisfaction_of_services__c = 900,
                                                                GS_Execution_Budget__c = 1333, Snapshot_Date__c = Date.newInstance(2017, 2, 23));
        PRO_Contract_Snapshot__c proS7 = new PRO_Contract_Snapshot__c(Contract__c = dcontract3.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 3, 9));
        PRO_Contract_Snapshot__c proS8 = new PRO_Contract_Snapshot__c(Contract__c = dcontract4.Id, Project_Quality_Overall_Status__c = 543, Customer_Satisfaction_of_services__c = 776,
                                                                GS_Execution_Budget__c = 4567, Snapshot_Date__c = Date.newInstance(2017, 2, 23));
        insert proS1;
        insert proS2;
        insert proS3;
        insert proS4;
        insert proS5;
        insert proS6;
        insert proS7;
        insert proS8;

        Project_Report_Out__c pro1 = new Project_Report_Out__c(Contract__c = dcontract1.Id, Contract_Snapshot__c = proS1.Id, Report_Out_Date__c = Date.newInstance(2017, 2, 9));
        Project_Report_Out__c pro2 = new Project_Report_Out__c(Contract__c = dcontract1.Id, Contract_Snapshot__c = proS2.Id, Report_Out_Date__c = Date.newInstance(2017, 2, 23));
        Project_Report_Out__c pro3 = new Project_Report_Out__c(Contract__c = dcontract1.Id, Contract_Snapshot__c = proS3.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 9));

        Project_Report_Out__c pro4 = new Project_Report_Out__c(Contract__c = dcontract2.Id, Contract_Snapshot__c = proS4.Id, Report_Out_Date__c = Date.newInstance(2017, 2, 9));
        Project_Report_Out__c pro5 = new Project_Report_Out__c(Contract__c = dcontract2.Id, Contract_Snapshot__c = proS5.Id, Report_Out_Date__c = Date.newInstance(2017, 2, 23));

        Project_Report_Out__c pro6 = new Project_Report_Out__c(Contract__c = dcontract3.Id, Contract_Snapshot__c = proS6.Id, Report_Out_Date__c = Date.newInstance(2017, 2, 23));
        Project_Report_Out__c pro7 = new Project_Report_Out__c(Contract__c = dcontract3.Id, Contract_Snapshot__c = proS7.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 9));

        Project_Report_Out__c pro8 = new Project_Report_Out__c(Contract__c = dcontract4.Id, Contract_Snapshot__c = proS8.Id, Report_Out_Date__c = Date.newInstance(2017, 2, 23));

        insert pro1;
        insert pro2;
        insert pro3;
        insert pro4;
        insert pro5;
        insert pro6;
        insert pro7;
        insert pro8;

        Test.startTest();
        Database.executeBatch(new GSOverallCalculationBatch(Date.newInstance(2017, 3, 8)));
        Test.stopTest();

        Contract_Statistic__c proDromDB = [SELECT Id, Inc_GS_Customer_Sat__c, Inc_GS_Overall_Status__c FROM Contract_Statistic__c LIMIT 1];
        Decimal value = proDromDB.Inc_GS_Overall_Status__c;
        System.assertEquals(24.98, value.setScale(2));
        value = proDromDB.Inc_GS_Customer_Sat__c;
        System.assertEquals(25.99, value.setScale(2));
        // Expected Value = (400 + 444 + 678 + 543) / (1000 + 1367 + 1333 + 4567) = 2065 / 8267 = 24,97
        // Expected Value (Customer) = (250 + 223 + 900 + 776) / (1000 + 1367 + 1333 + 4567) = 2149 / 8267 = 25,99
    }

    static testMethod void shouldCalculateGSQualitySituation2() {
        Business_Unit__c bu = new Business_Unit__c(Name = 'Inc');
        insert bu;
        DContract__c dcontract1 = new DContract__c(Name = 'Sample Test 1', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 10, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 1000);
        DContract__c dcontract2 = new DContract__c(Name = 'Sample Test 2', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 20, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 2000);
        DContract__c dcontract3 = new DContract__c(Name = 'Sample Test 3', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 30, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 3000);
        DContract__c dcontract4 = new DContract__c(Name = 'Sample Test 4', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 40, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 4000);
        insert dcontract1;
        insert dcontract2;
        insert dcontract3;
        insert dcontract4;

        PRO_Contract_Snapshot__c proS1 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 2, 23));
        PRO_Contract_Snapshot__c proS2 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 3, 9));
        PRO_Contract_Snapshot__c proS3 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 3, 23));
        PRO_Contract_Snapshot__c proS4 = new PRO_Contract_Snapshot__c(Contract__c = dcontract2.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 2, 23));
        PRO_Contract_Snapshot__c proS5 = new PRO_Contract_Snapshot__c(Contract__c = dcontract2.Id, Project_Quality_Overall_Status__c = 444, Customer_Satisfaction_of_services__c = 223,
                                                                GS_Execution_Budget__c = 1367, Snapshot_Date__c = Date.newInstance(2017, 3, 9));
        PRO_Contract_Snapshot__c proS6 = new PRO_Contract_Snapshot__c(Contract__c = dcontract3.Id, Project_Quality_Overall_Status__c = 678, Customer_Satisfaction_of_services__c = 900,
                                                                GS_Execution_Budget__c = 1333, Snapshot_Date__c = Date.newInstance(2017, 3, 9));
        PRO_Contract_Snapshot__c proS7 = new PRO_Contract_Snapshot__c(Contract__c = dcontract3.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 3, 23));
        PRO_Contract_Snapshot__c proS8 = new PRO_Contract_Snapshot__c(Contract__c = dcontract4.Id, Project_Quality_Overall_Status__c = 543, Customer_Satisfaction_of_services__c = 776,
                                                                GS_Execution_Budget__c = 4567, Snapshot_Date__c = Date.newInstance(2017, 3, 9));
        insert proS1;
        insert proS2;
        insert proS3;
        insert proS4;
        insert proS5;
        insert proS6;
        insert proS7;
        insert proS8;

        Project_Report_Out__c pro1 = new Project_Report_Out__c(Contract__c = dcontract1.Id, Contract_Snapshot__c = proS1.Id, Report_Out_Date__c = Date.newInstance(2017, 2, 23));
        Project_Report_Out__c pro2 = new Project_Report_Out__c(Contract__c = dcontract1.Id, Contract_Snapshot__c = proS2.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 9));
        Project_Report_Out__c pro3 = new Project_Report_Out__c(Contract__c = dcontract1.Id, Contract_Snapshot__c = proS3.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 23));

        Project_Report_Out__c pro4 = new Project_Report_Out__c(Contract__c = dcontract2.Id, Contract_Snapshot__c = proS4.Id, Report_Out_Date__c = Date.newInstance(2017, 2, 23));
        Project_Report_Out__c pro5 = new Project_Report_Out__c(Contract__c = dcontract2.Id, Contract_Snapshot__c = proS5.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 9));

        Project_Report_Out__c pro6 = new Project_Report_Out__c(Contract__c = dcontract3.Id, Contract_Snapshot__c = proS6.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 9));
        Project_Report_Out__c pro7 = new Project_Report_Out__c(Contract__c = dcontract3.Id, Contract_Snapshot__c = proS7.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 23));

        Project_Report_Out__c pro8 = new Project_Report_Out__c(Contract__c = dcontract4.Id, Contract_Snapshot__c = proS8.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 9));

        insert pro1;
        insert pro2;
        insert pro3;
        insert pro4;
        insert pro5;
        insert pro6;
        insert pro7;
        insert pro8;

        Test.startTest();
        Database.executeBatch(new GSOverallCalculationBatch(Date.newInstance(2017, 3, 22)));
        Test.stopTest();

        Contract_Statistic__c proDromDB = [SELECT Id, Inc_GS_Customer_Sat__c, Inc_GS_Overall_Status__c FROM Contract_Statistic__c LIMIT 1];
        Decimal value = proDromDB.Inc_GS_Overall_Status__c;
        System.assertEquals(24.98, value.setScale(2));
        value = proDromDB.Inc_GS_Customer_Sat__c;
        System.assertEquals(25.99, value.setScale(2));
        // Expected Value = (400 + 444 + 678 + 543) / (1000 + 1367 + 1333 + 4567) = 2065 / 8267 = 24,97
        // Expected Value (Customer) = (250 + 223 + 900 + 776) / (1000 + 1367 + 1333 + 4567) = 2149 / 8267 = 25,99
    }

    static testMethod void shouldCalculateGSQualitySituation3() {
        Business_Unit__c bu = new Business_Unit__c(Name = 'Inc');
        insert bu;
        DContract__c dcontract1 = new DContract__c(Name = 'Sample Test 1', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 10, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 1000);
        DContract__c dcontract2 = new DContract__c(Name = 'Sample Test 2', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 20, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 2000);
        DContract__c dcontract3 = new DContract__c(Name = 'Sample Test 3', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 30, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 3000);
        DContract__c dcontract4 = new DContract__c(Name = 'Sample Test 4', Prime_Contracting_Business_Unit__c = bu.Id, Percent_through_SOW_deliverables__c = 40, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 4000);
        insert dcontract1;
        insert dcontract2;
        insert dcontract3;
        insert dcontract4;

        PRO_Contract_Snapshot__c proS1 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 3, 9));
        PRO_Contract_Snapshot__c proS2 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 3, 23));
        PRO_Contract_Snapshot__c proS3 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 4, 13));
        PRO_Contract_Snapshot__c proS4 = new PRO_Contract_Snapshot__c(Contract__c = dcontract2.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 3, 9));
        PRO_Contract_Snapshot__c proS5 = new PRO_Contract_Snapshot__c(Contract__c = dcontract2.Id, Project_Quality_Overall_Status__c = 444, Customer_Satisfaction_of_services__c = 223,
                                                                GS_Execution_Budget__c = 1367, Snapshot_Date__c = Date.newInstance(2017, 3, 23));
        PRO_Contract_Snapshot__c proS6 = new PRO_Contract_Snapshot__c(Contract__c = dcontract3.Id, Project_Quality_Overall_Status__c = 678, Customer_Satisfaction_of_services__c = 900,
                                                                GS_Execution_Budget__c = 1333, Snapshot_Date__c = Date.newInstance(2017, 3, 23));
        PRO_Contract_Snapshot__c proS7 = new PRO_Contract_Snapshot__c(Contract__c = dcontract3.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 250,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 4, 13));
        PRO_Contract_Snapshot__c proS8 = new PRO_Contract_Snapshot__c(Contract__c = dcontract4.Id, Project_Quality_Overall_Status__c = 543, Customer_Satisfaction_of_services__c = 776,
                                                                GS_Execution_Budget__c = 4567, Snapshot_Date__c = Date.newInstance(2017, 3, 23));
        insert proS1;
        insert proS2;
        insert proS3;
        insert proS4;
        insert proS5;
        insert proS6;
        insert proS7;
        insert proS8;

        Project_Report_Out__c pro1 = new Project_Report_Out__c(Contract__c = dcontract1.Id, Contract_Snapshot__c = proS1.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 9));
        Project_Report_Out__c pro2 = new Project_Report_Out__c(Contract__c = dcontract1.Id, Contract_Snapshot__c = proS2.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 23));
        Project_Report_Out__c pro3 = new Project_Report_Out__c(Contract__c = dcontract1.Id, Contract_Snapshot__c = proS3.Id, Report_Out_Date__c = Date.newInstance(2017, 4, 13));

        Project_Report_Out__c pro4 = new Project_Report_Out__c(Contract__c = dcontract2.Id, Contract_Snapshot__c = proS4.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 9));
        Project_Report_Out__c pro5 = new Project_Report_Out__c(Contract__c = dcontract2.Id, Contract_Snapshot__c = proS5.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 23));

        Project_Report_Out__c pro6 = new Project_Report_Out__c(Contract__c = dcontract3.Id, Contract_Snapshot__c = proS6.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 23));
        Project_Report_Out__c pro7 = new Project_Report_Out__c(Contract__c = dcontract3.Id, Contract_Snapshot__c = proS7.Id, Report_Out_Date__c = Date.newInstance(2017, 4, 13));

        Project_Report_Out__c pro8 = new Project_Report_Out__c(Contract__c = dcontract4.Id, Contract_Snapshot__c = proS8.Id, Report_Out_Date__c = Date.newInstance(2017, 3, 23));

        insert pro1;
        insert pro2;
        insert pro3;
        insert pro4;
        insert pro5;
        insert pro6;
        insert pro7;
        insert pro8;

        Test.startTest();
        Database.executeBatch(new GSOverallCalculationBatch(Date.newInstance(2017, 3, 27)));
        Test.stopTest();

        Contract_Statistic__c proDromDB = [SELECT Id, Inc_GS_Customer_Sat__c, Inc_GS_Overall_Status__c FROM Contract_Statistic__c LIMIT 1];
        Decimal value = proDromDB.Inc_GS_Overall_Status__c;
        System.assertEquals(24.98, value.setScale(2));
        value = proDromDB.Inc_GS_Customer_Sat__c;
        System.assertEquals(25.99, value.setScale(2));
        // Expected Value = (400 + 444 + 678 + 543) / (1000 + 1367 + 1333 + 4567) = 2065 / 8267 = 24,97
        // Expected Value (Customer) = (250 + 223 + 900 + 776) / (1000 + 1367 + 1333 + 4567) = 2149 / 8267 = 25,99
    }

    static testMethod void shouldCalculateGSQualityTotal() {
        Business_Unit__c bu1 = new Business_Unit__c(Name = 'Inc');
        insert bu1;
        Business_Unit__c bu2 = new Business_Unit__c(Name = 'DSI');
        insert bu2;
        DContract__c dcontract1 = new DContract__c(Name = 'Sample Test 1', Prime_Contracting_Business_Unit__c = bu1.Id, Percent_through_SOW_deliverables__c = 10, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 1000);
        DContract__c dcontract2 = new DContract__c(Name = 'Sample Test 2', Prime_Contracting_Business_Unit__c = bu1.Id, Percent_through_SOW_deliverables__c = 20, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 2000);
        DContract__c dcontract3 = new DContract__c(Name = 'Sample Test 3', Prime_Contracting_Business_Unit__c = bu2.Id, Percent_through_SOW_deliverables__c = 30, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 3000);
        DContract__c dcontract4 = new DContract__c(Name = 'Sample Test 4', Prime_Contracting_Business_Unit__c = bu2.Id, Percent_through_SOW_deliverables__c = 40, Expected_Buffer__c = 0,
                                                   Contract_Expense_BUDGET__c = 0, of_Services_budget_for_GS__c = 100, Total_Amount_of_Contract__c = 4000);
        insert dcontract1;
        insert dcontract2;
        insert dcontract3;
        insert dcontract4;

        PRO_Contract_Snapshot__c proS1 = new PRO_Contract_Snapshot__c(Contract__c = dcontract1.Id, Project_Quality_Overall_Status__c = 200, Customer_Satisfaction_of_services__c = 100,
                                                                GS_Execution_Budget__c = 500, Snapshot_Date__c = Date.newInstance(2017, 1, 26));
        PRO_Contract_Snapshot__c proS2 = new PRO_Contract_Snapshot__c(Contract__c = dcontract2.Id, Project_Quality_Overall_Status__c = 400, Customer_Satisfaction_of_services__c = 200,
                                                                GS_Execution_Budget__c = 900, Snapshot_Date__c = Date.newInstance(2017, 1, 26));
        PRO_Contract_Snapshot__c proS3 = new PRO_Contract_Snapshot__c(Contract__c = dcontract3.Id, Project_Quality_Overall_Status__c = 600, Customer_Satisfaction_of_services__c = 300,
                                                                GS_Execution_Budget__c = 1000, Snapshot_Date__c = Date.newInstance(2017, 1, 26));
        PRO_Contract_Snapshot__c proS4 = new PRO_Contract_Snapshot__c(Contract__c = dcontract4.Id, Project_Quality_Overall_Status__c = 800, Customer_Satisfaction_of_services__c = 400,
                                                                GS_Execution_Budget__c = 1500, Snapshot_Date__c = Date.newInstance(2017, 1, 26));

        insert proS1;
        insert proS2;
        insert proS3;
        insert proS4;

        Project_Report_Out__c pro1 = new Project_Report_Out__c(Contract__c = dcontract1.Id, Contract_Snapshot__c = proS1.Id, Report_Out_Date__c = Date.newInstance(2017, 1, 26));
        Project_Report_Out__c pro2 = new Project_Report_Out__c(Contract__c = dcontract2.Id, Contract_Snapshot__c = proS2.Id, Report_Out_Date__c = Date.newInstance(2017, 1, 26));
        Project_Report_Out__c pro3 = new Project_Report_Out__c(Contract__c = dcontract3.Id, Contract_Snapshot__c = proS3.Id, Report_Out_Date__c = Date.newInstance(2017, 1, 26));
        Project_Report_Out__c pro4 = new Project_Report_Out__c(Contract__c = dcontract4.Id, Contract_Snapshot__c = proS4.Id, Report_Out_Date__c = Date.newInstance(2017, 1, 26));

        insert pro1;
        insert pro2;
        insert pro3;
        insert pro4;

        Test.startTest();
        Database.executeBatch(new GSOverallCalculationBatch(Date.newInstance(2017, 2, 8)));
        Test.stopTest();

        Contract_Statistic__c proDromDB = [SELECT Id, GS_Quality_Total_Overall_Status__c, GS_Quality_Total_Customer_Satisfaction__c FROM Contract_Statistic__c LIMIT 1];
        Decimal value = proDromDB.GS_Quality_Total_Overall_Status__c;
        System.debug('GS_Quality_Total_Overall_Status__c' + proDromDB.GS_Quality_Total_Overall_Status__c);
        System.assertEquals(51.28, value.setScale(2));
        value = proDromDB.GS_Quality_Total_Customer_Satisfaction__c;
        System.assertEquals(25.64, value.setScale(2));
        // Expected Value = (200 + 400 + 600 + 800) / (500 + 900 + 1000 + 1500) = 2000 / 3900 = 51,28
        // Expected Value (Customer) = (100 + 200 + 300 + 400) / (500 + 900 + 1000 + 1500) = 1000 / 3900 = 25,64
    }

    static private void assertSnapshotData(PRO_Contract_Snapshot__c snapshot) {
        System.assertEquals('Sample Test Name', snapshot.Name);
        System.assertEquals(30, snapshot.Percent_Of_Work_Completed__c);
        System.assertEquals(35, snapshot.Percent_Services_Budget_For_GS__c);
        System.assertEquals(50, snapshot.Expected_Buffer__c);
        System.assertEquals(5000, snapshot.Expense_And_Travel_Spend__c);
        System.assertEquals(2500, snapshot.Services_Spend__c);
        System.assertEquals(6000, snapshot.Total_Calculated_Costs__c);
        System.assertEquals(1000, snapshot.Product_Spend2__c);
        System.assertEquals(-2400, snapshot.Net_Income_By_Deliverables_Complete__c);
        System.assertEquals(60, snapshot.Execution_Efficiency__c);
        System.assertEquals(-28, snapshot.Buffer_By_Deliverables_Complete__c);
        System.assertEquals(58, snapshot.Budget_Used__c);
    }

    static private DContract__c addContract() {
        DContract__c dcontract = new DContract__c();

        dcontract.Name = 'Sample Test Name';
        dcontract.Percent_through_SOW_deliverables__c = 30;
        dcontract.of_Services_budget_for_GS__c = 35;
        dcontract.Expected_Buffer__c = 50;
        dcontract.Direct_Costs_Total_Expenses__c = 5000;
        dcontract.Services_Spend__c = 2500;
        dcontract.Contract_Expense_BUDGET__c = 2000;
        dcontract.Total_Amount_of_Contract__c = 12000;
        dcontract.Product_Income_Budget__c = 4000;
        dcontract.Contract_Start_Date__c = Date.today().addDays(-1);
        dcontract.Contract_End_Date__c = Date.today().addDays(3);
        dcontract.Direct_Costs_Sub_contract_Expenses__c = 300;
        dcontract.Direct_Costs_Travel_Expenses__c = 125;
        dcontract.Total_Direct_Costs__c = 3700;
        dcontract.Internal_Sub_contract_Spend__c = 200;

        dcontract.Status__c = 'Active';
        dcontract.Requires_Report_Out__c = 'No';

        insert dcontract;
        return dcontract;
    }
}