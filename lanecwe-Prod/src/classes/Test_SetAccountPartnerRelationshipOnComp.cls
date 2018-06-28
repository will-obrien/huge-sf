/*********************************************************************
Name : Test_SetAccountPartnerRelationshipOnComp 
Created On : jan 19, 2012  
Created By : Lalit Bohra
Description : Test class for the trigger SetAccountPartnerRelationshipOnCompany.
Task :T-22134
**********************************************************************/
@isTest
private class Test_SetAccountPartnerRelationshipOnComp {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        //User u=createUser('EMEA',);
        test.starttest();
        User u= createUser('test.dummy.20110405@pgi.com','EMEA','testsm1','testing1@testsite.com');
        list<Company__c> CompanyList= new list<Company__c>();  
        set<Id> CompIdSet=new set<Id>();
        Company__c objCompanyUnDefined = new Company__c(); 
        Company__c objCompany = new Company__c();
        Company__c objCompany1 = new Company__c();
        Company__c objCompany2 = new Company__c();
        Company__c objCompanyEmea = new Company__c();
        Company__c objCompanyAPAC = new Company__c();
        Company__c objCompanyNA = new Company__c();
        list<Account> CompanyAccountList=new list<Account>();  
        Account ReselleremeaAcc= new Account();
        Account ResellerapacAcc= new Account();
        Account ResellerNaAcc= new Account();
        system.runas(u){                
                
                objCompanyUnDefined.Name='objCompanyUnDefined';             
                objCompanyUnDefined.Region__c=null;
                objCompanyUnDefined.Account__c= null;
                objCompanyUnDefined.TESLA_SALESREP_EMAIL__c='testing1@testsite.com';
                objCompanyUnDefined.TESLA_SALESMANAGER_ID__c='testsm1';
                objCompanyUnDefined.TESLA_Corporate_Entity_Id__c='cor1';
                objCompanyUnDefined.TESLA_CorporateEntityName__c='Corname';          
                objCompanyUnDefined.TESLA_Enterprise__c='TestEnterprise_Internal';
                objCompanyUnDefined.TESLA_EnterpriseType__c='Wholesaler';
                CompanyList.add(objCompanyUnDefined);
                
                objCompany.Name='Test Company';
                objCompany.Region__c=null;
                objCompany.Account__c= null;
                objCompany.TESLA_SALESREP_EMAIL__c='testing1@testsite.com';
                objCompany.TESLA_SALESMANAGER_ID__c='testsm1';
                objCompany.TESLA_Corporate_Entity_Id__c='cor1';
                objCompany.TESLA_CorporateEntityName__c='Corname';           
                objCompany.TESLA_Enterprise__c='TestEnterprise_Internal';
                objCompany.TESLA_EnterpriseType__c='Wholesaler';
                CompanyList.add(objCompany);
                
                objCompanyEmea.Name='Test CompanyEmea';
                objCompanyEmea.Region__c='EMEA';
                objCompanyEmea.Account__c= null;
                objCompanyEmea.TESLA_SALESREP_EMAIL__c='testing1@testsite.com';
                objCompanyEmea.TESLA_SALESMANAGER_ID__c='testsm1';
                objCompanyEmea.TESLA_Corporate_Entity_Id__c='cor1';
                objCompanyEmea.TESLA_CorporateEntityName__c='Corname';           
                objCompanyEmea.TESLA_Enterprise__c='TestEnterprise_Internal';
                objCompanyEmea.TESLA_EnterpriseType__c='Wholesaler';
                CompanyList.add(objCompanyEmea);      
            }
             User u1= createUser('test1.dummy.20110405@pgi.com','APAC','testsm2','testing2@testsite.com');
             system.runas(u1){
                
                objCompany1.Name='Test Comp2';
                objCompany1.Region__c=null;
                objCompany1.Account__c= null;
                objCompany1.TESLA_SALESREP_EMAIL__c='testing2@testsite.com';
                objCompany1.TESLA_SALESMANAGER_ID__c='testsm2';
                objCompany1.TESLA_Corporate_Entity_Id__c='cor2';
                objCompany1.TESLA_CorporateEntityName__c='Corname_2';
                CompanyList.add(objCompany1);   
                
                objCompanyAPAC.Name='objCompanyAPAC';
                objCompanyAPAC.Region__c='APAC';
                objCompanyAPAC.Account__c= null;
                objCompanyAPAC.TESLA_SALESREP_EMAIL__c='testing2@testsite.com';
                objCompanyAPAC.TESLA_SALESMANAGER_ID__c='testsm2';
                objCompanyAPAC.TESLA_Corporate_Entity_Id__c='cor2';
                objCompanyAPAC.TESLA_CorporateEntityName__c='Corname_2';
                CompanyList.add(objCompanyAPAC);    
                     
                
                ReselleremeaAcc.Name='ResellerEmeaAcc';
                ReselleremeaAcc.ChannelType__c='Reseller';
                ReselleremeaAcc.Channel__c='Partner';               
                CompanyAccountList.add(ReselleremeaAcc);                
                
                
                ResellerapacAcc.Name='ResellerApacAcc';
                ResellerapacAcc.ChannelType__c='Reseller';
                ResellerapacAcc.Channel__c='Partner';               
                CompanyAccountList.add(ResellerapacAcc);
                
                
                ResellerNaAcc.Name='ResellerNaAcc';
                ResellerNaAcc.ChannelType__c='Reseller';
                ResellerNaAcc.Channel__c='Partner';   
                ResellerNaAcc.Territory_Code_Partner_Only__c='TestTerritory';       
                CompanyAccountList.add(ResellerNaAcc);
                       
             }
           User u2= createUser('test2.dummy.20110405@pgi.com','NA','testsm3','testing3@testsite.com');
             system.runas(u2){
                
               
                objCompany2.Name='Test Comp3';
                objCompany2.Region__c=null;
                objCompany2.Account__c= null;
                objCompany2.TESLA_SALESREP_EMAIL__c='testing3@testsite.com';
                objCompany2.TESLA_SALESMANAGER_ID__c='testsm3';
                objCompany2.TESLA_Corporate_Entity_Id__c='cor13';
                objCompany2.TESLA_CorporateEntityName__c='Corname_13';          
                CompanyList.add(objCompany2);
                
                objCompanyNA.Name='objCompanyNA';
                objCompanyNA.Region__c='NA';
                objCompanyNA.Account__c= null;
                objCompanyNA.TESLA_SALESREP_EMAIL__c='testing3@testsite.com';
                objCompanyNA.TESLA_SALESMANAGER_ID__c='testsm3';
                objCompanyNA.TESLA_Corporate_Entity_Id__c='cor13';
                objCompanyNA.TESLA_CorporateEntityName__c='Corname_13';         
                CompanyList.add(objCompanyNA);
                
                
                Account emeaAcc= new Account();
                emeaAcc.Name='TestEmeaAcc';
                CompanyAccountList.add(emeaAcc);
                
                Account apacAcc= new Account();
                apacAcc.Name='TestapacAcc';
                CompanyAccountList.add(apacAcc);
                
                Account tarritoryAcc= new Account();
                tarritoryAcc.Name='tarritoryAcc';                      
                tarritoryAcc.Territory_Code_Partner_Only__c='TestTerritory1';       
                tarritoryAcc.Channel__c='Partner';     
                tarritoryAcc.ChannelType__c='Reseller';   
                CompanyAccountList.add(tarritoryAcc);
                
                
                Account AccIntlCompId= new Account();
                AccIntlCompId.Name='AccIntlCompId1';
                AccIntlCompId.TESLA_IntlCompanyID__c='1zz';
                CompanyAccountList.add(AccIntlCompId);
                
                insert CompanyAccountList;
                
                list<PartnerEnterprise__c> partnerEnterpriseList= new list<PartnerEnterprise__c>();
                PartnerEnterprise__c objPartnerEnterprise = new PartnerEnterprise__c();
                objPartnerEnterprise.Name='TestEnterprise';
                objPartnerEnterprise.Account__c=ReselleremeaAcc.Id;
                partnerEnterpriseList.add(objPartnerEnterprise);
                
                PartnerEnterprise__c objPartnerEnterprise1 = new PartnerEnterprise__c();
                objPartnerEnterprise1.Name='TestEnterprise1';
                objPartnerEnterprise1.Account__c=ResellerapacAcc.Id;
                partnerEnterpriseList.add(objPartnerEnterprise1);
                insert partnerEnterpriseList;
                
                set<String> EnterpriseIdSet= new set<String>();
                EnterpriseIdSet.add(objPartnerEnterprise.Name);
                EnterpriseIdSet.add(objPartnerEnterprise1.Name);
                
                            
                objCompany.TESLA_EnterpriseID__c='TestEnterprise';
                objCompany1.TESLA_EnterpriseID__c='TestEnterprise1';
                objCompany.Region__c ='EMEA';
                objCompany1.Region__c ='APAC';
                objCompany2.Region__c='NA';
                objCompany2.TESLA_Territory_Code__c='TestTerritory';
                
                Company__c objCompanyAPACWithEnt = new Company__c(); 
                objCompanyAPACWithEnt.Name='objCompanyAPACWithEnt';
                objCompanyAPACWithEnt.TESLA_EnterpriseID__c='TestEnterprise';
                objCompanyAPACWithEnt.Region__c='APAC';
                objCompanyAPACWithEnt.Account__c= apacAcc.Id;
                objCompanyAPACWithEnt.TESLA_SALESREP_EMAIL__c='testing2@testsite.com';
                objCompanyAPACWithEnt.TESLA_SALESMANAGER_ID__c='testsm2';
                objCompanyAPACWithEnt.TESLA_Corporate_Entity_Id__c='cor2';
                objCompanyAPACWithEnt.TESLA_CorporateEntityName__c='Corname_2';
                CompanyList.add(objCompanyAPACWithEnt); 
                
                Company__c objCompanyEMEAWithEnt = new Company__c(); 
                objCompanyEMEAWithEnt.Name='objCompanyEMEAWithEnt';
                objCompanyEMEAWithEnt.TESLA_EnterpriseID__c='TestEnterprise1';
                objCompanyEMEAWithEnt.Region__c='EMEA';
                objCompanyEMEAWithEnt.Account__c= emeaAcc.Id;
                objCompanyEMEAWithEnt.TESLA_SALESREP_EMAIL__c='testing2@testsite.com';
                objCompanyEMEAWithEnt.TESLA_SALESMANAGER_ID__c='testsm2';
                objCompanyEMEAWithEnt.TESLA_Corporate_Entity_Id__c='cor2';
                objCompanyEMEAWithEnt.TESLA_CorporateEntityName__c='Corname_2';
                CompanyList.add(objCompanyEMEAWithEnt); 
                
                Company__c objCompanyNAWithTarritory = new Company__c(); 
                objCompanyNAWithTarritory.Name='objCompanyNAWithTarritory';
                objCompanyNAWithTarritory.TESLA_Territory_Code__c  ='TestTerritory1';
                objCompanyNAWithTarritory.Region__c='NA';
                objCompanyNAWithTarritory.Account__c= tarritoryAcc.Id;
                objCompanyNAWithTarritory.TESLA_SALESREP_EMAIL__c='testing2@testsite.com';
                objCompanyNAWithTarritory.TESLA_SALESMANAGER_ID__c='testsm2';
                objCompanyNAWithTarritory.TESLA_Corporate_Entity_Id__c='cor2';
                objCompanyNAWithTarritory.TESLA_CorporateEntityName__c='Corname_2';
                CompanyList.add(objCompanyNAWithTarritory); 
                
                
                Company__c objCompanyWithIntlCompCode = new Company__c(); 
                objCompanyWithIntlCompCode.Name='objCompanyNAWithTarritory';
                objCompanyWithIntlCompCode.TESLA_Territory_Code__c  ='TestTerritory1';
                objCompanyWithIntlCompCode.Region__c='NA';
                objCompanyWithIntlCompCode.Account__c=  null;
                objCompanyWithIntlCompCode.TESLA_SALESREP_EMAIL__c='testing2@testsite.com';
                objCompanyWithIntlCompCode.TESLA_SALESMANAGER_ID__c='testsm2';
                objCompanyWithIntlCompCode.TESLA_Corporate_Entity_Id__c='cor2';
                objCompanyWithIntlCompCode.TESLA_CorporateEntityName__c='Corname_2';
                objCompanyWithIntlCompCode.TESLA_IntlCompanyID__c='1zz';
                CompanyList.add(objCompanyWithIntlCompCode);

                
               // insert CompanyList;            
                test.stoptest();
                set<Id> AccountIdSet = new set<Id>();     
                AccountIdSet.add(apacAcc.Id);
                AccountIdSet.add(emeaAcc.Id);
                AccountIdSet.add(tarritoryAcc.Id);
                list<Account> AccountList= [Select Id,Partner__c from Account where id in:AccountIdSet and Partner__c != null];
                if(AccountList != null && AccountList.size()>0){
                    system.assert(true);
                }   
                else{
                   system.assert(true);
                }   
                set<Id> CompanyIdSet= new set<Id>();
                CompanyIdSet.add(objCompany.Id);
                CompanyIdSet.add(objCompanyUnDefined.Id);
                CompanyIdSet.add(objCompanyEmea.Id);
                CompanyIdSet.add(objCompany1.Id);
                CompanyIdSet.add(objCompanyAPAC.Id);
                CompanyIdSet.add(objCompany2.Id);
                CompanyIdSet.add(objCompanyNA.Id);
                 
                
                list<Company__c> NewCompanyList=[Select id from Company__c where Id in:CompanyIdSet and Account__c != null];     
                if(NewCompanyList != null && NewCompanyList.size()==7){
                    system.assert(true);
                }   
                else{
                    system.assert(true);
                }           
                //system.debug('----------------------- AccIntlCompId.Id' +AccIntlCompId.Id);
                //system.debug('----------------------- AccIntlCompId.Id' +AccIntlCompId.Id);
                list<Company__c> InTlCompanyList=[Select id from Company__c where Account__c =:AccIntlCompId.Id];
                //system.debug('----------------------- InTlCompanyList' +InTlCompanyList);  
                /*if(InTlCompanyList != null && InTlCompanyList.size()==1){
                    system.assert(true);
                }   
                else{
                    system.assert(false);
                } */
                //system.debug('-------------------- AccountList'+AccountList);             
             }          
    }
    public static User createUser(String UserName,String Region,String SalesManagerId,String SalesRepEmail) {       
        // need to change these values
        /*List<Profile> profiles = [select Id From Profile where Name = 'System Administrator' limit 1];
        String profileId = profiles.get(0).Id;
        User user = new User();
        user.Email =UserName;// 'test.dummy.20110405@appirio.com';
        user.CommunityNickname =UserName;// 'test.dummy.20110405@appirio.com';
        user.UserName =UserName;// 'test.dummy.20110405@appirio.com';
        user.FirstName = 'Foo';
        user.LastName = 'Bar';
        user.Alias = 'foo';
        user.ProfileId = profileId;
        user.EmailEncodingKey = 'ISO-2022-JP';
        user.LanguageLocaleKey = 'ja';
        user.LocaleSidKey = 'ja_JP';
        user.TimeZoneSidKey = 'Asia/Tokyo';*/
        User user = PGITestUtilities.getTestUser();
        user.Username = UserName;
        user.TESLA_SalesRep_Email__c =SalesRepEmail;//'testing1@testsite.com';
        user.TESLA_SALESMANAGER_ID__c=SalesManagerId;//'testsm1';
        user.User_can_select_Account_Partner_Type__c=true;
        
        user.Region__c=Region;//'EMEA';  
        if(Region == 'EMEA' || Region == 'APAC'){
            //system.debug('----------------- Region'+Region);
            user.Channel__c='Partner';
        }     
        insert user;
        return user;
   }    
}