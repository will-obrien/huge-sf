public with sharing class TimelineDataModel {
    public String ActivityId{get;set;}
    public String Activity{get;set;}
    public DateTime ActivityDate{get;set;}
    public Map<String,String> ActivityDetailedData{get;set;}
    public TimelineDataModel(String activityIdParam,String activityParam,DateTime activityDateParam,Map<String,String> detailedData){
        ActivityId=activityIdParam;
        Activity=activityParam;
        ActivityDate=activityDateParam;
        ActivityDetailedData=detailedData;
    }
}