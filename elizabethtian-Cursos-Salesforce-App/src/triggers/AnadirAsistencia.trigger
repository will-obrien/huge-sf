/*
 * Apex trigger that automatically creates Attendance records when a Registration
 * is created for a course, corresponding to the exact dates that the contact will attend.
 * A course instructor can then select who has attended their course for a particular day.
 * Uses the Calculate Dates Apex class.
 *
 * Created by: Elizabeth Tian, 2016
 *
*/

trigger AnadirAsistencia on Inscripcion__c (after insert/*, after delete*/) {
    if (Trigger.isInsert) {
        //Inscripcion__c[] insNuevos = Trigger.new;
        Inscripcion__c[] insNuevos = [SELECT Asistente__c,
                                             Curso__c,
                                             Curso__r.Fecha_de_Inicio__c,
                                             Curso__r.Fecha_de_Finalizacion__c,
                                             Curso__r.D_as__c,
                                             Curso__r.Frecuencia__c
                                      FROM   Inscripcion__c WHERE Id IN :trigger.newMap.keySet()];

        List<Asistencia__c> attend = new List<Asistencia__c>();

        // processing after a course is created or updated
        for (Inscripcion__c i: insNuevos) {
            // create new Asistencia__c objects for each day of the course for each participant?
            // GET DATES
            Date[] toMake = CalculateDates.getDates(
                i.Curso__r.Fecha_de_Inicio__c,
                i.Curso__r.Fecha_de_Finalizacion__c,
                i.Curso__r.D_as__c,
                i.Curso__r.Frecuencia__c
                );

            for (Date d: toMake) {
                Asistencia__c toAdd = new Asistencia__c(
                    Asistente__c=i.Asistente__c,
                    Curso__c=i.Curso__c,
                    Inscripcion__c=i.Id,
                    Fecha_de_asistencia__c=d
                    );
                attend.add(toAdd);
            }
        }

        if (attend.size() != 0) {
            insert attend;
        }
    }
    /*if (Trigger.isDelete) {
        // run a SOQL query and delete all the Asistencia__c objects
    }*/
}