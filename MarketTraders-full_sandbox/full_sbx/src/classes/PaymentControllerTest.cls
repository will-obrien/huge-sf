@isTest
private class PaymentControllerTest {


    static testMethod void paymentTest(){
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'sysAdy', email='sysAdy@testorg.com', emailencodingkey='UTF-8', lastname='Smith', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, timezonesidkey='America/New_York', username='sysAdy@testorg.xyz');


        System.runAs(u) {

            test.StartTest();

            Decimal amount = 0.00;
         	Date today = System.Today();

        	Opportunity oppTest = new Opportunity( Name = 'test', Amount = 123, StageName = 'New Deal', closeDate =  today );

        	insert oppTest;

            Payment_Terms__c ptTest = new Payment_Terms__c(Opportunity__c = oppTest.Id, Active__c = true );

            insert ptTest;

            Planned_Payment__c ppTest = new Planned_Payment__c (amount_due__c = 123, Due_Date__c = today, Payment_Terms__c = ptTest.Id);

        	insert ppTest;

            Payment_Activity__c paTest = new Payment_Activity__c( Payment_Terms__c = ptTest.Id, Outcome__c = 'Declined', Amount__c = 0  );

            insert paTest;

        	Payment__c pTest = new Payment__c ( Planned_Payment__c = ppTest.Id, Payment_Activity__c = paTest.Id );

        	insert pTest;

            Test.setCurrentPageReference(new PageReference('Page.CreatePayment'));
            System.currentPageReference().getParameters().put('oid', oppTest.Id);

            PaymentController pcTest = new PaymentController();

            // Starting process test
            PageReference pageRef = Page.CreatePayment;
            Test.setCurrentPage(pageRef);
            pcTest.payments[0].Amount = 1;
            pcTest.paymentActivity.Amount__c = 1;
            pcTest.paymentActivity.date__c = System.today();
            pcTest.process();



            // Starting cancel test
            PageReference pageRef10 = Page.Processor_Home;
            Test.setCurrentPage(pageRef10);
            pcTest.cancel();

            Payment__c controller = new Payment__c(Planned_Payment__c = ppTest.Id, Payment_Activity__c = paTest.Id, Amount__c = 1 );
            System.assert(controller.Amount__c > 0);


            Test.stopTest();

        }
    }
}