public class HighChartsController{

    private static String createConditions(String[] conditions){
        String condition = '';
        if(conditions.size()>0){
            condition += ' where ';
            for(String s :conditions){
                condition += ' ' + s + ' and';
            }
            condition = condition.substring(0, condition.length()-3);
        }
        return condition;
    }

    private static String createOrderBy(String orderBy){
        if(!String.isEmpty(orderBy)){
            return ' order by ' + orderBy;
        }
        return '';    
    }

    private static String createGroupBy(String groupBy){
        if(!String.isEmpty(groupBy)){
            return ' group by ' + groupBy;
        }
        return '';    
    }

    private static String createQuery(String tableName, String[] fieldArray){
        return createQuery(tableName, fieldArray, new String[]{}, '');    
    }

    private static String createQuery(String tableName, String[] fieldArray, String[] conditions ){
        return createQuery(tableName, fieldArray, conditions, '');
    }

    private static String createQuery(String tableName, String[] fieldArray, String[] conditions, String orderBy ){
        String query = 'select ';
        for(String s : fieldArray){
            if(!String.isEmpty(s)){
                query += s + ',';
            }
        }
        return query.substring(0, query.length()-1) + ' from ' + tableName + createConditions(conditions) + createOrderBy(orderBy);
    }

    private static String createQueryWithGroupBy(String tableName, String[] fieldArray, String[] conditions, String groupBy, String orderBy){
        String query = 'select ';
        for(String s : fieldArray){
            if(!String.isEmpty(s)){
                query += s + ',';
            }
        }
        return query.substring(0, query.length()-1) + ' from ' + tableName + createConditions(conditions) + createGroupBy(groupBy) + createOrderBy(orderBy);
    }

    private static List<Decimal> getValues(SObject obj, String[] fieldArray){
        List<Decimal> values = new List<Decimal>();
        for(String s : fieldArray){
            if(!String.isEmpty(s)){
                Decimal n = (Decimal)obj.get(s);
                values.add( n==null ? 0 : n);
            }
        }
        return values;
    }

    private static List<Decimal> queryDecimalValuesOfRecord(String objectName, String[] fieldArray, String recordIdFieldName, String recordId){
        String query = createQuery(objectName, fieldArray, new String[]{recordIdFieldName + '=\'' + recordId + '\''});
        List<SObject> records = Database.query(query);
        if(records!=null && records.size()>0){
            SObject record = records.get(0);
            return getValues(record, fieldArray);            
        }
        return new List<Integer>();
    }

    @AuraEnabled
    public static List<Decimal> getRadarFieldValues(String recordId, String objectName, String recordIdFieldName, String[] fieldArray){
        return queryDecimalValuesOfRecord(objectName, fieldArray, recordIdFieldName, recordId);
    }
    @AuraEnabled
    public static List<Decimal> getActivityGaugeFieldValues(String recordId, String objectName, String recordIdFieldName, String[] fieldArray){
        return queryDecimalValuesOfRecord(objectName, fieldArray, recordIdFieldName, recordId);
    }


    @AuraEnabled
    public static List<String> getAreaChartGroupValues(String recordId, String objectName, String recordIdFieldName, String groupField){
        String query = createQueryWithGroupBy(objectName, new String[]{groupField}, new String[]{recordIdFieldName + '=\'' + recordId + '\''}, groupField, groupField);
        List<String> groupValues = new List<String>();
        for(SObject record : Database.query(query)){
            groupValues.add(String.valueOf(record.get(groupField)));
        }
        return groupValues;
    }

    private static List<ChartDataWrapper> getMultipleGroupValues(String recordId, String objectName, String recordIdFieldName, String yField, String group1, String group2, String[] group1Values, String[] group2Values){
        List<ChartDataWrapper> yValues = new List<ChartDataWrapper>();        
        for(String group2value : group2Values){
            List<Decimal> data = new List<Decimal>();
            for(String group1value : group1Values){
                List<String> conditions = new List<String>();
                conditions.add(recordIdFieldName + '=\'' + recordId + '\'');
                conditions.add(group1 + '=\'' + group1value + '\'');
                conditions.add(group2 + '=\'' + group2value + '\'');
                String query = createQuery(objectName, new String[]{yField + ' val'}, conditions);
                for(SObject record : Database.query(query)){
                    data.add((Decimal)record.get('val'));
                }
            }
            yValues.add(new ChartDataWrapper(group2Value, data));        
        }
        return yValues;
    }
    private static List<ChartDataWrapper> getSingleGroupValues(String recordId, String objectName, String recordIdFieldName, String yField, String groupField, String[] groupValues){
        List<ChartDataWrapper> yValues = new List<ChartDataWrapper>();        
        List<Decimal> data = new List<Decimal>();
        for(String value : groupValues){
            List<String> conditions = new List<String>();
            conditions.add(recordIdFieldName + '=\'' + recordId + '\'');
            conditions.add(groupField + '=\'' + value + '\'');
            String query = createQuery(objectName, new String[]{yField + ' val'}, conditions);
            for(SObject record : Database.query(query)){
                data.add((Decimal)record.get('val'));
            }
        }
        yValues.add(new ChartDataWrapper('data', data));
        return yValues;
    }    
    @AuraEnabled
    public static List<ChartDataWrapper> getAreaChartYFieldValues(String recordId, String objectName, String recordIdFieldName, String yField, String group1, String group2, String[] group1Values, String[] group2Values){
        if(!yField.contains('(')){
            yField = 'count(' + yField + ')';
        }
        if(group2Values.size()==0){
            return getSingleGroupValues(recordId, objectName, recordIdFieldName, yField, group1, group1Values);
        }else{
            return getMultipleGroupValues(recordId, objectName, recordIdFieldName, yField, group1, group2, group1Values, group2Values);
        }
    }
    
}