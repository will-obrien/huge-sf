@isTest(SeeAllData=true)
private class TestInsertArticleRecords{
    static testMethod void getFields(){
        
        String selectedArticleObject;
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Set<String> keySet = gd.keySet();
        for (String key : keySet) {
            Schema.SObjectType objectType = gd.get(key);
            if (key.endsWith('kav')) {
                selectedArticleObject = objectType.getDescribe().getName();
            }
        }
        List<List<String>> fieldProperties = InsertArticleRecords.getFieldProperties(selectedArticleObject);
        InsertArticleRecords.getGridData(selectedArticleObject);
        List<List<String>> articleData = new List<List<String>>();
        List<String> tableData = new List<String>();
        for(String f : fieldProperties[0]){
            tableData.add('a');
        }
        articleData.add(tableData);
        InsertArticleRecords.insertArticles(selectedArticleObject, articleData, fieldProperties);
        //InsertArticleRecords.getArticleObjectNames();
        PageReference pageRef = Page.InsertArticleRecords;
        InsertArticleRecords controller = new InsertArticleRecords();
        controller.getArticleObjectNames();
    }
}