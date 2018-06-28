public class objectinfo {


// Find the fields for the selected object

public static Map<String,Schema.DisplayType> showFields(String selectedObject) {

Map <String,Schema.DisplayType> customfields = new Map <String,Schema.DisplayType>();
// Map of all SObjects in the running SF Org
Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
if (schemaMap.get(selectedObject)== null)
//  system.debug('Non existent object');
    return customfields;
else
{
// Map of field names
Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
//List <String> customfields = new List <String>();
for(Schema.SObjectField sfield : fieldMap.Values())
{
schema.describefieldresult dfield = sfield.getDescribe();
if (dfield.isCustom () ) {
//  save custom field name without the __c suffix
    system.debug(dfield.getType());
    customfields.put(dfield.getname().left(dfield.getname().length()-3),dfield.getType());
    }
}
//for (String fieldname  : customfields) 
//   { system.debug(fieldname); }
return customfields;
}
}


}
