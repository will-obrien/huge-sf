global class Widget_CSS_Configurator {
    
    @RemoteAction
    public static WidgetTemplate getTemplate(String templateID) {
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Widget_Template__c.fields.getMap();
        Set<String> keySet = fieldMap.keySet();
        String soql = 'SELECT ';
        for(String x : keySet) {
            Schema.DescribeFieldResult r = fieldMap.get(x).getDescribe();
            soql += r.getName() + ', ';
        }
        soql = soql.substring(0, soql.length()-2);
        soql += ' FROM Widget_Template__c Where Id = \'' + templateID + '\' Limit 1';
    System.Debug(soql);
        Widget_Template__c template = (Widget_Template__c)Database.query(soql);
                
        /* Code added for retreiving CSS Definition*/
        Map<String, Schema.SObjectField> cssfieldMap = Schema.SObjectType.Widget_CSS_Definition__c.fields.getMap();
        Set<String> csskeySet = cssfieldMap.keySet();
        String csssoql = 'SELECT ';
        for(String x : csskeySet) {
            Schema.DescribeFieldResult r = cssfieldMap.get(x).getDescribe();
            csssoql += r.getName() + ', ';
        }
        csssoql = csssoql.substring(0, csssoql.length()-2);
        csssoql += ' FROM Widget_CSS_Definition__c';
        
        List<Widget_CSS_Definition__c> lwcss = (List<Widget_CSS_Definition__c>)Database.query(csssoql);
        Map<String, Widget_CSS_Definition__c> cssMap = new Map<String,Widget_CSS_Definition__c>();
        for(Widget_CSS_Definition__c wcss : lwcss){
            cssMap.put(wcss.name, wcss);
        }

        WidgetTemplate w = new WidgetTemplate();
        w.setWidgetTemplate(template, cssMap);
        return w;
    }
    

    @RemoteAction
    public static String saveTemplate(WidgetTemplate template) {
        if(template == null) { return 'You must pass in a valid template.'; }
        template.saveTemplate();
        return template.templateID;
    }

    @RemoteAction
    public static String cloneTemplate(WidgetTemplate template){
        if(template == null){ return 'You must pass a valide template';}
        String newId = template.cloneTemplate();
        return newId;
    }
    
    
}