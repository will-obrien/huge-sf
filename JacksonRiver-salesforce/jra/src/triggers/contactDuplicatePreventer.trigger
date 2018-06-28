trigger contactDuplicatePreventer on Contact (before insert, before update) {
	// we only want to run this trigger once for inserts and updates
	if (!OneTimeTriggerValidator.isAlreadyDone()){
		/*   
       	* begin by building a map which stores the (unique) list of contacts
       	* being inserted/updated, using email address as the key. 
       	*/   
      	Map<String, Contact> contactMap = new Map<String, Contact>();
		for (Contact contact : System.Trigger.new) {             
            if (contact.Email != null) { // skip null emails
               /* for inserts OR  
                * updates where the email address is changing 
                * check to see if the email is a duplicate of another in 
                * this batch, if unique, add this lead to the contactMap
                */
               if  (System.Trigger.isInsert || 
                   	(System.Trigger.isUpdate && 
                    	contact.Email != System.Trigger.oldMap.get(contact.Id).Email)) {
                          if (contactMap.containsKey(contact.Email)) {
                                contact.Email.addError('Another new contact has the same email address.');
                          } else {
                                contactMap.put(contact.Email, contact);
                          }
               }
            }
		}
      
      	/* Using the lead map, make a single database query, 
       	* find all the leads in the database that have the same email address as 
       	* any of the leads being inserted/updated.
       	*/ 
      	for (Contact contact : [select Email from Contact where Email IN :contactMap.KeySet()]) {
        	Contact newContact = contactMap.get(contact.Email);
            newContact.Email.addError('A contact with this email address already exists.');
      	}
    // set the one time trigger validator to done
    OneTimeTriggerValidator.setAlreadyDone();
	}
}