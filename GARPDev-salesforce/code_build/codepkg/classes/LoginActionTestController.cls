/*********************************************
Name: LoginActionTestController 
Description: VF controller for VF page LoginActionTest
    
Created/Modified By        Created/Modified Date        Comments
---------------------------------------------------------------------------
1. Billy Meyers             09/25/2014                   Version 1.0
*********************************************/
public class LoginActionTestController {
    
    public List<Chapter_Meeting__c> meetings {get; set;}
    public String selectedMeetingId {get; set;} 
      
    
    public LoginActionTestController() {
        meetings = new List<Chapter_Meeting__c>();
        for(Chapter_Meeting__c meeting : [SELECT Id, Name, Chapter_Meeting_Location__r.Name, Start__c, End__c FROM Chapter_Meeting__c]){
            meetings.add(meeting);
        }      
    }
    
    public PageReference registerForMeeting(){
        PageReference pr = new PageReference('https://build-garpbuild.cs16.force.com/');
        pr.getParameters().put('action', 'meeting');
        pr.getParameters().put('id', selectedMeetingId);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference registerForJobTarget(){
        PageReference pr = new PageReference('https://build-garpbuild.cs16.force.com/');
        pr.getParameters().put('action', 'jobtarget');
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference signUpForNewsletter(){
        PageReference pr = Page.Login;
        pr.getParameters().put('action', 'news');
        pr.getParameters().put('id', 'XYZ');
        pr.setRedirect(true);
        return pr;
    }
}