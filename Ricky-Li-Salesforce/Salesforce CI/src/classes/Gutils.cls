//Place to store common methods
public class Gutils{
    //return if the current running environment is sandbox
    public static Boolean isSandbox() {
        return URL.getSalesforceBaseUrl().getHost().left(2).equalsignorecase('cs');
    }
    
    /*
      parameters: 
        1.Sobject Type case insensitive (eg: Account)
        2.DeveloperName: Record Type Name
      return: 
        RecordType Id (Type: Id)
    */
    public static Id getRecordTypeId(String sobjectType, String developerName) {
        List<RecordType> rt = [Select Id from RecordType Where SobjectType =: sobjectType and developerName =: developerName Limit 1];
        if(rt.isEmpty()){return null;}
        else{return rt.get(0).Id;}     
    }
}