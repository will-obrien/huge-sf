public with sharing class ContactController {
 
    @AuraEnabled
    public static List<Contact> findAll() {
        return [SELECT Id, Name from Contact limit 20];
    }
 
    @AuraEnabled
    public static List<Contact> findByName(String name) {
        String key = '%' + name + '%';
        return [SELECT Id, Name FROM Contact WHERE Name LIKE :key LIMIT 20];
    }
}