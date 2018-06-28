public class RecordTypeHelper {

    
    //========================================================================
    // VARIABLE DECLARATION SECTION
    //========================================================================      
    private static Map<string, RecordType> Rt_map = new Map<string, RecordType>();
    
    //========================================================================      
    //Method retrieves all the record types.
    //========================================================================      
    static void FillRTMap(){
        RecordType[] recordTypes = [select Id, sobjectType, Name from RecordType];
        for (Integer i=0; i<recordTypes.size(); i++){
            Rt_map.put(recordTypes[i].Id, recordTypes[i]);
            Rt_map.put(recordTypes[i].sobjectType+'|'+recordTypes[i].Name, recordTypes[i]);
        }
    }
    
    //========================================================================  
    //Method for getting RecordTypeId
    //========================================================================   
    public static Id GetRecordTypeId(String sobjectType, String name){
        if (Rt_map.size() == 0){
            FillRTMap();
        }
        RecordType rt = Rt_map.get(sobjectType+'|'+name);
        if (rt != null){
            return rt.id;
        }
        else{
            return null;
        }
    }
    
    //========================================================================  
    //Method for getting RecordType
    //========================================================================  
    public static RecordType GetRecordType(String sobjectType, String name){
        if (Rt_map.size() == 0){
            FillRTMap();
        }
        return Rt_map.get(sobjectType+'|'+name);
    }
    
    //========================================================================  
    //Metrhod for getting RecordType Name
    //========================================================================  
    public static String GetRecordTypeName(Id recordTypeId){
        if (Rt_map.size() == 0){
            FillRTMap();
        }
        return Rt_map.get(recordTypeId).Name;
    }   
}