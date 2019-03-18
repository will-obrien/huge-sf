public class WidgetTemplate {
        public String templateID {get;set;}
    	//Map<DOMID, MAP<CSS_ATTR, CSS_VAL>>
        public Map<String,Map<String,String>> widget_outer {get;set;}
        public Map<String,Map<String,String>> widget_inner {get;set;}
        public Map<String,Map<String,String>> widget_header {get;set;}
        public Map<String,Map<String,String>> widget_body {get;set;}
        public Map<String,Map<String,String>> widget_footer {get;set;}
        public Map<String,Map<String,String>> widget_body_link {get;set;}
        public Map<String,Map<String,String>> widget_body_link_hover {get;set;}
        public Map<String,String> status {get;set;}
        public Widget_Template__c t {get;set;}
        public Map<String, Widget_CSS_Definition__c> wcss {get;set;}

        public WidgetTemplate() {
            widget_outer        = new Map<String,Map<String,String>>();
            widget_inner        = new Map<String,Map<String,String>>();
            widget_header       = new Map<String,Map<String,String>>();
            widget_body         = new Map<String,Map<String,String>>();
            widget_footer       = new Map<String,Map<String,String>>();
            widget_body_link    = new Map<String,Map<String,String>>();
            widget_body_link_hover  = new Map<String,Map<String,String>>();
            status              = new Map<String,String >();
        }
        
        public Map<String,String> createAwesomeMap(String fieldName){
            Map<String,String> resultMap = new Map<String,String>();
            if(wcss.containsKey(fieldName.toLowerCase())){
                resultMap.put('css', wcss.get(fieldName.toLowerCase()).css__c);
                resultMap.put('label', wcss.get(fieldName.toLowerCase()).display_label__c);
                resultMap.put('color', '' + wcss.get(fieldName.toLowerCase()).color__c);
                resultMap.put('value', String.ValueOf(t.get(fieldName)));
            } else {
                resultMap.put('Error', fieldName);
            }
            return resultMap;
        }
        
        public void saveTemplate(){
            upsert t;
        }

        public String cloneTemplate(){
            try{
                Widget_Template__c wt = t.clone(false, true, false, false); 
                upsert wt;
                return String.valueOf(wt.Id);
            } catch(Exception e){
                System.debug('fail cloning');
                return 'Error';
            }
            
            
        }

        public void setWidgetTemplate(Widget_Template__c p_t, Map<String,Widget_CSS_Definition__c> p_wcss) {
            t = p_t;
            wcss = p_wcss;
            templateID = t.ID;
            try {
                Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Widget_Template__c.fields.getMap();
                for(String s : fieldMap.keySet()) {
                    Schema.DescribeFieldResult r = fieldMap.get(s).getDescribe();
                    if(r.getName().startsWithIgnoreCase('WO')) {
                        widget_outer.put(r.getName(), createAwesomeMap(r.getName()));
                    } 
                    if(r.getName().startsWithIgnoreCase('WI')) {
                        widget_body.put(r.getName(), createAwesomeMap(r.getName()));
                    } 
                    if(r.getName().startsWithIgnoreCase('WH')) {
                        widget_header.put(r.getName(), createAwesomeMap(r.getName()));
                    } 
                    
          /*WB now represents widget_body_link*/
                    if(r.getName().startsWithIgnoreCase('WBL') && !r.getName().contains('Hover')) {
                        widget_body_link.put(r.getName(), createAwesomeMap(r.getName()));
                    }
                    if(r.getName().startsWithIgnoreCase('WBL') && r.getName().contains('Hover')) {
                        widget_body_link_hover.put(r.getName(), createAwesomeMap(r.getName()));
                    }
                    
                    
                    if(r.getName().startsWithIgnoreCase('WF')) {
                        widget_footer.put(r.getName(), createAwesomeMap(r.getName()));
                    }
                    
                }
                status.put('Result','OK');
            } catch( Exception e ) {
                status.put('Exception', e.getMessage());
            }
        }
    }