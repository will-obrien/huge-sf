public class ContactsDML {
    public static void standaloneDML(){
        //----------------------------------------------------------
        //  Use standalone DML command to insert new Contacts.
        //----------------------------------------------------------
        
        // Declare a variable whose type is Contact named name1
        // and initialize it to a newly constructed Contact sObject 
        // assigning the field LastName the value 'Minkowitz'.
        Contact name1 = new Contact(LastName = 'Minkowitz');
        
        // Declare a variable whose type is Contact named name2
        // and initialize it to a newly constructed Contact sObject 
        // assigning the field LastName the value 'Singh'.
        Contact name2 = new Contact(LastName='Singh');
        
        // Declare a variable whose type is a List of Contact sObjects 
        // named contacts and initialize it to a newly constructed List.
        List<Contact> contacts = new List<Contact>();
        
        // Add name1 to the list contacts.
        contacts.add(name1);
        
        // Add name2 to the list contacts.
        contacts.add(name2);
        
        // Use the standalone insert command to insert contacts into the database. 
        insert contacts;
        
        // When you successfully insert an sObject instance, the ID of the 
        // inserted instance is returned to it.
        // Write a statement to output the ID of name1 into the debug log.
        System.debug('The Id of name1: ' + name1.Id);
        
        // Write a statement to output the ID of name2 into the debug log.
        System.debug('The Id of name2: ' + name2.Id);
    }
    
    
    public static void databaseMethodDML(){
        //-------------------------------------------------------------
        // Use a Database class method to insert Contacts.
        //-------------------------------------------------------------
        
        // Declare a variable whose type is Contact named name1.
        // It should not set any fields.
        Contact name1 = new Contact();
        
        // Declare a variable whose type is Contact named name2
        // and initialize it to a newly constructed Contact sObject 
        // assigning the field LastName the value 'Picasso'.
        Contact name2 = new Contact(LastName = 'Picasso');
        
        // Declare a variable whose type is a List of Contact sObjects 
        // named contacts and initialize it to a newly constructed List.
        List<Contact> contacts = new List<Contact>();
        
        // Add name1 and name2 to the list contacts.
        contacts.add(name1);
        contacts.add(name2);
        
        // Use the Database.insert command to replicate the
        // behaviour you would expect by issuing the command:
        // insert contacts;
        // Because name1 is incomplete, you should expect a DMLexception.
        Database.insert(contacts);
    }
	
   public static void databaseMethodDMLAllOrNone(){
        //-----------------------------------------------------------------------------
        // Use a Database class method to insert Contacts with a partial commit.
        //-----------------------------------------------------------------------------
        
        // Declare a variable whose type is Contact named name1.
        // It should not set any fields.
        Contact name1 = new Contact();
        
        // Declare a variable whose type is Contact named name2
        // and initialize it to a newly constructed Contact sObject 
        // assigning the field LastName the value 'Picasso'.
        Contact name2 = new Contact(LastName = 'Picasso');
        
        // Declare a variable whose type is a List of Contact sObjects 
        // named contacts and initialize it to a newly constructed List.
        List<Contact> contacts = new List<Contact>();
        
        // Add name1 and name2 to the list contacts.
        contacts.add(name1);
        contacts.add(name2);
        
        // Use the Database.insert command to insert the Contacts.
        // in contacts, with a partial commit.
        Database.insert(contacts, false);
        
        // Print the id of name2 to the debug log
        System.debug('The Id of name2: ' + name2.id);
    }


    public static void exceptionsDML(){
        List<Contact> contacts = new List<Contact>();
        
        Contact noName = new Contact();
        contacts.add(noName);
        
        Contact newContact = new Contact(LastName = 'Benett');
        contacts.add(newContact);
        
        Contact longName = new Contact(LastName = '00085chars00085chars00085chars00085chars00085chars00085chars00085chars00085chars00085');
        contacts.add(longName);
        
        // A new list based on the current list - to use later.
        List<Contact> newListContact = new List<Contact>(contacts);
        
        // TODO #1: Declare a variable whose type is a List of Database.SaveResult   
        //          sObjects named lsr and initialize it to the result of calling 
        //          the insert method of the Database class passing in as parameters
        //          the list contacts and the Boolean value false to indicate a partial commit.

        // TODO #2: Create a for loop with an iterator of type Database.SaveResult 
        //          named sr that iterates over the List lsr.

            // TODO #3: Within the for loop create an if statement that uses the 
            //          isSuccess method of the Database.SaveResult class to 
            //          determine if the insert of sr was unsuccessful.

                // TODO #4: Within the if statement create a for loop with an iterator
                //          of type Database.Error named err that iterates over the 
                //          result returned by calling the getErrors method of the 
                //          class Database.SaveResult on the variable sr.

                    // TODO #5: Create a System.debug statement that outputs the results 
                    //          of calling the getStatusCode method and the getMessage 
                    //          method of the Database.error class on the err variable.

        
        try{
            List<Database.SaveResult> lsr2 = Database.insert(newListContact, false);
        } catch(ListException e){
            System.debug('An error occurred. The error message is: ' + e.getMessage());
        }
        
    }
}