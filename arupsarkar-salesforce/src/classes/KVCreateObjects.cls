public with sharing class KVCreateObjects{


    public KVCreateObjects(){

    }
    
    public Account account{get; set;}
    public Contact contact{get; set;}
    public Goal__c accountGoal{get; set;}
    public Goal__c contactGoal{get; set;}
    public Goal_Team__c goalTeam{get; set;}
    public Goal_Achiever__c goalAchiever{get; set;}
    
    public Goal__c createAccountGoal(){
        //In the constructor create a Goal record with Goal Team
        Goal__c goal = new Goal__c();
        goal.Name = 'Account Goal';
        goal.Object__c = 'Account';
        goal.Field_Name__c = 'Rating';
        goal.From_Field_Value__c = 'Cold';
        goal.To_Field_Value__c = 'Hot';
        goal.Start_Time__c = Date.Today() - 30;
        goal.End_Time__c = Date.Today() + 30;
        
        insert goal;
        this.accountGoal = goal;
        return goal;    
    }
    
    public Goal__c createContactGoal(){
        //In the constructor create a Goal record with Goal Team
        Goal__c goal = new Goal__c();
        goal.Name = 'Contact Goal';
        goal.Object__c = 'Contact';
        goal.Field_Name__c = 'Level';
        goal.From_Field_Value__c = 'Secondary';
        goal.To_Field_Value__c = 'Primary';
        goal.Start_Time__c = Date.Today() - 30;
        goal.End_Time__c = Date.Today() + 30;
        
        insert goal;
        this.contactGoal = goal;
        return goal;    
    }    
    
    
    //create a Goal Team
    public Goal_Team__c createGoalTeam(Id goalId, String name){

        User user = [select Id from User where LastName = 'Sarkar' and FirstName = 'Arup' LIMIT 1];
        Goal_Team__c goalTeam = new Goal_Team__c();
        goalTeam.Name = name;
        goalTeam.Goal__c = goalId;
        goalTeam.User__c = user.Id;
        insert goalTeam;
        this.goalTeam =  goalTeam;
        return goalTeam;
        
    }
    
    
    //Create Account record
    public Account createAccount(){
        Account account = new Account();
        account.Name = 'Test Account';
        account.AccountNumber = 'X001';
        account.Phone = '6311231234';
        account.Fax = '6311231235';
        account.BillingStreet = '1 Main Street';
        account.BillingCity = 'New York';
        account.BillingState = 'NY';
        account.BillingPostalCode = '11355';
        account.BillingCountry = 'USA';
        account.Rating = 'Hot';
        
        insert account;
        return account;
    
    }
    
    public Account updateAccount(){
        Account account = createAccount();
        account.Rating = 'Cold';
        update account;
        
        return account;
    }
    
    //Create Contact Record
    public Contact createContact(Id accountId){

        Contact contact = new Contact();
        contact.FirstName = 'Test FirstName';
        contact.LastName = 'Test LastName';
        contact.Title = 'Title Name';
        contact.AccountId = accountId;
        contact.Phone = '2122231223';
        contact.Mobilephone = '2122231224';
        contact.Email = 'jay@xyz.com';
        contact.Level__c = 'Secondary';                
        
        insert contact;
        return contact;
    }
    
    
    public Contact updateContact(Id accountId){
        Contact contact = createContact(accountId);
        contact.Level__c = 'Primary';
        update contact;
        return contact;
    }
    
    public List<Goal_Achiever__c> getGoalAchiever(){

        List<Goal_Achiever__c> goalAchieversList = new List<Goal_Achiever__c>();    
        
        //Create the goals and the teams    
        Goal__c accountGoal = createAccountGoal();
        Goal__c contactGoal = createContactGoal();
        Goal_Team__c accountGoalTeam = createGoalTeam(accountGoal.Id, 'Account Goal team');
        Goal_Team__c contactGoalTeam = createGoalTeam(contactGoal.Id, 'Contact Goal team');        
        //Create the account contact records the, trigger will evaluate and create goal achievers
        Account account = updateAccount();
        Contact contact = updateContact(account.Id);

        this.contact = contact;
        this.account = account;    
    
        Goal_Achiever__c accountGoalAchiever = [SELECT Id, Name, Object_Name__c, Object_Id__c, Description__c, Goal_Team__c, Goal_Team__r.User__c,
                                    Goal_Team__r.User__r.Name, CreatedDate, Status__c
                                    FROM Goal_Achiever__c 
                                    //WHERE Status__c != 'Complete'
                                    WHERE Goal_Team__r.Goal__c = :accountGoal.Id
                                    ORDER BY CreatedDate LIMIT 1];
                                    
        System.debug(' ~~~~~~~~~~~~~~~ Account Goal Achiever Name : ' + accountGoalAchiever.Name + ', ' + accountGoalAchiever.Object_Id__c);

        goalAchieversList.add(accountGoalAchiever);
        

        Goal_Achiever__c contactGoalAchiever = [SELECT Id, Name, Object_Name__c, Object_Id__c, Description__c, Goal_Team__c, Goal_Team__r.User__c,
                                    Goal_Team__r.User__r.Name, CreatedDate, Status__c
                                    FROM Goal_Achiever__c 
                                    //WHERE Status__c != 'Complete'
                                    WHERE Goal_Team__r.Goal__c = :contactGoal.Id
                                    ORDER BY CreatedDate LIMIT 1];
                                    
        System.debug(' ~~~~~~~~~~~~~~~ Contact Goal Achiever Name : ' + contactGoalAchiever.Name + ', ' + contactGoalAchiever.Object_Id__c);
        
        goalAchieversList.add(contactGoalAchiever);
    
        return goalAchieversList;
    
    }

}