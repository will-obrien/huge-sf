public class Secondary_Header {
	    @AuraEnabled
    	public static string getValores(string recordId, string sObjectName, string field1){
            system.debug('Sacando datos del objeto: '+field1);
            if ((field1 != null)&&(field1!='')) {
        string soql = 'select Id, ' + field1 + ' from ' + SobjectName + ' where id = \'' + recordId + '\'';
                system.debug(soql);
            try {
            list<sobject> records = Database.query(soql);
                return (String) records[0].get(field1);
            }
            catch (Exception e) {
                system.debug('Excepción: '+e);
                return null;
            }
            } else {
                system.debug('Sin parámetro!!');
                return null;
            }
          
    }
}