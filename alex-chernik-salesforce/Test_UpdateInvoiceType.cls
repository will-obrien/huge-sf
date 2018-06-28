@IsTest
private class Test_UpdateInvoiceType
{
	@isTest
	static void testInvoiceUpdate()
	{
		Account acc = TestDataUtils.createAccount();
		insert acc;

		Opportunity opp = TestDataUtils.createOpportunity();
		opp.AccountId = acc.Id;
		insert opp;

		List<Invoice__c> invoicesOneType = new List<Invoice__c>();
		for (Integer i = 0; i < 50; i++)
		{
			Invoice__c inv1 = TestDataUtils.createInvoice(acc.Id, opp.Id, 'Invoice');
			inv1.Invoice_type__c = null;
			invoicesOneType.add(inv1);
		}
		insert invoicesOneType;

		List<Invoice__c> invoicesAnotherType = new List<Invoice__c>();
		for (Integer i = 0; i < 100; i++)
		{
			Invoice__c inv2 = TestDataUtils.createInvoice(acc.Id, opp.Id, 'Internal');
			inv2.Invoice_type__c = null;
			invoicesAnotherType.add(inv2);
		}
		insert invoicesAnotherType;

		Test.startTest();
		Database.executeBatch(new UpdateInvoiceType(), 200);
		Test.stopTest();

		for (Invoice__c invoice : [SELECT RecordTypeId, Invoice_type__c FROM Invoice__c LIMIT 200])
		{
			if (invoice.RecordTypeId == Utils.getRecordTypeId('Invoice__c:' + UpdateInvoiceType.INVOICE_RECORD_TYPE))
			{
				System.assertEquals('Receivable', invoice.Invoice_type__c);
			} else
			{
				System.assertEquals('Payable', invoice.Invoice_type__c);
			}
		}
	}
}
