public class refundPayments
{
    public ChargentSFA__Transaction__c payment;
    public list<wrapperOpps> lstWrapper{get;set;}
    public boolean bRender{get;set;}
    public refundPayments(Apexpages.StandardController std)
    { 
        payment = (ChargentSFA__Transaction__c)std.getRecord();
        try
        {
            payment = [select id,ChargentSFA__Opportunity__c,ChargentSFA__Type__c,ChargentSFA__Amount__c,ChargentSFA__Response_Status__c
                    from ChargentSFA__Transaction__c where id=: payment.Id];
        }
        catch(Exception ex)
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'This Payment is not eligible for refunds.'));
            //return;
        }

        bRender = true;
        if(payment.ChargentSFA__Type__c != 'Charge' && payment.ChargentSFA__Response_Status__c != 'Approved')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot issue a refund for this transaction.');
            ApexPages.addMessage(myMsg);
            bRender = false;
            return;

        }
        
                    
        loadLineItems(payment);
        
    }
    
    public class wrapperOpps
    {
        public boolean isSelected{get;set;}
        public Product_Refunds__c objProductRefund{get;set;}
        public Decimal dAmount{get;set;}
        public Decimal Sale_Price{get;set;}
        public String Refund_Code{get;set;}
        
        
        public wrapperOpps(OpportunityLineItem oppLine,ChargentSFA__Transaction__c objPayment)
        {
            objProductRefund = new Product_Refunds__c();
            objProductRefund.Product__c = oppLine.Product2Id;
            objProductRefund.Payment_Transaction__c = objPayment.Id;
            objProductRefund.Reason__c = '';
            objProductRefund.Refund_amount__c = 0;
            objProductRefund.Opportunity__c = oppLine.OpportunityID;
            objProductRefund.Unique_Id__c = string.valueOf(oppLine.OpportunityID)+string.valueOf(oppLine.Product2Id); 
            objProductRefund.Sales_Price__c = oppLine.UnitPrice;
            objProductRefund.Take_Membership__c = false;
                   
        }
    }
    
    public pageReference saveData()
    {
       List<Product_Refunds__c> lstProdRefunds = new List<Product_Refunds__c>();
       decimal dTotal = 0;
       boolean bSelected = false;
       
        for(wrapperOpps objWrap : lstWrapper)
        {
            //if(!bSelected) bSelected = objWrap.isSelected;
            if(objWrap.isSelected)
            {
                dTotal += objWrap.objProductRefund.Refund_amount__c;
                lstProdRefunds.add(objWrap.objProductRefund);
            }
        }
        if(lstProdRefunds.size() <= 0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please select record before saving.'));
            return null;
        }
        Decimal dRefundAmount = payment.ChargentSFA__Amount__c;
        if(dRefundAmount < 0)
            dRefundAmount = -dRefundAmount;
            
        if(dTotal > dRefundAmount)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Total amount should not exceed than refund amount.'));
            return null;
        }
        system.debug('lstProdRefunds == '+lstProdRefunds);
        upsert lstProdRefunds;
        
        PageReference pageRef = new PageReference('/'+payment.Id);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public void loadLineItems(ChargentSFA__Transaction__c objPay)
    {
        lstWrapper = new list<wrapperOpps>();
        Id oppId = null;
        /*if(payment.pymt__Transaction_Type__c == 'Refund')  oppId = payment.pymt__Parent_Transaction__r.pymt__Opportunity__c;
        else */
        oppId = payment.ChargentSFA__Opportunity__c;
        for(OpportunityLineItem opp : [select id,ProductCode,UnitPrice,TotalPrice,Product2Id,OpportunityID from OpportunityLineItem
                                        where OpportunityID =: oppId])
                {
                    lstWrapper.add(new wrapperOpps(opp,objPay));
                }
    }
    
}