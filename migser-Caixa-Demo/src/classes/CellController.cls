public with sharing class CellController {
    private class sexception extends exception {}

    @AuraEnabled
    public static list<id> forceSave(string recordList){
        list<sobject> soList = convertJSONToListOfSObject(recordList);
        CellCrud.screate(soList);

        list<id> idList = new list<id>();
        for (sobject so : soList){
            idList.add(so.id);
        }
        
        return idList;
    }
    
    @AuraEnabled
    public static void forceUpdate(string recordList){
        list<sobject> soList = convertJSONToListOfSObject(recordList);
        CellCrud.supdate(soList);
    }
    
    private static List<SObject> convertJSONToListOfSObject(String json) {
        Object[] values = (Object[])System.JSON.deserializeUntyped(json);

        List<SObject> newSObjectsList = new List<SObject>();
        for (Object v : values) {
            Map<String, Object> m = (Map<String, Object>)v;

            if (m.get('sobjectType') == null){
                sexception e = new sexception();
                e.setMessage('Required Property "sobjectType" not found.');
                throw e;
            }

            Schema.SObjectType targetType = Schema.getGlobalDescribe().get((String)m.get('sobjectType'));

            if (targetType == null){
                sexception e = new sexception();
                e.setMessage('SObject "' + (String)m.get('sobjectType') + '" not found.');
                throw e;
            }

            SObject o = targetType.newSObject();

            Map<String, Schema.SObjectField> fields = targetType.getDescribe().fields.getMap();
            for (String fieldName : m.keySet()) {
                // Filter out any psuedo fields such as LastNameLocal
                Schema.SObjectField fi = fields.get(fieldName);
                if (fi != null) {
                    if (fieldName == 'Id' || (fi.getDescribe().isCreateable() && fi.getDescribe().isUpdateable())) {
                        if (string.valueOf(fi.getDescribe().getType()) == 'date'){
                            if (m.get(fieldName) != null){
                                o.put(fieldName, date.valueOf(string.valueOf(m.get(fieldName)))); 
                            }
                        } else {
                            o.put(fieldName, m.get(fieldName)); 
                        }
                    }
                }
            }

            newSObjectsList.add(o);
        }

        return newSObjectsList;
    }
    
    public class objField {
        public string name;
        public string relationshipName;
        public string label;
        public string type;
        public string parentObj;
        public boolean isNameField;
        public boolean isNillable;
        public boolean isAccessible;
        public boolean isCreateable;
        public boolean isUpdateable;
        public boolean isAutoNumber;
        public list<map<string, string>> picklistItems;
    }
    
    @AuraEnabled
    public static string forceGetFieldList(string objectName){
        if (objectName == null){
            sexception e = new sexception();
            e.setMessage('objectName is null.');
            throw e;
        }
        if (schema.getGlobalDescribe().get(objectName) == null){
            sexception e = new sexception();
            e.setMessage('SObject "' + objectName + '" not found.');
            throw e;
        }

        list<objField> oflds = new list<objField>();
        //set<string> exclude_fields = new set<string>{'id','createddate','ownerid','createdbyid','lastmodifieddate','isdeleted','systemmodstamp','lastmodifiedbyid','lastvieweddate','lastreferenceddate'};
        set<string> exclude_fields = new set<string>{};
        list<schema.describeFieldResult> frs = new list<schema.describeFieldResult>();
        map<string, schema.sObjectField> om = schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for (string k : om.keySet()){
            if (exclude_fields.contains(k)){
                continue;
            }
            frs.add(om.get(k).getDescribe());
        }
        for (schema.describeFieldResult r : frs){
            if (r == null){
                continue;
            }
            objField ofld = new objField();
            ofld.name = r.getName();
            ofld.relationshipName = r.getRelationshipName();
            ofld.label = r.getLabel();
            ofld.type = String.valueOf(r.getType());
            ofld.isNameField = r.isNameField();
            ofld.isNillable = r.isNillable();
            ofld.isAccessible = r.isAccessible();
            ofld.isCreateable = r.isCreateable();
            ofld.isUpdateable = r.isUpdateable();
            ofld.isAutoNumber = r.isAutoNumber();

            // If this field is picklist, we include its label, value pair.
            if (ofld.type == 'picklist' || ofld.type == 'multipicklist'){
                list<map<string, string>> picklist_items = new list<map<string, string>>();
                for (schema.picklistEntry ple : r.getPicklistValues()){
                    map<string, string> mm = new map<string, string>();
                    mm.put('label', ple.getLabel());
                    mm.put('value', ple.getValue());
                    mm.put('isActive', String.valueOf(ple.isActive()));
                    mm.put('isDefaultValue', String.valueOf(ple.isDefaultValue()));
                    picklist_items.add(mm);
                }
                ofld.picklistItems = picklist_items;
            }

            // If this field is reference, we include its parnet object name
            if (ofld.type == 'reference'){
                ofld.parentObj = r.getReferenceTo()[0].getDescribe().getName();
            }
            
            oflds.add(ofld);
        }
        return JSON.serialize(oflds);
    }

    @AuraEnabled
    public static string forceLoadData(string objectName, string fields){
        if (objectName == null){
            sexception e = new sexception();
            e.setMessage('objectName is null.');
            throw e;
        }
        if (Schema.getGlobalDescribe().get(objectName) == null){
            sexception e = new sexception();
            e.setMessage('SObject "' + objectName + '" not found.');
            throw e;
        }

        list<sobject> recordList;
        if (fields == null){
            // we will retrieve all records with ALL field.
            recordList = CellCrud.slist(objectName);
        } else {
            // we will retrieve all records with SPECIFIED fields.
            map<string, schema.sObjectField> fieldMap = schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            for (string field : fields.replace(' ', '').split(',',0)){
                if (fieldMap.get(field.trim()) == null){
                    sexception e = new sexception();
                    e.setMessage('Field "' + field.trim() + '" not found in SObject "' + objectName + '".');
                    throw e;
                }
            }
            string escapedFields = String.escapeSingleQuotes(fields.replace(' ', ''));
            string escapedObject = String.escapeSingleQuotes(objectName);
            string soql = 'select ' + escapedFields + ' from ' + objectName + ' order by CreatedDate desc, Name';
            recordList = CellCrud.squery(soql);
        }
        
        return JSON.serialize(recordList);
    }
    
    @AuraEnabled
    public static string forceQuery(string soql){
        //string escapedSoql = String.escapeSingleQuotes(soql);
        list<sobject> recordList = CellCrud.squery(soql);
        return JSON.serialize(recordList);
    }

    @AuraEnabled
    public static void forceDelete(string objectName, string recordIds){
        if (objectName == null){
            sexception e = new sexception();
            e.setMessage('objectName is null.');
            throw e;
        }
        if (Schema.getGlobalDescribe().get(objectName) == null){
            sexception e = new sexception();
            e.setMessage('SObject "' + objectName + '" not found.');
            throw e;
        }
        if (recordIds == null){
            sexception e = new sexception();
            e.setMessage('recordIds is null.');
            throw e;
        }
        list<id> recordIdList = (list<id>)System.JSON.deserialize(recordIds, list<id>.class);
        string soql = 'select id from ' + String.escapeSingleQuotes(objectName) + ' where id in :recordIdList';
        list<sobject> soList = Database.query(soql);
        CellCrud.sdelete(soList);
    }
}