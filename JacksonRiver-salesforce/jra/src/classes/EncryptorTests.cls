/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class EncryptorTests {
  static testMethod void TestMissingAESKeyObject() {
    // delete any aes key objects
    User usr = [Select id from User where Id = :UserInfo.getUserId()];
    System.runAs(usr) {
      Test.startTest();
      deleteSettings();
      Test.stopTest();
    }
    
    Contact c = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe2@company.com');
    insert(c);
    
    // Make sure the encrypted query string field is now populated
    Contact c1 = [SELECT Query_String_Encrypted__c FROM Contact WHERE Id = :c.Id];
    System.assertEquals('Unable to encrypt string because an AES Key custom setting named Default does not exist.', c1.Query_String_Encrypted__c);
  }
  
    static testMethod void TestEncryption() {
      // Create a new AESKeys__c object
      AESKeys__c aes = AESKeys__c.getInstance('Default');
    if (aes == null) {
        AESKeys__c key = new AESKeys__c(Name = 'Default', Key__c = '12345678901234561234567890123456', IV__c = '1234567890123456');
      insert(key);
    }
    
    //Contact c = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@company.com', Default_Gift_Amount = '10');
    //insert(c);
    
    // Assert the encrypted query string field is now populated
    //Contact c1 = [SELECT Query_String_Encrypted__c FROM Contact WHERE Id = :c.Id];
    //System.assertNotEquals('Unable to encrypt string because an AES Key custom setting named Default does not exist.', c1.Query_String_Encrypted__c);
    }
    
    
    @future
  private static void deleteSettings()
  {
       AESKeys__c[] keys = [select id, name from AESKeys__c];
    delete keys;
    
  }
}