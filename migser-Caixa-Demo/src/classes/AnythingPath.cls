public class AnythingPath {

    //returns the object itself with the correct fields
    @AuraEnabled
    public static string getCurrentValue(string recordId, string picklistField, string sObjectName){
        string soql = 'select Id, ' + picklistField + ' from ' + SobjectName + ' where id = \'' + recordId + '\'';
        list<sobject> records = Database.query(soql);
        return (string)records[0].get(picklistField);
    }
    
    //updates the record
    @AuraEnabled
    public static void setNewValue(string recordId, string picklistField, string newValue){
        sobject o1 = id.valueOf(recordId).getSobjectType().newSobject(id.valueOf(recordId));
        o1.put(picklistField, newValue);
        update o1;       
    }

    //returns the picklist options as a list of (value, label)
    @AuraEnabled
    public static map<String, string> getPicklistOptions(string recordId, string picklistField, string sObjectName){
        map<string, string> output = new map<string, string>();
        
        Schema.sobjectType objType = Id.valueOf(recordId).getSobjectType();
        Schema.DescribeSObjectResult dsr  = objType.getDescribe();
        map<string, Schema.SObjectField> fieldMap = dsr.fields.getMap();
        Schema.DescribeFieldResult dfr = fieldmap.get(picklistField).getDescribe();
        list<Schema.PicklistEntry> results = dfr.getPicklistValues();
            
        for (Schema.PicklistEntry pe:results){
            if (pe.isActive()) output.put(pe.getValue(), pe.getLabel());
        }
        return output;
    }
}