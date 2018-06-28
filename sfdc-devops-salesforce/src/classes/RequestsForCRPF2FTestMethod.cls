@isTest
public class RequestsForCRPF2FTestMethod {
    //Method for creation of Rquest record 
    	public static Request__c createRequest(User_Story__c userstory) {
            Request__c requestObj = new Request__c(Request_Title__c = 'Test',User_Story__c = userstory.Id);
            return requestObj;
    	}
        
        //Method for creation of UserStory record
        public static User_Story__c createUserStory() {
            User_Story__c userstory = new User_Story__c(Name = 'Test');
            return userstory;
        }
    
    	//Method for creation of UserStory record linked to an Request
        public static User_Story__c createUserStory1() {
            User_Story__c userstory1 = new User_Story__c(Name = 'Test1');
            return userstory1;
        }
        
         public static testMethod void testRequestsForCRPF2F(){
             
             User_Story__c userstory = createUserStory();
             insert userstory;
             
             User_Story__c userstory1 = createUserStory1();
             insert userstory1;
             
             List<Request__c> requestList = new List<Request__c>();
        	 requestList.add(createRequest(userstory));
        	 requestList.add(createRequest(userstory1));
        	 insert requestList;
             
             
             //set pageReference 
        PageReference testPageRef = Page.View_Requests_v9;
        Test.setCurrentPage(testPageRef);
        
        test.startTest();
            ApexPages.StandardSetController standardsetController = new ApexPages.StandardSetController(requestList);
            standardsetController.setSelected(requestList);
            RequestsForCRPF2F showUserStories = new RequestsForCRPF2F(standardsetController); 
            showUserStories.GoToRequestsTab();
            showUserStories.getStories();
        test.stopTest();
         }
}