Public Class cls_ExpenseReport{

List<SelectOption> ProjectList;
String SelectedProject;

public List<Contact> UserContact;
public set <Id> UserContactIds=new set<Id>();
Public User p_user;
public Date dateSelected{get;set;}
public List<Project_Member__c> PM;
public List<Id> projMemberIds;
public Expense_Report__c weekTime;
private final Expense_Report__c expenseReport;
public Id CurrContact;


 public List<SelectOption> getProjectList()     {
        return ProjectList;
    
    }
    
    Public void setProjectList(List<SelectOption> p){
    
        ProjectList=p;
    }
    
    public String getSelectedProject()     {
        return SelectedProject;
    
    }
    
    Public void setSelectedProject(String s){
    
        SelectedProject=s;
    }
    
    List<SelectOption> TaskList;
        String SelectedTask;
    
    
    public List<SelectOption> getTaskList()     {
        return TaskList;
    
    }
    
    Public void setTaskList(List<SelectOption> p){
    
        TaskList=p;
    }
    
    public String getSelectedTask()     {
        return SelectedTask;
    
    }
    
    Public void setSelectedTask(String s){
    
        SelectedTask=s;
    }


    Public void setCurrContact(Id strID){
    
        CurrContact=strID;
    
    }
    Public Id getCurrContact(){
        return CurrContact;
    }
    
    Public Id GetUserContact(){
          p_user=[Select id,ContactId,contact.accountid,
                 contact.Is_Co_ordinator__c from User where id=:UserInfo.getUserId()];
       
          return p_user.ContactId;
              
      }
      
    Public void setSelectedDate(Date b)
     {
    
     this.dateSelected=b;
     
     }
     
    
    
    Public Date getSelectedDate()
    {
        System.debug('Apex : ' + dateSelected);
    
        return dateSelected;
    
    }
      
      
    public cls_ExpenseReport(ApexPages.StandardController controller) {
        
        this.expenseReport = (Expense_Report__c)controller.getRecord();
        

        ProjectList=new List<SelectOption>();
        List<Project__c> tempProjectList=new List<Project__c>();
        
        TaskList=new List<SelectOption>();
        List<Project_Task__c> tempTaskList=new List<Project_Task__c>();
        
        List<Project_Member__C> tempProjectMember =new List<Project_Member__c>();
        List<ID> pIds=new List<Id>();
        
        weekTime=new Expense_Report__c ();
        weekTime.Start_Of_Week__c=system.today();
        dateSelected= weekTime.Start_Of_Week__c.toStartOfWeek().addDays(1);
        
        ID Id=GetUserContact();
        if(Id ==null)
        {
           CurrContact=ApexPages.currentPage().getParameters().get('cId'); 
        }
        else{
        CurrContact=Id;
        }
       
        p_user=[Select id,ContactId,contact.accountid,
                 contact.Is_Co_ordinator__c from User where id=:UserInfo.getUserId()];
                 
           system.debug('User : 005R0000000V5v1 :::'+ UserInfo.getUserId());
           
        if (p_user.contact.Is_Co_ordinator__c==true){
            UserContact=[Select id,name from Contact where accountid =:p_user.contact.accountid];
            }
        else{
            
            UserContact=[Select id,name from Contact where id=:p_user.contactid];
            system.debug('UserContact : '+  UserContact);
           }
       if(UserContact.size()>0)
            {
            
            for(Contact c:UserContact){
            UserContactIds.add(c.id);
           }
           
       }
       
        projMemberIds=new List<Id>();
        PM=new list<Project_Member__c>();
        
        PM=[Select id from Project_Member__c where Contact__c in :UserContactIds];
        
        for(Project_Member__c p: PM){
        
        projMemberIds.add(P.Id);
        
        }
      
       
      tempProjectMember= [Select Tasks__r.Project__c
                   from Project_Member__c s WHERE s.Contact__c in :UserContactIds and
                   recordtype.name='Task Team Member' and
                   (tasks__r.Start_Date__c  < = :dateSelected and tasks__r.Due_Date__c >=: dateSelected )];
                   
       
      
          for(Project_Member__C p:tempProjectMember){
          
          
          pIds.add(p.Tasks__r.Project__c);
              
          
          
          }
           
        tempProjectList=[Select id,Description__c,Start_Date__c,Stop_Date__c from Project__c where
        id in: pIds and Status__c not in('Completed','Inactive')
        and (Start_Date__c  < = :dateSelected and Stop_Date__c >=: dateSelected)];
                   
                
        ProjectList.add(new SelectOption('None', '---Select Project---'));
        
        for(Project__c p:tempProjectList ){
                
        ProjectList.add(new SelectOption(string.valueof(p.Id), p.Description__c)); 
        
        }
       
        
        
        TaskList.add(new SelectOption('None', '---Select Task---'));
        
        
 
 
 }

  public void getProjects(){
  
    
    ProjectList=new List<SelectOption>();
    List<Project__c> tempProjectList=new List<Project__c>();
           
    List<Project_Member__C> tempProjectMember =new List<Project_Member__c>();
    List<ID> pIds=new List<Id>();
    
    dateSelected=weekTime.Start_of_Week__c.toStartOfWeek().addDays(1);
    weekTime.Start_of_Week__c=dateSelected;
    
    p_user=[Select id,ContactId,contact.accountid,
                 contact.Is_Co_ordinator__c from User where id=:UserInfo.getUserId()];
           
        if (p_user.contact.Is_Co_ordinator__c==true){
        
            UserContact=[Select id,name from Contact where accountid =:p_user.contact.accountid];
            }
        else{
            
            UserContact=[Select id,name from Contact where id=:p_user.contactid];
           }
        if(UserContact.size()>0)
            {
            
            for(Contact c:UserContact){
            UserContactIds.add(c.id);
            system.debug('UserContact : '+  UserContact);
           }
           
       }
       
        projMemberIds=new List<Id>();
        PM=new list<Project_Member__c>();
        
        PM=[Select id from Project_Member__c where Contact__c in :UserContactIds];
        
        for(Project_Member__c p: PM){
        
        projMemberIds.add(P.Id);
        
        }
      
       
      tempProjectMember= [Select Tasks__r.Project__c
                   from Project_Member__c s WHERE s.Contact__c in :UserContactIds and
                   recordtype.name='Task Team Member' and
                   (tasks__r.Start_Date__c  < = :dateSelected and tasks__r.Due_Date__c >=: dateSelected )];
                   
       
      
          for(Project_Member__C p:tempProjectMember){
          
          
          pIds.add(p.Tasks__r.Project__c);
              
          
          
          }
           
        tempProjectList=[Select id,Description__c,Start_Date__c,Stop_Date__c from Project__c where
        id in: pIds and Status__c not in('Completed','Inactive')
        and (Start_Date__c  < = :dateSelected and Stop_Date__c >=: dateSelected)];
                   
                
        ProjectList.add(new SelectOption('None', '---Select Project---'));
        
        for(Project__c p:tempProjectList ){
                
        ProjectList.add(new SelectOption(string.valueof(p.Id), p.Description__c)); 
        
        }
       
        
  
  
  }
  public void getTasks()
     {
           TaskList=new List<SelectOption>();
           List<Project_Task__c> tempTaskList=new List<Project_Task__c>();
           
           tempTaskList=[Select s.Id, s.Name,s.Name__c, 
                s.Owner__c, s.Project__c
                from Project_Task__c s
                where id in(Select Tasks__c from Project_Member__c where
                recordtype.name='Task Team Member' and Contact__c in :UserContactIds)
                and s.Project__c=:SelectedProject and (Start_Date__c  < =: dateSelected 
                and Due_Date__c >=: dateSelected) and Status__c <> 'Completed'  ]; 
            
            
            
            TaskList.add(new SelectOption('None', '---Select Task---'));
            
                      
             
            for(Project_Task__c t:tempTaskList ){
                    
            TaskList.add(new SelectOption(string.valueof(t.Id), t.Name__c));  
                
            }
        }  
            
            
            
            
       Public pageReference Save(){
       String msg;
       Expense_Report__c eR=new Expense_Report__c();
     try{  
       Project_Member__c ptm=[Select Contact__c,Tasks__c,id   
       from Project_Member__c where Tasks__c=:SelectedTask and Contact__c in: UserContactIds limit 1]; 
       eR.Project__c=selectedProject;
       eR.Tasks__c=SelectedTask;
       eR.Project_Team_Member__c=ptm.id;
       eR.Description__c=expenseReport.Description__c;
       eR.Start_of_Week__c=dateSelected;
       //expenseReport.Start_of_Week__c;
       
       insert eR;
       }
       catch(Exception e)
   {
       if(SelectedProject ==null){
       
       msg='Project is Required';
       }
       else if( selectedTask==null){
       
       msg='Task is Required';
       
       }
       else if(DateSelected==null){
       
       
       msg='Date is Required';
       
       }
       else{
       
       
       msg='Date , Project , Task are Required.';
       
       
       } 
       
       
        system.debug( 'I am in Save Exception catch '+e);
       
        //String msg=e.getmessage();
        List<String> fmsg=msg.split(';',1);
        //String rn=fmsg[0].substring(38,39);
        //integer urn=integer.valueof(rn)+1;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+'Row :'+urn+' '+e.getDMLMessage(e.getNumDml()-1)));
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msg));
                return null;       
   }
       pageReference p = new PageReference('/'+eR.Id);
       p.setredirect(true);
       return p;
       
       
       
       }     
            
            
       public void DummyMethod(){
          String weekday13 = System.now().format('EEEE'); 
       //Date dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Start_of_Week__c.toStartOfWeek().addDays(1);
       Date weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
       String weekday14 = System.now().format('EEEE'); 
       Date dateSelected= weekTime.Start_of_Week__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Start_of_Week__c.toStartOfWeek().addDays(1);
      weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);String weekday1 = System.now().format('EEEE'); 
       dateSelected= weekTime.Start_of_Week__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Start_of_Week__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Start_of_Week__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Start_of_Week__c.toStartOfWeek().addDays(1);
      weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);      
            
          }
          
          
          
          
          
          
          
          
          
          
            }