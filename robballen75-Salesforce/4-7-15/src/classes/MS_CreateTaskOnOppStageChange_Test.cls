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
private class MS_CreateTaskOnOppStageChange_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
   
 	    account acct  = new account();
		acct.name = 'Test Company';
		acct.Industry = 'Law Firm - UK(House)';
		acct.BillingCountry = 'France';
		insert acct;
   
   		contact cont = new contact();
   		cont.firstName = 'Test';
   		cont.lastName = 'LastName';
   		cont.AccountId = acct.Id;
   		insert cont;
   		
   		
   		system.debug('acctid = ' + acct.id);
   		
   		opportunity opp = new opportunity();
   		opp.AccountId=acct.Id;
   		opp.Amount = 100;
   		opp.Software_Amount__c = 100;
   		opp.StageName = 'Not Called';
   		opp.Name = 'Test name';
   		opp.CloseDate = date.today() + 60;
   		
   		   		insert opp;
   		
   		OpportunityContactRole opcr = new OpportunityContactRole();
   		opcr.ContactId = cont.id;
   		opcr.OpportunityId = opp.id;
   		insert opcr;
   		
   		
   test.starttest();
   
   Integer actCount = [select count() from task where WhatId = :opp.id];
   
   system.assertEquals(0,actCount);
   opp.StageName = '2-Discovery';
   update opp;
  actCount = [select count() from task where WhatId = :opp.id];
   system.assertEquals(1,actCount);
   
   	          	          
    }
}