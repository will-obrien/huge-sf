/** 
 * This trigger will encrypt the Contacts unencrypted password when the 
 * Contact is Updated or when a new Contact is inserted
 */
trigger contactSitecorePasswordTrigger on Contact (before insert, before update) {

    private Map<Id, String> oldPasswords = new Map<Id, String>();
    
    String password = null;
    String oldPassword = null;
    for(Contact contact: trigger.new) {
        // Get the new Password
        password = contact.SitecorePassword__c;
        // Get the old Password
        oldPassword = null;
        if(trigger.isUpdate) {
        	Contact oldContact = trigger.oldMap.get(contact.Id);
        	oldPassword = oldContact.SitecorePassword__c;
        }
        
        //System.debug('Unencrypted pw: '+ password);
    
        // Check to see if the password is different i.e. it has been modified or it is a new Contact with a password
        if(password != null && oldPassword != password) {
            //System.debug('oldPassword != password');
            
            String algorithmName = 'SHA1';
            Blob digest = Crypto.generateDigest(algorithmName,  Blob.valueOf(password));
            //System.debug('Encryption : '+ digest.toString());
            
            String hash = EncodingUtil.base64Encode(digest);
            
            // Replace unencrypted password with encrypted one
            contact.SitecorePassword__c = hash;
            contact.SitecorePasswordEncrypted__c = true;
        }
    }
}