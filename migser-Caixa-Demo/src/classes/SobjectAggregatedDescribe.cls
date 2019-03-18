@RestResource(urlMapping='/getSobjectInfo')
global without sharing class SobjectAggregatedDescribe {
    
    global class MissingsObjectException extends Exception{}
    
    global class SobjectAggregatedDescribeResponse {
        Set<String> availableSObjectTypeSet;
        Map<String, List<fieldWrapper>> sObjectDescribes;
        
        public SobjectAggregatedDescribeResponse() {
            availableSObjectTypeSet = new Set<String>();
            sObjectDescribes = new Map<String, List<fieldWrapper>>();
        }
    }
    
    global class fieldWrapper {
        String fieldAPIName;
        String fieldLabel;
        Boolean isLookup;
        String lookupTargetType;
        
        public fieldWrapper(Schema.SObjectField fieldInfo, Schema.sObjectType sObjectType){
            Schema.DescribeFieldResult fieldDesRes = fieldInfo.getDescribe();
            this.fieldAPIName = fieldDesRes.getName();
            this.fieldLabel = fieldDesRes.getLabel();
            
            Schema.sObjectType refrenceTo = getReferenceTo(fieldDesRes, sObjectType);                  
            this.isLookup = refrenceTo != NULL;// Do not use: fieldDesRes.isIdLookup()!! It returns true for Id & Email fields (API 35.0)    
            this.lookupTargetType =  refrenceTo != NULL ? String.valueOf(refrenceTo) : NULL;
        }
        
        // Checks if referenceTo exists, if so assigns it.
        // If referenceTo does not exists, it may still be an Id field. In this case assigns the sObjectType as referenceTo.
        private Schema.sObjectType getReferenceTo(Schema.DescribeFieldResult fieldDesRes ,Schema.sObjectType sObjectType){
            List<Schema.sObjectType> tempList = fieldDesRes.getReferenceTo();
            return (tempList != null && tempList.size() > 0) ? 
                tempList[0]
                :
            fieldDesRes.getName() == 'Id' ? sObjectType: NULL;
        }
    }
    
    @HttpGet
    global static String getDataWorkflowSobjectInfo(){
        SobjectAggregatedDescribeResponse response = new SobjectAggregatedDescribeResponse();
        Map<String,String> reqParams;
        if(test.isRunningTest()) {
            reqParams = null;
        } else {
            reqParams = RestContext.request.params == null ? new Map<String,String>() : RestContext.request.params;
        }
        
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();        
        
        String objList = test.isRunningTest() ? 'Account' : reqParams.get('detail');
        Object specOnly = test.isRunningTest() ? 'true' : reqParams.get('specifiedOnly');

        response = populateDetailSobject (response, globalDescribe, safe_GetSobjectListFromParam(objList));
        
        if (!safe_BooleanValueOf(specOnly)) {
            response.availableSObjectTypeSet = globalDescribe.keySet();
        }
        
        return JSON.serialize(response);
    }
    
    // Changes response in place.
    private static SobjectAggregatedDescribeResponse populateDetailSobject(  
        SobjectAggregatedDescribeResponse response, 
        final Map<String, Schema.SObjectType> globalDescribe,
        final List<String> sobjectToDetail) {
            
            for (String sobjectName: sobjectToDetail){
                if (!globalDescribe.containsKey(sobjectName)){
                    throw new MissingsObjectException ('Unknwon sObject: ' + sobjectName);
                }
                
                response.sObjectDescribes.put(
                    sobjectName, 
                    getFieldsForSobject(globalDescribe.get(sobjectName)) 
                );
                response.availableSObjectTypeSet.add(sobjectName);
            }
            return response;
        }
    
    // Silently tries to convert too boolean, if fails return false.
    private static Boolean safe_BooleanValueOf(Object o) {
        try {
            return Boolean.valueOf(o);
        } catch(Exception e) {
            return false;
        }
    }
    
    private static List<String> safe_GetSobjectListFromParam(String sobListStr) {
        List<String> retList = new List<String>();
        if (sobListStr != null && sobListStr.length() != 0) {
            retList = sobListStr.split(',');
        }
        return retList;
    }
    
    private static List<fieldWrapper> getFieldsForSobject (Schema.sObjectType sObjectType){
        List<fieldWrapper> retList = new List<fieldWrapper>();
        for (Schema.SObjectField iteratedField :sObjectType.getDescribe().fields.getMap().values()) {
            retList.add(new fieldWrapper(iteratedField,sObjectType));
        }
        return retList;
    }
}