/* 
 * Apex test class that tests the Signup Apex controller extension
 * 
 * Signup controller extension for the Signup page allows for website integration through
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

@isTest
public class TestSignup {

    @isTest static void testExtension() {
    	Date start1 = Date.newInstance(2016, 1, 1);
        Date end1 = Date.newInstance(2016, 1, 15);
        List<Curso__c> courses = new List<Curso__c>();
    	Curso__c bento = new Curso__c(Name='Bento',
    								  Fecha_de_Inicio__c=start1,
    								  Fecha_de_Finalizacion__c=end1,
    								  D_as__c='Viernes',
    								  Frecuencia__c='Semanalmente'
    								  );        
        courses.add(bento);
        insert courses;
        Contact c = new Contact(LastName='Hello', Email='tiger@yahoo.com');
        insert c;
		ApexPages.StandardController sc = new ApexPages.standardController(bento);
    	Signup e = new Signup(sc);
        Test.startTest();
        e.cur = courses;
        e.contact = c;
        e.showNewContact();
        e.inscrib();
        e.showOld();
        e.inscrib();
        e.calendar();
		Test.stopTest();
    }
}