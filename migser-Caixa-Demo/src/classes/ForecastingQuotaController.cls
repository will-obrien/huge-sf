public class ForecastingQuotaController {

    public boolean checked  { get; set; }
    public List<ForecastingQuota> ForecastQuota {get;set;}

    public ForecastingQuotaController(){
         ForecastQuota = [Select Id, StartDate, QuotaAmount, QuotaOwnerId,QuotaOwner.Name from ForecastingQuota order by QuotaOwnerId];
    }
            
    public PageReference createnew() {
         return Page.ForecastingQuota;
    }
 
}