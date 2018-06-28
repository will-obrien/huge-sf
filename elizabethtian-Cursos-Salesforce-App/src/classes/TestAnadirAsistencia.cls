/*
 * Apex test class that tests the AnadirAsistencia trigger.
 *
 * AnadirAsistencia trigger automatically creates Attendance records when a Registration
 * is created for a course, corresponding to the exact dates that the contact will attend.
 * A course instructor can then select who has attended their course for a particular day.
 * Uses the Calculate Dates Apex class.
 *
 * Created by: Elizabeth Tian, 2016
 *
*/


@isTest
public class TestAnadirAsistencia {
    
    public static Curso__c php;
    public static List<Curso__c> allCourses;
    public static List<Contact> allContacts;
            
    @isTest static void TestTriggerOneClass() {
        createPHP();
        // Create a Contact to be added to PHP
        Contact john = new Contact(FirstName='John', LastName='Smith');
        insert john;
        // Create a subscription to PHP
        Inscripcion__c johnJava = new Inscripcion__c(Curso__c=php.Id, Asistente__c=john.Id);
        // Test
        Test.startTest();
        Database.SaveResult result = Database.insert(johnJava, false);
        Test.stopTest();
        // Check john was inserted
        System.assert(result.isSuccess());
        System.assertEquals(0, result.getErrors().size());
        // Check to make sure new Asistencia objects were created using SOQL query
        List<Asistencia__c> attendance = [SELECT Id, Inscripcion__c, Fecha_de_asistencia__c
                                          FROM Asistencia__c 
                                          WHERE Inscripcion__c=:johnJava.Id];
        System.assertEquals(5, attendance.size());
        System.debug('These are the dates John is attending PHP: ');
        for (Asistencia__c a: attendance) {
            System.debug(a.Fecha_de_asistencia__c + ' ');
        }
    }

    @isTest static void TestTriggerBulkOneClass() {
        createPHP();
        createContacts();
        // Create multiple Subscriptions to be inserted
        List<Inscripcion__c> subs = new List<Inscripcion__c>();
        for (Contact c: allContacts) {
            subs.add(new Inscripcion__c(Curso__c=php.Id, Asistente__c=c.Id));
        }

         // Test
        Test.startTest();
        Database.SaveResult[] result = Database.insert(subs, false);
        Test.stopTest();
        // Check they were inserted
        for (Database.SaveResult res: result) {
            System.assert(res.isSuccess());
            System.assertEquals(0, res.getErrors().size());
        }
        // Check to make sure new Asistencia objects were created using SOQL query
        List<Asistencia__c> attendance = [SELECT Id, Inscripcion__c, Fecha_de_asistencia__c
                                          FROM Asistencia__c 
                                          WHERE Inscripcion__c
                                          IN :subs];
        System.assertEquals(15, attendance.size());
        System.debug('These are the dates 3 people are attending PHP: ');
        for (Asistencia__c a: attendance) {
            System.debug(a.Fecha_de_asistencia__c + ' ');
        }

    }

    @isTest static void TestTriggerManyClasses() {
        createCourses();
        Contact john = new Contact(FirstName='John', LastName='Smith');
        insert john;
        // Create multiple subs
        List<Inscripcion__c> subs = new List<Inscripcion__c>();
        for (Curso__c c: allCourses) {
            subs.add(new Inscripcion__c(Curso__c=c.Id, Asistente__c=john.Id));
        }
        // Test
        Test.startTest();
        Database.SaveResult[] result = Database.insert(subs, false);
        Test.stopTest();
        // Check they were inserted
        for (Database.SaveResult res: result) {
            System.assert(res.isSuccess());
            System.assertEquals(0, res.getErrors().size());
        }
        // Check to make sure new Asistencia objects were created using SOQL query
        List<Asistencia__c> attendance = [SELECT Id, Inscripcion__c, Fecha_de_asistencia__c
                                          FROM Asistencia__c 
                                          WHERE Inscripcion__c
                                          IN :subs];
        System.assertEquals(17, attendance.size());
        System.debug('These are the dates John is attending Java, HTML, and CSS: ');
        for (Asistencia__c a: attendance) {
            System.debug(a.Fecha_de_asistencia__c + ' ');
        }

    }

    @isTest static void TestTriggerBulkManyClasses() {
        createCourses();
        createContacts();
        List<Inscripcion__c> subs = new List<Inscripcion__c>();
        for (Curso__c cur: allCourses) {
            for (Contact con: allContacts) {
                subs.add(new Inscripcion__c(Curso__c=cur.Id, Asistente__c=con.Id));
            }
        }
        // Test
        Test.startTest();
        Database.SaveResult[] result = Database.insert(subs, false);
        Test.stopTest();
        // Check they were inserted
        for (Database.SaveResult res: result) {
            System.assert(res.isSuccess());
            System.assertEquals(0, res.getErrors().size());
        }
        // Check to make sure new Asistencia objects were created using SOQL query
        List<Asistencia__c> attendance = [SELECT Id, Inscripcion__c, Fecha_de_asistencia__c
                                          FROM Asistencia__c 
                                          WHERE Inscripcion__c
                                          IN :subs];
        System.assertEquals(51, attendance.size());
        System.debug('These are the dates 3 people are attending Java, HTML, and CSS: ');
        for (Asistencia__c a: attendance) {
            System.debug(a.Fecha_de_asistencia__c + ' ');
        }
    }

    static void createPHP() {
        // Create a course called PHP
        Date start = Date.newInstance(2016, 5, 1);
        Date endD = Date.newInstance(2016, 5, 31);
        php = new Curso__c(Name='PHP',
                                    Fecha_de_Inicio__c=start,
                                    Fecha_de_Finalizacion__c=endD,
                                    D_as__c = 'Martes;Miercoles',
                                    Frecuencia__c='Quincenalmente'
                                   );
        insert php;
    }
    
    static void createContacts() {
        // Create multiple Contacts
        allContacts = new List<Contact>();
        Contact jill = new Contact(FirstName='Jill', LastName='Smith');
        Contact joe = new Contact(FirstName='Joe', LastName='Stu');
        Contact jack = new Contact(FirstName='Jack', LastName='Li');
        allContacts.add(jill);
        allContacts.add(joe);
        allContacts.add(jack);
        insert allContacts;
    }
    
    static void createCourses() {
        allCourses = new List<Curso__c>();
        Date start1 = Date.newInstance(2016, 4, 1);
        Date end1 = Date.newInstance(2016, 4, 15);
        Curso__c java = new Curso__c(Name='Java',
                                    Fecha_de_Inicio__c=start1,
                                    Fecha_de_Finalizacion__c=end1,
                                    D_as__c = 'Sabado',
                                    Frecuencia__c='Semanalmente'
                                   );
        Date start2 = Date.newInstance(2016, 7, 1);
        Date end2 = Date.newInstance(2016, 8, 31);
        Curso__c html = new Curso__c(Name='HTML',
                                    Fecha_de_Inicio__c=start2,
                                    Fecha_de_Finalizacion__c=end2,
                                    D_as__c = 'Martes;Jueves',
                                    Frecuencia__c='Quincenalmente'
                                   );
        Date start3 = Date.newInstance(2016, 11, 5);
        Date end3 = Date.newInstance(2016, 12, 15);
        Curso__c css = new Curso__c(Name='CSS',
                                    Fecha_de_Inicio__c=start3,
                                    Fecha_de_Finalizacion__c=end3,
                                    D_as__c = 'Domingo',
                                    Frecuencia__c='Semanalmente'
                                   );
        allCourses.add(java);
        allCourses.add(html);
        allCourses.add(css);
        insert allCourses;
    }

}