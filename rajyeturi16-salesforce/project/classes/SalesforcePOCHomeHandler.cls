public class SalesforcePOCHomeHandler {

    public PageReference BackToHome() {
        return page.SalesforcePOCHome;
    }


    public PageReference SearchAll() {
        return page.SearchAll;
    }


    public PageReference Search() {
        return page.Search;
    }


    public PageReference Newpost() {
        return page.newpost;
    }


list<Salesforce_Documents__c > Poclist;
    public string searchValue
    {
        get
        {
            if(searchValue == null)
                searchValue = '';
            return searchValue;
        }
        set;
    }
    public List<Salesforce_Documents__c > searchResults
    {
        get
        {
            if(searchResults == null)
                searchResults = new List<Salesforce_Documents__c >();
            return searchResults;
        }
        set;
    }

    public SalesforcePOCHomeHandler() {
        
    }

    public list<Salesforce_Documents__c > getpocs() {
        Poclist= [SELECT Id, Name,Developer__c,Live_VF_page_URL__c,Subject__c,Description__c,Components_Used__c,Hours_Spent__c,Yammer_URL__c FROM Salesforce_Documents__c];
        return Poclist;
    }
  /*  public PageReference searchPOC()
    {
        
         System.debug('searchValue@@@@before '+searchValue  );
        if(searchValue == '')
        {
        searchResults = Poclist;
        System.debug('searchValue@@@@@111 '+ searchValue+searchResults  );
        return null;
        }
            System.debug('searchValue@@@@@ '+ searchValue );
        // Output the search value for debugging
        System.Debug('Initializing search, keyword is : ' + searchValue);       
        String finalSearchValue = '%' + searchValue + '%';
        List<Salesforce_Documents__c > salesforcedocs= new List<Salesforce_Documents__c >();
        // Careful- check out what the SOQL query is doing.
        // It gets a list of contacts under that account with matching names.
        salesforcedocs= [SELECT Id, Name,Developer__c,Live_VF_page_URL__c,Subject__c,Description__c,Components_Used__c,Hours_Spent__c,Yammer_URL__c FROM Salesforce_Documents__c where Description__c like :finalSearchValue];
        searchResults = salesforcedocs;
        system.debug('rashmi'+searchResults);
        return null;
        
        
    }
    */
    
}