public class CreatePaymentMethodController {
    // The Zuora id of the payment page
    public String pageId {
        get {
            if(pageId == null) pageId = '';
            return pageId;
        }
        set;
    }
      
    // Constructor, determines the Zuora page Id based on payment method of the quote
    public CreatePaymentMethodController(ApexPages.StandardController standardController) {
          
        // Default payment method type to Credit Card
        String paymentMethodType = 'Credit Card';
          
        // Ensure the payment method field is populated on the Quote sObject
        if(!Test.isRunningTest()) standardController.addFields(new List < String > {'zqu__PaymentMethod__c'});
          
        // Retrieve the quote and set the payment method type based on the quote's payment method
        zqu__Quote__c quote = (zqu__Quote__c)standardController.getRecord();
        if(quote != null) {
          if(quote.zqu__PaymentMethod__c == 'ACH') paymentMethodType = 'ACH';
          else if(quote.zqu__PaymentMethod__c == 'Wire Transfer') paymentMethodType = 'Bank Transfer';
        }
      
        // Query for settings
        List < zqu__HostedPageLiteSetting__c > settingList = [SELECT zqu__PageId__c, zqu__PaymentMethodType__c, zqu__ComponentName__c FROM zqu__HostedPageLiteSetting__c WHERE zqu__PaymentMethodType__c = :paymentMethodType LIMIT 1];
          
        if(settingList != null && !settingList.isEmpty()) {
            pageId = settingList[0].zqu__PageId__c;
        }
    }
}