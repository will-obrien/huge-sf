public with sharing class PGITestUtilities 
{
    public static Pricebook2 standardPriceBook
    {
        get
        {
            if (standardPriceBook == null)
            {
                standardPriceBook = [SELECT Id, Name FROM Pricebook2 WHERE IsActive = true And IsStandard = true];
            }
            return standardPriceBook;
        }
        set;
    }
    
    /**
     * Creates price book entries for the product.
     */
    public static PricebookEntry CreatePriceBookEntryForProduct(Product2 product)
    {
        //return CreatePriceBookEntryForProduct(product, null);
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbEntry = new PricebookEntry(UnitPrice=10.0, Pricebook2Id=pricebookId, product2Id=product.Id, isActive=true, UseStandardPrice=false);
        return pbEntry;
    }
    
    /**
     * Creates price book entries for the product and given pricebook.
     */
    public static PricebookEntry CreatePriceBookEntryForProduct(Product2 product, Pricebook2 pricebook)
    {
        PricebookEntry pbEntry = null;
        if (pricebook == null)
        {
            pricebook = standardPriceBook;
        }
        if (product != null)
        {
            pbEntry = new PricebookEntry(UnitPrice=10.0, Pricebook2Id=pricebook.Id, product2Id=product.Id, isActive=true, UseStandardPrice=false);
        }
        return pbEntry;
    }
    
    /**
     * Creates new quote line item.
     */
    public static QuoteLineItem CreateQli(Id quoteId, Id priceBookEntryId)
    {
        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = quoteId;
        qli.PricebookEntryId = priceBookEntryId;
        qli.Quantity = 5.0;
        qli.Quantity__c = 5.0;
        qli.UnitPrice = 16.0;
        qli.Discount = 16.0;
        qli.BidPrice__c = 16.0;
        return qli;
    }
    
    public static User getTestUser(){
        return getTestUser(getAdminProfile());
    }
    public static User getTestUser(Profile testProfile) {
        return new User(Alias='TESTUSER',Email='TEST.USER@pgi.com',
            EmailEncodingKey='UTF-8',FirstName='First_TEST',LastName='TEST_LAST_NAME', LanguageLocaleKey='en_US',
            LocaleSidKey='en_GB',ProfileId=testProfile.Id,timezonesidkey='Europe/London',Title='TEST TITLE',
            username='TEST.USERTEMP@pgi.com');
    }
    public static User getTestUser2(Profile testProfile) {
        return new User(Alias='TESTUSER',Email='TEST2.USER@pgi.com',
            EmailEncodingKey='UTF-8',FirstName='First_TEST1',LastName='TEST_LAST_NAME2', LanguageLocaleKey='en_US',
            LocaleSidKey='en_GB',ProfileId=testProfile.Id,timezonesidkey='Europe/London',Title='TEST TITLE',
            username='TEST2.USERTEMP@pgi.com');
    }
    
    public static Profile getAdminProfile() {
        return [Select Id, Name, UserLicense.LicenseDefinitionKey From Profile Where Name = 'System Administrator'];
    }
    public static User getUser(Profile testProfile) {
        return [Select ProfileId, Id From User  where ProfileId=:testProfile.Id and IsActive=true limit 1];
    }
    public static Group getPGINABilling (){
        return new Group(Name='PGI NA BILLING',type='Regular');
    }
    public static Group getPGINAProvisioing (){
        return new Group (Name='PGI NA PROVISIONING',type='Regular');
    }
    public static GroupMember getPGINABillingmembers (Group PGINABilling,User  TestUser){
        return new GroupMember (GroupId=PGINABilling.Id,UserOrGroupId=TestUser.Id);
    }
    public static GroupMember getPGINAProvisioingmembers (Group getPGINAProvisioing,User  TestUser){
        return new GroupMember (GroupId=getPGINAProvisioing.Id,UserOrGroupId=TestUser.Id);
    }
    
    /*******************************************************************
    Purpose:    Get Product Details        
    Parameters: ProductType 
    Returns:    Product__c
    *******************************************************************/
 
        public static Product__c getProductDetails(String ProductType ,String ProductName,String ProductCode){
        Product__c pro=new Product__c();
        pro.ProductType__c=ProductType;
        pro.Name=ProductName;
        pro.List_Rate__c=125;
        pro.Billing_Frequency__c='Monthly';
        pro.Auth_Rate6__c=20;
        pro.Auth_Rate5__c=30;
        pro.Auth_Rate4__c=35;
        pro.Auth_Rate3__c=40;
        pro.Auth_Rate2__c=45;
        pro.Auth_Rate1__c=50;
        pro.Term_Length__c = 1;
        pro.Minimum_Quantity__c=0;
        pro.Maximum_Quantity__c=100;
        pro.ProductCode__c=ProductCode;    
        pro.Is_active__c = true;
        pro.Channels__c='Eco';
        pro.Regions__c='NA';
        pro.CurrencyIsoCode  ='USD' ;
        pro.Unit_Of_Measure__c='Ancillary';
        return pro;
    }
    
    public static Product2 getStdProduct(){     
        Product2 stdPro= new Product2();
        stdPro.Name='StandardProduct';
        return stdPro;
    }
    /*******************************************************************
    Purpose:    Setting parameter in the currentPageUrl       
    Parameters: key,Value
    Returns:    void
    *******************************************************************/
    public static void setTestParameter(String key, String value){
        Apexpages.currentPage().getParameters().put(key,value);
    }

    /*******************************************************************
    Purpose:    Get Region Details        
    Parameters: -
    Returns:    Region__c
    *******************************************************************/
    public static  Region__c getRegionDetails(){
        Region__c region=new Region__c();
        region.Name='NA';
        return region;
    }
    /*******************************************************************
    Purpose:    Get Account Details        
    Parameters: -
    Returns:    Account
    *******************************************************************/
    public static Account getAccountDetails(){
        Account acc=new Account();
        acc.Name='Test';
        return acc;
    }
    
    /*******************************************************************
    Purpose:    Get Contact Details        
    Parameters: - AccId
    Returns:    Contact
    *******************************************************************/
    public static Contact getContactDetails(Id AccId){
        Contact cont=new Contact();
        cont.firstName='firstName';
        cont.lastName ='lastName';
        cont.title = 'test guy';
        cont.email = 'test@test.com';
        cont.AccountId=AccId;
        return cont;
    }
    
    /*******************************************************************
    Purpose:    Get Opportunity Details        
    Parameters: -
    Returns:    Opportunity
    *******************************************************************/
    public static Opportunity getOpportunityDetails(){
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpportunity';
        opp.StageName = 'TargetOpportunity';
        opp.CloseDate = date.today() + 10;
        opp.Prob_Input__c = '10';
        return opp;
    }
    
    /*******************************************************************
    Purpose:    Get Opportunity Line Item Details        
    Parameters: -
    Returns:    Opportunity Line Item
    *******************************************************************/
    public static OpportunityLineItem getOpportunityLineItemDetails(Id opportunityId, Id pricebookEntryId){
        OpportunityLineItem oli=new OpportunityLineItem();
        oli.UnitPrice = 100;
        oli.Quantity = 10;
        oli.OpportunityId = opportunityId;
        oli.PricebookEntryId = pricebookEntryId;
        return oli;
    }
    
    /*******************************************************************
    Purpose:    Get Quote Details        
    Parameters: -
    Returns:    Quote
    *******************************************************************/
    public static Quote getQuoteDetails(Id accId,Id ConId, Id oppId){
        Quote quote=new quote();
        quote.Name='Test quote';
        quote.Account__c=accId;
        quote.ContactId=conId;
        quote.OpportunityId=oppId;
        //quote.ContractType__c='Subcription License Order';
        quote.Status='Quote InProgress';
        
        return quote;
    }
    
    /*******************************************************************
    Purpose:    Get Quote Details        
    Parameters: - PGI Contract added
    Returns:    Quote
    *******************************************************************/
    public static Quote getQuoteDetails(Id accId,Id ConId, Id oppId,Id PGICOntract){
        Quote quote=new quote();
        quote.Name='Test quote';
        quote.Account__c=accId;
        quote.ContactId=conId;
        quote.OpportunityId=oppId;
        quote.PGI_Contract__c=PGICOntract;
        quote.Status='Quote InProgress';
        
        return quote;
    }
    
    public static Competitor__c getCompetitor(Id QuoteId){
        Competitor__c comp=new Competitor__c();
        comp.Competitor_Name__c='BT';
        comp.Competitor_Type__c='Incumbent';
        comp.Quote__c = QuoteId;
        return comp;
    }
    /*******************************************************************
    Purpose:    Get Quote Details        
    Parameters: -
    Returns:    ServiceCategory__c
    *******************************************************************/
    public static ServiceCategory__c getSerCategory(Id ServId, Id ProdId,  boolean dfaultProd){
        ServiceCategory__c serCate= new ServiceCategory__c();       
        serCate.Service__c=ServId;
        serCate.default__c= dfaultProd;
        serCate.product__c=prodId;
        return serCate;
    }
    
    /*******************************************************************
    Purpose:    Get Solution Details        
    Parameters: -
    Returns:    Solution__c
    *******************************************************************/
    public static Solution__c getSolution(){
        Solution__c soln= new Solution__c();
        soln.name='PGI TEST GlobalMeet 10k';
        return soln;
    }
    
    /*******************************************************************
    Purpose:    Get Service    
    Parameters: SolnId
    Returns:    Service__c
    *******************************************************************/
    public static Service__c getService(Id SolnId){
          Service__c service = new Service__c ();
          service.name = 'testserv';
          service.Solution__c = solnId;
          return service;
    }
    /*******************************************************************
    Purpose:    Get QuoteLineItem Details        
    Parameters: -
    Returns:    Quote Line Item
    *******************************************************************/
    public static QuoteLineItem getQuoteLineDetails( Quote aQuote,PGIProduct.ProductList aProdItem,ID PriceBookId){

        QuoteLineItem q1= new QuoteLineItem();
        q1.QuoteId=aQuote.Id;
        q1.Quantity__c= aProdItem.quantity;
        q1.Quantity=1;
        q1.BidPrice__c=aProdItem.Bidprice;               
        q1.PricebookEntryId = PriceBookId;
        q1.UnitPrice=aProdItem.ListRate;
        q1.Product__c=aProdItem.productId;
        q1.Service__c = aProdItem.serviceId;
        q1.Contract_Term__c = aProdItem.termLength;
        q1.Billing_Frequency__c = aProdItem.billingFrequency;
        
        return q1;
    }
    
    /*******************************************************************
    Purpose:    Get QuoteLineItem Details        
    Parameters: -
    Returns:    Quote Line Item
    *******************************************************************/
    public static PGIProduct.ProductList getProductListDetails(){
        Region__c region = PGITestUtilities.getRegionDetails();
        insert region;
        Solution__c solution = PGITestUtilities.getSolution();
        insert solution;
        Service__c service = PGITestUtilities.getService(solution.Id);
        insert service;
        Product__c product = PGITestUtilities.getProductDetails('Service','testService','100');
        insert product;
        ServiceCategory__c serviceCategory = PGITestUtilities.getSerCategory(product.Id, service.Id, true);
        PGIProduct.ProductList prodList = new PGIProduct.ProductList(serviceCategory);
        prodList.approvalStatus='Approved';
        prodList.authorityRate1=10;
        prodList.Bidprice=2000.50;
        prodList.billingFrequency='Daily';
        prodList.isDefaultProduct = true;
        prodList.isServiceProduct=true;     
        return prodList;
    }
    /*******************************************************************
    Purpose:   getStandardController      
    Parameters: -
    Returns:    ApexPages.StandardController
    *******************************************************************/
    
    public static ApexPages.StandardController getStandardController(SObject s){
       return (new ApexPages.StandardController(s));
    }
    
    /*******************************************************************
    Purpose:   getQuoteLineItem      
    Parameters: -
    Returns:    QuoteLineItem
    *******************************************************************/
    public static QuoteLineItem getServiceQuoteLineItem(Id product,Id service,Id quoteId,PricebookEntry pbe){
     QuoteLineItem quoteItem=new QuoteLineItem();
     quoteItem.Service__c=service;
     quoteItem.QuoteId=quoteId; 
     quoteItem.Product__c= product;
     quoteItem.Approval_Status__c ='Approval Required';
     quoteItem.Quantity=1;
     quoteItem.UnitPrice=56;
     quoteItem.PricebookEntryId=pbe.id;
     quoteItem.IsServiceProduct__c = true;
    // quoteItem.=pbe.Product2Id;
    
     return quoteItem;
    }
     /*******************************************************************
    Purpose:   getQuoteLineItem      
    Parameters: -
    Returns:    QuoteLineItem
    *******************************************************************/
    public static QuoteLineItem getTestQuoteLineItem(Id product,Id service,Id quoteId,PricebookEntry pbe,Id masterQuoteId){ 
     QuoteLineItem quoteItem=new QuoteLineItem();
     quoteItem.Service__c=service;
     quoteItem.QuoteId=quoteId; 
     quoteItem.Product__c= product;
     quoteItem.Approval_Status__c ='Approval Required';
     quoteItem.Quantity=1;
     quoteItem.UnitPrice=56;
     quoteItem.PricebookEntryId=pbe.id;  
     quoteItem.Quote_Line_Item__c=masterQuoteId;
   //  quoteItem.Product__c=pbe.Product2Id;
     //quoteItem.
    
     return quoteItem;
    }
    /*******************************************************************
    Purpose:   getOpportunitySolution      
    Parameters: -
    Returns:    OpportunitySolution__c
    *******************************************************************/ 
    public static OpportunitySolution__c getOpportunitySolution(Id oppId,Id quoteId,Id SolId){
         OpportunitySolution__c oppsoln =new OpportunitySolution__c();
         oppsoln.Opportunity__c = oppId; 
         oppsoln.CurrencyIsoCode = 'USD';
         oppsoln.Number_of_License__c=10;
         oppsoln.Solution__c=SolId;
         oppsoln.Quote__c =quoteId;
         oppsoln.BidPrice__c=1;
         oppsoln.Contract_Term__c=12;
          return oppsoln;
  }
  
      /*******************************************************************
    Purpose:   getcompany     
    Parameters: -
    Returns:    company__c
    *******************************************************************/ 
    public static Company__c getCompany(Id AccId){
        Company__c com = new Company__c();
        com.Name='test';
        com.Account__c=AccId;
        return com;
    }
     /*******************************************************************
    Purpose:   getContract     
    Parameters: -
    Returns:    PGI_Contract__c
    *******************************************************************/ 
    public static PGI_Contract__c getContract(Id AccId, Id quoteId){
        PGI_Contract__c contract = new PGI_Contract__c();
        contract.Name='test';
        contract.Account__c=AccId;
        contract.Quote__c=quoteId;
         return contract;
    }
   
    
    /*******************************************************************
    Purpose:   getContractTerms     
    Parameters: -
    Returns:    Contract_Terms__c
    *******************************************************************/ 
    public static Contract_Terms__c getContractTerms(string name ,string terms){
            Contract_Terms__c testConterms= new Contract_Terms__c();
            testConterms.name=name;
            testConterms.Terms_and_Conditions__c=terms;
            return testConterms;
    }
     /*******************************************************************
    Purpose:   getContractAmendmentLevragingQuote   
    Parameters: -
    Returns:    Contract_Amendment_Leveraging_Quote__c
    ******************************************************************
    public static Contract_Amendment_Leveraging_Quote__c getContractQuote(id companyid,id contractid)
    {Contract_Amendment_Leveraging_Quote__c con=new Contract_Amendment_Leveraging_Quote__c ();
    con.name='testcontract';
    con.ContractAmendmentCompany__c=companyid;
    con.ContractAmendment__c=contractid;
    return con;
    }
   
    */ 
    
    /*******************************************************************
    Purpose:   getProdTerms    
    Parameters: -
    Returns:    Add_on_FeatureContractTerms__c
    *******************************************************************/ 
    public static Add_on_FeatureContractTerms__c getProdTerms(Id ConTerm, Id ProdId ){
            Add_on_FeatureContractTerms__c testaddonterms= new Add_on_FeatureContractTerms__c();
            testaddonterms.Contract_Term__c=ConTerm;
            testaddonterms.Add_on_Feature__c=ProdId;
            return testaddonterms;
    }
    /*******************************************************************
    Purpose:   getQuoteCompany   
    Parameters: -
    Returns:    QuoteCompany__c
    ******************************************************************
    public static QuoteCompany__c getQuoteCompanies(Id quote, Id companyId,Id AccId)
    {
            QuoteCompany__c testQuoteCompany = new QuoteCompany__c();
            testQuoteCompany.Quote__c = quote;
            testQuoteCompany.Company__c = companyId;
            testQuoteCompany.quoteAccount__c=AccId;
            return testQuoteCompany;
    }
    */ 
    
    /**
     * Creates test attachment object.
     */
    public static Attachment createAttachment(Id parentId)
    {
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=parentId;
        return attach;
    }
    
    /**
     * Creates note object.
     */
    public static Note createNote(Id parentId)
    {
        Note note = new Note();
        note.Title = 'Test Note';
        note.Body = 'Test Body Note';
        note.ParentId = parentId;
        return note;
    }
    
    /**
     * Creates Region wise approval level custom setting.
     */
    public static void createRegionWiseAppLevNameSetting()
    {
        RegionWiseApprovalLevels__c approvalLevels = new RegionWiseApprovalLevels__c();
        approvalLevels.Name = PGIAppConstants.REGION_WISE_APPROVAL_LEVEL_CUSTOM_SETTING_NAME;
        approvalLevels.NARegion__c = 'Rep;Mgr, RVP, VP;SVP;Pricing Team;EVP;CFO';
        approvalLevels.EMEARegion__c = 'Level 1;Level 2;Level 3;Level 4;Level 5; Level 6';
        approvalLevels.APACRegion__c = 'Level 1;Level 2;Level 3;Level 4;Level 5; Level 6';
        insert approvalLevels;
    }
    
    /**
     * Creates Region wise approval level custom setting.
     */
    public static void createQCStatusValuesCustomSetting()
    {
        Map<String, QCStatusValues__c> allValues = QCStatusValues__c.getAll();
        if (allValues == null || allValues.isEmpty())
        {
            List<QCStatusValues__c> statusValueList = new List<QCStatusValues__c>();
            QCStatusValues__c qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.Accepted.name();
            qcStatusValue.StatusValue__c = 'Accepted';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.Approved.name();
            qcStatusValue.StatusValue__c = 'Approved';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.Closed.name();
            qcStatusValue.StatusValue__c = 'Closed';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.ContractDocumentGenerated.name();
            qcStatusValue.StatusValue__c = 'Contract Document Generated';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.ContractDocumentGeneratedDoc.name();
            qcStatusValue.StatusValue__c = 'Contract Document Generated - Doc';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.ContractSignedbyCustomer.name();
            qcStatusValue.StatusValue__c = 'Contract Signed by Customer';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.Denied.name();
            qcStatusValue.StatusValue__c = 'Denied';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.Draft.name();
            qcStatusValue.StatusValue__c = 'Draft';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.FullyProvisioned.name();
            qcStatusValue.StatusValue__c = 'Fully Provisioned';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.InReview.name();
            qcStatusValue.StatusValue__c = 'In Review';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.NeedsReview.name();
            qcStatusValue.StatusValue__c = 'Needs Review';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.Presented.name();
            qcStatusValue.StatusValue__c = 'Presented';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.PricingApproved.name();
            qcStatusValue.StatusValue__c = 'Pricing Approved- Internally Signed';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.QuoteInProgress.name();
            qcStatusValue.StatusValue__c = 'Quote- In Progress';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.ReadyforClosedWon.name();
            qcStatusValue.StatusValue__c = 'Ready for Closed Won';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.ReadyforContract.name();
            qcStatusValue.StatusValue__c = 'Ready for Contract';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.ReadyForProvisioning.name();
            qcStatusValue.StatusValue__c = 'Ready For Provisioning';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.Rejected.name();
            qcStatusValue.StatusValue__c = 'Rejected';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.SubmittedContractCustomerApproval.name();
            qcStatusValue.StatusValue__c = 'Submitted Contract- Customer Approval';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.SubmittedContractInternalApproval.name();
            qcStatusValue.StatusValue__c = 'Submitted Contract-Internal Approval';
            statusValueList.add(qcStatusValue);
            qcStatusValue = new QCStatusValues__c();
            qcStatusValue.Name = PGIQuoteStatusEnum.SubmittedPriceApproval.name();
            qcStatusValue.StatusValue__c = 'Submitted - Price Approval';
            statusValueList.add(qcStatusValue);
            insert statusValueList;
        }
    }
    
    /**
     * Creates Company Revenue object.
     */
    public static Company_Revenue__c createCompanyRevenue(Id accountId, Id companyId)
    {
        Company_Revenue__c companyRevenue = new Company_Revenue__c();
        companyRevenue.Related_Account__c = accountId;
        companyRevenue.Company_Name__c = companyId;
        companyRevenue.Revenue__c = 10;
        return companyRevenue;
    }
    
    /*******************************************************************
    Purpose:    Get Implementation Services Details        
    Parameters: -
    Returns:    Implementation_Services__c
    *******************************************************************/
    public static Implementation_Services__c getImplementationServices(Id opportunityId){
        Implementation_Services__c impServices= new Implementation_Services__c();
        impServices.Related_Opportunity__c = opportunityId;
        return impServices;
    }
    
    /*******************************************************************
    Purpose:    Get Lead Details        
    Parameters: -
    Returns:    Lead
    *******************************************************************/
    public static Lead getLeadDetails(){
        Lead lead = new Lead();
        lead.FirstName = 'Test';
        lead.LastName = 'Lead';
        lead.Email = 'test@lead.com';
        lead.company = 'testcompany';        
        return lead;
    }
    
    /*******************************************************************
    Purpose:    Get Account Team Member Details        
    Parameters: -
    Returns:    AccountTeamMember
    *******************************************************************/
    public static AccountTeamMember getAccountTeamMember(Id accountId, Id userId){
        AccountTeamMember accTeamMember = new AccountTeamMember();
        accTeamMember.AccountId = accountId;
        accTeamMember.UserId = userId;
        return accTeamMember;
    }
    
    /*******************************************************************
    Purpose:    Get Task Details        
    Parameters: -
    Returns:    Task
    *******************************************************************/
    public static Task getTaskDetails(Id whatId){
        Task tsk = new Task();
        tsk.Subject = 'Call';
        tsk.ActivityDate = Date.today();
        tsk.Status = 'In Progress';
        tsk.Priority = 'High'; 
        tsk.WhatId = whatId;
        return tsk;
    }
    
    /*******************************************************************
    Purpose:    Get Event Details        
    Parameters: -
    Returns:    Event
    *******************************************************************/
    public static Event getEventDetails(Id whatId){
        Event evnt = new Event();
        evnt.Subject = 'Call';
        evnt.ActivityDate = Date.today();
        evnt.StartDateTime = Date.today();
        evnt.EndDateTime = Date.today().AddDays(5); 
        evnt.whatid = whatId;
        return evnt;
    }
    
    /*******************************************************************
    Purpose:    Get ConMan_Contract__c Details        
    Parameters: -
    Returns:    ConMan_Contract__c
    *******************************************************************/
    public static ConMan_Contract__c getConManContractDetails(Id accountId, Id oppId){
        ConMan_Contract__c contract = new ConMan_Contract__c();
        contract.Account_Name__c = accountId;
        contract.Opportunity__c = oppId;
        return contract;
    }
    
    /*******************************************************************
    Purpose:    Get GCS Acq Opportunity Scorecard Details        
    Parameters: -
    Returns:    GCS_Acq_Opportunity_Scorecard__c
    *******************************************************************/
    public static GCS_Acq_Opportunity_Scorecard__c getOpportunityScorecardDetails(Opportunity opp){
        GCS_Acq_Opportunity_Scorecard__c oppScorecard = new GCS_Acq_Opportunity_Scorecard__c();
        oppScorecard.Opportunity__c = opp.Id;
        oppScorecard.Q1__c = '1';
        oppScorecard.Q4__c = '1';
        oppScorecard.Q8__c = '2';
        oppScorecard.Q14__c = '2';
        oppScorecard.Q23__c = '2';
        oppScorecard.Q29__c = '2';
        oppScorecard.Q38__c = '2';
        oppScorecard.Q44__c = '2';
        return oppScorecard;
    }
}