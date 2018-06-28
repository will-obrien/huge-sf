public class AssignAddUpUserType {
    
    public static void setUserType(List<Id> cts) {
        
        Id entityTypeId = Schema.SObjectType.Club_Entity__c.getRecordTypeInfosByName().get('Club Entity').getRecordTypeId();
        List<Contact> ctsToUpdate = new List<Contact>();
        
        List<Leadership__c> ldrships = new List<Leadership__c>([SELECT Id, Contact__c, Position_Active__c, Position_Status__c FROM Leadership__c WHERE Contact__c IN :cts AND Club_Entity__r.RecordTypeId = :entityTypeId]);
        
        set<Id> activeLdrs = new set<Id>();
        for (Leadership__c l : ldrships) {
            if (l.Position_Active__c == true || l.Position_Status__c == 'Active') {
                activeLdrs.add(l.Contact__c);
            }
        }
        
        if (activeLdrs.size() > 0) {
            List<Contact> AddUpUsers = new List<Contact>([SELECT Id, AddUP_User_Type__c FROM Contact WHERE Id IN :activeLdrs]);
            for (Contact c : AddUpUsers) {
                if (c.AddUP_User_Type__c == null) {
                    c.AddUP_User_Type__c = '4 - Local Entity Campaign Creator';
                    ctsToUpdate.add(c);
                }
            }
        }
      
        set<Id> inactiveLdrs = new set<Id>();
        for (Id c : cts) {
            if (!activeLdrs.contains(c)) {
                inactiveLdrs.add(c);
            }
        }
        
        if (inactiveLdrs.size() > 0) {
            List<Contact> notAddUpUsers = new List<Contact>([SELECT Id, AddUP_User_Type__c FROM Contact WHERE Id IN :inactiveLdrs]);
            for (Contact c : notAddUpUsers) {
                if (c.AddUP_User_Type__c == '4 - Local Entity Campaign Creator') {
                    c.AddUP_User_Type__c = null;
                    ctsToUpdate.add(c);
                }
            }
        }
        
        if (ctsToUpdate.size() > 0) {
            update ctsToUpdate;
        }
     
    }

}