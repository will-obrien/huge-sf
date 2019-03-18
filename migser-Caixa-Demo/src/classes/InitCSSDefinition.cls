public class InitCSSDefinition{
    public List<Widget_CSS_Definition__c> lwcss {get;set;}
    public InitCSSDefinition(){
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Widget_Template__c.fields.getMap();
        Set<String> keySet = fieldMap.keySet();
        Widget_CSS_Definition__c wcss;
        lwcss = new List<Widget_CSS_Definition__c>();
        for(String s : keySet){
            wcss = new Widget_CSS_Definition__c();
            wcss.Name = s;
            if(s.indexOf('color') != -1){
                wcss.Color__c = true;   
            }
            if(s.indexOf('__c') != -1){
                lwcss.add(wcss);    
            }
        }
    }
    
    public void initializeCSSMap(){
        upsert lwcss;
    }
}