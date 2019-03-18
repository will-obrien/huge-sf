public class PDEPictureCtrl {

    //returns the object itself with the correct fields
    @AuraEnabled
    public static string getPictureId(string recordId, string pictureField, string sObjectName){
        string soql = 'select Id, ' + pictureField + ' from ' + SobjectName + ' where id = \'' + recordId + '\'';
        list<sobject> records = Database.query(soql);
        return (string)records[0].get(pictureField);
    }
    
}