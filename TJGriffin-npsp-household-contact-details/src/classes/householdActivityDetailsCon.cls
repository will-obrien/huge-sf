public class householdActivityDetailsCon {
    public List<Task> tasks;
    private npo02__Household__c hshld; 
    // get household id from page
    public householdActivityDetailsCon(ApexPages.StandardController controller) {
        this.hshld = (npo02__Household__c)controller.getRecord();
    }
    public List<Task> getTasks()
    {
        // get contacts associated with household and store them in a collection
        List<Contact> cons = [SELECT id  FROM Contact WHERE Contact.npo02__Household__r.id = :hshld.id];
        //system.debug('size of contact collection from query on household name');
        //system.debug(cons.size());
        
        // populate a new list of ids from the collection of contacts
        List<Id> ids = new List<Id>();
        for(Contact c : cons) {
            ids.add(c.Id);
        }
        //system.debug('size of id collection');
        //system.debug(ids.size());
        if (ids.isempty())
         return null;
        
        // retrieve task data based on ids in list
        tasks = [Select ActivityDate, id, Related_Dept__c, Purpose__c, Subject, Who.Name, WhoId, WhatId, What.Name, What.type, Type from Task where WhoId in :ids Order By ActivityDate DESC];
        //system.debug('size of task collection from query based on contact ids');
        //system.debug(tasks.size());
        
        // return tasks to render on the page
        return tasks;
    }
    
    // Unit Test
    
    public static testMethod void testOppDetails()
    {
        npo02__Household__c h1 =  new npo02__Household__c(Name='Test');
                insert h1;
        npo02__Household__c myhshld = [SELECT ID FROM npo02__Household__c limit 1]; 
        
        Contact con1=new Contact(FirstName='UnitTest 1',LastName='Test',npo02__Household__c = myhshld.id);
        insert con1;
        Contact con = [SELECT Id, AccountId FROM Contact limit 1];  
        Task task1=new Task(Subject='Task Test 1', WhoId = con.Id );
        insert task1;

        
        ApexPages.StandardController sc = new ApexPages.standardController(myhshld);
        // create an instance of the controller
        householdActivityDetailsCon ctrl = new householdActivityDetailsCon(sc);

        
        // check that there is one household
        Integer tskSize=ctrl.getTasks().size();
        System.assert(tskSize>=1);

    }
    
}