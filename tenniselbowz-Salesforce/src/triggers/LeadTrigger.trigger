trigger LeadTrigger on Lead (after update) {

	/*
    if(Trigger.isBefore && Trigger.isInsert){									//before Insert
        
    } 
	*/
    /*
    if(Trigger.isBefore && Trigger.isUpdate){									//before update
    	
    }
	*/
    
	/*
	if(Trigger.isAfter && Trigger.isInsert){									//After Insert
       
    }
	*/
    
    if(Trigger.isAfter && Trigger.isUpdate){									//After Update
    	LeadTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
    
}