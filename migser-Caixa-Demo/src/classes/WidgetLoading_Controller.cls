public with sharing class WidgetLoading_Controller {
  	public Network network {get;set;}   
    public User user {get;set;}
    public Map<String,Custom_Widgets__c> map_lcws {get;set;}
	public Org_Template__c userTemplate {get;set;}
    
    public List<Custom_Widgets__c> lcws {get;set;}
    public Map<String, Custom_Widgets__c> mapWidgets {get;set;}

  public WidgetLoading_Controller() {
    	map_lcws = new Map<String, Custom_Widgets__c>();
        String sPrefixStr = Site.getPrefix();       
        List<Network> n = [Select n.UrlPathPrefix, n.Name, n.Id From Network n Where n.UrlPathPrefix =: sPrefixStr.subString(1) Limit 1];
        network = (n != null && n.size() > 0) ? n[0] : null;
        user = [Select Id, Name, ProfileId From User Where Id =: UserInfo.getUserID() Limit 1];
    	Template_Map__c tm = [Select Id, Widget_CSS__c From Template_Map__c Where Profile__c =: user.ProfileID and Community__c =: network.Id Limit 1];
        System.debug(user.id + '||' + network.id + '||' + tm.Id);
        for(Custom_Widgets__c cw : [Select Id, Name, isDisplayed__c from Custom_Widgets__c where Template_Map__c = :tm.Id]){
            map_lcws.put(cw.name, cw);
        }
        System.debug(map_lcws.values().size());
      SSEPortalCSSController ext = new SSEPortalCSSController();
      userTemplate = ext.userTemplate;
  }
}