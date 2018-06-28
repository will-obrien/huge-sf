/* Developer   : Keerthi Chandra
 * DateTime    : 11-05-16
 * Description : Roll Up Summary caluculation on the campaign for budget cost of child CampaignLink records.
 * Status      : Developed
 */
public class K_RollUpSummary_CampgnBudget
{
     ///<OBJECTIVE>
     /// Wrapper Class
     ///<OBJECTIVE>
     public class fieldDefinition 
     {
         public String strOperation {get;set;}
         public String strChildField {get;set;}
         public String strParentField {get;set;}
         public fieldDefinition (String o, String c, String p) {
         strOperation = o;
         strChildField = c;
         strParentField = p;
         }
     }
     
    ///<OBJECTIVE>
    /// Roll Up Summary Calculation
    ///<OBJECTIVE>
    public static void rollUpTrigger(list<fieldDefinition> fieldDefinitions,
     list<sObject> lstRecords, String strChildObject, String strChildParentLookupField,
     String strParentObject, String strQueryFilter) 
     {
        set<Id> setParentIds = new set<Id>();
        String strFieldsToAggregate = '';
        String strParentFields = '';
        if(lstRecords.size()>0)
        {
            for(sObject s : lstRecords) 
            {
               if(s.get(strChildParentLookupField) != null)
               {
                setParentIds.add((Id)s.get(strChildParentLookupField));
               }
                              
            }
        }
        //populate query text strings to be used in child aggregrator and parent value assignment
        if(fieldDefinitions.size()>0)
        {
            for(fieldDefinition d : fieldDefinitions) 
            {
                 strFieldsToAggregate += d.strOperation + '(' + d.strChildField + ') ' +', ';
                 strParentFields += d.strParentField + ', ';
                
            }
         }
        //Using dynamic SOQL with aggergate results populate parentValueMap
         String aggregateQuery = 'Select ' + strFieldsToAggregate +
         strChildParentLookupField + ' from ' + strChildObject + ' where  ' +
         strChildParentLookupField + ' IN :setParentIds ' + strQueryFilter + ' ' +
         ' group by ' + strChildParentLookupField;
         
        //Map will contain one parent record Id per one aggregate object
         map<Id, AggregateResult> parentValueMap =
         new map <Id, AggregateResult>();
        try
        {
            for(AggregateResult q : Database.query(aggregateQuery))
            {
                parentValueMap.put((Id)q.get(strChildParentLookupField), q);
              
            }
            
            //list of parent object records to update
            list<sObject> lstParentsToUpdate = new list<sObject>();
            String strParentQuery = 'select ' + strParentFields + ' Id ' +
            ' from ' + strParentObject + ' where  Id IN :setParentIds';
            
            system.debug('strParentQuery @@@'+strParentQuery );
            //for each affected parent object, retrieve aggregate results and
            //for each field definition add aggregate value to parent field
            for(sObject s : Database.query(strParentQuery)) 
            {
                Integer row = 0; //row counter reset for every parent record
                for(fieldDefinition d : fieldDefinitions) {
                    String field = 'expr' + row.format();
                    AggregateResult r = parentValueMap.get(s.Id);
                    //r will be null if no records exist
                    if(r != null) {
                        Decimal value = ((Decimal)r.get(field) == null ) ? 0 :
                        (Decimal)r.get(field);
                        s.put(d.strParentField, value);
                    } else {
                        s.put(d.strParentField, 0);
                    }
                    row += 1; //plus 1 for every field definition after first
                }
                lstParentsToUpdate.add(s);
            }
            
            //if parent records exist, perform update of all parent records
            //with a single DML statement
            if(lstParentsToUpdate.Size() > 0) 
            {
                Utility.updtSObject(lstParentsToUpdate);
            }
        }
        Catch(Exception ex){}
    }
    
    
     ///<OBJECTIVE>
    /// Roll Up Summary Calculation
    ///<OBJECTIVE>
    public static void rollUpOldCmpg(list<fieldDefinition> fieldDefinitions,
     list<sObject> lstRecords, String strChildObject, String strChildParentLookupField,
     String strParentObject, String strQueryFilter) 
     {
        set<Id> setParentIds = new set<Id>();
        String strFieldsToAggregate = '';
        String strParentFields = '';
        if(lstRecords.size()>0)
        {
            for(sObject s : lstRecords) 
            {
               if(s.get(strChildParentLookupField) != null)
               {
                setParentIds.add((Id)s.get(strChildParentLookupField));
               }
               
                 system.debug('setParentIds@@@'+setParentIds);
               
            }
        }
        //populate query text strings to be used in child aggregrator and parent value assignment
        if(fieldDefinitions.size()>0)
        {
            for(fieldDefinition d : fieldDefinitions) 
            {
                 strFieldsToAggregate += d.strOperation + '(' + d.strChildField + ') ' +', ';
                 strParentFields += d.strParentField + ', ';
                
            }
         }
        //Using dynamic SOQL with aggergate results populate parentValueMap
         String aggregateQuery = 'Select ' + strFieldsToAggregate +
         strChildParentLookupField + ' from ' + strChildObject + ' where  ' +
         strChildParentLookupField + ' IN :setParentIds ' + strQueryFilter + ' ' +
         ' group by ' + strChildParentLookupField;
         system.debug('aggregateQuery @@@'+aggregateQuery );
         
        //Map will contain one parent record Id per one aggregate object
         map<Id, AggregateResult> parentValueMap =
         new map <Id, AggregateResult>();
        try
        {
            for(AggregateResult q : Database.query(aggregateQuery))
            {
                parentValueMap.put((Id)q.get(strChildParentLookupField), q);
             
            }
            
            //list of parent object records to update
            list<sObject> lstParentsToUpdate = new list<sObject>();
            String strParentQuery = 'select ' + strParentFields + ' Id ' +
            ' from ' + strParentObject + ' where  Id IN :setParentIds';
            
            //for each affected parent object, retrieve aggregate results and
            //for each field definition add aggregate value to parent field
            for(sObject s : Database.query(strParentQuery)) 
            {
                Integer row = 0; //row counter reset for every parent record
                for(fieldDefinition d : fieldDefinitions) {
                    String field = 'expr' + row.format();
                    AggregateResult r = parentValueMap.get(s.Id);
                    //r will be null if no records exist
                    if(r != null) {
                        Decimal value = ((Decimal)r.get(field) == null ) ? 0 :
                        (Decimal)r.get(field);
                        s.put(d.strParentField, value);
                    } else {
                        s.put(d.strParentField, 0);
                    }
                    row += 1; //plus 1 for every field definition after first
                }
                lstParentsToUpdate.add(s);
            }
            
            //if parent records exist, perform update of all parent records
            //with a single DML statement
            if(lstParentsToUpdate.Size() > 0) 
            {
                Utility.updtSObject(lstParentsToUpdate);
            }
        }
        Catch(Exception ex){}
    }
}