/*
 * Apex test class for the Calendar Apex controller
 * 
 * Calendar controller for the Cursos Calendar displays the Calendar in a Salesforce tab.
 * If a course is clicked on the calendar, page is redirected to the Course record in Salesforce.
 *
 * Created by: Elizabeth Tian, 2016
 *
 */


@isTest
public class TestCalendar {

    @isTest static void testController() {
    	List<Curso__c> test1 = new List<Curso__c>();
    	Date start1 = Date.newInstance(2016, 1, 1);
        Date end1 = Date.newInstance(2016, 1, 15);
        Curso__c bento = new Curso__c(Name='Bento',
    								  Fecha_de_Inicio__c=start1,
    								  Fecha_de_Finalizacion__c=end1,
    								  D_as__c='Viernes',
    								  Frecuencia__c='Semanalmente'
    								  );        
    	test1.add(bento);
        insert test1;
        Test.startTest();
        Calendar controller = new Calendar();
        controller.filterCriteria = 'hi';
        Test.stopTest();
    }
}