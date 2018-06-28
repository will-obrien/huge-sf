trigger proctorRegistration on Proctor_Registration__c (after insert, after update) {
    List<Proctor_Registration__c> prs = Trigger.new;
    List<id> ids = new List<id>();
    
    List<String> emails = new List<String>();
 
    List<Proctor_Registration__c> lstPR = [select Id, Name, Status__c, Selected__c, Confirmed__c, Contact__c, Proctor_Email__c, Type__c, Exam_Group__r.Exam_Date__c, Test_Site__r.Name from Proctor_Registration__c where Id in :prs];
    
    MAP<String,Proctor_Registration__c> mapProc = new MAP<String,Proctor_Registration__c>();
    for (Proctor_Registration__c pr :lstPR){  
        if(pr.Proctor_Email__c != null) {
            mapProc.put(pr.Proctor_Email__c,pr);
            ids.add(pr.Contact__c);        
        }
    }
        
    List<Contact> lstContacts = [select Id, Name, Email, KPI_Proctor_Confirmed__c, KPI_Proctor_Selected__c, KPI_Proctor__c, KPI_Proctor_Supervisor__c, KPI_Proctor_Exam_Date__c, KPI_Proctor_Type__c, KPI_Proctor_Exam_Site__c from Contact where Id in :ids];
    for (Contact con :lstContacts){
        Proctor_Registration__c pr = mapProc.get(con.Email);
        if(pr != null) {
            con.KPI_Proctor__c = true;
            if(pr.Type__c == 'Supervisor')
                con.KPI_Proctor_Supervisor__c = true;
            if(pr.Status__c == 'Approved') {
                con.KPI_Proctor_Exam_Date__c = String.valueOf(pr.Exam_Group__r.Exam_Date__c);
                con.KPI_Proctor_Type__c = pr.Type__c;
                con.KPI_Proctor_Exam_Site__c = pr.Test_Site__r.Name;
                con.KPI_Proctor_Selected__c=pr.Selected__c;
                con.KPI_Proctor_Confirmed__c =pr.Confirmed__c;
            } else {
                con.KPI_Proctor_Selected__c=false;
                con.KPI_Proctor_Confirmed__c=false;
                con.KPI_Proctor_Exam_Date__c = NULL;
                con.KPI_Proctor_Type__c = NULL;
                con.KPI_Proctor_Exam_Site__c = NULL;
            }
        }
    }
    update lstContacts;
    
}