/**
 * This class contains the helper methods to create pricebook entry, send email for missing pricebook entries etc.
 *
 * @author Amit M.
 * @version 1.0
 */
public with sharing class PGIProductHelper {
	
	/* Stores custom setting object for send email. */
	private SendPbEntryEmail__c sendEmailSetting;
	
	/* Store product manager user to send email for missing pricebook entries. */
	public User productManager
	{
		get
		{
			if (productManager == null && this.sendPbEntryEmail && sendEmailSetting.ProductManagerId__c != null)
			{
				try
				{
					productManager = [Select Id, Email From User Where Id=:sendEmailSetting.ProductManagerId__c limit 1];
				}
				catch(Exception ex)
				{
					PGIErrorUtilities.logPgiError('Create Opportunity Line Itmes:Product Manager NOT FOUND', 
													ex.getMessage(), PGIErrorUtilities.LoggingLevel.INFO);
				}
			}
			return productManager;
		}
		private set;
	}
	
	/**
	 * Default contstructor for class, populates the custom setting object.
	 */
	public PGIProductHelper()
	{
		this.sendEmailSetting = SendPbEntryEmail__c.getInstance(PGIAppConstants.PB_ENTRY_CUSTOM_SETTING_NAME);
	}
	
	/**
	 * Stores boolean value to check whether should be sent or not.
	 */
	public boolean sendPbEntryEmail
	{
		get
		{
			return this.sendEmailSetting.SendEmail__c;
		}
		private set;
	}
	
	/**
	 * Creates price book entry for the given product and pricebook.
	 *
	 * @param pricebookId, price book id for which price book entry needs to be done.
	 * @returns PricebookEntry object.
	 */
	public PricebookEntry createPbEntryForProduct(Id pricebookId)
	{
		return this.createPbEntryForProduct(null, pricebookId);
	}

	/**
	 * Creates price book entry for the given product and pricebook.
	 *
	 * @param productId, id of the product.
	 * @param pricebookId, price book id for which price book entry needs to be done.
	 * @returns PricebookEntry object.
	 */
	public PricebookEntry createPbEntryForProduct(Id productId, Id pricebookId)
	{
		PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
		
		// If product id is null, then create the entry for PGI standard product.
		if (productId == null)
		{
			productId = staticResources.pgiStandardProduct.Id;
		}
		
		// If pricebook id is null, then create the entry for standard price book.
		if (pricebookId == null)
		{
			pricebookId = staticResources.regionWisePricebooks.get(PGIAppConstants.STANDARD_PRICEBOOK).Id;
		}
		PricebookEntry pbEntry = new PricebookEntry(UnitPrice=10.0, Pricebook2Id=pricebookId, product2Id=productId, isActive=true, UseStandardPrice=false);
		insert pbEntry;
		return pbEntry;
	}
	
	/**
	 * Queries the product object for the given product names.
	 *
	 * @param productNameList, List of product names.
	 * @returns list of queried products.
	 */
	/*public List<Product2> findProductByName(List<String> productNameList)
	{
		List<Product2> productList = null;
		if (productNameList != null && !productNameList.isEmpty())
		{
			productList =  [Select Id, Name From Product2 Where Name IN:productNameList];
		}
		return productList;
	}*/
	
	/**
	 * Sends the email to product manager, notifying him that there are certain products that are missing
	 * price book entries.
	 *
	 * @param productList, List of product objects.
	 */
	/*public void sendPbEntryMissingEmail(List<Product2> productList)
	{
		if (productList != null && !productList.isEmpty())
		{
			if (this.productManager == null)
			{
				PGIErrorUtilities.logPgiError('Create Opportunity Line Itmes', 
												'Product Manager Id is not SET in SendPbEntryEmail__c custom setting.', 
												PGIErrorUtilities.LoggingLevel.INFO);
			}
			else
			{
				String subject = 'Pricebook Entries Not Found.';
				String plainTextBody = 'Pricebook Entries were not found for below products while creating opportunity products,' + PGIAppConstants.NEW_LINE_CHARACTER;
				String htmlBody = '';
				for (Product2 product : productList)
				{
					String productUrl = URL.getSalesforceBaseUrl().toExternalForm() +  PGIAppConstants.FORWARD_SLASH + product.Id;
					htmlBody += '<a href='+productUrl+'>'+product.Name+'</a>' + PGIAppConstants.NEW_LINE_CHARACTER;
				}
				PGISendEmailHelper emailHelper = new PGISendEmailHelper(new String[]{this.productManager.Email}, subject, plainTextBody, htmlBody);
				emailHelper.sendEmail();
			}
		}
	}*/
	
	@isTest
	static void Test_createPbEntryForProduct(){
		Test.startTest();
		Product2 product = PGITestUtilities.getStdProduct(); 
		product.Name = PGIAppConstants.STANDARD_PRODUCT_NAME;
		insert product;
		PGIProductHelper helper = new PGIProductHelper();
        PricebookEntry pbe = helper.createPbEntryForProduct(Test.getStandardPricebookId());
        Test.stopTest();
        system.assert(pbe!=null);
	}
	
	@isTest
	static void Test_productManager(){
		Test.startTest();
		User testUser = PGITestUtilities.getTestUser();
		insert testUser;
		SendPbEntryEmail__c sendEmailSetting = new SendPbEntryEmail__c();
		sendEmailSetting.Name = PGIAppConstants.PB_ENTRY_CUSTOM_SETTING_NAME;
		sendEmailSetting.ProductManagerId__c = testUser.Id;
		sendEmailSetting.SendEmail__c = true;
		insert sendEmailSetting;
		PGIProductHelper helper = new PGIProductHelper();
		system.assert(helper.productManager!= null);
		Test.stopTest();
	}
}