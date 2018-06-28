@isTest
public class TermSearchTestMethod{

    public static testMethod void testTermSearch(){

        TermSearchController termSearch = new TermSearchController();    

        String sortDir = 'asc';
        String search_keywords = system.currentPageReference().getParameters().put('Search_Keywords_value','Test');
        String Content_Type = system.currentPageReference().getParameters().put('Content_Type','Test');
        String Technology = system.currentPageReference().getParameters().put('Technology','Test');
        String Multiple_Content_Type = system.currentPageReference().getParameters().put('Multiple_Content_Type_value','Test');
        String Asset_Name = system.currentPageReference().getParameters().put('Asset_Name','Test');
        String Multiple_Technology_Type = system.currentPageReference().getParameters().put('Multiple_Technology_Type_value','Test');
        String Multiple_Project_Phase = system.currentPageReference().getParameters().put('Multiple_Project_Phase_value','Test');        
        String soql = 'select Name, Other_Details__c, Content_Type__c, Technology__c, Module__c, Project_Phase__c,Keywords_new__c from Term__c where Name != null';
        String debugSoql = soql;

        List<String> picklistvalues = new List<String> { 'one', 'two', 'three' };
        
        if(termSearch.Content_Type_Picklist == null)
            termSearch.Content_Type_Picklist = picklistvalues;
            List<String> getContent_Type_Picklist=termSearch.Content_Type_Picklist;
        
        if(termSearch.Search_Keywords_Picklist  == null)
            termSearch.Search_Keywords_Picklist  = picklistvalues;
            List<String> getSearch_Keywords=termSearch.Search_Keywords_Picklist;
        
        if(termSearch.Technology_Type_Picklist == null)
            termSearch.Technology_Type_Picklist = picklistvalues;
            List<String> getTechnology_Type_Picklist=termSearch.Technology_Type_Picklist;
            
        if(termSearch.Project_Phase_Picklist == null)
            termSearch.Project_Phase_Picklist = picklistvalues;
            List<String> getProject_Phase_Picklist=termSearch.Project_Phase_Picklist;
                   
        termSearch.debugSoql = 'DebugLog';
        String getDebugSoql = termSearch.debugSoql;
        
        List<Term__c> listTerm = new List<Term__c>();
        listTerm = Database.query(soql);
        
        termSearch.toggleSort();
        PageReference testPageResults = termSearch.runSearch();

    }
    
}