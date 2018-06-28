public without sharing class VSDashBoard_Con {
    public List<Task> getTasks(){
        return [SELECT Id,Subject,Status, ActivityDate FROM Task WHERE ActivityDate = TODAY AND Status != 'Completed' AND Status != 'Deferred'];
    }
    
    public List<Case> getCases(){
        return [SELECT Id,CaseNumber,Status,Subject, Priority FROM Case WHERE OwnerId=:UserInfo.getUserId() AND isClosed = FALSE];
    }
    
    public List<Lead> getLeads(){
        return [SELECT Id,Name,Status, CreatedDate FROM Lead WHERE OwnerId=:UserInfo.getUserId() AND IsUnreadByOwner = true];
    }
    
    public List<Account> getAccounts(){
        return [SELECT Id,Name,BillingState,Type FROM Account ORDER BY LastViewedDate DESC limit 5 ];
    }
    
    public List<Contact> getContacts(){
        return [SELECT Id,Name,Phone, Department FROM Contact ORDER BY LastViewedDate DESC limit 5 ];
    }
}