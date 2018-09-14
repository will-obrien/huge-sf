/*
 * Add Multiple Subscriptions Apex controller extension for corresponding Visualforce page
 *
 * SOQL query pulls up a list of all Contacts in the database. This allows the organization
 * to select and subscribe multiple Contacts to one course, creating the corresponding
 * Registration and Attendance records.
 *
 * Created by: Elizabeth Tian, 2016
 *
*/

public class Add_Multiple_Subscriptions_Contact {
    public ApexPages.StandardSetController controller;
    public List<cCurso> coursesInternal;
    public Id contactId = (Id) ApexPages.currentPage().getParameters().get('id');
    
    public Add_Multiple_Subscriptions_Contact(ApexPages.StandardSetController control) {
        this.controller = control;
    }
    
    public List<cCurso> getCoursesInternal() {
        if (coursesInternal == null) {
            coursesInternal = new List<cCurso>();
            for (Curso__c c: [SELECT Id, Name, Inscriptos__c, Limite_de_inscripciones__c,
                              Fecha_de_Inicio__c, Fecha_de_Finalizacion__c, D_as__c,
                              Frecuencia__c
                      	  	  FROM Curso__c]) { 
        	coursesInternal.add(new cCurso(c));
        	}
        }
        return coursesInternal;
    }
    
    public PageReference processSelected() {
    	List<Curso__c> selectedCourses = new List<Curso__c>();
    	for (cCurso c: coursesInternal) {
    		if (c.selected == true) {
    			selectedCourses.add(c.cur);
    		}
    	}
        List<Inscripcion__c> allIns = new List<Inscripcion__c>();
    	for (Curso__c course: selectedCourses) {
    		//create new inscription
    		Inscripcion__c ins = new Inscripcion__c(
                					 Asistente__c=contactId, 
                					 Curso__c=course.id,
                					 Fecha_de_Inscripcion__c=Date.today(),
                					 Estado__c='Activo'
            						);
            allIns.add(ins);
    	}
        insert allIns;
        coursesInternal = null;
        PageReference page = new PageReference('/' + contactId);
        page.setRedirect(true);
        return page;
    }

    public class cCurso {
    	public Curso__c cur {get; set;}
    	public Boolean selected {get; set;}
    	
    	public cCurso(Curso__c c) {
    		cur = c;
    		selected = false;
    	}
    }
}