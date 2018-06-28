public class ObjectDescribe{

    public static string get_ObjectInfo(string ObjectName){
    
         Map<string,string> resultObject = new Map<String,String>();
         Schema.SobjectType oType = Schema.getGlobalDescribe().get(ObjectName);
         Sobject object_instance = oType.newSObject();
         for(Schema.SObjectField f :  object_instance.getSObjectType().getDescribe().fields.getMap().Values()){
                if(f.getDescribe().updateable){
                    resultObject.put(String.valueOf(f.getDescribe().getName()), String.valueOf(f.getDescribe().getLabel()));
                }
          }
          String JSONString = JSON.serialize(resultObject);
       return JSONString;
    }
}