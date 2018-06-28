/**
 * Test helper class used for mocking salary history.
 */
public class SalaryHistoryMock {

    public static List<SalaryHistoryWrapper> getFieldHistory(SFDC_Employee__c employee, String fieldName) {
        List<SalaryHistoryWrapper> records = new List<SalaryHistoryWrapper>();
        if (employee.Name == 'emp_1') {
            if (fieldName == 'Salary__c') {
                records.add(new SalaryHistoryWrapper(null, 10000, DateTime.newInstance(2015, 2, 14, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(10000, 20000, DateTime.newInstance(2015, 4, 14, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(20000, 30000, DateTime.newInstance(2015, 6, 14, 10, 0, 0)));
            } else {
                records.add(new SalaryHistoryWrapper(null, Date.newInstance(2015, 6, 1), DateTime.newInstance(2015, 6, 14, 10, 0, 0)));
            }
        } else if (employee.Name == 'emp_3') {
            if (fieldName == 'Salary__c') {
                records.add(new SalaryHistoryWrapper(50000, 60000, DateTime.newInstance(2014, 1, 1, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(60000, 70000, DateTime.newInstance(2015, 1, 1, 12, 0, 0)));
                records.add(new SalaryHistoryWrapper(70000, 80000, DateTime.newInstance(2016, 9, 10, 2, 22, 0)));
            }
        } else if (employee.Name == 'emp_4') {
            if (fieldName == 'Salary__c') {
                records.add(new SalaryHistoryWrapper(null, 17000, DateTime.newInstance(2015, 2, 2, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(17000, 13000, DateTime.newInstance(2015, 4, 14, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(13000, 34000, DateTime.newInstance(2015, 4, 14, 11, 0, 0)));
            } else {
                records.add(new SalaryHistoryWrapper(null, Date.newInstance(2013, 3, 7), DateTime.newInstance(2015, 2, 2, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(Date.newInstance(2013, 3, 7), Date.newInstance(2015, 6, 1), DateTime.newInstance(2015, 4, 14, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(Date.newInstance(2015, 6, 1), Date.newInstance(2015, 1, 1), DateTime.newInstance(2015, 4, 14, 11, 0, 0)));
            }
        } else if (employee.Name == 'emp_6') {
            if (fieldName == 'Salary__c') {
                records.add(new SalaryHistoryWrapper(null, 20000, DateTime.newInstance(2010, 1, 1, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(20000, 40000, DateTime.newInstance(2011, 1, 1, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(40000, 60000, DateTime.newInstance(2012, 1, 1, 10, 0, 0)));
            } else if (fieldName == 'Effective_Salary_Date__c') {
                records.add(new SalaryHistoryWrapper(null, Date.newInstance(2011, 11, 1), DateTime.newInstance(2012, 1, 1, 10, 0, 0)));
            } else if (fieldName == 'Exchange_Rate__c') {
                records.add(new SalaryHistoryWrapper(null, 2, DateTime.newInstance(2010, 2, 2, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(2, 3, DateTime.newInstance(2011, 2, 14, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(3, 2, DateTime.newInstance(2013, 1, 1, 10, 0, 0)));
            } else {
                records.add(new SalaryHistoryWrapper(null, Date.newInstance(2012, 1, 1), DateTime.newInstance(2013, 1, 1, 10, 0, 0)));
            }
        } else if (employee.Name == 'emp_8') {
            if (fieldName == 'Exchange_Rate__c') {
                records.add(new SalaryHistoryWrapper(4, 2, DateTime.newInstance(2014, 9, 9, 10, 0, 0)));
            } else if (fieldName == 'Effective_Exchange_Rate_Date__c') {
                records.add(new SalaryHistoryWrapper(Date.newInstance(2012, 5, 5), Date.newInstance(2013, 6, 1), DateTime.newInstance(2014, 9, 9, 10, 0, 0)));
            }
        } else if (employee.Name == 'emp_12') {
            if (fieldName == 'Exchange_Rate__c') {
                records.add(new SalaryHistoryWrapper(0, 0.016, DateTime.newInstance(2014, 1, 1, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(0.016, 3, DateTime.newInstance(2015, 1, 1, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(3, 2, DateTime.newInstance(2016, 1, 1, 10, 0, 0)));
            } else {
                records.add(new SalaryHistoryWrapper(null, Date.newInstance(2012, 1, 1), DateTime.newInstance(2014, 1, 1, 10, 0, 0)));
                records.add(new SalaryHistoryWrapper(Date.newInstance(2014, 1, 1), Date.newInstance(2014, 6, 1), DateTime.newInstance(2015, 1, 1, 10, 0, 0)));
            }
        }

        return records;
    }

    public static List<SalaryHistoryRecord> getMockMergeData(SFDC_Employee__c employee) {
        System.debug('Using mock merge for Name : ' + employee.Name);
        List<SalaryHistoryRecord> result = new List<SalaryHistoryRecord>();
        if (employee.Name == 'emp_11') {
            result.add(new SalaryHistoryRecord(7700.43, Date.newInstance(1900, 1, 1)));
            result.add(new SalaryHistoryRecord(9900.44, Date.newInstance(2015, 11, 5)));
            result.add(new SalaryHistoryRecord(89319.79, Date.newInstance(2016, 2, 24)));
        } else if (employee.Name == 'emp_10') {
            result.add(new SalaryHistoryRecord(3300.59, Date.newInstance(1900, 1, 1)));
            result.add(new SalaryHistoryRecord(5000.39, Date.newInstance(2015, 11, 05)));
            result.add(new SalaryHistoryRecord(45259.16, Date.newInstance(2016, 2, 24)));
        } else if (employee.Name == 'emp_9') {
            result.add(new SalaryHistoryRecord(5700.83, Date.newInstance(1900, 1, 1)));
            result.add(new SalaryHistoryRecord(11300.39, Date.newInstance(2015, 11, 12)));
            result.add(new SalaryHistoryRecord(101854.98, Date.newInstance(2016, 2, 24)));
        }
        return result;
    }
}