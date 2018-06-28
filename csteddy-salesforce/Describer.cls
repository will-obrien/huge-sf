public class Describer
{
public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
public List<Pair> lstfieldname{get;set;}
public List <Pair> fields {get{return lstfieldname;} set{lstfieldname =value;}}
public List <SelectOption> objectNames{public get; private set;}
public String selectedObject {get; set;}

// Intialize objectNames and fields

public Describer() {
objectNames = initObjNames();
fields = new List<Pair>();
}
// Populate SelectOption list -

// find all sObjects available in the organization

private List<SelectOption> initObjNames() {
List<SelectOption> objNames = new List<SelectOption>();
List<String> entities = new List<String>(schemaMap.keySet());
entities.sort();
for(String name : entities)
objNames.add(new SelectOption(name,name));
return objNames;
}

// Find the fields for the selected object

public void showFields() {
//fields.clear();
system.debug('$$$$$' + selectedObject);
Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
for(Schema.SObjectField sfield : fieldMap.Values())
{
schema.describefieldresult dfield = sfield.getDescribe();
system.debug('#######' + dfield );
Pair field = new Pair();
field.key = dfield.getname();
system.debug('#######4444' + field.key);
field.val = dfield.getType () + ' : ' + dfield.getLabel ();
lstfieldname.add(field);
}
}

public class Pair
{
public String key {get; set;}
public String val {get; set;}
}
}
