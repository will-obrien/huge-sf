public with sharing class Milestone1_Clone_Project_Controller {
    
    public Milestone1_Project__c rec {get; set;}
    public Milestone1_Project__c dummyProj {get; set;}
    private List<Milestone1_Milestone__c> milestones {get; set;}
    private List<Milestone1_Task__c> tasks {get; set;}

    public Milestone1_Clone_Project_Controller(ApexPages.StandardController stc){
        //query project record
        rec = [SELECT Id,
                      Name,
                      Deadline__c,
                      Description__c,
                      Status__c,
                      Total_Expense_Budget__c,
                      Total_Hours_Budget__c
               FROM Milestone1_Project__c
               WHERE Id = :stc.getId()
              ];
        
        //query milestone records
        milestones = [SELECT Id,
                             Name,
                             Parent_Milestone__c,
                             Complete__c,
                             Deadline__c,
                             Description__c,
                             Expense_Budget__c,
                             Hours_Budget__c,
                             OwnerId
                      FROM Milestone1_Milestone__c
                      WHERE Project__c = :rec.Id
                     ];
        
        //query task records
        tasks = [SELECT Id,
                        Name,
                        Project_Milestone__c,
                        Assigned_To__c,
                        Complete__c,
                        Description__c,
                        Due_Date__c
                 FROM Milestone1_Task__c
                 WHERE Project_Milestone__r.Project__c = :rec.Id
                ];
                
        dummyProj = new Milestone1_Project__c();
        dummyProj.Name = 'Copy of ' + rec.Name;
    }
    
    public PageReference createClone(){
        //create new project record
        rec.Name = dummyProj.Name;
        Milestone1_Project__c newProj = Milestone1_Clone_Utility.cloneProject(rec);
        insert newProj;
        
        //separate milestone records into parents and subs
        List<Milestone1_Milestone__c> topMilestones = new List<Milestone1_Milestone__c>();
        List<Milestone1_Milestone__c> bottomMilestones = new List<Milestone1_Milestone__c>();
        for(Milestone1_Milestone__c oldMS : milestones){
            if(oldMS.Parent_Milestone__c == null){
                topMilestones.add(oldMS);
            } else {
                bottomMilestones.add(oldMS);
            }
        }
        
        //clone and insert top milestone records
        Map<String, Milestone1_Milestone__c> newTopMilestoneMap = Milestone1_Clone_Utility.cloneMilestonesIntoMap(topMilestones);
        for(Milestone1_Milestone__c newMS : newTopMilestoneMap.values()){
            newMS.Project__c = newProj.Id;
        }
        insert newTopMilestoneMap.values();
        
        //clone and insert sub milestone records
        Map<String, Milestone1_Milestone__c> newBottomMilestoneMap = Milestone1_Clone_Utility.cloneMilestonesIntoMap(bottomMilestones);
        for(Milestone1_Milestone__c newMS : newBottomMilestoneMap.values()){
            newMS.Project__c = newProj.Id;
            newMS.Parent_Milestone__c = newTopMilestoneMap.get(newMS.Parent_Milestone__c).Id;
        }
        insert newBottomMilestoneMap.values();
        
        //collect all milestones into one map
        Map<String, Milestone1_Milestone__c> allNewMilestoneMap = new Map<String, Milestone1_Milestone__c>();
        allNewMilestoneMap.putAll(newTopMilestoneMap);
        allNewMilestoneMap.putAll(newBottomMilestoneMap);
        
        //clone and insert task records
        List<Milestone1_Task__c> newTasks = Milestone1_Clone_Utility.cloneTasksIntoList(tasks);
        for(Milestone1_Task__c newTask : newTasks){
            newTask.Project_Milestone__c = allNewMilestoneMap.get(newTask.Project_Milestone__c).Id;
        }
        insert newTasks;
        
        //direct user to cloned project's detail page
        return new ApexPages.StandardController(newProj).view();
    }

}