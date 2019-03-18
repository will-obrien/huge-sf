public class TestingUtils {
    private static Integer offsetForDummyInsert = 1;

    public static User ADMIN_USER
    {
        get {
            if ( ADMIN_USER == null ){
                ADMIN_USER = [SELECT Id FROM User WHERE  Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
            }
            return ADMIN_USER;
        }
        set;
    }

    public static Product2 createProduct(String prodName, Map<String, Object> additionalFieldMap, Boolean doInsert ){

        Product2 testProd = new Product2( Name = prodName );
        mergeValues(testProd, additionalFieldMap);

        if (doInsert){
            insert testProd;
        }

        return testProd;
    }

    public static List<Task> createTasks(Integer numTasks, String taskSubject, string typeName, Id whoID,  Boolean doInsert ){
        List<Task> tasksToCreate = new List<Task>();

        for(integer i = 0; i <numTasks; i++) {
            tasksToCreate.add(new Task(subject = taskSubject + i, whoID = whoID, type = typeName, ActivityDate = Date.today()));
        }

        if (doInsert){
            insert tasksToCreate;
        }

        return tasksToCreate;

    }

    public static List<Lead> createLead(Integer numLeads, String leadName, Boolean doInsert) {
        List<Lead> leads = new List<Lead>();
        for(integer i = 0; i < numLeads; i++){
            leads.add(new Lead(lastName= leadName + i, Company = 'Sentient Jet'));
        }

        if (doInsert){
            insert leads;
        }
        return leads;
    }

    /**
    *   Create a new user
    *   @param String - the user name
    *   @param String - profile name
    *   @return User
    */
    public static User createTestUser(String userName, String profileName)
    {
        Id profileId;
        try
        {
            profileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;
        }
        catch (Exception ex)
        {
            System.assert( false, profileName + ' profile does not exist in the system');
        }

        User testUser = new User();
        testUser.LastName = 'test ' + UserName;
        testUser.Alias = (userName.length() > 8 ) ?  userName.substring(0 , 8) : userName;
        testUser.Email = UserName+'@bluewolfgroup.com';
        testUser.Username = UserName+UserName+'@test.com';
        testUser.ProfileId = profileId;
        testUser.CommunityNickname = 'a'+UserName;
        testUser.TimeZoneSidKey = 'America/New_York';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.IsActive = true;

        return testUser;
    }


    public static List<Case> createCases(Integer numCases, String caseName, Boolean doInsert) {
        List<Case> cases = new List<Case>();
        for(integer i = 0; i < numCases; i++){
            cases.add(new Case (Subject = caseName));
        }

        if (doInsert){
            insert cases;
        }
        return cases;
    }

    public static List<Account> createAccounts(Integer numAccounts, String acctName, Boolean doInsert) {
        List<Account> accounts = new List<Account>();
        for(integer i = 0; i < numAccounts; i++){
            accounts.add(new Account(name = acctName + i));
        }

        if (doInsert){
            insert accounts;
        }
        return accounts;
    }


    public static List<Opportunity> createOpportunities(Integer size, Id accountId, Boolean doInsert){
        List<Opportunity> opptys = new List<Opportunity>();
        for(Integer i = 0; i < size; i++)
        {
            opptys.add( new Opportunity(name = 'opptyName' + i, accountId= accountId, Vertical_Market__c = 'Healthcare', StageName= 'D-Proposal/Bid-Not Daikin Specified', closeDate = Date.today()) );
        }

        if(doInsert){
            insert opptys;
        }
        return opptys;
    }

    public static RecordType getRecordType(String sObjectType, String name) {
        List<RecordType> recordTypes = new List<RecordType>();

        recordTypes =[select id from RecordType where sObjectType =: sObjectType and developername =: name Limit 1];
        if(recordTypes.size() == 0) {
            return null;
        }

        return recordTypes[0];
    }

    public static List<Contact> createContacts( Integer numOfContacts, Id accountId, Boolean doInsert ){
        List<Contact> contactList = new List<Contact>();
        for( Integer index = 0; index < numOfContacts; index++ ){
            Contact contact = new Contact();
            contact.LastName = 'TestLast' + index;
            contact.AccountId = accountId;
            contact.Email = 'test' + index + '@test.com';
            contactList.add( contact );
        }

        if( doInsert ){
            insert contactList;
        }

        return contactList;
    }

    public static List<Case_Asset__c> createCaseAssets( List<Case> cases, List<Asset> assets, Boolean doInsert ) {
        List<Case_Asset__c> caseAssets = new List<Case_Asset__c>();
        for(Integer i = 0; i < Math.min(cases.size(), assets.size()); i++){
            caseAssets.add(new Case_Asset__c(case__c = cases[i].Id, asset__c = assets[i].Id));
        }

        if( doInsert ){
            insert caseAssets;
        }
        return caseAssets;
    }

    public static List<Asset> createAssets( Integer numOfAssets, sObject parent, Boolean doInsert){
        List<Asset> assets = new List<Asset>();
        for(Integer i = 0; i < numOfAssets; i++){
            Asset a = new Asset();
            if(parent instanceOf Account){
                a.AccountId = parent.Id;
            } else if (parent instanceOf Contact){
                a.ContactId = parent.Id;
            } else {
                System.assert(false, 'Unknown parent type, please use Contact or Account');
            }
            a.Name = 'Test Asset' + i;
            assets.add(a);
        }

        if(doInsert){
            insert assets;
        }
        return assets;
    }

    public static List<Order__c> createOrders(Integer numToCreate, boolean doInsert){
        List<Order__c> ordersToReturn = new List<Order__c>();

        for(Integer i = 0 ; i< numToCreate; i++) {
            ordersToReturn.add(new Order__c());
        }

        if(doInsert) {
            insert ordersToReturn;
        }

        return ordersToReturn;
    }

    public static List<Address__c> createAddresses(Integer numToCreate, boolean doInsert){
        List<Address__c> objects = new List<Address__c>();

        for(Integer i = 0; i < numToCreate; i++){
            objects.add(new Address__c(
                    Address_Line_1__c = '123 Address',
                    City__c = 'Chicago',
                    State_Province__c = 'Illinois',
                    State_Province_ISO_Code__c = 'IL',
                    Postal_Code__c = '123456',
                    Country_ISO_Code__c = 'USA',
                    Country__c = 'United States'
                )
            );
        }

        if(doInsert) insert objects;
        return objects;
    }

    public static List<Contact_Address__c> createContactAddresses(Integer numToCreate, Id contactId, Id addressId, boolean doInsert){
        List<Contact_Address__c> objects = new List<Contact_Address__c>();

        for(Integer i = 0; i < numToCreate; i++){
            objects.add(new Contact_Address__c(
                    Contact__c = contactId,
                    Address__c = addressId,
                    Active__c = true,
                    Physical__c = true
                )
            );
        }

        if(doInsert) insert objects;
        return objects;
    }

    public static List<Account_Address__c> createAccountAddresses(Integer numToCreate, Id accountId, Id addressId, boolean doInsert){
        List<Account_Address__c> objects = new List<Account_Address__c>();

        for(Integer i = 0; i < numToCreate; i++){
            objects.add(new Account_Address__c(
                    Account__c = accountId,
                    Address__c = addressId,
                    Active__c = true
                )
            );
        }

        if(doInsert) insert objects;
        return objects;
    }


    public static Boolean pageMessagesContains(String messageNeedle){
        List<ApexPages.Message> messages = ApexPages.getMessages();

        for(ApexPages.Message message : messages)
        {
            if(message.getSummary().contains( messageNeedle))
            return true;
        }
        return false;
    }

    private static void mergeValues(SObject sobj, Map<String, Object> fieldToValue)
    {
        for ( String fieldName : fieldToValue.keySet()  ){
            sobj.put( fieldName, fieldToValue.get(fieldName) );
        }
    }

    public static void dummyInsert(List<SObject> objects)
    {
        String Id_Prefix = objects[0].getSObjectType().getDescribe().getKeyPrefix();
        for( Integer i = 0; i < objects.size(); i++ )
        {
            String idSuffix = String.valueOf( offsetForDummyInsert ).leftPad(12);
            idSuffix = idSuffix.replace(' ', '0');

            objects[i].id= Id_Prefix + idSuffix;
            offsetForDummyInsert+=1;
        }
    }

    public static Pricebookentry createPriceBookEntry(Id prodId, Decimal prodUnitPrice, Map<String, Object> additionalFieldMap, Boolean doInsert)
    {
        Pricebookentry testPbe = new Pricebookentry();
        testPbe.Product2Id = prodId;
        testPbe.UnitPrice = prodUnitPrice;
        testPbe.Pricebook2Id = Test.getStandardPricebookId();
        testPbe.IsActive = TRUE;
        mergeValues(testPbe, additionalFieldMap);

        if (doInsert){
            insert testPbe;
        }

        return testPbe;
    }

    public static List<OpportunityLineItem> createOpportunityLineItems (Integer size, Id opptyId, Id pbeId, Boolean doInsert )
    {
        List<OpportunityLineItem> olisToreturn = new List<OpportunityLineItem>();

        for( Integer i = 0; i < size; i++ )
        {
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = opptyId;
            oli.PricebookEntryId = pbeId;
            oli.Quantity = 1;
            oli.TotalPrice = 0.00;
            olisToreturn.add(oli);
        }

        if( doInsert )
            insert olisToreturn;
        return olisToreturn;
    }
}