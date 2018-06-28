/**
   @Author - Anurag Ranjan
   
   @name - PMO_Task_Assignment
   
   @CreateDate - 02/04/2012
   
   @Description - Helper class to create new IDC tasks records (object - IDC_Task__c) based on custom setting PMO_TaskAssignment.
                  The class also creates new defect records (object - Defect__c) based on custom setting PMO_TaskAssignment 
                  and custom settings PMO_CreateDefect__c.
                  
   @Version - 1.0
   
   @reference - None
  */
public  class PMO_Task_Assignment 
{
    /**
    *  Description -  The method loops on all records in custom settings PMO_TaskAssignment and compares against the 
                     IDC tasks record received from trigger and creates related IDC tasks and defects based on no. of criteria
    *
    *  @name - PMO_Task_Assignment
    *
    *  @param - List<IDC_Task__c> idcTasksList - Contains the IDC task list coming from the trigger
    *
    *  @return - None
    *
    *  @throws exception- None
    */
    public static void PMO_Task_Assignment(List<IDC_Task__c> idcTasksList)
    {
        
        // Map storing all the records for custom setting PMO_TaskAssignment__c            
        Map<String, PMO_TaskAssignment__c> allTasksCustomSettingMap = PMO_TaskAssignment__c.getAll();  
         
        // List of new IDC Tasks that are being inserted. These new IDC tasks are child records to other IDC tasks
        List<IDC_Task__c> newIdcTasksList = new List<IDC_Task__c>();
        
        // List of new defects that are being inserted
        List<Defect__c> newDefectList = new List<Defect__c>(); 
        
       try
       {
            // Looping through all values in custom setting
            for (PMO_TaskAssignment__c currentCustomSettingTask : allTasksCustomSettingMap.values()) 
            {
            
                // Looping through updated IDC tasks record received from trigger
                for (IDC_Task__c currentidcTask : idcTasksList)  
                {    
                    
                    // Process only those IDC task records which have their task type field value equal to value in preceding task field of custom setting PMO_TaskAssignment__c
                    // New IDC tasks will have task type same as the preceding task type of current IDC task
                    // New defects will have task type same as current IDC task
                    if (currentidcTask.Task_Type__c ==  PMO_TaskAssignment__c.getInstance(currentCustomSettingTask.name).Preceding_Task__c)   
                    {
                        
                        // The below if block contains the logic for creation of new child IDC task records
                        if ((currentCustomSettingTask.name != system.label.PMO_Task_CodeReview || 
                            (currentCustomSettingTask.name == system.label.PMO_Task_CodeReview && 
                            currentidcTask.Build_Task_Type__c == system.label.PMO_TaskType_Customization)) &&
                            ((currentidcTask.Defect_Found__c  && 
                            (currentidcTask.Task_Type__c.contains(system.label.PMO_Task_Review) || 
                            currentidcTask.Task_Type__c.contains(system.label.PMO_Task_Execution))) ||
                            (!currentidcTask.Task_Type__c.contains(system.label.PMO_Task_Review) && 
                            !currentidcTask.Task_Type__c.contains(system.label.PMO_Task_Execution))))
                        {
                        
                            // Creating new IDC task record 
                            IDC_Task__c newIdcTask = new IDC_Task__c();
                            
                            // Assign value to owner id only if the current custom setting has value in field Owner Queue
                            if (PMO_TaskAssignment__c.getInstance(currentCustomSettingTask.name).Owner_Queue__c != null)
                            {
                                newIdcTask.OwnerId = PMO_TaskAssignment__c.getInstance(currentCustomSettingTask.name).Owner_Queue__c;
                            }
                            
                            //assigning values to new IDC task record
                            newIdcTask.Assigned_Date__c = system.today();
                            newIdcTask.Task_Type__c = currentCustomSettingTask.name;                      
                            newIdcTask.IDC_Task__c = currentidcTask.id;
                            newIdcTask.Track__c = currentidcTask.Track__c;
                            newIdcTask.Request__c = currentidcTask.Request__c;
                            
                            // inserting new IDC task into IDC Task list
                            newIdcTasksList.add(newIdcTask); 

                        }
                        
                        // The below if block contains the logic for creation of new defect records
                        // The defect record is created only if the current record's task type has 'Create Defect' checked in the custom setting PMO_CreateDefect__c
                        if ( currentidcTask.Defect_Found__c && 
                            currentidcTask.Defect_Description__c != null && 
                            PMO_CreateDefect__c.getInstance(currentidcTask.Task_Type__c).Create_Defect__c )
                        {
                           
                           // create a new defect record
                           Defect__c newDefect = new Defect__c();
                           
                           //assigning values to new defect record
                           newDefect.subject__c = system.label.PMO_Defect_Subject + currentidcTask.Request_Name__c;
                           newDefect.status__c = system.label.PMO_Defect_Open;
                           newDefect.Defect_Detected__c = currentidcTask.Task_Type__c;
                           newDefect.Detailed_Description__c = currentidcTask.Defect_Description__c;
                           
                           // Assign value to field related request only when there is a request attached with the current IDC task record
                           if (currentidcTask.Request__c != null)
                           {
                                newDefect.Related_Request__c = currentidcTask.Request__c;
                           }
                           
                           // inserting new defect into defect list
                           newDefectList.add(newDefect);
                          
                        }  
                    }
                }
            }
            
            // insert the newIdcTasksList list only if it is not empty 
            if (!newIdcTasksList.isEmpty()) 
            {
                insert newIdcTasksList;
            }
            
            // insert the newDefectList list only if it is not empty
            if (!newDefectList.isEmpty())
            {
                insert newDefectList;
            }
       }
       
       // Catching exception if any
       catch(Exception ex)
       {
           ex.setMessage(system.label.PMO_Task_Error);
       }
   }
}