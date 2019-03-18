@isTest(SeeAllData=true)
public class testForeCastingQuotaController{
    static testMethod void RunForeCastingQuotaListTest(){
        ForecastingQuotaController fqcontroller = new ForecastingQuotaController();
        PageReference pr = fqcontroller.createnew();
        PageReference expectedPage = Page.ForecastingQuota;
        //System.assertEquals(pr,expectedPage);                
    }
    
    static testMethod void RunViewQuotaTest(){
        String uid = '00530000006OMyk';
        User u = [Select Id from User where Id = :uid];        
        
        System.runAs(u){
            ForecastingQuota fq = new ForecastingQuota();
            fq.QuotaAmount = 10000;
            fq.QuotaOwnerId = u.id;
            fq.StartDate = Date.today()+365;
            insert fq;
            PageReference viewQuotaPage = Page.ViewQuota;
            Test.setCurrentPageReference(viewQuotaPage);
            ApexPages.currentPage().getParameters().put('id',fq.id);
            ApexPages.StandardController cont = new ApexPages.StandardController(fq);
            NewFQController nfqc = new NewFQController(cont);
            nfqc.savefq();
            nfqc.deletefq();
            fq.StartDate = Date.Today();
            nfqc.savefq();
        }
    }
}