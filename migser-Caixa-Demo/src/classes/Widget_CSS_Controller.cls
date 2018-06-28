public with sharing class Widget_CSS_Controller {

    public Network network {get;set;}   
    public User user {get;set;}
    public Widget_Template__c template {get;set;}
    public String soql {get;set;}
    public String errorMsg {get;set;}

    public Widget_CSS_Controller() {
        Initialize();
    }
    
    private void Initialize() {
        String sPrefixStr = Site.getPrefix();       
        List<Network> n = [Select n.UrlPathPrefix, n.Name, n.Id From Network n Where n.UrlPathPrefix =: sPrefixStr.subString(1) Limit 1];
        network = (n != null && n.size() > 0) ? n[0] : null;
        user = [Select Id, Name, ProfileId From User Where Id =: UserInfo.getUserID() Limit 1];
    	Template_Map__c tm = [Select Id, Widget_CSS__c From Template_Map__c Where Profile__c =: user.ProfileID and Community__c =: network.Id Limit 1];
        System.debug(user.id + '||' + network.id + '||' + tm.Id);
        template = (tm != null) ? LoadTemplateCSS(tm.Widget_CSS__c) : new Widget_Template__c();
    }
    
    private Widget_Template__c LoadTemplateCSS(ID TemplateID) {
        try {
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Widget_Template__c.fields.getMap();
            Set<String> keySet = fieldMap.keySet();
            soql = 'SELECT ';
            for(String x : keySet) {
                Schema.DescribeFieldResult r = fieldMap.get(x).getDescribe();
                soql += r.getName() + ', ';
            }
            soql = soql.substring(0, soql.length()-2);
            soql += ' FROM Widget_Template__c Where Id = \'' + TemplateID + '\' Limit 1';

            Widget_Template__c template = (Widget_Template__c)Database.query(soql);
            return template;
        } catch( Exception e ) {
            errorMsg = e.getMessage();
            return new Widget_Template__c();
        }
    }
}