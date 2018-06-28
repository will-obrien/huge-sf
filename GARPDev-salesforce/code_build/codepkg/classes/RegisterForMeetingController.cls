global class RegisterForMeetingController {

    global PageReference registerForMeeting() {
        List<User> user = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        String meetingId = ApexPages.currentPage().getParameters().get('id');
        String userId = ApexPages.currentPage().getParameters().get('userId');
        if(meetingId != null && user != null && user.size()>0 && user[0].ContactId != null) {
            try {
                Registration.chapterMeetingRegister(user[0].ContactId, meetingId, true);
                return new PageReference('/sfdcapp#!/calendar_event_detail/' + meetingId + '/chapter');
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                return null;
            }
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error registering for meeting'));
        return null;
    }

    global PageReference goToDashboard(){
        return Page.SFDCApp;
    }

}