/*
    This class has methods to execute methods related to account trigger
    **********************************************************
    Author: Mounika Sattu
    Audit History
    **********************************************************
    08/18/2014        Mounika Sattu       Created
    **********************************************************  
*/

public with sharing class ProjectFundingSourcesHelper{
	   public void process() {
        if(Trigger.isBefore && Trigger.isInsert){
                 updateProjectFundingNumber(Trigger.New);
        		 updateProjectPortfolioManager();
            }
        else if(Trigger.isAfter){           
                  updateAmount();
        }       
    }    
    
    /* This method update the Amount on Funding_Streams__c objects as the sum total of all the Amount on the Contract Funding Source Object associated with each Project Funding Source */
    private void updateAmount(){
            Set<ID> fsIds = new Set<ID>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Project_Funding_Sources__c pfsObj: (List<Project_Funding_Sources__c>)Trigger.new){
            fsIds.add(pfsObj.Funding_Stream__c);
        }
    }
    if(Trigger.isDelete || Trigger.isUpdate){
        for(Project_Funding_Sources__c pfsObj: (List<Project_Funding_Sources__c>)Trigger.old){
            fsIds.add(pfsObj.Funding_Stream__c);
        }
    }
    Map<ID, Funding_Streams__c> fsMap = new Map<ID,Funding_Streams__c>([SELECT Id,Funds_Obligated__c FROM Funding_Streams__c WHERE Id IN :fsIds]);
    for(AggregateResult fsAmount : [SELECT Funding_Stream__c,SUM(Contract_Funding_Source_Total_Amount__c)TotalAmount FROM Project_Funding_Sources__c WHERE 
                                    Funding_Stream__c IN :fsMap.keySet() GROUP BY Funding_Stream__c]){
        Funding_Streams__c fsObj = fsMap.get(String.valueOf(fsAmount.get('Funding_Stream__c')));
        if(fsAmount.get('TotalAmount') != null){
            fsObj.Funds_Obligated__c = Decimal.valueOf(String.valueOf(fsAmount.get('TotalAmount')));    
        }
    } 
    try{
        update fsMap.values();  
    }
    catch(System.DMLException e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
    }
    }
    
   private void updateProjectFundingNumber(List<Project_Funding_Sources__c> projectFundingSourcesList){
      Map<Id,Funding_Streams__c> fundingStreamMap = new Map <Id,Funding_Streams__c>([Select Id, Name from Funding_Streams__c LIMIT 10000]);
      Map<Id,Project__c> projectMap = new Map <Id,Project__c>([Select Id, Name from Project__c LIMIT 10000]);
      if(projectFundingSourcesList!=null){
      for(Project_Funding_Sources__c pfsObjInstance: projectFundingSourcesList){      	
	  	  if((projectMap.size() > 0) && (fundingStreamMap!=null) &&  fundingStreamMap.get(pfsObjInstance.Funding_Stream__c).Name !=null && projectMap.get(pfsObjInstance.Project__c).Name!=null)
	  	  {      	   
	        pfsObjInstance.name = fundingStreamMap.get(pfsObjInstance.Funding_Stream__c).Name + '-' + projectMap.get(pfsObjInstance.Project__c).Name;
	  	  }	  	  
        }
    } 
   }
    
/*
  This trigger will update the Project Portfolio Manager on Project_Funding_Sources__c Object with the Portfolio Manager detail on Project__c Object 
*/
 private void updateProjectPortfolioManager(){
  Set<ID> projIds = new Set<ID>();
  for(Project_Funding_Sources__c pfsObj: (List<Project_Funding_Sources__c>)Trigger.new){
    projIds.add(pfsObj.Project__c);
  }
  Map<ID, Project__c> projMap = new Map<ID, Project__c>([SELECT Portfolio_Manager__c FROM Project__c WHERE Id IN :projIds]);
  if(projMap.size() >0)
  {
	  for(Project_Funding_Sources__c pfsObj: (List<Project_Funding_Sources__c>)Trigger.new)
	  {
	    Project__c projId = projMap.get(pfsObj.Project__c);
	    if(projId.Portfolio_Manager__c != null)
	    {
	      pfsObj.Project_Portfolio_Manager__c = projId.Portfolio_Manager__c;  
	    }
	  }
  }  
  }  
 }