@isTest
public class SalaryHistoryTest {

    /**
     * 1 date record and 3 history (first with empty OldValue)
     */
    static testMethod void shouldFetchHistoryForEmp1() {
        Test.startTest();

        SalaryHistoryHelper salaryHelper = new SalaryHistoryHelper();
        SFDC_Employee__c employee = new SFDC_Employee__c(Name = 'emp_1', Salary__c = 30000);

        List<SalaryHistoryRecord> historyList = salaryHelper.getHistoryForEmployee(employee, 'Salary__c', 'Effective_Salary_Date__c');

        System.assertEquals(3, historyList.size());
        System.assertEquals(10000, historyList.get(0).getValue());
        System.assertEquals(Date.newInstance(1900, 1, 1), historyList.get(0).getValueDate());
        System.assertEquals(20000, historyList.get(1).getValue());
        System.assertEquals(Date.newInstance(2015, 4, 14), historyList.get(1).getValueDate());
        System.assertEquals(30000, historyList.get(2).getValue());
        System.assertEquals(Date.newInstance(2015, 6, 1), historyList.get(2).getValueDate());

        Test.stopTest();
    }

    /**
     * Empty list
     */
    static testMethod void shouldFetchHistoryForEmp2() {
        Test.startTest();

        SalaryHistoryHelper salaryHelper = new SalaryHistoryHelper();
        SFDC_Employee__c employee = new SFDC_Employee__c(Name = 'emp_2', Salary__c = 150000);

        List<SalaryHistoryRecord> historyList = salaryHelper.getHistoryForEmployee(employee, 'Salary__c', 'Effective_Salary_Date__c');

        System.assertEquals(1, historyList.size());
        System.assertEquals(150000, historyList.get(0).getValue());
        System.assertEquals(Date.newInstance(1900, 1, 1), historyList.get(0).getValueDate());

        Test.stopTest();
    }

    /**
     * 0 date record and 3 history (first with filled OldValue)
     */
    static testMethod void shouldFetchHistoryForEmp3() {
        Test.startTest();

        SalaryHistoryHelper salaryHelper = new SalaryHistoryHelper();
        SFDC_Employee__c employee = new SFDC_Employee__c(Name = 'emp_3', Salary__c = 150000);

        List<SalaryHistoryRecord> historyList = salaryHelper.getHistoryForEmployee(employee, 'Salary__c', 'Effective_Salary_Date__c');

        System.assertEquals(4, historyList.size());
        System.assertEquals(50000, historyList.get(0).getValue());
        System.assertEquals(Date.newInstance(1900, 1, 1), historyList.get(0).getValueDate());
        System.assertEquals(60000, historyList.get(1).getValue());
        System.assertEquals(Date.newInstance(2014, 1, 1), historyList.get(1).getValueDate());
        System.assertEquals(70000, historyList.get(2).getValue());
        System.assertEquals(Date.newInstance(2015, 1, 1), historyList.get(2).getValueDate());
        System.assertEquals(80000, historyList.get(3).getValue());
        System.assertEquals(Date.newInstance(2016, 9, 10), historyList.get(3).getValueDate());

        Test.stopTest();
    }

    /**
     * 2 date record and 2 history
     */
    static testMethod void shouldFetchHistoryForEmp4() {
        Test.startTest();

        SalaryHistoryHelper salaryHelper = new SalaryHistoryHelper();
        SFDC_Employee__c employee = new SFDC_Employee__c(Name = 'emp_4', Salary__c = 150000);

        List<SalaryHistoryRecord> historyList = salaryHelper.getHistoryForEmployee(employee, 'Salary__c', 'Effective_Salary_Date__c');

        System.assertEquals(3, historyList.size());
        System.assertEquals(17000, historyList.get(0).getValue());
        System.assertEquals(Date.newInstance(1900, 1, 1), historyList.get(0).getValueDate());
        System.assertEquals(34000, historyList.get(1).getValue());
        System.assertEquals(Date.newInstance(2015, 1, 1), historyList.get(1).getValueDate());
        System.assertEquals(13000, historyList.get(2).getValue());
        System.assertEquals(Date.newInstance(2015, 6, 1), historyList.get(2).getValueDate());

        Test.stopTest();
    }

    static testMethod void shouldIgnoreBadExchangeRate() {
        Test.startTest();

        SalaryHistoryHelper salaryHelper = new SalaryHistoryHelper();
        SFDC_Employee__c employee = new SFDC_Employee__c(Name = 'emp_12', Salary__c = 150000);

        List<SalaryHistoryRecord> historyList = salaryHelper.getHistoryForEmployee(employee, 'Exchange_Rate__c', 'Effective_Exchange_Rate_Date__c');

        System.assertEquals(2, historyList.size());
        System.assertEquals(3, historyList.get(0).getValue());
        System.assertEquals(Date.newInstance(1900, 1, 1), historyList.get(0).getValueDate());
        System.assertEquals(2, historyList.get(1).getValue());
        System.assertEquals(Date.newInstance(2016, 1, 1), historyList.get(1).getValueDate());

        Test.stopTest();
    }

    static testMethod void shouldMergeListsEmp6() {
        Test.startTest();

        SalaryHistoryHelper salaryHelper = new SalaryHistoryHelper();
        SFDC_Employee__c employee = new SFDC_Employee__c(Name = 'emp_6', Salary__c = 60000);

        List<SalaryHistoryRecord> historyList = salaryHelper.mergeSalaryHistory(employee);

        System.debug(historyList);
        System.assertEquals(5, historyList.size());

        Loaded_Daily_Rate_Settings__c settings = new Loaded_Daily_Rate_Settings__c(Settings_Effective_Date__c = Date.newInstance(1900, 1, 1),
                                                                                   Working_Days__c = 260, Fringe__c = 30,
                                                                                   Overhead__c = 52, Fee__c = 10, G_A__c = 10);

        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(20000, 2), settings),
                            historyList.get(0).getValue());
        System.assertEquals(Date.newInstance(1900, 1, 1), historyList.get(0).getValueDate());

        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(40000, 2), settings),
                            historyList.get(1).getValue());
        System.assertEquals(Date.newInstance(2011, 1, 1), historyList.get(1).getValueDate());

        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(40000, 3), settings),
                            historyList.get(2).getValue());
        System.assertEquals(Date.newInstance(2011, 2, 14), historyList.get(2).getValueDate());

        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(60000, 3), settings),
                            historyList.get(3).getValue());
        System.assertEquals(Date.newInstance(2011, 11, 1), historyList.get(3).getValueDate());

        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(60000, 2), settings),
                            historyList.get(4).getValue());
        System.assertEquals(Date.newInstance(2012, 1, 1), historyList.get(4).getValueDate());

        Test.stopTest();
    }

    static testMethod void shouldMergeListsEmp7() {
        Test.startTest();

        Loaded_Daily_Rate_Settings__c settings = new Loaded_Daily_Rate_Settings__c(Settings_Effective_Date__c = Date.newInstance(1900, 1, 1),
                                                                                   Working_Days__c = 260, Fringe__c = 30,
                                                                                   Overhead__c = 52, Fee__c = 10, G_A__c = 10);

        SalaryHistoryHelper salaryHelper = new SalaryHistoryHelper();
        SFDC_Employee__c employee = new SFDC_Employee__c(Name = 'emp_7', Salary__c = 45000, Exchange_Rate__c = 2,
                                                         Effective_Salary_Date__c = Date.newInstance(2013, 1, 1),
                                                         Effective_Exchange_Rate_Date__c = Date.newInstance(2011, 1, 1));

        List<SalaryHistoryRecord> historyList = salaryHelper.mergeSalaryHistory(employee);

        System.assertEquals(1, historyList.size());
        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(45000, 2), settings),
                            historyList.get(0).getValue());
        System.assertEquals(Date.newInstance(1900, 1, 1), historyList.get(0).getValueDate());

        Test.stopTest();
    }

    static testMethod void shouldMergeListsEmp8() {
        Test.startTest();

        Loaded_Daily_Rate_Settings__c settings = new Loaded_Daily_Rate_Settings__c(Settings_Effective_Date__c = Date.newInstance(1900, 1, 1),
                                                                                   Working_Days__c = 260, Fringe__c = 30,
                                                                                   Overhead__c = 52, Fee__c = 10, G_A__c = 10);

        SalaryHistoryHelper salaryHelper = new SalaryHistoryHelper();
        SFDC_Employee__c employee = new SFDC_Employee__c(Name = 'emp_8', Salary__c = 200000, Exchange_Rate__c = 2,
                                                         Effective_Salary_Date__c = Date.newInstance(2010, 1, 1),
                                                         Effective_Exchange_Rate_Date__c = Date.newInstance(2013, 6, 1));

        List<SalaryHistoryRecord> historyList = salaryHelper.mergeSalaryHistory(employee);

        System.assertEquals(2, historyList.size());
        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(200000, 4), settings),
                            historyList.get(0).getValue());
        System.assertEquals(Date.newInstance(1900, 1, 1), historyList.get(0).getValueDate());

        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(200000, 2), settings),
                            historyList.get(1).getValue());
        System.assertEquals(Date.newInstance(2013, 6, 1), historyList.get(1).getValueDate());

        Test.stopTest();
    }

    static testMethod void shouldCalculateCorrectSalary() {
        Test.startTest();
        Loaded_Daily_Rate_Settings__c settings = new Loaded_Daily_Rate_Settings__c(Settings_Effective_Date__c = Date.newInstance(1900, 1, 1),
                                                                                   Working_Days__c = 260, Fringe__c = 30,
                                                                                   Overhead__c = 52, Fee__c = 10, G_A__c = 10);
        System.assertEquals(11.50, SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(20000, 2), settings));
        System.assertEquals(22.99, SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(40000, 2), settings));
        System.assertEquals(15.33, SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(40000, 3), settings));
        System.assertEquals(34.48, SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(60000, 2), settings));
        System.assertEquals(22.25, SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(60000, 3.1), settings));
        System.assertEquals(71.96, SalaryHistoryHelper.calculatePerHourSalary(SalaryHistoryHelper.calculateSalary(457000, 7.3), settings));

        Test.stopTest();
    }

    static testMethod void testIntegrationWithCalculationBatchJob() {
        // 3 Employess, 3 contracts, one is subcontract
        Test.startTest();

        SFDC_Employee__c employee_1 = new SFDC_Employee__c(Name = 'emp_6', Salary__c = 60000, Exchange_Rate__c = 2,
                                                          Effective_Salary_Date__c = Date.newInstance(2011, 11, 1),
                                                          Effective_Exchange_Rate_Date__c = Date.newInstance(2013, 1, 1));
        insert employee_1;
        SFDC_Employee__c employee_2 = new SFDC_Employee__c(Name = 'emp_7', Salary__c = 45000, Exchange_Rate__c = 2,
                                                         Effective_Salary_Date__c = Date.newInstance(2013, 1, 1),
                                                         Effective_Exchange_Rate_Date__c = Date.newInstance(2011, 1, 1));
        insert employee_2;
        SFDC_Employee__c employee_3 = new SFDC_Employee__c(Name = 'emp_8', Salary__c = 200000, Exchange_Rate__c = 2,
                                                         Effective_Salary_Date__c = Date.newInstance(2010, 1, 1),
                                                         Effective_Exchange_Rate_Date__c = Date.newInstance(2013, 6, 1));
        insert employee_3;

        DContract__c parent_1 = new DContract__c(Name = 'Sample Parent', Status__c = 'Active', Requires_Report_Out__c = 'No', Intracompany_Sub_contract__c = 'No');
        insert parent_1;
        DContract__c child = new DContract__c(Name = 'Sample Child', Status__c = 'Active', Requires_Report_Out__c = 'No', Intracompany_Sub_contract__c = 'Yes', Parent_Contract__c = parent_1.Id);
        insert child;
        DContract__c parent_2 = new DContract__c(Name = 'Sample Parent 2', Status__c = 'Active', Requires_Report_Out__c = 'No', Intracompany_Sub_contract__c = 'No');
        insert parent_2;

        // Employee 1:
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(20000, 2) = 11.50
        Time_Card__c tc_1_employee_1 = new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2010, 12, 30), Employee__c = employee_1.Id, Client__c = parent_1.Id);
        insert tc_1_employee_1;
        // Salary = 3 * SalaryHistoryHelper.calculateSalary(20000, 2) = 3 * 11.50 = 34,5
        Time_Card__c tc_2_employee_1 = new Time_Card__c(Total__c = 3, Date__c = Date.newInstance(2010, 11, 1), Employee__c = employee_1.Id, Client__c = parent_1.Id);
        insert tc_2_employee_1;
        // Salary = 6 * SalaryHistoryHelper.calculateSalary(40000, 2) = 6 * 22.99 = 137,94
        Time_Card__c tc_3_employee_1 = new Time_Card__c(Total__c = 6, Date__c = Date.newInstance(2011, 1, 1), Employee__c = employee_1.Id, Client__c = child.Id);
        insert tc_3_employee_1;
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(40000, 3) = 7 * 15.33 = 107,31
        Time_Card__c tc_4_employee_1 = new Time_Card__c(Total__c = 7, Date__c = Date.newInstance(2011, 5, 22), Employee__c = employee_1.Id, Client__c = parent_2.Id);
        insert tc_4_employee_1;
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(20000, 2) = 8 * 34.48 = 275,84
        Time_Card__c tc_5_employee_1 = new Time_Card__c(Total__c = 8, Date__c = Date.newInstance(2016, 3, 3), Employee__c = employee_1.Id, Client__c = parent_2.Id);
        insert tc_5_employee_1;
        // child = 137.94, parent_1 46 = 183.94 , parent_2 = 275,84 + 107,31 = 383.15

        // Employee 2:
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(45000, 2) = 25.86
        Time_Card__c tc_1_employee_2 = new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2010, 12, 30), Employee__c = employee_2.Id, Client__c = parent_1.Id);
        insert tc_1_employee_2;
        // Salary = 3 * SalaryHistoryHelper.calculateSalary(45000, 2) = 3 * 25.86 = 77,58
        Time_Card__c tc_2_employee_2 = new Time_Card__c(Total__c = 3, Date__c = Date.newInstance(2010, 11, 1), Employee__c = employee_2.Id, Client__c = parent_1.Id);
        insert tc_2_employee_2;
        // Salary = 6 * SalaryHistoryHelper.calculateSalary(45000, 2) = 6 * 25.86 = 155,16
        Time_Card__c tc_3_employee_2 = new Time_Card__c(Total__c = 6, Date__c = Date.newInstance(2011, 1, 1), Employee__c = employee_2.Id, Client__c = parent_1.Id);
        insert tc_3_employee_2;
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(45000, 2) = 7 * 25.86 = 181,02
        Time_Card__c tc_4_employee_2 = new Time_Card__c(Total__c = 7, Date__c = Date.newInstance(2011, 5, 22), Employee__c = employee_2.Id, Client__c = parent_1.Id);
        insert tc_4_employee_2;
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(45000, 2) = 8 * 25.86 = 206,88
        Time_Card__c tc_5_employee_2 = new Time_Card__c(Total__c = 8, Date__c = Date.newInstance(2016, 3, 3), Employee__c = employee_2.Id, Client__c = parent_2.Id);
        insert tc_5_employee_2;
        // child = 0, parent_1 = 439.62 , parent_2 = 206,88

        // Employee 3:
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(200000, 4) = 57.48
        Time_Card__c tc_1_employee_3 = new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2010, 12, 30), Employee__c = employee_3.Id, Client__c = child.Id);
        insert tc_1_employee_3;
        // Salary = 3 * SalaryHistoryHelper.calculateSalary(200000, 4) = 3 * 57.48 = 172.44
        Time_Card__c tc_2_employee_3 = new Time_Card__c(Total__c = 3, Date__c = Date.newInstance(2010, 11, 1), Employee__c = employee_3.Id, Client__c = child.Id);
        insert tc_2_employee_3;
        // Salary = 6 * SalaryHistoryHelper.calculateSalary(200000, 2) = 6 * 114.95 = 689.7
        Time_Card__c tc_3_employee_3 = new Time_Card__c(Total__c = 6, Date__c = Date.newInstance(2013, 6, 1), Employee__c = employee_3.Id, Client__c = child.Id);
        insert tc_3_employee_3;
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(200000, 2) = 7 * 114.95 = 804.65
        Time_Card__c tc_4_employee_3 = new Time_Card__c(Total__c = 7, Date__c = Date.newInstance(2015, 5, 22), Employee__c = employee_3.Id, Client__c = parent_1.Id);
        insert tc_4_employee_3;
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(200000, 4) = 8 * 57.48 = 459.84
        Time_Card__c tc_5_employee_3 = new Time_Card__c(Total__c = 8, Date__c = Date.newInstance(2013, 5, 30), Employee__c = employee_3.Id, Client__c = parent_2.Id);
        insert tc_5_employee_3;
        // child = 919.62, parent_1 = 804.65 + 919.62 CH , parent_2 = 459.84

        // TOTAL : child = 1057.56, parent_1 = 46 + 439.62 + 804.65 + 1057.56 CH = 2347.83 , parent_2 = 383.15 + 206,88 + 459.84 = 1049.87
        Test.stopTest();

        BatchCalculateTotalHoursOfTimeCard batch1 = new BatchCalculateTotalHoursOfTimeCard();
        Database.QueryLocatorIterator iter = batch1.start(null).iterator();
        List<sObject> testData = new List<sObject>();
        while (iter.hasNext()) {
            testData.add(iter.next());
        }
        System.debug('testData : ' + testData);
        batch1.execute(null, testData);
        System.debug('testData : ' + testData);
        System.debug('batch1.getServicesSpendMap() : ' + batch1.getServicesSpendMap());
        BatchUpdateContractServicesSpend batch2 = new BatchUpdateContractServicesSpend(batch1.getServicesSpendMap());
        batch2.execute(null, batch2.start(null));

        DContract__c dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: parent_1.Id];
        System.assertEquals(2347.83, dcontractFromDB.Services_Spend__c);
        dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: child.Id];
        System.assertEquals(1057.56, dcontractFromDB.Services_Spend__c);
        dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: parent_2.Id];
        System.assertEquals(1049.87, dcontractFromDB.Services_Spend__c);
    }

    static testMethod void shouldSortList() {
        List<SalaryHistoryRecord> salaryList = new List<SalaryHistoryRecord>();
        salaryList.add(new SalaryHistoryRecord(11, Date.newInstance(2015, 4, 11)));
        salaryList.add(new SalaryHistoryRecord(12, Date.newInstance(1900, 1, 1)));
        salaryList.add(new SalaryHistoryRecord(10, Date.newInstance(2014, 1, 15)));
        salaryList.add(new SalaryHistoryRecord(44, Date.newInstance(2016, 2, 22)));

        salaryList.sort();

        System.assertEquals(Date.newInstance(1900, 1, 1), salaryList.get(0).getValueDate());
        System.assertEquals(Date.newInstance(2014, 1, 15), salaryList.get(1).getValueDate());
        System.assertEquals(Date.newInstance(2015, 4, 11), salaryList.get(2).getValueDate());
        System.assertEquals(Date.newInstance(2016, 2, 22), salaryList.get(3).getValueDate());
    }

    static testMethod void testCalcualtionScale() {
        Test.startTest();
        DContract__c parent = new DContract__c(Name = 'Sample Parent', Status__c = 'Active', Requires_Report_Out__c = 'No', Intracompany_Sub_contract__c = 'No');
        insert parent;

        SFDC_Employee__c employee_1 = new SFDC_Employee__c(Name = 'emp_9', Salary__c = 101854.98, Effective_Salary_Date__c = Date.newInstance(2016, 2, 24),
                                                           Exchange_Rate__c = 1, Effective_Exchange_Rate_Date__c = Date.newInstance(2016, 2, 24));
        SFDC_Employee__c employee_2 = new SFDC_Employee__c(Name = 'emp_10', Salary__c = 45259.16, Effective_Salary_Date__c = Date.newInstance(2016, 2, 24),
                                                           Exchange_Rate__c = 1, Effective_Exchange_Rate_Date__c = Date.newInstance(2016, 2, 24));
        SFDC_Employee__c employee_3 = new SFDC_Employee__c(Name = 'emp_11', Salary__c = 89319.79, Effective_Salary_Date__c = Date.newInstance(2016, 2, 24),
                                                           Exchange_Rate__c = 1, Effective_Exchange_Rate_Date__c = Date.newInstance(2016, 2, 24));

        insert employee_1;
        insert employee_2;
        insert employee_3;

        List<Time_Card__c> timecards = new List<Time_Card__c>();
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 7, 3), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.7, Date__c = Date.newInstance(2016, 7, 4), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.8, Date__c = Date.newInstance(2016, 7, 5), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 6, Date__c = Date.newInstance(2016, 7, 6), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 6.2, Date__c = Date.newInstance(2016, 7, 7), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 5.7, Date__c = Date.newInstance(2016, 7, 8), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.9, Date__c = Date.newInstance(2016, 7, 9), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 7, 13), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 6.8, Date__c = Date.newInstance(2016, 7, 14), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 6.7, Date__c = Date.newInstance(2016, 7, 15), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.8, Date__c = Date.newInstance(2016, 7, 18), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.8, Date__c = Date.newInstance(2016, 7, 19), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.8, Date__c = Date.newInstance(2016, 7, 19), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.3, Date__c = Date.newInstance(2016, 7, 19), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.2, Date__c = Date.newInstance(2016, 7, 21), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.7, Date__c = Date.newInstance(2016, 7, 22), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.6, Date__c = Date.newInstance(2016, 7, 25), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.2, Date__c = Date.newInstance(2016, 7, 26), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.5, Date__c = Date.newInstance(2016, 8, 2), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.1, Date__c = Date.newInstance(2016, 8, 3), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2, Date__c = Date.newInstance(2016, 8, 8), Employee__c = employee_1.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.6, Date__c = Date.newInstance(2016, 8, 9), Employee__c = employee_1.Id, Client__c = parent.Id));

        timecards.add(new Time_Card__c(Total__c = 1.1, Date__c = Date.newInstance(2016, 4, 28), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.4, Date__c = Date.newInstance(2016, 4, 29), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.3, Date__c = Date.newInstance(2016, 5, 2), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.9, Date__c = Date.newInstance(2016, 5, 4), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 3.6, Date__c = Date.newInstance(2016, 5, 5), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.1, Date__c = Date.newInstance(2016, 5, 10), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.1, Date__c = Date.newInstance(2016, 5, 10), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.1, Date__c = Date.newInstance(2016, 5, 12), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.4, Date__c = Date.newInstance(2016, 5, 12), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.1, Date__c = Date.newInstance(2016, 5, 13), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.2, Date__c = Date.newInstance(2016, 5, 16), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.1, Date__c = Date.newInstance(2016, 5, 17), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.3, Date__c = Date.newInstance(2016, 5, 17), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.1, Date__c = Date.newInstance(2016, 5, 17), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.3, Date__c = Date.newInstance(2016, 5, 17), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.1, Date__c = Date.newInstance(2016, 5, 17), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.3, Date__c = Date.newInstance(2016, 5, 17), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.4, Date__c = Date.newInstance(2016, 5, 19), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.6, Date__c = Date.newInstance(2016, 5, 19), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.4, Date__c = Date.newInstance(2016, 5, 19), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.6, Date__c = Date.newInstance(2016, 5, 19), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.7, Date__c = Date.newInstance(2016, 5, 20), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.7, Date__c = Date.newInstance(2016, 5, 20), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.8, Date__c = Date.newInstance(2016, 5, 23), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.3, Date__c = Date.newInstance(2016, 5, 23), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 5, 25), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0, Date__c = Date.newInstance(2016, 5, 31), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.3, Date__c = Date.newInstance(2016, 6, 3), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.5, Date__c = Date.newInstance(2016, 6, 6), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.7, Date__c = Date.newInstance(2016, 6, 8), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.8, Date__c = Date.newInstance(2016, 6, 8), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.3, Date__c = Date.newInstance(2016, 7, 1), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.2, Date__c = Date.newInstance(2016, 7, 6), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.3, Date__c = Date.newInstance(2016, 7, 6), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.2, Date__c = Date.newInstance(2016, 7, 7), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.2, Date__c = Date.newInstance(2016, 7, 7), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.1, Date__c = Date.newInstance(2016, 7, 8), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 7, 8), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 7, 8), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.6, Date__c = Date.newInstance(2016, 7, 25), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.2, Date__c = Date.newInstance(2016, 7, 26), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.7, Date__c = Date.newInstance(2016, 7, 27), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.9, Date__c = Date.newInstance(2016, 8, 2), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 5.2, Date__c = Date.newInstance(2016, 8, 3), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.7, Date__c = Date.newInstance(2016, 8, 4), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.5, Date__c = Date.newInstance(2016, 8, 4), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2, Date__c = Date.newInstance(2016, 8, 5), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.7, Date__c = Date.newInstance(2016, 8, 5), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.4, Date__c = Date.newInstance(2016, 8, 9), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.2, Date__c = Date.newInstance(2016, 8, 10), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 8, 17), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.4, Date__c = Date.newInstance(2016, 8, 17), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.5, Date__c = Date.newInstance(2016, 8, 18), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.5, Date__c = Date.newInstance(2016, 8, 18), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.2, Date__c = Date.newInstance(2016, 8, 19), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.7, Date__c = Date.newInstance(2016, 8, 19), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.3, Date__c = Date.newInstance(2016, 8, 23), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.7, Date__c = Date.newInstance(2016, 8, 23), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2, Date__c = Date.newInstance(2016, 8, 24), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.9, Date__c = Date.newInstance(2016, 8, 24), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 8, 25), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 5.5, Date__c = Date.newInstance(2016, 8, 25), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 6, Date__c = Date.newInstance(2016, 8, 26), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 8, 26), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.4, Date__c = Date.newInstance(2016, 8, 29), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2, Date__c = Date.newInstance(2016, 8, 30), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.5, Date__c = Date.newInstance(2016, 8, 31), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2, Date__c = Date.newInstance(2016, 8, 31), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 8, 31), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.6, Date__c = Date.newInstance(2016, 8, 31), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.8, Date__c = Date.newInstance(2016, 9, 1), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2, Date__c = Date.newInstance(2016, 9, 1), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.9, Date__c = Date.newInstance(2016, 9, 2), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 2.3, Date__c = Date.newInstance(2016, 9, 2), Employee__c = employee_2.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.7, Date__c = Date.newInstance(2016, 9, 12), Employee__c = employee_2.Id, Client__c = parent.Id));

        timecards.add(new Time_Card__c(Total__c = 1.9, Date__c = Date.newInstance(2016, 3, 23), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.3, Date__c = Date.newInstance(2016, 4, 1), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 5, 5), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.9, Date__c = Date.newInstance(2016, 5, 10), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 5, 13), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 5, 18), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 5, 18), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 5, 18), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1.1, Date__c = Date.newInstance(2016, 5, 31), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.5, Date__c = Date.newInstance(2016, 6, 6), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.2, Date__c = Date.newInstance(2016, 6, 27), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.3, Date__c = Date.newInstance(2016, 7, 7), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2016, 7, 26), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.6, Date__c = Date.newInstance(2016, 7, 28), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.5, Date__c = Date.newInstance(2016, 8, 3), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.5, Date__c = Date.newInstance(2016, 8, 18), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.5, Date__c = Date.newInstance(2016, 8, 23), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.7, Date__c = Date.newInstance(2016, 8, 31), Employee__c = employee_3.Id, Client__c = parent.Id));
        timecards.add(new Time_Card__c(Total__c = 0.5, Date__c = Date.newInstance(2016, 9, 12), Employee__c = employee_3.Id, Client__c = parent.Id));

        insert timecards;

        Test.stopTest();

        BatchCalculateTotalHoursOfTimeCard batch1 = new BatchCalculateTotalHoursOfTimeCard();
        Database.QueryLocatorIterator iter = batch1.start(null).iterator();
        List<sObject> testData = new List<sObject>();
        while (iter.hasNext()) {
            testData.add(iter.next());
        }
        System.debug('Time cards : ' + testData.size());
        Time_Card__c tc1 = (Time_Card__c) testData.get(0);
        Time_Card__c tc2 = (Time_Card__c) testData.get(1);
        System.debug('Time cards : ' + tc1.Time_card_cost__c);
        System.debug('Time cards : ' + tc2.Time_card_cost__c);
        batch1.execute(null, testData);
        BatchUpdateContractServicesSpend batch2 = new BatchUpdateContractServicesSpend(batch1.getServicesSpendMap());
        batch2.execute(null, batch2.start(null));

        DContract__c dcontractFromDB = [SELECT Id, Name, Services_Spend__c FROM DContract__c WHERE Id =: parent.Id];
        System.assertEquals(13780.155, dcontractFromDB.Services_Spend__c);
    }

    static testMethod void shouldCalculateTotalCostAfterUpsert() {
        SFDC_Employee__c employee_1 = new SFDC_Employee__c(Name = 'emp_6', Salary__c = 60000, Exchange_Rate__c = 2,
                                                          Effective_Salary_Date__c = Date.newInstance(2011, 11, 1),
                                                          Effective_Exchange_Rate_Date__c = Date.newInstance(2013, 1, 1));
        insert employee_1;
        DContract__c parent_1 = new DContract__c(Name = 'Sample Parent', Status__c = 'Active', Requires_Report_Out__c = 'No', Intracompany_Sub_contract__c = 'No');
        insert parent_1;

        // After update Salary Salary = 1 * SalaryHistoryHelper.calculateSalary(20000, 2) = 11.50
        Time_Card__c tc_1_employee_1 = new Time_Card__c(Total__c = 0.5, Date__c = Date.newInstance(2010, 12, 30), Employee__c = employee_1.Id, Client__c = parent_1.Id);
        //  After update Salary = 3 * SalaryHistoryHelper.calculateSalary(20000, 2) = 3 * 11.50 = 34,5
        Time_Card__c tc_2_employee_1 = new Time_Card__c(Total__c = 1, Date__c = Date.newInstance(2010, 11, 1), Employee__c = employee_1.Id, Client__c = parent_1.Id);

        List<Time_Card__c> tcList1 = new List<Time_Card__c>();
        tcList1.add(tc_1_employee_1);
        tcList1.add(tc_2_employee_1);
        insert tcList1;
        Test.startTest();

        List<Time_Card__c> tcList2 = new List<Time_Card__c>();
        // Salary = 6 * SalaryHistoryHelper.calculateSalary(40000, 2) = 6 * 22.99 = 137,94
        Time_Card__c tc_3_employee_1 = new Time_Card__c(Total__c = 6, Date__c = Date.newInstance(2011, 1, 1), Employee__c = employee_1.Id, Client__c = parent_1.Id);
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(40000, 3) = 7 * 15.33 = 107,31
        Time_Card__c tc_4_employee_1 = new Time_Card__c(Total__c = 7, Date__c = Date.newInstance(2011, 5, 22), Employee__c = employee_1.Id, Client__c = parent_1.Id);
        // Salary = 1 * SalaryHistoryHelper.calculateSalary(20000, 2) = 8 * 34.48 = 275,84
        Time_Card__c tc_5_employee_1 = new Time_Card__c(Total__c = 8, Date__c = Date.newInstance(2016, 3, 3), Employee__c = employee_1.Id, Client__c = parent_1.Id);
        tcList2.add(tc_3_employee_1);
        tcList2.add(tc_4_employee_1);
        tcList2.add(tc_5_employee_1);

        Time_Card__c tcFromDB1 = [SELECT Id, Total__c FROM Time_Card__c WHERE Id =: tc_1_employee_1.Id LIMIT 1];
        tcFromDB1.Total__c = 1;
        Time_Card__c tcFromDB2 = [SELECT Id, Total__c FROM Time_Card__c WHERE Id =: tc_2_employee_1.Id LIMIT 1];
        tcFromDB2.Total__c = 3;

        tcList2.add(tcFromDB1);
        tcList2.add(tcFromDB2);

        upsert tcList2;

        Test.stopTest();

        Time_Card__c tcFromDB = [SELECT Id, Time_card_cost__c FROM Time_Card__c WHERE Id =: tc_1_employee_1.Id LIMIT 1];
        System.assertEquals(11.50, tcFromDB.Time_card_cost__c);
        tcFromDB = [SELECT Id, Time_card_cost__c FROM Time_Card__c WHERE Id =: tc_2_employee_1.Id LIMIT 1];
        System.assertEquals(34.5, tcFromDB.Time_card_cost__c);
        tcFromDB = [SELECT Id, Time_card_cost__c FROM Time_Card__c WHERE Id =: tc_3_employee_1.Id LIMIT 1];
        System.assertEquals(137.94, tcFromDB.Time_card_cost__c);
        tcFromDB = [SELECT Id, Time_card_cost__c FROM Time_Card__c WHERE Id =: tc_4_employee_1.Id LIMIT 1];
        System.assertEquals(107.31, tcFromDB.Time_card_cost__c);
        tcFromDB = [SELECT Id, Time_card_cost__c FROM Time_Card__c WHERE Id =: tc_5_employee_1.Id LIMIT 1];
        System.assertEquals(275.84, tcFromDB.Time_card_cost__c);
    }

    static testMethod void shouldUseSettingsList() {
        Test.startTest();

        Loaded_Daily_Rate_Settings__c settings_1 = new Loaded_Daily_Rate_Settings__c(Name = 'Test 1', Settings_Effective_Date__c = Date.newInstance(1990, 1, 1), Working_Days__c = 260, Fringe__c = 0.30,
                                          Overhead__c = 52, Fee__c = 10, G_A__c = 10);
        Loaded_Daily_Rate_Settings__c settings_2 = new Loaded_Daily_Rate_Settings__c(Name = 'Test 3', Settings_Effective_Date__c = Date.newInstance(2016, 1, 1), Working_Days__c = 260, Fringe__c = 0.2,
                                          Overhead__c = 30, Fee__c = 10, G_A__c = 10);
        Loaded_Daily_Rate_Settings__c settings_3 = new Loaded_Daily_Rate_Settings__c(Name = 'Test 2', Settings_Effective_Date__c = Date.newInstance(2014, 1, 1), Working_Days__c = 260, Fringe__c = 0.1,
                                          Overhead__c = 70, Fee__c = 15, G_A__c = 15);
        insert settings_1;
        insert settings_2;
        insert settings_3;

        SFDC_Employee__c employee_1 = new SFDC_Employee__c(Name = 'emp_9', Salary__c = 101854.98, Effective_Salary_Date__c = Date.newInstance(2016, 2, 24),
                                                           Exchange_Rate__c = 1, Effective_Exchange_Rate_Date__c = Date.newInstance(2016, 2, 24));
        Test.stopTest();

        SalaryHistoryHelper helper = new SalaryHistoryHelper();
        List<SalaryHistoryRecord> empHistory = helper.mergeSalaryHistory(employee_1);
        System.debug(empHistory);
        System.assertEquals(5, empHistory.size());
        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(5700.83, settings_1), empHistory.get(0).getValue());
        System.assertEquals(Date.newInstance(1900, 1, 1), empHistory.get(0).getValueDate());
        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(5700.83, settings_3), empHistory.get(1).getValue());
        System.assertEquals(Date.newInstance(2014, 1, 1), empHistory.get(1).getValueDate());
        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(11300.39, settings_3), empHistory.get(2).getValue());
        System.assertEquals(Date.newInstance(2015, 11, 12), empHistory.get(2).getValueDate());
        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(11300.39, settings_2), empHistory.get(3).getValue());
        System.assertEquals(Date.newInstance(2016, 1, 1), empHistory.get(3).getValueDate());
        System.assertEquals(SalaryHistoryHelper.calculatePerHourSalary(101854.98, settings_2), empHistory.get(4).getValue());
        System.assertEquals(Date.newInstance(2016, 2, 24), empHistory.get(4).getValueDate());
    }
}