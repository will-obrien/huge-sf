trigger Project_Milesstones_ICOwner_Update_Trigger on Project__c(after insert, before insert, before update) 
{
    Set<ID> projIds = new Set<ID>();    
    List<Milestone__c> lsMileStones = new List<Milestone__c>();
    
   if(Trigger.isBefore)
    {
        for(project__c proj : trigger.new)
        {
            if((proj.Innovation_Coordinator__c !=null)  && (proj.OwnerId!=null) && (proj.Innovation_Coordinator__c !=proj.OwnerId))
            {
                System.Debug('test userid ' + proj.Innovation_Coordinator__c);
                proj.OwnerId = proj.Innovation_Coordinator__c;
            }
        }
    }
    
    if(Trigger.isInsert && Trigger.isAfter)
    {
        for(Project__c pfObj: Trigger.new)
        {
            projIds.add(pfObj.Id);
        }
        
        for(ID ProjId : projIds)
        {
           List<String> lsStepNames = new List<String>{'Resourcing Package Appoved','Milestone Review 1','Milestone Review 2','Milestone Review 3','Milestone Review 4','Milestone Review 5','Close Out Meeting','Close Out Procedure Completed','Open For Proposals','Closed For Proposals'};
           for(String milestoneStep : lsStepNames)
           {
           Milestone__c initMileStone =  new Milestone__c(Project__c = projId, Name = mileStoneStep) ;
           lsMileStones.add(initMileStone);
           }
        }   
         
        insert lsMileStones;      
    }
  }