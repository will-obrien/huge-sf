/*
    Name       : ContactsOnMap
    Date       : 3-April-2016
    Author     : Kuhinoor Alam
    Description: This Class is used to show Contacts on google Map.    
*/
public class ContactsOnMap{
public list<Contact> conlist{get;set;}
    public ContactsOnMap(){
        conlist =[SELECT Id, MailingCity, LastName FROM Contact where  MailingCity <> null LIMIT 10];
    }
}