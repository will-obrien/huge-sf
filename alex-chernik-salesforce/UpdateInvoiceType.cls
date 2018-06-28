global class UpdateInvoiceType implements Database.Batchable<sObject>
{
	@TestVisible private static final String INVOICE_RECORD_TYPE = 'Invoice';

	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		System.debug('*****start');
		return Database.getQueryLocator([SELECT Invoice_type__c, RecordTypeId FROM Invoice__c WHERE Invoice_type__c = '']);
	}

	global void execute(Database.BatchableContext bc, List<Invoice__c> invoices)
	{
		System.debug('*****execute');
		for (Invoice__c inv : invoices)
		{
			inv.Invoice_type__c = inv.RecordTypeId == Utils.getRecordTypeId('Invoice__c:' + INVOICE_RECORD_TYPE) ? 
					'Receivable' : 'Payable';
		}

		try
		{
			update invoices;
		}
		catch (DmlException e)
		{
			System.debug('*****dml exc' + e.getMessage());
		}
		catch (Exception e)
		{
			System.debug('*****exc' + e.getMessage());
		}
	}

	global void finish(Database.BatchableContext bc)
	{

	}
}