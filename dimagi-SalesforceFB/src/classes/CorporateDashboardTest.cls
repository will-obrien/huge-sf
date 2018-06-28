@isTest
public class CorporateDashboardTest {

    @testSetup
    static void setup() {
        Date currentDay = Date.today();
        Integer currentYear = currentDay.year();
        Date fiscalYearStart = Date.newInstance(currentYear, 1, 1);
        Date fiscalYearEnd = Date.newInstance(currentYear, 12, 31);
        Corporate_Dashboard_Settings__c setting = Corporate_Dashboard_Settings__c.getOrgDefaults();
        setting.Fiscal_Year_Start__c = fiscalYearStart;
        setting.Fiscal_year_End__c = fiscalYearEnd;
        setting.EV_Target__c = 2000000;
        setting.EV_Expected_Buffer_Target__c = 2000000;
        setting.Opp_Won_Target__c = 2000000;
        insert setting;
    }

    @isTest
    public static void shouldLoadICDSGraphs() {
        Date currentDate = Date.today();
        insert new ICDS_Domain_Snapshot__c(Active_Users__c = 45000, Forms__c = 13000000, WAMs__c = 345000, Date__c = currentDate.addMonths(-2));
        insert new ICDS_Domain_Snapshot__c(Active_Users__c = 55000, Forms__c = 14000000, WAMs__c = 365000, Date__c = currentDate.addMonths(-1));
        insert new ICDS_Domain_Snapshot__c(Active_Users__c = 65000, Forms__c = 15000000, WAMs__c = 385000, Date__c = currentDate);

        Test.startTest();
        CorporateDashboardHelper.refreshAllGraphs();
        Test.stopTest();

        List<Global_Metric_Graph__c> icdsGraphs = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c
                                                   FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.ICDS_GRAPHS
                                                   ORDER BY Helper_Date__c];
        System.assertEquals(45, icdsGraphs.get(0).Graph_Value_1__c);
        System.assertEquals(365, icdsGraphs.get(1).Graph_Value_2__c);
        System.assertEquals(15000, icdsGraphs.get(2).Graph_Value_3__c);
    }

    @isTest
    public static void shouldLoadDomainSnapshotGraphs() {
        setUpMonthlySnapshotData();

        Test.startTest();
        CorporateDashboardHelper.refreshAllGraphs();
        Test.stopTest();

        List<Global_Metric_Graph__c> userGraph = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c, Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                                                  FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.USER_GRAPH ORDER BY Helper_Date__c];
        List<Global_Metric_Graph__c> formGraph = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c, Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                                                  FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.FORM_GRAPH ORDER BY Helper_Date__c];
        List<Global_Metric_Graph__c> wamGraph = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c, Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                                                  FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.WAM_GRAPH ORDER BY Helper_Date__c];
        List<Global_Metric_Graph__c> programsGraph = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c, Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                                                  FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.PROGRAMS_GRAPH ORDER BY Helper_Date__c];

        System.assertEquals(3, userGraph.size());
        System.assertEquals(3, formGraph.size());
        System.assertEquals(3, wamGraph.size());
        System.assertEquals(3, programsGraph.size());

        System.assertEquals(17, userGraph.get(0).Graph_Value_5__c);
        System.assertEquals(13, userGraph.get(0).Graph_Value_4__c);
        System.assertEquals(12, wamGraph.get(0).Graph_Value_3__c);
        System.assertEquals(11, wamGraph.get(0).Graph_Value_2__c);
        System.assertEquals(66, formGraph.get(0).Graph_Value_1__c);
        System.assertEquals(52, formGraph.get(0).Graph_Value_6__c);
        System.assertEquals(12, programsGraph.get(0).Graph_Value_7__c);
        System.assertEquals(33, programsGraph.get(0).Graph_Value_1__c);
    }

    @isTest
    public static void shouldLoadGSGraphs() {
        setUpGSData();

        Test.startTest();
        CorporateDashboardHelper.refreshAllGraphs();
        Test.stopTest();

        List<Global_Metric_Graph__c> gsGraph = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c
                                                FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.GS_GRAPHS
                                                ORDER BY Helper_Date__c];
        System.assertEquals(3, gsGraph.size());
        System.assertEquals(86, gsGraph.get(0).Graph_Value_1__c);
        System.assertEquals(77, gsGraph.get(0).Graph_Value_2__c);
        System.assertEquals(66, gsGraph.get(1).Graph_Value_1__c);
        System.assertEquals(88, gsGraph.get(2).Graph_Value_2__c);
    }

    @isTest
    public static void shouldLoadPerformanceGraphs() {
        setUpPerformanceData();

        Test.startTest();
        CorporateDashboardHelper.refreshAllGraphs();
        Test.stopTest();

        List<Global_Metric_Graph__c> performanceGraph = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c
                                                         FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.PERFORMANCE_GRAPHS
                                                         ORDER BY Helper_Date__c];
        System.assertEquals(2, performanceGraph.size());
        System.assertEquals(30, performanceGraph.get(0).Graph_Value_1__c);
        System.assertEquals(7, performanceGraph.get(0).Graph_Value_2__c);
        System.assertEquals(9, performanceGraph.get(0).Graph_Value_3__c);
        System.assertEquals(17.5, performanceGraph.get(1).Graph_Value_1__c);
        System.assertEquals(5, performanceGraph.get(1).Graph_Value_2__c);
        System.assertEquals(8, performanceGraph.get(1).Graph_Value_3__c);
    }

    @isTest
    public static void shouldMrrGraph() {
        setUpMrrData();

        Test.startTest();
        CorporateDashboardHelper.refreshAllGraphs();
        Test.stopTest();

        List<Global_Metric_Graph__c> mrrGraph = [SELECT X_Text__c, Graph_Value_1__c, Graph_Value_2__c, Graph_Value_3__c, Graph_Value_4__c,
                                                         Graph_Value_5__c, Graph_Value_6__c, Graph_Value_7__c
                                                         FROM Global_Metric_Graph__c WHERE Name =: CorporateDashboardHelper.MRR_GRAPH
                                                         ORDER BY Helper_Date__c];
        System.assertEquals(2, mrrGraph.size());
        System.assertEquals(0, mrrGraph.get(0).Graph_Value_4__c);
        System.assertEquals(0, mrrGraph.get(1).Graph_Value_4__c);
    }

    private static void setUpMrrData() {
        Date currentDay = Date.today();
        Accounting_Subscription__c sub = new Accounting_Subscription__c(service_type__c = 'Self_service');
        insert sub;
        Accounting_Invoice__c inv1 = new Accounting_Invoice__c(Accounting_Subscription__c = sub.Id,
                                                               is_hidden__c = false, Ops_Override__c = false,
                                                               is_hidden_to_ops__c = false,
                                                               date_end__c = currentDay, Softwareplan_Edition__c = 'Pro');
        Accounting_Invoice__c inv2 = new Accounting_Invoice__c(Accounting_Subscription__c = sub.Id,
                                                               is_hidden__c = false, Ops_Override__c = false,
                                                               is_hidden_to_ops__c = false,
                                                               date_end__c = currentDay, Softwareplan_Edition__c = 'Pro');
        Accounting_Invoice__c inv3 = new Accounting_Invoice__c(Accounting_Subscription__c = sub.Id,
                                                               is_hidden__c = false, Ops_Override__c = false,
                                                               is_hidden_to_ops__c = false,
                                                               date_end__c = currentDay, Softwareplan_Edition__c = 'Pro');
        Accounting_Invoice__c inv4 = new Accounting_Invoice__c(Accounting_Subscription__c = sub.Id,
                                                               is_hidden__c = false, Ops_Override__c = false,
                                                               is_hidden_to_ops__c = false,
                                                               date_end__c = currentDay.addMonths(-1), Softwareplan_Edition__c = 'Pro');
        Accounting_Invoice__c inv5 = new Accounting_Invoice__c(Accounting_Subscription__c = sub.Id,
                                                               is_hidden__c = false, Ops_Override__c = false,
                                                               is_hidden_to_ops__c = false,
                                                               date_end__c = currentDay.addMonths(-1), Softwareplan_Edition__c = 'Pro');
        Accounting_Invoice__c inv6 = new Accounting_Invoice__c(Accounting_Subscription__c = sub.Id,
                                                               is_hidden__c = false, Ops_Override__c = false,
                                                               is_hidden_to_ops__c = false,
                                                               date_end__c = currentDay.addMonths(-1), Softwareplan_Edition__c = 'Pro');
        insert inv1;
        insert inv2;
        insert inv3;
        insert inv4;
        insert inv5;
        insert inv6;
    }

    private static void setUpPerformanceData() {
        Date currentDay = Date.today();
        CommCareHQ_Performance_Metrics__c performance1 = new CommCareHQ_Performance_Metrics__c(Date__c = currentDay.addMonths(-1),
                                                                                               Server_Apdex__c = null,
                                                                                               Number_of_Submissions__c = 30000,
                                                                                               Avg_Page_Load__c = 3);
        CommCareHQ_Performance_Metrics__c performance2 = new CommCareHQ_Performance_Metrics__c(Date__c = currentDay.addMonths(-1),
                                                                                               Server_Apdex__c = 9,
                                                                                               Number_of_Submissions__c = 5000,
                                                                                               Avg_Page_Load__c = null);
        CommCareHQ_Performance_Metrics__c performance3 = new CommCareHQ_Performance_Metrics__c(Date__c = currentDay.addMonths(-1),
                                                                                               Server_Apdex__c = 7,
                                                                                               Number_of_Submissions__c = null,
                                                                                               Avg_Page_Load__c = 7);
        CommCareHQ_Performance_Metrics__c performance4 = new CommCareHQ_Performance_Metrics__c(Date__c = currentDay.addMonths(-2),
                                                                                               Server_Apdex__c = null,
                                                                                               Number_of_Submissions__c = 30000,
                                                                                               Avg_Page_Load__c = 7);
        CommCareHQ_Performance_Metrics__c performance5 = new CommCareHQ_Performance_Metrics__c(Date__c = currentDay.addMonths(-2),
                                                                                               Server_Apdex__c = 9,
                                                                                               Number_of_Submissions__c = 30000,
                                                                                               Avg_Page_Load__c = null);
        CommCareHQ_Performance_Metrics__c performance6 = new CommCareHQ_Performance_Metrics__c(Date__c = currentDay.addMonths(-2),
                                                                                               Server_Apdex__c = 9,
                                                                                               Number_of_Submissions__c = null,
                                                                                               Avg_Page_Load__c = 7);
        insert performance1;
        insert performance2;
        insert performance3;
        insert performance4;
        insert performance5;
        insert performance6;
    }

    private static void setUpGSData() {
        Date currentDay = Date.today();
        Contract_Statistic__c cs1 = new Contract_Statistic__c(PRO_Cycle_Date__c = currentDay.addMonths(-1),
                                                              GS_Quality_Total_Customer_Satisfaction__c = 88,
                                                              GS_Quality_Total_Overall_Status__c = 78);
        Contract_Statistic__c cs2 = new Contract_Statistic__c(PRO_Cycle_Date__c = currentDay.addMonths(-2),
                                                              GS_Quality_Total_Customer_Satisfaction__c = 90,
                                                              GS_Quality_Total_Overall_Status__c = 66);
        Contract_Statistic__c cs3 = new Contract_Statistic__c(PRO_Cycle_Date__c = currentDay.addMonths(-3),
                                                              GS_Quality_Total_Customer_Satisfaction__c = 77,
                                                              GS_Quality_Total_Overall_Status__c = 86);
        insert cs1;
        insert cs2;
        insert cs3;
    }

    private static void setUpMonthlySnapshotData() {
        Date currentDay = Date.today();
        Integer currentYear = currentDay.year();
        Integer currentMonth = currentDay.month();
        Domain_Monthly_Snapshot__c sn1 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Standard', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 11, Snapshot_Date__c = currentDay.addMonths(-1));
        Domain_Monthly_Snapshot__c sn2 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Standard', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 22, Snapshot_Date__c = currentDay.addMonths(-2));
        Domain_Monthly_Snapshot__c sn3 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Standard', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 17000,
                                                                        Scale_of_Programs__c = 33, Snapshot_Date__c = currentDay.addMonths(-3));
        Domain_Monthly_Snapshot__c sn4 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Pro', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 44, Snapshot_Date__c = currentDay.addMonths(-1));
        Domain_Monthly_Snapshot__c sn5 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Pro', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 55, Snapshot_Date__c = currentDay.addMonths(-2));
        Domain_Monthly_Snapshot__c sn6 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Pro', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 13000,
                                                                        Scale_of_Programs__c = 66, Snapshot_Date__c = currentDay.addMonths(-3));
        Domain_Monthly_Snapshot__c sn7 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Enterprise', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 77, Snapshot_Date__c = currentDay.addMonths(-1));
        Domain_Monthly_Snapshot__c sn8 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Enterprise', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 88, Snapshot_Date__c = currentDay.addMonths(-2));
        Domain_Monthly_Snapshot__c sn9 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Enterprise', Wam__c = 12000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 99, Snapshot_Date__c = currentDay.addMonths(-3));
        Domain_Monthly_Snapshot__c sn10 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Community', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 88, Snapshot_Date__c = currentDay.addMonths(-1));
        Domain_Monthly_Snapshot__c sn11 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Community', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 77, Snapshot_Date__c = currentDay.addMonths(-2));
        Domain_Monthly_Snapshot__c sn12 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Community', Wam__c = 11000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 66, Snapshot_Date__c = currentDay.addMonths(-3));
        Domain_Monthly_Snapshot__c sn13 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Advanced', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 55, Snapshot_Date__c = currentDay.addMonths(-1));
        Domain_Monthly_Snapshot__c sn14 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Advanced', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 44, Snapshot_Date__c = currentDay.addMonths(-2));
        Domain_Monthly_Snapshot__c sn15 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Advanced', Wam__c = 1000, Forms_for_Period__c = 66000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 33, Snapshot_Date__c = currentDay.addMonths(-3));
        Domain_Monthly_Snapshot__c sn16 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Managed Hosting', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 22, Snapshot_Date__c = currentDay.addMonths(-1));
        Domain_Monthly_Snapshot__c sn17 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Managed Hosting', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 11, Snapshot_Date__c = currentDay.addMonths(-2));
        Domain_Monthly_Snapshot__c sn18 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Managed Hosting', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 12, Snapshot_Date__c = currentDay.addMonths(-3));
        Domain_Monthly_Snapshot__c sn19 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Reseller', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 13, Snapshot_Date__c = currentDay.addMonths(-1));
        Domain_Monthly_Snapshot__c sn20 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Reseller', Wam__c = 1000, Forms_for_Period__c = 50000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 14, Snapshot_Date__c = currentDay.addMonths(-2));
        Domain_Monthly_Snapshot__c sn21 = new Domain_Monthly_Snapshot__c(Software_Plan_Edition__c = 'Reseller', Wam__c = 1000, Forms_for_Period__c = 52000, Active_Mobile_Users__c = 1300,
                                                                        Scale_of_Programs__c = 1, Snapshot_Date__c = currentDay.addMonths(-3));
        insert sn1;
        insert sn2;
        insert sn3;
        insert sn4;
        insert sn5;
        insert sn6;
        insert sn7;
        insert sn8;
        insert sn9;
        insert sn10;
        insert sn11;
        insert sn12;
        insert sn13;
        insert sn14;
        insert sn15;
        insert sn16;
        insert sn17;
        insert sn18;
        insert sn19;
        insert sn20;
        insert sn21;
    }
}