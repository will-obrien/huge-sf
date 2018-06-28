public class cls_TimeLog_v3 {

  
static integer indexRow =0;
string jprop='test 111' ;



Public String MondayLabel;
Public String TuesdayLabel;
Public String WednesdayLabel;
Public String ThursdayLabel;
Public String FridayLabel;
Public String SaturdayLabel;
Public String SundayLabel;


public String getjprop()
{
return jprop;
}
public void setjprop(String j)
{
jprop=j;
}

    String selProject,selTask;
    public Date dateSelected{get;set;}
     List<Time_Log__c> approvedtimeLog;
    List<prj_time>  approvedtimeLog_recs;
    List<Time_Log__c> submittedtimeLog;
    List<prj_time>  submittedtimeLog_recs;

    List<Project_Task__c> tasksForProject=new List<Project_Task__c>();
    //Public List<Project__c> prj1;
    List<Project_Member__c> prj=new List<Project_Member__c>();  
    public List<prj_time> timeLog_recs;//timeLog_recs=new List<prj_time>();
    Public Boolean bolTask{get;set;}
    boolean flag=true;
    public List<Time_Log__c> timeLog {get; set;}
    public Time_Log__c weekTimeLog {get; set;}
    public Time_Log__c weekTime {get; set;}
    public List<Contact> UserContact;
    public set <Id> UserContactIds=new set<Id>();
    Public User p_user;
    
    public Integer delIndex;
    
    public List<Project_Member__c> PM;
    public List<Id> projMemberIds;
    List<Project__c>  ddlProject;
    public Id CurrContact;
   // public List<Project__c> prj1;
   
   Public void setCurrContact(Id strID){
     
      CurrContact=strID;
    
    }
    Public Id getCurrContact(){
     return CurrContact;
    }

    Public Id GetUserContact(){
          p_user=[Select id,ContactId,contact.accountid,
                 contact.Is_Co_ordinator__c from User where id=:UserInfo.getUserId()];
         //if(p_user <> null)
          return p_user.ContactId;
          // else
           //return   ApexPages.currentPage().getParameters().get('cId');        
      }

    //.................... Constructor .....................
        //public cls_TimeLog_v3(ApexPages.StandardController controller){}
      
        public cls_TimeLog_v3(ApexPages.StandardController controller) {
        
        
        
         timeLog_recs=new List<prj_time>();
         
        ID Id=GetUserContact();
        if(Id ==null)
        {
           CurrContact=ApexPages.currentPage().getParameters().get('cId'); 
        }
        else{
        CurrContact=Id;
        }
        system.debug('Phone Booth :'+ Id);
        
       system.debug('CurrentContact from test Class' + CurrContact);
       bolTask=true;
       String weekday1 = System.now().format('EEEE'); 
       //Date dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
       //Date weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ weekday1);
       
      //***timeLog = new List<Time_Log__c>();        
      // timeLog.add(new Time_Log__c ());
      
        //   p_user=[Select id,ContactId,contact.accountid,
     // contact.Is_Co_ordinator__c from User where id=:UserInfo.getUserId()];
      
      //if (p_user.contact.Is_Co_ordinator__c==true)
         //UserContact=[Select id,name from Contact where accountid =:p_user.contact.accountid];
      // else
         UserContact=[Select id,name from Contact where id=:CurrContact];
         
         system.debug('UserContact' + UserContact.size());
       if(UserContact.size()>0)
       {
       for(Contact c:UserContact)
       UserContactIds.add(c.id);
       }
       projMemberIds=new List<Id>();
       PM=new list<Project_Member__c>();
        
        PM=[Select id from Project_Member__c where Contact__c in :UserContactIds];
        
        for(Project_Member__c p: PM){
        
         projMemberIds.add(P.Id);
        
        }
        system.debug('PM : projMemberIds ' + projMemberIds);
        ddlProject=new List<Project__c>();
        
        
        
        weekTime=new Time_Log__c ();
        
        system.debug('ddlProject : '+ ddlProject);
        
        String strDate= System.currentPageReference().getParameters().get('currdatevalue');
        
       if(strDate ==null){
       
           weekTime.Week_Start_Date__c=system.today();
           dateSelected=weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
           weekTime.Week_Start_Date__c=dateSelected;
       }
       else{
       List <String> datepart=strDate.split(' ',2);
       List <String> dateelements=datepart[0].split('-',3);
       //Date DateSet=date.valueOf(strDate);
       system.debug('dateelements  '+dateelements);
        Date Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
            //Date Dateset=Date.newInstance(2010,03,29);

            //dateSelected=Date.newInstance(2010,03,29);//DateSet;
            dateSelected=Dateset;
            system.debug('URL date'+dateSelected);
            weekTime.Week_Start_Date__c=dateSelected;
       }
       
       
        List<Project_Member__C> tempProjectMember =new List<Project_Member__c>();
       List<Project__c> tempProjectList=new List<Project__c>();
       
   /*    tempProject=[Select Id ,ProjectId__C,ProjectName__c ,Contact__c
                   from Project_Member__c s WHERE s.Contact__c in :UserContactIds and
                   recordtype.name='Task Team Member' and
                   (tasks__r.Start_Date__c  < = :dateSelected and tasks__r.Due_Date__c >=: dateSelected )];
      */
       List<ID> pIds=new List<Id>();
       
      tempProjectMember= [Select Tasks__r.Project__c
                   from Project_Member__c s WHERE s.Contact__c in :UserContactIds and
                   recordtype.name='Task Team Member' and
                   (tasks__r.Start_Date__c  < = :dateSelected and tasks__r.Due_Date__c >=: dateSelected )];
                   
       
      // List<ID> pIds=new List<Id>();
      for(Project_Member__C p:tempProjectMember){
      
      
      pIds.add(p.Tasks__r.Project__c);
          
      
      
      }
       
       ddlProject=[Select id,Description__c,Start_Date__c,Stop_Date__c from Project__c where
        id in: pIds and Status__c not in('Completed','Inactive')
         and (Start_Date__c  < = :dateSelected and Stop_Date__c >=: dateSelected)];
               
       system.debug('Apex: DDLProject ;  '+ ddlProject);
       
       
       timeLog=[Select id,Tasks__r.name,Tasks__r.name__c,RowTotalForVF__c,
       Contractor__c,Contractor__r.name,Status__c,Week_total_Hours__c,Tasks__r.Project__r.Stop_Date__c,

       Tasks__r.Project__c,Tasks__r.Project__r.name,Tasks__r.Project__r.Description__c,

       Short_Description__c,Saturday_Hours__c,Sunday_Hours__c,Monday_Hours__c,Tuesday_Hours__c,
       Wednesday_Hours__c,Thursday_Hours__c,Friday_Hours__c from Time_Log__c where
       Project_Member__c in :projMemberIds and Week_Start_Date__c=:dateSelected 
       and Status__c not in('Approved','Submitted')];
      system.debug('Initial Time logs'+timeLog);
    
        if(timeLog.size()==0)
        {
        Time_Log__c newtimeLog=new Time_Log__c ();
        timeLog.add(newtimeLog);
    }
   /*   weekTimeLog=[Select Id,Name,Week_Start_Date__c,Saturday_Hours__c,Sunday_Hours__c,Contractor__r.name,
       Monday_Hours__c,Tuesday_Hours__c,Wednesday_Hours__c,Friday_Hours__c,Short_Description__c,
       Project_Member__c,Tasks__c,Work_Date__c,Work_Time__c,
       Work_Type__c from Time_Log__c limit 1];
     */  
        prj=[Select s.Id, s.Name, s.Project__c, s.Project__r.Id,
        s.Project__r.Name, s.Project__r.Description__c,
        s.Project_Team__c, s.Contact__c from 
        Project_Member__c s WHERE s.Contact__c in :UserContactIds and
        recordtype.name='Project Team Member' ];

 /*       system.debug('Projects fetched'+prj);
        if(prj.size()>0)
        { 
        
        selProject=prj[0].id;
        
        tasksForProject=[Select s.Id, s.Name, s.Owner__c, s.Project__c
        from Project_Task__c s
        where id in(Select Tasks__c from Project_Member__c where
        recordtype.name='Task Team Member' and Contact__c in :UserContactIds)
        and s.Project__c=:prj[0].id ];
        system.debug('Tasks'+tasksForProject);
        }
        system.debug('dateselcted '+dateSelected); */

        /*timeLog=[Select id,Tasks__r.name,Tasks__r.name__c,Contractor_Name__c,Contractor__c,
        Contractor__r.id,Contractor__r.name,Status__c,Week_total_Hours__c,
        Tasks__r.Project__c,Tasks__r.Project__r.name,
        Short_Description__c,Saturday_Hours__c,Sunday_Hours__c,Monday_Hours__c,Tuesday_Hours__c,
        Wednesday_Hours__c,Thursday_Hours__c,Friday_Hours__c,
        Tasks__r.Project__r.Description__c
        from Time_Log__c where
        Project_Member__c in: projMemberIds and Week_Start_Date__c=:dateSelected and Status__c not in('Approved','Submitted')]; */
        //system.debug('Initial Time logs'+timeLog);

    if(timeLog.size()==0)
    {
   //Time_Log__c newtimeLog=new Time_Log__c ();
  //prj_time p=new prj_time();
    timeLog_recs.add(new prj_time(new Time_Log__c (),ddlProject,UserContactIds));
    }
    else
    {
        for(Time_Log__c t:timeLog)
        {
        
        system.debug('Apex: t  '+ t );
        system.debug('Apex:ddlProject :  '+ ddlProject);
         system.debug('Apex:UserContactIds '+ UserContactIds); 
        timeLog_recs.add(new prj_time(t,ddlProject,UserContactIds));
        }
        
        
        
    }
      
      
      // ************** Code for Approved Time Records  **************************
      
    
    approvedtimeLog=new List<Time_Log__c>();
    approvedtimeLog_recs=new List<prj_time>();
    approvedtimeLog=[Select id,Tasks__r.name,Tasks__r.name__c,Contractor_Name__c,Contractor__c,
    Contractor__r.id,Contractor__r.name,Status__c,Week_total_Hours__c,RowTotalForVF__c,
    Tasks__r.Project__c,Tasks__r.Project__r.name,Tasks__r.Project__r.Stop_Date__c,
    Short_Description__c,Saturday_Hours__c,Sunday_Hours__c,Monday_Hours__c,Tuesday_Hours__c,
    Wednesday_Hours__c,Thursday_Hours__c,Friday_Hours__c,
    Tasks__r.Project__r.Description__c
    from Time_Log__c where
    Project_Member__c in :projMemberIds and Week_Start_Date__c=:dateSelected 
    and Status__c  in ('Approved')];
    
        if(approvedtimeLog.size() > 0)
        {
            for(Time_Log__c t:approvedtimeLog)
        {
                approvedtimeLog_recs.add(new prj_time(t,ddlProject,UserContactIds));
                
        }
        
        }
        else
        {
            //approvedtimeLog_recs.add(new prj_time(new Time_Log__c ()));
        }
        
        
        
          
      //**************** Code for Submitted Time Records  **********************
      submittedtimeLog = new List<Time_Log__c>();
      submittedtimeLog_recs=new List<prj_time>();
      
       submittedtimeLog=[Select id,Tasks__r.name,Tasks__r.name__c,Contractor_Name__c,Contractor__c,
    Contractor__r.id,Contractor__r.name,Status__c,Week_total_Hours__c,RowTotalForVF__c,
    Tasks__r.Project__c,Tasks__r.Project__r.name,
    Short_Description__c,Saturday_Hours__c,Sunday_Hours__c,Monday_Hours__c,Tuesday_Hours__c,
    Wednesday_Hours__c,Thursday_Hours__c,Friday_Hours__c,
    Tasks__r.Project__r.Description__c
    from Time_Log__c where
    Project_Member__c in :projMemberIds and Week_Start_Date__c=:dateSelected 
    and Status__c  in ('Submitted')];
    
        if(submittedtimeLog.size() > 0)
        {
            for(Time_Log__c t:submittedtimeLog)
        {
                submittedtimeLog_recs.add(new prj_time(t,ddlProject,UserContactIds));
                
        }
        
        }
        else
        {
            
        }  
      
        
    
    
    
       Date dateForLabel;
       dateForLabel=dateSelected;
       StrDate=String.ValueOf(dateForLabel);
       String month=dateForLabel.format();
       system.debug('Month' + month);
       List<String> datepart;
       datepart=StrDate.split(' ',2);
       List <String> dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
       Date Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
        String d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
        system.debug('My name is Earl 2' + d);
       
       MondayLabel= d;
       
       dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
      dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
       Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       TuesdayLabel= d;
       
       
       
       dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
      Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       WednesdayLabel= d;
    
    
     dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
      Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       ThursdayLabel= d;
       
       
       
       
       
       
       
        dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
      Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       FridayLabel= d;
    
     dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
      Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       SaturdayLabel= d;
       
       
       
       
        dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
      Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       SundayLabel= d;
    
    
    
    
    
    
          
    }
      
      
      
      
       
          
      
      
   public void setMonday(String s){
    
     MondayLabel='MON:' + s;
    }

    Public String getMonday(){
    
    return MondayLabel;
    
    }
    
    
    public void setTuesday(String s){
    
     TuesdayLabel='TUE:' + s;
    }

    Public String getTuesday(){
    
    return TuesdayLabel;
    
    }
    
    
    public void setWednesday(String s){
    
     WednesdayLabel='WED:' + s;
    }

    Public String getWednesday(){
    
    return WednesdayLabel;
    
    }
    
    public void setThursday(String s){
    
     ThursdayLabel='THU:' + s;
    }

    Public String getThursday(){
    
    return ThursdayLabel;
    
    }
    
    
    public void setFriday(String s){
    
     FridayLabel='FRI:' + s;
    }

    Public String getFriday(){
    
    return FridayLabel;
    
    }
    
    public void setSaturday(String s){
    
     SaturdayLabel='SAT:' + s;
    }

    Public String getSaturday(){
    
    return SaturdayLabel;
    
    }
    
    
    public void setSunday(String s){
    
     SundayLabel='SUN:' + s;
    }

    Public String getSunday(){
    
    return SundayLabel;
    
    }
    
    
       
      
    public void setdelIndex(integer i){
    
        delIndex=i;
    } 
    
    public integer getdelIndex(){
    
     return delIndex;
    
    }
    
    Public void setSelectedDate(Date b)
    {
    //system.debug('Apex: Setting the value :' + b);
     this.dateSelected=b;
     
     }
     
    
    
     Public Date getSelectedDate()
    {
    System.debug('Apex : ' + dateSelected);
    
    return dateSelected;
    
    }
  
   String errorLabel;
   public String geterrorLabel(){
    return errorLabel;
    
   
   }
   
   public void seterrorLabel(string s){ 
    errorLabel=s;
}
   
   public void changeDate(){
           system.debug('Inside ChangeDate()' );
       timeLog_recs=new List<prj_time>();
   
       String weekday1 = System.now().format('EEEE'); 
       //Date dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
       //Date weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       weekTime.Week_Start_Date__c=dateSelected;
       system.debug('Apex: Week of the day : '+ dateSelected);
       String StrDate;
       Date dateForLabel;
       dateForLabel=dateSelected;
       StrDate=String.ValueOf(dateForLabel);
       String month=dateForLabel.format();
       system.debug('Month' + month);
       List<String> datepart;
       datepart=StrDate.split(' ',2);
       List <String> dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
       Date Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
        String d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
        system.debug('My name is Earl 2' + d);
       
       MondayLabel= d;
       
       dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
      dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
       Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       TuesdayLabel= d;
       
       
       
       dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
      Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       WednesdayLabel= d;
    
    
     dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
      Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       ThursdayLabel= d;
       
       
       
       
       
       
       
        dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
      Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       FridayLabel= d;
    
     dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
      Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       SaturdayLabel= d;
       
       
       
       
        dateForLabel=dateForLabel.addDays(1);
       StrDate=String.ValueOf(dateForLabel);
       month=dateForLabel.format();
       system.debug('Month' + month);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
       
       system.debug('dateelements  '+dateelements);
      Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
       
         d=dateelements[2]+ '/'+dateelements[1];//+ '-' +dateelements[0];
       
       
       SundayLabel= d;
      if(timeLog_recs.size() >0){
        timeLog_recs.clear();}
        //approvedtimeLog_recs.clear();
        timeLog.clear();
        //approvedtimeLog.clear();

        timeLog=[Select Id,Tasks__r.name,Tasks__r.name__c,contractor__c,
        Contractor__r.name,Contractor__r.id,Status__c,Week_total_Hours__c,
        Tasks__r.Project__c,Tasks__r.Project__r.name,RowTotalForVF__c,
        Tasks__r.Project__r.Description__c,Tasks__r.Project__r.Stop_Date__c,
        Short_Description__c,Saturday_Hours__c,Sunday_Hours__c,Monday_Hours__c,Tuesday_Hours__c,
        Wednesday_Hours__c,Thursday_Hours__c,Friday_Hours__c from Time_Log__c where
        Project_Member__c in : projMemberIds  and Week_Start_Date__c=:dateSelected and  Status__c not in('Approved','Submitted')];
        //system.debug('Initial Time logs'+timeLog);
        if(timeLog.size()==0)
        {
        //Time_Log__c newtimeLog=new Time_Log__c ();
        //prj_time p=new prj_time();
        timeLog_recs.add(new prj_time(new Time_Log__c (),ddlProject,UserContactIds));
        }
        else
        {
        for(Time_Log__c t:timeLog)
        {
        timeLog_recs.add(new prj_time(t,ddlProject,UserContactIds));
        }
        }
   
        // ************** Code for Approved Time Records  **************************
      
   approvedtimeLog = new List<Time_Log__c>();
      approvedtimeLog_recs=new List<prj_time>();
    
    approvedtimeLog=[Select Id,Tasks__r.name,Tasks__r.name__c,Contractor_Name__c,Contractor__c,
    Contractor__r.id,Contractor__r.name,Status__c,Week_total_Hours__c,
    Tasks__r.Project__c,Tasks__r.Project__r.name,RowTotalForVF__c,
    Short_Description__c,Saturday_Hours__c,Sunday_Hours__c,Monday_Hours__c,Tuesday_Hours__c,
    Wednesday_Hours__c,Thursday_Hours__c,Friday_Hours__c,
    Tasks__r.Project__r.Description__c
    from Time_Log__c where
    Project_Member__c in :projMemberIds and Week_Start_Date__c=:dateSelected and Status__c in('Approved')];
    
        if(approvedtimeLog.size() > 0)
        {
            for(Time_Log__c t:approvedtimeLog)
        {
                approvedtimeLog_recs.add(new prj_time(t,ddlProject,UserContactIds));
                
        }
        
        }
        else
        {
            //approvedtimeLog_recs.add(new prj_time(new Time_Log__c ()));
        }
         //**************** Code for Submitted Time Records  **********************
         
         
         submittedtimeLog = new List<Time_Log__c>();
      submittedtimeLog_recs=new List<prj_time>();
         
         
        submittedtimeLog=[Select Id,Tasks__r.name,Tasks__r.name__c,Contractor_Name__c,Contractor__c,
        Contractor__r.id,Contractor__r.name,Status__c,Week_total_Hours__c,RowTotalForVF__c,
        Tasks__r.Project__c,Tasks__r.Project__r.name,
        Short_Description__c,Saturday_Hours__c,Sunday_Hours__c,Monday_Hours__c,Tuesday_Hours__c,
        Wednesday_Hours__c,Thursday_Hours__c,Friday_Hours__c,
        Tasks__r.Project__r.Description__c,Tasks__r.Project__r.Stop_Date__c
        from Time_Log__c where
        Project_Member__c in :projMemberIds and Week_Start_Date__c=:dateSelected 
        and Status__c  in ('Submitted')];

        if(submittedtimeLog.size() > 0)
        {
            for(Time_Log__c t:submittedtimeLog)
        {
                submittedtimeLog_recs.add(new prj_time(t,ddlProject,UserContactIds));
                system.debug('Submitted Records '+ submittedtimeLog_recs);
        }
        
        }
        else
        {
            
        }  
  
   }
   
   
   
   
   Public void showTimeEntryGrid(){
   
   String weekday1 = System.now().format('EEEE'); 
       //Date dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
       //Date weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
   }
   
   
   
   
   public void addrow(){
   
     timeLog_recs.add(new prj_time(new Time_Log__c (),ddlProject,UserContactIds));  
            
 }
              
              
   public PageReference save(){
     
   //timeLog_recs   
   system.debug('Save Method' + timeLog_recs);
   List<Time_Log__c> upsertlist=new List<Time_Log__c>();
   //try{
   for(prj_time pt:timeLog_recs )
   {
 //if(pt.tl.Short_Description__c==null){
 //errorLabel='Description Required';}
  //throw new ValidationException('Description Required');
   //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Validation Failed: Description is required.'));
  /// ApexPages.addMessages('Description is Required');
   //  pagereference pg=new PageReference('/apex/vf_TimeLog_v2');
   //pg.setredirect(true);
  //return pg;   } 
  system.debug('Date Selected : ' + weekTime.Week_Start_Date__c);
  system.debug('Date Selected : ' + dateSelected);
   system.debug('pt.id '+pt.tl.Id);
   system.debug('pt.SelectedTask '+pt.SelectedTask);
   system.debug('pt.t1.Monday_Hours__c  '+pt.tl.Monday_Hours__c);
   Time_Log__c curr_timelog;
   
   System.debug('Apex : Object  :' +  pt.tl);
   
   if(pt.tl.Id == null)
  { 
  system.debug('Apex: Inside the condition :' + pt.tl.Id);
  if(pt.SelectedTask != 'None'){
  Project_Member__c ptm=[Select Contact__c,Tasks__c,id 
  from Project_Member__c where Tasks__c=:pt.SelectedTask and 
  Contact__c in: UserContactIds limit 1]; //pt.SelectedContractor   Sobia

  curr_timelog= new Time_Log__c(Short_Description__c=pt.tl.Short_Description__c,
   Tasks__c=pt.SelectedTask,
   //contractor__c=pt.SelectedContractor,
   Project_Member__c=ptm.id,
   Project__c=pt.selectedProject,
   Monday_Hours__c=pt.tl.Monday_Hours__c,
   Tuesday_Hours__c=pt.tl.Tuesday_Hours__c,
   Wednesday_Hours__c=pt.tl.Wednesday_Hours__c,
   Thursday_Hours__c=pt.tl.Thursday_Hours__c,
   Friday_Hours__c=pt.tl.Friday_Hours__c,
   Saturday_Hours__c=pt.tl.Saturday_Hours__c,
   Sunday_Hours__c=pt.tl.Sunday_Hours__c,
   Week_Start_Date__c=dateSelected,    //weekTime.Week_Start_Date__c,
   Contractor_Name__c=pt.tl.Contractor_Name__c,RowTotalForVF__c=pt.tl.RowTotalForVF__c);
   //Status__c=pt.tl.Status__c;
   }
   }
   else{
   system.debug('I am in else condition');
   curr_timelog=pt.tl;
    //curr_timelog.contractor__c=pt.selectedContractor;
    curr_timelog.Short_Description__c=pt.tl.Short_Description__c;
   //pt.tl.Tasks__c=pt.SelectedTask;
   }
   //id=pt.tl.id;
   upsertlist.add(curr_timelog);
  }// for loop
  
   
   if(upsertlist.size()>0)
   {
   try{
   
      upsert upsertlist;
      }
   catch(Exception e)
   {
        //throw new ValidationException('Desc mandatory');
        system.debug( 'I am in Save Exception catch '+e);
        //ApexPages.addMessages(e);
        //for(integer j=0;j<e.getNumDml();j++)
        //{
        //integer rn=j+1;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+e.getmessage()));
        String msg=e.getmessage();
        List<String> fmsg=msg.split(';',1);
        String rn=fmsg[0].substring(38,39);
        integer urn=integer.valueof(rn)+1;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+'Row :'+urn+' '+e.getDMLMessage(e.getNumDml()-1)));
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Description is required for all rows '));
        //}
                return null;       
   }
   /*catch(ValidationException e)
   {
      system.debug( 'I am in catch '+e);
   ApexPages.addMessages(e);
   
   }*/

   }
   //pagereference pg=new PageReference('/apex/vf_TimeLog_v2?currdatevalue='+ dateSelected);
  // pg.setredirect(true);
  //return pg;
   //}catch(DMLException ex){
   //ApexPages.addMessages(ex);
  /* ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
'Description is Required ' + e.getMessage());
ApexPages.addMessage(myMsg);*/
   //ApexPages.addMessages(ex);
  //  }
   
   
     pagereference pg=new PageReference('/apex/vf_TimeLog_v2?currdatevalue='+ dateSelected);
   pg.setredirect(true);
  return pg; 
 
  
  }
  
  
  Public pageReference getSelectedTimeRecordsForApproval(){
  
  
   List<Time_Log__C> selectedTimeRows=new List<Time_Log__c>();
   List<prj_time> selectedTimeRowsToSave=new List<prj_time>();
   system.debug('Length: '+ timeLog_recs.size());
 
   for(prj_time ap : timeLog_recs){
  
      system.debug('sobia');
      system.debug('sobia Selected :'+ap.selected );
    
    if(ap.selected == True)
      {   
         system.debug('sobia Selected'+ ap.selected );

         System.debug('APEX : getSelectedTimeRecordsForApproval : Item Selected Is = ' + ap);                           
         selectedTimeRows.add(ap.tl);
         selectedTimeRowsToSave.add(ap);
      }                                                    
   }
   
   system.debug('selectedTimeRowsToSave :  '+ selectedTimeRowsToSave.size());
    
  List<Time_Log__c> upsertlist=new List<Time_Log__c>();
   try{ 
  if (selectedTimeRowsToSave.size()==0)
  {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
      'Select a row to submit for approval'));
      
      system.debug('approval message '+apexpages.getmessages());
      return null;
  
  }
   for(prj_time pt:selectedTimeRowsToSave)
   {
   
   Time_Log__c curr_timelog;
   System.debug('Apex' +  pt.tl);

   if(pt.tl.Id==null)
  { 
  
   System.debug('Inside the If statement ' +  pt.tl);
  Project_Member__c ptm=[Select Contact__c,Tasks__c,id 
  from Project_Member__c where Tasks__c=:pt.SelectedTask and 
  Contact__c in:UserContactIds limit 1];//pt.SelectedContractor];
  
  curr_timelog= new Time_Log__c(Short_Description__c=pt.tl.Short_Description__c,
   Tasks__c=pt.SelectedTask,
   //contractor__c=pt.SelectedContractor,
   Project__c=pt.selectedProject,
   Project_Member__c=ptm.id,
   Monday_Hours__c=pt.tl.Monday_Hours__c,
   Tuesday_Hours__c=pt.tl.Tuesday_Hours__c,
   Wednesday_Hours__c=pt.tl.Wednesday_Hours__c,
   Thursday_Hours__c=pt.tl.Thursday_Hours__c,
   Friday_Hours__c=pt.tl.Friday_Hours__c,
   Saturday_Hours__c=pt.tl.Saturday_Hours__c,
   Sunday_Hours__c=pt.tl.Sunday_Hours__c,
   Week_Start_Date__c=weekTime.Week_Start_Date__c,
   Contractor_Name__c=pt.tl.Contractor_Name__c,
   Status__c='Submitted',RowTotalForVF__c=pt.tl.RowTotalForVF__c);
   
   }
   else
   {
    curr_timelog=pt.tl;
   // curr_timelog.contractor__c=pt.selectedContractor;
    curr_timelog.Status__c='Submitted';
    curr_timelog.Short_Description__c=pt.tl.Short_Description__c;

    }
      //upsertlist.add(curr_timelog);
      upsert curr_timelog;
       system.debug('curr_timelog' + curr_timelog);
      
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(curr_timelog.Id);
        // Submit the approval request for the time sheet
        //Approval.ProcessResult result = Approval.process(req1);
       // result.getErrors();
        // Verify the result
       // System.assert(result.isSuccess());
        //System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status'+ result.getInstanceStatus());
    }
    
  }catch(Exception e){
   
   
    String msg=e.getmessage();
        List<String> fmsg=msg.split(';',1);
        String rn=fmsg[0].substring(38,39);
        integer urn=integer.valueof(rn)+1;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+'Row :'+urn+' '+e.getDMLMessage(e.getNumDml()-1)));
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Description is required for all rows '));
        //}
                return null;       
   
   } 
   //if(upsertlist.size()>0)
  // {
   //upsert upsertlist;
      // }
  
  pagereference pg=new PageReference('/apex/vf_TimeLog_v2?currdatevalue='+ dateSelected);
   //   pageReference pg=new pageReference('/apex/vf_TimeLog_v2');
   pg.setredirect(true);
     return pg;
  }
  
  
  
   Public PageReference dumSave(){
   
   pagereference pg=new PageReference('/apex/vf_TimeLog_v2?currdatevalue='+ dateSelected);
   pg.setredirect(true);
   return pg; 
 
   
   }
  
   public pageReference DeleteRow(){
   
    system.debug('delete Index: ' + delIndex );
    prj_time delRec=timeLog_recs.get(delIndex-1);
    system.debug('Index at which delete is called' + delRec);
    Time_Log__c timelogDel;
    timelogDel=timeLog_recs.get(delIndex-1).tl;
    
    prj_time recordsToDel;
    
    pagereference pg=new PageReference('/apex/vf_TimeLog_v2?currdatevalue='+ dateSelected);
   //   pageReference pg=new pageReference('/apex/vf_TimeLog_v2');
   
   pg.setRedirect(true);
    system.debug('Index at which delete is called' + timelogDel);
             
         if(timeLog_recs.get(delIndex-1).tl.Id ==null && delIndex <> null){
         
             timeLog_recs.remove(delIndex-1);
             return null;
         
         }
         else if(timeLog_recs.get(delIndex-1).tl.Id <> null){
             
             recordsToDel=timeLog_recs.get(delIndex-1);
             timelogDel=recordsToDel.tl;
             delete timelogDel;
         } 
         
        
         
       return pg;     
              }

  public PageReference Close()
  {
  PageReference p=new PageReference('/home/home.jsp');
  p.setredirect(true);
  return p;
  }
  
  
  
  
  public List<prj_time> getapprovedtimeLog_recs()
  {
      return approvedtimeLog_recs;
      }
    public List<prj_time> getsubmittedtimeLog_recs()
  {
      return submittedtimeLog_recs;
      }
  
      
  public List<prj_time> gettimeLog_recs()
  {
     return timeLog_recs;
  
  }
  
   Public  Decimal sumOfAllRows{get;set;}
   Public  Decimal sum;
   
   public Decimal getsumOfAllRows(){
            
                                    
                sumOfAllRows = getSum();     
                     
            
                return sumOfAllRows;  
         }
        
    public Decimal getSum(){
            
       for(prj_time s :timeLog_recs ){
                        
                sum = sumOfAllRows+ s.tl.RowTotalForVF__c;     
                     
            
         }
          return sum;  
         }
         //String jprop {get; set;}
             public PageReference validateDay(){
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Date out of Range')); 
                         return null;
             }
    /*string selectedProject;
    String selectedTask;
    system.debug('ValidateDay() method is called' + selectedProject +' : ' + selectedTask );
    ID pId=selectedProject;
    ID tId=selectedTask;
    String day;
    Project__c p=[select Id ,Name,Description__c,start_Date__c,Stop_Date__c  from Project__c
    where Id=:pId];
    if(day=='1' && dateSelected == p.Stop_Date__c){   
    
    }
    else if(day=='2' && dateSelected+1 == p.Stop_Date__c){
    
    }
    else if(day=='3' && dateSelected +2== p.Stop_Date__c){
        }
    else if(day=='4' && dateSelected+3 == p.Stop_Date__c){

    }
    
    else if(day=='5' && dateSelected+4 == p.Stop_Date__c){
    
    }
    else if(day=='6' && dateSelected+5 == p.Stop_Date__c){
 }
    else if(day=='1' && dateSelected+6 == p.Stop_Date__c){
    
    }

*/

    
    
   // }
      

  
  //wrapper class for project and task
  
  
  public class prj_time
  {
  
  public Boolean selected {get; set;}
  public decimal rowTotalHours{get;set;}
  
       
    public integer getIndexRow(){
    
    indexRow=indexRow+1;
    return indexRow;
    
    }
        
    public void setIndexRow(integer s){
     indexRow=s;

}
        public List<SelectOption> Project_list {get; set;}
        public List<Project__c> prj1;
        public List<SelectOption> Tasks_List {get; set;}
        public List<SelectOption> Contractor_list {get;set;}
        public String Project {get; set;}
        Public String Task {get; set;}

        public String SelectedProject;
        public String  SelectedTask;
        public String SelectedContractor;
        public Time_Log__c tl {get;set;}
        public Set <Id> UserContactIds= new set<Id>();
        public List<Contact> UserContact ;
        User p_user;
        public Date dateSelected;
        public Id CurrContact;
        Time_Log__c  weekTime=new Time_Log__c ();

   // public List<Project__c> prj1;
   
          
       // r=[Select id,ContactId,contact.accountid,
        //contact.Is_Co_ordinator__c from User where id=:UserInfo.getUserId()];
        
        public void setSelectedProject(String s)
           {
           SelectedProject=s;
           }
        public String getSelectedProject()
           {
           return SelectedProject;
           }
         public void setSelectedTask(String s)
           {
           SelectedTask=s;
           }
        public String getSelectedTask()
           {
           return SelectedTask;
           }
   /*     public void setSelectedContractor(String s)
           {
           SelectedContractor=s;
           }
        public String getSelectedContractor()
           {
           return SelectedContractor;
           } */
           
           
           
      /*     
           Public void setCurrContact(Id strID){
    
      CurrContact=strID;
    
    }
    Public Id getCurrCOntact(){
     return CurrContact;
    }

    Public Id GetUserContact(){
          p_user=[Select id,ContactId,contact.accountid,
                 contact.Is_Co_ordinator__c from User where id=:UserInfo.getUserId()];
         //if(p_user <> null)
          return p_user.ContactId;
                     
      }*/

    //.................... Constructor 
   //******************************************Constructor *****************************************************************************
   
   public prj_time(Time_Log__c  t ,List<Project__c> prjlist,set<ID> UserContactIdList)
   
   {         

           //UserContactIds=UserContactIds;
   
   
          /*   Id id=getUserContact();
             
               if(id==null){
                   CurrContact=ApexPages.currentPage().getParameters().get('cId'); 
               }
               else {
               CurrContact=id;
           }
               
               system.debug('Wrapper Class :' + CurrContact);
            if(p_user <> null){     
            if (p_user.contact.Is_Co_ordinator__c==true)
                 {UserContact=[Select id,name from Contact where accountid =:p_user.contact.accountid];}
            }else
           { UserContact=[Select id,name from Contact where id=:CurrContact];
            }
            system.debug('Wrapper Class : UserContact || ' + UserContact);  */
                          
           weekTime.Week_Start_Date__c=system.today();
            dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
            
             //weekTime.Week_Start_Date__c= dateSelected;

             p_user=[Select id,ContactId,contact.accountid,
                 contact.Is_Co_ordinator__c from User where id=:UserInfo.getUserId()];
            if (p_user.contact.Is_Co_ordinator__c==true)
            UserContact=[Select id,name from Contact where accountid =:p_user.contact.accountid];
            else
            UserContact=[Select id,name from Contact where id=:p_user.contactid];
            if(UserContact.size()>0)
            {
            for(Contact c:UserContact)
            UserContactIds.add(c.id);
       }
            system.debug('Apex: List - prjlist ' + prjlist.size());
            Project_list=new List<SelectOption>();
            Tasks_List=new List<SelectOption>();
            Contractor_list=new List<SelectOption>();
            tl=t;
            system.debug('current task '+ t.Tasks__r.name);
            //SelectedTask=t.Tasks__r.name;
            SelectedTask=t.Tasks__r.name__c;
            system.debug('SelectedTask  :'+SelectedTask);
            //Task=t.Tasks__c;
            system.debug('UserContactIds  '+UserContactIds );
            /*   List<Project__c>  prj1=[Select id,Description__c from Project__c where
            id in (Select Project__c from Project_Member__c s WHERE s.Contact__c in :UserContactIds and
            recordtype.name='Project Team Member')];  */
            prj1=new List<Project__c>();
            for(Project__c p: prjlist){

            prj1.add(p);
     
     }
            /*[Select s.Id, s.Name, s.Project__c, s.Project__r.Id,
            s.Project__r.Name, s.Project__r.Description__c,
            s.Project_Team__c, s.Contact__c from 
            Project_Member__c s WHERE s.Contact__c in :UserContactIds and
            recordtype.name='Project Team Member'];*/
            system.debug('prj1 '+prj1);

            List <Project_Task__c> tasksForProject1;
            List <Contact> contractorforTask1;
            tasksForProject1=new  List <Project_Task__c>();
            
            // t= timelog object records
        if(t.Tasks__r.Project__c<>null)
            {
            
            tasksForProject1=[Select s.Id, s.Name,s.Name__c, s.Owner__c, s.Project__c,
            s.Project__r.Description__c from Project_Task__c s
            where id in(Select Tasks__c from Project_Member__c where
            recordtype.name='Task Team Member' and Contact__c in :UserContactIds)
            and s.Project__c=:t.Tasks__r.Project__c and (Start_Date__c  < =: dateSelected 
            and Due_Date__c >=: dateSelected) and Status__c <> 'Completed'];
            
            system.debug('Task Inside contructor' + tasksForProject1);
            
            Project_list.add(new SelectOption(string.valueof(t.Tasks__r.Project__c),
            t.Tasks__r.Project__r.Description__c));
            // task found now check for if contractor is there on the time entry if 
            //there he should be on the top of the list.
           // contractorforTask1=[Select id,name from contact where id=:t.Contractor__c];
            //Contractor_list.add(new SelectOption(string.valueof(contractorforTask1.Id),
            //contractorforTask1.name);
        }
        else
        {
            if(prj1.size()>0){
            tasksForProject1=[Select s.Id, s.Name,s.Name__c, s.Owner__c, s.Project__c from Project_Task__c s
            where id in(Select Tasks__c from Project_Member__c where
            recordtype.name='Task Team Member' and Contact__c in :UserContactIds)
            and s.Project__c=:prj1[0].Id and (Start_Date__c  < =: dateSelected 
            and Due_Date__c >=: dateSelected) and Status__c <> 'Completed'];
             }
            
       system.debug('Else Statement :tasksForProject1 '+tasksForProject1);
       // fetch contractors for first task. all TTM members belonging the same account as the current user's contact.
     /* Sobia contractorforTask1=[Select Id ,name from contact where id in
       (select contact__C from Project_Member__c where recordtype.name='Task Team Member'
       and Tasks__c=:tasksForProject1[0].id)and accountid=:p_user.contact.accountId];*/
       
        }
        
        if(prj1.size() >0){
            for(Project__c pb: prj1) 
            { 
            //system.debug('pb.Project__r.Id'+pb.Project__r.Id);
            //system.debug ('pb.Project__r.Name'+pb.Project__r.Name);  
            if(pb.Id<>t.Tasks__r.Project__c) {         
              Project_list.add(new SelectOption(string.valueof(pb.Id), pb.Description__c));  
              }
            } 
        }
        else{
        
                   
            Project_list.add(new SelectOption('None', '----------None----------'));
        
        
        
        }
        
        
        
        
        
        
        
        
        
        
        
        
        if(t.Tasks__r.name__c<>null)
              {
                Tasks_List.add(new SelectOption(string.valueof(t.Tasks__c), t.Tasks__r.name__c)); 
              }
        
     if(tasksForProject1.size()>0){
        for(Project_Task__c tk: tasksForProject1) 
        {  
            if(tk.id<>t.Tasks__c)             
              {  Tasks_List.add(new SelectOption(string.valueof(tk.Id), tk.Name__c));  }
              
        } 
            
    }
    else{
       
       
       
       Tasks_List.add(new SelectOption('None', '----------None----------'));
       
       
       
       
       
       } 
   /* SOBIA     if(t.contractor__C<>null)
        {
                Contractor_list.add(new SelectOption(string.valueof(t.contractor__c),t.contractor__r.name));
        }
        for(contact ct:contractorforTask1)
        {
            if(ct.id<>t.contractor__c)
                Contractor_list.add(new SelectOption(string.valueof(ct.id),ct.name));
            }*/
        } 
        // This method is called when you change the selection in the Project Picklist 
        //   to populate the Tasks based on the selection made.
        
        public void getTasks()
            {
            //tasksForProject1.clear();
                 dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);

                system.debug('Task for Project record ' + UserContactIds);
                system.debug('Task for Project record ' +SelectedProject);
                
                List <Project_Task__c> tasksForProject1=[Select s.Id, s.Name,s.Name__C, 
                s.Owner__c, s.Project__c
                from Project_Task__c s
                where id in(Select Tasks__c from Project_Member__c where
                recordtype.name='Task Team Member' and Contact__c in :UserContactIds)
                and s.Project__c=:SelectedProject and (Start_Date__c  < =: dateSelected 
            and Due_Date__c >=: dateSelected) and Status__c <> 'Completed'  ];
                
                
                system.debug('Apex sobia: tasksForProject1 '+ tasksForProject1);
                system.debug('Apex: '+ tasksForProject1);
                
                
                if(Tasks_List.size() >0)
              {  Tasks_List.clear();}
                
                SelectedTask=tasksForProject1[0].Id;

                
                for(Project_Task__c tk: tasksForProject1) 
                {  

                // feb23 Tasks_List.add(new SelectOption(string.valueof(tk.Id), tk.Name));  
                Tasks_List.add(new SelectOption(string.valueof(tk.Id), tk.Name__c ));
                } 
                                 //getContractors();
            }
        
        
        
        
   /*     public void getContractors()
        {
            List <contact> contractorforTask1=[Select id,name from contact where id in(select contact__c from Project_Member__c where
                recordtype.name='Task Team Member' and Contact__c in :UserContactIds and Tasks__c=:SelectedTask)];
                
                Contractor_List.clear();
                system.debug('On task change ' +contractorforTask1);
                
                for(contact ck: contractorforTask1) 
                {  
                       
                // feb23 Tasks_List.add(new SelectOption(string.valueof(tk.Id), tk.Name));  
                Contractor_List.add(new SelectOption(string.valueof(ck.Id), ck.Name ));
                } 
        }
        */ 
        
      
   
   public void getrowTotalHours(){
      
      if(tl.Saturday_Hours__c ==null){
      system.debug('Sobia K');
      tl.Saturday_Hours__c=0;
      
      }
      if(tl.Monday_Hours__c ==null){
      
      tl.Monday_Hours__c=0;
      
      }
      if(tl.Sunday_Hours__c ==null){
      
      tl.Sunday_Hours__c=0;
      
      }
      if(tl.Wednesday_Hours__c ==null){
      
      tl.Wednesday_Hours__c=0;
      
      }
      if(tl.Thursday_Hours__c ==null){
      
      tl.Thursday_Hours__c=0;
      
      }
      if(tl.Friday_Hours__c ==null){
      
      tl.Friday_Hours__c=0;
      
      }
      if(tl.Tuesday_Hours__c ==null){
      
      tl.Tuesday_Hours__c=0;
     
      }





          if(tl.Saturday_Hours__c <> null || tl.Monday_Hours__c <>null || tl.Tuesday_Hours__c <> null ||
                tl.Wednesday_Hours__c<> null || tl.Thursday_Hours__c<> null || tl.Friday_Hours__c<> null
                || tl.Sunday_Hours__c<> null){
           
          system.debug('GetrowTotalHours');
          
         tl.RowTotalForVF__c=tl.Saturday_Hours__c+tl.Monday_Hours__c+tl.Tuesday_Hours__c+
                         tl.Wednesday_Hours__c+tl.Thursday_Hours__c+tl.Friday_Hours__c+tl.Sunday_Hours__c;
            } 
       // return null;
        }
        
         
   }
   
   
 
 

//******************************************* Dummy Code ****************************
    
            private String firstName;
            private String lastName;
            private String company;
            private String email;
            private String qp;

            
                
            

            public String getFirstName() {
                  return this.firstName;
            }

            public void setFirstName(String firstName) {
                  this.firstName = firstName;
            }

            public String getLastName() {
                  return this.lastName;
            }

            public void setLastName(String lastName) {
                  this.lastName = lastName;
            }

            public String getCompany() {
                  return this.company;
            }

            public void setCompany(String company) {
                  this.company = company;
            }

            public String getEmail() {
                  return this.email;
            }

            public void setEmail(String email) {
                  this.email = email;
            }


            
            
          
   public void DummyMethod(){
          String weekday13 = System.now().format('EEEE'); 
       //Date dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
       Date weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
       String weekday14 = System.now().format('EEEE'); 
       Date dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
      weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);String weekday1 = System.now().format('EEEE'); 
       dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
      weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday1 = System.now().format('EEEE'); 
       dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
      weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
        system.debug('Apex: Week of the day : '+ dateSelected);
         weekday1 = System.now().format('EEEE'); 
       dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
      weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
system.debug('Apex: Week of the day : '+ dateSelected); weekday1 = System.now().format('EEEE'); 
       dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
      weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);

system.debug('Apex: Week of the day : '+ dateSelected); weekday1 = System.now().format('EEEE'); 
       dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
      weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);

system.debug('Apex: Week of the day : '+ dateSelected);
 weekday1 = System.now().format('EEEE'); 
       dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
      weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);

system.debug('Apex: Week of the day : '+ dateSelected);
 weekday1 = System.now().format('EEEE'); 
       dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
      weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
       
       system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
        system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
        system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
        system.debug('Apex: Week of the day : '+ dateSelected);
        weekday14 = System.now().format('EEEE'); 
        dateSelected= weekTime.Week_Start_Date__c.addDays(-3).toStartOfWeek().addDays(8);
        dateSelected= weekTime.Week_Start_Date__c.toStartOfWeek().addDays(1);
        weekday =System.today().addDays(-3).toStartOfWeek().addDays(8);
          }     
  
  }