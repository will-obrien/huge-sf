public class RequestsForCRPF2F {
    Private List<Request__c> reqs;
    Private Set<Id> storySet = new Set<Id>();
    Private Set<Id> reqSet = new Set<Id>();
    Private Boolean isEmpty = true;
    
    public RequestsForCRPF2F(ApexPages.StandardSetController stdSetController)
    {
        reqs = stdSetController.getSelected();
        system.debug('Count of selected reqs: ' + reqs.size());
        if (reqs.size() > 0)
        {
            isEmpty = false;
        }
        for (Request__c req : reqs)
        {
            if(req.User_Story__c != null){
                reqSet.add(req.Id);
                storySet.add(req.User_Story__c);
                system.debug('added UserStoryId:Req --> ' + req.User_story__c + ' : ' + req.Id);
            }
        }
        system.debug('Count of reqSet --> ' + reqSet.size());
        system.debug('Count of storySet --> ' + storySet.size());
    }
    
     public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null ) 
            {
                if(reqSet.size() > 0 && storySet.size() > 0)
                {
                    String query = 'SELECT Id, Name, User_Story_Description__c, Level_3_Process__c, Release__c, Capability__r.Name, Business_Driver__c, Priority__c, (Select Id, Name, Request_Description__c, Status__c, Capability__c, Planned_Release__r.Name, Level_3_Process__c, Business_Benefit__c  FROM Requests__r where Id IN (';
                    Boolean prePendComma = false;
                    for(Id reqId:reqSet)
                    {
                        if (prePendComma)
                        {
                            query += ', ';
                        }
                        // not the most efficient code - but lack of sleep; need to do something I know I can do
                        query += '\'';
                        query += reqId;
                        query += '\'';
                        prePendComma = true;
                    }
                    query += ') order by Name) from User_Story__c where Id in (';
                    prePendComma = false;
                    for(Id storyId:storySet)
                    {
                        if (prePendComma)
                        {
                            query += ', ';
                        }
                        // not the most efficient code - but lack of sleep; need to do something I know I can do
                        query += '\'';
                        query += storyId;
                        query += '\'';
                        prePendComma = true;
                    }
                    query += ') Order By User_Story_Number__c';
                    system.debug(query);
                    //ApexPages.StandardSetController                     
                    setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                  
                }
                else
                {
                    // nothing was selected.  return no rows
                    setCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, User_Story_Description__c, Capability__r.Name, User_Story_Number__c, (Select Id, Name, Request_Description__c, Status__c FROM Requests__r where Id = null) from User_Story__c where Id = null Order By User_Story_Number__c]));
                }
            }
            return setCon;
        }
        set;
    }

    public Boolean NoData
    {
        get{return isEmpty;}
        set;
    }

    // Initialize setCon and return a list of records
    public List<User_Story__c> getStories() {       
            
            return (List<User_Story__c>) setCon.getRecords();           
         
    }
    
    public PageReference GoToRequestsTab()
    {
        //Get a reference to the Custom Object and gets its Key
        Schema.DescribeSObjectResult result = Request__c.sObjectType.getDescribe();
    
        //navigate to the View Page
        PageReference pageRef = New PageReference('/' + result.getKeyPrefix() + '/o');
        pageRef.setRedirect(true);
        return pageRef; 
    }
}