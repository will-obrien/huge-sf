public with sharing class CilantroGatewayAccess{
    
    public static List<Profile__c> profileList;
    public static List<Members__c> memberList;
    public static Map<String, String> mapMembers;    
    public static Boolean updateRecords = false;
    
    
    public Hopscotch getHopscotchPayLoad(String keyword){
        
        Hopscotch hopscotchClass;
        if (keyword.equals('perks')){
            String response = getHopscotchResponse('GET', System.Label.Hopscotch_URL);            
            JSONParser parser = JSON.createParser(response);       
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    hopscotchClass = (Hopscotch)parser.readValueAs(Hopscotch.class);
                    parser.skipChildren();
                }
            }
        }
        return hopscotchClass;
    }
    
    
    public void getOdysseyPayload(String userId, String category, String keyword){
        
        //http://52.38.33.176:8084/odyssey/v1/accounts/1234567800/link
        //http://52.38.33.176:8084/odyssey/v1/accounts/1234567800/messages
        
        String url = System.Label.Odyssey_URL + System.Label.Version + '/' + category + '/';
        String response = '';
        JSONParser parser;
        
        if (keyword.equals('messages')){
            url += userId + '/' + keyword;
            response = getCilantroResponse('GET', url);            
            response = response.replaceAll('"type"\\s*:', '"type_Z":');
            
            MessageClass messages;             
            parser = JSON.createParser(response);       
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    messages = (MessageClass)parser.readValueAs(MessageClass.class);
                    parser.skipChildren();
                }
            }            
            System.debug('*** MESSAGES *** ' +  messages);                      
            
        }else if (keyword.equals('link')){
            url += userId + '/' + keyword;
            response = getCilantroResponse('GET', url); 
            
            OdysseyLinkClass odysseyLink;
            parser = JSON.createParser(response);       
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    odysseyLink = (OdysseyLinkClass)parser.readValueAs(OdysseyLinkClass.class);
                    parser.skipChildren();
                }
            }
            System.debug('*** ODYSSEY LINK *** ' + odysseyLink);         
        }
    }
    
    public static String getHopscotchResponse(String method, String endPoints){    
        String response = '';   
        HttpRequest req = new HttpRequest(); 
        req.setMethod(method);        
        req.setHeader('ChannelId', System.Label.ChannelId);
        req.setHeader('DestinationId', System.Label.DestinationId);
        req.setHeader('DeviceId', System.Label.DeviceId);
        req.setHeader('AuthTime', System.Label.AuthTime);
        req.setHeader('Host', System.Label.Host);        
        //req.setHeader('user-agent', System.Label.user_agent);        
        req.setHeader('Content-Type', System.Label.Content_Type);           
        req.setHeader('alttkn', System.Label.alttkn);
        req.setEndPoint(endPoints);
        req.setTimeout(99999);
        
        try {        
            if (!Test.isRunningTest()){

                //Execute web service call here  
                Http http = new Http();                   
                HTTPResponse res = http.send(req);  
                
                //Helpful debug messages
                System.debug('*** STATUS *** ' + res.getStatus());
                System.debug('*** STATUS_CODE *** '+ res.getStatusCode());
                
                if (res.getStatusCode() == 404){
                    ErrorHandler e = new ErrorHandler(new ErrorClass('404', 'Not Found', ''));
                    response = JSON.serialize(e);
                }else{
                    response = res.getBody();
                    System.debug('*** RESPONSE BODY *** '+ response);
                }
            }
        } catch(System.CalloutException e) {
            System.debug('*** ERROR **** ' + e.getMessage());
        }            
        return response;
    }
    
    public void insertAccountLink(OdysseyLinkClass link){
        try{        
            //List<Odyssey_Link__c> odysseyLink = new List<Odyssey_Link__c>();
            //odysseyLink.add(new Odyssey_Link__c(Cilantro_Id__c=link));
        
        
        
        }catch(Exception e){
            System.debug('*** INSERT ACCOUNT LINK ERROR *** ' + e.getMessage());        
        }
    }
    
    
    
    public Boolean processData(String userId,  String category, String keyword){
    
        String url = System.Label.Cilantro_URI + '/' + System.Label.Version + '/' + category;
        String response = '';
    
        //GET <url>/v1/accounts?msisdn=639216581356
        //http://api.cloud.cilantro.xyz/v1/accounts/facebook%7C10206136796552758/usage
        //http://api.cloud.cilantro.xyz/v1/accounts/facebook|10153668655667988/messages
        //http://api.cloud.cilantro.xyz/v1/catalog/products
        //http://api.cloud.cilantro.xyz/v1/categories
        
     
        //INIT PROFILE REQUEST
        if (keyword.equals('msisdn')){
            url += '?' + keyword + '=' + userId;
            
            response = getCilantroResponse('GET', url);
            
            // REPLACE ALL DATE FIELDS ATTRIBUTE
            response = response.replaceAll('"date"\\s*:', '"udate":');
            
            JSONParser parser = JSON.createParser(response);
            
            System.debug('*** PROFILE RESPONSE *** ' + response);            
            
            //INSERT PROFILE
            AccountClass account;        
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    account = (AccountClass)parser.readValueAs(AccountClass.class);
                    parser.skipChildren();
                }
            }
           
            if (account != null){           
                try{
                    // INSERT PROFILE AND MEMBERS
                    processUserProfile('', account);
                
                    // INSERT USAGE
                    if (profileList.size() > 0){
                        getUsagePayload(false, userId, category, profileList.get(0).Id, profileList.get(0).Cilantro_ID__c, mapMembers);
                    }
                    
                    //INSERT MESSAGES
                    if (profileList.size() > 0){
                        getMessages(category, profileList.get(0).Cilantro_ID__c, profileList.get(0).Id);
                    
                    }
                    return true;
                }catch(Exception e){
                    System.debug('******** GATEWAY ACCESS ERROR ******** ' + e.getMessage());
                    return false;
                }            
            }    
        }
        
        if (keyword.equals('products')){
            System.debug('*** CILANTRO GET PRODUCTS ***');
            getProductPayLoad(url, keyword);       
        }
        
        if (category.equals('denominations')){
            getDenominationPayLoad(url);
        }
        
        if (category.equals('categories')){
            getCategoryPayLoad(url);
        }
        return false;
    }
    
    public void updateSubscribersRecord(String recordId, String userId,  String category, String keyword){
                
        String url = System.Label.Cilantro_URI + '/' + System.Label.Version + '/' + category;
        String response = '';
                
        if (keyword.equals('msisdn')){
            url += '?' + keyword + '=' + userId;
            
            response = getCilantroResponse('GET', url);
            
            // REPLACE ALL DATE FIELDS ATTRIBUTE
            response = response.replaceAll('"date"\\s*:', '"udate":');
            
            JSONParser parser = JSON.createParser(response);
            
            System.debug('*** PROFILE RESPONSE *** ' + response);            
            
            //INSERT PROFILE
            AccountClass account;        
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    account = (AccountClass)parser.readValueAs(AccountClass.class);
                    parser.skipChildren();
                }
            }
           
            if (account != null){           
                try{
                    // INSERT PROFILE AND MEMBERS
                    processUserProfile(recordId, account);
                
                    // INSERT USAGE
                    if (profileList.size() > 0){
                        getUsagePayload(true, userId, category, profileList.get(0).Id, profileList.get(0).Cilantro_ID__c, mapMembers);
                    }
                    
                    //INSERT MESSAGES
                    if (profileList.size() > 0){
                        getMessages(category, profileList.get(0).Cilantro_ID__c, profileList.get(0).Id);                    
                    }                    
                }catch(Exception e){
                    System.debug('******** GATEWAY ACCESS ERROR ******** ' + e.getMessage());
                }            
            }    
        }
        
        if (keyword.equals('products')){
            System.debug('*** CILANTRO GET PRODUCTS ***');
            getProductPayLoad(url, keyword);       
        }
        
        if (category.equals('denominations')){
            getDenominationPayLoad(url);
        }
        
        if (category.equals('categories')){
            getCategoryPayLoad(url);
        }
        
        
    }    
    
    
    @future(callout=true)
    public static void getMessages(String category, String cilantroId, String profile_id){
        String url = System.Label.Cilantro_URI + '/' + System.Label.Version + '/' + category;
        url += '/' + cilantroId + '/messages?limit=200';
        
        String response = getCilantroResponse('GET', url);     
        response = response.replaceAll('"type"\\s*:', '"type_Z":');
           
        JSONParser parser = JSON.createParser(response);
        
        MessageClass messages;        
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                messages = (MessageClass)parser.readValueAs(MessageClass.class);
                parser.skipChildren();
            }
        }
        
        insertMessages(messages, profile_id);    
    
    }
    
    public static void insertMessages(MessageClass messages, String profile_id){
    
        if (messages == null){
            return;
        }
    
        List<Message__c> messageList = new List<Message__c>();
        List<Message_Details__c> messageDetailList = new List<Message_Details__c>();
        
        if (messages.records != null &&  messages.records.size() > 0){
            for (MessageClass.Records r: messages.records){
                messageList.add(new Message__c(Profile__c=profile_id, Reference_Number__c=r.reference_number, Name__c=r.name, Message__c=r.message, Type__c=r.type_Z, Timestamp__c=Date.valueOf(r.timestamp)));
            } //for end
            
            insert messageList;            
            System.debug('*** MESSAGES *** ' + messageList); 
            
            // LOOP TO INSERT CHILD RECORDS
            for (Message__c m: messageList){
                for (MessageClass.Records r: messages.records){
                    if (m.Reference_Number__c == r.reference_number){
                        if (r.details != null && r.details.peso != null){
                            messageDetailList.add(new Message_Details__c(Type__c='peso', Message__c=m.Id, Display__c=r.details.peso.display, Expiration__c=r.details.peso.expiration));
                        }                        
                        if (r.details != null && r.details.open_data != null){
                            messageDetailList.add(new Message_Details__c(Type__c='open_data', Message__c=m.Id, Display__c=r.details.open_data.display, Expiration__c=r.details.open_data.expiration));
                        }                        
                        if (r.details != null && r.details.smart_life_data != null){
                            messageDetailList.add(new Message_Details__c(Type__c='smart_life_data', Message__c=m.Id, Display__c=r.details.smart_life_data.display, Expiration__c=r.details.smart_life_data.expiration));
                        }
                    }
                }
            }            
            insert messageDetailList;           
            System.debug('*** MESSAGE DETAILS *** ' + messageDetailList);            
        }
    }
    
    
    @future(callout=true)
    private static void getCategoryPayLoad(String url){    
        String response = getCilantroResponse('GET', url);        
        JSONParser parser = JSON.createParser(response);
    
        List<CategoryClass> categories;        
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                categories = (List<CategoryClass>)parser.readValueAs(List<CategoryClass>.class);
                parser.skipChildren();
            }
        }        
        insertCategoryData(categories);        
    }
        
    public static void insertCategoryData(List<CategoryClass> categories){
        try{
            if (categories == null)
                return;
        
            //PUT CODE HERE
        
        }catch(Exception e){
            System.debug('*** ERROR - INSERT CATEGORY DATA *** ' + e.getMessage());
        }
    }
    
    @future(callout=true)
    private static void getDenominationPayLoad(String url){
        
        String response = getCilantroResponse('GET', url);        
        JSONParser parser = JSON.createParser(response);
        
        DenominationClass denomination;        
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                denomination = (DenominationClass)parser.readValueAs(DenominationClass.class);
                parser.skipChildren();
            }
        }
        
        insertDenominationData(denomination);
    }
    
    
    public static void insertDenominationData(DenominationClass denomination){
        try{
            
            if (denomination == null) return;
        
            List<Denomination__c> denominationList = new List<Denomination__c>();
            denominationList.add(new Denomination__c(Unit__c=denomination.amount.unit, Value__c=integer.valueof(denomination.amount.value), Display__c=denomination.amount.display));
            insert denominationList;        
        
        }catch(Exception e){
            System.debug('*** ERROR - INSERT DENOMINATION *** ' + e.getMessage());
        }
    }
    
    
    public class DenominationObject{    
        public List<DenominationClass> denominationList {get; set;}    
        public DenominationObject(List<DenominationClass> denominationList){
            this.denominationList = denominationList;        
        }    
    }

    public void processUserProfile(String recordId, AccountClass account){
        //INIT PROFILE & MEMBERS
        profileList = new List<Profile__c>();
        memberList = new List<Members__c>();
        
        // INSERT PROFILE            
        Boolean isActivated = (account.profile.activated == 'true' ? true : false);
        Boolean isLoadProtected = (account.profile.load_protected  == 'true' ? true : false);
        
        if (String.isEmpty(recordId)){
            system.debug('*** INSERT NEW PROFILE ***');
            profileList.add(new Profile__c(Firstname__c=account.profile.first_name, Middlename__c=account.profile.middle_name, Lastname__c=account.profile.last_name, Activated__c=isActivated, Role__c=account.profile.role, Peso_Balance__c=account.balance.peso.display,  Load_Protected__c=isLoadProtected, Msisdn__c=account.profile.msisdn, Cilantro_ID__c=account.id, Email__c=''));    
            insert profileList;
        }else{
            system.debug('*** UPDATE PROFILE *** ' + recordId);
            profileList.add(new Profile__c(Id=recordId, Firstname__c=account.profile.first_name, Middlename__c=account.profile.middle_name, Lastname__c=account.profile.last_name, Activated__c=isActivated, Role__c=account.profile.role, Peso_Balance__c=account.balance.peso.display,  Load_Protected__c=isLoadProtected, Msisdn__c=account.profile.msisdn, Cilantro_ID__c=account.id, Email__c=account.profile.email));         
            update profileList;
        }
                
        if (String.isEmpty(recordId)){
            // INSERT MEMBERS
            for(MemberClass m: account.members){
                system.debug('*** MEMBERS *** '+ m);        
                isActivated = (m.profile.activated == 'true' ? true : false);        
                memberList.add(new Members__c(Profile__c=profileList.get(0).Id ,Activated__c=isActivated, Firstname__c=m.profile.first_name, Lastname__c=m.profile.last_name, MSISDN__c=m.profile.msisdn));
            }
            insert memberList;        
        }else{        
            updateMembers(profileList, account.members);            
        }
        
        if (memberList.size() > 0){
            // initialize members
            mapMembers = new Map<String, String>();
            for (Members__c m :memberList){
                mapMembers.put(m.MSISDN__c, m.Id);
            }
        }
    }
    
    private void updateMembers(List<Profile__c> myProfile, List<MemberClass> members){
        List<Members__c> memberListing = new List<Members__c>();
        List<Members__c> myMembers = [SELECT Id, MSISDN__c FROM Members__c WHERE Profile__c =:myProfile.get(0).Id];
        Boolean isActivated = myProfile.get(0).Activated__c;
        Boolean isLoadProtected = myProfile.get(0).Load_Protected__c;
        
        for(MemberClass m1:members){
            for (Members__c m2: myMembers){
                if (m1.profile.msisdn == m2.MSISDN__c){
                    memberListing.add(new Members__c(Id=m2.Id ,Activated__c=isActivated, Role__c=m1.profile.role, Firstname__c=m1.profile.first_name, Lastname__c=m1.profile.last_name, MSISDN__c=m1.profile.msisdn));
                }            
            }        
        }
        
        if (memberListing.size() > 0) update memberListing;
    }
    
    
    @future(callout=true)
    private static void getProductPayLoad(String url, String keyword){
        //http://api.cloud.cilantro.xyz/v1/catalog/products            
        
            url += '/' + keyword+'?limit=100';
            
            String response = getCilantroResponse('GET', url);
            
            // REPLACE ALL DATE AND LIMIT FIELDS ATTRIBUTE
            response = response.replaceAll('"limit"\\s*:', '"limits":');
            response = response.replaceAll('"null"\\s*', '""');
            
            JSONParser parser = JSON.createParser(response);
            
            System.debug('*** PRODUCT RESPONSE *** ' + response);            
            
            //GET PRODUCTS
            ProductClass product;        
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    product = (ProductClass)parser.readValueAs(ProductClass.class);
                    parser.skipChildren();
                }
            }
        
            insertProductData(product);
    }
    
    public static void insertProductData(ProductClass product){
        try{     
        
            if (product == null)
                return;
        
            System.debug('*** PRODUCTS *** ' + product.records.size());
                    
            List<Product__c> listProduct = [SELECT Id, Id__c, Category_Id__c, Description__c, Image_Url__c, Name__c, 
                                            Open_Access_Data_Allowance__c, Open_Access_Data_Validity__c,
                                            SmartLife_Data_Display__c, SmartLife_Data_Unit__c,
                                            SmartLife_Data_Validity__c, SmartLife_Data_Value__c, Unit__c, Value__c FROM Product__c];
            
            if (listProduct.size() == 0){                                
                String open_data_display = '';
                String open_data_validity = '';
                
                List<ProductClass.RecordClass> recordList = product.records;   
                             
                for(ProductClass.RecordClass r: recordList){                                               
                    open_data_display = (r.data_plan.open_data == null? '':r.data_plan.open_data.display);
                    open_data_validity = (r.data_plan.open_data == null? '':r.data_plan.open_data.validity);
                    
                    listProduct.add(new Product__c(Id__c=r.id, Description__c=r.description, Category_Id__c=r.category, Image_Url__c=r.image_url,   
                                                   Open_Access_Data_Allowance__c=open_data_display,
                                                   Open_Access_Data_Validity__c=open_data_validity,  
                                                   Name__c=r.name, Unit__c=r.amount.unit, 
                                                   Value__c=Decimal.valueOf(r.amount.value),                
                                                   SmartLife_Data_Display__c=r.data_plan.smart_life_data.display, 
                                                   SmartLife_Data_Unit__c=r.data_plan.smart_life_data.unit,
                                                   SmartLife_Data_Validity__c=r.data_plan.smart_life_data.validity, 
                                                   SmartLife_Data_Value__c=r.data_plan.smart_life_data.value));                                                                                                            
                }
                System.debug('*** LIST OF PRODUCTS *** ' + listProduct);                      
                insert listProduct;
            }            
        }catch(Exception e){
            System.debug('*** ERROR - INSERT PRODUCT DATA *** ' + e.getMessage());        
        }
    }
    
    @future(callout=true)
    public static void getUsagePayload(Boolean isUpdate, String userId, String category, String profileId, String cilantroId, Map<String, String> members){
        String url = System.Label.Cilantro_URI + '/' + System.Label.Version + '/' + category;
        url += '/' + cilantroId + '/usage';
    
        String response = getCilantroResponse('GET', url);        
        
        // REPLACE ALL DATE FIELDS ATTRIBUTE
        response = response.replaceAll('"date"\\s*:', '"udate":');
        
        JSONParser parser = JSON.createParser(response);

        System.debug('*** USAGE RESPONSE *** ' + response);
        System.debug('*** PROFILE ID *** ' + profileId);
        
        // PARSE JSON RESPONSE
        UsageObjectClass usage;        
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                usage = (UsageObjectClass)parser.readValueAs(UsageObjectClass.class);
                parser.skipChildren();
            }
        }
        
        //INSERT USAGE DATA HERE....
        insertUsageData(isUpdate, profileId, members, usage);
        
        
    }
    
    
    private static void updateSharedOpenDataSummary(String id, UsageObjectClass usage){
        List<Shared_Open_Data__c> ids = [SELECT Id FROM  Shared_Open_Data__c WHERE Profile__c =:id];
        List<Shared_Open_Data__c> sharedOpenDataSummary = new List<Shared_Open_Data__c>();
        
        sharedOpenDataSummary.add(new Shared_Open_Data__c(Id=ids.get(0).Id,Total_Value__c=Decimal.valueOf(usage.shared.open_data.total.value), Total_Unit__c=usage.shared.open_data.total.unit, Total_Expiration__c=usage.shared.open_data.total.expiration,  
                                                          Total_Display__c=usage.shared.open_data.total.display, Total_Date__c=Date.valueOf(usage.shared.open_data.total.udate),                                                           
                                                          Balance_Value__c=Decimal.valueOf(usage.shared.open_data.balance.value), Balance_Unit__c=usage.shared.open_data.balance.unit, Balance_Expiration__c=usage.shared.open_data.balance.expiration,  
                                                          Balance_Display__c=usage.shared.open_data.balance.display, Balance_Date__c=Date.valueOf(usage.shared.open_data.balance.udate),
                                                          Profile__c=id));
        update sharedOpenDataSummary;        
        system.debug('*** update sharedOpenDataSummary *** ' + sharedOpenDataSummary);
    }
    
    
    public static void insertUsageData(Boolean isUpdate, String profileId, Map<String, String> members, UsageObjectClass usage){
        try{
            
            if (usage == null)
                return;
                            
            // ********************************** SUMMARY ***************************************                    
            List<Shared_Open_Data__c> sharedOpenDataSummary = new List<Shared_Open_Data__c>();
            
            if (isUpdate){
                updateSharedOpenDataSummary(profileId, usage);                            
            }else{                   
                sharedOpenDataSummary.add(new Shared_Open_Data__c(Total_Value__c=Decimal.valueOf(usage.shared.open_data.total.value), Total_Unit__c=usage.shared.open_data.total.unit, Total_Expiration__c=usage.shared.open_data.total.expiration,  
                                                                  Total_Display__c=usage.shared.open_data.total.display, Total_Date__c=Date.valueOf(usage.shared.open_data.total.udate),                                                           
                                                                  Balance_Value__c=Decimal.valueOf(usage.shared.open_data.balance.value), Balance_Unit__c=usage.shared.open_data.balance.unit, Balance_Expiration__c=usage.shared.open_data.balance.expiration,  
                                                                  Balance_Display__c=usage.shared.open_data.balance.display, Balance_Date__c=Date.valueOf(usage.shared.open_data.balance.udate),
                                                                  Profile__c=profileId));
                insert sharedOpenDataSummary;
            }
            
            List<Shared_Smart_Life_Data__c> sharedSmartLifeDataSummary = new List<Shared_Smart_Life_Data__c>();
            sharedSmartLifeDataSummary.add(new Shared_Smart_Life_Data__c(Total_Value__c=Decimal.valueOf(usage.shared.smart_life_data .total.value), Total_Unit__c=usage.shared.smart_life_data.total.unit, Total_Expiration__c=usage.shared.smart_life_data.total.expiration,  
                                                                         Total_Display__c=usage.shared.smart_life_data.total.display, Total_Date__c=Date.valueOf(usage.shared.smart_life_data.total.udate),                                                           
                                                                         Balance_Value__c=Decimal.valueOf(usage.shared.smart_life_data.balance.value), Balance_Unit__c=usage.shared.smart_life_data.balance.unit, Balance_Expiration__c=usage.shared.smart_life_data.balance.expiration,  
                                                                         Balance_Display__c=usage.shared.smart_life_data.balance.display, Balance_Date__c=Date.valueOf(usage.shared.smart_life_data.balance.udate),
                                                                         Profile__c=profileId));
            if (updateRecords){
                update sharedSmartLifeDataSummary;
                system.debug('*** update sharedSmartLifeDataSummary ***');
            }else{
                insert sharedSmartLifeDataSummary;
            }
                        
            // ************************************* TRANSACTIONS ***************************************
            List<Shared_Open_Transaction__c> sharedOpenTransactionList = new List<Shared_Open_Transaction__c>();
            List<Shared_Smart_Life_Transaction__c> sharedSmartLifeTransactionList = new List<Shared_Smart_Life_Transaction__c>();
            
            System.debug('*** OPEN DATA SUBSCRIBERS *** ' + usage.shared.open_data.subscribers.size());
            
            // CHECK IF MEMBER OBJECT HAVE VALUES
            if (members != null && members.size() > 0){  
            
                // ************************************* OPEN SHARED ***************************************
                if (sharedOpenDataSummary.size() > 0){   
                    Id openDataSummaryId = sharedOpenDataSummary.get(0).Id;    
                    for(SubscribersClass s: usage.shared.open_data.subscribers){
                        Id membersId = members.get(s.msisdn);
                        
                        System.debug('*** MEMBER ID *** ' + membersId); 
                        
                        if (membersId == null){
                            continue;
                        }
                        
                        // COLLECT ALL USAGE INFORMATIONS
                        sharedOpenTransactionList.add(new Shared_Open_Transaction__c(Shared_Open_Data__c=openDataSummaryId, Profile__c=profileId, Members__c=membersId, 
                                                                                     Unit__c=s.usage.unit, Value__c=Decimal.valueOf(s.usage.value), Display__c=s.usage.display, 
                                                                                     Date__c=Date.valueOf(s.usage.udate)));
                    }
                    
                    if (updateRecords){
                        update sharedOpenTransactionList;
                        system.debug('*** update sharedOpenTransactionList ***');
                    }else{
                        insert sharedOpenTransactionList;                    
                    }
                }
                
                // ************************************* SMART LIFE SHARED ***************************************
                
                if (sharedSmartLifeDataSummary.size() > 0){   
                    Id smartLifeSummaryId = sharedSmartLifeDataSummary.get(0).Id;    
                    for(SubscribersClass s: usage.shared.smart_life_data.subscribers){
                        Id membersId = members.get(s.msisdn);
                        
                        System.debug('*** MEMBER ID *** ' + membersId); 
                        
                        if (membersId == null){
                            continue;
                        }
                        
                        // COLLECT ALL USAGE INFORMATIONS
                        sharedSmartLifeTransactionList.add(new Shared_Smart_Life_Transaction__c(Shared_Smart_Life_Data__c=smartLifeSummaryId, Profile__c=profileId, Members__c=membersId, 
                                                                                                Unit__c=s.usage.unit, Value__c=Decimal.valueOf(s.usage.value), Display__c=s.usage.display, 
                                                                                                Date__c=Date.valueOf(s.usage.udate)));
                    }
                    
                    if (updateRecords){
                        system.debug('*** update sharedSmartLifeTransactionList ***');
                        update sharedSmartLifeTransactionList;
                    }else{
                        insert sharedSmartLifeTransactionList;
                    }
                }
            }
            
            
            // ************************************* PERSONAL DATA ***************************************
            
            System.debug('*** PERSONAL DATA *** ' + usage.personal);
            
            // INSERT PERSONAL OPEN DATA
            if (usage.personal != null && usage.personal.open_data != null){
                List<Personal_Open_Data__c> openData = new List<Personal_Open_Data__c>();
                openData.add(new Personal_Open_Data__c(Profile__c=profileId, Balance_Display__c=usage.personal.open_data.balance.display, Balance_Expiration__c=usage.personal.open_data.expiration));
                
                if (updateRecords){
                    system.debug('*** update openData ***');
                    update openData;
                }else{
                    insert openData;
                }
            }
                        
            // INSERT PERSONAL SMART LIFE DATA
            if (usage.personal != null && usage.personal.smart_life_data != null){
                List<Personal_SmartLife_Data__c> smartLifeData = new List<Personal_SmartLife_Data__c>();
                smartLifeData.add(new Personal_SmartLife_Data__c(Profile__c=profileId, Balance_Display__c=usage.personal.smart_life_data.balance.display, Balance_Expiration__c=usage.personal.smart_life_data.expiration));
                
                if (updateRecords){
                    system.debug('*** update smartLifeData ***');
                    update smartLifeData;
                }else{
                    insert smartLifeData;
                }
            }
            
            // INSERT BOOSTER            
            if (usage.personal != null && usage.personal.boosters != null){
                List<Personal_Booster_Data__c> personalBooster = new List<Personal_Booster_Data__c>();
                
                for(Personal_BoosterClass booster :usage.personal.boosters){            
                    personalBooster.add(new Personal_Booster_Data__c(Profile__c=profileId, Name__c=booster.name, Balance_Display__c=booster.balance.display, Balance_Expiration__c=booster.expiration));
                }
                
                if (updateRecords){
                    system.debug('*** update personalBooster ***');                    
                    update personalBooster;
                }else{
                    insert personalBooster;
                }                
            }
            
            // INSERT CATEGORIES
            List<Personal_Categories__c> personalCategoriesList = new List<Personal_Categories__c>();
            List<Personal_Category_Details__c> personalCategoryDetails = new List<Personal_Category_Details__c>();            
            Map<String, List<Personal_Category_Details__c>> mapCollectedDetails = new Map<String, List<Personal_Category_Details__c>>();
            
            for(CategoriesClass c: usage.personal.categories){
                personalCategoriesList.add(new Personal_Categories__c(Profile__c=profileId, Category_Name__c=c.category_name, Color_Name__c=c.color_name));
                
                for(DateClass d: c.dates){ 
                    personalCategoryDetails.add(new Personal_Category_Details__c(Profile__c=profileId, Category_Type__c=c.category_name, Date__c=Date.valueOf(d.udate)+1, Display__c=d.usage.display, Unit__c=d.usage.unit, Value__c=Decimal.valueOf(d.usage.value)));
                }                                
                mapCollectedDetails.put(c.category_name, personalCategoryDetails);                
            } 
            
            // PUSH TO SALESFORCE
            if (updateRecords){
                system.debug('*** update personalCategoriesList ***');               
                update personalCategoriesList;
            }else{
                insert personalCategoriesList;            
            }        
            
            List<Personal_Category_Details__c> bulkCategoryDetails = new List<Personal_Category_Details__c>();
            if (personalCategoriesList.size() > 0){        
                //loop on categories object to get the SF Id then initialize it on the category details
                for(Personal_Categories__c c: personalCategoriesList){
                    List<Personal_Category_Details__c> p1 = mapCollectedDetails.get(c.Category_Name__c);
                    for(Personal_Category_Details__c p2: p1){
                        if (p2.Category_Type__c == c.Category_Name__c){
                            bulkCategoryDetails.add(new Personal_Category_Details__c(Personal_Categories__c=c.Id, Profile__c=p2.Profile__c, Category_Type__c=p2.Category_Type__c, Date__c=p2.Date__c, Display__c=p2.Display__c, Unit__c=p2.Unit__c, Value__c=p2.Value__c));            
                        }                        
                    }            
                }
            }
            
            // insert category details here...
            if (updateRecords){
                system.debug('*** update bulkCategoryDetails ***');                  
                update bulkCategoryDetails;
            }else{
                insert bulkCategoryDetails;
            }
            
            System.debug('*** PERSONAL CATEGORY DETAILS *** ' + bulkCategoryDetails);
        }catch(Exception e){
            System.debug('*** ERROR - INSERT USAGE DATA *** ' + e.getMessage());        
        }
    }
    
    public static String getCilantroResponse(String method, String endPoints){    
        String response = '';   
        HttpRequest req = new HttpRequest(); 
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json');           
        req.setEndPoint(endPoints);
        req.setTimeout(99999);
        
        try {        
            if (!Test.isRunningTest()){

                //Execute web service call here  
                Http http = new Http();                   
                HTTPResponse res = http.send(req);  
                
                //Helpful debug messages
                System.debug('*** STATUS *** ' + res.getStatus());
                System.debug('*** STATUS_CODE *** '+ res.getStatusCode());
                
                if (res.getStatusCode() == 404){
                    ErrorHandler e = new ErrorHandler(new ErrorClass('404', 'Not Found', ''));
                    response = JSON.serialize(e);
                }else{
                    response = res.getBody();
                    System.debug('*** RESPONSE BODY *** '+ response);
                }
            }
        } catch(System.CalloutException e) {
            System.debug('*** ERROR **** ' + e.getMessage());
        }            
        return response;
    }
    
   
   public class CategoryClass{   
       public String id {get; set;}
       public String name  {get; set;}
       public String description {get; set;}
       public String image_url {get; set;}
   
       public CategoryClass(String id, String name, String description, String image_url){
           this.id = id;
           this.name = name;
           this.description = description;
           this.image_url = image_url;
       }
   }
   
   
   

}