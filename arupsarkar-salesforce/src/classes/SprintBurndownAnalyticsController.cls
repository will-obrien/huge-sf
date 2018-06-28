public with sharing class SprintBurndownAnalyticsController{

	/*

    static integer totalNumberofSprintDays = 0;
    static List<Sprint__c> sprintList = new List<Sprint__c>();
    static List< Sprint_Burndown__c > sprintBurndownList = new List < Sprint_Burndown__c >();
    static Set<Id> sprintBurndownUpdatedDateSet = new Set <Id>();
    static List<Sprint_Task__c> sprintTaskList = new List<Sprint_Task__c>();
    static DateTime sprintActivityDate ;
    static DateTime tempDateTime;
    static DateTIme sprintActivityDateTemp;
    static DateTime tempSprintDateTime;
    static Map< DateTime, Id > sprintChartMap = new Map<DateTime, Id>();
    static Map< DateTime, Id > sprintDateMap = new Map<DateTime, Id>(); 
    static List<Sprint_Burndown__c> sprintChart = new List<Sprint_Burndown__c>();
    static integer mapCount = 0;
    static Set<Id> sprintBurndownInactiveList = new Set<Id>();
    static Set<Id> sprintBurndownActiveList = new Set<Id>();
    static String productOwnerEmailAddress;
    static String scrumMasterEmailAddress;

    public static void SetSprintBurndownData(Set<Id> sprintIds){
    
        try{
        

        
            sprintList = [select s.Id, s.Start_Date__c, s.End_Date__c, s.ProductBackLogItem__c
                                from Sprint__c s 
                                where Id IN :sprintIds
                                and Sprint_Planning__c = 'Final'
                                and Status__c = 'Open'];
                                
            //get the email address from the Agile project object.
            Product_Backlog_Item__c pbi = [select ProductBacklog__c 
                                                from Product_Backlog_Item__c 
                                                where Id = :sprintList[0].ProductBackLogItem__c LIMIT 1];
            AgileProject__c ap = [select Product_Owner__c, Scrum_Master__c 
                                    from AgileProject__c 
                                    where Id = :pbi.ProductBacklog__c LIMIT 1];
            
            Team_Member__c productOwnerEmail = [select Email__c from Team_Member__c where Id = :ap.Product_Owner__c LIMIT 1];
            Team_Member__c scrumMasterEmail = [select Email__c from Team_Member__c where Id = :ap.Scrum_Master__c LIMIT 1];  
            
            productOwnerEmailAddress = productOwnerEmail.Email__c;
            scrumMasterEmailAddress = scrumMasterEmail.Email__c;
            
            System.debug('~~~~~~~~~~~~~ Product Owner Email : ' + productOwnerEmailAddress);                                                                                  
            System.debug('~~~~~~~~~~~~~ Scrum Master Email : ' + scrumMasterEmail.Email__c);                                                
                                                                                
                                
            sprintChart = [select Id, Activity_Date__c 
                                from Sprint_Burndown__c 
                                where Sprint__c IN :sprintIds];
            
            for(Sprint_Burndown__c s : sprintChart){
                sprintChartMap.put(s.Activity_Date__c, s.Id);
            }
            //total number of days in Sprint Burndown Chart            
            mapCount = sprintChartMap.size();
            //get the # of sprint days
            totalNumberofSprintDays = sprintList[0].Start_Date__c.Date().daysBetween(sprintList[0].End_Date__c.Date());
            System.debug('~~~~~~ # of days : ' + totalNumberofSprintDays);
            
            tempDateTime = sprintList[0].Start_Date__c;
            tempSprintDateTime = tempDateTime;

            
            for(integer i = 0 ; i <= totalNumberofSprintDays ; i++){
                //This will track the date modification in sprint dates and 
                //accordingly update the sprint burndown chart                
                if(i == 0){
                    sprintActivityDateTemp = tempSprintDateTime;
                }else{
                    sprintActivityDateTemp = tempSprintDateTime.addDays(1);
                    tempSprintDateTime = sprintActivityDateTemp;                    
                }
                sprintDateMap.put(sprintActivityDateTemp, sprintList[0].Id);

                if(!(sprintChartMap.containsKey(sprintActivityDateTemp)) ){
                    //if(i == 0 ){
                    //    sprintActivityDate = sprintActivityDateTemp;
                    //}else{
                    //    sprintActivityDate = tempDateTime.addDays(1);
                    //}                
                    Sprint_Burndown__c sprintBurndown = new Sprint_Burndown__c();                
                    sprintBurndown.Sprint__c = sprintList[0].Id;
                    //sprintBurndown.Activity_Date__c = sprintActivityDate;
                    sprintBurndown.Activity_Date__c = sprintActivityDateTemp;
                    sprintBurndown.Active__c = true;
                    sprintBurndown.Product_Master_Email__c = productOwnerEmailAddress;
                    sprintBurndown.Scrum_Master_Email__c = scrumMasterEmailAddress;
                    insert sprintBurndown;                
                    
                    sprintBurndownUpdatedDateSet.add(sprintBurndown.Sprint__c);
                    System.debug('~~~~~~~Parent Sprint Id : ' + sprintBurndown.Sprint__c);
                    System.debug('~~~~~~ Day : ' + i + ', Date : ' + sprintActivityDateTemp );
                    //tempDateTime = sprintActivityDate;                    
                }
            }
            
            //update rest of the Sprint Burndown dates as inactive if the sprint dates are modified.
            if(mapCount != 0){
                for(DateTime tmpchartDate : sprintChartMap.keySet()){
                    if(!sprintDateMap.containsKey(tmpchartDate)){
                        System.debug('~~~~~~~ Inactive Chart Id : ' + sprintChartMap.get(tmpchartDate));
                        sprintBurndownInactiveList.add(sprintChartMap.get(tmpchartDate));
                    }
                    if(sprintDateMap.containsKey(tmpchartDate)){
                        sprintBurndownActiveList.add(sprintChartMap.get(tmpchartDate));   
                    }
                }
            }
            
            //Inactivate Dates

            integer counter = 0;
            List<Sprint_Burndown__c> sprintBurndownInactivateList = [select Id, Active__c from Sprint_Burndown__c where Id IN :sprintBurndownInactiveList];
            for(Sprint_Burndown__c s : sprintBurndownInactivateList){
                sprintBurndownInactivateList[counter].Active__c = false;
                counter++;
            }
            update sprintBurndownInactivateList;
            //Activate Dates

            counter = 0;
            List<Sprint_Burndown__c> sprintBurndownActivateList = [select Id, Active__c from Sprint_Burndown__c where Id IN :sprintBurndownActiveList];
            for(Sprint_Burndown__c s : sprintBurndownActivateList){
                sprintBurndownActivateList[counter].Active__c = true;
                counter++;
            }
            update sprintBurndownActivateList;                    
            
            //If new sprint dates have been modified, then update the sprint task
            //to trigger calculation of sprint chart
            System.debug('~~~~~~~~~~~ Sprint Set size : ' + sprintBurndownUpdatedDateSet.size());
            //System.debug('~~~~~~~~~~ Parent Sprint Id : ' + sprintBurndownUpdatedDateSet);
            
            //reset trigger processing helper so that it does not get into infinite loop
            if(!SprintTaskTriggerProcessingHelper.beforeProcessing()){
                SprintTaskTriggerProcessingHelper.afterProcessing();
                if(sprintBurndownUpdatedDateSet.size() > 0){
                    sprintTaskList = [select Id, Sprint_Modified_Date__c from Sprint_Task__c where SprintTask__c IN :sprintBurndownUpdatedDateSet LIMIT 1]  ;         
                    if(sprintTaskList.size() > 0){
                        System.debug('~~~~~~~~~~~ Sprint Task Modified Date : ' + System.Today());                
                        sprintTaskList[0].Sprint_Modified_Date__c = System.Today();
                        update sprintTaskList;
                    }            
                }            
            }

            

            
        }catch(Exception e){
            System.debug('~~~~~~ Class: SprintBurndownAnalyticsController: Method:  SetSprintBurndownData ' + e);
        }
    
    }
	*/    
}