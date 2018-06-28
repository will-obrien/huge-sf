public with sharing class Milestone1_Clone_Milestone_Controller {
    
    public Milestone1_Milestone__c rec {get; set;}
    public Milestone1_Milestone__c dummyMS {get; set;}
    private List<Milestone1_Milestone__c> milestones {get; set;}
    private List<Milestone1_Task__c> tasks {get; set;}

    public Milestone1_Clone_Milestone_Controller(ApexPages.StandardController stc){
        //query main milestone record
        rec = [SELECT Id,
                      Name,
                      Project__c,
                      Parent_Milestone__c,
                      Complete__c,
                      Deadline__c,
                      Description__c,
                      Expense_Budget__c,
                      Hours_Budget__c,
                      OwnerId
                      FROM Milestone1_Milestone__c
                      WHERE Id = :stc.getId()
                     ];
        
        //query sub milestone records
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
                      WHERE Parent_Milestone__c = :rec.Id
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
                 WHERE Project_Milestone__c = :rec.Id
                 OR Project_Milestone__r.Parent_Milestone__c = :rec.Id
                ];
        
        dummyMS = new Milestone1_Milestone__c();
        dummyMS.Name = 'Copy of ' + rec.Name;
    }
    
    public PageReference createClone(){
        //clone and insert main milestone record
        List<Milestone1_Milestone__c> mainMilestoneList = new List<Milestone1_Milestone__c>();
        rec.Name = dummyMS.Name;
        mainMilestoneList.add(rec);
        Map<String, Milestone1_Milestone__c> newTopMilestoneMap = Milestone1_Clone_Utility.cloneMilestonesIntoMap(mainMilestoneList);
        insert newTopMilestoneMap.values();
        
        //clone and insert sub milestone records
        Map<String, Milestone1_Milestone__c> newBottomMilestoneMap = Milestone1_Clone_Utility.cloneMilestonesIntoMap(milestones);
        for(Milestone1_Milestone__c newMS : newBottomMilestoneMap.values()){
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
        
        //direct user to cloned milestone's detail page
        return new ApexPages.StandardController(newTopMilestoneMap.values()[0]).view();
    }

}