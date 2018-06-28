public with sharing class GoalConfiguration_Controller 
{

    public static final String SSCHEDULESTATUS = 'ScheduleStatus';
    public List<Goal_Achiever__c> goalQualifiers {get; set;}
    public Boolean hasErrors {get; private set;}
    public String errorMessage {get; private set;}
    public Boolean showCompleted {get; set;}
    public Boolean listHasItems {get{return (this.goalQualifiers.size() > 0); } private set;} 
    
    public Boolean isScheduleEnabled
    {
        get
        {
            Boolean retVal = false;
            GoalSchedule__c gs = GoalStaticMethods.getOrCreateGoalSchedule();
            if(gs.CronId__c != null && [SELECT count() FROM CronTrigger WHERE Id = :gs.CronId__c] == 1)
                retVal = true;
            return retVal;
        }
        private set;
    }
    public String scheduleStatus {get{return (this.isScheduleEnabled == false ? 'Stopped' : 'Running');}}
    
    public Boolean hasGoalQualifiers 
    { 
        get
        {
            Boolean retVal = false;
            if(this.goalQualifiers.size() > 0)
                for(Goal_Achiever__c gq : this.goalQualifiers)
                    if(gq.Status__c != 'Complete')
                        retVal = true;

            return retVal;
        }
        private set; 
    }

    public GoalConfiguration_Controller()
    {
        GoalSchedule__c gs = GoalStaticMethods.getGoalSchedule();
        System.debug('~~~~~~~~~ GoalConfiguration_Controller Constructor : ' + gs.Id + ', gs.Show_Completed__c : ' + gs.Show_Completed__c);
        
        if(gs != null)
            this.showCompleted = gs.Show_Completed__c;
            
        System.debug('~~~~~~~~~ GoalConfiguration_Controller Constructor : this.showCompleted ' + this.showCompleted);            
        loadGoalQualifiers();
    }
    
    private void loadGoalQualifiers()
    {
        String query = 'SELECT Id, Name, Account__c, Account__r.Name, Contact__c, Contact__r.Name, Lead__c, Lead__r.Name, ';
        query += 'Opportunity__c, Opportunity__r.Name, Goal_team__c, Goal_Team__r.User__c, ';
        query += 'Goal_Team__r.User__r.Name, CreatedDate, Status__c, Object_Name__c, Description__c ';
        query += 'FROM Goal_Achiever__c ';
        if(this.showCompleted != true)
            query += 'WHERE Status__c != \'complete\' ';
        query += 'ORDER BY CreatedDate';
        
        this.goalQualifiers = Database.query(query);
    }

    public PageReference enableSchedule()
    {
        GoalSchedule__c gs = GoalStaticMethods.getOrCreateGoalSchedule();
        
        try
        {
            gs.CronId__c = System.schedule('GoalSchedule', GoalSchedule.CRON_EXP, new GoalSchedule());
            update gs;
        }
        catch(Exception e)
        {
            this.hasErrors = true;
            this.errorMessage = e.getMessage();
            
            if(this.errorMessage.contains('is already scheduled for execution'))
                this.errorMessage += '   Delete GoalSchedule and try again (Name | Setup | Monitoring | Scheduled Jobs)';
        }

        return null;
    }

    public PageReference disableSchedule()
    {
        GoalSchedule__c gs = GoalStaticMethods.getOrCreateGoalSchedule();

        try
        {
            System.abortJob(gs.CronId__c);
        }
        catch(Exception e)
        { 
            // Job may have been canceled manually 
        }
        
        // Set CronId to null and update, whether the above succeeded or failed
        gs.CronId__c = null;
        update gs;

        return null;
    }
    
    public PageReference processQueue()
    {
        GoalScheduleExecute.processQueue();
        return null;
    }

    public PageReference toggleShowCompleted()
    {
        GoalSchedule__c gs = GoalStaticMethods.getOrCreateGoalSchedule();
        System.debug('~~~~~~~~~~ Goal Controller : toggleShowCompleted Schedule Id : ' + gs.Id);
        gs.Show_Completed__c = this.showCompleted;
        update gs;
        loadGoalQualifiers();

        return null;
    }
    
}