public class CountryListAcc{
    
    //Public properties
    public List<Account> lstAcc {get; set;}
    public List<Contact> lstCon {get; set;}
    public List<DContract__c> lstContr {get; set;}
    public List<DContract__c> lstContrclosed {get; set;}
    public List<Project__c> lstDeplmnt {get; set;}
    public List<Project__c> lstDeplmntClosed {get; set;}
    public List<Opportunity> lstoppty {get; set;}
    public List<Opportunity> lstopptyClosed {get; set;}
    public List<ParentAcc> hierarchy {get; set;}    
    public String recId{get; set;}
    public String SearchString {get;set;}    
    Public Boolean showpage{get;set;}
    Public Boolean showChild{get;set;}
    
    Public List<AccountWrapper> wrapperList{get;set;}
    
    public map<id,string> accountMap=new map<id,string>();
    
    //Account selected by radio button
    public String selectedAccountId { get; set; }
    public List<Account> childAccounts { get; set; }
    
    //Private variables
    Set<Id> setId = new Set<Id>();
    List<Id> accIdList = new List<Id>();
    
     //Constructor
    public CountryListAcc(){
        
       
        
        //Initializing properties
        childAccounts = new List<Account>();
        lstCon = new List<Contact>();
        lstContr = new List<DContract__c>();
        lstContrclosed = new List<DContract__c>();
        lstDeplmnt = new List<Project__c>();
        lstDeplmntClosed = new List<Project__c>();
        lstoppty = new List<Opportunity>();
        lstopptyClosed = new List<Opportunity>();
        showPage = False;
        wrapperList = new List<AccountWrapper>();
        accountMap.clear();
        String strX = ApexPages.currentPage().getParameters().get('q');
        
        String accountId = ApexPages.currentPage().getParameters().get('id');
        
        if(strX!=null){
            SearchString=strX;
            Search();
            if(accountId!=null){
                selectedAccountId=accountId;
                searchByAccount();
            }
        }
    }
    
    //Function to search accounts
    public pageReference Search()
    {  
        //Clears all collections binded on page
        wrapperList.clear();
        childAccounts.clear();
        lstCon.clear();
        lstContrclosed.clear();
        lstDeplmnt.clear();
        lstDeplmntClosed.clear();
        lstoppty.clear();
        lstopptyClosed.clear();     
        
        //Select records from Account according to given search string
        String SearchQuery='Select Name,Id,Country__r.Name,Status__c,Parent.Name from account where name like \'%'+SearchString+'%\'';  
        lstAcc = Database.query(SearchQuery);
       
       //Create collection of wrapper class
        if(lstAcc.size() > 0){
            for(Account ac: lstAcc){
                wrapperList.add(new AccountWrapper(ac,false));
                setId.add(ac.Id);
                accIdList.add(ac.Id);
                accountMap.put(ac.Id,ac.Name);
            }    
        }
                
        for(Account acc: [Select Name,Id,Country__r.Name,Status__c,Parent.Name From Account Where ParentId IN : accIdList])
        {
            if(!setId.contains(acc.Id))
            {
                wrapperList.add(new AccountWrapper(acc,true));
                lstAcc.add(acc);
                setId.add(acc.Id);
            }
            
        }
    
        showPage = True;
        
        PageReference page=new PageReference('/apex/CountryList?q='+SearchString);
        //page.getParameters().put('q', SearchString);
        
        page.setRedirect(true);
        
        return page;
    }
    
    //Action on radiobutton
    public PageReference searchByAccount(){
        
        
        string selectedAccountName=accountMap.get(selectedAccountId);
        PageReference page=new PageReference('/apex/CountryList?q='+selectedAccountName+'&id='+selectedAccountId);
        page.setRedirect(true);
        
        
        
        //Get child accounts
        childAccounts = [Select Name,Id,Country__r.Name,Status__c,Parent.Name from account where Parent.Id =: selectedAccountId]; 
        
        //Create set of child accounts IDs
        Set<Id> childAccountIDs = new Set<Id>();
        if(childAccounts.size() > 0){
            for(Account ac: childAccounts){                
                childAccountIDs.add(ac.Id);                
            }    
        }       
       
       //Get all children objects by account Id
       
       //Contacts
        lstCon=[SELECT Id, Account.Name,Email,Title, Name, Country__c 
                FROM Contact 
                WHERE AccountId =: selectedAccountId];
        
        //Contracts Open        
        lstContr =   [SELECT Id, Name,Account__c, DContract__c.Account__r.Name, 
                                     Contract_Start_Date__c, Contract_End_Date__c, Project_Manager__c, 
                                     Project_Manager__r.Name, Status__c, Short_Description__c 
                          FROM DContract__c 
                          WHERE Account__c =: selectedAccountId AND Status__c != 'Complete' ];              
        
        //Contracts Closed      
        lstContrclosed = [SELECT Id, Name,Account__c, DContract__c.Account__r.Name, 
                                     Contract_Start_Date__c, Contract_End_Date__c, Project_Manager__c, 
                                     Project_Manager__r.Name, Status__c, Short_Description__c 
                          FROM DContract__c 
                          WHERE Account__c =: selectedAccountId AND Status__c = 'Complete' ];
        
        //Deployements Open
        lstDeplmnt = [SELECT Id, Name, Implementing_Account__c,Project__c.Implementing_Account__r.Name,
                             Project_End_Date__c, Project_Manager__c, Project__c.Project_Manager__r.Name,
                             Status__c, Short_Description__c 
                       FROM Project__c WHERE Implementing_Account__c =: selectedAccountId AND Status__c != 'Complete'];
        
        //Deployements Closed       
        lstDeplmntClosed = [SELECT Id, Name, Implementing_Account__c,Project__c.Implementing_Account__r.Name,
                                   Project_End_Date__c, Project_Manager__c, Project__c.Project_Manager__r.Name,
                                   Status__c, Short_Description__c 
                             FROM Project__c WHERE Implementing_Account__c =: selectedAccountId AND Status__c ='Complete'];
        
        //Opportunities Open
        lstoppty = [SELECT Id, Name,Account.Name, Description,Country__c,Country__r.Name, StageName
                    FROM Opportunity 
                    WHERE AccountId =: selectedAccountId AND 
                         (StageName = 'Stage 1 - Connect' OR 
                          StageName = 'Stage 2 - Talking' OR 
                          StageName = 'Stage 3 - Prospect' OR 
                          StageName = 'Stage 4 - Proposal Development' OR 
                          StageName = 'Stage 5 - Submitted' OR 
                          StageName = 'Stage 6 - In Negotiations' OR 
                          StageName = 'On Hold')];
        
        //Opportunities Closed 
        lstopptyClosed = [SELECT Id, Name,Account.Name, Description,Country__c,Country__r.Name, StageName 
                          FROM Opportunity 
                          WHERE AccountId =: selectedAccountId AND (StageName = 'Closed - Lost' OR StageName = 'Closed - Won')];
        
        
        //Get all child objects by child accounts IDs
        
        //Contacts
        List<Contact> lstConChild =[SELECT Id, Account.Name,Email,Title, Name, Country__c 
                                    FROM Contact 
                                    WHERE AccountId IN: childAccountIDs];
        lstCon.addAll(lstConChild);
        
        //Contracts Open    
        List<DContract__c> lstContrChild =   [SELECT Id, Name,Account__c, DContract__c.Account__r.Name, 
                                                         Contract_Start_Date__c, Contract_End_Date__c, Project_Manager__c, 
                                                         Project_Manager__r.Name, Status__c, Short_Description__c 
                                              FROM DContract__c 
                                              WHERE Account__c IN: childAccountIDs AND Status__c != 'Complete' ];           
        
        lstContr.addAll(lstContrChild);     
       
       //Contracts Closed
        List<DContract__c> lstContrclosedChild = [SELECT Id, Name,Account__c, DContract__c.Account__r.Name, 
                                                             Contract_Start_Date__c, Contract_End_Date__c, Project_Manager__c, 
                                                             Project_Manager__r.Name, Status__c, Short_Description__c 
                                                  FROM DContract__c 
                                                  WHERE Account__c IN: childAccountIDs AND Status__c = 'Complete' ];
        
        lstContrclosed.addAll(lstContrclosedChild);
        
        //Deployements Open
        List<Project__c> lstDeplmntChild = [SELECT Id, Name, Implementing_Account__c,Project__c.Implementing_Account__r.Name,
                                                 Project_End_Date__c, Project_Manager__c, Project__c.Project_Manager__r.Name,
                                                 Status__c, Short_Description__c 
                                            FROM Project__c WHERE Implementing_Account__c IN: childAccountIDs AND Status__c != 'Complete'];
       
        lstDeplmnt.addAll(lstDeplmntChild);        
       
       //Deployements Closed
        List<Project__c> lstDeplmntClosedChild = [SELECT Id, Name, Implementing_Account__c,Project__c.Implementing_Account__r.Name,
                                                       Project_End_Date__c, Project_Manager__c, Project__c.Project_Manager__r.Name,
                                                       Status__c, Short_Description__c 
                                                 FROM Project__c WHERE Implementing_Account__c IN: childAccountIDs AND Status__c ='Complete'];
        
        lstDeplmntClosed.addAll(lstDeplmntClosedChild);
        
        //Opportunities Open
        List<Opportunity> lstopptyChild = [SELECT Id, Name,Account.Name, Description,Country__c,Country__r.Name, StageName
                                      FROM Opportunity 
                                      WHERE AccountId IN: childAccountIDs AND 
                                             (StageName = 'Stage 1 - Connect' OR 
                                              StageName = 'Stage 2 - Talking' OR 
                                              StageName = 'Stage 3 - Prospect' OR 
                                              StageName = 'Stage 4 - Proposal Development' OR 
                                              StageName = 'Stage 5 - Submitted' OR 
                                              StageName = 'Stage 6 - In Negotiations' OR 
                                              StageName = 'On Hold')];
         
        lstoppty.addAll(lstopptyChild);
        
        //Opportunities Closed
        List<Opportunity> lstopptyClosedChild = [SELECT Id, Name,Account.Name, Description,Country__c,Country__r.Name, StageName 
                                                 FROM Opportunity 
                                                 WHERE AccountId IN: childAccountIDs AND 
                                                 (StageName = 'Closed - Lost' OR StageName = 'Closed - Won')];
         
        lstopptyClosed.addAll(lstopptyClosedChild);   
        
        return page;                         
    }
    
   
    //Inner class for parent accounts
    public class ParentAcc{
        public List<Contact> Conlist {get; set;}
        public Account gparent {get;set;}
        public List<Child_Account__c>  chAcc{get; set;}

        public ParentAcc(Account  gp, List<Child_Account__c> c){
            chAcc = c;
            gparent = gp;
        }
    }
    
    //Function to fetch parent accounts
    public List<ParentAcc> mainnodes(){
        hierarchy = new List<ParentAcc>();
        List<Account> tempparent = [SELECT Id, Name, Phone FROM Account];
        
        for (Integer i =0; i< tempparent.size() ; i++){
            List<Child_Account__c> tempchildren = [SELECT Id, Name,Child_Account__c,Parent_Account__c 
                                                   FROM Child_Account__c WHERE Parent_Account__c = :tempparent[i].Id];
            if(tempchildren.size() > 0)
                hierarchy.add(new ParentAcc(tempparent[i],tempchildren));
        }
        
        System.Debug('________ hierarchy ________'+hierarchy);
        System.Debug('___ tempparent ____'+tempparent);
        return hierarchy;
    }
    
    //Functon to fetch child objects
    public void ContList(){
        lstCon=[SELECT Id, Account.Name,Email,Title, Name, Country__c FROM Contact WHERE AccountId =: recId];
        
        lstContr = [SELECT Id, Name,Account__c, DContract__c.Account__r.Name, Contract_Start_Date__c, Contract_End_Date__c, 
                            Project_Manager__c, Project_Manager__r.Name, Status__c, Short_Description__c 
                    FROM DContract__c WHERE Account__c =: recId AND Status__c = 'Active' ];
        
        lstContrclosed = [SELECT Id, Name,Account__c, DContract__c.Account__r.Name, Contract_Start_Date__c, Contract_End_Date__c, 
                                 Project_Manager__c, Project_Manager__r.Name, Status__c, Short_Description__c 
                          FROM DContract__c WHERE Account__c =: recId AND Status__c = 'Complete' ];
        
        lstDeplmnt = [SELECT Id, Name, Implementing_Account__c,Project__c.Implementing_Account__r.Name, Project_End_Date__c, 
                             Project_Manager__c, Project__c.Project_Manager__r.Name, Status__c, Short_Description__c 
                      FROM Project__c WHERE Implementing_Account__c =:recId AND Status__c ='Active'];
        
        lstDeplmntClosed = [SELECT Id, Name, Implementing_Account__c,Project__c.Implementing_Account__r.Name, Project_End_Date__c, 
                                   Project_Manager__c, Project__c.Project_Manager__r.Name, Status__c, Short_Description__c 
                            FROM Project__c WHERE Implementing_Account__c =:recId AND Status__c ='Complete'];
        
        lstoppty = [SELECT Id, Name,Account.Name, Description,Country__c,Country__r.Name, StageName 
                    FROM Opportunity WHERE AccountId =: recId AND 
                    (StageName = 'Stage 1 - Connect' OR StageName = 'Stage 2 - Talking' OR 
                     StageName = 'Stage 3 - Prospect' OR StageName = 'Stage 4 - Proposal Development' OR 
                     StageName = 'Stage 5 - Submitted' OR StageName = 'Stage 6 - In Negotiations' OR StageName = 'On Hold')];
         
        lstopptyClosed = [SELECT Id, Name,Account.Name, Description,Country__c,Country__r.Name, StageName 
                          FROM Opportunity WHERE AccountId =: recId AND 
                          (StageName = 'Closed - Lost' OR StageName = 'Closed - Won')];
    }
    
    //Inner class to decide account is child or not
    public class AccountWrapper {
        public Account acc {get; set;}
        public Boolean child{get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. When we create a new cContact object 
        //we pass a Contact that is set to the con property. We also set the selected value to false
        public AccountWrapper(Account c,Boolean ch) {
            acc = c;
            child = ch;
            selected = false;
        }
    }
}