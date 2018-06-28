public class newMyobUtil{

public static Map<String,String> getAllFieldsWithRecordType(String recordTypeId){

        // method returns a list of fields based on the Card object record type
        Map<Id,RecordType> r = new Map<Id,RecordType>([SELECT Id,Name from RecordType where SObjectType='Card__c']);
        List<Schema.FieldSetMember> lf = new List<Schema.FieldSetMember>();
        Map<String,String> resultAllFieldsWithRecordType = new Map<String,String>();
        
        lf.addall(SObjectType.Card__c.FieldSets.Personal.getFields());
        if (r.get(recordTypeId).Name=='Personal'){
        }
        else if (r.get(recordTypeId).Name=='Customer'){
         lf.addall(SObjectType.Card__c.FieldSets.Card.getFields());
         lf.addall(SObjectType.Card__c.FieldSets.Customer.getFields());
        } 
        else if (r.get(recordTypeId).Name=='Supplier') {
         lf.addall(SObjectType.Card__c.FieldSets.Card.getFields());
         lf.addall(SObjectType.Card__c.FieldSets.Supplier.getFields());
        }
        
        for(Schema.FieldSetMember f : lf) {
            resultAllFieldsWithRecordType.put(String.ValueOf(f.getFieldPath()),String.ValueOf(f.getType()));
        }
         
       return  resultAllFieldsWithRecordType;

}

}
