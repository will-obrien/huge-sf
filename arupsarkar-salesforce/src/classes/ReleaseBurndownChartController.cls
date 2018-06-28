global with sharing class ReleaseBurndownChartController
{
/*

    static List <Sprint__c> sprintList = new List<Sprint__c> ();
    static List<Product_Backlog_Item__c> pblList = new List<Product_Backlog_Item__c>();
    static List <Release_Burndown_Chart__c> releaseBurndownChartList = new List<Release_Burndown_Chart__c>();
    static Map<Id, List<Release_Burndown_Chart__c>> releaseBurndownMap = new Map<Id, List<Release_Burndown_Chart__c>>();
    static List <Sprint__c> sprintListAll = new List<Sprint__c> ();
    static Map<Id, List<Sprint__c>> sprintMap = new Map<Id, List<Sprint__c>>();
    static Map<Id, List<Sprint__c>> sprintOneMap = new Map<Id, List<Sprint__c>>();
    static integer counter = 0;
    static Map<Id, List<Sprint__c>> sprintMapInclusive = new Map<Id, List<Sprint__c>>();
    static Map<Id, List<Sprint__c>> sprintMapExclusive = new Map<Id, List<Sprint__c>>();
    static Map<Id, decimal> sprintIdExists = new Map<Id, decimal>();
    static Id PBLId ;
    static decimal runningMaxTotal;
    static decimal remainingMaxTotal;
    static decimal finalTotal;
    
    
    public static void SetReleaseBurndownData(Set<Id> sprintIds)
    
    {
    
        try{
        
            runningMaxTotal = 0;
            remainingMaxTotal = 0;
            finalTotal = 0;
            
            //get the sprint record for which the trigger fired
            sprintList = [select Id, Name, Total_Hours__c, ProductBackLogItem__c, Total_Remaining_Hours__c from Sprint__c where Id IN :sprintIds];
            sprintOneMap.put(sprintList[0].Id, new List <Sprint__c> { sprintList[0] } );
            
            
            PBLId = sprintList[0].ProductBackLogItem__c;
            sprintListAll = [select Id, Name, Total_Hours__c, Total_Remaining_Hours__c, ProductBackLogItem__c 
                                from Sprint__c
                                where ProductBackLogItem__c = :sprintList[0].ProductBackLogItem__c];

            if(sprintListAll.size() > 0){
            
                releaseBurndownChartList = [select Id, Running_Hours__c, Sprint__c, Sprint_Name__c
                                                from Release_Burndown_Chart__c
                                                where Product_Backlog_Item__c = :sprintList[0].ProductBackLogItem__c];
                //populate rbl map
                for(Release_Burndown_Chart__c rbc : releaseBurndownChartList){
                    releaseBurndownMap.put(rbc.Id, new List <Release_Burndown_Chart__c> { rbc });
                    sprintIdExists.put(rbc.Sprint__c, rbc.Running_Hours__c);
                }//end of for loop
                
                //populate sprint map
                for(Sprint__c s : sprintListAll){
                    sprintMap.put(s.Id, new List<Sprint__c> { s } );
                    runningMaxTotal = runningMaxTotal + s.Total_Hours__c;
                    remainingMaxTotal = remainingMaxTotal + s.Total_Remaining_Hours__c;
                }//end of for loop
                
                finalTotal = runningMaxTotal - remainingMaxTotal;
                System.debug('~~~~~~~~ Final Total : ' + finalTotal );
                
                //setting the first record
                if(releaseBurndownMap.size() < 1){
                    Release_Burndown_Chart__c rblObj = new Release_Burndown_Chart__c();
                    
                    rblObj.Product_Backlog_Item__c = PBLId;
                    rblObj.Sprint_Name__c = 'Sprint 0';
                    rblObj.Running_Hours__c = runningMaxTotal;
                    insert rblObj;
                    System.debug('~~~~~~~~~ RBI Id : ' + rblObj.Id);
                    //return ;
                }//else{
                
                //setting the affected sprint in RBL
                 for (Id newrblId : sprintOneMap.keyset() ){

                    List <Sprint__c> newSprint = new List<Sprint__c>();
                    newSprint = sprintOneMap.get(newrblId);
                     
                     if(sprintIdExists.containsKey(newrblId)){
                     //update
                        List<Release_Burndown_Chart__c> rblChartTemp = [select Id, Running_Hours__c 
                                                                        from Release_Burndown_Chart__c 
                                                                        where Sprint__c = :newrblId 
                                                                        LIMIT 1];
                         rblChartTemp[0].Running_Hours__c = finalTotal;
                         update rblChartTemp[0];
                     
                     }else{
                     //insert    

                        Release_Burndown_Chart__c newrblObj = new Release_Burndown_Chart__c();
                            
                        newrblObj.Product_Backlog_Item__c = newSprint[0].ProductBackLogItem__c;
                        newrblObj.Sprint_Name__c = newSprint[0].Name;
                        newrblObj.Sprint__c = newSprint[0].Id;
                        newrblObj.Running_Hours__c = finalTotal;                       
                        insert newrblObj;
                        System.debug('~~~~~~~~~~~~~ New RBL Chart Id : ' + newrblObj.Id);                       
                     
                     }
                     
                        
                 }                
                
                
            }

        }catch(Exception e){
            System.debug('~~~~~~~~~ ReleaseBurndownChartController : Error - ' + e);
        }    
    
    }

*/
}