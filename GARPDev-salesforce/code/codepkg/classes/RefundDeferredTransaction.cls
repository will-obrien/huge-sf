public without sharing class RefundDeferredTransaction
{
    public ChargentSFA__Transaction__c trans{get;set;}
    public String[] options{get;set;}
    public String strSelectedVal{get;set;}
    public decimal dAmount{get;set;}
    public boolean bPaidInFull {get;set;}
    //public DateTime dtDate {get;set;}
    public RefundDeferredTransaction(Apexpages.StandardController std)
    {
        trans = (ChargentSFA__Transaction__c)std.getRecord();
        trans = [select id,ChargentSFA__Opportunity__c,ChargentSFA__Opportunity__r.Amount,Accounting_Notes__c,ChargentSFA__Gateway_Date__c from ChargentSFA__Transaction__c where id =: trans.Id];

    }

     public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Check','Check'));
            options.add(new SelectOption('Wire Transfer','Wire Transfer'));
            options.add(new SelectOption('Charge Back Accepted','Charge Back Accepted'));
            options.add(new SelectOption('Charge Back Loss','Charge Back Loss'));
            return options;
        }

    public PageReference SaveTransaction()
    {
        /*if(dAmount > trans.ChargentSFA__Opportunity__r.Amount)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Amount should not be greater than Opportunity total.');
            ApexPages.addMessage(myMsg);
            return null;

        }*/
        ChargentSFA__Transaction__c tr = new ChargentSFA__Transaction__c();
        tr.ChargentSFA__Opportunity__c = trans.ChargentSFA__Opportunity__c;
        tr.ChargentSFA__Amount__c = dAmount;
        if(strSelectedVal == 'Charge Back Accepted' || strSelectedVal == 'Charge Back Loss')
        tr.ChargentSFA__Payment_Method__c = '';
        else
        tr.ChargentSFA__Payment_Method__c = strSelectedVal;
        tr.ChargentSFA__Response_Message__c = 'Approved';
        tr.ChargentSFA__Response_Status__c = 'Approved';
        if(strSelectedVal == 'Charge Back Accepted' || strSelectedVal == 'Charge Back Loss')
            tr.ChargentSFA__Type__c = strSelectedVal;
        else
            tr.ChargentSFA__Type__c = 'Refund';
        tr.ChargentSFA__Gateway_Date__c = trans.ChargentSFA__Gateway_Date__c;
        tr.Accounting_Notes__c = trans.Accounting_Notes__c;
        insert tr;
         PageReference pageRef = new PageReference('/'+trans.id);
        pageRef.setRedirect(true);
        return pageref;



    }

    public PageReference CancelTransaction()
    {
        
        PageReference pageRef = new PageReference('/'+trans.id);
        pageRef.setRedirect(true);
        return pageref;



    }
    
    
}