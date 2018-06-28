@RestResource(urlMapping='/KVGetJSONData/*')

global class KVGetJSONData{


    public KVGetJSONData(){}
    
    global class GoalData{
        String GoalName {get; private set;}
        Datetime StartDate {get; private set;}
        Datetime EndDate {get; private set;}
        
        public GoalData(){}
        
        public GoalData(String goalName, Datetime startDate, Datetime endDate){
            this.GoalName = goalName;
            this.StartDate = startDate;
            this.EndDate = endDate;
        }
    }
    
    @HttpPost
    global static GoalData getJSONData() { 
        Goal__c goal = [select Name, Start_Time__c, End_Time__c from Goal__c];
        GoalData obj = new GoalData(goal.Name, goal.Start_Time__c, goal.End_Time__c);

        List<GoalData> gdata = new List<GoalData>();
        gdata.add(obj);
        
        String JSONString = JSON.serialize(gdata);
        System.debug('Serialized list of invoices into JSON format: ' + JSONString);
        
        return obj;
    }    
    
    
    

    
}