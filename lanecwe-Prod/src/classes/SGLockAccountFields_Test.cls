@isTest (SeeAllData = true)
private class SGLockAccountFields_Test {

    static testMethod void SGLockAccountFields_Test() {

        Test.startTest();
        
        Account accttest1 = PGITestUtilities.getAccountDetails();
		accttest1.z_source__c	= 'Salesgateway';
        insert accttest1;
        
        Contact cntcttest1 = PGITestUtilities.getContactDetails(accttest1.id);
        cntcttest1.accountid	=  accttest1.Id;
        cntcttest1.z_source__c	=  'Salesgateway';
        insert cntcttest1;

        conman_contract__c cntrcttest1 = new conman_contract__c(Account_Name__c		=	accttest1.id
                                                              //,Opportunity__c 		= 	opptytest1.id
                                                              ,Contract_Status__c	=	'Sent To Customer');
        insert cntrcttest1;

        accttest1.name			=  'skiptest';
        update accttest1;

        accttest1.Billingcity			=  'hyderabad';
        update accttest1;

        accttest1.Billingstate			=  'AP';
        update accttest1;

        accttest1.Billingstreet			=  'kadapa';
        update accttest1;

        accttest1.Billingcountry			=  'india';
        update accttest1;

        accttest1.Billingpostalcode			=  '1234';
        update accttest1;

        
        
        /*cntcttest1.FirstName	= 'skiptest';
        update cntcttest1;*/
        
        
        Test.stopTest();

    }

}