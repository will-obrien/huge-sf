global class CustomiseHostedPageLiteGoNextPlugin extends zqu.PaymentPageController.DefaultHostedPageLiteGoNextPlugin {
    global override PageReference navigateNext(String paymentMethodType, Map < String, String > callbackParameters) {
        Boolean success = Boolean.valueOf(callbackParameters.get('success'));
      
        if(!success) {
           String errorMessage = callbackParameters.get('errorMessage');
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
           return null;
        }
        
        zqu__Quote__c updatedQuote = new zqu__Quote__c(id='a0ZF0000009wIOpMAM');
        updatedQuote.Custom_Text_Field__c  = String.valueOf(System.Now().format('yyyyMMdd hhmmss'));
        for (Integer i = 0; i < 1000000; i++) {
            System.debug(i+1);
        }
        update updatedQuote;
        return new PageReference('/a0ZF0000009wIOpMAM');
    }
}