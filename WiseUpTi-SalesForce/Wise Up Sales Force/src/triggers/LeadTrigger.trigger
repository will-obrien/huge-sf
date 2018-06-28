trigger LeadTrigger on Lead (after update, after insert,before insert,before update,before delete,after delete,after undelete) {
    
   
        LeadTriggerHandler handler = new LeadTriggerHandler (true);
        
        handler.oldRecordsList = Trigger.old;
        handler.newRecordsList = Trigger.new;
        handler.oldRecordsMap = Trigger.oldMap;
        handler.newRecordsMap = Trigger.newMap;
        handler.isAfter = Trigger.isAfter;
        handler.isBefore = Trigger.isBefore;
        handler.isInsert = Trigger.isInsert; 
        handler.isUpdate = Trigger.isUpdate; 
        handler.isDelete = Trigger.isDelete;
        handler.isUndelete = Trigger.isUndelete;
                
        if(Trigger.isAfter)
        {
            if(Trigger.isInsert)
                handler.OnAfterInsert();
                        
            if(Trigger.isUpdate)
                handler.OnAfterUpdate();
                    
            if(Trigger.isDelete)
                handler.OnAfterDelete();
                    
            if(Trigger.isUnDelete)
                handler.OnUndelete();
        }
        else
        {
            if(Trigger.isInsert)
                handler.OnBeforeInsert();
                    
            if(Trigger.isUpdate)
                handler.OnBeforeUpdate();
                
            if(Trigger.isDelete)
                handler.OnBeforeDelete(); 
        }
}