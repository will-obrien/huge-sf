global class JRA_BatchAdvocacyUpdateScheduler implements Schedulable {
/*
PNC June 2015
To enable legisaltor updates via batch, we provide a simple schedulable interface
Client can write their own version that calls the JRA Batch
Class can be scheduled via Dev Console using something like this:

JRA_BatchAdvocacyUpdateScheduler m = new JRA_BatchAdvocacyUpdateScheduler();
String sch = '00 15 * * * ?';
String jobID = system.schedule('Test Update Job', sch, m);
*/

global void execute(SchedulableContext sc) {
    //Set a default PostalCode Field
    String sZipCodeField = 'MailingPostalCode';

    //Get PostalCode Field from Custom Setting
    if (JR_Advocacy_Settings__c.getvalues('ZipCodeField') != NULL) {
    	if (String.IsEmpty(JR_Advocacy_Settings__c.getvalues('ZipCodeField').String_Value__c) == FALSE) {
        	sZipCodeField = JR_Advocacy_Settings__c.getvalues('ZipCodeField').String_Value__c;
    	}
	}
    
    //Invoke batch with basic query that includes all records marked ready to process
    String sQuery = 'Select Id, Legislator_Data_Status__c, ' + sZipCodeField + ' FROM CONTACT WHERE Legislator_Data_Status__c = \'Ready to Process\' ';
	JRA_BatchLegislatorUpdate jba = new JRA_BatchLegislatorUpdate();
	jba.sQuery = sQuery;
    //Scope is set at 25 to avoid callout limits
	database.executebatch(jba,25);

}


}