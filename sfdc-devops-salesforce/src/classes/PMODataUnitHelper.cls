/**
 @Author - Anurag Ranjan
 
 @name - IDC_TaskTestHelper
 
 @CreateDate - 02/06/2014
 
 @Description - Helper class for creating test data
                
 @Version - 1.0
 
 @reference - None
*/
@isTest 
public class PMODataUnitHelper 
{
    /**
     *  Description -  This method is used to create request record
     *
     *  @name - insertRequest
     *
     *  @param - String requestName - stores title of the request
     *      - Id releaseID - stores the id of the associated release
     *
     *  @return - Request__c - returns a request record
     *
     *  @throws exception- None
     */  
    public static IDC_Task__c createTask(String taskType, String Userid, String RequestId )
    {
        // creating a IDC task record
        IDC_Task__c idctask = new IDC_Task__c();
        
        // assigning values to the record
        idcTask.Task_Type__c = taskType;
        idcTask.Defect_Found__c = True;
        idcTask.Defect_Description__c = 'Test Description';
        idcTask.Planned_LOE__c = 1.00;
        idcTask.OwnerId  = Userid;
        idcTask.Request__c=RequestId;
        idcTask.Start_Date__c = System.today() - 2;
        idcTask.status__c = 'In Progress';
        
        // returning the IDC task record
        return idctask;
    }

    
    /**
     *  Description -  This method is used to update task record
     *
     *  @name - updateTask
     *
     *  @param - IDC_Task__c task - stores the task record to be updated
     *      
     *  @return - IDC_Task__c - returns updated task record
     *
     *  @throws exception- None
     */      
    public static IDC_Task__c updateTask(IDC_Task__c task)
    {
        // updating task values
        task.status__c = 'Completed';
        task.Actual_LOE__c = 1.00;
        task.End_Date__c = System.today();
        task.comments__c='Complete';
        
        // returning task record
        return(task);
    }
    
    
    /**
    *  Description -  This method is used to create request record
    *
    *  @name - insertRequest
    *
    *  @param - String requestName - stores title of the request
    *		  - Id releaseID - stores the id of the associated release
    *
    *  @return - Request__c - returns a request record
    *
    *  @throws exception- None
    */	
	public static Request__c insertRequest( String requestName, Id releaseID)
	{
		
		// Create a request record
		Request__c request = new Request__c();
		
		// Assigning values to different fields of request
		request.Request_Title__c = 'Test Release ' + requestName;
		request.Request_Type__c = 'Configuration';
		request.Request_Description__c  = 'Test';
		request.Req__c = 1.0;
		request.SIT__c = 1.0;
		request.BUT__c = 1.0;
		request.UAT__c = 1.0;
		request.Des__c = 1.0;
		request.TrnDep__c = 1.0;
		request.Adapt__c = 1.0;
		request.Release__c = releaseID;
		
		// returning a request record
		return(request);
	} 
	
	
    /**
    *  Description -  This method is used to create release record
    *
    *  @name - insertReleaseForRequest
    *
    *  @param - String releaseName - stores name of the request
    *
    *  @return - Release__c - returns a release record
    *
    *  @throws exception- None
    */		
	public static Release__c insertReleaseForRequest(String releaseName)
	{
		
		// creating a release record
		Release__c release = new Release__c(Name = 'Test Release ' + releaseName);
		
		// returning a release record.
		return(release);
	}
	
	
    /**
    *  Description -  This method is used to update request record
    *
    *  @name - updateRequest
    *
    *  @param - Request__c request - stores a request record which is going to be updated
    *
    *  @return - Request__c - returns the updated request record
    *
    *  @throws exception- None
    */		
	public static Request__c updateRequest(Request__c request)
	{
		// Updating the requirement estimate field of the request		
		request.Req__c = 2.0;
		
		// returning the updated request field
		return(request);
	}
}