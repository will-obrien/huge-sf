public class LeadTriggerHandler {
    public static void doCheckDuplicateLead(List<Lead> incomingLeads){
        List<Lead> currentLeads =  new List<Lead>();
        Map<String,String> leadPhoneEmailMap = new Map<String,String>(); 
        currentLeads = [Select Id,Email,Phone from Lead 
                        where (Email!=NULL OR Email!='') AND 
                        (Phone!=NULL OR Phone!='')];
        
        for(Lead l: currentLeads){
            leadPhoneEmailMap.put(l.Phone, l.Email);    
       }
        
        for(Lead l:incomingLeads){
             System.debug('Viraj:'+leadPhoneEmailMap.get(l.Phone));
            if((leadPhoneEmailMap.get(l.Phone) == l.Email)){
                 System.debug('Duplicate Record');
               l.addError('Duplicate Lead:'+l.Lastname);
          }
        }
      }
    
    public static void doAddTaskOnLead(List<Lead> incomingLeads){
        List<Task> myTasks = new List<Task>();
        for(Lead op :incomingLeads ){
           // if(op.StageName =='Closed Won'){
              myTasks.add(new Task(subject='Follow Up Task for New Lead', 
                                   WhoID = op.ID, 
                                   Ownerid = op.OwnerId,
                                   Status = 'Not Started',
                                   Priority = 'Normal'
                         )
              );
            //}
        }
        insert myTasks;
        
    }
    
    public static void doCloneLead(List<Lead> incomingLeads){
        System.debug('inside doCloneLead');
        List<Lead> cloneLeadList= new List<Lead>();
        for(Lead l:incomingLeads){
            if(l.Description!=null){
                System.debug('Description:'+l.Description );
                if(l.Description.contains('Clone')){ 
                    Lead tempLead = l.clone(false,true,false,false); //clone(preserveId, isDeepClone, preserveReadonlyTimestamps, preserveAutonumber)
                    //tempLead.id=null;
                    tempLead.Email = l.Email.replace('@','1@');
                    System.debug('Email:'+l.Email);
                    tempLead.Status = 'Working – Contacted';     
                    tempLead.Description='';
                    cloneLeadList.add(tempLead);
                    System.debug('Size of cloneLeadList:'+cloneLeadList.size());
            	}    
            }
        }
        
        if(cloneLeadList!=null && cloneLeadList.size()>0){
            insert cloneLeadList; 
        }    
    }
}