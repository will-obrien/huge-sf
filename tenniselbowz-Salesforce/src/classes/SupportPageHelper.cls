public with sharing class SupportPageHelper {
    
    // Builds a dynamic query based on passed in fields and object
    public static String buildSearchQuery(List<String> displayFields, Set<String> sortFields, sObject obj, Map<String, String> additionalFields, String additionalQueryCondition){
        String query = 'SELECT ' + String.join(displayFields, ', ') + ' FROM ' + obj.getSobjectType() + ' WHERE ';
        List<String> searchFields = new List<String>(sortFields);
        String queryConditions = '';
        
        for(Integer i = 0; i < searchFields.size(); i++){
            String queryBuilder = (queryConditions != '') ? ' OR ' : '';
            
            Object fieldValue = null;
            if(searchFields[i].contains('.')){
                List<String> splitFields = searchFields[i].split('\\.');
                if(splitFields.size() == 2){
                    Sobject fieldObj = (obj.getSobject(splitFields[0]));
                    if(fieldObj != null) {
                        fieldValue = fieldObj.get(splitFields[1]);
                    }
                }
            } else {
                fieldValue = obj.get(searchFields[i]);
            }
            if(fieldValue != null){
                queryConditions += queryBuilder + searchFields[i] + ' = \'' + String.escapeSingleQuotes(String.valueOf(fieldValue)) + '\'';
            }
        }
        for(String field : additionalFields.keyset()) {
            String queryBuilder = (queryConditions != '') ? ' OR ' : '';
            String fieldValue = additionalFields.get(field);
            
            if(!String.isBlank(fieldValue)){
                //Some fields are tied together in this search, ie Contact FirstName and LastName. We need to ensure they
                //both are matching values.
                if(field.contains(';')){
                   List<string> splitField = field.split(';');
                   List<string> splitValue = fieldValue.split(';');
                   if(splitField.size() > 1 && (splitValue.size() == splitField.size()) ) {
                       String andString = '(';
                       for(integer i = 0; i < splitField.size(); i++){
                           if(andString != '('){
                               andString += ' AND ';
                           }
                           andString += splitField[i] + ' LIKE \'%' + splitValue[i] + '%\'';
                       }
                       queryConditions += queryBuilder + andString + ')';
                   } 
                   
                } else {
                    queryConditions += queryBuilder + field + ' = \'' + String.escapeSingleQuotes(String.valueOf(fieldValue)) + '\'';
                }
            }
        }
        
        if(additionalQueryCondition != null && additionalQueryCondition != '') {
            String queryBuilder = (queryConditions != '') ? ' OR ' : '';
            queryConditions += queryBuilder + additionalQueryCondition;
        }
        if(queryConditions == '') return null;
        
        query += queryConditions + ' LIMIT 49500';
        System.debug('>>> buildQuery result: ' + query);
        return query;
    }
    
    
    // Counts number of "hits" with search on object and returns results sorted by relevance
    public static SupportPageCont.checkboxWrapperList sortRecords (List<String> fieldsToReturn, List<Sobject> queriedObjects, Sobject proxyObj, Map<Id, Integer> additionalMatchesMap) {
       System.debug('>>> Found ' + queriedObjects.size() + ' records, attempting to sort...');
        Map<Integer, List<Sobject>> matchesToSobjectmap = new Map<Integer, List<Sobject>>();
        
        for(Sobject obj : queriedObjects) {
            
            Integer additionalMatches = (additionalMatchesMap.containsKey(obj.id)) ? additionalMatchesMap.get(obj.id) : 0;
            Integer matches = findRecordMatches(fieldsToReturn, obj, proxyObj ) + additionalMatches;
            if(matchesToSobjectmap.containsKey(matches)) {
                matchesToSobjectmap.get(matches).add(obj);
            } else {
                matchesToSobjectmap.put(matches, new List<Sobject>{obj});
            }
        }
        return sortByRelevance(matchesToSobjectmap, fieldsToReturn.size() + 5);
    }
    
    // Goes through search results and figures out and returns number of "hits" based on search terms
    @testVisible
    private static Integer findRecordMatches (List<String> fieldsToReturn, Sobject queryObj, Sobject proxyObj){
       Integer counter = 0;
       
       for(String field : fieldsToReturn ) {
           if(field.contains('.')) {
                List<String> splitFields = field.split('\\.');
                if(splitFields.size() == 2){
                    
                    SObject proxyFieldValue =  (proxyObj.getSobject(splitFields[0]));  
                    SObject objectFieldValue = (queryObj.getSobject(splitFields[0]));
                    
                    if(proxyFieldValue != null && objectFieldValue != null && proxyFieldValue.get(splitFields[1]) != null && objectFieldValue.get(splitFields[1]) != null ) {
                        String proxyStringValue = String.valueOf(proxyFieldValue.get(splitFields[1])).toLowerCase();
                        String objectStringValue = String.valueOf(objectFieldValue.get(splitFields[1])).toLowerCase();
                    
                        if(objectStringValue.contains(proxyStringValue) ){
                            counter++;
                        }
                    }
                }
           } else {
               Object proxyFieldValue = proxyObj.get(field);
               Object objectFieldValue = queryObj.get(field);
               if ( proxyFieldValue != null && objectFieldValue != null) {
                   String proxyStringValue = String.valueOf(proxyFieldValue).toLowerCase(); 
                   String objectStringValue = String.valueOf(objectFieldValue).toLowerCase();
                   if(objectStringValue.contains(proxyStringValue) ){
                       counter++;
                   }
               }
           }
       } 
       return counter;
        
    }
    
    // Returns a checkboxWrapperList with results sorted by relevance (designated by Map parameter)
    @testVisible
    private  static SupportPageCont.checkboxWrapperList sortByRelevance(Map<Integer, List<sObject>> relevanceMap, Integer maxFields){ 
        SupportPageCont.checkboxWrapperList wrapperList = null; 
        
        for(integer i = maxFields; i >= 0; i--) {
            if(relevanceMap != null && relevanceMap.containsKey(i)) {
                if(wrapperList == null) {
                    wrapperList = new SupportPageCont.checkboxWrapperList(relevanceMap.get(i));
                } else {
                    for(SObject obj : relevanceMap.get(i)){
                        wrapperList.wrappers.add(new SupportPageCont.checkboxWrapper(obj));
                    }
                }
            }    
        }
        if(wrapperList != null) wrapperList.reduce(SupportPageCont.searchLimit);
        return wrapperList;
    }
    
    public static Map<Id, Integer> findCaseAdditionalSearchMatches(Set<ID> caseAssetMatches, Map<String, String> additionalFields, List<Case> cases) {
        Map<Id, Integer> additionalSearchMatchesMap = new Map<Id, Integer>();
        
        for(ID ourID : caseAssetMatches ) {
            additionalSearchMatchesMap.put(ourID, 1);
        }
        
        findObjectAdditionalFieldMatches(cases, additionalFields, additionalSearchMatchesMap);
        
        return additionalSearchMatchesMap; 
    }
    
    
    
    public static void findObjectAdditionalFieldMatches(List<SObject> objects, Map<String, String> additionalFields, Map<Id, Integer> additionalSearchMatchesMap) {        
        for(Sobject obj : objects) {
            for(String fieldName : additionalFields.keyset() ) {
                Object fieldValue = obj.get(fieldName);
                Object otherFieldValue = additionalFields.get(fieldName);
                if(fieldValue!= null && otherFieldValue != null ){
                    String fieldString = String.valueOf(fieldValue).toLowerCase();
                    String otherFieldString = String.valueOf(otherFieldValue).toLowerCase();
                    if(fieldString.contains(otherFieldString)){
                        if(additionalSearchMatchesMap.containsKey(obj.id)) {
                            Integer newMatchNumber = 1 + additionalSearchMatchesMap.get(obj.id);
                            additionalSearchMatchesMap.put(obj.id, newMatchNumber);
                        } else {
                            additionalSearchMatchesMap.put(obj.id, 1);
                        }
                    }
                }
            }
        }
    }
    
}