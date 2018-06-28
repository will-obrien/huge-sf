@isTest(seeAllData=true)
global class TestMainController{
    private static List<Profile__c>  profile;
    private static List<Members__c> members;
    private static List<Shared_Open_Data__c> sharedOpen;
    private static List<Shared_Smart_Life_Data__c> sharedSmartLife;
    private static List<Personal_Open_Data__c> personalOpen;
    private static List<Personal_SmartLife_Data__c> personalSmartLife;
    private static List<Personal_Booster_Data__c> personalBooster;
    private static List<Denomination__c> denomination;
    private static List<Shared_Open_Transaction__c> sharedOpenTransaction;
    private static List<Categories__c> categories;
    private static List<Product__c> product;    
    private static List<Personal_Category_Details__c> personalCategoryDetails;
    private static List<Personal_Categories__c> personalCategories;
    
    static testMethod void testMainController(){
        Id ProfileID = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User u = [Select Id From User Where ProfileId = :ProfileID AND IsActive = true LIMIT 1];
        
        System.runAs(u){
        
            insertTestData();
            
            ApexPages.currentPage().getParameters().put('id', profile.get(0).MSISDN__c); 
            
            MainController.ProductClass p1 = new MainController.ProductClass('','','','','','','','','','');
            MainController.ResultSet rs = new MainController.ResultSet(String.valueOf(profile.get(0).Id),'','','','','','','','');
        
            MainController mc = new MainController(); 
            mc.init(); 
            mc.searchedRecordId = String.valueOf(profile.get(0).MSISDN__c);
            mc.searchValue = String.valueOf(profile.get(0).MSISDN__c);
            mc.openDataDetailClass = new SharedOpenDataDetailClass('','','','','');
            mc.productBigBytes = new List<MainController.HolderClass>();
            mc.productBigBytes.add(new MainController.HolderClass('','','','','',''));            
            mc.detailClass = new List<BalanceDetailClass>();   
            mc.initProfile();
            mc.getMembers();
            mc.getUserBalance();
            mc.getSharedBalance();
            mc.getBalanceDetails();
        }
    }
    
    static testMethod void testSearchByEmailAddress(){
        Profile p = [select id from profile where name='Marketing User'];
        User u1 = null;
        if (p != null){
            String timestamp = String.valueOf(System.now().getTime());
            String testEmail = 'mrktuser' + timestamp + '@test.com';
            u1 = new User(alias = 'standt', email=testEmail,
                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                 localesidkey='en_US', profileid = p.Id,
                 timezonesidkey='America/Chicago', username=testEmail);
        }
        
        System.runAs(u1){
            insertTestData();
            ApexPages.currentPage().getParameters().put('id', profile.get(0).Email__c);             
            MainController.ProductClass p1 = new MainController.ProductClass('','','','','','','','','','');
            MainController.ResultSet rs = new MainController.ResultSet(new Profile__c());
            MainController.UserProfileClass upc = new MainController.UserProfileClass(new Profile__c());
        
            MainController mc = new MainController();  
            mc.init();
            mc.searchedRecordId = String.valueOf(profile.get(0).MSISDN__c);
            mc.searchValue = String.valueOf(profile.get(0).MSISDN__c);
            mc.openDataDetailClass = new SharedOpenDataDetailClass('','','','','');
            mc.productBigBytes = new List<MainController.HolderClass>();
            mc.productBigBytes.add(new MainController.HolderClass('','','','','',''));            
            mc.detailClass = new List<BalanceDetailClass>();            
            mc.initProfile();
            mc.getMembers();
            mc.getUserBalance();
            mc.getSharedBalance();
            mc.getBalanceDetails();
            
            MainController.getRecords('123456');
        }
    }
    
    static testMethod void testSearchByName(){
        Profile p = [select id from profile where name='Marketing User'];
        User u1 = null;
        if (p != null){
            String timestamp = String.valueOf(System.now().getTime());
            String testEmail = 'mrktuser' + timestamp + '@test.com';
            u1 = new User(alias = 'standt', email=testEmail,
                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                 localesidkey='en_US', profileid = p.Id,
                 timezonesidkey='America/Chicago', username=testEmail);
        }
        
        System.runAs(u1){
            insertTestData();
            ApexPages.currentPage().getParameters().put('id', profile.get(0).Lastname__c); 
            
            MainController.ProductClass p1 = new MainController.ProductClass('','','','','','','','','','');
            MainController.ResultSet rs = new MainController.ResultSet(new Profile__c());
            MainController.UserProfileClass upc = new MainController.UserProfileClass(new Profile__c());

            MainController mc = new MainController();  
            mc.init();
            mc.searchedRecordId = String.valueOf(profile.get(0).MSISDN__c);
            mc.searchValue = String.valueOf(profile.get(0).MSISDN__c);
            mc.openDataDetailClass = new SharedOpenDataDetailClass('','','','','');
            mc.productBigBytes = new List<MainController.HolderClass>();
            mc.productBigBytes.add(new MainController.HolderClass('','','','','',''));            
            mc.detailClass = new List<BalanceDetailClass>();            
            mc.initProfile();
            mc.getMembers();
            mc.getUserBalance();
            mc.getSharedBalance();
            mc.getBalanceDetails();
            mc.getUserInfo('xyz');                       
            
            MainController.getRecords('123456');            
            MainController.getUserDashboardData(mc.searchedRecordId);
            MainController.getUserDashboardByMonth(mc.searchedRecordId, '01/01/2016', '12/01/2016');
            MainController.getUserDashboardDataByRange(mc.searchedRecordId, '01/01/2016', '12/01/2016');
            MainController.getUserDashboardUsageBalances(mc.searchedRecordId);
        }
    }
    
    private static void insertTestData(){    
        profile = new List<Profile__c>();
        profile.add(new Profile__c(Role__c='Primary', MSISDN__c='123456', Lastname__c='AAA', Firstname__c='BBB', Email__c='test1@salesforce.com', Activated__c=true));
        profile.add(new Profile__c(Role__c='Supplemental', MSISDN__c='7890', Lastname__c='CCC', Firstname__c='DD', Email__c='test2@salesforce.com', Activated__c=false));        
        insert profile;
        
        members = new List<Members__c>();
        members.add(new Members__c(Profile__c=profile.get(0).Id, Role__c='Supplemental', MSISDN__c='111', Lastname__c='POLI', Firstname__c='CARPIO', Activated__c=true));
        members.add(new Members__c(Profile__c=profile.get(1).Id, Role__c='Primary', MSISDN__c='123456', Lastname__c='AAA', Firstname__c='BBB', Activated__c=true));
        insert members;
        
        sharedOpen = new List<Shared_Open_Data__c>();
        sharedOpen.add(new Shared_Open_Data__c(Balance_Display__c='1KB', Balance_Expiration__c='12/2/2015 4:00 PM', Profile__c=profile.get(0).Id));
        sharedOpen.add(new Shared_Open_Data__c(Balance_Display__c='2KB', Balance_Expiration__c='12/3/2015 4:00 PM', Profile__c=profile.get(1).Id));
        insert sharedOpen;
        
        sharedSmartLife = new List<Shared_Smart_Life_Data__c>();
        sharedSmartLife.add(new Shared_Smart_Life_Data__c(Balance_Display__c='20KB', Balance_Expiration__c='12/4/2015 4:00 PM', Profile__c=profile.get(0).Id)); 
        sharedSmartLife.add(new Shared_Smart_Life_Data__c(Balance_Display__c='25KB', Balance_Expiration__c='12/5/2015 4:00 PM', Profile__c=profile.get(1).Id)); 
        insert sharedSmartLife;
        
        personalOpen = new List<Personal_Open_Data__c>(); 
        personalOpen.add(new Personal_Open_Data__c(Balance_Display__c='40KB', Balance_Expiration__c='12/6/2015 4:00 PM', Profile__c=profile.get(0).Id));
        personalOpen.add(new Personal_Open_Data__c(Balance_Display__c='45KB', Balance_Expiration__c='12/7/2015 4:00 PM', Profile__c=profile.get(1).Id));
        insert personalOpen;
    
        personalSmartLife = new List<Personal_SmartLife_Data__c>();
        personalSmartLife.add(new Personal_SmartLife_Data__c(Balance_Display__c='50KB', Balance_Expiration__c='12/8/2015 4:00 PM', Profile__c=profile.get(0).Id));
        personalSmartLife.add(new Personal_SmartLife_Data__c(Balance_Display__c='55KB', Balance_Expiration__c='12/9/2015 4:00 PM', Profile__c=profile.get(1).Id));
        insert personalSmartLife;
    
        sharedOpenTransaction = new List<Shared_Open_Transaction__c>();
        sharedOpenTransaction.add(new Shared_Open_Transaction__c(Shared_Open_Data__c=sharedOpen.get(0).Id, Date__c=Date.Today(), Display__c='100', Profile__c=profile.get(0).Id, Unit__c='1KB', Value__c=100));
        sharedOpenTransaction.add(new Shared_Open_Transaction__c(Shared_Open_Data__c=sharedOpen.get(1).Id, Date__c=Date.Today(), Display__c='200', Profile__c=profile.get(1).Id, Unit__c='1KB', Value__c=200));
        insert sharedOpenTransaction;
    
        personalBooster = new List<Personal_Booster_Data__c>();
        personalBooster.add(new Personal_Booster_Data__c(Balance_Display__c='60KB', Balance_Expiration__c='12/10/2015 4:00 PM', Profile__c=profile.get(0).Id));
        personalBooster.add(new Personal_Booster_Data__c(Balance_Display__c='65KB', Balance_Expiration__c='12/11/2015 4:00 PM', Profile__c=profile.get(1).Id));
        insert personalBooster;
                
        denomination = new List<Denomination__c>(); 
        denomination.add(new Denomination__c(Display__c='100', Unit__c='100', Value__c=100));
        denomination.add(new Denomination__c(Display__c='200', Unit__c='200', Value__c=200));
        denomination.add(new Denomination__c(Display__c='300', Unit__c='300', Value__c=300));
        insert denomination;
        
        categories = new List<Categories__c>();
        categories.add(new Categories__c(Id__c='bda87896-bfd6-40a6-86e3-8584192b137d', Description__c='AAA', image_url__c='AAA', Name__c='Shared Data Offers'));
        categories.add(new Categories__c(Id__c='c9da178d-3637-471e-9180-33319e6a661e', Description__c='BBB', image_url__c='BBB', Name__c='Personal Data Offers'));
        categories.add(new Categories__c(Id__c='941f0afe-669c-4fe7-a697-15ad4febc35c', Description__c='CCC', image_url__c='CCC', Name__c='Booster Load'));
        insert categories;
        
        product = new List<Product__c>();
        product.add(new Product__c(Category_Id__c=categories.get(0).Id__c,  Id__c='facebook_5', Value__c=100, Name__c='Facebook 5', Open_Access_Data_Allowance__c='40MB', 
                                   Open_Access_Data_Validity__c='1 day', SmartLife_Data_Display__c='Unlimited', SmartLife_Data_Validity__c='1 day'));

        product.add(new Product__c(Category_Id__c=categories.get(1).Id__c,  Id__c='facebook_5', Value__c=100, Name__c='Facebook 5', Open_Access_Data_Allowance__c='40MB', 
                                   Open_Access_Data_Validity__c='1 day', SmartLife_Data_Display__c='Unlimited', SmartLife_Data_Validity__c='1 day'));

        product.add(new Product__c(Category_Id__c=categories.get(2).Id__c,  Id__c='facebook_5', Value__c=100, Name__c='Facebook 5', Open_Access_Data_Allowance__c='40MB', 
                                   Open_Access_Data_Validity__c='1 day', SmartLife_Data_Display__c='Unlimited', SmartLife_Data_Validity__c='1 day'));
        insert product;
        
        
        personalCategories = new List<Personal_Categories__c>();
        personalCategories.add(new Personal_Categories__c(Category_Name__c='Entertainment', Profile__c=profile.get(0).Id));
        insert personalCategories;
        
        personalCategoryDetails = new List<Personal_Category_Details__c>();        
        personalCategoryDetails.add(new Personal_Category_Details__c(Category_Type__c='Entertainment', Date__c=System.Now(), Value__c=500, Personal_Categories__c=personalCategories.get(0).Id));
        insert personalCategoryDetails;
    }
}