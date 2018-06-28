public class paymentDetailsController{
    public String cardno{get;set;}
    public list< Transaction__c> transdetail{get;set;}
        public paymentDetailsController(){
            transdetail = new list< Transaction__c>();
        }
      public pageReference pay(){
                Transaction__c t = new  Transaction__c();
                t.Cardno__c = cardno;
                insert t;
                transdetail =[select transactionid__c from  Transaction__c  ORDER BY transactionid__c DESC LIMIT 1 ];
        return new pageReference ('/apex/paymentDetailspage');
    }
}