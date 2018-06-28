public with sharing class RedirectOnCancel {

    public RedirectOnCancel(ApexPages.StandardController accountController){}

    public PageReference cancel() {
        Schema.DescribeSObjectResult accountSchema = Account.SObjectType.getDescribe();
        String objectIdPrefix = accountSchema.getKeyPrefix();
        Id listViewId;
        List<ListView> lstList = [Select l.id
                                  From ListView l 
                                  where l.Name = 'All Accounts'];
        for(ListView iterator : lstList) {
            listViewId = iterator.Id;
        }
        PageReference redirectUrl = new PageReference('/'+objectIdPrefix+'?fcf='+ listViewId);
        redirectUrl.setRedirect(true);
        return redirectUrl;
    }
}