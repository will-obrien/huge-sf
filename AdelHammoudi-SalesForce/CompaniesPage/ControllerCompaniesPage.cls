/**
 * ControllerCompaniesPage class is custom controller for CompaniesPage.
 *
 * @author  Adel Hammoudi
 * @version 1.0, June 2016
 */
public with sharing class ControllerCompaniesPage 
{
	public List<Account> accountList {get;set;}
	public List<Work_Period__c> workPeriodList {get;set;}
    
    public ControllerCompaniesPage()
    {
        workPeriodList = new List<Work_Period__c>([SELECT Name, Order__r.Account__r.Id,
        											Rate__r.Revenue__c, Rate__r.Margin__c 
        											FROM Work_Period__c]);
        accountList = new List<Account>([SELECT Name, Id FROM Account]);
    }
}