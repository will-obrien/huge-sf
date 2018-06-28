public class AdvanceActivityHistoryController 
{
  List<Task> tk;
  // the variable being set from the commandlink
  public String taskId {get; set;} 
  public Boolean isTask {get; set;}
  private String secondSort = ', LastModifiedDate desc';
  private String whereParam = ''; 

  //store variables for filter hiding/showing and dynamic link name
  public String showFilter {get; set;}
  public String filterLink {get; set;}  
  //default value for filter
  private String sF = 'display: None;';
  private String fL = 'Show Filter';
  
  //store input value for prepopulate input after submit filter
  public String activityType {get; set;}
  public String relatedTo {get; set;}
  public String createdBy {get; set;}
  public String assignedTo {get; set;}
  public String lastModifiedDate {get; set;}
  public String lastModifiedDateTo {get; set;}
  
  private String tempActivityType = 'All';
  private String tempRelatedTo = '';
  private String tempCreatedBy = '';
  private String tempAssignedTo = '';
  private String tempLastModifiedDate = '';
  private String tempLastModifiedDateTo = '';
 
  // the current sort direction. defaults to desc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to Last Modified Date
  public String sortField {
    get  { if (sortField == null) {sortField = 'LastModifiedDate'; } 
    	   if (sortField == 'LastModifiedDate') {secondSort = '';} return sortField;  }
    set;
  }
 
 
  public AdvanceActivityHistoryController(ApexPages.StandardController Controller)
   {
     }
  
  public List<ActivityHistory> getResults() {
  	String orderClause = ' order by '+ sortField + ' ' + sortDir + secondSort;
  	String whereClause = '';
  	if(whereParam != '') whereClause = ' where ' + whereParam;
  	
  	String queryAH = 'select (select ActivityType, IsTask, Status, What.Name, Description, Subject, LastModifiedDate,WhatId, OwnerId,WhoId, Owner.Name, Who.Name, Priority,ActivityDate,CreatedById, CreatedBy.Name, DB_Activity_Type__c from ActivityHistories'+ whereClause + orderClause +') from Account where Id = \'' + System.currentPageReference().getParameters().get('id') + '\'';
  	
  	system.debug('here 1: ' + queryAH);
  	
  	List<Account> a = Database.query(queryAH);
  	List<ActivityHistory> ahResult = new List<ActivityHistory>();
  	for (ActivityHistory ah : a[0].getSObjects('ActivityHistories')) {//get a[0] because there is only one account return
  		ahResult.add(ah);
  	}
  	
  	showFilter = sF;
  	filterLink = fL;
  	
  	activityType = tempActivityType;
  	relatedTo = tempRelatedTo;
  	createdBy = tempCreatedBy;
  	assignedTo = tempAssignedTo;
  	lastModifiedDate = tempLastModifiedDate;
  	lastModifiedDateTo = tempLastModifiedDateTo;
  	
  	return ahResult; 
  }
 
 public PageReference gettk()
 { /*
   String userId=UserInfo.getUserId();
   UserId=userId.Substring(0,15);
   System.debug('UserId=='+UserId);
   */
   return Null; 
 }
 public void deleteActivity(){
 	try{		
 			if(isTask){
 				Task ta = [select Description, What.Name, Subject ,WhatId, OwnerId,WhoId, Owner.Name, Who.Name from Task where Id = :taskId limit 1];
 				delete ta;
 			}else{
 				Event ev = [select Description, What.Name, Subject ,WhatId, OwnerId,WhoId, Owner.Name, Who.Name from Event where Id = :taskId limit 1];
 				delete ev;
 			}

 	} catch (DmlException e){		
 	}
 }
  
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    //getResults();
    sF = 'display: none;';
	fL = 'Show Filter';
  }
  
  // runs the search with parameters passed via Javascript
  public void runSearch() {
  	
    tempActivityType = Apexpages.currentPage().getParameters().get('searchActivityType');
    tempRelatedTo = Apexpages.currentPage().getParameters().get('searchRelatedTo');
    tempCreatedBy = Apexpages.currentPage().getParameters().get('searchCreatedBy');
    tempAssignedTo = Apexpages.currentPage().getParameters().get('searchAssignedTo');
    tempLastModifiedDate = Apexpages.currentPage().getParameters().get('searchLastModifiedDate');
    tempLastModifiedDateTo = Apexpages.currentPage().getParameters().get('searchLastModifiedDateTo');
 
    whereParam = '';
    if (!tempActivityType.equals('') && !tempActivityType.equals('All'))
      whereParam += 'DB_Activity_Type__c = \''+String.escapeSingleQuotes(tempActivityType)+'\''; 
    if (!tempRelatedTo.equals('')){
    	if(!whereParam.equals(''))
    		whereParam += ' and ';
      whereParam += 'What.Name = \''+String.escapeSingleQuotes(tempRelatedTo)+'\'';
    } 
    if (!tempCreatedBy.equals('')){
    	if(!whereParam.equals(''))
    		whereParam += ' and ';
      whereParam += 'CreatedBy.Name = \''+String.escapeSingleQuotes(tempCreatedBy)+'\''; 
    }
    if (!tempAssignedTo.equals('')){
    	if(!whereParam.equals(''))
    		whereParam += ' and ';
      whereParam += 'Owner.Name = \''+String.escapeSingleQuotes(tempAssignedTo)+'\''; 
    }
    if (!tempLastModifiedDate.equals('')){    	
    	try{
    		List<String> sl = tempLastModifiedDate.split('/',-2);
    		String fromDate = sl[2]+'-'+sl[1]+'-'+sl[0]+'T00:00:00Z';
    		if(!whereParam.equals(''))
    			whereParam += ' and ';
      		whereParam += 'LastModifiedDate >= '+ fromDate +'';
    	}catch(Exception e){} 
    }
    
    if (!tempLastModifiedDateTo.equals('')){   	
    	try{
    		List<String> sl = tempLastModifiedDateTo.split('/',-2);
    		String toDate = sl[2]+'-'+sl[1]+'-'+sl[0]+'T23:59:59Z';
    		if(!whereParam.equals(''))
    			whereParam += ' and ';
      		whereParam += 'LastModifiedDate <= '+ toDate +'';
    	}catch(Exception e){} 
    }
       
	sF = '';
	fL = 'Hide Filter';
  }

 
}