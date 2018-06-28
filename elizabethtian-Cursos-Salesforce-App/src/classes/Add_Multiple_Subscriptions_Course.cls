/*
 * Add Multiple Subscriptions Apex controller extension for corresponding Visualforce page
 *
 * SOQL query pulls up a list of all Courses in the database. This allows the organization
 * to subscribe one Contact to multiple Courses that the organization selects
 * and create the corresponding Registration and Attendance records.
 *
 * Created by: Elizabeth Tian, 2016
 *
*/

public class Add_Multiple_Subscriptions_Course {
    public ApexPages.StandardSetController controller;
    public List<cContact> contactsInternal;
    public Id courseId = (Id) ApexPages.currentPage().getParameters().get('id');
    
    public Add_Multiple_Subscriptions_Course(ApexPages.StandardSetController control) {
        this.controller = control;
    }
    
    public List<cContact> getContactsInternal() {
        if (contactsInternal == null) {
            contactsInternal = new List<cContact>();
            for (Contact c: [SELECT Id, FirstName, LastName
                      	     FROM Contact]) {
        	contactsInternal.add(new cContact(c));
        	}
        }
        return contactsInternal;
    }
    
    public PageReference processSelected() {
    	List<Contact> selectedContacts = new List<Contact>();
    	for (cContact c: contactsInternal) {
    		if (c.selected == true) {
    			selectedContacts.add(c.con);
    		}
    	}
        List<Inscripcion__c> allIns = new List<Inscripcion__c>();
    	for (Contact contact: selectedContacts) {
    		//create new inscription
    		Inscripcion__c ins = new Inscripcion__c(
                					 Asistente__c=contact.id, 
                					 Curso__c=courseId,
                					 Fecha_de_Inscripcion__c=Date.today(),
                					 Estado__c='Activo'
            						);
            allIns.add(ins);
    	}
        insert allIns;
        contactsInternal = null;
        PageReference page = new PageReference('/' + courseId);
        page.setRedirect(true);
        return page;
    }

    public class cContact {
    	public Contact con {get; set;}
    	public Boolean selected {get; set;}
    	
    	public cContact(Contact c) {
    		con = c;
    		selected = false;
    	}
    }
}