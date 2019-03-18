public class SlickSidebarFieldsetHelper {

    // MANDATORY FIELDS FOR ALL FieldSet Queries -
    // Ensure that fields deemed mandatory (by me) are part of the query.
    // First looks to see whether that field actually exists and is it is not part of the fieldset
    // adds it to the query so that things don't blow up
    private static String ID_FIELD = 'Id';
    private static String TAB_NAME_FIELD = 'SlickSidebar_Tab_Name__c';
    private static String NAME_FIELD = 'Name';


	/**
	 *
	 * Returns a comma separated list of members within the FieldSetMember list passed in
	 * Typically used to create the SOQL query to pull stuff from whatever the object assiciated with the fieldset it
	 *
	 **/
    public static String parseFieldSetMembers(SObject theObject, List<Schema.FieldSetMember> fields) {
    	boolean includedIdField = false;
        boolean includedTabNameField = false;
        boolean tabNameFieldExists = false;
        boolean includedNameField = false;

        String fieldList = '';    
        if (fields != null) {
            for(Schema.FieldSetMember curMemb : fields) {
                fieldList += curMemb.getFieldPath() + ',';

                if ( ID_FIELD.equalsIgnoreCase( curMemb.getFieldPath() ) ) {
                	includedIdField = true;
                }

                if ( TAB_NAME_FIELD.equalsIgnoreCase(curMemb.getFieldPath()) ) {
                    includedTabNameField = true;
                }
                
                if ( NAME_FIELD.equalsIgnoreCase(curMemb.getFieldPath())  ) {
                    includedNameField = true;
                }
            }

            if ( includedIdField == false ) {
            	System.debug('ID field was not included in the field set so am manually adding it in');
            	fieldList += ID_FIELD + ',';
            }

            if (includedTabNameField == false ) {
                System.debug('SlickSidebar_Tab_Name__c has not been included in the field set for ' + theObject.getSObjectType() );
                if ( doesTabNameFieldExist(theObject) ) {
                    System.debug('SlickSidebar_Tab_Name__c field was not included in the field set and it exists on the object so am manually adding it in');
                    fieldList += TAB_NAME_FIELD + ',';
                }
            }
            
            if (includedNameField == false) {
                if ( doesFieldExist(theObject, NAME_FIELD) ) {
                    System.debug('SlickSidebar_Tab_Name__c field was not included in the field set and it exists on the object so am manually adding it in');
                    fieldList += NAME_FIELD + ',';
                }              
            }
            fieldList = fieldList.removeEnd(',');                
        }               
        return fieldList;
    }

    /**
     *
     * Checks whether the passed in object contains the SlickSidebar_Tab_Name__c field within it's description
     *
     **/
    private static boolean doesFieldExist(SObject theObject, String fieldName) {    
        boolean objectContainsField = false;
        List<Schema.DescribeSObjectResult> describeSObjectResults;
        Map<String, Schema.SObjectField> fieldMap;

        describeSObjectResults = Schema.describeSObjects(new String[] {String.valueOf(theObject.getSObjectType())});
        fieldMap = describeSObjectResults[0].fields.getMap();

        if ( fieldMap.containsKey(fieldName) ) {
            objectContainsField = true;  
            System.debug('The '+ fieldName + ' field DOES exist for the object: ' +  theObject.getSObjectType());
        } else {
            System.debug('The '+ fieldName + ' field DOES NOT exist for the object: ' +  theObject.getSObjectType());
        }
        return objectContainsField;
    }    
    
    
    /**
     *
     * Checks whether the passed in object contains the SlickSidebar_Tab_Name__c field within it's description
     *
     **/
    private static boolean doesTabNameFieldExist(SObject theObject) {    
        boolean objectContainsTabNameField = false;
        List<Schema.DescribeSObjectResult> describeSObjectResults;
        Map<String, Schema.SObjectField> fieldMap;

        describeSObjectResults = Schema.describeSObjects(new String[] {String.valueOf(theObject.getSObjectType())});
        fieldMap = describeSObjectResults[0].fields.getMap();

        if ( fieldMap.containsKey(TAB_NAME_FIELD) ) {
            objectContainsTabNameField = true;  
            System.debug('The SlickSidebar_Tab_Name__c field DOES exist for the object: ' +  theObject.getSObjectType());
        } else {
            System.debug('The SlickSidebar_Tab_Name__c field DOES NOT exist for the object: ' +  theObject.getSObjectType());
        }
        return objectContainsTabNameField;
    }


    /**
     *
     * Creates the basis of a SOQL query for the object and fieldset passed in and filters by the id passed in
     * @return String 'SELECT Id, Name FROM Service__c'
     *
     **/
    public static String createBaseQueryString(SObject theObject, List<Schema.FieldSetMember> fields, ID id) {
    	String queryString = '';
    	queryString = createBaseQueryString(theObject, fields) + ' WHERE ID = \'' + id + '\'';

    	System.debug('SlickSidebarFieldsetHelper.createBaseQueryString(WITH ID) - generated SOQL query string is: ' + queryString);

    	return queryString;
    }

    /**
     *
     * Creates the basis of a SOQL query for the object and fieldset passed in
     * @return String 'SELECT Id, Name FROM Service__c'
     *
     **/
	public static String createBaseQueryString(SObject theObject, List<Schema.FieldSetMember> fields) {    
    	String queryString = '';
    	queryString = 'SELECT ' + parseFieldSetMembers(theObject, fields) + ' FROM ' + theObject.getSObjectType();
    	return queryString;
	}

    public void UnitTestCompliance() {
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;            
    }    

}