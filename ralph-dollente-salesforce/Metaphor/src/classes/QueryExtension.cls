public class QueryExtension {
    public static List<SObject> setQuery(String[] fieldname, String objectName, String whereCondition, String limits){
        List<SObject> resultSet = new List<SObject>();
        String queryString = 'SELECT ';
        
        for(String f :fieldname){            
            queryString +=  f + ',';
        }
        
        if (queryString.endsWith(',')){
            queryString = queryString.substring(0, queryString.lastIndexOf(','));
        }        

        queryString += ' FROM ' + objectName;       
        
        if (!String.isEmpty(whereCondition) && !String.isBlank(whereCondition)){
            queryString += ' ' + whereCondition;
        }
        
    
        if (!String.isEmpty(limits) && !String.isBlank(limits)){
            queryString += ' ' + limits;
        }
        
        System.debug('*** QUERY *** ' + queryString);        
        resultSet = Database.query(queryString);
        System.debug('*** RESULT SET *** ' + resultSet);
    
        return resultSet;
    }
}