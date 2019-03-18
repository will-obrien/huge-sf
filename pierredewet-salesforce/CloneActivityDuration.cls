public with sharing class ActivityDurationClone {

  //Current activity duration id
  Activity_duration__c currentADRec;
  
  public activityDurationDeepClone(ApexPages.StandardController controller) 
  {
    currentADRec = (Activity_duration__c)controller.getRecord();
  }
  
  public pageReference cloneRecord()
  {
    //New Record object
    Activity_duration__c newADRec;
        
    //Set savepoint to roll back to incase of error
    Savepoint savePoint = Database.setSavepoint();

    try
    {
      //Need to select all fields to be used and updated as this isn't SQL.
      currentADRec = [SELECT Year__c, Volunteering_Activity__c, Start_date__c, Quarter__c, OwnerId, Number_of_sessions__c, Name, Id, End_date__c From Activity_duration__c 
            WHERE id =:currentADRec.id];
      newADRec = currentADRec.clone(false);

      Integer newRecYear = Integer.valueOf(currentADRec.Year__c);

      //Update the fields in the new record
      if(currentADRec.Quarter__c == 'Oct-Dec')
      {
        newADRec.Year__c = String.valueOf(newRecYear + 1);
      }
      else
      {
        newADRec.Year__c = String.valueOf(newRecYear);
      }
      
      
      if(currentADRec.Quarter__c == 'Jan-Mar')
      {
        newADRec.Quarter__c = 'Apr-Jun';
      }
      else if (currentADRec.Quarter__c == 'Apr-Jun')
      {
        newADRec.Quarter__c = 'Jul-Sep';
      }
      else if (currentADRec.Quarter__c == 'Jul-Sep')
      {
        newADRec.Quarter__c = 'Oct-Dec';
      }
      else 
      {
        newADRec.Quarter__c = 'Jan-Mar';
      }
      
      newADRec.Number_of_sessions__c = currentADRec.Number_of_sessions__c;
      
      newADRec.Name = newADRec.Year__c + ':' + newADRec.Quarter__c;
      
      //Insert cloned activity period
      insert newADRec;
            
      //Copy the related list - Activity Organisation
      List<Activity_organisation__c> actOrgList = new List<Activity_organisation__c>();
      for( Activity_organisation__c  actOrg : [SELECT a.Volunteering_Activity__c, a.Total_hours__c, a.Total_Volunteers_beneficiaries__c, a.Team_leader_hours__c, a.Site__c, a.Period__c, a.Organisation_type__c, a.Opportunity__c, a.Number_of_team_leaders__c, a.Name, a.In_kind_value__c, a.In_kind_description__c, a.Activity_duration__c, a.Account__c From Activity_organisation__c a WHERE a.Activity_duration__c =:currentADRec.id])
      {
        Activity_organisation__c newActOrg = actOrg.clone(false);
        newActOrg.Activity_duration__c = newADRec.Id;

        actOrgList.add(newActOrg);
      }

      //Insert related Activity Organisations
      insert actOrgList;
    }
    catch(Exception e)
    {
        Database.rollback(savePoint);
        ApexPages.addMessages(e);
        return null;
    }
    return new PageReference('/'+newADRec.id);   
  }

  //Convert year string to date value  
  public Date convertToDate(String y, Integer m, Integer d)
  {
    Integer year = Integer.valueOf(y);
    return date.newInstance(year,m,d);
  }

  public PageReference cancel() {
    PageReference sitePage = new ApexPages.StandardController(currentADRec).view();
    sitePage.setRedirect(true);
    return sitePage; 
  }      
}