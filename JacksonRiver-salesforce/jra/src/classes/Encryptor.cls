public with sharing class Encryptor {
  public string Encrypt(string str) {
    if (str == '' || str == null) {
      return '';
    }
    // try and get the default aes key
    AESKeys__c aes = AESKeys__c.getInstance('Default');
    if (aes == null) {
      return 'Unable to encrypt string because an AES Key custom setting named Default does not exist.';  
    }
      
    // Convert key and iv to blobs
    Blob key = Blob.valueOf(aes.Key__c);
        Blob iv = Blob.valueOf(aes.IV__c);
        
        // Convert data to a blob
        Blob data = Blob.valueOf(str);
        
        // Encrypt
        Blob encryptedData = Crypto.encrypt('AES256', key, iv, data); 
        
        return Encodingutil.urlEncode(Encodingutil.base64Encode(encryptedData), 'utf-8');
  }
}