public with sharing class TermSearchController {

  // the soql without the order and limit
  public String soql {get;set;}
  // the collection of contacts to display
  public List<Term__c> listTerm {get;set;}

  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }

  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'Content_Type__c'; } return sortField;  }
    set;
  }

  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql+ ' order by ' + sortField + ' ' + sortDir; }
    set;
  }

  // init the controller and display some sample data when the page loads
  public TermSearchController() {
    //soql = 'select Name, Other_Details__c, Content_Type__c, Technology__c, Module__c, Project_Phase__c,Keywords_new__c from Term__c';
    
    runQuery();
  }

  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }

  // runs the actual query
  public void runQuery() {

    try {      
          //listTerm = Database.query(soql+ ' order by ' + sortField + ' ' + sortDir + '');
          List<List<Term__c>> listTerm_1 = new List<List<Term__c>>();
          List<Term__c> listTerm_3 = new List<Term__c>();  
          
          if(Asset_Name==null || Asset_Name=='')
              Asset_Name='SFDC*';
          else
              Asset_Name=Asset_Name + '*';
          listTerm_1 = [FIND :Asset_Name IN ALL FIELDS RETURNING Term__c];

          for(List<Term__c> listTerm_2:listTerm_1 )
          {
              listTerm_3 = listTerm_2;          
          }
          soql = 'Select Name, Other_Details__c, Content_Type__c, Technology__c, Module__c, Project_Phase__c,Keywords_new__c from Term__c where id IN :listTerm_3';

          if(Multiple_Content_Type != '' && Multiple_Content_Type != null)
              soql += ' AND Content_Type__c in ('+Multiple_Content_Type+')';    
          if (Multiple_Technology_Type != '' && Multiple_Technology_Type != null)
              soql += ' AND Technology__c in ('+Multiple_Technology_Type+')';  
          if (Multiple_Project_Phase != '' && Multiple_Project_Phase != null)
              soql += ' AND Project_Phase__c INCLUDES ('+Multiple_Project_Phase+')';   

          listTerm = Database.query(soql+ ' order by ' + sortField + ' ' + sortDir + '');
          
    } catch (Exception e) {
          system.debug('#################'+e);
          //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'OPP!'+e));      
    }

  }

  // runs the search with parameters passed via Javascript
    String Asset_Name,Content_Type,Technology,Multiple_Content_Type,search_keywords,Multiple_Technology_Type,Multiple_Project_Phase;

  public PageReference runSearch() {
     Asset_Name = Apexpages.currentPage().getParameters().get('Asset_Name');
     Content_Type = Apexpages.currentPage().getParameters().get('Content_Type');
     Technology = Apexpages.currentPage().getParameters().get('Technology');
     search_keywords = Apexpages.currentPage().getParameters().get('Search_Keywords_value');
     Multiple_Content_Type = Apexpages.currentPage().getParameters().get('Multiple_Content_Type_value');
     Multiple_Technology_Type = Apexpages.currentPage().getParameters().get('Multiple_Technology_Type_value');
     Multiple_Project_Phase = Apexpages.currentPage().getParameters().get('Multiple_Project_Phase_value');
     
     // run the query again
     runQuery();

    return null;
  }

  // use apex describe to build the picklist values
public List<String> Content_Type_Picklist {
    get {
      if (Content_Type_Picklist == null) {

        Content_Type_Picklist = new List<String>();
        Schema.DescribeFieldResult field = Term__c.Content_Type__c.getDescribe();

        for (Schema.PicklistEntry f : field.getPicklistValues())
          Content_Type_Picklist.add(f.getLabel());

      }
      return Content_Type_Picklist;          
    }
    set;
  }
  
public List<String> Technology_Type_Picklist {
    get {
      if (Technology_Type_Picklist == null) {

        Technology_Type_Picklist = new List<String>();
        Schema.DescribeFieldResult field = Term__c.Technology__c.getDescribe();

        for (Schema.PicklistEntry f : field.getPicklistValues())
          Technology_Type_Picklist.add(f.getLabel());

      }
      return Technology_Type_Picklist;          
    }
    set;
  }
  
public List<String> Project_Phase_Picklist {
    get {
      if (Project_Phase_Picklist == null) {

        Project_Phase_Picklist = new List<String>();
        Schema.DescribeFieldResult field = Term__c.Project_Phase__c.getDescribe();

        for (Schema.PicklistEntry f : field.getPicklistValues())
          Project_Phase_Picklist.add(f.getLabel());

      }
      return Project_Phase_Picklist;          
    }
    set;
  }

public List<String> Search_Keywords_Picklist {
    get;set;
  }
}