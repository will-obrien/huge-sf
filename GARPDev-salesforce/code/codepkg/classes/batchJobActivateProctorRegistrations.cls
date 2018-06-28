global class batchJobActivateProctorRegistrations implements Database.Batchable<sObject>,Database.StateFul{
    
    public String examGroupId;  
    public String mode;  
    public String testId;
    
    global batchJobActivateProctorRegistrations (String examGroupId, String mode, String testId){
        this.examGroupId = examGroupId;
        this.mode = mode;
        this.testId = testId;
        
        system.debug('batchJobActivateProctorRegistrations:' + examGroupId + ':' + mode + ':' + testId);
    }
     
   global Database.QueryLocator start(Database.BatchableContext BC){         
       String sType = 'Supervisor';
       if(mode == 'Supervisor') {           
           if(testId != null)
               return Database.getQueryLocator('select Id, Name, Contact__c, Exam_Group__c, Proctor_Email__c, Proctor_First_Name__c, Proctor_Last_Name__c, Proctor_Type__c, Test_Site__c, Test_Site_Code__c, Type__c from Proctor_Registration__c where Type__c = :sType and Exam_Group__c = :examGroupId and ID = :testId order by Proctor_Email__c');
           else return Database.getQueryLocator('select Id, Name, Contact__c, Exam_Group__c, Proctor_Email__c, Proctor_First_Name__c, Proctor_Last_Name__c, Proctor_Type__c, Test_Site__c, Test_Site_Code__c, Type__c from Proctor_Registration__c where Type__c = :sType and Exam_Group__c = :examGroupId order by Proctor_Email__c');    
       } else {
           if(testId != null)
               return Database.getQueryLocator('select Id, Name, Contact__c, Exam_Group__c, Proctor_Email__c, Proctor_First_Name__c, Proctor_Last_Name__c, Proctor_Type__c, Test_Site__c, Test_Site_Code__c, Type__c from Proctor_Registration__c where Type__c != :sType and Exam_Group__c = :examGroupId and ID = :testId order by Proctor_Email__c');
           else return Database.getQueryLocator('select Id, Name, Contact__c, Exam_Group__c, Proctor_Email__c, Proctor_First_Name__c, Proctor_Last_Name__c, Proctor_Type__c, Test_Site__c, Test_Site_Code__c, Type__c from Proctor_Registration__c where Type__c != :sType and Exam_Group__c = :examGroupId order by Proctor_Email__c');                  
       }
   }

   global void execute(Database.BatchableContext BC, List<Proctor_Registration__c> scope){
       
       system.debug('scope:' + scope);

       List<User> lstUsers = new List<User>();       
       List<Contact> lstContacts = new List<Contact>();
       List<Account> lstAccounts = new List<Account>();

       List<User> newUsers = new List<User>();       
       List<Contact> newContacts = new List<Contact>();
       List<Account> newAccounts = new List<Account>();

       List<String> lstEmails = new List<String>();
       
       MAP<String,User> mapUser = new MAP<String,User>();
       MAP<String,Account> mapAcct = new MAP<String,Account>();
       MAP<String,Contact> mapCont = new MAP<String,Contact>();

       for(Proctor_Registration__c pr :scope) {
           lstEmails.add(pr.Proctor_Email__c);
       }
       
       system.debug('lstEmails:' + lstEmails);

       
       lstAccounts = [select Id, Name, Member_Email__c from Account where Member_Email__c in :lstEmails];
       for(Account acct :lstAccounts) {
           mapAcct.put(acct.Member_Email__c, acct);
       }       
       system.debug('mapAcct:' + mapAcct);
       
       lstContacts = [select Id, Name, Email, AccountId from Contact where Email in :lstEmails];
       for(Contact cont :lstContacts) {
           mapCont.put(cont.Email, cont);
       }       
       system.debug('mapCont:' + mapCont);

       lstUsers = [select username, Email, contactId from User where Email in :lstEmails];
       for(User u :lstUsers) {
           mapUser.put(u.Email, u);
       }       
       system.debug('mapUser:' + mapUser);
       
       for(Proctor_Registration__c pr :scope) {
           Contact fndCont = mapCont.get(pr.Proctor_Email__c);
           
           system.debug('fndCont:' + fndCont);
           
           if(fndCont == null || fndCont.AccountId == null) {           
               Account newAccount = new Account();
               newAccount.RecordtypeId = recordtypehelper.getRecordtypeID('Account','Business');
               newAccount.Name = pr.Proctor_First_Name__c + ' ' + pr.Proctor_Last_Name__c;
               newAccount.Member_Email__c = pr.Proctor_Email__c;
               lstEmails.add(pr.Proctor_Email__c);
               newAccounts.add(newAccount);
           }
       }
       insert newAccounts;
       
       lstAccounts = [select Id, Name, Member_Email__c from Account where Member_Email__c in :lstEmails];
       for(Account acct :lstAccounts) {
           mapAcct.put(acct.Member_Email__c, acct);
       }       

       for(Proctor_Registration__c pr :scope) {
           Contact fndCont = mapCont.get(pr.Proctor_Email__c);
           Account fndAcct = mapAcct.get(pr.Proctor_Email__c);
           if(fndCont == null && fndAcct != null) {
               Contact newContact = new Contact();
               newContact.RecordtypeId = recordtypehelper.getRecordtypeID('Contact','Business Relationship');
               newContact.FirstName=pr.Proctor_First_Name__c;
               newContact.LastName=pr.Proctor_Last_Name__c;
               newContact.Email=pr.Proctor_Email__c;
               newContact.AccountId=fndAcct.Id;               
               newContacts.add(newContact);
           }
       }
       insert newContacts;
       
       lstContacts = [select Id, Name, Email, do_not_fire__c,FirstName,LastName,GARP_Member_ID__c,Password__c,recordTypeId from Contact where Email in :lstEmails];
       List<User> userList=new List<User>();
       
       Profile pf = [SELECT Id FROM profile WHERE name='Customer Community' limit 1];
       for(Contact con :lstContacts) {
           mapCont.put(con.Email, con);
           
           User fUser = mapUser.get(con.Email);
           if(fUser == null) {
              User mockUser=new User();
              mockUser.contactId=con.Id;
              mockUser.username= con.Email;
              mockUser.firstname=con.FirstName;
              mockUser.lastname=con.LastName;
              mockUser.email=con.Email;
              mockUser.communityNickname = con.GARP_Member_ID__c + string.valueof(Math.random()).substring(4,9);
              mockUser.alias = con.GARP_Member_ID__c + string.valueof(Math.random()).substring(7,9);
              mockUser.profileid = pf.Id;
              mockUser.emailencodingkey='UTF-8';
              mockUser.languagelocalekey='en_US';
              mockUser.localesidkey='en_US';
              mockUser.timezonesidkey='America/New_York';             
              Database.DMLOptions dlo = new Database.DMLOptions();
              dlo.EmailHeader.triggerUserEmail = true;
              dlo.EmailHeader.triggerAutoResponseEmail= true;
              mockUser.setOptions(dlo);   
              userList.add(mockUser); 
              system.debug('mockUser == '+mockUser);
           }
       }       
       try {
       	insert userList;    
       } catch(DmlException e) {
		System.debug('The following exception has occurred: ' + e.getMessage());
	   }

       
       
       for(Proctor_Registration__c pr :scope) {
           Contact fndCont = mapCont.get(pr.Proctor_Email__c);
           if(fndCont != null) {
               pr.Contact__c = fndCont.Id;
           }
       }
       update scope;
   }
    
    
   global void finish(Database.BatchableContext BC){
   
   }
}