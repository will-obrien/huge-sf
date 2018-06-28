public class TimelineController{

    private static Map<String, String> createFieldMap(String dateStartField, String dateEndField, String textField, String captionField, String headlineField, String urlField){
        Map<String, String> fieldMap = new Map<String, String>();
        fieldMap.put('headline', headlineField);
        fieldMap.put('startDate', dateStartField);
        fieldMap.put('text', textField);
        if(!String.isEmpty(urlField)){
            fieldMap.put('url', urlField); 
        }
        if(!String.isEmpty(dateEndField)){
            fieldMap.put('endDate', dateEndField); 
        }
        if(!String.isEmpty(captionField)){
            fieldMap.put('caption', captionField);        
        }
        return fieldMap;
    }
    private static String createSoql(String objectName, Map<String, String> fieldMap){
        String soql = 'select ';
            soql += fieldMap.get('headline') + ', ';

        if(!soql.containsIgnoreCase(' ' + fieldMap.get('startDate') + ',')){
            soql += fieldMap.get('startDate') + ', ';        
        }
        if(!soql.containsIgnoreCase(' ' + fieldMap.get('text') + ',')){
            soql += fieldMap.get('text') + ', ';
        }

        if(!soql.containsIgnoreCase(' ' + fieldMap.get('caption') + ',') && fieldMap.containsKey('caption')){
            soql += fieldMap.get('caption') + ', ';
        }
        if(!soql.containsIgnoreCase(' ' + fieldMap.get('url') + ',') && fieldMap.containsKey('url')){
            soql += fieldMap.get('url') + ', ';
        }
        if(!soql.containsIgnoreCase(' ' + fieldMap.get('endDate') + ',') && fieldMap.containsKey('endDate')){
            soql += fieldMap.get('endDate') + ', ';        
        }
        soql = soql.substring(0, soql.lastIndexOf(','));
        soql += ' from ' + objectName + ' order by ' + fieldMap.get('startDate') + ' asc';
        System.debug('soql: ' + soql);
        return soql;
    }    

    @AuraEnabled
    public static List<TimelineEvent> getTimelineEvents(String objectName, String dateStartField, String dateEndField, String textField, String captionField, String headlineField, String urlField){
        List<TimelineEvent> events = new List<TimelineEvent>();
        Map<String, String> fieldMap = createFieldMap(dateStartField, dateEndField, textField, captionField, headlineField, urlField);
        String soql = createSoql(objectName, fieldMap);
        for(SObject record: Database.query(soql)){
            events.add(new TimelineEvent(record, fieldMap));
        }
        System.debug('events: ' + events);
        return events;
    }

}