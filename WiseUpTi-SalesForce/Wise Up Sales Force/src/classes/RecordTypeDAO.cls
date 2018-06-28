public class RecordTypeDAO {

    public static map<Id, RecordType> mapRecordTypesBySobjectType(String SobjectType){
        return new map<Id, RecordType>([SELECT Id, Name FROM Recordtype WHERE SobjectType =: SobjectType]);
    }
    
    public static map<String, RecordType> mapByNameRecordTypeBySobjectType(String SobjectType){
        map<String, RecordType> mapRec = new map<String, RecordType>();
        
        for(Recordtype r : [SELECT Id, Name FROM Recordtype WHERE SobjectType =: SobjectType]){
            mapRec.put(r.Name, r);
        }
        
        return mapRec;
    }

}