public with sharing class PrepareNewQuoteController{
    
    private Zuora.zApi api = new Zuora.zApi();
    private final Opportunity opp;
    private final String CRMId;
    private final Map <String,List<SelectOption>> cachedSubOptions = new Map <String,List<SelectOption>>();
    
    public Boolean initFailed                          {get; private set;}
    public String  selectedAccountType                 {get;set;}
    public String  selectedAccount                     {get;set;}
    public String  selectedSubscription                {get;set;}
    public String  selectedSubscriptionType            {get;set;}
    public String  selectedAmendmentType               {get;set;}
    public List<SelectOption> billingAccountList       {get;set;}
    public List<SelectOption> subscriptionList         {get;set;}
        
    public PrepareNewQuoteController(ApexPages.StandardController controller) {
        this.initFailed = true;
        final String oppId = controller.getId();
        if (null == oppId || '' == oppId) {
            appendErrorMessage('Need to specify the id of opportunity to create a quote.');
            return;
        }     
        
        final List<Opportunity> oppList = [SELECT Id, Account.Id FROM Opportunity WHERE Id = :oppId limit 1];
        if (oppList.size() != 1) {
            appendErrorMessage('Invalid opportunity specified to create a quote.');
            return;
        }     
        this.opp = oppList[0];
        this.CRMId = this.opp.Account.Id;
        
        try {
            api.zlogin();
        } catch (Zuora.zAPIException e) {
            appendErrorMessage(e.getMessage());
            return;
        }
        this.initFailed = false;
    }
    
    public PageReference onload() {
        try {
            this.loadBillingAccountList();
        } catch (Zuora.zAPIException e) {
            appendErrorMessage(e.getMessage());
                        return null;
        }
        return null;
    }
    
    public PageReference onSelectAccount() {
                try {
                    this.loadSubscriptionList();
                } catch (Zuora.zAPIException e) {
                    appendErrorMessage(e.getMessage());
                    return null;
            }
            return null;
    }
    
    public PageReference goNewQuote() {
        PageReference  newQuotePage = Page.zqu__CreateQuote;
        String quoteType = 'Subscription';
        if ('amend' == selectedAmendmentType ) {
            quoteType = 'Amendment';
        } else if ('renew' == selectedAmendmentType) {
                    quoteType = 'Renewal';
        }
        newQuotePage.getParameters().put('quoteType', quoteType);
        newQuotePage.getParameters().put('billingaccountid', this.selectedAccount);
        newQuotePage.getParameters().put('existsubscriptionid', this.selectedSubscription);
        newQuotePage.getParameters().put('oppid', String.valueOf(this.opp.Id).substring(0,15));
        newQuotePage.setRedirect(true);     
 
        return newQuotePage;
    }
 
    public PageReference onSelectAccountType() {
        if ('new' == this.selectedAccountType) {
            this.selectedSubscriptionType = 'new';
        } else {
                        try {
                        this.loadBillingAccountList();
                        } catch (Zuora.zAPIException e) {
                        appendErrorMessage(e.getMessage()); 
                        return null;
                        }
            this.selectDefaultAccount();
        }     
        return null;
    }
    
    private void selectDefaultAccount() {
        if (this.billingAccountList != null && this.billingAccountList.size() > 0) {
            this.selectedAccount = this.billingAccountList[0].getValue();
        }
        this.onSelectAccount();
    }
    
    public PageReference onSelectSubscriptionType() {
        if ('existing' == this.selectedSubscriptionType) {
                        try {
                        this.loadSubscriptionList();
                        } catch (Zuora.zAPIException e) {
                        appendErrorMessage(e.getMessage());
                        return null;
                }
                this.selectDefaultSubscription();
        }     
        return null;         
    }   
    private void selectDefaultSubscription() {
        if (this.subscriptionList.size() > 0) {
            this.selectedAmendmentType = 'amend';
            this.selectedSubscription = this.subscriptionList[0].getValue();
        }
    }   
    private void loadBillingAccountList() {
        if (this.CRMId == null) return;
        //already queried from Zuora, no need to query again
        if (this.billingAccountList != null)
            return;
        else{
            //query from Zuora and build the billing account picklist
            this.billingAccountList = new List<SelectOption> ();
            String acczoql = 'SELECT AccountNumber, Name FROM Account WHERE Status = \'Active\' AND CrmId LIKE \'' + this.CRMId.substring(0, 15) + '%\'';
            List <Zuora.zObject> acclist;
            try {
                acclist = api.zquery(acczoql);
            } catch (Zuora.zAPIException e) {
                throw e;
            }
            
            for(Zuora.zObject acc: acclist) {
                String accvalue = (String)acc.getValue('Id');                 
                String acclabel = acc.getValue('Name') +  ', Acct#:' + acc.getValue('AccountNumber');                                   
                SelectOption accso = new SelectOption (accvalue, acclabel);
                this.billingAccountList.add(accso);
            } 
        }
    }   
    //query the subscription from zuora and build the picklist
    private void loadSubscriptionList() {
        this.subscriptionList = new  List<SelectOption>();     
        if (this.selectedAccount == null) return;
        List<SelectOption> suboptionlist = this.cachedSubOptions.get(this.selectedAccount);
        if (suboptionlist != null) this.subscriptionList = suboptionlist;
        else{
            suboptionlist = new List<SelectOption> ();
            String subzoql = 'SELECT Id, Name, ContractEffectiveDate, TermType, Status FROM Subscription WHERE TermType=  \'TERMED\' AND Status = \'Active\' AND AccountId = \'' + this.selectedAccount + '\'';
            List<Zuora.zObject> subscriptionList;
            try { 
                subscriptionList = api.zquery(subzoql);
            } catch (Zuora.zAPIException e) {
                throw e;
            }                   
            
            for(Zuora.zObject sub : subscriptionList) {
                String subvalue = (String)sub.getValue('Id');
                DateTime cedatetime = (DateTime)sub.getValue('ContractEffectiveDate');             
                String sublabel = (String)sub.getValue('Name') +  ', Status: ' + (String)sub.getValue('Status') +  ', Contract Effective Date: ' +  cedatetime.date().format();
                SelectOption subso = new SelectOption (subvalue,sublabel);
                suboptionlist.add(subso);
            }
        
            if (suboptionlist.size() > 0){
                this.cachedSubOptions.put(this.selectedAccount, suboptionlist);
                this.subscriptionList = suboptionlist;
            }
        }
    }
    
    static private void appendErrorMessage(String message) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
    }
}