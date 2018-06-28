/*
 * Apex test class for the corresponding Add Multiple Subscriptions controller extension
 *
 * SOQL query pulls up a list of all Courses in the database. This allows the organization
 * to subscribe one Contact to multiple Courses that the organization selects
 * and create the corresponding Registration and Attendance records.
 *
 * Created by: Elizabeth Tian, 2016
 *
*/

@isTest
public class TestAddMultipleSubscriptionsContact {
    @isTest static void testExtension() {
    	List<Contact> test1 = new List<Contact>();
        Contact c = new Contact(LastName='Tester');
        test1.add(c);
        insert test1;
    	Date start1 = Date.newInstance(2016, 1, 1);
        Date end1 = Date.newInstance(2016, 1, 15);
    	Curso__c bento = new Curso__c(Name='Bento',
    								  Fecha_de_Inicio__c=start1,
    								  Fecha_de_Finalizacion__c=end1,
    								  D_as__c='Viernes',
    								  Frecuencia__c='Semanalmente'
    								  );
        insert bento;
    	ApexPages.StandardSetController sc = new ApexPages.standardSetController(test1);
    	Add_Multiple_Subscriptions_Contact e = new Add_Multiple_Subscriptions_Contact(sc);
    	PageReference page = new PageReference('/' + c.id);
        e.coursesInternal = e.getCoursesInternal();
        e.coursesInternal[0].selected=true;
        e.contactId = c.id;
        Test.startTest();
        e.processSelected();
        Test.stopTest();

    }
}