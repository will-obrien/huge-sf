/* 
 * Apex controller extension for Signup that allows for website integration through
 * Force.com site hosting and an iframe. A user is directed to this page after clicking on
 * a course on the Calendar_Website page. When a user signs up, a SOQL query is made to check
 * if the attendant email already exists in the Salesforce database - if it does not, the
 * page creates a new Contact and subscribes them to the course (with a new Inscripcion record
 * and the automatically created Asistencia records). An automatic confirmation email is also
 * sent to the user after subscribing.c
 * 
 * Created by: Elizabeth Tian, 2016
 *
 */

public class Signup {
    public ApexPages.StandardController controller;
    public Inscripcion__c newInscrip {get; set;}
    public Contact contact {get; set;}
    public Id courseId = (Id) ApexPages.currentPage().getParameters().get('id');
    public List<Curso__c> cur;
    public Boolean newContact {get; set;}
    public Boolean oldContact {get; set;}
    
    public Signup(ApexPages.StandardController control) {
        this.controller = control;
        newContact = false;
        oldContact = false;
        newInscrip = new Inscripcion__c();
        contact = new Contact();
        cur = [SELECT Id, Name, D_as__c, Fecha_de_Inicio__c, Fecha_de_Finalizacion__c, Frecuencia__c, Importe__c, Moneda_Importe__c
        	   FROM Curso__c WHERE Id=:courseId LIMIT 1];
    }
    
    public void showNewContact() {
        if (oldContact == true) oldContact = false;
        newContact = true;
    }
    
    public void showOld() {
        if (newContact == true) newContact = false;
        oldContact = true;
    }
    
    public PageReference calendar() {
        PageReference cal = new PageReference(Site.getBaseUrl() + '/' + 'Calendar_Website');
        return cal;
    }
    
    public PageReference inscrib() {
        try {
        	// mail
			Messaging.reserveSingleEmailCapacity(1);
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setSubject('¡Su solicitud de inscripción a ' + cur[0].Name + ' ha sido completada!');
			String[] toAddresses = new List<String>();
			String greeting = 'Hola!';
			String importe;
			if (cur[0].Importe__c != null) { importe = ' El importe total del mismo es ' + cur[0].Importe__c + ' ' + cur[0].Moneda_Importe__c + '.'; }
			else { importe = ''; }
			String info = '<br><br>¡Muchas gracias por inscribirte al curso de ' + cur[0].Name
            					   + '!' + importe + '<br><br> A continuación te detallamos toda la información del mismo:<br>'
            					   + '<br><ul><li>Nombre: '+ cur[0].Name 
            					   + '</li><li>Fecha de Inicio: ' + cur[0].Fecha_de_Inicio__c
            					   + '</li><li>Fecha de Finalizacion: ' + cur[0].Fecha_de_Finalizacion__c 
            					   + '</li><li>Dias: ' + cur[0].D_as__c
            					   + '</li><li>Frecuencia: ' + cur[0].Frecuencia__c + '</li></ul>';
			
			// old contact
            if (oldContact == true) {
            	List<Contact> c = [SELECT Id, FirstName, Email FROM Contact WHERE Email=:contact.Email LIMIT 1];
            	if (c.size() == 0) {
					ApexPages.addMessage(new ApexPages.Message(
            			ApexPages.severity.WARNING, 'Asistente no existe! Por favor hacer click en "Asistente Nuevo".'));
            	} else { 
            		// mail
            		greeting = 'Hola ' + c[0].FirstName + ',';
            		String body = greeting + info;
            		toAddresses.add(c[0].Email);
					mail.setToAddresses(toAddresses);
					mail.setHtmlBody(body);
					
					// create inscripcion
	            	newInscrip.Asistente__c=c[0].Id;
	                newInscrip.Curso__c=courseId;
	                newInscrip.Estado__c='Activo';
	                newInscrip.Fecha_de_Inscripcion__c=Date.today();
	                insert newInscrip;
            		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Exito!'));
            		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            	}
            }
            // new contact
            else if (newContact == true) {
            	List<Contact> ct = [SELECT Id, FirstName, Email FROM Contact WHERE Email=:contact.Email LIMIT 1];
            	if (ct.size() == 0) {
            		insert contact;
                	newInscrip.Asistente__c=contact.id;
                	greeting = 'Hola ' + contact.FirstName + ',';
					toAddresses.add(contact.Email);
					mail.setToAddresses(toAddresses);
            	} else {
                	newInscrip.Asistente__c=ct[0].id;
                	greeting = 'Hola ' + ct[0].FirstName + ',';     
          			toAddresses.add(ct[0].Email);
					mail.setToAddresses(toAddresses);	           	
            	}
            	String body = greeting + info;
				mail.setHtmlBody(body);
                newInscrip.Curso__c=courseId;
                newInscrip.Estado__c='Activo';
                newInscrip.Fecha_de_Inscripcion__c=Date.today();
                insert newInscrip;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Exito!'));
            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        catch(DmlException e) {
            
        }
        return null;
    }
}