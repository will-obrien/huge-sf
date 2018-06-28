public with sharing class KVGoalManagementEngine
{
    public static List<String> sObjs = new List<String>();

    
    public static void KVGoalEngine(List<SObject> sObjects, List<SObject> sOldObjects)
    {
    
        Set<Id> goalTeamIds = new Set<Id>();
        Set<Id> goalIds = new Set<Id>();
        Map<String, Goal_Team__c> userGoalTeamMap = new Map<String, Goal_Team__c>();
        String objType = getSObjType(sObjects[0]);

        List<Goal_Team__c> goalTeams = 
            getGoalTeams(objType, sObjects, goalTeamIds, userGoalTeamMap);
        
        // Continue only if we have eligible participants
        if(goalTeams.size() > 0)
        {
            List<Goal__c> goals = getGoals(goalTeams, goalIds);
            Map<String, Goal_Achiever__c> previouslyAchieved = 
                getPreviouslyAchieved(goalIds, goalTeamIds);
            List<Goal_Achiever__c> goalAchievers = new List<Goal_Achiever__c>();
            //evaluateGoals(objType, sObjects, goals, previouslyAchieved, userGoalTeamMap, goalAchievers, mInUseIds, OldValue, NewValue);
            evaluateGoals(objType, sObjects, goals, previouslyAchieved, userGoalTeamMap, goalAchievers, sOldObjects);
            insert goalAchievers;
        }
            
    }
    
    private static String getSObjType(SObject so)
    {
    
        String retVal = '';
        
        Map<String, Schema.SObjectType> globalMap = Schema.getGlobalDescribe();
        sObjs = new List<String>(globalMap.keySet());
        
        sObjs.sort();
        
        for(SObjectType sobjType : globalMap.values()){
            if(so.getsObjectType() == sobjType){
                retVal = sobjType.getDescribe().getLabel();
                System.debug('~~~~~~~~~~~~~~~~ sObject Name : ' + retVal);
                
                break;
            }
            
        }
        
        try{
            FieldMapping__c fieldMapping = [SELECT Object_API_Name__c from FieldMapping__c where Object_Name__c = :retVal LIMIT 1];
            retVal = fieldMapping.Object_API_Name__c;
            System.debug('~~~~~~~~~~~~~~~~ sObject API Name : ' + retVal);        
        }catch(Exception e){
        
        }        



        return retVal;
    }
    

    private static List<Goal_Team__c> getGoalTeams(String objType, List<SObject> sObjects, 
        Set<Id> goalTeamIds, Map<String, Goal_Team__c> userGoalTeamMap)
    {
        List<Id> ownerIds = new List<Id>();
        for(SObject so : sObjects)
            ownerIds.add((Id) so.get('OwnerId'));
        List<Goal_Team__c> goalTeams = [SELECT Id, Goal__c, User__c, Goal__r.Id, User__r.Email  
            FROM Goal_Team__c WHERE Goal__r.Object__c = :objType AND User__c IN :ownerIds];

        for(Goal_Team__c g : goalTeams)
        {
            goalTeamIds.add(g.Id);
            userGoalTeamMap.put((g.User__c + '' + g.Goal__r.Id).toLowerCase(), g);
        }
        return goalTeams;
    }
    
    private static List<Goal__c> getGoals(List<Goal_Team__c> goalTeams, Set<Id> goalIds)
    {
        for(Goal_Team__c gp : goalTeams)
            goalIds.add(gp.Goal__r.Id);

        return [SELECT Id, Object__c, Field_Name__c, From_Field_Value__c, To_Field_Value__c,
                        Start_Time__c, End_Time__c 
                    FROM Goal__c WHERE Id IN :goalIds];

    }
    

    private static Map<String, Goal_Achiever__c> getPreviouslyAchieved(Set<Id> goalIds, 
        Set<Id> goalTeamIds)
    {
        Map<String, Goal_Achiever__c> retVal = new Map<String, Goal_Achiever__c>();
        List<Goal_Achiever__c> tmpList = [
            SELECT Id, Goal_Team__c, Goal_Team__r.Goal__c, Goal_Team__r.User__c, Object_Name__c, Object_Id__c  
            FROM Goal_Achiever__c 
            WHERE Goal_Team__r.Goal__c IN :goalIds AND Goal_Team__c IN :goalTeamIds];
        
        for(Goal_Achiever__c g : tmpList)
        {
            String qObject = '';
            qObject = g.Object_Id__c;

            retVal.put((g.Goal_Team__r.Goal__c + '' + g.Goal_Team__r.User__c + qObject).toLowerCase(), g);
                
        }
        return retVal;
    }
    

    private static void evaluateGoals(String objType, List<SObject> sObjects, List<Goal__c> goals, 
        Map<String, Goal_Achiever__c> previouslyAchieved, 
        Map<String, Goal_Team__c> userGoalTeamMap, List<Goal_Achiever__c> goalAchievers,
        List<SObject> sOldObjects)
    {
        for(Goal__c g : goals)
        {
            for(SObject s : sObjects)
            {
                FieldMapping__c fieldMapping = [SELECT Name, Object_Name__c, 
                                                    Field_Name__c, API_Name__c FROM FieldMapping__c
                                                    WHERE Object_Name__c = :g.Object__c AND Field_Name__c = :g.Field_Name__c];

                
                //check for insert operation, sOldObjects will be null
                if(sOldObjects != null){
                    if(((String)sOldObjects[0].get(fieldMapping.API_Name__c) == g.From_Field_Value__c && 
                                (String) s.get(fieldMapping.API_Name__c) == g.To_Field_Value__c) &&
                                ((DATETIME)s.get('LastModifiedDate') >= g.Start_Time__c && (DATETIME)s.get('LastModifiedDate') <= g.End_Time__c) &&
                                !previouslyAchieved.containsKey((g.Id + '' + (String) s.get('OwnerId') + s.Id).toLowerCase()) && 
                                userGoalTeamMap.containsKey(((String) s.get('OwnerId') + g.Id).toLowerCase()))
                    {
                        //create a Goal Achiever Object
                        Goal_Achiever__c tmp = new Goal_Achiever__c();
                        tmp.Goal_Team__c = 
                            userGoalTeamMap.get(((String) s.get('OwnerId') + g.Id).toLowerCase()).Id;
                        
                        tmp.Object_Id__c = s.Id;
                        tmp.Object_Name__c = s.getsObjectType().getDescribe().getLabel();
                        tmp.Email__c = userGoalTeamMap.get(((String) s.get('OwnerId') + g.Id).toLowerCase()).User__r.Email;
                        tmp.url__c = URL.getSalesforceBaseUrl().toExternalForm() + '/' + s.Id;
                        
                        goalAchievers.add(tmp);                        
                        
                    }
                
                }else{
                    if(((String) s.get(fieldMapping.API_Name__c) == g.To_Field_Value__c) &&
                        ((DATETIME)s.get('LastModifiedDate') >= g.Start_Time__c && (DATETIME)s.get('LastModifiedDate') <= g.End_Time__c) &&
                        !previouslyAchieved.containsKey((g.Id + '' + (String) s.get('OwnerId') + s.Id).toLowerCase()) && 
                        userGoalTeamMap.containsKey(((String) s.get('OwnerId') + g.Id).toLowerCase()))
                    {
                        //create a Goal Achiever Object
                        Goal_Achiever__c tmp = new Goal_Achiever__c();
                        tmp.Goal_Team__c = 
                            userGoalTeamMap.get(((String) s.get('OwnerId') + g.Id).toLowerCase()).Id;
                       
                        tmp.Object_Id__c = s.Id; 
                        tmp.Object_Name__c = s.getsObjectType().getDescribe().getLabel();
                        tmp.Email__c = userGoalTeamMap.get(((String) s.get('OwnerId') + g.Id).toLowerCase()).User__r.Email;
                        tmp.url__c = URL.getSalesforceBaseUrl().toExternalForm() + '/' + s.Id;                        

                        goalAchievers.add(tmp);

                    }                             
                }
            

            }
        }
    }
        


}