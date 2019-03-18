global with sharing class Batch_Maps_Helper 
{
    
    //===============================================
    //today's Date. Context for the batch iteration
    global static Date getToday()
    {
        return System.today().addDays(-1);
    } 
    
    //===============================================
    //start and ed dates for rolling dates
    global static Date getStartMonth()
    {
        Date dateToday = getToday();
        return Date.newInstance(dateToday.year(), dateToday.month(), 1);
    }
    
    //===============================================
    //end date for rolling 90
    global static Date getEndDate90()
    {
        Date dateToday = getToday();
        return  Date.newInstance(dateToday.AddMonths(2).year()
                                 , dateToday.AddMonths(2).month()
                                 , Date.daysInMonth(dateToday.AddMonths(2).year(), dateToday.AddMonths(2).month()) );
    }
    
    //===============================================
    //end date for rolling 12 months
    global static Date getEndDate12()
    {
        Date dateToday = getToday();
        return Date.newInstance(dateToday.AddMonths(11).year()
                                    , dateToday.AddMonths(11).month()
                                    , Date.daysInMonth(dateToday.AddMonths(11).year(), dateToday.AddMonths(11).month()) );
    }
    
    
    //===============================================
    // END OF WEEK
    global static boolean isEndOfWeek()
    {
        string dayOfWeek = System.now().addDays(-1).format('E');// dayOfWeek is Sun, Mon, Tue, etc.
        boolean endOfWeek = false;
        if(dayOfWeek == 'Sat')
          endOfWeek = true;
          
        return endOfWeek;
    }
    
    //===============================================
    //END OF MONTH  
    global static boolean isEndOfMonth()
    {
        Integer numberOfDays = Date.daysInMonth(getToday().year(), getToday().month());
        boolean endOfMonth = false;
        if(numberOfDays == getToday().day())
          endOfMonth = true;
          
        return endOfMonth;
    }
    
    //===============================================
    //END OF QUARTER IN THE CONTEXT OF YESTERDAY
    global static boolean isEndOfQuarter()
    {
        Date quarterEndDate;
        if(isStartOfQuarter())
        {
        	quarterEndDate = [Select EndDate From Period Where type = 'Quarter' and StartDate = LAST_FISCAL_QUARTER].EndDate;
        }
        else
        {
        	quarterEndDate = [Select EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].EndDate;
        }
        
        boolean endOfQuarter = false;
        if(getToday() == quarterEndDate)
          endOfQuarter = true;
          
        return endOfQuarter;
    }
    
    //===============================================
    //START OF QUARTER in the Context of TODAY
    global static boolean isStartOfQuarter()
    {
        Date quarterStartDate = [Select StartDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].StartDate;
        boolean startOfQuarter = false;
        if(System.Today() == quarterStartDate)
          startOfQuarter = true;
          
        return startOfQuarter;
    }
      
    //===============================================
    //END OF YEAR IN THE CONTEXT OF YESTERDAY
    global static boolean isEndOfYear()
    {
        boolean endOfYear = false;
        date yearEnd;
        if(isStartOfYear())
        {
        	yearEnd = [Select EndDate From Period Where type = 'Year' and StartDate = LAST_FISCAL_YEAR].EndDate;
        }
        
        else
        {
        	yearEnd = [Select EndDate From Period Where type = 'Year' and StartDate = THIS_FISCAL_YEAR].EndDate;
        }
        if(getToday() == yearEnd)
          endOfYear = true;
          
        return endOfYear;
    }
    
    //===============================================
    //START OF FISCAL YEAR IN THE CONTEXT OF TODAY
    global static boolean isStartOfYear()
    {
        boolean startOfYear = false;
        Date yearstart = [Select startDate From Period Where type = 'Year' and StartDate = THIS_FISCAL_YEAR].startDate;
        if(System.Today() == yearstart)
          startOfYear = true;
          
        return startOfYear;
    }
    
        
     //===============================================
     //Month relative to quarter
     global static map<Integer, Integer> getQuarterMonthMap()
     {
        map<Integer, Integer> qMap = new map<Integer, Integer>();
        qMap.put(1,1);
        qMap.put(2,2);
        qMap.put(3,3);
        qMap.put(4,1);
        qMap.put(5,2);
        qMap.put(6,3);
        qMap.put(7,1);
        qMap.put(8,2);
        qMap.put(9,3);
        qMap.put(10,1);
        qMap.put(11,2);
        qMap.put(12,3);
        
        return qMap;
     }
     
     //===============================================
     // - Fiscal Quarter
     global static Integer getCurrFiscalQuarter()
     {
     	if(isStartOfQuarter())
     	{
     		for(Period p : [Select p.Number From Period p Where p.type = 'Quarter' and p.StartDate = LAST_FISCAL_QUARTER])
	          return p.Number;
     	}
     	else
     	{
	        for(Period p : [Select p.Number From Period p Where p.type = 'Quarter' and p.StartDate = THIS_FISCAL_QUARTER])
	          return p.Number;
     	}
          
        return 1;
     }
     
     //===============================================
     // - Fiscal Quarter Given a date
     global static Integer getCurrFiscalQuarter(Date startDate)
     {
        Date stDate = Date.newInstance(startDate.year(), startDate.month(), 1);
        for(Period p : [Select p.Number From Period p Where p.type = 'Quarter' and p.StartDate <= :stDate and p.EndDate > :stDate])
          return p.Number; 
          
        return 1;
     }
     
     //===============================================
     //Fiscal Year
     global static Integer getCurrFiscalYear()
     {
        if(isStartOfYear())
        {
        	for(Period p : [Select PeriodLabel, p.StartDate From Period p Where p.type = 'Year' and p.StartDate = LAST_FISCAL_YEAR])
          		return p.StartDate.year();
        }
        else
        {
	        for(Period p : [Select PeriodLabel, p.StartDate From Period p Where p.type = 'Year' and p.StartDate = THIS_FISCAL_YEAR])
	          return p.StartDate.year();
        }
          
          
        return 1;
     }
     
     //===============================================
     //Fiscal Year
     global static Date getCurrFiscalDate()
     {
        Date curDate = getToday();
        Date d = Date.newinstance(curDate.year(),curDate.month(),1);
        for(Period p : [Select PeriodLabel, p.StartDate From Period p where p.StartDate = :d])
          return p.StartDate;
          
          
        return curDate;
     }
     
     //===============================================
     //replicates summary functions on Sales Rep Quota object
     global static Double getTotalAnnualQuota(string fieldId, Sales_Rep_Quota__c q)
     {
        
        Double totalAnualQuota = 0;
        if( fieldId != null && q != null)
        {   
            totalAnualQuota 
              = Double.valueOf(q.get('Q1_M1_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q1_M1_'+fieldId+'_Quota__c'))
              + Double.valueOf(q.get('Q2_M1_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q2_M1_'+fieldId+'_Quota__c'))
              + Double.valueOf(q.get('Q3_M1_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q3_M1_'+fieldId+'_Quota__c'))
              + Double.valueOf(q.get('Q4_M1_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q4_M1_'+fieldId+'_Quota__c'))
              
              + Double.valueOf(q.get('Q1_M2_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q1_M2_'+fieldId+'_Quota__c'))
              + Double.valueOf(q.get('Q2_M2_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q2_M2_'+fieldId+'_Quota__c'))
              + Double.valueOf(q.get('Q3_M2_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q3_M2_'+fieldId+'_Quota__c'))
              + Double.valueOf(q.get('Q4_M2_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q4_M2_'+fieldId+'_Quota__c'))
              
              + Double.valueOf(q.get('Q1_M3_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q1_M3_'+fieldId+'_Quota__c'))
              + Double.valueOf(q.get('Q2_M3_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q2_M3_'+fieldId+'_Quota__c'))
              + Double.valueOf(q.get('Q3_M3_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q3_M3_'+fieldId+'_Quota__c'))
              + Double.valueOf(q.get('Q4_M3_'+fieldId+'_Quota__c') == null ? 0 : q.get('Q4_M3_'+fieldId+'_Quota__c'));
        }
            
        return totalAnualQuota;
     }
     
     
     
     global static Double getTotalAnnualQuota(Sales_Rep_Quota__c q)
     {
        
        Double totalAnualQuota = 0;
        //if(q != null)
        //{ 
            totalAnualQuota 
              = Double.valueOf(q.Q1_MA_Quota__c==null ? 0 : q.Q1_MA_Quota__c) 
              + Double.valueOf(q.Q1_SR_Quota__c==null ? 0 : q.Q1_SR_Quota__c) 
              + Double.valueOf(q.Q1_TK_Quota__c ==null ? 0 : q.Q1_TK_Quota__c) 
              + Double.valueOf(q.Q1_RC_Quota__c==null ? 0 : q.Q1_RC_Quota__c) 
              + Double.valueOf(q.Q1_MCP_Quota__c ==null ? 0 : q.Q1_MCP_Quota__c) 
              + Double.valueOf(q.Q1_Other_Quota__c ==null ? 0 : q.Q1_Other_Quota__c)
              
              + Double.valueOf(q.Q2_MA_Quota__c==null ? 0 : q.Q2_MA_Quota__c) 
              + Double.valueOf(q.Q2_SR_Quota__c==null ? 0 : q.Q2_SR_Quota__c) 
              + Double.valueOf(q.Q2_TK_Quota__c ==null ? 0 : q.Q2_TK_Quota__c) 
              + Double.valueOf(q.Q2_RC_Quota__c==null ? 0 : q.Q2_RC_Quota__c) 
              + Double.valueOf(q.Q2_MCP_Quota__c ==null ? 0 : q.Q2_MCP_Quota__c) 
              + Double.valueOf(q.Q2_Other_Quota__c ==null ? 0 : q.Q2_Other_Quota__c)
              
              + Double.valueOf(q.Q3_MA_Quota__c==null ? 0 : q.Q3_MA_Quota__c) 
              + Double.valueOf(q.Q3_SR_Quota__c==null ? 0 : q.Q3_SR_Quota__c) 
              + Double.valueOf(q.Q3_TK_Quota__c ==null ? 0 : q.Q3_TK_Quota__c) 
              + Double.valueOf(q.Q3_RC_Quota__c==null ? 0 : q.Q3_RC_Quota__c) 
              + Double.valueOf(q.Q3_MCP_Quota__c ==null ? 0 : q.Q3_MCP_Quota__c) 
              + Double.valueOf(q.Q3_Other_Quota__c ==null ? 0 : q.Q3_Other_Quota__c)
              
              + Double.valueOf(q.Q4_MA_Quota__c==null ? 0 : q.Q4_MA_Quota__c) 
              + Double.valueOf(q.Q4_SR_Quota__c==null ? 0 : q.Q4_SR_Quota__c) 
              + Double.valueOf(q.Q4_TK_Quota__c ==null ? 0 : q.Q4_TK_Quota__c) 
              + Double.valueOf(q.Q4_RC_Quota__c==null ? 0 : q.Q4_RC_Quota__c) 
              + Double.valueOf(q.Q4_MCP_Quota__c ==null ? 0 : q.Q4_MCP_Quota__c) 
              + Double.valueOf(q.Q4_Other_Quota__c ==null ? 0 : q.Q4_Other_Quota__c);
              
        //}
            
        return totalAnualQuota;
     }
     
     global static Double getTotalMonthlyQuota(Integer month, Integer quarter, Sales_Rep_Quota__c q)
     {
        
        Double totalAnualQuota = 0;
        if( month != null && quarter != null && q != null)
        {   
            totalAnualQuota 
            = Double.valueOf(q.get('Q'+quarter+'_M'+month+'_MA_Quota__c') == null ? 0 : q.get('Q'+quarter+'_M'+month+'_MA_Quota__c'))
            + Double.valueOf(q.get('Q'+quarter+'_M'+month+'_MCP_Quota__c') == null ? 0 : q.get('Q'+quarter+'_M'+month+'_MCP_Quota__c'))
            + Double.valueOf(q.get('Q'+quarter+'_M'+month+'_Other_Quota__c') == null ? 0 : q.get('Q'+quarter+'_M'+month+'_Other_Quota__c'))
            + Double.valueOf(q.get('Q'+quarter+'_M'+month+'_RC_Quota__c') == null ? 0 : q.get('Q'+quarter+'_M'+month+'_RC_Quota__c'))
            + Double.valueOf(q.get('Q'+quarter+'_M'+month+'_SR_Quota__c') == null ? 0 : q.get('Q'+quarter+'_M'+month+'_SR_Quota__c'))
            + Double.valueOf(q.get('Q'+quarter+'_M'+month+'_TK_Quota__c') == null ? 0 : q.get('Q'+quarter+'_M'+month+'_TK_Quota__c'));
        }
            
        return totalAnualQuota;
     }
     
     global static Double getMonthQuota(Integer month, Integer quarter, String lob, Sales_Rep_Quota__c q)
     {
        
        Double mtdQuota = 0;
            //get the quota for the fiscal quarter two months from now...
            if(q != null
               && q.get('Q'+ quarter + '_M' + month + '_'+lob+'_Quota__c') != null)
            {
                mtdQuota += Double.valueOf(q.get('Q'+ quarter + '_M' + month+ '_'+lob+'_Quota__c'));
            }
            
        return mtdQuota;
     }
     
     //===============================================
     //All roles under a given hierarchy
     global static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
 
        Set<ID> currentRoleIds = new Set<ID>();
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id from UserRole where ParentRoleId 
          IN :roleIds AND ParentRoleID != null])
        currentRoleIds.add(userRole.Id);
     
        // go fetch some more rolls!
        if(currentRoleIds.size() > 0)
          currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
     
        return currentRoleIds;
     
     }
     
     static testMethod void testThisClass()
     {
        UserRole startingRole = [Select Id, Name from UserRole where name = 'Service'];
        Batch_Maps_Helper.getAllSubRoleIds(new set<Id>{startingRole.Id});
        
        Batch_Maps_Helper.getCurrFiscalQuarter();
        Batch_Maps_Helper.getCurrFiscalYear();
        Batch_Maps_Helper.getEndDate12();
        Batch_Maps_Helper.getEndDate90();
        Batch_Maps_Helper.getQuarterMonthMap();
        Batch_Maps_Helper.getQuarterMonthMap();
        Batch_Maps_Helper.getStartMonth();
        Batch_Maps_Helper.getToday();
        Batch_Maps_Helper.getTotalAnnualQuota('MCP', new Sales_Rep_Quota__c());
        Batch_Maps_Helper.getTotalAnnualQuota(new Sales_Rep_Quota__c());
        Batch_Maps_Helper.isEndOfMonth();
        Batch_Maps_Helper.isEndOfQuarter();
        Batch_Maps_Helper.isEndOfWeek();
        Batch_Maps_Helper.isEndOfYear();
        Batch_Maps_Helper.getTotalAnnualQuota(new Sales_Rep_Quota__c());
         
     }
     
     

}