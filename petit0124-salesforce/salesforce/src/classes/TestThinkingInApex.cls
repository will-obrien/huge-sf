@isTest
private class TestThinkingInApex {

    static testMethod void test1() {
        SomeFutureOperations.DoFutureCall();
        SomeFutureOperations.DoFutureCall();
        SomeFutureOperations.DoFutureCall();
        Test.startTest();
        Test.stopTest();
    }
    
    static testMethod void test2() {
    	Test.startTest();
    	ThinkingInApex.IsUserSpecial();
    	ThinkingInApex.IsUserSpecial();
    	Test.stopTest();
    }
    
    static testMethod void test3()
    {
    	Opportunity op = new Opportunity( name='optest', StageName ='Prospecting', CloseDate = Date.Today() );
    	
    	Contact ct = new Contact(LastName = 'newct');
    	insert ct;
    	ThinkingInApex.AssociateContacts = new List<Contact>{ct};

		TestDiagnostics2.SetDefaultFields('Opportunity', new List<Opportunity>{op}); // Used for deployment, not part of this example
    	
    	insert op;
    }
}