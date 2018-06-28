/**
 * Helper class for fetching salary history for employees
 */
public without sharing class SalaryHistoryHelper {

    // Needed for PRO page to avoid SOQL Limit Exception
    private Map<Id, List<SalaryHistoryWrapper>> employeeSalaryList;
    private Map<Id, List<SalaryHistoryWrapper>> employeeSalaryDateList;
    private Map<Id, List<SalaryHistoryWrapper>> employeeExchangeRateList;
    private Map<Id, List<SalaryHistoryWrapper>> employeeExchangeRateDateList;
    private List<LoadedDailyRateSettingsWrapper> dailyRateSettings;

    public SalaryHistoryHelper() {
        this.employeeSalaryList = new Map<Id, List<SalaryHistoryWrapper>>();
        this.employeeSalaryDateList = new Map<Id, List<SalaryHistoryWrapper>>();
        this.employeeExchangeRateList = new Map<Id, List<SalaryHistoryWrapper>>();
        this.employeeExchangeRateDateList = new Map<Id, List<SalaryHistoryWrapper>>();
        loadLoadedDailyRateSettings();
    }

    /**
     * Loads history records from DB for employees from given list
     */
    public void loadHistoryForEmployees(Set<Id> emps) {
        this.employeeSalaryList = fillMap(emps, [SELECT ParentId, OldValue, NewValue, CreatedDate FROM SFDC_Employee__History WHERE ParentId IN: emps AND Field = 'Salary__c' ORDER BY CreatedDate ASC]);
        this.employeeSalaryDateList = fillMap(emps,[SELECT ParentId, OldValue, NewValue, CreatedDate FROM SFDC_Employee__History WHERE ParentId IN: emps AND Field = 'Effective_Salary_Date__c' ORDER BY CreatedDate ASC]);
        this.employeeExchangeRateList = fillMap(emps,[SELECT ParentId, OldValue, NewValue, CreatedDate FROM SFDC_Employee__History WHERE ParentId IN: emps AND Field = 'Exchange_Rate__c' ORDER BY CreatedDate ASC]);
        this.employeeExchangeRateDateList = fillMap(emps,[SELECT ParentId, OldValue, NewValue, CreatedDate FROM SFDC_Employee__History WHERE ParentId IN: emps AND Field = 'Effective_Exchange_Rate_Date__c' ORDER BY CreatedDate ASC]);
    }

    /**
     * Builds employee salary and exchange rate history.
     */
    public List<SalaryHistoryRecord> getHistoryForEmployee(SFDC_Employee__c employee, String salaryField, String dateField) {
        List<SalaryHistoryRecord> salaryList = new List<SalaryHistoryRecord>();
        List<SalaryHistoryWrapper> employeeSalaryHistory = getFieldHistory(employee, salaryField);
        List<SalaryHistoryWrapper> employeeSalaryDateHistory = getFieldHistory(employee, dateField);

        Date lastSalaryDate = Date.newInstance(1900, 1, 1);
        Decimal lastSalary;
        Integer salaryIndex = 0;

        // Cases for first History record:
        // * No history 
        // * Salary is empty and no history
        // * History record which updates from null to value (start value)
        // * History record which updates from first value to second (OldValue field is start value)

        // No history we must fetch data from current record - Effective date for first sallary will be 01.01.1900
        if (employeeSalaryHistory.size() == 0) {
            if (salaryField == 'Salary__c') {
                salaryList.add(new SalaryHistoryRecord(employee.Salary__c == null ? 0 : (Decimal) employee.Salary__c, lastSalaryDate));
            } else {
                salaryList.add(new SalaryHistoryRecord(employee.Exchange_Rate__c == null ? 1 : (Decimal) employee.Exchange_Rate__c, lastSalaryDate));
            }
        } else { // We have salary history

            // If first history record contains OldValue we must take it to the list
            if (employeeSalaryHistory.get(0).OldValue != null && ((Decimal) employeeSalaryHistory.get(0).OldValue) >= 0.1) {
                lastSalary = (Decimal) employeeSalaryHistory.get(0).OldValue;

                if (employeeSalaryDateHistory.size() > 0 && employeeSalaryDateHistory.get(0).OldValue != null && employeeSalaryDateHistory.get(0).CreatedDate == employeeSalaryHistory.get(0).CreatedDate) {
                    lastSalaryDate = (Date) employeeSalaryDateHistory.get(0).OldValue;
                } else {
                    lastSalaryDate = takeDate(employeeSalaryHistory.get(0).CreatedDate);
                }

                salaryList.add(new SalaryHistoryRecord(lastSalary, lastSalaryDate));
            }

            Map <DateTime, Date> effectiveDateMap = new Map<DateTime, Date>();

            Date helperDate = Date.newInstance(1900, 1, 1);
            for (Integer i = 0; i < employeeSalaryDateHistory.size(); i++) {
                effectiveDateMap.put((DateTime) employeeSalaryDateHistory.get(i).CreatedDate,
                                      employeeSalaryDateHistory.get(i).NewValue == null ? helperDate : (Date) employeeSalaryDateHistory.get(i).NewValue);
                if (employeeSalaryDateHistory.get(i).NewValue != null) {
                    helperDate = (Date) employeeSalaryDateHistory.get(i).NewValue;
                }
            }

            Boolean needSort = false;
            for (Integer i = 0; i < employeeSalaryHistory.size(); i++) {

                Decimal currentSalary = (Decimal) employeeSalaryHistory.get(i).NewValue;
                // We must ignore exchange rate < 0.1 - Exception Divide by 0 and reject bad values from old history
                if (currentSalary == null || (currentSalary < 0.1 && salaryField == 'Exchange_Rate__c')) {
                    continue;
                }

                DateTime salCreateDateTime = (DateTime) employeeSalaryHistory.get(i).CreatedDate;
                Date toAdd;

                if (effectiveDateMap.containsKey(salCreateDateTime)) {
                    toAdd = effectiveDateMap.get(salCreateDateTime);
                } else {
                    toAdd = takeDate(salCreateDateTime);
                }
                salaryList.add(new SalaryHistoryRecord(currentSalary, toAdd));

                if (lastSalaryDate > toAdd) {
                    needSort = true;
                }
                lastSalaryDate = toAdd;
            }

            if (needSort) {
                salaryList.sort();
            }
        }

        if (salaryList.size() > 0) {
            SalaryHistoryRecord firstRec = salaryList.get(0);
            firstRec.setValueDate(Date.newInstance(1900, 1, 1));
            salaryList.set(0, firstRec);
        }

        return salaryList;
    }

    public List<SalaryHistoryRecord> mergeSalaryWithExchangeRateHistory(SFDC_Employee__c employee) {
        if (Test.isRunningTest() && (employee.Name == 'emp_9' || employee.Name == 'emp_10' || employee.Name == 'emp_11')) {
            System.debug('Using mock for Name : ' + employee.Name);
            return SalaryHistoryMock.getMockMergeData(employee);
        }

        List<SalaryHistoryRecord> salary = getHistoryForEmployee(employee, 'Salary__c', 'Effective_Salary_Date__c');
        List<SalaryHistoryRecord> exchangeRate = getHistoryForEmployee(employee, 'Exchange_Rate__c', 'Effective_Exchange_Rate_Date__c');
        List<SalaryHistoryRecord> result = new List<SalaryHistoryRecord>();
        Boolean endLoop = false;

        Decimal currentSalary = 0;
        Decimal currentRate = 1;
        Integer salaryIndex = 0;
        Integer exchangeRateIndex = 0;

        while (!endLoop) {

            Date salaryDate = null;
            Date exchangeRateDate = null;

            Decimal sal = 0;
            Decimal rate = 1;

            if (salaryIndex < salary.size()) {
                sal = salary.get(salaryIndex).getValue();
                salaryDate = salary.get(salaryIndex).getValueDate();
            }

            if (exchangeRateIndex < exchangeRate.size()) {
                rate = exchangeRate.get(exchangeRateIndex).getValue();
                exchangeRateDate = exchangeRate.get(exchangeRateIndex).getValueDate();
            }

            Date toAdd = salaryDate;
            if ((salaryDate == null && exchangeRateDate != null) || salaryDate > exchangeRateDate) {
                toAdd = exchangeRateDate;
                currentRate = rate;
                exchangeRateIndex++;
            } else if ((salaryDate != null && exchangeRateDate == null) || salaryDate < exchangeRateDate) {
                currentSalary = sal;
                salaryIndex++;
            } else if (salaryDate == exchangeRateDate) {
                currentSalary = sal;
                currentRate = rate;
                salaryIndex++;
                exchangeRateIndex++;
            } else {
                break;
            }

            result.add(new SalaryHistoryRecord(calculateSalary(currentSalary, currentRate), toAdd));

            if (salaryIndex  >= salary.size() && exchangeRateIndex  >= exchangeRate.size()) {
                break;
            }
        }

        return result;
    }

    public List<SalaryHistoryRecord> mergeSalaryHistory(SFDC_Employee__c employee) {
        List<SalaryHistoryRecord> salary = mergeSalaryWithExchangeRateHistory(employee);
        List<SalaryHistoryRecord> result = new List<SalaryHistoryRecord>();

        Boolean endLoop = false;

        Decimal currentSalary = 0;
        LoadedDailyRateSettingsWrapper currentSettings = this.dailyRateSettings.get(0);
        Integer salaryIndex = 0;
        Integer settingsIndex = 0;

        while (!endLoop) {

            Date salaryDate = null;
            Date settingsDate = null;

            Decimal sal = 0;
            LoadedDailyRateSettingsWrapper settings = null;

            if (salaryIndex < salary.size()) {
                sal = salary.get(salaryIndex).getValue();
                salaryDate = salary.get(salaryIndex).getValueDate();
            }

            if (settingsIndex < this.dailyRateSettings.size()) {
                settings = this.dailyRateSettings.get(settingsIndex);
                settingsDate = this.dailyRateSettings.get(settingsIndex).getSettings().Settings_Effective_Date__c;
            }

            Date toAdd = salaryDate;
            if ((salaryDate == null && settingsDate != null) || salaryDate > settingsDate) {
                toAdd = settingsDate;
                currentSettings = settings;
                settingsIndex++;
            } else if ((salaryDate != null && settingsDate == null) || salaryDate < settingsDate) {
                currentSalary = sal;
                salaryIndex++;
            } else if (salaryDate == settingsDate) {
                currentSalary = sal;
                currentSettings = settings;
                salaryIndex++;
                settingsIndex++;
            } else {
                break;
            }

            result.add(new SalaryHistoryRecord(calculatePerHourSalary(currentSalary, currentSettings.getSettings()), toAdd));

            if (salaryIndex  >= salary.size() && settingsIndex  >= this.dailyRateSettings.size()) {
                break;
            }
        }

        return result;
    }

    public static Decimal calculateSalary(Decimal sal, Decimal er) {
        Double result = (sal / (Double) er);
        return Decimal.valueOf(result).setScale(2);
    }

    public static Decimal calculatePerHourSalary(Decimal sal, Loaded_Daily_Rate_Settings__c settings) {
        Double result = ((sal / settings.Working_Days__c) * (1 + settings.Fringe__c / 100.0)
                            * (1 + settings.Overhead__c / 100.0) * (1 + settings.Fee__c / 100.0)
                            * (1 + settings.G_A__c / 100.0)) / 8.0;
        return Decimal.valueOf(result).setScale(2);
    }

    private Decimal getValueForSalary(String field, SalaryHistoryWrapper record) {
        if (field == 'Exchange_Rate__c') {
            if (record.NewValue != null && ((Decimal) record.NewValue) != 0) {
                return (Decimal) record.NewValue;
            } else if (record.OldValue != null && ((Decimal) record.OldValue) != 0) {
                return (Decimal) record.OldValue;
            } else {
               return 1;
            }
        } else {
            if (record.NewValue != null) {
                return (Decimal) record.NewValue;
            } else if (record.OldValue != null) {
                return (Decimal) record.OldValue;
            } else {
               return 0;
            }
        }
    }

    private List<SalaryHistoryWrapper> getFieldHistory(SFDC_Employee__c employee, String fieldName) {
        if (Test.isRunningTest()) {
            return SalaryHistoryMock.getFieldHistory(employee, fieldName);
        }

        // Check data fom buffor
        if (fieldName == 'Salary__c' && this.employeeSalaryList.containsKey(employee.Id)) {
            return this.employeeSalaryList.get(employee.Id);
        } else if (fieldName == 'Effective_Salary_Date__c' && this.employeeSalaryDateList.containsKey(employee.Id)) {
            return this.employeeSalaryDateList.get(employee.Id);
        } else if (fieldName == 'Exchange_Rate__c' && this.employeeExchangeRateList.containsKey(employee.Id)) {
            return this.employeeExchangeRateList.get(employee.Id);
        } else if (fieldName == 'Effective_Exchange_Rate_Date__c' && this.employeeExchangeRateDateList.containsKey(employee.Id)) {
            return this.employeeExchangeRateDateList.get(employee.Id);
        }

        List<SFDC_Employee__History> records = [SELECT OldValue, NewValue, CreatedDate FROM SFDC_Employee__History WHERE parentId =: employee.Id AND Field =: fieldName ORDER BY CreatedDate ASC];
        List<SalaryHistoryWrapper> salaryHistory = new List<SalaryHistoryWrapper>();
        for (SFDC_Employee__History rec : records) {
            salaryHistory.add(new SalaryHistoryWrapper(rec.OldValue, rec.NewValue, rec.CreatedDate));
        }

        return salaryHistory;
    }

    private Map<Id, List<SalaryHistoryWrapper>> fillMap(Set<Id> emps, List<SFDC_Employee__History> records) {
        Map<Id, List<SalaryHistoryWrapper>> tmpMap = new Map<Id, List<SalaryHistoryWrapper>>();
        for (Id ei: emps) {
            tmpMap.put(ei, new List<SalaryHistoryWrapper>());
        }

        for (SFDC_Employee__History rec : records) {
            List<SalaryHistoryWrapper> salaryHistory = tmpMap.get(rec.ParentId);
            salaryHistory.add(new SalaryHistoryWrapper(rec.OldValue, rec.NewValue, rec.CreatedDate));
            tmpMap.put(rec.ParentId, salaryHistory);
        }

        return tmpMap;
    }

    private Date takeDate(DateTime dt) {
        return Date.newInstance(dt.year(), dt.month(), dt.day());
    }

    private void loadLoadedDailyRateSettings() {
        this.dailyRateSettings = new List<LoadedDailyRateSettingsWrapper>();
        List<Loaded_Daily_Rate_Settings__c> ldrs = Loaded_Daily_Rate_Settings__c.getall().values();

        if (ldrs.size() > 0) {
            for (Loaded_Daily_Rate_Settings__c settings : ldrs) {
                this.dailyRateSettings.add(new LoadedDailyRateSettingsWrapper(settings));
            }
            this.dailyRateSettings.sort();
            this.dailyRateSettings.get(0).getSettings().Settings_Effective_Date__c = Date.newInstance(1900, 1, 1);
            System.debug('Loaded_Daily_Rate_Settings__c ' + this.dailyRateSettings);
        } else {
            this.dailyRateSettings.add(new LoadedDailyRateSettingsWrapper(
                    new Loaded_Daily_Rate_Settings__c(Settings_Effective_Date__c = Date.newInstance(1900, 1, 1), Working_Days__c = 260, Fringe__c = 30,
                                                      Overhead__c = 52, Fee__c = 10, G_A__c = 10)));
        }
    }

    private class LoadedDailyRateSettingsWrapper implements Comparable {

        private Loaded_Daily_Rate_Settings__c settings;

        public LoadedDailyRateSettingsWrapper(Loaded_Daily_Rate_Settings__c settings) {
            this.settings = settings;
        }

        public Loaded_Daily_Rate_Settings__c getSettings() {
            return this.settings;
        }

        public void setSettings(Loaded_Daily_Rate_Settings__c settings) {
            this.settings = settings;
        }

        public Integer compareTo(Object objToCompare) {
            Date dateToCompare = ((LoadedDailyRateSettingsWrapper) objToCompare).getSettings().Settings_Effective_Date__c;
            if (this.getSettings().Settings_Effective_Date__c > dateToCompare) {
                return 1;
            } else if (this.getSettings().Settings_Effective_Date__c < dateToCompare) {
                return -1;
            }
            return 0;
        }
    }
}