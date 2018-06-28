public with sharing class KVApexJobVisualController
{


    public Integer STEP {get;set;}
    public List<Goal_Achiever__c> completedGoalAchievers {get;set;}
    public List<Goal_Achiever__c> incompleteGoalAchievers {get; set;}
    public Boolean ProcessRequests{get; private set;}
    public Boolean hasErrors {get; private set;}
    public String errorMessage {get; private set;}
    public Boolean showCompleted {get; set;}    
    public Boolean listHasItems {get{return (this.incompleteGoalAchievers.size() > 0); } private set;} 
    public Boolean listCompletedItems {get{return (this.completedGoalAchievers.size() > 0); } private set;}

    
    //constructor
    public KVApexJobVisualController()
    {
        /*
        KVApexJobSchedule__c gs = KVApexUtilityEngine.getApexSchedule();
        System.debug('~~~~~~~~~ GoalConfiguration_Controller Constructor : ' + gs.Id + ', gs.JobStatus__c : ' + gs.JobStatus__c);
        
        if(gs != null)
        {
            if(gs.JobStatus__c == 'Complete'){
                this.showCompleted = true;
            }else{
                this.showCompleted = false;
            }
        }


        System.debug('~~~~~~~~~ GoalConfiguration_Controller Constructor : this.showCompleted ' + this.showCompleted);
        */

        STEP = 0;

        loadInCompleteGoalAchievers();
        loadCompletedGoalAchievers();
    }
    
    //This method will In Complete goal achievers
    private void loadInCompleteGoalAchievers()
    {
        String query = 'SELECT Id, Name, Goal_Team__r.Goal__r.Name, ';
        query += 'Goal_team__c, Goal_Team__r.User__c, ';
        query += 'Goal_Team__r.User__r.Name, CreatedDate, Status__c, Object_Name__c, Description__c, Object_Id__c ';
        query += 'FROM Goal_Achiever__c ';
        query += 'WHERE Status__c != \'Complete\' ';
        query += 'ORDER BY CreatedDate desc';
        
        this.incompleteGoalAchievers = Database.query(query);

    }
        
    //This method will show Completed Items
    private void loadCompletedGoalAchievers(){
        String query = 'SELECT Id, Name, Goal_Team__r.Goal__r.Name, ';
        query += 'Goal_team__c, Goal_Team__r.User__c, ';
        query += 'Goal_Team__r.User__r.Name, CreatedDate, Status__c, Object_Name__c, Description__c, Object_Id__c ';
        query += 'FROM Goal_Achiever__c ';
        query += 'WHERE Status__c = \'Complete\' ';
        query += 'ORDER BY CreatedDate desc';
        
        this.completedGoalAchievers = Database.query(query);    
    }
    

    
    public Boolean isApexJobEnabled
    {
        get
        {
            Boolean retVal = false;
            KVApexJobSchedule__c jobSchedule = KVApexUtilityEngine.GetorCreateApexSchedule();
            if(jobSchedule.CronId__c != null && [SELECT count() FROM CronTrigger WHERE Id = :jobSchedule.CronId__c] == 1){
                retVal = true;
            }
                
            return retVal;
        }
        private set;
    }
    public String scheduleStatus {get{return (this.isApexJobEnabled == false ? 'OFF' : 'ON');}}
    
    public Boolean GoalAchieversExist 
    { 
        get
        {
            Boolean retVal = false;
            if(this.incompleteGoalAchievers.size() > 0)
                for(Goal_Achiever__c goalAchiever : this.incompleteGoalAchievers)
                    if(goalAchiever.Status__c != 'Complete')
                        retVal = true;

            return retVal;
        }
        private set; 
    }


  
    


    
    

    //public PageReference enableSchedule()
    public PageReference ApexScheduleON()
    {
        KVApexJobSchedule__c jobSchedule = KVApexUtilityEngine.GetorCreateApexSchedule();
        
        try
        {
            STEP = 1;
            jobSchedule.CronId__c = System.schedule('KV Apex Schedule', KVApexSchedule.CRON_EXP, new KVApexSchedule());
            update jobSchedule;
        }
        catch(Exception e)
        {
            this.hasErrors = true;
            this.errorMessage = e.getMessage();
            
            if(this.errorMessage.contains('is already scheduled for execution'))
                this.errorMessage += '   Delete KV Apex Schedule and try again (Name | Setup | Monitoring | Scheduled Jobs)';
        }

        return null;
    }


    public PageReference UpdateCronId(){
    
        KVApexJobSchedule__c jobSchedule = KVApexUtilityEngine.GetorCreateApexSchedule();
    
        //KVApexJobSchedule__c jobSchedule = [select CronId__c from KVApexJobSchedule__c where CronId__c = :CronId];
        if(jobSchedule.CronId__c != null && jobSchedule.CronId__c.length() > 0){
            System.debug('~~~~~~~~~~ Before Update : ' + jobSchedule.CronId__c);
            jobSchedule.CronId__c = null;
            update jobSchedule;
            System.debug('~~~~~~~~~~ After Update : ' + jobSchedule.CronId__c);
        }

        return null;
    }

    public PageReference ApexScheduleOFF()
    {
        KVApexJobSchedule__c jobSchedule;
        jobSchedule = KVApexUtilityEngine.GetorCreateApexSchedule();

        try
        {
            STEP = 0;
            System.debug('~~~~~~~ Cron Id : ' + jobSchedule.CronId__c);
            System.abortJob(jobSchedule.CronId__c);
            // Reset CronId in custom settings KVApexJobSchedule__c
            //if(jobSchedule.CronId__c != null && jobSchedule.CronId__c.length() > 0){
            //    jobSchedule.CronId__c = null;
            //    update jobSchedule;                        
            //}

        }
        catch(Exception e)
        { 
            this.hasErrors = true;
            this.errorMessage = e.getMessage();
            System.debug('~~~~~~~ Error Message : ' + this.errorMessage);
        }
        


        return null;
    }
    
    public PageReference processAllPendingItemsInQueue()
    {
    
        try{
            ProcessRequests = true;
            KVApexScheduleExecute.KVProcessApexJobQueue();
            loadInCompleteGoalAchievers();
            loadCompletedGoalAchievers();
            
            return null;        
        }catch(Exception e){
        
            ProcessRequests = false;
            return null;
        }

    }

    /*
    public PageReference toggleShowCompleted()
    {
        KVApexJobSchedule__c gs = KVApexUtilityEngine.GetorCreateApexSchedule();
        System.debug('~~~~~~~~~~ Goal Controller : toggleShowCompleted Schedule Id : ' + gs.Id);
        if(this.showCompleted){
            gs.JobStatus__c = 'Complete';
        }else{
            gs.JobStatus__c = 'In Complete';
        }
        
        update gs;
        loadInCompleteGoalAchievers();

        return null;
    }
    */

}