/*********************************************
Name: SignUpConfirmController
Description: VF controller for VF page SignUpConfirm
    
Created/Modified By        Created/Modified Date        Comments
---------------------------------------------------------------------------
1. Billy Meyers             09/25/2014                   Version 1.0
*********************************************/
global class SignUpConfirmController {

    global String action {get; set;}
    global String actionId {get; set;}
    global String userId {get; set;}
    global String success {get; set;}
    
    global User u {get; set;}
    
    global SignUpConfirmController() {
        action = ApexPages.currentPage().getParameters().get('action');
        actionId = ApexPages.currentPage().getParameters().get('id');
        userId = ApexPages.currentPage().getParameters().get('userId');
        success = ApexPages.currentPage().getParameters().get('success'); 
        if (action == 'jobtarget'){
            u = [SELECT Id, FirstName, LastName, Contact.Email, Contact.GARP_Member_ID__c FROM User WHERE ContactId = :actionId];
        }      
    }
    
    global PageReference setConfirmMessage(){
        String message;       
        
        Cookie contactId = ApexPages.currentPage().getCookies().get('counter');
        PageReference pageRef = null;

        if(action == 'meeting'){
            String meetingName;
            List<Chapter_Meeting__c> meetingList = [SELECT Id, Name FROM Chapter_Meeting__c WHERE Id = :actionId];
            if(meetingList != null && meetingList.size()>0){
                meetingName = meetingList[0].Name;
            }
            if(Boolean.valueOf(success)){
                message = 'Registration for "' + meetingName + '" successful!'; 
                pageRef = new PageReference('/sfdcapp#!/registerInfo' + userId);
                contactId = new Cookie('contactId',userId,null,-1,false);
            } 
        } else if (action == 'jobtarget') {
            message = 'Registration for JobTarget successful!'; 
            pageRef = new PageReference('/sfdcapp#!/registerInfo' + userid);
            contactId = new Cookie('contactId',userId,null,-1,false);
        } else {
            message = 'Registration successful!'; 
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message));
        ApexPages.currentPage().setCookies(new Cookie[]{contactId});
        
        return pageRef;
    }
}