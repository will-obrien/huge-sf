global class InsertArticleRecords{
    public String articleObjectName { get; set; }
    public List<List<String>> articleData{get;set;}
    
    public List<SelectOption> getArticleObjectNames() {
        List<SelectOption> options = new List<SelectOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Set<String> keySet = gd.keySet();
        for (String key : keySet) {
            Schema.SObjectType objectType = gd.get(key);
            if (key.endsWith('kav')) {
                options.add(new SelectOption(objectType.getDescribe().getName(), objectType.getDescribe().getLabel()));
            }
        }
        return options;
    }
    
    @RemoteAction
    global static List<List<String>> getFieldProperties(String selectedArticleObject){
        List<String> fields = new List<String>();
        List<String> fieldsType = new List<String>();
        List<List<String>> fieldProperties = new List<List<String>>();
        
        SObjectType sType = Schema.getGlobalDescribe().get(selectedArticleObject);
        Map<String,Schema.SObjectField> fieldMap = sType.getDescribe().fields.getMap();
        
        fields.add(sType.getDescribe().fields.getMap().get('Title').getDescribe().getName());
        fields.add(sType.getDescribe().fields.getMap().get('UrlName').getDescribe().getName());
        fields.add(sType.getDescribe().fields.getMap().get('Summary').getDescribe().getName());
        fieldsType.add(String.valueof(sType.getDescribe().fields.getMap().get('Title').getDescribe().getType()));
        fieldsType.add(String.valueof(sType.getDescribe().fields.getMap().get('UrlName').getDescribe().getType()));
        fieldsType.add(String.valueof(sType.getDescribe().fields.getMap().get('Summary').getDescribe().getType()));
        
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult dfield = sfield.getDescribe();
            if(dfield.isCreateable()==true){
                if(dfield.isCustom() ){
                    fields.add(dfield.getName());
                    fieldsType.add(String.valueof(dfield.getType()));
                }
            }
        }
        
        List<Schema.DescribeDataCategoryGroupResult> describeCategoryResult = Schema.describeDataCategoryGroups(new List<String>{'KnowledgeArticleVersion'});
        for(Schema.DescribeDataCategoryGroupResult r : describeCategoryResult){
            fields.add(r.getName());
            fieldsType.add('Category');
        }
        
        fields.add(sType.getDescribe().fields.getMap().get('IsVisibleInPrm').getDescribe().getName());
        fields.add(sType.getDescribe().fields.getMap().get('IsVisibleInCsp').getDescribe().getName());
        fields.add(sType.getDescribe().fields.getMap().get('IsVisibleInPkb').getDescribe().getName());
        fieldsType.add(String.valueof(sType.getDescribe().fields.getMap().get('IsVisibleInPrm').getDescribe().getType()));
        fieldsType.add(String.valueof(sType.getDescribe().fields.getMap().get('IsVisibleInCsp').getDescribe().getType()));
        fieldsType.add(String.valueof(sType.getDescribe().fields.getMap().get('IsVisibleInPkb').getDescribe().getType()));
        
        
        fieldProperties.add(fields);
        fieldProperties.add(fieldsType);
        return fieldProperties;
        
    }
    
    @RemoteAction
    global static List<List<String>> getGridData(String selectedArticleObject){
        
        List<String> a = new List<String>();

        SObjectType sType = Schema.getGlobalDescribe().get(selectedArticleObject);
        Map<String,Schema.SObjectField> fieldMap = sType.getDescribe().fields.getMap();
        
        a.add(sType.getDescribe().fields.getMap().get('Title').getDescribe().getLabel()+'\n('+sType.getDescribe().fields.getMap().get('Title').getDescribe().getType()+')');
        a.add(sType.getDescribe().fields.getMap().get('UrlName').getDescribe().getLabel()+'\n('+sType.getDescribe().fields.getMap().get('UrlName').getDescribe().getType()+')');
        a.add(sType.getDescribe().fields.getMap().get('Summary').getDescribe().getLabel()+'\n('+sType.getDescribe().fields.getMap().get('Summary').getDescribe().getType()+')');
        
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult dfield = sfield.getDescribe();
            if(dfield.isCreateable()==true){
                if(dfield.isCustom() ){
                    a.add(dfield.getLabel()+'\n('+dfield.getType()+')');
                }
            }
        }
        
        List<Schema.DescribeDataCategoryGroupResult> describeCategoryResult = Schema.describeDataCategoryGroups(new List<String>{'KnowledgeArticleVersion'});
        for(Schema.DescribeDataCategoryGroupResult r : describeCategoryResult){
            a.add(r.getLabel()+'\n(Category)');
        }
        
        a.add(sType.getDescribe().fields.getMap().get('IsVisibleInPrm').getDescribe().getLabel()+'\n('+sType.getDescribe().fields.getMap().get('IsVisibleInPrm').getDescribe().getType()+')');
        a.add(sType.getDescribe().fields.getMap().get('IsVisibleInCsp').getDescribe().getLabel()+'\n('+sType.getDescribe().fields.getMap().get('IsVisibleInCsp').getDescribe().getType()+')');
        a.add(sType.getDescribe().fields.getMap().get('IsVisibleInPkb').getDescribe().getLabel()+'\n('+sType.getDescribe().fields.getMap().get('IsVisibleInPkb').getDescribe().getType()+')');
        
        List<String> b;
        
        List<List<String>> c = new List<List<String>>{a};
        for(Integer i=0 ; i < 5 ; i++) {
            b = new List<String>();
            for(Integer j=0 ; j < a.size() ; j++) {
                b.add('');
            }
            c.add(b);
        }
        return c;
        
    }
    
    @RemoteAction
    global static String insertArticles(String selectedArticleObject, List<List<String>> articleData, List<List<String>> fieldProperties){
        Savepoint sp = Database.setSavepoint();

        String message;
        List<String> fields = fieldProperties[0];
        List<String> fieldsType = fieldProperties[1];
        List<sObject> soList = new List<sObject>();
        List<sObject> socList = new List<sObject>();
        try{
            for(Integer i=1; i<articleData.size(); i++){
                if(articleData[i][0]!=null && articleData[i][1]!=null && articleData[i][0]!='' && articleData[i][1]!=''){
                    sObject sObj = Schema.getGlobalDescribe().get(selectedArticleObject).newSObject();
                    for(Integer j=0; j<fields.size(); j++){
                        if(fieldsType[j]=='Category'){
                        }else if(fieldsType[j]!='Boolean'){
                            sObj.put(fields[j] , articleData[i][j].removeStart('"').removeEnd('"'));
                        }else{
                            sObj.put(fields[j] , Boolean.valueof(articleData[i][j].removeStart('"').removeEnd('"')));
                        }
                    }
                    soList.add(sObj);
                }
            }
            insert soList;
            
            for(Integer i=0; i<soList.size(); i++){
                for(Integer j=0; j<fields.size(); j++){
                    if(fieldsType[j]=='Category'){
                        if(articleData[i+1][j]!=''){
                            sObject sObjCategory = Schema.getGlobalDescribe().get(selectedArticleObject.replace('kav', 'DataCategorySelection')).newSObject();
                            sObjCategory.put('ParentId', soList[i].Id);
                            sObjCategory.put('DataCategoryGroupName', fields[j]);
                            sObjCategory.put('DataCategoryName', articleData[i+1][j].removeStart('"').removeEnd('"'));
                            socList.add(sObjCategory);
                        }
                    }
                }
            }
            Insert socList;
            
            for(sObject sObj : soList){
                sObj = Database.query('Select id, KnowledgeArticleId From ' + selectedArticleObject + ' Where id = \''+sObj.Id+'\'');
                KbManagement.PublishingService.publishArticle(String.valueof(sObj.get('KnowledgeArticleId')), true);
            }
            
            
        }catch(Exception ex){
            Database.rollback(sp);
            return ex.getMessage();
        }
        if(soList.size()==0){
            message = 'Invalid Entry';
        }else{
            message = 'Articles Successfully Created!';
        }
        return message;
    }
}