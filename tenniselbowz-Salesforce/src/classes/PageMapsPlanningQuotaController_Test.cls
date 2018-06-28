@isTest(SeeAllData=true)
    public class PageMapsPlanningQuotaController_Test{
        
        public static TestMethod void testCase1(){
            
            
            test.startTest();
            
            Profile pr = [select id from profile where name='System Administrator'];
             User u = new User(alias = 'qqqrte', email='standarduser@daikinapplied.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = pr.Id,
                timezonesidkey='America/Los_Angeles', username='stansdfwefdarduser@daikinapplied.com',
                User_Division__c = 'IT', Title='test');
            
            insert u;
            
            Sales_Rep_Quota__c s = new Sales_Rep_Quota__c();
                    //s.Quarterly_Quota__c = 100.05;
                    s.Q4_M3_MA_Quota__c = 100.05;
                    s.Q4_M2_MA_Quota__c= 100.05;
                    s.Q4_M1_MA_Quota__c= 100.05;
                    s.Q3_M3_MA_Quota__c = 100.05;
                    s.Q3_M2_MA_Quota__c= 100.05;
                    s.Q3_M1_MA_Quota__c= 100.05;
                    s.Q2_M3_MA_Quota__c = 100.05;
                    s.Q2_M2_MA_Quota__c= 100.05;
                    s.Q2_M1_MA_Quota__c= 100.05;
                    s.Q1_M3_MA_Quota__c = 100.05;
                    s.Q1_M2_MA_Quota__c= 100.05;
                    s.Q1_M1_MA_Quota__c= 100.05;
                    s.Q4_M3_SR_Quota__c = 100.05;
                    s.Q4_M2_SR_Quota__c= 100.05;
                    s.Q4_M1_SR_Quota__c= 100.05;
                    s.Q3_M3_SR_Quota__c = 100.05;
                    s.Q3_M2_SR_Quota__c= 100.05;
                    s.Q3_M1_SR_Quota__c= 100.05;
                    s.Q2_M3_SR_Quota__c = 100.05;
                    s.Q2_M2_SR_Quota__c= 100.05;
                    s.Q2_M1_SR_Quota__c= 100.05;
                    s.Q1_M3_SR_Quota__c = 100.05;
                    s.Q1_M2_SR_Quota__c= 100.05;
                    s.Q1_M1_SR_Quota__c= 100.05;
                    s.Q4_M3_TK_Quota__c = 100.05;
                    s.Q4_M2_TK_Quota__c= 100.05;
                    s.Q4_M1_TK_Quota__c= 100.05;
                    s.Q3_M3_TK_Quota__c= 100.05;
                    s.Q3_M2_TK_Quota__c= 100.05;
                    s.Q3_M1_TK_Quota__c= 100.05;
                    s.Q2_M3_TK_Quota__c= 100.05;
                    s.Q2_M2_TK_Quota__c= 100.05;
                    s.Q2_M1_TK_Quota__c= 100.05;
                    s.Q1_M3_TK_Quota__c= 100.05;
                    s.Q1_M2_TK_Quota__c= 100.05;
                    s.Q1_M1_TK_Quota__c= 100.05;
                    s.Q4_M3_RC_Quota__c= 100.05;
                    s.Q4_M2_RC_Quota__c= 100.05;
                    s.Q4_M1_RC_Quota__c= 100.05;
                    s.Q3_M3_RC_Quota__c= 100.05;
                    s.Q3_M2_RC_Quota__c= 100.05;
                    s.Q3_M1_RC_Quota__c= 100.05;
                    s.Q2_M3_RC_Quota__c= 100.05;
                    s.Q2_M2_RC_Quota__c= 100.05;
                    s.Q2_M1_RC_Quota__c= 100.05;
                    s.Q1_M3_RC_Quota__c= 100.05;
                    s.Q1_M2_RC_Quota__c= 100.05;
                    s.Q1_M1_RC_Quota__c= 100.05;
                    s.Q4_M3_MCP_Quota__c= 100.05;
                    s.Q4_M2_MCP_Quota__c= 100.05;
                    s.Q4_M1_MCP_Quota__c= 100.05;
                    s.Q3_M3_MCP_Quota__c= 100.05;
                    s.Q3_M2_MCP_Quota__c= 100.05;
                    s.Q3_M1_MCP_Quota__c= 100.05;
                    s.Q2_M3_MCP_Quota__c= 100.05;
                    s.Q2_M2_MCP_Quota__c= 100.05;
                    s.Q2_M1_MCP_Quota__c= 100.05;
                    s.Q1_M3_MCP_Quota__c= 100.05;
                    s.Q1_M2_MCP_Quota__c= 100.05;
                    s.Q1_M1_MCP_Quota__c= 100.05;
                    s.Q4_M3_Other_Quota__c= 100.05;
                    s.Q4_M2_Other_Quota__c= 100.05;
                    s.Q4_M1_Other_Quota__c= 100.05;
                    s.Q3_M2_Other_Quota__c= 100.05;
                    s.Q3_M3_Other_Quota__c= 100.05;
                    s.Q3_M1_Other_Quota__c= 100.05;
                    s.Q2_M3_Other_Quota__c= 100.05;
                    s.Q2_M2_Other_Quota__c= 100.05;
                    s.Q2_M1_Other_Quota__c= 100.05;
                    s.Q1_M3_Other_Quota__c= 100.05;
                    s.Q1_M2_Other_Quota__c= 100.05;
                    s.Q1_M1_Other_Quota__c = 100.00;
                    s.User__c = u.Id; 
         insert s;
                    
            RecordType objRT = [select id,name,developername from RecordType where SobjectType = 'Opportunity' and developername = 'North_America' limit 1];
            
            Account testAcc1 = new Account(OwnerId=u.Id,National_Account__c=true,Japanese_Company__c=true,Account_Type__c='Strategic', name='testAcc1',Company_Type__c='Architect');
            Insert testAcc1;
            
            List<Account> testAcc1new = new List<Account>([select id , name,owner.name from Account limit 1]);
            System.debug('****acc owner :'+testAcc1new[0].owner.name+'  id:'+testAcc1new[0].owner.ID);
            
            List<Opportunity> lstOpp = new List<Opportunity>();
            
            Opportunity testOpp1 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'MA', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp1',amount=3000.0,AccountId=testAcc1.id,CloseDate=system.today()+180,Vertical_Market__c='Healthcare',recordType=objRT);
            Opportunity testOpp2 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'Service & Repair', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp2',amount=300000.0,AccountId=testAcc1.id,CloseDate=system.today()+30,Vertical_Market__c='Healthcare',recordType=objRT);
            Opportunity testOpp3 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'TK - Turnkey Contracting', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp3',amount=30000.0,AccountId=testAcc1.id,CloseDate=system.today()+40,Vertical_Market__c='Healthcare',recordType=objRT);
            Opportunity testOpp4 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'Rental Chillers', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp4',amount=3000.0,AccountId=testAcc1.id,CloseDate=system.today()+69,Vertical_Market__c='Healthcare',recordType=objRT);
            Opportunity testOpp5 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'MA', StageName='D-Proposal/Bid-Not Daikin Specified',  name='testOpp5',amount=300.0,AccountId=testAcc1.id,CloseDate=system.today()+95,Vertical_Market__c='Healthcare',recordType=objRT);
            
            Opportunity testOpp6 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'MA', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp1',amount=3000.0,AccountId=testAcc1.id,CloseDate=system.today()+180,Vertical_Market__c='Healthcare',recordType=objRT);
            Opportunity testOpp7 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'Service & Repair', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp2',amount=300000.0,AccountId=testAcc1.id,CloseDate=system.today()+30,Vertical_Market__c='Healthcare',recordType=objRT);
            Opportunity testOpp8 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'TK - Turnkey Contracting', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp3',amount=30000.0,AccountId=testAcc1.id,CloseDate=system.today()+40,Vertical_Market__c='Healthcare',recordType=objRT);
            Opportunity testOpp9 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'Rental Chillers', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp4',amount=3000.0,AccountId=testAcc1.id,CloseDate=system.today()+69,Vertical_Market__c='Healthcare',recordType=objRT);
            Opportunity testOpp10 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'Other', StageName='D-Proposal/Bid-Not Daikin Specified',  name='testOpp5',amount=300.0,AccountId=testAcc1.id,CloseDate=system.today()+95,Vertical_Market__c='Healthcare',recordType=objRT);
            
            Opportunity testOpp11 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'TK - Turnkey Contracting', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp3',amount=30000.0,AccountId=testAcc1.id,CloseDate=system.today()+40,Vertical_Market__c='Healthcare',recordType=objRT);
            Opportunity testOpp12 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'MCP', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp3',amount=30000.0,AccountId=testAcc1.id,CloseDate=system.today()+40,Vertical_Market__c='Healthcare',recordType=objRT);
            Opportunity testOpp13 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'MCP', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp3',amount=30000.0,AccountId=testAcc1.id,CloseDate=system.today()+40,Vertical_Market__c='Healthcare',recordType=objRT);
            
            lstOpp.add(testOpp1);
            lstOpp.add(testOpp2);
            lstOpp.add(testOpp3);
            lstOpp.add(testOpp4);
            lstOpp.add(testOpp5);
            
            lstOpp.add(testOpp6);
            lstOpp.add(testOpp7);
            lstOpp.add(testOpp8);
            lstOpp.add(testOpp9);
            lstOpp.add(testOpp10);
            
            lstOpp.add(testOpp11);
            lstOpp.add(testOpp12);
            lstOpp.add(testOpp13);
            
            insert lstOpp;
            
            List<Opportunity> lstOpp1 = new List<Opportunity>();
            //lstOpp1 =[select id,ownerid from opportunity limit 1];
            PageReference p = new PageReference('apex/vfMapsPlanningQuota');
            
           // p.setRedirect(true);
            Test.setCurrentPage(p);
            Opportunity opp = [select Id,name,MAPS_LOB_Type__c,amount,closedate,StageName,ownerid,Accountid,owner.name from Opportunity where name = 'testOpp1' LIMIT 1][0];
            System.debug('###oppowner Name:'+opp.owner.name+'  id :'+opp.owner.id);
    /******
            ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);
            PageMapsPlanningQuotaController con  = new PageMapsPlanningQuotaController(stdOpp);
    *******/

            ApexPages.StandardController sc = new ApexPages.StandardController(opp);
            PageMapsPlanningQuotaController con  = new PageMapsPlanningQuotaController(sc);
            
            con.selectedValues = u.Id;
            System.assertequals(u.id,con.selectedValues);
            
            con.getAccTypeList();
            con.generatePdf();
            con.accType = '0';
            con.accWrap('Strategic');
            Map<String,decimal> testObj = new Map<String,decimal>();
            testObj.put('apr',1000.0);
            List<PageMapsPlanningQuotaController.oppAmtCalc> lstoppAMt = new List<PageMapsPlanningQuotaController.oppAmtCalc>();
            lstoppAMt = con.tableWrap;
            con.accnts = testAcc1new;
            
            Map<String,List<PageMapsPlanningQuotaController.MajorAccounts>> mapTemp = new Map<String,List<PageMapsPlanningQuotaController.MajorAccounts>>();
            mapTemp = con.getMajorAccounts;
            
            p.setRedirect(true);
            
            //PageMapsPlanningQuotaController.accWrapper accWrap2 = new PageMapsPlanningQuotaController.accWrapper('005C0000004fmsI', 'Test', '005C0000004fmsI', 'Test', true, true, true, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00);
            //con.selectedValues = '005C0000004fmsI';
           test.stopTest();
            
            
            
        }
        public static TestMethod void testCase2(){
            
            
            test.startTest();
            
            Profile pr = [select id from profile where name='System Administrator'];
             User u = new User(alias = 'qqqrte', email='standarduser@daikinapplied.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = pr.Id,
                timezonesidkey='America/Los_Angeles', username='stansdfwefdarduser@daikinapplied.com',
                User_Division__c = 'IT', Title='test');
            
            insert u;
            
            Sales_Rep_Quota__c s = new Sales_Rep_Quota__c();
                    //s.Quarterly_Quota__c = 100.05;
                    s.Q4_M3_MA_Quota__c = 100.05;
                    s.Q4_M2_MA_Quota__c= 100.05;
                    s.Q4_M1_MA_Quota__c= 100.05;
                    s.Q3_M3_MA_Quota__c = 100.05;
                    s.Q3_M2_MA_Quota__c= 100.05;
                    s.Q3_M1_MA_Quota__c= 100.05;
                    s.Q2_M3_MA_Quota__c = 100.05;
                    s.Q2_M2_MA_Quota__c= 100.05;
                    s.Q2_M1_MA_Quota__c= 100.05;
                    s.Q1_M3_MA_Quota__c = 100.05;
                    s.Q1_M2_MA_Quota__c= 100.05;
                    s.Q1_M1_MA_Quota__c= 100.05;
                    s.Q4_M3_SR_Quota__c = 100.05;
                    s.Q4_M2_SR_Quota__c= 100.05;
                    s.Q4_M1_SR_Quota__c= 100.05;
                    s.Q3_M3_SR_Quota__c = 100.05;
                    s.Q3_M2_SR_Quota__c= 100.05;
                    s.Q3_M1_SR_Quota__c= 100.05;
                    s.Q2_M3_SR_Quota__c = 100.05;
                    s.Q2_M2_SR_Quota__c= 100.05;
                    s.Q2_M1_SR_Quota__c= 100.05;
                    s.Q1_M3_SR_Quota__c = 100.05;
                    s.Q1_M2_SR_Quota__c= 100.05;
                    s.Q1_M1_SR_Quota__c= 100.05;
                    s.Q4_M3_TK_Quota__c = 100.05;
                    s.Q4_M2_TK_Quota__c= 100.05;
                    s.Q4_M1_TK_Quota__c= 100.05;
                    s.Q3_M3_TK_Quota__c= 100.05;
                    s.Q3_M2_TK_Quota__c= 100.05;
                    s.Q3_M1_TK_Quota__c= 100.05;
                    s.Q2_M3_TK_Quota__c= 100.05;
                    s.Q2_M2_TK_Quota__c= 100.05;
                    s.Q2_M1_TK_Quota__c= 100.05;
                    s.Q1_M3_TK_Quota__c= 100.05;
                    s.Q1_M2_TK_Quota__c= 100.05;
                    s.Q1_M1_TK_Quota__c= 100.05;
                    s.Q4_M3_RC_Quota__c= 100.05;
                    s.Q4_M2_RC_Quota__c= 100.05;
                    s.Q4_M1_RC_Quota__c= 100.05;
                    s.Q3_M3_RC_Quota__c= 100.05;
                    s.Q3_M2_RC_Quota__c= 100.05;
                    s.Q3_M1_RC_Quota__c= 100.05;
                    s.Q2_M3_RC_Quota__c= 100.05;
                    s.Q2_M2_RC_Quota__c= 100.05;
                    s.Q2_M1_RC_Quota__c= 100.05;
                    s.Q1_M3_RC_Quota__c= 100.05;
                    s.Q1_M2_RC_Quota__c= 100.05;
                    s.Q1_M1_RC_Quota__c= 100.05;
                    s.Q4_M3_MCP_Quota__c= 100.05;
                    s.Q4_M2_MCP_Quota__c= 100.05;
                    s.Q4_M1_MCP_Quota__c= 100.05;
                    s.Q3_M3_MCP_Quota__c= 100.05;
                    s.Q3_M2_MCP_Quota__c= 100.05;
                    s.Q3_M1_MCP_Quota__c= 100.05;
                    s.Q2_M3_MCP_Quota__c= 100.05;
                    s.Q2_M2_MCP_Quota__c= 100.05;
                    s.Q2_M1_MCP_Quota__c= 100.05;
                    s.Q1_M3_MCP_Quota__c= 100.05;
                    s.Q1_M2_MCP_Quota__c= 100.05;
                    s.Q1_M1_MCP_Quota__c= 100.05;
                    s.Q4_M3_Other_Quota__c= 100.05;
                    s.Q4_M2_Other_Quota__c= 100.05;
                    s.Q4_M1_Other_Quota__c= 100.05;
                    s.Q3_M2_Other_Quota__c= 100.05;
                    s.Q3_M3_Other_Quota__c= 100.05;
                    s.Q3_M1_Other_Quota__c= 100.05;
                    s.Q2_M3_Other_Quota__c= 100.05;
                    s.Q2_M2_Other_Quota__c= 100.05;
                    s.Q2_M1_Other_Quota__c= 100.05;
                    s.Q1_M3_Other_Quota__c= 100.05;
                    s.Q1_M2_Other_Quota__c= 100.05;
                    s.Q1_M1_Other_Quota__c = 100.00;
                    s.User__c = u.Id; 
         insert s;
         
            RecordType objRT = [select id,name,developername from RecordType where SobjectType = 'Opportunity' and developername = 'North_America' limit 1];
                     
            Account testAcc1 = new Account(OwnerId=u.Id,National_Account__c=true,Japanese_Company__c=true,Account_Type__c='Strategic', name='testAcc1',Company_Type__c='Architect');
            Insert testAcc1;
            
            List<Account> testAcc1new = new List<Account>([select id , name,owner.name from Account limit 1]);
            System.debug('****acc owner :'+testAcc1new[0].owner.name+'  id:'+testAcc1new[0].owner.ID);
            
            List<Opportunity> lstOpp = new List<Opportunity>();
            
            Opportunity testOpp1 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'MA', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp1',amount=3000.0,AccountId=testAcc1.id,CloseDate=system.today()+180,Vertical_Market__c='Healthcare',recordtype=objRT);
            Opportunity testOpp2 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'Service & Repair', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp2',amount=300000.0,AccountId=testAcc1.id,CloseDate=system.today()+30,Vertical_Market__c='Healthcare',recordtype=objRT);
            Opportunity testOpp3 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'TK - Turnkey Contracting', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp3',amount=30000.0,AccountId=testAcc1.id,CloseDate=system.today()+40,Vertical_Market__c='Healthcare',recordtype=objRT);
            Opportunity testOpp4 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'Rental Chillers', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp4',amount=3000.0,AccountId=testAcc1.id,CloseDate=system.today()+69,Vertical_Market__c='Healthcare',recordtype=objRT);
            Opportunity testOpp5 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'MA', StageName='D-Proposal/Bid-Not Daikin Specified',  name='testOpp5',amount=300.0,AccountId=testAcc1.id,CloseDate=system.today()+95,Vertical_Market__c='Healthcare',recordtype=objRT);
            
            Opportunity testOpp6 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'MA', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp1',amount=3000.0,AccountId=testAcc1.id,CloseDate=system.today()+180,Vertical_Market__c='Healthcare',recordtype=objRT);
            Opportunity testOpp7 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'Service & Repair', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp2',amount=300000.0,AccountId=testAcc1.id,CloseDate=system.today()+30,Vertical_Market__c='Healthcare',recordtype=objRT);
            Opportunity testOpp8 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'TK - Turnkey Contracting', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp3',amount=30000.0,AccountId=testAcc1.id,CloseDate=system.today()+40,Vertical_Market__c='Healthcare',recordtype=objRT);
            Opportunity testOpp9 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'Rental Chillers', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp4',amount=3000.0,AccountId=testAcc1.id,CloseDate=system.today()+69,Vertical_Market__c='Healthcare',recordtype=objRT);
            Opportunity testOpp10 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'Other', StageName='D-Proposal/Bid-Not Daikin Specified',  name='testOpp5',amount=300.0,AccountId=testAcc1.id,CloseDate=system.today()+95,Vertical_Market__c='Healthcare',recordtype=objRT);
            
            Opportunity testOpp11 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'TK - Turnkey Contracting', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp3',amount=30000.0,AccountId=testAcc1.id,CloseDate=system.today()+40,Vertical_Market__c='Healthcare',recordtype=objRT);
            Opportunity testOpp12 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'MCP', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp3',amount=30000.0,AccountId=testAcc1.id,CloseDate=system.today()+40,Vertical_Market__c='Healthcare',recordtype=objRT);
            Opportunity testOpp13 = new Opportunity(OwnerId=u.Id, Line_of_Business__c = 'MCP', StageName='D-Proposal/Bid-Not Daikin Specified', name='testOpp3',amount=30000.0,AccountId=testAcc1.id,CloseDate=system.today()+40,Vertical_Market__c='Healthcare',recordtype=objRT);
            
            lstOpp.add(testOpp1);
            lstOpp.add(testOpp2);
            lstOpp.add(testOpp3);
            lstOpp.add(testOpp4);
            lstOpp.add(testOpp5);
            
            lstOpp.add(testOpp6);
            lstOpp.add(testOpp7);
            lstOpp.add(testOpp8);
            lstOpp.add(testOpp9);
            lstOpp.add(testOpp10);
            
            lstOpp.add(testOpp11);
            lstOpp.add(testOpp12);
            lstOpp.add(testOpp13);
            
            
            insert lstOpp;
            
            List<Opportunity> lstOpp1 = new List<Opportunity>();
            //lstOpp1 =[select id,ownerid from opportunity limit 1];
            PageReference p = new PageReference('apex/vfMapsPlanningQuota');
            
           // p.setRedirect(true);
            Test.setCurrentPage(p);
            Opportunity opp = [select Id,name,MAPS_LOB_Type__c,amount,closedate,StageName,ownerid,Accountid,owner.name from Opportunity where name = 'testOpp1' LIMIT 1][0];
            System.debug('###oppowner Name:'+opp.owner.name+'  id :'+opp.owner.id);
    /******
            ApexPages.StandardController stdOpp = new ApexPages.StandardController(opp);
            PageMapsPlanningQuotaController con  = new PageMapsPlanningQuotaController(stdOpp);
    *******/

            ApexPages.StandardController sc = new ApexPages.StandardController(opp);
            PageMapsPlanningQuotaController con  = new PageMapsPlanningQuotaController(sc);
            
            con.selectedValues = u.Id;
            System.assertequals(u.id,con.selectedValues);
            
             
            con.getAccTypeList();
            con.generatePdf();
            con.accType = '0';
            con.accWrap('Strategic');
            Map<String,decimal> testObj = new Map<String,decimal>();
            testObj.put('apr',1000.0);
            List<PageMapsPlanningQuotaController.oppAmtCalc> lstoppAMt = new List<PageMapsPlanningQuotaController.oppAmtCalc>();
            lstoppAMt = con.tableWrap;
            con.accnts = testAcc1new;
            
            Map<String,List<PageMapsPlanningQuotaController.MajorAccounts>> mapTemp = new Map<String,List<PageMapsPlanningQuotaController.MajorAccounts>>();
            mapTemp = con.getMajorAccounts;
            
            p.setRedirect(true);
            
            //PageMapsPlanningQuotaController.accWrapper accWrap2 = new PageMapsPlanningQuotaController.accWrapper('005C0000004fmsI', 'Test', '005C0000004fmsI', 'Test', true, true, true, 23.00, 23.00, 23.00, 23.00, 23.00, 23.00);
            //con.selectedValues = '005C0000004fmsI';
           test.stopTest();
            
            
            
        }
        
    }