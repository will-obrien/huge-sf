public class createTransaction
{
    public Opportunity opp{get;set;}
    public String[] options{get;set;}
    public String strSelectedVal{get;set;}
    public decimal dAmount{get;set;}
    public boolean bPaidInFull {get;set;}
    public string notes {get;set;}
    public ChargentSFA__Transaction__c objTrans{get;set;}
    public boolean bRender{get;set;}
    public createTransaction(Apexpages.StandardController std)
    {
        opp = (opportunity)std.getRecord();
        opp = [select id,Amount,StageName from opportunity where id =: opp.Id];
        system.debug('opp : '+opp);
        objTrans = new ChargentSFA__Transaction__c();
        bRender = true;
        if(opp.stageName != 'New Lead')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You can process payment for only open invoice.');
            ApexPages.addMessage(myMsg);
            bRender = false;
            //return null;

        }
        
    }

     public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Credit Card By Fax','Credit Card By Fax'));
            options.add(new SelectOption('Check','Check'));
            options.add(new SelectOption('Wire Transfer','Wire Transfer'));
            options.add(new SelectOption('Free','Free'));
            options.add(new SelectOption('ACH','ACH'));
            return options;
        }

    public PageReference SaveTransaction()
    {
        system.debug(' opp.Amount : '+ opp.Amount);
         if(dAmount > opp.Amount)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Amount should not be greater than Opportunity total.');
            ApexPages.addMessage(myMsg);
            return null;

        }

        ChargentSFA__Transaction__c trans = new ChargentSFA__Transaction__c();
        trans.ChargentSFA__Opportunity__c = opp.Id;
        trans.ChargentSFA__Amount__c = dAmount;
        trans.ChargentSFA__Payment_Method__c = strSelectedVal;
        trans.Accounting_Notes__c = objTrans.Accounting_Notes__c;
        if(bPaidInFull)
        {
            trans.ChargentSFA__Response_Message__c = 'Approved';
            trans.ChargentSFA__Response_Status__c = 'Approved';
            trans.ChargentSFA__Type__c = 'Charge';

        }
        trans.ChargentSFA__Gateway_Date__c = objTrans.ChargentSFA__Gateway_Date__c;
        insert trans;
         PageReference pageRef = new PageReference('/'+opp.id);
        pageRef.setRedirect(true);
        return pageref;



    }

    public PageReference CancelTransaction()
    {
        
        PageReference pageRef = new PageReference('/'+opp.id);
        pageRef.setRedirect(true);
        return pageref;



    }
    
    
}