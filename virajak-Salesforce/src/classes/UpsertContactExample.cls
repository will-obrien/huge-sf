public class UpsertContactExample {
    public static void myUpsert(){
        Contact viraj = new Contact(FirstName='Viraj',LastName='Kalbhor',Department='Finance');      
        insert viraj;
        viraj.Description = 'Hmm..Good';
        
        Contact bappa = new Contact(FirstName='Ganesh', LastName='Bappa',Department='Technology');
        List<Contact> contacts = new List<Contact>();
        contacts.add(viraj);
        contacts.add(bappa);
        upsert contacts;

    }

}