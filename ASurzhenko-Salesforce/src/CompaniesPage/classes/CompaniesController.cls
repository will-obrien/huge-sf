public with sharing class CompaniesController 
{
    public List<Work_Period__c> workPeriodList {get;set;}
    public Set<String> companies {set; get;}
        
    public CompaniesController()
    {
        workPeriodList = new List<Work_Period__c>([SELECT Name, Order__r.Account__r.Name, 
                                                  Rate__r.Revenue__c, Rate__r.Margin__c 
                                                  FROM Work_Period__c]);
               
        companies = new Set<String>();
        for (Work_Period__c item: workPeriodList)
        {
            companies.add(item.Order__r.Account__r.Name);
        }
    }
}