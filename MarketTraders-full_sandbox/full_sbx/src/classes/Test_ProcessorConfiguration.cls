/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_ProcessorConfiguration {

    static testMethod void myUnitTest() {
        ProcessorConfiguation configuration = new ProcessorConfiguation();
        
        /* Configure Processor Data Options */
        configuration.csv = true;
  		configuration.api = false;
        configuration.manualWebinarSelection = false;
        configuration.manualDateSelection = false;
        
        /* Configure Processor Settings Options */
        configuration.showPresenter = true;
        configuration.showSecondaryPresenter = true;
        configuration.showDiscount = true;

		/* Configure Opportunity Details */
		configuration.opportunityRecordTypeId = '012600000005Mm1';
		configuration.opportunityRecordTypeName = 'College Course';
		configuration.opportunityName = 'Investment Theory and Practice in Global Currency Markets (' + String.valueOf(Date.today()) + ')';
		configuration.opportunityProduct = 'Investment Theory and Practice in Global Currency Markets';
		configuration.opportunityStageName = 'New Deal';
		configuration.opportunityCloseDate = ProccessorHelperMethods.getEndOfQuarterDate(Date.today());
		
		configuration.opportunityOwnersMap = new map<String,String>{'00560000001ydts'=>'Luis Gonzalez'};
		configuration.setOpportunityOwnerAssignmentVariables();

        for(integer x = 0; x < configuration.opportunityOwnersMap.size() + 1 ; x++){
        	configuration.getOpportunityOwnerId();
        }

    }
    
}