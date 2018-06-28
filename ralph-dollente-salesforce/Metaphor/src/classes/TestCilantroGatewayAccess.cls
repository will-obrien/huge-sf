@isTest(seeAllData=false)
global class TestCilantroGatewayAccess{
    private static Shared_Open_Data__c shared_open_data;
    private static Profile__c profile;
    private static List<CilantroGatewayAccess.CategoryClass> categoryList;
    private static AccountClass account;
    private static ProfileClass profileClass;
    private static BalanceClass balanceClass;
    private static PesoClass pesoClass;
    private static OpenDataClass openDataClass;
    private static SmartLifeDataClass smartLifeDataClass;
    private static ErrorClass errorClass;
    private static List<MemberClass> memberList;
    private static ProductClass productClass;
    private static List<RecordClass> records;
    private static DetailClass detailClass;    
    private static UsageObjectClass usageClass;    
    
    @IsTest
    public static void testCilantroGatewayAccess(){
    
        Id ProfileID = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User u = [Select Id From User Where ProfileId = :ProfileID AND IsActive = true LIMIT 1];
        
        System.runAs(u){
            //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            
            List<DenominationClass> d1 = new List<DenominationClass>();
            CilantroGatewayAccess.DenominationObject d2 = new CilantroGatewayAccess.DenominationObject(d1);
            CilantroGatewayAccess.CategoryClass c2 = new CilantroGatewayAccess.CategoryClass('','','','');
            
            CilantroGatewayAccess c1 = new CilantroGatewayAccess();            
            c1.processData('639490145060', 'accounts', 'msisdn');            
            c1.processData('','catalog','products');
            c1.processData('','denominations','');
            c1.processData('','categories','');           
                
            setTestData();
            
            c1.processUserProfile(account);
            
            Map<String, String> members = new Map<String, String>();
            members.put('123', '123'); 
            
            CilantroGatewayAccess.insertCategoryData(categoryList);
            CilantroGatewayAccess.insertDenominationData(new DenominationClass('123','100', new AmountClass('100','100','100')));
            CilantroGatewayAccess.insertProductData(productClass);
            CilantroGatewayAccess.insertUsageData(String.valueOf(profile.Id), members, usageClass);
            CilantroGatewayAccess.getUsagePayload(String.valueOf(profile.Id), 'usage', String.valueOf(profile.Id), '123242', members);               
                           
                           
        }
    
    }
    
    
    private static void setTestData(){
    
        profile = new Profile__c(Activated__c=true, Cilantro_ID__c='1234567890', Email__c='test@salesforce.com', Firstname__c='test', Lastname__c='test', Load_Protected__c=true,
                                 Middlename__c='test', MSISDN__c='1234567890', Peso_Balance__c='100', Role__c='Primary', Service_Type__c='Prepaid', Status__c='Activated');
        insert profile;
        
        shared_open_data = new Shared_Open_Data__c(Profile__c=profile.Id, Total_Date__c=Date.Today(), Balance_Date__c=Date.Today(), Balance_Display__c='1MB', 
                                                   Balance_Expiration__c='100', Balance_Unit__c='100', Balance_Value__c=200, Total_Value__c=100, 
                                                   Total_Unit__c='100', Total_Expiration__c='100', Total_Display__c='1MB');
        insert shared_open_data;
        
        categoryList = new List<CilantroGatewayAccess.CategoryClass>();        
        categoryList.add(new CilantroGatewayAccess.CategoryClass('898wwwiiksf', 'TEST', 'TEST', 'https://test.com'));
        
        profileClass = new ProfileClass('ALPHA','B','TANGO','1234567890','Primary','true','true','1000','SmartBro','test@salesforce.com', '');
        
        pesoClass = new PesoClass('100','100','100');
        openDataClass = new OpenDataClass('100','100','100');
        smartLifeDataClass = new SmartLifeDataClass('100','100','100');
        errorClass = new ErrorClass('INFO','TEST','INFO');
        
        balanceClass = new BalanceClass(pesoClass, openDataClass, smartLifeDataClass, errorClass);
        
        memberList = new List<MemberClass>();
        memberList.add(new MemberClass(profileClass));
        
        account = new AccountClass('123456', profileClass, balanceClass, errorClass, memberList);
        detailClass = new DetailClass('8888', '123', new DetailClass.BalanceClass('100','100'));
        
        records = new List<RecordClass>();
        records.add(new RecordClass('1', '123', 'TEST', 'TEST101', 'TEST DATA', detailClass, '8:00AM'));
        
        ProductClass.AmountClass amountClass = new ProductClass.AmountClass('100','100');
        
        ProductClass.OpenDataPlanClass openDataPlanClass = new ProductClass.OpenDataPlanClass('300','300','1day', new List<String>(),'100MB');
        ProductClass.SmartLifeDataPlanClass smartLifeDataPlanClass = new ProductClass.SmartLifeDataPlanClass('300','300','1day', new List<String>(),'100MB');
        ProductClass.DataPlanClass dataPlanClass = new ProductClass.DataPlanClass(openDataPlanClass, smartLifeDataPlanClass);
        
        ProductClass.RecordClass recordClass = new ProductClass.RecordClass('','','',amountClass,'','',dataPlanClass);
        List<ProductClass.RecordClass> myRecord = new List<ProductClass.RecordClass>();
        myRecord.add(recordClass);
        
        productClass = new ProductClass('1000', '1', '200', myRecord);      
          
        Shared_UsageClass sharedUsageClass = new Shared_UsageClass('2015-12-03T09:30:02.879803+08:00','100','100','100');        
        SubscribersClass subscriberClass = new SubscribersClass('Primary','123456', sharedUsageClass);
        
        
        List<DateClass> dateList = new List<DateClass>();
        dateList.add(new DateClass('2015-12-03T09:30:02.879803+09:00', new Personal_UsageClass('100','100','100')));
        dateList.add(new DateClass('2015-12-03T09:30:02.879803+08:00', new Personal_UsageClass('200','200','200')));
        
        CategoriesClass categoriesClass = new CategoriesClass('TEST','ORANGE',dateList);
        
        List<CategoriesClass> myCategoryList = new List<CategoriesClass>();
        myCategoryList.add(categoriesClass);
                
        Personal_BalanceClass personal_BalanceClass = new Personal_BalanceClass('2015-12-03T09:30:02.879803+08:00','100','100','100');        
        Personal_BoosterClass personal_BoosterClass = new Personal_BoosterClass('TEST','IMGTEST','1day', personal_BalanceClass);        
        Personal_PesoClass personal_PesoClass = new Personal_PesoClass('2015-12-03T09:30:02.879803+08:00', personal_BalanceClass);
        Personal_OpenDataClass personal_OpenDataClass = new Personal_OpenDataClass('2015-12-03T09:30:02.879803+08:00', personal_BalanceClass);
        Personal_SmartLifeDataClass personal_SmartLifeDataClass = new Personal_SmartLifeDataClass('2015-12-03T09:30:02.879803+08:00', personal_BalanceClass);
                
        List<Personal_BoosterClass> personalBoosterList = new List<Personal_BoosterClass>();
        personalBoosterList.add(personal_BoosterClass);
        
        List<SubscribersClass> subscribersList = new List<SubscribersClass>();
        subscribersList.add(subscriberClass);
                
        Shared_BalanceClass sharedBalanceClass = new Shared_BalanceClass('2015-12-03T09:30:02.879803+08:00','100','100','100','1day');
        TotalClass totalClass = new TotalClass('2015-12-03T09:30:02.879803+08:00','100','100','100','1day');
        
        Shared_OpenDataClass sharedOpenDataClass = new Shared_OpenDataClass(subscribersList, totalClass, sharedBalanceClass);                
        UsageObjectClass.Shared_SmartLifeDataClass shared_SmartLifeDataClass = new UsageObjectClass.Shared_SmartLifeDataClass(subscribersList, totalClass, sharedBalanceClass);
        
        UsageObjectClass.SharedClass sharedClass = new UsageObjectClass.SharedClass(sharedOpenDataClass, shared_SmartLifeDataClass);       
        
        UsageObjectClass.PersonalClass personalClass = new UsageObjectClass.PersonalClass(myCategoryList, personalBoosterList, personal_PesoClass, personal_OpenDataClass, personal_SmartLifeDataClass);
        
        usageClass = new UsageObjectClass(sharedClass, personalClass);
    }
}