public class TeamMemberControllerExt {
  
   private final Leadership__c leadership;
    //    public Leadership__c leadership{get;set;}

    public TeamMemberControllerExt(ApexPages.StandardController controller) {
        this.leadership = (Leadership__c)controller.getRecord();       
    }
/*
    public void x()
    {
    system.debug('=============');
    
    
    }

     public SelectOption[] getPositionOptions() {  
        SelectOption[] positions = new SelectOption[]{};
                Id entId = leadership.Club_Entity__c;
                system.debug('>>>>>>>>>>>'+entid);
        positions.add(new SelectOption('','--None--'));
        if (entId != null) {
            Club_Entity__c ent = [SELECT Id, Entity_Type__c FROM Club_Entity__c WHERE Id = :entId];
            for (Leader_Position__c l : [SELECT Id, Name FROM Leader_Position__c WHERE Active__c = true AND Entity_Types__c includes (:ent.Entity_Type__c) ORDER BY Name]) {  
            positions.add(new SelectOption(l.id, l.name));  
                }
        }      
        
        return positions;  
    } */
    
     public List<SelectOption> getPositionOptions() {  
        List<SelectOption> positions = new List<SelectOption>();
                Id entId = leadership.Club_Entity__c;
        positions.add(new SelectOption('','--None--'));
        if (entId != null) {
            Club_Entity__c ent = [SELECT Id, Entity_Type__c FROM Club_Entity__c WHERE Id = :entId];
            for (Leader_Position__c l : [SELECT Id, Name FROM Leader_Position__c WHERE Active__c = true AND Entity_Types__c includes (:ent.Entity_Type__c) ORDER BY Name]) {  
            positions.add(new SelectOption(l.id, l.name));  
                }
        }      
        
        return positions;  
    }
/*    
     public String getGreeting() {
     Id entId = leadership.Club_Entity__c;
     system.debug('>>>>>>>>>>>'+entid);
        return 'Hello ' + entId;
    }
*/    

    
}