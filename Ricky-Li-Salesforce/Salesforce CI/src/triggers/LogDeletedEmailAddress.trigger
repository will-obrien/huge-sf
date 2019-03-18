trigger LogDeletedEmailAddress on Email_Address__c (after delete) {
    List <DeletedEmailAddress__c> delObjsToInsert = new DeletedEmailAddress__c[]{};
    for (Email_Address__c ea:Trigger.old){
        DeletedEmailAddress__c de = new DeletedEmailAddress__c();
        de.Name = ea.Name;
        de.Email_Address__c = ea.Email_Address__c;
        de.Email_Address_Type__c = ea.Email_Address_Type__c;
        de.EmailAddress_Id__c = ea.Id;
        de.Contact__c = ea.Contact__c;
        de.CheckPersonAccnt__c = ea.CheckPersonAccnt__c;
        de.Account__c = ea.Account__c;
        delObjsToInsert.add(de);
    }
    insert delObjsToInsert;
}