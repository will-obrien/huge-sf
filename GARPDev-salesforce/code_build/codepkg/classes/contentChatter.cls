public class contentChatter {
    public transient Content__c cont { public get; private set; }

    public contentChatter() {
        
        Map<String,String> params = ApexPages.currentPage().getParameters();
        String contentId = params.get('contentId');

        List<Content__c> lstContent = [Select Id, Name from Content__c where Id = :contentId limit 1];
        cont = lstContent[0];
    }
}