global class BatchProcess_MAPS_Roles implements Database.Batchable<sObject>{
    
    /**!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**
     ** THIS IS INTENDED TO BE RUN IN BATCHES OF 1 ONLY **
     System.schedule('Role-Total-Batch_Maps_ReportingShedular', '0 0 2 * * ?', new Batch_Maps_ReportingShedular_Total());
System.schedule('User-Batch_Maps_ReportingShedular', '0 0 2 * * ?', new Batch_Maps_ReportingShedular_User());
System.schedule('User-Total-Batch_Maps_ReportingShedular', '0 0 2 * * ?', new Batch_Maps_ReportingShedular_UserTotal());
System.schedule('Role-Batch_Maps_ReportingShedular', '0 0 2 * * ?', new Batch_Maps_ReportingShedular_Role());
     **!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**/ 
     
    global Database.querylocator start(Database.BatchableContext BC){ 
        UserRole startingRole = [Select Id, Name from UserRole where name = 'Service'];
        set<Id> roleIds = Batch_Maps_Helper.getAllSubRoleIds(new set<Id>{startingRole.Id});
        roleIds.add(startingRole.Id); 
        map<String, Excluded_MAPS_Roles__c> exclusions = Excluded_MAPS_Roles__c.getAll();
        return Database.getQueryLocator([Select Id, Name, ParentRoleId from UserRole where Id in :roleIds and name not in :exclusions.keySet()]);
        
    }

    //Main execute method
    global void execute(Database.BatchableContext BC, List<UserRole> roles){
        
        //today's Date. Context for the batch iteration
        Date dateToday = Batch_Maps_Helper.getToday();
        //start and ed dates for rolling dates
        Date startMonth = Batch_Maps_Helper.getStartMonth();
        Date endDate90 = Batch_Maps_Helper.getEndDate90();
        Date endDate12 = Batch_Maps_Helper.getEndDate12();
        
        //Current Year and Quarter
        Integer currentQuarter = Batch_Maps_Helper.getCurrFiscalQuarter();
        Integer currentYear = Batch_Maps_Helper.getCurrFiscalYear();
                                      
        // END OF WEEK
        boolean endOfWeek = Batch_Maps_Helper.isEndOfWeek();
        
        //END OF MONTH  
        boolean endOfMonth = Batch_Maps_Helper.isEndOfMonth();
        
        //END OF QUARTER  
        boolean endOfQuarter = Batch_Maps_Helper.isEndOfQuarter();
          
        //END OF YEAR
        boolean endOfYear = Batch_Maps_Helper.isEndOfYear();
        
        //collections used for processing and upsert    
        map<string, MAPS_Reporting__c> summaryMap = new map<string, MAPS_Reporting__c>();
        set<string> lobSet = new set<string>();
        map<string, MAPS_LOB__c> mapsLob = MAPS_LOB__c.getAll();
        map<Integer, Integer> quarterMonthMap = Batch_Maps_Helper.getQuarterMonthMap();
        
        
        //furrent Fiscal Month
        Date curFiscalDate = Batch_Maps_Helper.getCurrFiscalDate();
        //get the quota for the fiscal quarter two months from now...
        Integer thirdFiscalQuarter = Batch_Maps_Helper.getCurrFiscalQuarter(curFiscalDate.addMonths(2));
        Integer thirdFiscalMonth = quarterMonthMap.get( curFiscalDate.addMonths(2).month());
        
        //get the quota for the fiscal quarter one month from now...
        Integer secondFiscalQuarter = Batch_Maps_Helper.getCurrFiscalQuarter(curFiscalDate.addMonths(1));
        Integer secondFiscalMonth = quarterMonthMap.get( curFiscalDate.addMonths(1).month());
        
        //get the quota for the fiscal quarter one month from now...
        Integer currentFiscalQuarter = Batch_Maps_Helper.getCurrFiscalQuarter(curFiscalDate);
        Integer currentFiscalMonth = quarterMonthMap.get( curFiscalDate.month());
        
        //unravel all of the roles under the current role
        set<Id> roleIds = Batch_Maps_Helper.getAllSubRoleIds(new set<Id>{roles[0].Id});
        roleIds.add(roles[0].Id);
        
        list<User> users= [Select Id from User where UserRoleId in :roleIds and Exclude_User_for_Quota_Planning__c = false];
        
        map<Id, String> parentRoleNameMap = new map<Id, String>();
        set<Id> parentRoleIdSet = new set<Id>();
        
        for(UserRole u : roles)
          parentRoleIdSet.add(u.ParentRoleId);
          
        for(UserRole r : [Select Name, Id from UserRole where Id in :parentRoleIdSet])
            parentRoleNameMap.put(r.Id, r.Name);
        
        
        //=============================================================
        //Create a container for each summary utilizing an external key
        for(MAPS_LOB__c lob : mapsLob.values())
        {
            for(UserRole u : roles)
            {
                string mapKey = u.Id+lob.Name+system.today().addDays(-1);
                lobSet.add(lob.Name);
                summaryMap.put(mapKey
                              , new MAPS_Reporting__c(Pipeline_v_Quota_Rolling_12_Months__c = 0
                                                     ,Factored_Pipeline_v_Quota_Rolling_12M__c = 0
                                                     ,Closed_Won_MTD__c = 0
                                                     ,Closed_Won_v_Quota_MTD__c = 0
                                                     ,Closed_Won_YTD__c = 0
                                                     ,Closed_Won_v_Quota_YTD__c = 0
                                                     ,Pipeline_Rolling_90_Days__c = 0
                                                     ,Factored_Pipeline_Rolling_90_Days__c = 0
                                                     ,Pipeline_Rolling_12_Months__c = 0
                                                     ,Factored_Pipeline_Rolling_12_Months__c = 0
                                                     ,Major_Projects_Rolling_90_Days__c = 0
                                                     ,Major_Projects_Rolling_12_Months__c = 0
                                                     ,Strategic_Accounts_Current_Number__c = null
                                                     ,Quota_Current_FY__c = 0
                                                     ,Summary_Name__c = u.Name
                                                     ,Summary_Type_Id__c = u.Id
                                                     ,Summary_Level__c = lob.name
                                                     ,Summary_Parent_Name__c = parentRoleNameMap.get(u.ParentRoleId)
                                                     ,Summary_Parent_Id__c = u.ParentRoleId
                                                     ,Date_Ending__c = system.today().addDays(-1)
                                                     ,Processing_ID__c = mapKey
                                                     ,Pipeline_v_Quota_Rolling_90_Days__c = 0
                                                     ,Factored_Pipeline_v_Quota_Rolling_90D__c = 0
                                                     ,Week_Ending__c= endOfWeek
                                                     ,Month_Ending__c= endOfMonth
                                                     ,Quarter_Ending__c= endOfQuarter
                                                     ,Year_Ending__c= endOfYear
                                                     ));
            }
        }
        
        
        //====================
        //get User Quota Data
        map<Id, Sales_Rep_Quota__c> userQuotaMap = new map<Id, Sales_Rep_Quota__c>();
        map<Id, Decimal> totalAnnualQuotaMap = new map<Id, Decimal>();
        for(AggregateResult ar :[Select sum(s.Total_Annual_Quota_SR__c) Total_Annual_Quota_SR__c
                                        , sum(s.Total_Annual_Quota_RC__c) Total_Annual_Quota_RC__c
                                        , sum(s.Total_Annual_Quota_Other__c) Tot_Annual_Quota_Other__c
                                        , sum(s.Total_Annual_Quota_MCP__c) Total_Annual_Quota_MCP__c
                                        , sum(s.Total_Annual_Quota_MA__c) Total_Annual_Quota_MA__c
                                        , sum(s.Q4_M3_TK_Quota__c) Q4_M3_TK_Quota__c
                                        , sum(s.Q4_M3_SR_Quota__c) Q4_M3_SR_Quota__c
                                        , sum(s.Q4_M3_RC_Quota__c) Q4_M3_RC_Quota__c
                                        , sum(s.Q4_M3_Other_Quota__c) Q4_M3_Other_Quota__c
                                        , sum(s.Q4_M3_MCP_Quota__c) Q4_M3_MCP_Quota__c
                                        , sum(s.Q4_M3_MA_Quota__c) Q4_M3_MA_Quota__c
                                        , sum(Q4_M2_TK_Quota__c)    Q4_M2_TK_Quota__c 
                                        , sum(Q4_M2_SR_Quota__c)    Q4_M2_SR_Quota__c 
                                        , sum(Q4_M2_RC_Quota__c)    Q4_M2_RC_Quota__c 
                                        , sum(Q4_M2_Other_Quota__c) Q4_M2_Other_Quota__c 
                                        , sum(Q4_M2_MCP_Quota__c)   Q4_M2_MCP_Quota__c 
                                        , sum(Q4_M2_MA_Quota__c)    Q4_M2_MA_Quota__c 
                                        , sum(Q4_M1_TK_Quota__c)    Q4_M1_TK_Quota__c 
                                        , sum(Q4_M1_SR_Quota__c)    Q4_M1_SR_Quota__c 
                                        , sum(Q4_M1_RC_Quota__c)    Q4_M1_RC_Quota__c 
                                        , sum(Q4_M1_Other_Quota__c) Q4_M1_Other_Quota__c 
                                        , sum(Q4_M1_MCP_Quota__c)   Q4_M1_MCP_Quota__c 
                                        , sum(Q4_M1_MA_Quota__c)    Q4_M1_MA_Quota__c 
                                        , sum(Q3_Total_Quota__c)    Q3_Total_Quota__c 
                                        , sum(Q3_TK_Quota__c)   Q3_TK_Quota__c 
                                        , sum(Q3_SR_Quota__c)   Q3_SR_Quota__c 
                                        , sum(Q3_RC_Quota__c)   Q3_RC_Quota__c 
                                        , sum(Q3_Other_Quota__c)    Q3_Other_Quota__c 
                                        , sum(Q3_MCP_Quota__c)  Q3_MCP_Quota__c 
                                        , sum(Q3_MA_Quota__c)   Q3_MA_Quota__c 
                                        , sum(Q3_M3_TK_Quota__c)    Q3_M3_TK_Quota__c 
                                        , sum(Q3_M3_SR_Quota__c)    Q3_M3_SR_Quota__c 
                                        , sum(Q3_M3_RC_Quota__c)    Q3_M3_RC_Quota__c 
                                        , sum(Q3_M3_Other_Quota__c) Q3_M3_Other_Quota__c 
                                        , sum(Q3_M3_MCP_Quota__c)   Q3_M3_MCP_Quota__c 
                                        , sum(Q3_M3_MA_Quota__c)    Q3_M3_MA_Quota__c 
                                        , sum(Q3_M2_TK_Quota__c)    Q3_M2_TK_Quota__c 
                                        , sum(Q3_M2_SR_Quota__c)    Q3_M2_SR_Quota__c 
                                        , sum(Q3_M2_RC_Quota__c)    Q3_M2_RC_Quota__c 
                                        , sum(Q3_M2_Other_Quota__c) Q3_M2_Other_Quota__c 
                                        , sum(Q3_M2_MCP_Quota__c)   Q3_M2_MCP_Quota__c 
                                        , sum(Q3_M2_MA_Quota__c)    Q3_M2_MA_Quota__c 
                                        , sum(Q3_M1_TK_Quota__c)    Q3_M1_TK_Quota__c 
                                        , sum(Q3_M1_SR_Quota__c)    Q3_M1_SR_Quota__c 
                                        , sum(Q3_M1_RC_Quota__c)    Q3_M1_RC_Quota__c 
                                        , sum(Q3_M1_Other_Quota__c) Q3_M1_Other_Quota__c 
                                        , sum(Q3_M1_MCP_Quota__c)   Q3_M1_MCP_Quota__c 
                                        , sum(Q3_M1_MA_Quota__c)    Q3_M1_MA_Quota__c 
                                        , sum(Q2_Total_Quota__c)    Q2_Total_Quota__c 
                                        , sum(Q2_TK_Quota__c)   Q2_TK_Quota__c 
                                        , sum(Q2_SR_Quota__c)   Q2_SR_Quota__c 
                                        , sum(Q2_RC_Quota__c)   Q2_RC_Quota__c 
                                        , sum(Q2_Other_Quota__c)    Q2_Other_Quota__c 
                                        , sum(Q2_MCP_Quota__c)  Q2_MCP_Quota__c 
                                        , sum(Q2_MA_Quota__c)   Q2_MA_Quota__c 
                                        , sum(Q2_M3_TK_Quota__c)    Q2_M3_TK_Quota__c 
                                        , sum(Q2_M3_SR_Quota__c)    Q2_M3_SR_Quota__c 
                                        , sum(Q2_M3_RC_Quota__c)    Q2_M3_RC_Quota__c 
                                        , sum(Q2_M3_Other_Quota__c) Q2_M3_Other_Quota__c 
                                        , sum(Q2_M3_MCP_Quota__c)   Q2_M3_MCP_Quota__c 
                                        , sum(Q2_M3_MA_Quota__c)    Q2_M3_MA_Quota__c 
                                        , sum(Q2_M2_TK_Quota__c)    Q2_M2_TK_Quota__c 
                                        , sum(Q2_M2_SR_Quota__c)    Q2_M2_SR_Quota__c 
                                        , sum(Q2_M2_RC_Quota__c)    Q2_M2_RC_Quota__c 
                                        , sum(Q2_M2_Other_Quota__c) Q2_M2_Other_Quota__c 
                                        , sum(Q2_M2_MCP_Quota__c)   Q2_M2_MCP_Quota__c 
                                        , sum(Q2_M2_MA_Quota__c)    Q2_M2_MA_Quota__c 
                                        , sum(Q2_M1_TK_Quota__c)    Q2_M1_TK_Quota__c 
                                        , sum(Q2_M1_SR_Quota__c)    Q2_M1_SR_Quota__c 
                                        , sum(Q2_M1_RC_Quota__c)    Q2_M1_RC_Quota__c 
                                        , sum(Q2_M1_Other_Quota__c) Q2_M1_Other_Quota__c 
                                        , sum(Q2_M1_MCP_Quota__c)   Q2_M1_MCP_Quota__c 
                                        , sum(Q2_M1_MA_Quota__c)    Q2_M1_MA_Quota__c 
                                        , sum(Q1_Total_Quota__c)    Q1_Total_Quota__c 
                                        , sum(Q1_TK_Quota__c)   Q1_TK_Quota__c 
                                        , sum(Q1_SR_Quota__c)   Q1_SR_Quota__c 
                                        , sum(Q1_RC_Quota__c)   Q1_RC_Quota__c 
                                        , sum(Q1_Other_Quota__c)    Q1_Other_Quota__c 
                                        , sum(Q1_MCP_Quota__c)  Q1_MCP_Quota__c 
                                        , sum(Q1_MA_Quota__c)   Q1_MA_Quota__c 
                                        , sum(Q1_M3_TK_Quota__c)    Q1_M3_TK_Quota__c 
                                        , sum(Q1_M3_SR_Quota__c)    Q1_M3_SR_Quota__c 
                                        , sum(Q1_M3_RC_Quota__c)    Q1_M3_RC_Quota__c 
                                        , sum(Q1_M3_Other_Quota__c) Q1_M3_Other_Quota__c 
                                        , sum(Q1_M3_MCP_Quota__c)   Q1_M3_MCP_Quota__c 
                                        , sum(Q1_M3_MA_Quota__c)    Q1_M3_MA_Quota__c 
                                        , sum(Q1_M2_TK_Quota__c)    Q1_M2_TK_Quota__c 
                                        , sum(Q1_M2_SR_Quota__c)    Q1_M2_SR_Quota__c 
                                        , sum(Q1_M2_RC_Quota__c)    Q1_M2_RC_Quota__c 
                                        , sum(Q1_M2_Other_Quota__c) Q1_M2_Other_Quota__c 
                                        , sum(Q1_M2_MCP_Quota__c)   Q1_M2_MCP_Quota__c 
                                        , sum(Q1_M2_MA_Quota__c)    Q1_M2_MA_Quota__c 
                                        , sum(Q1_M1_TK_Quota__c)    Q1_M1_TK_Quota__c 
                                        , sum(Q1_M1_SR_Quota__c)    Q1_M1_SR_Quota__c 
                                        , sum(Q1_M1_RC_Quota__c)    Q1_M1_RC_Quota__c 
                                        , sum(Q1_M1_Other_Quota__c) Q1_M1_Other_Quota__c 
                                        , sum(Q1_M1_MCP_Quota__c)   Q1_M1_MCP_Quota__c 
                                        , sum(Q1_M1_MA_Quota__c)    Q1_M1_MA_Quota__c 
                                        , sum(Total_Annual_Quota__c) Total_Annual_Quota
                                     From Sales_Rep_Quota__c  s
                                    where User__c  in :users
                                      and Current_Quota__c = true])
        {
            totalAnnualQuotaMap.put(roles[0].Id, (Decimal) ar.get('Total_Annual_Quota'));
            userQuotaMap.put(roles[0].Id, new Sales_Rep_Quota__c(Q4_M3_TK_Quota__c  = (Decimal) ar.get('Q4_M3_TK_Quota__c')
                                                            ,   Q4_M3_SR_Quota__c   = (Decimal) ar.get('Q4_M3_SR_Quota__c')
                                                            ,   Q4_M3_RC_Quota__c   = (Decimal) ar.get('Q4_M3_RC_Quota__c')
                                                            ,   Q4_M3_Other_Quota__c    = (Decimal) ar.get('Q4_M3_Other_Quota__c')
                                                            ,   Q4_M3_MCP_Quota__c  = (Decimal) ar.get('Q4_M3_MCP_Quota__c')
                                                            ,   Q4_M3_MA_Quota__c   = (Decimal) ar.get('Q4_M3_MA_Quota__c')
                                                            ,   Q4_M2_TK_Quota__c   = (Decimal) ar.get('Q4_M2_TK_Quota__c')
                                                            ,   Q4_M2_SR_Quota__c   = (Decimal) ar.get('Q4_M2_SR_Quota__c')
                                                            ,   Q4_M2_RC_Quota__c   = (Decimal) ar.get('Q4_M2_RC_Quota__c')
                                                            ,   Q4_M2_Other_Quota__c    = (Decimal) ar.get('Q4_M2_Other_Quota__c')
                                                            ,   Q4_M2_MCP_Quota__c  = (Decimal) ar.get('Q4_M2_MCP_Quota__c')
                                                            ,   Q4_M2_MA_Quota__c   = (Decimal) ar.get('Q4_M2_MA_Quota__c')
                                                            ,   Q4_M1_TK_Quota__c   = (Decimal) ar.get('Q4_M1_TK_Quota__c')
                                                            ,   Q4_M1_SR_Quota__c   = (Decimal) ar.get('Q4_M1_SR_Quota__c')
                                                            ,   Q4_M1_RC_Quota__c   = (Decimal) ar.get('Q4_M1_RC_Quota__c')
                                                            ,   Q4_M1_Other_Quota__c    = (Decimal) ar.get('Q4_M1_Other_Quota__c')
                                                            ,   Q4_M1_MCP_Quota__c  = (Decimal) ar.get('Q4_M1_MCP_Quota__c')
                                                            ,   Q4_M1_MA_Quota__c   = (Decimal) ar.get('Q4_M1_MA_Quota__c')
                                                            ,   Q3_M3_TK_Quota__c   = (Decimal) ar.get('Q3_M3_TK_Quota__c')
                                                            ,   Q3_M3_SR_Quota__c   = (Decimal) ar.get('Q3_M3_SR_Quota__c')
                                                            ,   Q3_M3_RC_Quota__c   = (Decimal) ar.get('Q3_M3_RC_Quota__c')
                                                            ,   Q3_M3_Other_Quota__c    = (Decimal) ar.get('Q3_M3_Other_Quota__c')
                                                            ,   Q3_M3_MCP_Quota__c  = (Decimal) ar.get('Q3_M3_MCP_Quota__c')
                                                            ,   Q3_M3_MA_Quota__c   = (Decimal) ar.get('Q3_M3_MA_Quota__c')
                                                            ,   Q3_M2_TK_Quota__c   = (Decimal) ar.get('Q3_M2_TK_Quota__c')
                                                            ,   Q3_M2_SR_Quota__c   = (Decimal) ar.get('Q3_M2_SR_Quota__c')
                                                            ,   Q3_M2_RC_Quota__c   = (Decimal) ar.get('Q3_M2_RC_Quota__c')
                                                            ,   Q3_M2_Other_Quota__c    = (Decimal) ar.get('Q3_M2_Other_Quota__c')
                                                            ,   Q3_M2_MCP_Quota__c  = (Decimal) ar.get('Q3_M2_MCP_Quota__c')
                                                            ,   Q3_M2_MA_Quota__c   = (Decimal) ar.get('Q3_M2_MA_Quota__c')
                                                            ,   Q3_M1_TK_Quota__c   = (Decimal) ar.get('Q3_M1_TK_Quota__c')
                                                            ,   Q3_M1_SR_Quota__c   = (Decimal) ar.get('Q3_M1_SR_Quota__c')
                                                            ,   Q3_M1_RC_Quota__c   = (Decimal) ar.get('Q3_M1_RC_Quota__c')
                                                            ,   Q3_M1_Other_Quota__c    = (Decimal) ar.get('Q3_M1_Other_Quota__c')
                                                            ,   Q3_M1_MCP_Quota__c  = (Decimal) ar.get('Q3_M1_MCP_Quota__c')
                                                            ,   Q3_M1_MA_Quota__c   = (Decimal) ar.get('Q3_M1_MA_Quota__c')
                                                            ,   Q2_M3_TK_Quota__c   = (Decimal) ar.get('Q2_M3_TK_Quota__c')
                                                            ,   Q2_M3_SR_Quota__c   = (Decimal) ar.get('Q2_M3_SR_Quota__c')
                                                            ,   Q2_M3_RC_Quota__c   = (Decimal) ar.get('Q2_M3_RC_Quota__c')
                                                            ,   Q2_M3_Other_Quota__c    = (Decimal) ar.get('Q2_M3_Other_Quota__c')
                                                            ,   Q2_M3_MCP_Quota__c  = (Decimal) ar.get('Q2_M3_MCP_Quota__c')
                                                            ,   Q2_M3_MA_Quota__c   = (Decimal) ar.get('Q2_M3_MA_Quota__c')
                                                            ,   Q2_M2_TK_Quota__c   = (Decimal) ar.get('Q2_M2_TK_Quota__c')
                                                            ,   Q2_M2_SR_Quota__c   = (Decimal) ar.get('Q2_M2_SR_Quota__c')
                                                            ,   Q2_M2_RC_Quota__c   = (Decimal) ar.get('Q2_M2_RC_Quota__c')
                                                            ,   Q2_M2_Other_Quota__c    = (Decimal) ar.get('Q2_M2_Other_Quota__c')
                                                            ,   Q2_M2_MCP_Quota__c  = (Decimal) ar.get('Q2_M2_MCP_Quota__c')
                                                            ,   Q2_M2_MA_Quota__c   = (Decimal) ar.get('Q2_M2_MA_Quota__c')
                                                            ,   Q2_M1_TK_Quota__c   = (Decimal) ar.get('Q2_M1_TK_Quota__c')
                                                            ,   Q2_M1_SR_Quota__c   = (Decimal) ar.get('Q2_M1_SR_Quota__c')
                                                            ,   Q2_M1_RC_Quota__c   = (Decimal) ar.get('Q2_M1_RC_Quota__c')
                                                            ,   Q2_M1_Other_Quota__c    = (Decimal) ar.get('Q2_M1_Other_Quota__c')
                                                            ,   Q2_M1_MCP_Quota__c  = (Decimal) ar.get('Q2_M1_MCP_Quota__c')
                                                            ,   Q2_M1_MA_Quota__c   = (Decimal) ar.get('Q2_M1_MA_Quota__c')
                                                            ,   Q1_M3_TK_Quota__c   = (Decimal) ar.get('Q1_M3_TK_Quota__c')
                                                            ,   Q1_M3_SR_Quota__c   = (Decimal) ar.get('Q1_M3_SR_Quota__c')
                                                            ,   Q1_M3_RC_Quota__c   = (Decimal) ar.get('Q1_M3_RC_Quota__c')
                                                            ,   Q1_M3_Other_Quota__c    = (Decimal) ar.get('Q1_M3_Other_Quota__c')
                                                            ,   Q1_M3_MCP_Quota__c  = (Decimal) ar.get('Q1_M3_MCP_Quota__c')
                                                            ,   Q1_M3_MA_Quota__c   = (Decimal) ar.get('Q1_M3_MA_Quota__c')
                                                            ,   Q1_M2_TK_Quota__c   = (Decimal) ar.get('Q1_M2_TK_Quota__c')
                                                            ,   Q1_M2_SR_Quota__c   = (Decimal) ar.get('Q1_M2_SR_Quota__c')
                                                            ,   Q1_M2_RC_Quota__c   = (Decimal) ar.get('Q1_M2_RC_Quota__c')
                                                            ,   Q1_M2_Other_Quota__c    = (Decimal) ar.get('Q1_M2_Other_Quota__c')
                                                            ,   Q1_M2_MCP_Quota__c  = (Decimal) ar.get('Q1_M2_MCP_Quota__c')
                                                            ,   Q1_M2_MA_Quota__c   = (Decimal) ar.get('Q1_M2_MA_Quota__c')
                                                            ,   Q1_M1_TK_Quota__c   = (Decimal) ar.get('Q1_M1_TK_Quota__c')
                                                            ,   Q1_M1_SR_Quota__c   = (Decimal) ar.get('Q1_M1_SR_Quota__c')
                                                            ,   Q1_M1_RC_Quota__c   = (Decimal) ar.get('Q1_M1_RC_Quota__c')
                                                            ,   Q1_M1_Other_Quota__c    = (Decimal) ar.get('Q1_M1_Other_Quota__c')
                                                            ,   Q1_M1_MCP_Quota__c  = (Decimal) ar.get('Q1_M1_MCP_Quota__c')
                                                            ,   Q1_M1_MA_Quota__c   = (Decimal) ar.get('Q1_M1_MA_Quota__c')));
        }
        
        
        //======
        //Quota
        for(UserRole u : roles)
        {
            Sales_Rep_Quota__c q = userQuotaMap.get(u.Id);
            
            for(string lob : mapsLob.keySet())
            {
                MAPS_Reporting__c maps = summaryMap.get(u.Id + lob + dateToday);
                maps.Quota_Current_FY__c = Batch_Maps_Helper.getTotalAnnualQuota(mapsLob.get(lob).Field_Identifier__c, q);
            }
        }
        
        //================
        //CLOSED WON MTD
        for(AggregateResult ar : [select sum(amount) amt
                                        //, owner.UserRoleId
                                        , MAPS_Reporting_LOB__c
                                        , FISCAL_MONTH(CloseDate) month
                                        , FISCAL_YEAR(CloseDate) year
                                        , FISCAL_QUARTER(CloseDate) quarter
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = true
                                     and CALENDAR_MONTH(CloseDate) = :dateToday.month()
                                     and CALENDAR_YEAR(CloseDate) = :dateToday.year()
                                     and MAPS_Reporting_LOB__c in :lobSet
                                   group by MAPS_Reporting_LOB__c
                                          , FISCAL_MONTH(CloseDate) 
                                          , FISCAL_YEAR(CloseDate) 
                                          , FISCAL_QUARTER(CloseDate)])
        {
            string roleId = roles[0].Id; //The Single Role In Context
            string lob = (String)ar.get('MAPS_Reporting_LOB__c');
            string key = roleId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Closed_Won_MTD__c = (Decimal)ar.get('amt');
        
            Decimal amt = (Decimal)ar.get('amt');   
            
            //calculate MTD CosedWon vs. Quota
            Sales_Rep_Quota__c q = userQuotaMap.get(roleId);
            
            Double mtdQuota = 0;
            if(mapsLob.get(lob).Field_Identifier__c != null
              && q != null
              && q.get('Q'
                       + (Integer)ar.get('quarter')  
                       + '_M' + quarterMonthMap.get((Integer)ar.get('month'))
                       + '_'+mapsLob.get(lob).Field_Identifier__c+'_Quota__c') != null)
            {
                mtdQuota = Double.valueOf(q.get('Q'
                                               + (Integer)ar.get('quarter')  
                                               + '_M' + quarterMonthMap.get((Integer)ar.get('month'))
                                               + '_'+mapsLob.get(lob).Field_Identifier__c+'_Quota__c'));
            }
            
            if(mtdQuota != null && mtdQuota > 0)
                maps.Closed_Won_v_Quota_MTD__c = amt.divide(mtdQuota, 2) * 100;
        }
        
        
        //================
        //CLOSED WON YTD
        for(AggregateResult ar : [select sum(amount) amt
                                        , MAPS_Reporting_LOB__c
                                        , FISCAL_YEAR(CloseDate) year
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = true
                                     and FISCAL_YEAR(CloseDate) = :currentYear
                                     and MAPS_Reporting_LOB__c in :lobSet
                                   group by MAPS_Reporting_LOB__c 
                                          , FISCAL_YEAR(CloseDate)])
        {
            string roleId = roles[0].Id;
            string lob = (String)ar.get('MAPS_Reporting_LOB__c');
            string key = roleId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Closed_Won_YTD__c = (Decimal)ar.get('amt');
        
            //calculate MTD CosedWon vs. Quota
            Sales_Rep_Quota__c q = userQuotaMap.get(roleId);
            
            Double quota = Batch_Maps_Helper.getTotalAnnualQuota(mapsLob.get(lob).Field_Identifier__c, q);
            
            if(quota > 0)
                maps.Closed_Won_v_Quota_YTD__c = maps.Closed_Won_YTD__c.divide(quota, 2) * 100;
        }
        
        //===================
        //PIPELINE ROLLING 90
        for(AggregateResult ar : [select sum(amount) amt
                                        , sum(Factored_Amount__c) factAmt
                                        , MAPS_Reporting_LOB__c
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = false
                                     and isClosed = false
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate90
                                     and MAPS_Reporting_LOB__c in :lobSet
                                   group by MAPS_Reporting_LOB__c])
        {
            string roleId = roles[0].Id;
            string lob = (String)ar.get('MAPS_Reporting_LOB__c');
            string key = roleId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Pipeline_Rolling_90_Days__c = (Decimal)ar.get('amt');
            maps.Factored_Pipeline_Rolling_90_Days__c = (Decimal)ar.get('factAmt');
            
            
            
        }
        
        //===================
        //PIPELINE V. QUOTA ROLLING 90
        for(AggregateResult ar : [select sum(amount) amt
                                        , sum(Factored_Amount__c) factAmt
                                        , MAPS_Reporting_LOB__c
                                    from Opportunity
                                   where OwnerId in :users
                                     and ((IsWon = false
                                           and isClosed = false)
                                         OR
                                         (isClosed = true 
                                           and IsWon = true))
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate90
                                     and MAPS_Reporting_LOB__c in :lobSet
                                   group by MAPS_Reporting_LOB__c])
        {
            string roleId = roles[0].Id;
            string lob = (String)ar.get('MAPS_Reporting_LOB__c');
            string key = roleId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            Decimal amt = (Decimal)ar.get('amt');
            Decimal factAmt = (Decimal)ar.get('factAmt');
            
            
            Sales_Rep_Quota__c q = userQuotaMap.get(roleId);
            
            if(!mapsLob.containsKey(lob) || mapsLob.get(lob).Field_Identifier__c == null)
               continue;
               //8540688
            
            //get the quata data two months from now
            Double mtdQuota = Batch_Maps_Helper.getMonthQuota(currentFiscalMonth, currentFiscalQuarter, mapsLob.get(lob).Field_Identifier__c, q);
            
            //add the quata data one month from now
            mtdQuota += Batch_Maps_Helper.getMonthQuota(secondFiscalMonth, secondFiscalQuarter, mapsLob.get(lob).Field_Identifier__c,  q);
            
            //add the quata data for this fiscal month
            mtdQuota += Batch_Maps_Helper.getMonthQuota(thirdFiscalMonth, thirdFiscalQuarter, mapsLob.get(lob).Field_Identifier__c, q);
            
            if(mtdQuota != null && mtdQuota > 0)
            {
                maps.Pipeline_v_Quota_Rolling_90_Days__c = amt.divide(mtdQuota, 2) * 100;
                maps.Factored_Pipeline_v_Quota_Rolling_90D__c = factAmt.divide(mtdQuota, 2) * 100;
            }
            
        }
        
        //===================
        //PIPELINE ROLLING 12
        for(AggregateResult ar : [select sum(amount) amt
                                        , sum(Factored_Amount__c) factAmt
                                        , MAPS_Reporting_LOB__c
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = false
                                     and isClosed = false
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate12
                                     and MAPS_Reporting_LOB__c in :lobSet
                                   group by MAPS_Reporting_LOB__c])
        {
            string roleId = roles[0].Id;
            string lob = (String)ar.get('MAPS_Reporting_LOB__c');
            string key = roleId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Pipeline_Rolling_12_Months__c = (Decimal)ar.get('amt');
            maps.Factored_Pipeline_Rolling_12_Months__c = (Decimal)ar.get('factAmt');
        
        }
        
        //============================
        //PIPELINE V. QUOTA ROLLING 12
        for(AggregateResult ar : [select sum(amount) amt
                                        , sum(Factored_Amount__c) factAmt
                                        , MAPS_Reporting_LOB__c
                                    from Opportunity
                                   where OwnerId in :users
                                     and ((IsWon = false
                                           and isClosed = false)
                                         OR
                                         (isClosed = true 
                                           and IsWon = true))
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate12
                                     and MAPS_Reporting_LOB__c in :lobSet
                                   group by MAPS_Reporting_LOB__c])
        {
            string roleId = roles[0].Id;
            string lob = (String)ar.get('MAPS_Reporting_LOB__c');
            string key = roleId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            Decimal amt = (Decimal)ar.get('amt');
            Decimal factAmt = (Decimal)ar.get('factAmt');   
            //calculate rolling 12 vs. Quota
            Sales_Rep_Quota__c q = userQuotaMap.get(roleId);
            
            Double mtdQuota = Batch_Maps_Helper.getTotalAnnualQuota(mapsLob.get(lob).Field_Identifier__c,q);
            
            if(mtdQuota != null && mtdQuota > 0)
            {
                maps.Pipeline_v_Quota_Rolling_12_Months__c = amt.divide(mtdQuota, 2) * 100;
                maps.Factored_Pipeline_v_Quota_Rolling_12M__c = factAmt.divide(mtdQuota, 2) * 100;
            }
        }
        
        //=========================
        //MAJOR PROJECTS ROLLING 90
        for(AggregateResult ar : [select sum(amount) amt
                                        //, owner.UserRoleId
                                        , MAPS_Reporting_LOB__c
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = false
                                     and isClosed = false
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate90
                                     and MAPS_Reporting_LOB__c in :lobSet
                                     and Major_Project__c = true
                                   group by MAPS_Reporting_LOB__c])
        {
            string roleId = roles[0].Id;
            string key = roleId + ar.get('MAPS_Reporting_LOB__c') + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Major_Projects_Rolling_90_Days__c = (Decimal)ar.get('amt');
        }
        
        //=========================
        //MAJOR PROJECTS ROLLING 12
        for(AggregateResult ar : [select sum(amount) amt
                                        //, owner.UserRoleId
                                        , MAPS_Reporting_LOB__c
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = false
                                     and isClosed = false
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate12
                                     and MAPS_Reporting_LOB__c in :lobSet
                                     and Major_Project__c = true
                                   group by MAPS_Reporting_LOB__c])
        {
            string roleId = roles[0].Id;
            string key = roleId + ar.get('MAPS_Reporting_LOB__c') + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Major_Projects_Rolling_12_Months__c = (Decimal)ar.get('amt');
        }
        
        System.Debug(':::summaryMap:::'+summaryMap);
        //======================
        //upsert the map records
        list<Database.UpsertResult> res = Database.upsert(summaryMap.values(), MAPS_Reporting__c.Processing_ID__c, true);//all or nothing
        
        
    }
    
    
    
    global void finish(Database.BatchableContext BC){

    }
    
    

}