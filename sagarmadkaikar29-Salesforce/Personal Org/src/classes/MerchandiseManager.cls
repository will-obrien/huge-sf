@RestResource(urlMapping = '/Merchandise/*')
global with sharing class MerchandiseManager 
{
    @HttpGet
    global static Merchandise__c getMerchandiseById()
    {
        RestRequest req = RestContext.request;
        String merchId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Merchandise__c result = [SELECT Name,Quantity__c,Price__c,Warehouse__c FROM Merchandise__c WHERE Id = :merchId ];
        return result;
    }
    
    @HttpPost
    global static String createMerchandise(String name,Decimal quantity, Decimal price, String warehouse)
    {
        Merchandise__c m = new Merchandise__c( Name = name, Quantity__c=quantity, Price__c = price, Warehouse__c=warehouse);
        insert m;
        return m.Id;

    }

}