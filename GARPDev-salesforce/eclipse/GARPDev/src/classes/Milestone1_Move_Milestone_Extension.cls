public with sharing class Milestone1_Move_Milestone_Extension {
    
    public List<Milestone1_Milestone__c> recs {get; set;}
    private Map<Id, Milestone1_Milestone__c> recsById {get; set;}
    private List<Milestone1_Milestone__c> subMilestones {get; set;}
    private List<Milestone1_Task__c> tasks {get; set;}
    public Milestone1_Milestone__c dummyMS {get; set;}
    public Boolean anySelected {get; set;}
    public String milestoneId {get;set;}
    public String prevPage {get;set;}
    private ApexPages.StandardSetController stc;
    
    public Milestone1_Move_Milestone_Extension(ApexPages.StandardController stc)
    {
        Milestone1_Milestone__c currentMilestone = (Milestone1_Milestone__c) stc.getRecord();
        system.debug('Current Milstone Id == ' + currentMilestone.Id);
        recs = new List<Milestone1_Milestone__c>{currentMilestone};
        milestoneId = currentMilestone.Id;
        processSelection(recs);
    }


    public Milestone1_Move_Milestone_Extension(ApexPages.StandardSetController instc){
        stc = instc;
        milestoneId = null;
        recs = stc.getSelected();
        processSelection(recs); 
    }
    
    private void processSelection(List<Milestone1_Milestone__c> processList)
    {
        recs = processList;
        anySelected = recs.size() > 0;
        if(anySelected){
            Set<Id> recIds = new Set<Id>();
            for(Milestone1_Milestone__c rec : recs){
                recIds.add(rec.Id);
            }
            recs = [SELECT Id,
                           Name,
                           Project__c,
                           Parent_Milestone__c
                    FROM Milestone1_Milestone__c
                    WHERE Id IN :recIds
                   ];
    
            //query sub milestone records
            subMilestones = [SELECT Id,
                                    Name,
                                    Project__c,
                                    Parent_Milestone__c
                             FROM Milestone1_Milestone__c
                             WHERE Parent_Milestone__c IN :recIds
                            ];
            
            //merge both lists so that sub-milestones move with their parents
            recs.addAll(subMilestones);
            System.debug('*** milestones being moved: ' + recs.size());
            
            recsById = new Map<Id, Milestone1_Milestone__c>();
            for(Milestone1_Milestone__c rec : recs){
                rec.Okay_to_Reparent__c = true;
                recsById.put(rec.Id, rec);
            }   
            dummyMS = new Milestone1_Milestone__c();
        }
    }
    
    public PageReference moveMilestones(){
        try
        {
            Milestone1_Project__c proj = [SELECT Id FROM Milestone1_Project__c WHERE Id = :dummyMS.Project__c];
            
            List<Milestone1_Milestone__c> topMilestones = new List<Milestone1_Milestone__c>();
            List<Milestone1_Milestone__c> bottomMilestones = new List<Milestone1_Milestone__c>();
            for(Milestone1_Milestone__c rec : recs){
                system.debug(rec.Project__c + ' == ' + proj.Id);
                if(rec.Project__c == proj.Id)
                {
                    throw new Milestone1_Move_Exception(Milestone1_Move_Exception.ERROR_MILESTONE_ALREADY_ASSIGNED_PROJECT);
                }
                rec.Project__c = proj.Id;
                if(rec.Parent_Milestone__c == null){
                    topMilestones.add(rec);
                } else {
                    if(recsById.get(rec.Parent_Milestone__c) == null){
                        rec.Parent_Milestone__c = null;
                    }
                    bottomMilestones.add(rec);
                }
            }
            
            System.debug('*** topMilestones: ' + topMilestones);
            update topMilestones;
            System.debug('*** bottomMilestones: ' + bottomMilestones);
            update bottomMilestones;
            if(milestoneId != null)
            {
                return new ApexPages.StandardController(new Milestone1_Milestone__c(Id=milestoneId)).view();
            }else
            {
                return stc.cancel();
            }
        }
        catch(Exception e)
        {
            system.debug('Exception thrown!');
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage());
            ApexPages.addMessage(errorMsg);
            return ApexPages.currentPage();
        }
    }

}