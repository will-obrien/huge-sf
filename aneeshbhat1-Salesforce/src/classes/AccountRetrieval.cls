global class AccountRetrieval{
webService static String getAccount(String name) {
    List<Contact> contacts = new List<Contact>();
   for (Contact contactParam : Database.query('Select Id, Name, phone from Contact where Name like \'' + name + '%\'')){
       contacts.add(contactParam);
       }
       
       
       
       String JSONString = JSON.serialize(contacts);
       return JSONString;
   }
  }