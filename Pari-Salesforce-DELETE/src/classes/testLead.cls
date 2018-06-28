@isTest
private class testLead {
    private static testmethod void testLeadActivity(){
        
        Lead l = new Lead (LastName = 'Joy', Company = 'Joy Inc', Status = 'Open - Not Contacted', Type_of_Insurance__c = 'Auto' );
        insert l;
       
        List<task> taskList = [SELECT id, ActivityDate FROM Task WHERE whoID = :l.Id ];
        system.assertEquals(1, taskList.size());
        
        Lead m = new Lead (LastName ='Mario', Company =  'Mario Inc', Status = 'Open - Not Contacted', Type_of_Insurance__c = 'Auto');
        insert m;
        
        List<Task> mtaskList = [SELECT id, ActivityDate FROM Task WHERE whoId = :m.Id];
        system.assertEquals(1, mtaskList.size());
        
        System.assertEquals(Date.today()+1, mtaskList[0].ActivityDate);
        
        
    }
    
}