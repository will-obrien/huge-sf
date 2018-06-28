global with sharing class SprintTaskBurndownAnalyticsController
{
    /*
    static List<Sprint_Task__c> sprintTask = new List<Sprint_Task__c>();
    static List<Sprint_Task__c> sprintTasks = new List<Sprint_Task__c>();
    static List<Sprint_Burndown__c> sprintBurndown = new List<Sprint_Burndown__c>();
    static decimal avgHours = 0.00;
    static decimal totHours = 0.00;
    static decimal totRemainingHours = 0.00;
    static decimal runningTempTotal = 0.00;
    static decimal totStoryPoints = 0.00;
    static Datetime sprintTaskDate;
    static Datetime sprintActivityDate;
    static boolean checkUpdate = false;
    static Id sprintId;

    public static void SetSprintTaskBurndownData(Set<Id> sprintTaskIds)
    {
        
        sprintTask = [select s.Id, s.LastModifiedDate, s.Activity_Date__c, s.SprintTask__c, s.Estimation__c, s.Remaining__c
                        from Sprint_Task__c s
                        where Id IN :sprintTaskIds ];

        sprintTaskDate = sprintTask[0].LastModifiedDate;
        sprintActivityDate = sprintTask[0].Activity_Date__c;
        sprintId = sprintTask[0].SprintTask__c;
        
        System.debug('~~~~~~~~~~~~~ Last Modified Date : ' + sprintTaskDate);
        System.debug('~~~~~~~~~~~~~ Sprint Activity Date : ' + sprintActivityDate);
        System.debug('~~~~~~~~~~~~~ Sprint Id : ' + sprintId);
        
        //update total hours, total remaining hours and story points in Sprint object.
        Sprint__c sprint = [select Id, Total_Hours__c, 
                                Total_Remaining_Hours__c, Total_Story_Points__c 
                                from Sprint__c where Id = :sprintId];
        
        
        AggregateResult[] groupedResults = [SELECT SprintTask__c sprintId, AVG(Estimation__c) avgEstmatedHours,
                                                SUM(Estimation__c) totEstmatedHours, SUM(Remaining__c) totRemainingHours,
                                                SUM(Story_Points__c) totStoryPoints
                                                FROM Sprint_Task__c
                                                WHERE SprintTask__c = :sprintTask[0].SprintTask__c
                                                GROUP BY SprintTask__c];
        for (AggregateResult ar : groupedResults)  {
            System.debug('~~~~~~ Sprint ID : ' + ar.get('sprintId'));
            System.debug('~~~~~~ Average amount : ' + ar.get('avgEstmatedHours'));
            avgHours = Double.ValueOf(ar.get('avgEstmatedHours'));
            totHours = Double.ValueOf(ar.get('totEstmatedHours'));
            totRemainingHours = Double.ValueOf(ar.get('totRemainingHours'));
            totStoryPoints = Double.ValueOf(ar.get('totStoryPoints'));
        }
        
        sprint.Total_Hours__c = totHours;
        sprint.Total_Remaining_Hours__c = totRemainingHours;
        sprint.Total_Story_Points__c = totStoryPoints;
        
        update sprint;
        
        sprintBurndown = [SELECT Id, Activity_Date__c, Total_Hours__c, Total_Remaining_Hours__c
                        FROM Sprint_Burndown__c 
                        WHERE Sprint__c = :sprintTask[0].SprintTask__c
                        AND Active__c = true
                        ORDER BY Activity_Date__c ASC ];
                        
        integer counter = 0; 
        integer sprintBurndownSize =  sprintBurndown.size();
        
        System.debug('~~~~~~~~~~ Sprint burndown Size : ' + sprintBurndownSize);
                              
        for(Sprint_Burndown__c s : sprintBurndown){
            //Sprint_Burndown__c sbc = new Sprint_Burndown__c();
            if(counter == 0){
                s.Total_Hours__c = totHours - (totHours/sprintBurndownSize);
                //s.Total_Remaining_Hours__c = totHours;
                runningTempTotal = s.Total_Hours__c;
                
                System.debug('~~~~~~~~~~~ SprintTaskBurndownAnalyticsController - ' + counter + '.) ' + 'running Total - ' + runningTempTotal);
                
            }else{
                s.Total_Hours__c = runningTempTotal - (totHours/sprintBurndownSize); 
                runningTempTotal =  s.Total_Hours__c;
                System.debug('~~~~~~~~~~~ SprintTaskBurndownAnalyticsController - ' + counter + '.) ' + 'running Total - ' + runningTempTotal);                
            }
            System.debug('~~~~~~~~~~~~~~~ Sprint burndown date : ' + Date.valueOf(s.Activity_Date__c));
             
            if(sprintActivityDate != null && sprintActivityDate.isSameDay(s.Activity_Date__c)){
                s.Total_Remaining_Hours__c = totRemainingHours;
                checkUpdate = true;
            }
            
            if(!checkUpdate && sprintTaskDate.isSameDay(s.Activity_Date__c)){
                s.Total_Remaining_Hours__c = totRemainingHours;
                checkUpdate = false; 
            }            
            counter++;
            update s;
        }                        
    
    }
	*/
}