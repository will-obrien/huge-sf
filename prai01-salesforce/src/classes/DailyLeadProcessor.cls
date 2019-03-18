/*
Create an Apex class that implements the Schedulable interface to update Lead records with a specific LeadSource.
 Write unit tests that achieve 100% code coverage for the class. This is very similar to what you did for Batch Apex.

*/

global class DailyLeadProcessor implements Schedulable {
     
     global void execute(SchedulableContext ctx){
        List <Lead> leads = [SELECT Id, LeadSource FROM lead WHERE LeadSource = NULL];
        List <Lead> leadsToUpdate = new List<Lead>();

        for (Lead l : leads){
            l.LeadSource = 'Dreamforce';
            leadsToUpdate.add(l);
        }
        update leads;
     }

}