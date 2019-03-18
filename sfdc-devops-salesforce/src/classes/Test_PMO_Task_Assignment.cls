/**
   @Author - Veenesh Vikram
   
   @name - Test_PMO_Task_Assignment
   
   @CreateDate - 01/16/2014
   
   @Description - Test class to test the case scenarios for the class "PMO_Task_Assignment".
                  
   @Version - 1.0
   
   @reference - None
  */
@isTest
private class Test_PMO_Task_Assignment {
    /**
   *  Description -  This method is a test method that creates the test data to cover different scenarios
   *
   *  @name - Test_PMO_Task_Assignment
   *
   *  @param - None
   *
   *  @return - None
   *
   *  @throws exception- None
   */
    public static testmethod void testPMOTaskAssignment()
    {
    
        // stores records for custom setting PMO_TaskAssignment__c
        List<PMO_TaskAssignment__c> taskAssignmentCustomSettingList = new List<PMO_TaskAssignment__c>();
        
        // stores records for custom setting PMO_CreateDefect__c
        List<PMO_CreateDefect__c> createDefectCustomSettingList = new List<PMO_CreateDefect__c>();
        
        // stores IDC task records that will be inserted in to database
        List<IDC_Task__c> taskList = new List<IDC_Task__c>();
        
        // stores updated IDC task records
        List<IDC_Task__c> updateTaskList = new List<IDC_Task__c>();

        // Query a user record.
        // The user will be used to create record for custom setting PMO_TaskAssignment__c
        User user = [SELECT Id FROM User WHERE IsActive = True LIMIT 1];
        String userId = user.id;

        //Creating records for custom setting PMO_TaskAssignment__c records.
        PMO_TaskAssignment__c taskAssignemntCustomSetting1 = new PMO_TaskAssignment__c(name='Analysis',Task__c='Analysis',Owner_Queue__c=userId );
        taskAssignmentCustomSettingList.add(taskAssignemntCustomSetting1);
        PMO_TaskAssignment__c taskAssignemntCustomSetting2 = new PMO_TaskAssignment__c(name='Design',Task__c='Design',Preceding_Task__c='Analysis',Owner_Queue__c=userId );
        taskAssignmentCustomSettingList.add(taskAssignemntCustomSetting2);
        
        //Inserting records for Custom Setting PMO_TaskAssignment__c records.
        insert taskAssignmentCustomSettingList;

        //Creating records for PMO_CreateDefect__c custom setting.
        PMO_CreateDefect__c createDefectCustomSetting1 = new PMO_CreateDefect__c(name='Analysis',Create_Defect__c = True);
        createDefectCustomSettingList.add(createDefectCustomSetting1);
        PMO_CreateDefect__c createDefectCustomSetting2 = new PMO_CreateDefect__c(name='Design',Create_Defect__c = True);
        
        //Inserting records for Custom Setting PMO_CreateDefect__c records.
        createDefectCustomSettingList.add(createDefectCustomSetting2);
        
        //Inserting records for Custom Setting PMO_CreateDefect__c 
        insert createDefectCustomSettingList;
        
        // creating release record which will be the parent record for the requests record
        Release__c release = PMODataUnitHelper.insertReleaseForRequest('Test Release' + 1);
        
        // Inserting release record
        insert(release);
        
        // Creating request record
        Request__c request = PMODataUnitHelper.insertRequest('Test Request',release.Id);
        
        // inserting request record
        insert request;  
        
        
        // Creating IDC Task Records.
        for (Integer count = 0; count < 200; count++)
        {
                IDC_Task__c task = PMODataUnitHelper.createTask('Analysis', userId, request.id);
                taskList.add(task);
        }

        //Inserting IDC Task Records.
        insert taskList;
        
        //Assert Insertion of IDC Task records.
        List<IDC_Task__c> insertedTaskList = [SELECT Id FROM IDC_Task__c WHERE Id IN:taskList];
        
        //Ensuring that no. of records inserted is correct
        System.assertEquals(insertedTaskList.size(),200,'Number of task record returned is incorrect.The result has '+ 
                insertedTaskList.size()+' records-Expected 200');

        // updating the records so as the trigger on IDC_Task__c fires      
        for(IDC_Task__c currentTask : insertedTaskList)
        {
            updateTaskList.add(PMODataUnitHelper.updateTask(currentTask));
        }
        
        // Test scenario starts here
        Test.startTest();

        // updating the records 
        update updateTaskList;
        
        // Test scenario ends here
        Test.stopTest();
        
        // retrieving list of defects which were created because of trigger
        List<Defect__c> defectList = [ SELECT Id, status__c FROM Defect__c WHERE Related_Request__c =: request.id ];
        
        // ensuring correct no. of records are inserted in defect object
        System.assertEquals(defectList.size(),200,'Number of defect record returned is incorrect.The result has '+ 
                defectList.size()+' records-Expected 200'); 
        
        // ensuring the status field has correct value
        for (Defect__c currentDefect : defectList)
        {
            System.assertEquals(currentDefect.status__c,'Open','Status of defect incorrect. The status is '+ 
                    currentDefect.status__c+' - Expected Open');    
        }
    }
    
}