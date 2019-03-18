public with sharing class CustomWorkbench {

    public List<sObject> recordlist { get; set; }
    public String query1 { get; set; }
    public List<String> fieldNameToString { get; set; }
    public List<SelectOption> fieldNames{get; set;}
    public String CorrespondingFields{ get; set; }
    public String AllObjectsList { get; set; }
    
    public class innerWrapperClass{
        List<String> SelectedFieldsName { get; set; }
    }
       
    public PageReference DisplayRecords() {
        if(CorrespondingFields != null){
            integer length = CorrespondingFields.length();
            CorrespondingFields= CorrespondingFields.substring(1,length-1);
            String[] separate = CorrespondingFields.split(',\\s*');
            query1 = 'Select ' + CorrespondingFields + ' from ' + AllObjectsList;
            try{
                recordlist = Database.query(query1);
            }
            catch(Exception es){
                ApexPages.addMessages(es);
            }
            System.debug('recordlist ' + recordlist );
            System.debug('query1 '+query1 );
        }
        return null;
    }
    
    public void getAllFields() {
        System.debug('all AllObjectsList' + AllObjectsList);
        fieldNameToString = new List<String>();
        fieldNames = new List<SelectOption>();
        if(AllObjectsList != null){
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectSchema = schemaMap.get(AllObjectsList);
            Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
            
            for(String fieldName: fieldMap.keySet()) {  
                fieldNames.add(new SelectOption(fieldName,fieldName));
                fieldNameToString.add(fieldName);
                //fieldNameToString = (List<String>)fieldNames;
            }
        }
        System.debug('all fields' + fieldNames);
        System.debug('fieldNameToString' + fieldNameToString);
    }

    public List<SelectOption> getAllObjects() {
        List<Schema.sObjectType> gd = Schema.getGlobalDescribe().Values();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--------Select--------'));
        for(Schema.sObjectType gd1 : gd){
            options.add(new SelectOption(gd1.getDescribe().getName(),gd1.getDescribe().getName()));
        }
        options.sort();
        return options;
    }

    /*public List<sObject> getDisplayRecords() {
        if(CorrespondingFields != null){
            integer length = CorrespondingFields.length();
            CorrespondingFields= CorrespondingFields.substring(1,length-1);
            String[] separate = CorrespondingFields.split(',\\s*');
            System.debug('separate :' + separate[0] );
            query1 = 'Select ' + CorrespondingFields + ' from ' + AllObjectsList;
            recordlist = Database.query(query1);
            System.debug('recordlist ' + recordlist );
            System.debug('query1 '+query1 );
        }
        return recordlist ;
    }*/
}