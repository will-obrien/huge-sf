public class Milestone1_Test_Utility {
    
    public static Milestone1_Project__c sampleProject(String name) {
        Milestone1_Project__c rec = new Milestone1_Project__c();
        rec.Name = name;
        return rec;
    }

    public static Milestone1_Project__c sampleProjectActive(String name) {
        Milestone1_Project__c rec = Milestone1_Test_Utility.sampleProject(name);
        rec.Status__c	=	'Active';
        rec.Kickoff__c 	=	Date.today().addDays(-14);
        rec.Deadline__c	=	Date.today().addDays(14);
        return rec;
    }
    public static Milestone1_Milestone__c sampleMilestone(Milestone1_Project__c project) {
        Milestone1_Milestone__c rec = new Milestone1_Milestone__c();
        rec.Name = project.Name + '' + Datetime.now().getTime();
        rec.Project__c = project.id;
        rec.Complete__c = false; //getRandomBool(.25);
        rec.Kickoff__c = project.Kickoff__c;
        rec.Deadline__c = project.Deadline__c;
        rec.Description__c = 'Description for ' + rec.Name;
        rec.Expense_Budget__c = Math.floor(Math.random() * 50000 * 100) / 100;
        rec.Hours_Budget__c = Math.floor(Math.random() * 500 * 100) / 100;
        return rec;
    }
    public static Milestone1_Milestone__c sampleMilestone(Id projectId, Id parentMSId, String name) {
        Milestone1_Milestone__c rec = new Milestone1_Milestone__c();
        rec.Name = name;
        rec.Parent_Milestone__c = parentMSId;
        rec.Project__c = projectId;
        rec.Complete__c = false; //getRandomBool(.25);
        rec.Deadline__c = Date.today().addDays(1);
        rec.Description__c = 'Description for ' + name;
        rec.Expense_Budget__c = Math.floor(Math.random() * 50000 * 100) / 100;
        rec.Hours_Budget__c = Math.floor(Math.random() * 500 * 100) / 100;
        return rec;
    }

    public static Milestone1_Task__c sampleTask(Milestone1_Milestone__c milestone) {
        Milestone1_Task__c rec = new Milestone1_Task__c();
        rec.Project_Milestone__c = milestone.Id;
        rec.Assigned_To__c = UserInfo.getUserId();
        rec.Name = Milestone.Name + ' task ' + Datetime.now().getTime();
        rec.Complete__c = getRandomBool(.25);
        rec.Description__c 	= 'test description ' + rec.Name;
        rec.Start_Date__c 	= milestone.Kickoff__c.addDays(-1);
        rec.Due_Date__c 	= milestone.deadline__c.addDays(-1);
        rec.Estimated_Expense__c = Math.floor(Math.random() * 5000 * 100) / 100;
        rec.Estimated_Hours__c = Math.floor(Math.random() * 50 * 100) / 100;
        return rec;
    }
    
    public static Milestone1_Task__c sampleTask(Id milestoneId) {
        Milestone1_Task__c rec = new Milestone1_Task__c();
        rec.Project_Milestone__c = milestoneId;
        rec.Assigned_To__c = UserInfo.getUserId();
        rec.Name = '12345678901234567890123456789';
        if(Math.random() > .5){
            rec.Name += '123456789012345678901234567890123234567890'; 
        }
        rec.Complete__c 			= getRandomBool(.25);
        rec.Description__c 			= 'test description';
        rec.Start_Date__c 			= Date.today().addDays(1);
        rec.Due_Date__c 			= Date.today().addDays(1);
        rec.Estimated_Expense__c 	= Math.floor(Math.random() * 5000 * 100) / 100;
        rec.Estimated_Hours__c 		= Math.floor(Math.random() * 50 * 100) / 100;
        return rec;
    }
    
    public static Milestone1_Time__c sampleTime(Id taskId) {
        Milestone1_Time__c rec = new Milestone1_Time__c();
        rec.Project_Task__c = taskId;
        rec.Hours__c = Math.floor(Math.random() * 10 * 100) / 100;
        return rec;
    }
    
    public static Milestone1_Expense__c sampleExpense(Id taskId) {
        Milestone1_Expense__c rec = new Milestone1_Expense__c();
        rec.Project_Task__c = taskId;
        rec.Amount__c = Math.floor(Math.random() * 1000 * 100) / 100;
        return rec;
    }
    
    public static Boolean getRandomBool(Decimal oddsOfTrue){
        if(Math.random() <= oddsOfTrue){
            return true;
        }
        return false;
    }
    
    public static Date getRandomDate(Integer rangeFromToday){
        return Date.today().addDays((Math.random() * rangeFromToday * 2 - rangeFromToday).intValue());
    }
    
    public static List<Milestone1_Settings__c> createDefaultCustomChatterSettings()
    {
        
        Milestone1_Settings__c testRule = Milestone1_Settings__c.getOrgDefaults();
        if(testRule == null)
        {
            testRule = new Milestone1_Settings__c();
            testRule.Auto_Follow_Complete_Task__c = true;
            testRule.Auto_Follow_Task__c = true;
            testRule.Auto_Unfollow_Reassignment__c = true;
            testRule.SetupOwnerId = UserInfo.getUserId();
            insert testRule;
        } else {
        	System.debug(testRule);
        }
        List<Milestone1_Settings__c> returnList = new List<Milestone1_Settings__c>{testRule};
        return returnList;
    }
    
}