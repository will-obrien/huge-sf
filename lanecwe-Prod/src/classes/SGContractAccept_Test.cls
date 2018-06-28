@isTest (SeeAllData = true)
private class SGContractAccept_Test {

    static testMethod void SGContractAccept_Test() {

        Test.startTest();
        
        Account accttest = PGITestUtilities.getAccountDetails();
		accttest.z_source__c	= 'Salesgateway';
		accttest.SlesgatewayID__c	= '123';
        insert accttest;

        Opportunity opptytest = PGITestUtilities.getOpportunityDetails();
		opptytest.z_source__c	= 'Salesgateway';
        opptytest.accountid		= accttest.id;
        insert opptytest;
        
        Contact cntcttest = PGITestUtilities.getContactDetails(accttest.id);
        cntcttest.accountid	=  accttest.Id;
        cntcttest.z_source__c	=  'Salesgateway';
        insert cntcttest;

        conman_contract__c cntrcttest = new conman_contract__c(Account_Name__c		=	accttest.id
                                                              ,Opportunity__c 		= 	opptytest.id
                                                              ,Contract_Status__c	=	'Sent To Customer'
                                                              ,z_source__c			=	'Salesgateway');
        insert cntrcttest;
        
		Attachment atttest = new Attachment();
        atttest.name = 'testattachment';
        atttest.parentid = cntrcttest.id;
        atttest.Description = 'run only for SG';
        atttest.Body = blob.valueOf('test123');
        insert atttest;

        Test.stopTest();
    }

}