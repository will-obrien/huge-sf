trigger EncryptQueryString on Contact (before update) {
    Contact[] contacts = Trigger.new;
    Encryptor crypt = new Encryptor();
  // loop over all the contacts in the update and encrypt their query strings    
    for (Contact c: contacts) {
        c.Query_String_Encrypted__c = crypt.Encrypt(c.Query_String__c);
        c.Gift_String_Encrypted__c = crypt.Encrypt('amounts=' + c.Gift_String__c + '&default=' + c.Default_Gift_Amount__c);
    }   
}