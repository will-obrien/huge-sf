public class AddPrimaryContact implements Queueable {

private Contact contact;
private String state;

/*
Create a constructor for the class that accepts as its first argument a Contact sObject and a second argument as a string for the State abbreviation.
*/
public AddPrimaryContact(Contact cont, String cd){
    this.contact = cont;
    this.state = cd;
}

/*
The execute method must query for a maximum of 200 Accounts with the BillingState specified by the State abbreviation passed into the 
constructor and insert the Contact sObject record associated to each Account. Look at the sObject clone() method.
*/
public void execute (QueueableContext context) {
    List<Account> listAccount = [SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts) FROM Account 
                                WHERE BillingState = :state LIMIT 200];

    List<Contact> listContact = new List<Contact>();
        for (Account acc:listAccount)
        {
            Contact cont = contact.clone(false, false, false, false);
            cont.AccountId = acc.Id;
            listContact.add(cont);
        }                       

        if (listContact.size() > 0 ){
            insert listContact;
        }       
    }
}