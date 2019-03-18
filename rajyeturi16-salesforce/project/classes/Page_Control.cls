public with sharing class Page_Control {
    public list<SFDC_Team__c> st {set;get;}
    public ApexPages.StandardController controller;
       public Page_Control(ApexPages.StandardController controller) {
    SFDC_Team__c d = (SFDC_Team__c) controller.getRecord();
    d.PPT__c = UserInfo.getUserId();
    this.controller = controller;
    }
    public PageReference save()
    {
     
 PageReference pgref = new PageReference('/apex/form');
      controller.save();
      pgref.setRedirect(true);
      return pgref;
      
    }

}