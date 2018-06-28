public class Generated {

    Case c;
    List<Task> tasksList;
    
    public Generated() {
        c= [SELECT Id, AccountId, CaseNumber, ClosedDate, ContactId, Description, IsClosed, LastViewedDate, Origin, OwnerId, Priority, Status, Subject, Type FROM Case WHERE Id = :getCaseID()];
    }

    public String getTasksData() {
        String result = '';

        getTasks(getCaseID(),getActivityDate());

        if(tasksList!=NULL && !tasksList.isEmpty()) {

            for(integer i=0;i<tasksList.size();i++) {
                result = result + '<hr/><table id="customTable" style="margin: 15px auto; width: 96%;">';
                result = result + '<tr><th>Id</th><td>' + tasksList.get(i).Id + '</td></tr>';
                result = result + '<tr><th>AccountId</th><td>' + tasksList.get(i).AccountId + '</td></tr>';

                result = result + '<tr><th>ActivityDate</th><td>' + tasksList.get(i).ActivityDate + '</td></tr>';
                result = result + '<tr><th>Description</th><td>' + tasksList.get(i).Description+ '</td></tr>';
                result = result + '<tr><th>IsClosed</th><td>' + tasksList.get(i).IsClosed+ '</td></tr>';
                result = result + '<tr><th>OwnerId</th><td>' + tasksList.get(i).OwnerId+ '</td></tr>';
                result = result + '<tr><th>Priority</th><td>' + tasksList.get(i).Priority+ '</td></tr>';
                result = result + '<tr><th>Status</th><td>' + tasksList.get(i).Status+ '</td></tr>';
                result = result + '<tr><th>Subject</th><td>' + tasksList.get(i).Subject+ '</td></tr>';
                result = result + '<tr><th>WhatId</th><td>' + tasksList.get(i).WhatId+ '</td></tr>';
                result = result + '<tr><th>WhoId</th><td>' + tasksList.get(i).WhoId+ '</td></tr>';

                result = result + '</table>';
            }
            return result;
            
        } else {
            return 'no tasks';
        }
    }

    public String getCaseData() {

        String result = '<table id="customTable" style="margin: 0 auto; width: 96%;"><tr><th>Id</th><td>' + c.Id + '</td></tr><tr><th>IsClosed</th><td>' + c.IsClosed + '</td></tr><tr><th>AccountId</th><td>' + c.AccountId + '</td></tr><tr><th>CaseNumber</th><td>' + c.CaseNumber + '</td></tr><tr><th>ClosedDate</th><td>' + c.ClosedDate + '</td></tr><tr><th>ContactId</th><td>' + c.ContactId + '</td></tr><tr><th>Description</th><td>' + c.Description + '</td></tr><tr><th>LastViewedDate</th><td>' + c.LastViewedDate + '</td></tr><tr><th>Origin</th><td>' + c.Origin + '</td></tr><tr><th>OwnerID</th><td>' + c.OwnerID + '</td></tr><tr><th>Priority</th><td>' + c.Priority + '</td></tr><tr><th>Status</th><td>' + c.Status + '</td></tr><tr><th>Subject</th><td>' + c.Subject + '</td></tr><tr><th>Type</th><td>' + c.Type + '</td></tr></table>';

        return result;
    }

    public String getCaseID() {
        return ApexPages.currentPage().getParameters().get('caseID');
    }

    public String getActivityDate() {
        return ApexPages.currentPage().getParameters().get('activityDate');
    }

    public List<Task> getTasks(string caseID, string activityDate) {
        try {
            Date oldest = Date.parse(activityDate);
            tasksList = [SELECT Id, AccountId, ActivityDate, Description, IsClosed, OwnerId, Priority, Status, Subject, WhatId, WhoId FROM Task WHERE ActivityDate >= :oldest AND WhatID = :caseID];
            return tasksList;
        } catch (Exception e) {
            return NULL;
        }
    }
}