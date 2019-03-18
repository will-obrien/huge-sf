global with sharing class CellCrud {
    private class sexception extends exception {}

    global static void screate(sobject o){
        screate(new list<sobject>{o});
    }

    global static void screate(list<sobject> os){
        if (os == null || os.size() == 0){
            return;
        }
        
        // Get Describe Result of the SObject
        Schema.SObjectType targetType = os[0].getSObjectType();
        if (targetType == null) {
            sexception e = new sexception();
            e.setMessage('Object not found.');
            throw e;
        }

        Schema.DescribeSObjectResult sobjResult = targetType.getDescribe();
        
        // !! Attention to Governor Limit: Up to 100 call
        // Get map of all fileds exist in the SObject
        map<string, schema.sObjectField> m = sobjResult.fields.getMap();
        
        // Initiate set to manage fields to create
        set<schema.describeFieldResult> descFields_to_create = new set<schema.describeFieldResult>();
        
        // Loop all fields exist in the object
        for (String key : m.keySet()) {
            schema.describeFieldResult descField = m.get(key).getDescribe();
            
            // Loop every records to create and collect the fields to create
            for (sobject o : os){
                try {
                    if (o.get(descField.getName()) != null){
                        descFields_to_create.add(descField);
                        break;
                    } 
                } catch (SObjectException e){
                    // The object does not contain this field so go to scan next field.
                    continue;
                }
            }
        }
            
        // Check FLS on each field to create
        for (schema.Describefieldresult descField : descFields_to_create){
            if (!descField.isCreateable()){
                sexception e = new sexception();
                e.setMessage('Field: ' + descField.getName() + ' is not createable.');
                throw e;
            }
        }
        
        insert os;
    }

    global static void supdate(sobject o){
        supdate(new list<sobject>{o}, false);
    }
    
    global static void supdate(list<sobject> os){
        supdate(os, false);
    }
    
    global static void supdate(sobject o, boolean strict){
        supdate(new list<sobject>{o}, strict);
    }
    
    global static void supdate(list<sobject> os, boolean strict){
        if (os == null || os.size() == 0){
            return;
        }
        
        Schema.SObjectType targetType = os[0].getSObjectType();
        if (targetType == null) {
            sexception e = new sexception();
            e.setMessage('Object not found.');
            throw e;
        }
        
        Schema.DescribeSObjectResult sobjResult = targetType.getDescribe();
        
        // !! Attention to Governor Limit: Up to 100 call
        map<string, schema.sObjectField> m = sobjResult.fields.getMap();
        
        // Loop all fields exist in the object
        list<sobject> os4u = new list<sobject>();
        for (sobject o : os){
            sobject o4u = targetType.newSObject(o.id);
            boolean update_required = false;

            string object_json = JSON.serialize(o);
            map<string, object> object_map = (map<string, object>)JSON.deserializeUntyped(object_json);

            // Add field if it is updateable.
            for (String key : m.keySet()) {
                schema.describeFieldResult descField = m.get(key).getDescribe();

                // Check if the object has this field
                if (object_map.containsKey(descField.getname())){
                    if (strict == true && !descField.isUpdateable()){
                        sexception e = new sexception();
                        e.setMessage('Field: ' + descField.getName() + ' is not updateable.');
                        throw e;
                    }
                    if (descField.isUpdateable()){
                        o4u.put(descField.getName(), o.get(descField.getName()));
                        update_required = true;
                    }
                }
            }
            
            // Add record to update list if there is at least 1 field to udpate.
            if (update_required){
                os4u.add(o4u);
            }
        }

        update os4u;
    }

    global static void sdelete(sobject o){
        sdelete(new list<sObject>{o});
    }
    
    global static void sdelete(list<sobject> os){
        if (os == null || os.size() == 0){
            return;
        }

        if (!os[0].getSObjectType().getDescribe().isDeletable()){
            sexception e = new sexception();
            e.setMessage('Object: ' + os[0].getSObjectType().getDescribe().getName() + ' is not deletable.');
            throw e;
        }
        delete os;
    }

    global static list<sObject> squery(string soql){
        List<sObject> records;
        try {
            records = Database.query(soql);
        } catch (QueryException qe) {
            system.debug('Error ocurred on executing SOQL: ' + soql);
            throw qe;
        }

        if (records.size() > 0){

            Schema.SObjectType targetType = records[0].getSObjectType();
            if (targetType == null) {
                sexception e = new sexception();
                e.setMessage('Object not found.');
                throw e;
            }
            
            Schema.DescribeSObjectResult sobjResult = targetType.getDescribe();
            
            // !! Attention to Governor Limit: Up to 100 call
            map<string, schema.sObjectField> m = sobjResult.fields.getMap();

            string object_json = JSON.serialize(records[0]);
            map<string, object> object_map = (map<string, object>)JSON.deserializeUntyped(object_json);

            set<string> forbiddenFields = new set<string>();
            for (String key : m.keySet()) {
                schema.describeFieldResult descField = m.get(key).getDescribe();
                // Check if the object has this field
                if (object_map.containsKey(descField.getname())){
                    if (!descField.isAccessible()){
                        // Add field to forbidden set if it is not accessible.
                        forbiddenFields.add(descField.getname());
                    }
                }
            }

            // Delete field value which is not allowed to access
            if (forbiddenFields.size() > 0){
                for (sObject record : records){
                    for (string forbiddenField : forbiddenFields){
                        record.put(forbiddenField, null);
                    }
                }
            }
        }

        return records;
    }

    global static list<sObject> slist(string objName){
        string field_to_read = '';
        
        Schema.SObjectType targetType = schema.getGlobalDescribe().get(objName);
        if (targetType == null) {
            sexception e = new sexception();
            e.setMessage('Object not found.');
            throw e;
        }
        
        Schema.DescribeSObjectResult sobjResult = targetType.getDescribe();
        
        // !! Attention to Governor Limit: Up to 100 call
        map<string, schema.sObjectField> m = sobjResult.fields.getMap();
        
        for (String key : m.keySet()) {     
            if (!m.get(key).getDescribe().isAccessible()){
                continue;
            }
            schema.describeFieldResult descField = m.get(key).getDescribe();
            field_to_read += descField.getName() + ',';
        }
        
        if (field_to_read == ''){
            sexception e = new sexception();
            e.setMessage('No field can be retrieved.');
            throw e;
        }
        field_to_read = field_to_read.removeEnd(',');
        
        string soql = 'select ' + field_to_read + ' from ' + objName + ' order by CreatedDate desc';
        list<sObject> records;
        try {
            records = Database.query(soql);
        } catch (QueryException e){
            system.debug('Error ocurred on executing SOQL: ' + soql);
            throw e;
        }

        if (records.size() == 0){
            return null;
        }
        return records;
    }
}