public with sharing class CustomComponentApexController2 {
    
    @AuraEnabled
	public static String getContactName1(String id){ 
        List<Contact> contacts1=new List<Contact>();
        contacts1=[SELECT Name from Contact WHERE Id=:id Limit 1];
        return contacts1[0].Name;
    }
}