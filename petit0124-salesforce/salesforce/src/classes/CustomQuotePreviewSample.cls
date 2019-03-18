public with sharing class CustomQuotePreviewSample extends zqu.QuotePreviewController {
  /*CLASS VARIABLES*/
  public static final String BLANK_CONTACT_ERROR_MESSAGE = 'A quote must have a valid bill to contact and sold to contact to be sent to Zuora. Click Go Back to return to the quote\'s detail page';
  public static final String QUOTE_SUBMIT_SUCCESS = 'Quote was successfully submitted to Z-Billing!';
 
  /*INSTANCE VARIABLES*/
  // Configuration options for quote preview component
  public zqu.QuotePreviewOptions previewOptions {
    get;
    set;
  }
  // Configuration options for notification component within quote preview component
  public zqu.NotificationOptions notificationOptions {
    get;
    set;
  }
  // Handler to the quote object
  private zqu__Quote__c quote {
    get;
    set;
  }
  // Constructor
  public CustomQuotePreviewSample(ApexPages.StandardController stdController) {
    // Ensure that the BillTo/SoldTo contacts are accessible
    if (!Test.isRunningTest()) stdController.addFields(new List < String > {
      'zqu__BillToContact__c', 'zqu__ElectronicPaymentMethodId__c', 'zqu__Opportunity__r.AccountId', 'zqu__SoldToContact__c', 'zqu__ZuoraAccountID__c'
    });
    // Get quote object
    quote = (zqu__Quote__c) stdController.getRecord();
    // Initialize preview options
    previewOptions = new zqu.QuotePreviewOptions();
    // Pass quote id to the preview options
    previewOptions.quoteId = stdController.getId();
    // Set display options
    previewOptions.buttonBarLocation = 'top';
    previewOptions.quotePropertyTitle = 'Quote Details';
    previewOptions.selectedProductsTitle = 'Selected Products and Rate Plans';
    previewOptions.isSelectedProductsCollapsible = true;
    // Set preview controller and CreateOrderPlugin
    previewOptions.previewController = this;
    previewOptions.createOrderPlugin = 'CustomQuotePreviewSample.CreateOrderPlugin';
    // Initialize the notification options
    notificationOptions = new zqu.NotificationOptions();
 
    // If the quote is missing a Bill To Contact or Sold To Contact, disable the create order button
    // and display a popup message for the error
    if (quote.zqu__BillToContact__c == null || quote.zqu__SoldToContact__c == null) {
      previewOptions.disableCreateButton = true;
      notificationOptions.failureBody = BLANK_CONTACT_ERROR_MESSAGE;
      notificationOptions.isPopup = true;
      notificationOptions.backAction = 'toQuoteDetail();';
    }
    // Set configuration options for notification component within quote preview component
    previewOptions.notificationOptions = notificationOptions;
  }
  // Method to return to quote's detail page from notification popup
  public PageReference toQuoteDetail() {
    return new PageReference('/' + quote.Id);
  }
  // Plugin implementation of ICreateOrder interface
  public class CreateOrderPlugin implements ICreateOrderPlugin {
    public PageReference CreateOrder(zqu.QuotePreviewController qpc) {
      // Cast plugin instance
      CustomQuotePreviewSample previewController = (CustomQuotePreviewSample) qpc;
      //Retrieve quote object from outer controller
      zqu__Quote__c quote = previewController.quote;
      if (quote == null) return null;
      // Retrieve config information
      Map < String, Object > zqconfig = zqu.zQuoteUtil.getZuoraConfigInformation();
      List < zqu.zQuoteUtil.ZBillingQuoteCollection > quotes = new List < zqu.zQuoteUtil.ZBillingQuoteCollection > ();
      zqu.zQuoteUtil.ZBillingQuoteCollection quoteCol = new zqu.zQuoteUtil.ZBillingQuoteCollection();
      // Set Account ID on collection
      if (String.isNotEmpty(quote.zqu__Opportunity__r.AccountId)) {
        quoteCol.sfdcAccountId = quote.zqu__Opportunity__r.AccountId;
      }
      quoteCol.zAccountId = String.isEmpty(quote.zqu__ZuoraAccountId__c) ? 'new' : quote.zqu__ZuoraAccountId__c;
      quoteCol.quoteRequests = new List < zqu.zQuoteUtil.ZBillingQuoteRequest > ();
      zqu.zQuoteUtil.ZBillingQuoteRequest req = new zqu.zQuoteUtil.ZBillingQuoteRequest();
      req.sfdcQuoteId = quote.Id;
      //Set the payment method id on request from the quote if not null
      if (String.isNotBlank(quote.zqu__ElectronicPaymentMethodID__c)) {
        req.paymentMethodId = quote.zqu__ElectronicPaymentMethodID__c;
      }
      //Set generate invoice flag on request
      req.generateInvoice = (Boolean) zqconfig.get('Generate_Invoice__c');
      //Set process payments flag on the request
      Boolean processPayment = (Boolean) zqconfig.get('Process_Payments__c') == null ? false : (Boolean) zqconfig.get('Process_Payments__c');
      req.processPayment = processPayment && String.isNotBlank(quote.zqu__ZuoraAccountID__c);
      quoteCol.quoteRequests.add(req);
      quotes.add(quoteCol);
      //Send request
      List < zqu.zQuoteUtil.zBillingResult > results = 
        zqu.zQuoteUtil.sendToZBilling(quotes);
      //Display results using popup notification component
      previewController.notificationOptions.isPopup = true;
      //If zBillingResult was successful, navigate to Subscription Confirmation page. If not, display error message on current page
      for (zqu.zQuoteUtil.zBillingResult result: results) {
        if (result.success) {
          //Enable popup notification with OK button redirecting to quote detail page
          previewController.notificationOptions.continueAction = 'hidePopupNotification();displayStatusModal();toQuoteDetail();';
          previewController.notificationOptions.backAction = '';
          //Post confirmation message
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, QUOTE_SUBMIT_SUCCESS));
        }
        else {
          //Enable popup notification with cancel button only
          previewController.notificationOptions.continueAction = '';
          previewController.notificationOptions.backAction = 'hidePopupNotification();displayStatusModal();toQuoteDetail();';
          //Post error message
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, result.message));
        }
      }
      //Stay on current page
      return null;
    }
  }
}