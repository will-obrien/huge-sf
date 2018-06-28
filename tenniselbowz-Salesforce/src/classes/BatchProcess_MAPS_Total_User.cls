global class BatchProcess_MAPS_Total_User implements Database.Batchable<sObject>{

     
    global Database.querylocator start(Database.BatchableContext BC){ 
        UserRole startingRole = [Select Id from UserRole where name = 'Service'];
        set<Id> roleIds = Batch_Maps_Helper.getAllSubRoleIds(new set<Id>{startingRole.Id});
        
        System.debug(':::roleIds ::: '+roleIds);
        
        roleIds.add(startingRole.Id);
        return Database.getQueryLocator([Select Id, IsActive, name, UserRoleId, UserRole.Name, UserRole.ParentRoleId
                                           from User 
                                          where UserRoleId in :roleIds
                                            and Exclude_User_for_Quota_Planning__c = false order by CreatedDate desc ]);
        
    }

    //Main execute method
    global void execute(Database.BatchableContext BC, List<User> users){
        
           
        //yesterday's Date. Context for the batch iteration
        Date dateToday = Batch_Maps_Helper.getToday();
        
        //start and end dates for rolling dates
        Date startMonth = Batch_Maps_Helper.getStartMonth();
        Date endDate90 = Batch_Maps_Helper.getEndDate90();
        Date endDate12 = Batch_Maps_Helper.getEndDate12(); 
        
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
        
        
        string lob = 'Total';
        
        
        map<Id, String> parentRoleNameMap = new map<Id, String>();
        set<Id> parentRoleIdSet = new set<Id>();
        for(User u : users)
          parentRoleIdSet.add(u.UserRole.ParentRoleId);
          
        for(UserRole r : [Select Name, Id from UserRole where Id in :parentRoleIdSet])
            parentRoleNameMap.put(r.Id, r.Name);
        
        //=============================================================
        //Create a container for each summary utilizing an external key
        /*for(User u : users)
        { 
            string mapKey = u.Id+lob+system.today().addDays(-1);
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
                                                 ,Strategic_Accounts_Current_Number__c = 0
                                                 ,Quota_Current_FY__c = 0
                                                 ,Summary_Name__c = u.Name
                                                 ,Summary_Type_Id__c = u.Id
                                                 ,Summary_Level__c = 'Total'
                                                 ,Summary_Parent_Name__c = parentRoleNameMap.get(u.UserRole.ParentRoleId)
                                                 ,Summary_Parent_Id__c = u.UserRole.ParentRoleId
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
        
        */
         for(User u : users)
        { 
			if(u.isActive ==TRUE){
				string mapKey = u.Id+lob+system.today().addDays(-1);
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
                                                 ,Strategic_Accounts_Current_Number__c = 0
                                                 ,Quota_Current_FY__c = 0
                                                 ,Summary_Name__c = u.Name
                                                 ,Summary_Type_Id__c = u.Id
                                                 ,OwnerId = u.id
                                                 ,Summary_Level__c = 'Total'
                                                 ,Summary_Parent_Name__c = parentRoleNameMap.get(u.UserRole.ParentRoleId)
                                                 ,Summary_Parent_Id__c = u.UserRole.ParentRoleId
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
			else {
				string mapKey = u.Id+lob+system.today().addDays(-1);
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
                                                 ,Strategic_Accounts_Current_Number__c = 0
                                                 ,Quota_Current_FY__c = 0
                                                 ,Summary_Name__c = u.Name
                                                 ,Summary_Type_Id__c = u.Id
                                                 ,Summary_Level__c = 'Total'
                                                 ,Summary_Parent_Name__c = parentRoleNameMap.get(u.UserRole.ParentRoleId)
                                                 ,Summary_Parent_Id__c = u.UserRole.ParentRoleId
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
        for(Sales_Rep_Quota__c q :[Select s.User__c, s.Total_Annual_Quota__c, s.Total_Annual_Quota_TK__c, s.Total_Annual_Quota_SR__c, s.Total_Annual_Quota_RC__c, s.Total_Annual_Quota_Other__c, s.Total_Annual_Quota_MCP__c, s.Total_Annual_Quota_MA__c, s.Q4_Total_Quota__c, s.Q4_TK_Quota__c, s.Q4_SR_Quota__c, s.Q4_RC_Quota__c, s.Q4_Other_Quota__c, s.Q4_MCP_Quota__c, s.Q4_MA_Quota__c, s.Q4_M3_TK_Quota__c, s.Q4_M3_SR_Quota__c, s.Q4_M3_RC_Quota__c, s.Q4_M3_Other_Quota__c, s.Q4_M3_MCP_Quota__c, s.Q4_M3_MA_Quota__c, s.Q4_M2_TK_Quota__c, s.Q4_M2_SR_Quota__c, s.Q4_M2_RC_Quota__c, s.Q4_M2_Other_Quota__c, s.Q4_M2_MCP_Quota__c, s.Q4_M2_MA_Quota__c, s.Q4_M1_TK_Quota__c, s.Q4_M1_SR_Quota__c, s.Q4_M1_RC_Quota__c, s.Q4_M1_Other_Quota__c, s.Q4_M1_MCP_Quota__c, s.Q4_M1_MA_Quota__c, s.Q3_Total_Quota__c, s.Q3_TK_Quota__c, s.Q3_SR_Quota__c, s.Q3_RC_Quota__c, s.Q3_Other_Quota__c, s.Q3_MCP_Quota__c, s.Q3_MA_Quota__c, s.Q3_M3_TK_Quota__c, s.Q3_M3_SR_Quota__c, s.Q3_M3_RC_Quota__c, s.Q3_M3_Other_Quota__c, s.Q3_M3_MCP_Quota__c, s.Q3_M3_MA_Quota__c, s.Q3_M2_TK_Quota__c, s.Q3_M2_SR_Quota__c, s.Q3_M2_RC_Quota__c, s.Q3_M2_Other_Quota__c, s.Q3_M2_MCP_Quota__c, s.Q3_M2_MA_Quota__c, s.Q3_M1_TK_Quota__c, s.Q3_M1_SR_Quota__c, s.Q3_M1_RC_Quota__c, s.Q3_M1_Other_Quota__c, s.Q3_M1_MCP_Quota__c, s.Q3_M1_MA_Quota__c, s.Q2_Total_Quota__c, s.Q2_TK_Quota__c, s.Q2_SR_Quota__c, s.Q2_RC_Quota__c, s.Q2_Other_Quota__c, s.Q2_MCP_Quota__c, s.Q2_MA_Quota__c, s.Q2_M3_TK_Quota__c, s.Q2_M3_SR_Quota__c, s.Q2_M3_RC_Quota__c, s.Q2_M3_Other_Quota__c, s.Q2_M3_MCP_Quota__c, s.Q2_M3_MA_Quota__c, s.Q2_M2_TK_Quota__c, s.Q2_M2_SR_Quota__c, s.Q2_M2_RC_Quota__c, s.Q2_M2_Other_Quota__c, s.Q2_M2_MCP_Quota__c, s.Q2_M2_MA_Quota__c, s.Q2_M1_TK_Quota__c, s.Q2_M1_SR_Quota__c, s.Q2_M1_RC_Quota__c, s.Q2_M1_Other_Quota__c, s.Q2_M1_MCP_Quota__c, s.Q2_M1_MA_Quota__c, s.Q1_Total_Quota__c, s.Q1_TK_Quota__c, s.Q1_SR_Quota__c, s.Q1_RC_Quota__c, s.Q1_Other_Quota__c, s.Q1_MCP_Quota__c, s.Q1_MA_Quota__c, s.Q1_M3_TK_Quota__c, s.Q1_M3_SR_Quota__c, s.Q1_M3_RC_Quota__c, s.Q1_M3_Other_Quota__c, s.Q1_M3_MCP_Quota__c, s.Q1_M3_MA_Quota__c, s.Q1_M2_TK_Quota__c, s.Q1_M2_SR_Quota__c, s.Q1_M2_RC_Quota__c, s.Q1_M2_Other_Quota__c, s.Q1_M2_MCP_Quota__c, s.Q1_M2_MA_Quota__c, s.Q1_M1_TK_Quota__c, s.Q1_M1_SR_Quota__c, s.Q1_M1_RC_Quota__c, s.Q1_M1_Other_Quota__c, s.Q1_M1_MCP_Quota__c, s.Q1_M1_MA_Quota__c, s.Name, s.FY_Q4_M3_Total_Quota__c, s.FY_Q4_M2_Total_Quota__c, s.FY_Q4_M1_Total_Quota__c, s.FY_Q3_M3_Total_Quota__c, s.FY_Q3_M2_Total_Quota__c, s.FY_Q3_M1_Total_Quota__c, s.FY_Q2_M3_Total_Quota__c, s.FY_Q2_M2_Total_Quota__c, s.FY_Q2_M1_Total_Quota__c, s.FY_Q1_M3_Total_Quota__c, s.FY_Q1_M2_Total_Quota__c, s.FY_Q1_M1_Total_Quota__c 
                                     From Sales_Rep_Quota__c s
                                    where User__c in :users
                                      and Current_Quota__c = true])
        {
            userQuotaMap.put(q.User__c, q);
        }
        
        //======
        // Quota
        for(User u : users)
        {
            Sales_Rep_Quota__c q = userQuotaMap.get(u.Id);
            
            MAPS_Reporting__c maps = summaryMap.get(u.Id + lob + dateToday);
            
            if(q != null)
                maps.Quota_Current_FY__c = q.Total_Annual_Quota__c;
            
        }
        
        //================
        //CLOSED WON MTD
        for(AggregateResult ar : [select sum(amount) amt
                                        , FISCAL_MONTH(CloseDate) month
                                        , FISCAL_YEAR(CloseDate) year
                                        , FISCAL_QUARTER(CloseDate) quarter
                                        , OwnerId
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = true
                                     and CALENDAR_MONTH(CloseDate) = :dateToday.month()
                                     and CALENDAR_YEAR(CloseDate) = :dateToday.year()
                                   group by FISCAL_MONTH(CloseDate) 
                                          , FISCAL_YEAR(CloseDate) 
                                          , FISCAL_QUARTER(CloseDate)
                                          , OwnerId])
        {
            string ownerId = (String)ar.get('OwnerId'); 
            string key = ownerId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Closed_Won_MTD__c = (Decimal)ar.get('amt');
            
        }
        
        for(AggregateResult ar : [select sum(amount) amt
                                        , ownerId
                                        , FISCAL_MONTH(CloseDate) month
                                        , FISCAL_YEAR(CloseDate) year
                                        , FISCAL_QUARTER(CloseDate) quarter
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = true
                                     and CALENDAR_MONTH(CloseDate) = :dateToday.month()
                                     and CALENDAR_YEAR(CloseDate) = :dateToday.year()
                                     and MAPS_Reporting_LOB__c in 
                                     ('MA - New','SR - Quoted','TK')
                                   group by FISCAL_MONTH(CloseDate) 
                                          , FISCAL_YEAR(CloseDate) 
                                          , ownerId
                                          , FISCAL_QUARTER(CloseDate)])
        {
            string ownerId = (String)ar.get('ownerId'); 
            string key = ownerId + lob + dateToday;
            Decimal amt = (Decimal)ar.get('amt');
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
        
            //calculate MTD CosedWon vs. Quota
            Sales_Rep_Quota__c q = userQuotaMap.get(ownerId);
            
            //SUM(Opportunity.Amount) / SUM (Sales_Rep_Quota__c.FY_Q?_M?_MA_Quota__c)
            
            Double mtdQuota = 0;
            if(q != null
               && q.get('FY_Q'
                       + (Integer)ar.get('quarter')  
                       + '_M' + quarterMonthMap.get((Integer)ar.get('month'))
                       + '_Total_Quota__c') != null)
            {
                mtdQuota = Double.valueOf(q.get('FY_Q'
                                               + (Integer)ar.get('quarter')  
                                               + '_M' + quarterMonthMap.get((Integer)ar.get('month'))
                                               + '_Total_Quota__c'));
            }
            
            if(mtdQuota != null && mtdQuota > 0)
                maps.Closed_Won_v_Quota_MTD__c = amt.divide(mtdQuota, 2) * 100;
        }
        
        
        //================
        //CLOSED WON YTD
        for(AggregateResult ar : [select sum(amount) amt
                                        , ownerId
                                        , FISCAL_YEAR(CloseDate) year
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = true
                                     and FISCAL_YEAR(CloseDate) = :currentYear
                                   group by FISCAL_YEAR(CloseDate)
                                          , ownerId])
        {
            string ownerId = (String)ar.get('ownerId'); 
            string key = ownerId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Closed_Won_YTD__c = (Decimal)ar.get('amt');
            
        }   
        //=======================
        // CLOSED WON YTD v QUOTA
        for(AggregateResult ar : [select sum(amount) amt
                                        , ownerId
                                        , FISCAL_YEAR(CloseDate) year
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = true
                                     and FISCAL_YEAR(CloseDate) = :currentYear
                                     and MAPS_Reporting_LOB__c in 
                                     ('MA - New','SR - Quoted','TK')
                                   group by ownerId, FISCAL_YEAR(CloseDate)])
        {
            string ownerId = (String)ar.get('ownerId'); 
            string key = ownerId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            Decimal amt = (Decimal)ar.get('amt');
            //calculate MTD CosedWon vs. Quota
            Sales_Rep_Quota__c q = userQuotaMap.get(ownerId);
            if(q != null)
            {
                Decimal quota = (q.Total_Annual_Quota__c == null ? 0:q.Total_Annual_Quota__c);
                
                if(quota > 0)
                    maps.Closed_Won_v_Quota_YTD__c = amt.divide(quota, 2) * 100;
            }
                
            
        }
        
        //===================
        //PIPELINE ROLLING 90
        for(AggregateResult ar : [select sum(Factored_Amount__c) factAmt
                                        , sum(amount) amt
                                        , ownerId
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = false
                                     and isClosed = false
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate90
                                   group by OwnerId])
        {
            string ownerId = (String)ar.get('ownerId'); 
            string key = ownerId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Pipeline_Rolling_90_Days__c = (Double)ar.get('amt');
            maps.Factored_Pipeline_Rolling_90_Days__c = (Decimal)ar.get('factAmt');
        }
        
        //=============================
        //PIPELINE ROLLING VS. QUOTA 90
        for(AggregateResult ar : [select sum(amount) amt
                                        , sum(Factored_Amount__c) factAmt
                                        , ownerId
                                    from Opportunity
                                   where OwnerId in :users
                                     and ((IsWon = false
                                           and isClosed = false)
                                         OR
                                         (isClosed = true 
                                           and IsWon = true))
                                     and MAPS_Reporting_LOB__c in 
                                     ('MA - New','SR - Quoted','TK')
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate90
                                   group by OwnerId])
        {
            string ownerId = (String)ar.get('ownerId'); 
            string key = ownerId + lob + dateToday;
            
            Decimal amt = (Decimal)ar.get('amt');
            Decimal factAmt = (Decimal)ar.get('factAmt');
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
        
            //calculate rolling 90 vs. Quota
            Sales_Rep_Quota__c q = userQuotaMap.get(ownerId);
            
            Double mtdQuota = 0;//Batch_Maps_Helper.getTotalMonthlyQuota(rateMonth, rateQuarter,  q);
            
            //get the quota for the fiscal quarter two months from now...
            if(q != null
               && q.get('FY_Q'+ thirdFiscalQuarter 
                       + '_M' + thirdFiscalMonth
                       + '_Total_Quota__c') != null)
            {
                mtdQuota += Double.valueOf(q.get('FY_Q' + thirdFiscalQuarter 
                                               + '_M' + thirdFiscalMonth
                                               + '_Total_Quota__c'));
            }
            
            //add the quota for the quarter one months from now...
            if(q != null
               && q.get('FY_Q'+ secondFiscalQuarter 
                       + '_M' + secondFiscalMonth
                       + '_Total_Quota__c') != null)
            {
                mtdQuota += Double.valueOf(q.get('FY_Q' + secondFiscalQuarter 
                                               + '_M' + secondFiscalMonth
                                               + '_Total_Quota__c'));
            }
            
            //add the current month's quota
            if(q != null
               && q.get('FY_Q'+ currentFiscalQuarter 
                       + '_M' + currentFiscalMonth
                       + '_Total_Quota__c') != null)
            {
                mtdQuota += Double.valueOf(q.get('FY_Q' + currentFiscalQuarter 
                                               + '_M' + currentFiscalMonth
                                               + '_Total_Quota__c'));
            }
            
            if(mtdQuota != null && mtdQuota > 0 && amt != null && factAmt != null)
            {
                maps.Pipeline_v_Quota_Rolling_90_Days__c = amt.divide(mtdQuota, 2) * 100;
                maps.Factored_Pipeline_v_Quota_Rolling_90D__c = factAmt.divide(mtdQuota, 2) * 100;
            }
        }
        
        //===================
        //PIPELINE ROLLING 12
        for(AggregateResult ar : [select sum(amount) amt
                                        , sum(Factored_Amount__c) factAmt
                                        , ownerId
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = false
                                     and isClosed = false
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate12
                                   group by OwnerId])
        {
            string ownerId = (String)ar.get('ownerId'); 
            string key = ownerId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Pipeline_Rolling_12_Months__c = (Double)ar.get('amt');
            maps.Factored_Pipeline_Rolling_12_Months__c = (Decimal)ar.get('factAmt');
            
        }
        
        //===================
        //PIPELINE V. QUOTA ROLLING 12
        for(AggregateResult ar : [select sum(amount) amt
                                        , sum(Factored_Amount__c) factAmt
                                        , ownerId
                                    from Opportunity
                                   where OwnerId in :users
                                     and ((IsWon = false
                                           and isClosed = false)
                                         OR
                                         (isClosed = true 
                                           and IsWon = true))
                                     and MAPS_Reporting_LOB__c in 
                                     ('MA - New','SR - Quoted','TK')
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate12
                                   group by OwnerId])
        {
            string ownerId = (String)ar.get('ownerId'); 
            string key = ownerId + lob + dateToday;
            
            Decimal amt = (Decimal)ar.get('amt');
            Decimal factAmt = (Decimal)ar.get('factAmt');
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
        
            //calculate rolling 12 vs. Quota
            Sales_Rep_Quota__c q = userQuotaMap.get(ownerId);
            
            Double mtdQuota = 0;
            
            if(q != null)
            {   
                mtdQuota = q.Total_Annual_Quota__c;
            }
            if(mtdQuota != null && mtdQuota > 0)
            {
                maps.Pipeline_v_Quota_Rolling_12_Months__c = amt.divide(mtdQuota, 2) * 100;
                maps.Factored_Pipeline_v_Quota_Rolling_12M__c = factAmt.divide(mtdQuota, 2) * 100;
            }
        }
        
        //=========================
        //MAJOR PROJECTS ROLLING 90
        for(AggregateResult ar : [select sum(amount) amt
                                       , ownerId
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = false
                                     and isClosed = false
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate90
                                     and Major_Project__c = true
                                   group by OwnerId])
        {
            string ownerId = (String)ar.get('ownerId'); 
            string key = ownerId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Major_Projects_Rolling_90_Days__c = (Decimal)ar.get('amt');
        }
        
        //=========================
        //MAJOR PROJECTS ROLLING 12
        for(AggregateResult ar : [select sum(amount) amt
                                        , ownerId
                                    from Opportunity
                                   where OwnerId in :users
                                     and IsWon = false
                                     and isClosed = false
                                     and CloseDate >= :startMonth
                                     and CloseDate <= :endDate12
                                     and Major_Project__c = true
                                   group by OwnerId])
        {
            string ownerId = (String)ar.get('ownerId'); 
            string key = ownerId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Major_Projects_Rolling_12_Months__c = (Decimal)ar.get('amt');
        }
        
        //========================
        //Count Strategic Accounts
        for(AggregateResult ar : [select count(Id) cnt
                                        , ownerId
                                    from Account
                                   where OwnerId in :users
                                     and Account_Type__c = 'Strategic'
                                   group by ownerId])
        {
            string ownerId = (String)ar.get('ownerId'); 
            string key = ownerId + lob + dateToday;
            
            //assume our key exists. Blow up othersise
            MAPS_Reporting__c maps = summaryMap.get(key);
            maps.Strategic_Accounts_Current_Number__c = (Integer)ar.get('cnt');
        }
        
        //======
        //Quota
        for(User u : users)
        {
            Sales_Rep_Quota__c q = userQuotaMap.get(u.Id);
            
            MAPS_Reporting__c maps = summaryMap.get(u.Id + lob + dateToday);
            if(q != null)
                maps.Quota_Current_FY__c = q.Total_Annual_Quota__c;
            
        }
        
        
        System.Debug(':::summaryMap:::'+summaryMap);
        //======================
        //upsert the map records
        list<Database.UpsertResult> res = Database.upsert(summaryMap.values(), MAPS_Reporting__c.Processing_ID__c, true);//all or nothing
        
    }
    
    
    
    global void finish(Database.BatchableContext BC){

    }
    
    
     
    
}