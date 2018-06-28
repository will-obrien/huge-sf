public with sharing class CaseHistoryController {

  public List<CaseHistoryItem> CHIlist  {get; set;}
  public Case aCase                     {get; set;}
  public String caseID                  {get; set;}
  public List<Task> tasks               {get; set;}
  public boolean showAll                {get; set;}
  public Set<String> prefixSet          {get; set;}
  
  public CaseHistoryController(){
    CHIlist= new List<CaseHistoryItem>();
    caseId = Apexpages.currentPage().getParameters().get('id'); 
    aCase = [select CaseNumber, Account.Name, AccountId, Subject, Contact.Name, ContactId,
    (Select Id, CreatedById, CreatedBy.Name, WhatId, What.Name, Subject, ActivityDate, Status, OwnerId, Description, CreatedDate, Owner.Name From Tasks),
    (Select Id, CreatedDate, CreatedBy.Name, CreatedById, CommentBody From CaseComments),
    (Select Id, CreatedById, CreatedBy.Name, CreatedDate, Field, OldValue, NewValue From Histories),
    (Select Id, CreatedById, CreatedBy.Name, CreatedDate, TextBody, Subject, FromName, ToAddress, MessageDate From EmailMessages) 
    from Case where id = :caseID];
    setupTasks(aCase);
    setupCaseComments(aCase);
    setupHistories(aCase);
    setupEmails(aCase);
    sortByCreateDate();
  }
  


  public PageReference sortByOwner(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('OWNER',0, CHIlist.size()-1);
    return null;
  }
  
  public PageReference sortByCreateDate(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('CREATEDATE',0, CHIlist.size()-1);
    return null;
  }

  public PageReference sortByDueDate(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('DUEDATE',0, CHIlist.size()-1);
    return null;
  }
  
  public PageReference sortByCreateBy(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('CREATEBY',0, CHIlist.size()-1);
    return null;
  }
  
  public PageReference sortByType(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('TYPE',0, CHIlist.size()-1);
    return null;
  }

  public PageReference sortBySubject(){
    showAll = true;
    if(CHIlist.size()>1)
     quickSort('SUBJECT',0, CHIlist.size()-1);
    return null;
  }
    
  public void setupHistories(Case c){
    List<CaseHistory> cHistories = c.Histories;
    String subject;
    String oldVal;
    String newVal;
  
    setupPrefix();
  
    for (CaseHistory ch:cHistories){
      oldVal=String.valueOf(ch.oldValue);
      newVal=String.valueOf(ch.newValue);
      
      if(isId(oldVal)||isId(newVal))
        subject=null;
      else if(ch.OldValue==null&&ch.NewValue==null)
        subject = ch.Field+'--Modified, or Created';
      else if(ch.OldValue==null)
         subject = ch.Field+' changed or set to '+newVal;
      else if(ch.newValue==null)
         subject = ch.Field+' changed or set to '+oldVal;
      else{
        subject = ch.Field+' changed from '+oldVal+' to '+newVal;
      }
      
      
      if(subject!=null)
        CHIlist.add(new CaseHistoryItem(ch.CreatedDate, subject, ch.CreatedBy.Name, ch.CreatedById, null, 'History', null, null, null, null));
      }
    }
  
   public void setupEmails(Case c){
    List<EmailMessage> emailMessages=c.EmailMessages;
    String subject='';
    for(EmailMessage em:emailMessages){
     subject='On '+em.MessageDate.format('MM/d/yyyy')+' '+em.FromName+' wrote to '+em.ToAddress+'--'+em.Subject+'--'+em.TextBody;
     CHIlist.add(new CaseHistoryItem(em.CreatedDate, subject, em.CreatedBy.Name, em.CreatedById,  null, 'Email', null, null, null, null));
    }
  }
   
  private void setupPrefix(){
    prefixSet=new Set<String>();
    Map<String, Schema.SObjectType> gD = Schema.getGlobalDescribe();
    Set<String>keys=gD.keySet();
    for(String key:keys){
      Schema.DescribeSObjectResult r = gD.get(key).getDescribe();
      if(r!=null &&r.getKeyPrefix()!=null && r.getKeyPrefix()!='')
       prefixSet.add(r.getKeyPrefix());
    }     
  }
  
  public boolean isId(String at){
    if(at==null)
     return false;   
    else if(at.length()<5)
     return false;
    else{ 
      String testVal = at.substring(0,3);     
      for(String prefix : prefixSet){
        if(prefix.equals(testVal))
         return true;
      }
    }
    return false;
  }

  public void setupCaseComments(Case c){
    List <CaseComment> cComments = c.CaseComments;
    for(CaseComment cc: cComments){
      CHIlist.add(new CaseHistoryItem(cc.CreatedDate, cc.CommentBody, cc.CreatedBy.Name, cc.CreatedById, null,'Comment', null, null, null, null));
    }
  }
  
  public void setupTasks(Case c){
    tasks = c.Tasks;
    for (task t: tasks){
    	if(notEmail(t.Subject))
        CHIlist.add(new CaseHistoryItem(t.CreatedDate, t.Subject, t.CreatedBy.Name, t.CreatedById, t.Id, 'Activity', t.ActivityDate, t.Owner.Name, '--  '+t.Description, t.OwnerId));
    }   
  }
  private Boolean notEmail(String testVal){
  	if(testVal.length()<5)
  	 return true;
  	
  	String subTestVal = testVal.substring(0, 5);
  	if(subTestVal.equalsIgnoreCase('Email'))
  	 return false;
  	
  	return true;
  }
  
  public void quickSort(String key, integer left, integer right) {
    integer index = partition(key, left, right);
    if (left < index - 1)
     quickSort(key, left, index - 1);
    if (index < right)
     quickSort(key, index, right);
  }
  
  public integer partition(String key, integer left, integer right){
      integer i = left, j = right;
      CaseHistoryItem tmp;
      CaseHistoryItem pivot = CHIlist[(left + right) / 2];
      while (i <= j) {
            while (compare(key, CHIlist[i], pivot))
                  i++;
            while (compare(key,pivot, CHIlist[j]))
                  j--;
            if (i <= j) {
                  tmp = CHIlist[i];
                  CHIlist[i] = CHIlist[j];
                  CHIlist[j] = tmp;
                  i++;
                  j--;
            }
      }
      return i;
  }
  
  //sorts by key then 'CREATEDATE' if keys are equal
  public boolean compare(String key, CaseHistoryItem left, CaseHistoryItem right){
    if (key=='CREATEDATE')
     return left.createdDate<right.createdDate;
    
    else if(key=='DUEDATE'){
       if(left.dueDate==null && right.dueDate==null)
        return compare('CREATEDATE', left, right);
       else if(left.dueDate==null)
         return false;
       else if(right.dueDate==null)
         return true;
       else{
         if(left.dueDate==right.dueDate)
           return compare('CREATEDATE', left, right);
         else
           return left.dueDate<right.dueDate;
       }
     }
    
    else if(key=='OWNER'){
       if(left.ownerName==null && right.ownerName==null)
        return compare('CREATEDATE', left, right);
       else if(left.ownerName==null)
         return false;
       else if(right.ownerName==null)
         return true;
       else{
         if(left.ownerName==right.ownerName)
           return compare('CREATEDATE', left, right);
         else
           return left.ownerName<right.ownerName;
       }
     }
     
    else if(key=='CREATEBY'){
     if(left.createdName==right.createdName)
       return compare('CREATEDATE', left, right);
     else
       return left.createdName<right.createdName;
    }
    
    else if(key=='TYPE'){
     if(left.itemTypeName==right.itemTypeName)
       return compare('CREATEDATE', left, right);
     else
       return left.itemTypeName<right.itemTypeName;
      }
    
    else if(key=='SUBJECT'){
     if(left.subject==right.subject)
       return compare('CREATEDATE', left, right);
     else
       return left.subject<right.subject;
     }
    
    else
     return left.createdDate<right.createdDate;  
  }
  
  public Class CaseHistoryItem{
    public Datetime createdDate   {get; set;}
    public Date dueDate           {get; set;}
    public String subject         {get; set;}
    public String createdName     {get; set;} 
    public String createdId       {get; set;}
    public String mainId          {get; set;}
    public String itemType        {get; set;}
    public boolean isActivity     {get; set;}
    public String createDateFix   {get; set;}
    public String dueDateFix      {get; set;}
    public String subjectSort     {get; set;}
    public String ownerName       {get; set;}
    public String taskDescription {get; set;}
    public String ownerId         {get; set;}
    public String itemTypeName    {get; set;}
    
    CaseHistoryItem(Datetime aCreateDate, String aSubject, String aCreatedName, String aCreatedId,  String aMainId, String aType, Date aDueDate, String aOwnerName, String aTaskDesc, String aOwnerId){
      createdDate=aCreateDate;
      createDateFix=createdDate.format('MM/d/yyyy -- h:mm a');
      subject=aSubject;
      createdName=aCreatedName;
      createdId=aCreatedId;
      mainId=aMainId;
      itemType=getTypeImageMap(aType);
      itemTypeName=aType;
      dueDate=aDueDate;
      if(dueDate!=null){
        isActivity=true;
        dueDateFix=dueDate.format(); 
      }
      else 
        isActivity=false;
      ownerName=aOwnerName;
      taskDescription=aTaskDesc;
      ownerId=aOwnerId;
    }
    
    private String getTypeImageMap(String aType){
      if (aType=='History')
        return '/resource/1262726668000/history';
      else if(aType=='Comment')
        return '/resource/1262720324000/comment';
      else if(aType=='Email')
        return '/resource/1262899368000/mail';
      else
        return '/resource/1262726732000/activity';
    }
  }

  static testMethod void testCaseHistoryController() {
   ApexPages.currentPage().getParameters().put('id', '500A0000000u03A' );
   CaseHistoryController CHC = new CaseHistoryController();
   CHC.sortByCreateBy();
   CHC.sortByDueDate();
   CHC.sortBySubject();
   CHC.sortByType();
   
   System.debug('TESTS ENDED');
  }
}