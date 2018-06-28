public without sharing class TrendingSnapshotsControllerTestUtility {
    
    public static Data_Extract__c createDataExtract(boolean isActive, String name, String daySelector, String operation,
                                                              String reportId, String reportName, String schedule, String soqlQuery, 
                                                              String timeInterval, String extractType, Datetime lastRun, boolean isInsert) {
        
        Data_Extract__c dataExtract = new Data_Extract__c(Active__c = isActive, Dataset_Name__c = name, 
                                                          Day_Date_Selector__c = daySelector, Operation__c = operation, 
                                                          Report_Id__c = reportId, Report_Name__c = reportName, 
                                                          Schedule__c = schedule, SOQL_Query__c = soqlQuery,
                                                          Time_Interval__c = timeInterval, Type__c = extractType, 
                                                          Timestamp__c = lastRun);
        
        if(isInsert) insert dataExtract;
        return dataExtract;
    }
}