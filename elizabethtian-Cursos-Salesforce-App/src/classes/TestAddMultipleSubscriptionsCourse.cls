/*
 * Apex test class for corresponding Add Multiple Subscriptions controller extension
 *
 * SOQL query pulls up a list of all Contacts in the database. This allows the organization
 * to select and subscribe multiple Contacts to one course, creating the corresponding
 * Registration and Attendance records.
 *
 * Created by: Elizabeth Tian, 2016
 *
*/

@isTest
public class TestAddMultipleSubscriptionsCourse {
    @isTest static void testExtension() {
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
    	Contact c = new Contact(LastName='Test');
        insert c;
    	ApexPages.StandardSetController sc = new ApexPages.standardSetController(test1);
    	Add_Multiple_Subscriptions_Course e = new Add_Multiple_Subscriptions_Course(sc);
    	PageReference page = new PageReference('/' + bento.id);
        e.contactsInternal = e.getContactsInternal();
        e.contactsInternal[0].selected=true;
        e.courseId = bento.id;
        Test.startTest();
        e.processSelected();
        Test.stopTest();

    }
}