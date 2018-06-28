trigger proctorRegistration on Proctor_Registration__c (before insert) {
    List<Proctor_Registration__c> prs = Trigger.new;
    List<Contact> lstContacts = new List<Contact>();
    List<id> SupervisorIds = new List<id>();
    List<id> ids = new List<id>();
    
    List<String> emails = new List<String>();
 
    for (Proctor_Registration__c pr:prs){

        if(pr.Contact__c == null) {
            Account newAccount = new Account();
            String name = pr.Proctor_First_Name__c + ' ' + pr.Proctor_Last_Name__c;
            newAccount.put('Name',name);
            insert newAccount;
    
            Contact newContact = new Contact();
            newContact.put('FirstName',pr.Proctor_First_Name__c);
            newContact.put('LastName',pr.Proctor_Last_Name__c);
            newContact.put('Email',pr.Proctor_Email__c);
            newContact.put('AccountId',newAccount.Id);
            
            insert newContact;
            lstContacts.add(newContact);
            pr.Contact__c = newContact.Id;
        } 
        
        if(pr.Type__c == 'Supervisor') {
                SupervisorIds.add(pr.Contact__c);
            } 
       else {
                ids.add(pr.Contact__c);
            }
        
    }
    //if(lstContacts.size() > 0)
    //    CommunityUtils.createCommunityUser(lstContacts);
    
    List<Contact> lstSupContacts = [select Id, Name, KPI_Proctor__c, KPI_Proctor_Supervisor__c from Contact where Id in :SupervisorIds];
    for (Contact con :lstSupContacts){
        con.KPI_Proctor_Supervisor__c = true;
    }
    update lstSupContacts;
    
    List<Contact> lstProcContacts = [select Id, Name, KPI_Proctor__c, KPI_Proctor_Supervisor__c from Contact where Id in :ids];
    for (Contact con :lstProcContacts){
        con.KPI_Proctor__c = true;
    }
    update lstProcContacts;
    
}