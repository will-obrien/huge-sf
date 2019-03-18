public with sharing class NewFQController {
    public ForecastingQuota fq {get;set;}
    public NewFQController(ApexPages.StandardController controller) {
        fq = new ForecastingQuota();
        String theId = ApexPages.currentPage().getParameters().get('id');
        if(theId != null){
            fq = [Select Id,StartDate,QuotaAmount,QuotaOwnerId from ForecastingQuota where Id = :theId];
        }
    }
    
    public PageReference savefq(){
        try{
            upsert fq;
        } catch (Exception e){
            System.debug('insert quota?' + e.getMessage());
        }
        return new PageReference('/apex/ViewQuota?id=' + fq.id);
    }
    
    public PageReference deletefq(){
        try{
            delete fq;
        } catch (Exception e){
            System.debug('delete quota?' + e.getMessage());
        }
        return new PageReference('/apex/ListForecastQuota');
    }

}