global class RegisterForJobTargetController {
    
    global User u {get; set;}
    global String email {get; set;}
    global String msg{get; set;}
    global String gotoParam{get; set;}
    global String gotoSend{get; set;}
    
    global RegisterForJobTargetController() {
        gotoParam = ApexPages.currentPage().getParameters().get('goto');
        gotoSend = '/jobseeker/search/results/';
        if(gotoParam != null) {

            if(gotoParam.indexOf('resumes') > -1) {
                gotoSend = '/jobseeker/resumes/';
            } else if(gotoParam.indexOf('agents') > -1) {
                gotoSend = '/jobseeker/job-alerts/';
            } else if(gotoParam.indexOf('search') > -1) {
                gotoSend = '/jobseeker/search/results/';
            } else if(gotoParam.indexOf('index') > -1) {
                gotoSend = '/jobseeker/my-account/';
            } else {
                gotoSend = '/jobseeker/search/results/';
            }   
        }
        
        try {
            u = [SELECT Id, FirstName, LastName, Contact.Id, Contact.Email, Contact.GARP_Member_ID__c FROM User WHERE Id = :UserInfo.getUserId()];
            system.debug('* *' + u.Contact.Email);
            system.debug('* *' + u.Id);
            Contact c = [select Id, Name, Email from Contact where Id = :u.Contact.Id ];
            email = c.Email;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'You will be redirected to the JobTarget website'));       
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
}