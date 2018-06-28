public class SObjectAllFieldCloner {

  // Clone a list of objects to a particular object type
  // Parameters 
  // - List<sObject> sObjects - the list of objects to be cloned 
  // - Schema.SobjectType objectType - the type of object to be cloned.
  // The sObjects you pass in must include the ID field, 
  // and the object must exist already in the database, 
  // otherwise the method will not work.
  public static List<sObject> cloneObjects(List<sObject> sObjects,
                                        Schema.SObjectType objectType){
    
    // A list of IDs representing the objects to clone
    List<Id> sObjectIds = new List<Id>{};
    // A list of fields for the sObject being cloned
    List<String> sObjectFields = new List<String>{};
    // A list of new cloned sObjects
    List<sObject> clonedSObjects = new List<sObject>{};
    
    // Get all the fields from the selected object type using 
    // the get describe method on the object type.
    if(objectType != null){
      sObjectFields.addAll(
        objectType.getDescribe().fields.getMap().keySet());
    }
    
    // If there are no objects sent into the method, 
    // then return an empty list
    if (sObjects != null && 
        !sObjects.isEmpty() && 
        !sObjectFields.isEmpty()){
    
      // Strip down the objects to just a list of Ids.
      for (sObject objectInstance: sObjects){
        sObjectIds.add(objectInstance.Id);
      }

      /* Using the list of sObject IDs and the object type, 
         we can construct a string based SOQL query 
         to retrieve the field values of all the objects.*/
    
      String allSObjectFieldsQuery = 'SELECT ' + sObjectFields.get(0); 
    
      for (Integer i=1 ; i < sObjectFields.size() ; i++){
        allSObjectFieldsQuery += ', ' + sObjectFields.get(i);
      }
    
      allSObjectFieldsQuery += ' FROM ' + 
                               objectType.getDescribe().getName() + 
                               ' WHERE ID IN (\'' + sObjectIds.get(0) + 
                               '\'';

      for (Integer i=1 ; i < sObjectIds.size() ; i++){
        allSObjectFieldsQuery += ', \'' + sObjectIds.get(i) + '\'';
      }
    
      allSObjectFieldsQuery += ')';
    
      try{
      
        // Execute the query. For every result returned, 
        // use the clone method on the generic sObject 
        // and add to the collection of cloned objects
        for (SObject sObjectFromDatabase:
             Database.query(allSObjectFieldsQuery)){
          clonedSObjects.add(sObjectFromDatabase.clone(false,true));  
        }
    
      } catch (exception e){
        // Write exception capture method 
        // relevant to your organisation. 
        // Debug message, Apex page message or 
        // generated email are all recommended options.
      }
    }    
    
    // return the cloned sObject collection.
    return clonedSObjects;
  }
}