public with sharing class PageMapsPlanningQuotaController 
{
    public String selectedValues {get; set;}
    public String financialYear{get; set;}
    public String nextFinancialYear{get; set;}
    public String nextFinancialYear1{get; set;}
    public Opportunity oppor {get; set;}
    
    public transient String accType{get; set;}
    
    public static String grandTotQuotaPage;    
    public static String grandTotQuotaRollPage;
    public static String grandTotOppPage; 
    public static String grandTotOppRollPage;
    public static String grandTotFacPage;
    public static String grandTotFacRollPage;
    public static Date curFiscalDate = Batch_Maps_Helper.getCurrFiscalDate();
    public static Integer fiscalYear = (Integer)Batch_Maps_Helper.getCurrFiscalYear();
    public static string dateSumStr{get;set;}

/****   
    public transient String grandTotPipeQuotaPage;
    public transient String grandTotRollPipeQuotaPage;
    public transient String grandTotFacPipeQuotaPage;
    public transient String grandTotRollFacPipeQuotaPage;
*****/  
    
//    Public static boolean grandVarBool = false;
    public List<Account> accnts;
    Map<Id, Account> mapAccnts;
    Map<Id,Opportunity> mapOpp;
    List<Opportunity> lstOpp;
    Map<Id,User> usrMap;
    List<Account> thrAccnts;
    Set<ID> userIds;
    Map<Id,User> usrMapName;

    Map<Id,Sales_Rep_Quota__c> mapQuota;
     
    public PageMapsPlanningQuotaController(ApexPages.StandardController stdController) {
        oppor = (Opportunity)stdController.getRecord();
        If(Date.today().month() == 1 || Date.today().month() == 2 || Date.today().month() == 3)
        {
            financialYear = Date.Today().addYears(-1).Year()+'';
            nextFinancialYear = Date.Today().Year()+'';
            nextFinancialYear1 = Date.Today().addYears(1).Year()+'';        
        }
        else
        {
            financialYear = Date.Today().Year()+'';
            nextFinancialYear = Date.Today().addYears(1).Year()+'';
            nextFinancialYear1 = Date.Today().addYears(2).Year()+'';
        }
        //grandTotQuota = '0';
        
    }
    
    public List<accWrapper> accWrapStrategic{
        get{
            accWrapStrategic = new List<accWrapper>();
            accWrapStrategic = accWrap('Strategic');
            return accWrapStrategic;
        }
        set;
    } 
    
  
    public List<accWrapper> accWrap(String accType){
        List<accWrapper> accWrap = new List<accWrapper>();
        try{
            if(selectedValues != null){
                
                if(!getAccLst(accType)) return null;
                
                integer usrSize = 0;
        
                decimal amt , totAmount;
                decimal MAamt, totMAAmount;
                decimal SRamt, totSRAmount;
                decimal TKamt, totTKAmount;
                decimal RCamt, totRCAmount;
                decimal MCPamt, totMCPAmount;
                decimal OtherPamt, totOtherAmount;
               
                usrMap = new Map<Id,User>([Select Id,Name from User Where Id IN : userIds]);
                
                for(Account acc: accnts)
                {
	                amt = 0; totAmount = 0;
	                MAamt = 0; totMAAmount = 0;
	                SRamt = 0; totSRAmount = 0;
	                TKamt = 0; totTKAmount = 0;
	                RCamt = 0; totRCAmount = 0;
	                MCPamt = 0; totMCPAmount = 0;
	                OtherPamt = 0; totOtherAmount = 0;

                    for(Opportunity opp : acc.opportunities){
                    	if(opp.OwnerId == acc.OwnerId)
                    	{
	                        if(opp.Amount != null) totAmount += opp.Amount;
	                        system.debug ('*** bala**opp.MAPS_LOB_Type__c** '+opp.MAPS_LOB_Type__c +' ** ' +opp.Amount);
	                        if(opp.MAPS_LOB_Type__c =='MA' && opp.Amount != null )  totMAAmount += opp.Amount;
	                        if(opp.MAPS_LOB_Type__c =='SR' && opp.Amount != null )  totSRAmount += opp.Amount;
	                        if(opp.MAPS_LOB_Type__c =='TK' && opp.Amount != null )  totTKAmount += opp.Amount;
	                        if(opp.MAPS_LOB_Type__c =='Rental Chillers' && opp.Amount != null )  totRCAmount += opp.Amount;
	                        if(opp.MAPS_LOB_Type__c =='MCP' && opp.Amount != null )  totMCPAmount += opp.Amount;
	                        if(opp.MAPS_LOB_Type__c =='Other' && opp.Amount != null )  totOtherAmount += opp.Amount;
	                        system.debug ('*** bala**totSRAmount**'+totSRAmount);
	                        system.debug ('*** bala**totSRAmount**'+totOtherAmount);
                    	}
                    }
                    accWrap.add(new accWrapper(acc.Id, acc.Name, acc.OwnerId, usrMap.get(acc.OwnerId).Name, acc.National_Account__c, acc.Japanese_Company__c, totAmount,totMAAmount,totSRAmount,totTKAmount,totRCAmount,totMCPAmount,totOtherAmount));
                    totAmount = 0;
                    
                }//for acc
                return accWrap;
                
                
 /*******  code commented by Spandan            
                system.debug ('*** bala**totMAAmount**'+totMAAmount);
                system.debug ('*** bala**totSRAmount**'+totSRAmount);
                system.debug ('*** bala**totTkAmount**'+totTKAmount);
                
******/             

            }//Outermost if
            return null;
        }catch(Exception ex){
            //accWrap.add(new accWrapper(null, 'SELECT', null, 'PLEASE', 'ONE', 'USER', '0'));
            return accWrap;
        }//catch
    }
    
    
    public Boolean getAccLst(String accType){
        userIds = new Set<Id>();
        Set<Id> setSubRoleIds = new Set<Id>();
        
        String[] selIds = selectedValues.split(',');
        system.debug('sel ids ' + selIds);
        
        if(selIds.size() == 0)  return false;
        
        for(String role : selIds)
            setSubRoleIds.add(role.subString(0,15));
        
        system.debug('sub roles ' + setSubRoleIds);
        for(String id : selIds){
            id = id.trim();
            system.debug('id val ' + id);
            if(id.startswith('005')){//This is user
                userIds.add(id);
            }
        }
        usrMapName = new Map<Id,User>([Select Id,Name from User Where Id IN : userIds]);
        System.Debug('userIds : '+userIds);
        
        accnts = [Select Id, name, OwnerId, Total_Opportunity_Amount__c, National_Account__c, Japanese_Company__c
                     , (Select Id, OwnerId, Name, Amount, MAPS_LOB_Type__c, AccountId from Opportunities Where IsClosed = false) 
                   from account 
                  where OwnerId IN : userIds 
                    and Account_Type__c =: accType 
                  order by owner.name];
        
         mapAccnts = new Map<Id, Account>(accnts);
        
        //System.Debug('accnts : '+accnts); 
        return true;
    }
    

    public List<accWrapper> accWrapGrowth{
        get{
            
            accWrapGrowth = new List<accWrapper>();
            accWrapGrowth = accWrap('Growth');
            return accWrapGrowth;
        }
        set;
    }
    
 
    public List<accWrapper> accWrapNew{
        get{
            
            accWrapNew = new List<accWrapper>();
            accWrapNew = accWrap('New');
            return accWrapNew;
        }
        set;
    }
    
    
public List<oppAmtCalc> tableWrap
{
      get{
       // try{
          tableWrap = new List<oppAmtCalc>();
          
//         List<Opportunity> lstOpp = new List<Opportunity>([Select Id,CloseDate,Factored_Amount__c,OwnerId,owner.name, CreatedDate, Name, Amount, MAPS_LOB_Type__c, AccountId from Opportunity Where StageName != 'Closed Won' And StageName != 'Closed Lost' and CloseDate!=null and OwnerId IN : userIds order by MAPS_LOB_Type__c]);
         List<Opportunity> lstOpp = new List<Opportunity>([Select Id,CloseDate,Factored_Amount__c,OwnerId,owner.name
         														, CreatedDate, Name, Amount, MAPS_LOB_Type__c, AccountId 
         													from Opportunity 
         												   Where IsClosed = false //(NOT (IsClosed = true and IsWon=false)) 
         												     and CloseDate!=null 
         												     and OwnerId IN : userIds order by MAPS_LOB_Type__c]);
                mapQuota = new Map<Id, Sales_Rep_Quota__c>();
                
               for(Sales_Rep_Quota__c salesQuota : [Select s.User__c, 
                     s.Q4_M3_MA_Quota__c, s.Q4_M2_MA_Quota__c, s.Q4_M1_MA_Quota__c,s.Q3_M3_MA_Quota__c, s.Q3_M2_MA_Quota__c, s.Q3_M1_MA_Quota__c,s.Q2_M3_MA_Quota__c, s.Q2_M2_MA_Quota__c, s.Q2_M1_MA_Quota__c,s.Q1_M3_MA_Quota__c, s.Q1_M2_MA_Quota__c, s.Q1_M1_MA_Quota__c,s.Q4_M3_SR_Quota__c, s.Q4_M2_SR_Quota__c, s.Q4_M1_SR_Quota__c,s.Q3_M3_SR_Quota__c, s.Q3_M2_SR_Quota__c, s.Q3_M1_SR_Quota__c,s.Q2_M3_SR_Quota__c, s.Q2_M2_SR_Quota__c, s.Q2_M1_SR_Quota__c,s.Q1_M3_SR_Quota__c, s.Q1_M2_SR_Quota__c, s.Q1_M1_SR_Quota__c,s.Q4_M3_TK_Quota__c, s.Q4_M2_TK_Quota__c, s.Q4_M1_TK_Quota__c,s.Q3_M3_TK_Quota__c, s.Q3_M2_TK_Quota__c, s.Q3_M1_TK_Quota__c,s.Q2_M3_TK_Quota__c, s.Q2_M2_TK_Quota__c, s.Q2_M1_TK_Quota__c,s.Q1_M3_TK_Quota__c, s.Q1_M2_TK_Quota__c, s.Q1_M1_TK_Quota__c,s.Q4_M3_RC_Quota__c, s.Q4_M2_RC_Quota__c, s.Q4_M1_RC_Quota__c,s.Q3_M3_RC_Quota__c, s.Q3_M2_RC_Quota__c, s.Q3_M1_RC_Quota__c,s.Q2_M3_RC_Quota__c, s.Q2_M2_RC_Quota__c, s.Q2_M1_RC_Quota__c,s.Q1_M3_RC_Quota__c, s.Q1_M2_RC_Quota__c, s.Q1_M1_RC_Quota__c,s.Q4_M3_MCP_Quota__c, s.Q4_M2_MCP_Quota__c, s.Q4_M1_MCP_Quota__c,s.Q3_M3_MCP_Quota__c, s.Q3_M2_MCP_Quota__c, s.Q3_M1_MCP_Quota__c,s.Q2_M3_MCP_Quota__c, s.Q2_M2_MCP_Quota__c, s.Q2_M1_MCP_Quota__c,s.Q1_M3_MCP_Quota__c, s.Q1_M2_MCP_Quota__c, s.Q1_M1_MCP_Quota__c,s.Q4_M3_Other_Quota__c,s.Q4_M2_Other_Quota__c,s.Q4_M1_Other_Quota__c,s.Q3_M2_Other_Quota__c,s.Q3_M3_Other_Quota__c,     s.Q3_M1_Other_Quota__c,s.Q2_M3_Other_Quota__c,s.Q2_M2_Other_Quota__c,s.Q2_M1_Other_Quota__c,s.Q1_M3_Other_Quota__c,s.Q1_M2_Other_Quota__c,s.Q1_M1_Other_Quota__c,s.OwnerId, s.Name,  s.IsDeleted, s.Id,  s.CreatedDate From Sales_Rep_Quota__c s where  User__c IN : userIds]){
                mapQuota.put(salesQuota.User__c, salesQuota);
        }
            
        for(Id tempId : userIds)
        {
            
              //map for opportunity amount calculation in the first fiscal year.
              transient Map<String, decimal> mapAmt1 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt2 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt3 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt4 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt5 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt6 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt7 = new Map<String, decimal>();                    

              //map for opportunity amount calculation in the second fiscal year.
              transient Map<String, decimal> mapAmt21 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt22 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt23 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt24 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt25 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt26 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmt27 = new Map<String, decimal>();
            
              //map for opportunity facotr amount calculation in the first fiscal year.
              transient Map<String, decimal> mapFacAmt1 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt2 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt3 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt4 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt5 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt6 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt7 = new Map<String, decimal>();                    

              //map for opportunity facotr amount calculation in the second fiscal year.
              transient Map<String, decimal> mapFacAmt21 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt22 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt23 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt24 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt25 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt26 = new Map<String, decimal>();
              transient Map<String, decimal> mapFacAmt27 = new Map<String, decimal>();
              
              
              transient Map<String, decimal> mapAmtQuota1 = new Map<String, decimal>();         
              transient Map<String, decimal> mapAmtQuota2 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmtQuota3 = new Map<String, decimal>();         
              transient Map<String, decimal> mapAmtQuota4 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmtQuota5 = new Map<String, decimal>();         
              transient Map<String, decimal> mapAmtQuota6 = new Map<String, decimal>();
              transient Map<String, decimal> mapAmtQuota7 = new Map<String, decimal>();
              
    //          String grandTotQuota = '0';
              
              
                    decimal amt = 0, aprAmt1 = 0, mayAmt1 = 0, junAmt1 = 0, julAmt1 = 0, augAmt1 = 0, sepAmt1 = 0;
                    decimal octAmt1 = 0, novAmt1 = 0, decAmt1 = 0, janAmt1 = 0, febAmt1 = 0, marAmt1 = 0;
                    
                    decimal FacAmt2 = 0, aprFacAmt2 = 0, mayFacAmt2 = 0, junFacAmt2 = 0, julFacAmt2 = 0, augFacAmt2 = 0, sepFacAmt2 = 0;
                    decimal octFacAmt2 = 0, novFacAmt2 = 0, decFacAmt2 = 0, janFacAmt2 = 0, febFacAmt2 = 0, marFacAmt2 = 0;
                    
                    decimal aprAmt3 = 0, mayAmt3 = 0, junAmt3 = 0, julAmt3 = 0, augAmt3 = 0, sepAmt3 = 0;
                    decimal octAmt3 = 0, novAmt3 = 0, decAmt3 = 0, janAmt3 = 0, febAmt3 = 0, marAmt3 = 0;
                    
                    //decimal Q1Quota = 0, Q2Quota = 0, Q3Quota = 0, Q4Quota = 0;
                    
                    decimal aprQuota = 0, mayQuota = 0, junQuota = 0, julQuota = 0, augQuota = 0, sepQuota = 0;
                    decimal octQuota = 0, novQuota = 0, decQuota = 0, janQuota = 0, febQuota = 0 , marQuota = 0;
                    
                    decimal amt2 = 0, aprAmt21 = 0, mayAmt21 = 0, junAmt21 = 0, julAmt21 = 0, augAmt21 = 0, sepAmt21 = 0;
                    decimal octAmt21 = 0, novAmt21 = 0, decAmt21 = 0, janAmt21 = 0, febAmt21 = 0, marAmt21 = 0;
                    
                    decimal FacAmt22 = 0, aprFacAmt22 = 0, mayFacAmt22 = 0, junFacAmt22 = 0, julFacAmt22 = 0, augFacAmt22 = 0, sepFacAmt22 = 0;
                    decimal octFacAmt22 = 0, novFacAmt22 = 0, decFacAmt22 = 0, janFacAmt22 = 0, febFacAmt22 = 0, marFacAmt22 = 0;
                    
                    decimal aprAmt23 = 0, mayAmt23 = 0, junAmt23 = 0, julAmt23 = 0, augAmt23 = 0, sepAmt23 = 0;
                    decimal octAmt23 = 0, novAmt23 = 0, decAmt23 = 0, janAmt23 = 0, febAmt23 = 0, marAmt23 = 0;
                    
                    //decimal Q1Quota = 0, Q2Quota = 0, Q3Quota = 0, Q4Quota = 0;
                    
                    decimal aprQuota2 = 0, mayQuota2 = 0, junQuota2 = 0, julQuota2 = 0, augQuota2 = 0, sepQuota2 = 0;
                    decimal octQuota2 = 0, novQuota2 = 0, decQuota2 = 0, janQuota2 = 0, febQuota2 = 0 , marQuota2 = 0;

                    
                    Integer day = 0;
                    Id id;                     
            
                        boolean tempvar = false;
                        boolean tempMA = false;
                        boolean tempTK = false;
                        boolean tempSR = false;
                        boolean tempRental = false;
                        boolean tempMCP = false;
                        boolean tempOther = false;
                        String tempLOB = 'False';
                        Integer intTemp = 0;
                        String OwnerName;
                        for(Opportunity opp : lstOpp){
                            If(tempId != null)
                            OwnerName = usrMapName.get(tempId).name;
                            If(tempId == opp.OwnerId)
                            {
                        
                            id = opp.OwnerId;
                            OwnerName = opp.owner.name;
                            System.debug('############## opp.MAPS_LOB_Type__c ' + opp.MAPS_LOB_Type__c);
                            System.debug('############# tempLOB ' + tempLOB);
                            System.debug('############# accType ' + accType);
                            If((opp.MAPS_LOB_Type__c != tempLOB && tempLOB != 'False') && accType == '0')
                            {
                                If(tempLOB == 'MA'){
                                    tempMA = True;
                                    IF(mapQuota.get(id) != null && mapQuota.get(id).Q1_M1_MA_Quota__c != null)
                                    {
                                    aprQuota += mapQuota.get(id).Q1_M1_MA_Quota__c;
                                    mayQuota += mapQuota.get(id).Q1_M2_MA_Quota__c;
                                    junQuota += mapQuota.get(id).Q1_M3_MA_Quota__c;
                                    julQuota += mapQuota.get(id).Q2_M1_MA_Quota__c;
                                    augQuota += mapQuota.get(id).Q2_M2_MA_Quota__c;
                                    sepQuota += mapQuota.get(id).Q2_M3_MA_Quota__c;
                                    octQuota += mapQuota.get(id).Q3_M1_MA_Quota__c;
                                    novQuota += mapQuota.get(id).Q3_M2_MA_Quota__c;
                                    decQuota += mapQuota.get(id).Q3_M3_MA_Quota__c;
                                    janQuota += mapQuota.get(id).Q4_M1_MA_Quota__c;
                                    febQuota += mapQuota.get(id).Q4_M2_MA_Quota__c;
                                    marQuota += mapQuota.get(id).Q4_M3_MA_Quota__c;
                                    }
                                    mapAmtQuota1.put('aprQuota',aprQuota);
                                    mapAmtQuota1.put('mayQuota',mayQuota);
                                    mapAmtQuota1.put('junQuota',junQuota);
                                    mapAmtQuota1.put('julQuota',julQuota);
                                    mapAmtQuota1.put('augQuota',augQuota);
                                    mapAmtQuota1.put('sepQuota',sepQuota);
                                    mapAmtQuota1.put('octQuota',octQuota);
                                    mapAmtQuota1.put('novQuota',novQuota);
                                    mapAmtQuota1.put('decQuota',decQuota);
                                    mapAmtQuota1.put('janQuota',janQuota);
                                    mapAmtQuota1.put('febQuota',febQuota);
                                    mapAmtQuota1.put('marQuota',marQuota);
                                    
                                    
                                    mapAmt1.put('aprAmt',aprAmt1);  
                                    mapAmt1.put('mayAmt',mayAmt1);  
                                    mapAmt1.put('junAmt',junAmt1);  
                                    mapAmt1.put('julAmt',julAmt1);  
                                    mapAmt1.put('augAmt',augAmt1);  
                                    mapAmt1.put('sepAmt',sepAmt1);  
                                    mapAmt1.put('octAmt',octAmt1);  
                                    mapAmt1.put('novAmt',novAmt1);  
                                    mapAmt1.put('decAmt',decAmt1);  
                                    mapAmt1.put('janAmt',janAmt1);  
                                    mapAmt1.put('febAmt',febAmt1);  
                                    mapAmt1.put('marAmt',marAmt1);

                                    mapAmt21.put('aprAmt',aprAmt21);  
                                    mapAmt21.put('mayAmt',mayAmt21);  
                                    mapAmt21.put('junAmt',junAmt21);  
                                    mapAmt21.put('julAmt',julAmt21);  
                                    mapAmt21.put('augAmt',augAmt21);  
                                    mapAmt21.put('sepAmt',sepAmt21);  
                                    mapAmt21.put('octAmt',octAmt21);  
                                    mapAmt21.put('novAmt',novAmt21);  
                                    mapAmt21.put('decAmt',decAmt21);  
                                    mapAmt21.put('janAmt',janAmt21);  
                                    mapAmt21.put('febAmt',febAmt21);  
                                    mapAmt21.put('marAmt',marAmt21);  
                                    
                                    mapFacAmt1.put('aprAmt',aprFacAmt2);  
                                    mapFacAmt1.put('mayAmt',mayFacAmt2);  
                                    mapFacAmt1.put('junAmt',junFacAmt2);  
                                    mapFacAmt1.put('julAmt',julFacAmt2);  
                                    mapFacAmt1.put('augAmt',augFacAmt2);  
                                    mapFacAmt1.put('sepAmt',sepFacAmt2);  
                                    mapFacAmt1.put('octAmt',octFacAmt2);  
                                    mapFacAmt1.put('novAmt',novFacAmt2);  
                                    mapFacAmt1.put('decAmt',decFacAmt2);  
                                    mapFacAmt1.put('janAmt',janFacAmt2);  
                                    mapFacAmt1.put('febAmt',febFacAmt2);  
                                    mapFacAmt1.put('marAmt',marFacAmt2);

                                    mapFacAmt21.put('aprAmt',aprFacAmt22);  
                                    mapFacAmt21.put('mayAmt',mayFacAmt22);  
                                    mapFacAmt21.put('junAmt',junFacAmt22);  
                                    mapFacAmt21.put('julAmt',julFacAmt22);  
                                    mapFacAmt21.put('augAmt',augFacAmt22);  
                                    mapFacAmt21.put('sepAmt',sepFacAmt22);  
                                    mapFacAmt21.put('octAmt',octFacAmt22);  
                                    mapFacAmt21.put('novAmt',novFacAmt22);  
                                    mapFacAmt21.put('decAmt',decFacAmt22);  
                                    mapFacAmt21.put('janAmt',janFacAmt22);  
                                    mapFacAmt21.put('febAmt',febFacAmt22);  
                                    mapFacAmt21.put('marAmt',marFacAmt22);  
                                    
                                }
                                
                                System.debug('#########tempLOB at #389 ' + tempLOB);   
                                If(tempLOB == 'TK'){
                                
                                    tempTK = True;
                                    If(mapQuota.get(id) != null && mapQuota.get(id).Q1_M1_TK_Quota__c != null)
                                    {
                                    aprQuota += mapQuota.get(id).Q1_M1_TK_Quota__c;
                                    mayQuota += mapQuota.get(id).Q1_M2_TK_Quota__c;
                                    junQuota += mapQuota.get(id).Q1_M3_TK_Quota__c;
                                    julQuota += mapQuota.get(id).Q2_M1_TK_Quota__c;
                                    augQuota += mapQuota.get(id).Q2_M2_TK_Quota__c;
                                    sepQuota += mapQuota.get(id).Q2_M3_TK_Quota__c;
                                    octQuota += mapQuota.get(id).Q3_M1_TK_Quota__c;
                                    novQuota += mapQuota.get(id).Q3_M2_TK_Quota__c;
                                    decQuota += mapQuota.get(id).Q3_M3_TK_Quota__c;
                                    janQuota += mapQuota.get(id).Q4_M1_TK_Quota__c;
                                    febQuota += mapQuota.get(id).Q4_M2_TK_Quota__c;
                                    marQuota += mapQuota.get(id).Q4_M3_TK_Quota__c;
                                    }
                                    mapAmtQuota2.put('aprQuota',aprQuota);
                                    mapAmtQuota2.put('mayQuota',mayQuota);
                                    mapAmtQuota2.put('junQuota',junQuota);
                                    mapAmtQuota2.put('julQuota',julQuota);
                                    mapAmtQuota2.put('augQuota',augQuota);
                                    mapAmtQuota2.put('sepQuota',sepQuota);
                                    mapAmtQuota2.put('octQuota',octQuota);
                                    mapAmtQuota2.put('novQuota',novQuota);
                                    mapAmtQuota2.put('decQuota',decQuota);
                                    mapAmtQuota2.put('janQuota',janQuota);
                                    mapAmtQuota2.put('febQuota',febQuota);
                                    mapAmtQuota2.put('marQuota',marQuota);
                                    
                                    
                                    mapAmt2.put('aprAmt',aprAmt1);  
                                    mapAmt2.put('mayAmt',mayAmt1);  
                                    mapAmt2.put('junAmt',junAmt1);  
                                    mapAmt2.put('julAmt',julAmt1);  
                                    mapAmt2.put('augAmt',augAmt1);  
                                    mapAmt2.put('sepAmt',sepAmt1);  
                                    mapAmt2.put('octAmt',octAmt1);  
                                    mapAmt2.put('novAmt',novAmt1);  
                                    mapAmt2.put('decAmt',decAmt1);  
                                    mapAmt2.put('janAmt',janAmt1);  
                                    mapAmt2.put('febAmt',febAmt1);  
                                    mapAmt2.put('marAmt',marAmt1);

                                    mapAmt22.put('aprAmt',aprAmt21);  
                                    mapAmt22.put('mayAmt',mayAmt21);  
                                    mapAmt22.put('junAmt',junAmt21);  
                                    mapAmt22.put('julAmt',julAmt21);  
                                    mapAmt22.put('augAmt',augAmt21);  
                                    mapAmt22.put('sepAmt',sepAmt21);  
                                    mapAmt22.put('octAmt',octAmt21);  
                                    mapAmt22.put('novAmt',novAmt21);  
                                    mapAmt22.put('decAmt',decAmt21);  
                                    mapAmt22.put('janAmt',janAmt21);  
                                    mapAmt22.put('febAmt',febAmt21);  
                                    mapAmt22.put('marAmt',marAmt21); 

                                    mapFacAmt2.put('aprAmt',aprFacAmt2);  
                                    mapFacAmt2.put('mayAmt',mayFacAmt2);  
                                    mapFacAmt2.put('junAmt',junFacAmt2);  
                                    mapFacAmt2.put('julAmt',julFacAmt2);  
                                    mapFacAmt2.put('augAmt',augFacAmt2);  
                                    mapFacAmt2.put('sepAmt',sepFacAmt2);  
                                    mapFacAmt2.put('octAmt',octFacAmt2);  
                                    mapFacAmt2.put('novAmt',novFacAmt2);  
                                    mapFacAmt2.put('decAmt',decFacAmt2);  
                                    mapFacAmt2.put('janAmt',janFacAmt2);  
                                    mapFacAmt2.put('febAmt',febFacAmt2);  
                                    mapFacAmt2.put('marAmt',marFacAmt2);

                                    mapFacAmt22.put('aprAmt',aprFacAmt22);  
                                    mapFacAmt22.put('mayAmt',mayFacAmt22);  
                                    mapFacAmt22.put('junAmt',junFacAmt22);  
                                    mapFacAmt22.put('julAmt',julFacAmt22);  
                                    mapFacAmt22.put('augAmt',augFacAmt22);  
                                    mapFacAmt22.put('sepAmt',sepFacAmt22);  
                                    mapFacAmt22.put('octAmt',octFacAmt22);  
                                    mapFacAmt22.put('novAmt',novFacAmt22);  
                                    mapFacAmt22.put('decAmt',decFacAmt22);  
                                    mapFacAmt22.put('janAmt',janFacAmt22);  
                                    mapFacAmt22.put('febAmt',febFacAmt22);  
                                    mapFacAmt22.put('marAmt',marFacAmt22);  
                                    
                                }   
                                If(tempLOB == 'SR'){
                                
                                    tempSR = True;
                                    If(mapQuota.get(id) != null && mapQuota.get(id).Q1_M1_SR_Quota__c != null)
                                    {
                                    aprQuota += mapQuota.get(id).Q1_M1_SR_Quota__c;
                                    mayQuota += mapQuota.get(id).Q1_M2_SR_Quota__c;
                                    junQuota += mapQuota.get(id).Q1_M3_SR_Quota__c;
                                    julQuota += mapQuota.get(id).Q2_M1_SR_Quota__c;
                                    augQuota += mapQuota.get(id).Q2_M2_SR_Quota__c;
                                    sepQuota += mapQuota.get(id).Q2_M3_SR_Quota__c;
                                    octQuota += mapQuota.get(id).Q3_M1_SR_Quota__c;
                                    novQuota += mapQuota.get(id).Q3_M2_SR_Quota__c;
                                    decQuota += mapQuota.get(id).Q3_M3_SR_Quota__c;
                                    janQuota += mapQuota.get(id).Q4_M1_SR_Quota__c;
                                    febQuota += mapQuota.get(id).Q4_M2_SR_Quota__c;
                                    marQuota += mapQuota.get(id).Q4_M3_SR_Quota__c;
                                    }
                                    mapAmtQuota3.put('aprQuota',aprQuota);
                                    mapAmtQuota3.put('mayQuota',mayQuota);
                                    mapAmtQuota3.put('junQuota',junQuota);
                                    mapAmtQuota3.put('julQuota',julQuota);
                                    mapAmtQuota3.put('augQuota',augQuota);
                                    mapAmtQuota3.put('sepQuota',sepQuota);
                                    mapAmtQuota3.put('octQuota',octQuota);
                                    mapAmtQuota3.put('novQuota',novQuota);
                                    mapAmtQuota3.put('decQuota',decQuota);
                                    mapAmtQuota3.put('janQuota',janQuota);
                                    mapAmtQuota3.put('febQuota',febQuota);
                                    mapAmtQuota3.put('marQuota',marQuota);
                                    
                                    mapAmt3.put('aprAmt',aprAmt1);  
                                    mapAmt3.put('mayAmt',mayAmt1);  
                                    mapAmt3.put('junAmt',junAmt1);  
                                    mapAmt3.put('julAmt',julAmt1);  
                                    mapAmt3.put('augAmt',augAmt1);  
                                    mapAmt3.put('sepAmt',sepAmt1);  
                                    mapAmt3.put('octAmt',octAmt1);  
                                    mapAmt3.put('novAmt',novAmt1);  
                                    mapAmt3.put('decAmt',decAmt1);  
                                    mapAmt3.put('janAmt',janAmt1);  
                                    mapAmt3.put('febAmt',febAmt1);  
                                    mapAmt3.put('marAmt',marAmt1);

                                    mapAmt23.put('aprAmt',aprAmt21);  
                                    mapAmt23.put('mayAmt',mayAmt21);  
                                    mapAmt23.put('junAmt',junAmt21);  
                                    mapAmt23.put('julAmt',julAmt21);  
                                    mapAmt23.put('augAmt',augAmt21);  
                                    mapAmt23.put('sepAmt',sepAmt21);  
                                    mapAmt23.put('octAmt',octAmt21);  
                                    mapAmt23.put('novAmt',novAmt21);  
                                    mapAmt23.put('decAmt',decAmt21);  
                                    mapAmt23.put('janAmt',janAmt21);  
                                    mapAmt23.put('febAmt',febAmt21);  
                                    mapAmt23.put('marAmt',marAmt21); 

                                    mapFacAmt3.put('aprAmt',aprFacAmt2);  
                                    mapFacAmt3.put('mayAmt',mayFacAmt2);  
                                    mapFacAmt3.put('junAmt',junFacAmt2);  
                                    mapFacAmt3.put('julAmt',julFacAmt2);  
                                    mapFacAmt3.put('augAmt',augFacAmt2);  
                                    mapFacAmt3.put('sepAmt',sepFacAmt2);  
                                    mapFacAmt3.put('octAmt',octFacAmt2);  
                                    mapFacAmt3.put('novAmt',novFacAmt2);  
                                    mapFacAmt3.put('decAmt',decFacAmt2);  
                                    mapFacAmt3.put('janAmt',janFacAmt2);  
                                    mapFacAmt3.put('febAmt',febFacAmt2);  
                                    mapFacAmt3.put('marAmt',marFacAmt2);

                                    mapFacAmt23.put('aprAmt',aprFacAmt22);  
                                    mapFacAmt23.put('mayAmt',mayFacAmt22);  
                                    mapFacAmt23.put('junAmt',junFacAmt22);  
                                    mapFacAmt23.put('julAmt',julFacAmt22);  
                                    mapFacAmt23.put('augAmt',augFacAmt22);  
                                    mapFacAmt23.put('sepAmt',sepFacAmt22);  
                                    mapFacAmt23.put('octAmt',octFacAmt22);  
                                    mapFacAmt23.put('novAmt',novFacAmt22);  
                                    mapFacAmt23.put('decAmt',decFacAmt22);  
                                    mapFacAmt23.put('janAmt',janFacAmt22);  
                                    mapFacAmt23.put('febAmt',febFacAmt22);  
                                    mapFacAmt23.put('marAmt',marFacAmt22);  
                                    
                                }   
                                If(tempLOB == 'Rental Chillers'){
                                
                                    tempRental = True;
                                    If(mapQuota.get(id) != null && mapQuota.get(id).Q1_M1_RC_Quota__c != null)
                                    {
                                    aprQuota += mapQuota.get(id).Q1_M1_RC_Quota__c;
                                    mayQuota += mapQuota.get(id).Q1_M2_RC_Quota__c;
                                    junQuota += mapQuota.get(id).Q1_M3_RC_Quota__c;
                                    julQuota += mapQuota.get(id).Q2_M1_RC_Quota__c;
                                    augQuota += mapQuota.get(id).Q2_M2_RC_Quota__c;
                                    sepQuota += mapQuota.get(id).Q2_M3_RC_Quota__c;
                                    octQuota += mapQuota.get(id).Q3_M1_RC_Quota__c;
                                    novQuota += mapQuota.get(id).Q3_M2_RC_Quota__c;
                                    decQuota += mapQuota.get(id).Q3_M3_RC_Quota__c;
                                    janQuota += mapQuota.get(id).Q4_M1_RC_Quota__c;
                                    febQuota += mapQuota.get(id).Q4_M2_RC_Quota__c;
                                    marQuota += mapQuota.get(id).Q4_M3_RC_Quota__c;
                                    }
                                    mapAmtQuota4.put('aprQuota',aprQuota);
                                    mapAmtQuota4.put('mayQuota',mayQuota);
                                    mapAmtQuota4.put('junQuota',junQuota);
                                    mapAmtQuota4.put('julQuota',julQuota);
                                    mapAmtQuota4.put('augQuota',augQuota);
                                    mapAmtQuota4.put('sepQuota',sepQuota);
                                    mapAmtQuota4.put('octQuota',octQuota);
                                    mapAmtQuota4.put('novQuota',novQuota);
                                    mapAmtQuota4.put('decQuota',decQuota);
                                    mapAmtQuota4.put('janQuota',janQuota);
                                    mapAmtQuota4.put('febQuota',febQuota);
                                    mapAmtQuota4.put('marQuota',marQuota);
                                    
                                    mapAmt4.put('aprAmt',aprAmt1);  
                                    mapAmt4.put('mayAmt',mayAmt1);  
                                    mapAmt4.put('junAmt',junAmt1);  
                                    mapAmt4.put('julAmt',julAmt1);  
                                    mapAmt4.put('augAmt',augAmt1);  
                                    mapAmt4.put('sepAmt',sepAmt1);  
                                    mapAmt4.put('octAmt',octAmt1);  
                                    mapAmt4.put('novAmt',novAmt1);  
                                    mapAmt4.put('decAmt',decAmt1);  
                                    mapAmt4.put('janAmt',janAmt1);  
                                    mapAmt4.put('febAmt',febAmt1);  
                                    mapAmt4.put('marAmt',marAmt1);

                                    mapAmt24.put('aprAmt',aprAmt21);  
                                    mapAmt24.put('mayAmt',mayAmt21);  
                                    mapAmt24.put('junAmt',junAmt21);  
                                    mapAmt24.put('julAmt',julAmt21);  
                                    mapAmt24.put('augAmt',augAmt21);  
                                    mapAmt24.put('sepAmt',sepAmt21);  
                                    mapAmt24.put('octAmt',octAmt21);  
                                    mapAmt24.put('novAmt',novAmt21);  
                                    mapAmt24.put('decAmt',decAmt21);  
                                    mapAmt24.put('janAmt',janAmt21);  
                                    mapAmt24.put('febAmt',febAmt21);  
                                    mapAmt24.put('marAmt',marAmt21);  
                                    
                                    mapFacAmt4.put('aprAmt',aprFacAmt2);  
                                    mapFacAmt4.put('mayAmt',mayFacAmt2);  
                                    mapFacAmt4.put('junAmt',junFacAmt2);  
                                    mapFacAmt4.put('julAmt',julFacAmt2);  
                                    mapFacAmt4.put('augAmt',augFacAmt2);  
                                    mapFacAmt4.put('sepAmt',sepFacAmt2);  
                                    mapFacAmt4.put('octAmt',octFacAmt2);  
                                    mapFacAmt4.put('novAmt',novFacAmt2);  
                                    mapFacAmt4.put('decAmt',decFacAmt2);  
                                    mapFacAmt4.put('janAmt',janFacAmt2);  
                                    mapFacAmt4.put('febAmt',febFacAmt2);  
                                    mapFacAmt4.put('marAmt',marFacAmt2);

                                    mapFacAmt24.put('aprAmt',aprFacAmt22);  
                                    mapFacAmt24.put('mayAmt',mayFacAmt22);  
                                    mapFacAmt24.put('junAmt',junFacAmt22);  
                                    mapFacAmt24.put('julAmt',julFacAmt22);  
                                    mapFacAmt24.put('augAmt',augFacAmt22);  
                                    mapFacAmt24.put('sepAmt',sepFacAmt22);  
                                    mapFacAmt24.put('octAmt',octFacAmt22);  
                                    mapFacAmt24.put('novAmt',novFacAmt22);  
                                    mapFacAmt24.put('decAmt',decFacAmt22);  
                                    mapFacAmt24.put('janAmt',janFacAmt22);  
                                    mapFacAmt24.put('febAmt',febFacAmt22);  
                                    mapFacAmt24.put('marAmt',marFacAmt22);  
                                    
                                }   
                                
                                else if(tempLOB == 'MCP')
                                {
                                      tempMCP = True;
                                    If(mapQuota.get(id) != null && mapQuota.get(id).Q1_M1_MCP_Quota__c != null)
                                    {
                                    aprQuota += mapQuota.get(id).Q1_M1_MCP_Quota__c;
                                    mayQuota += mapQuota.get(id).Q1_M2_MCP_Quota__c;
                                    junQuota += mapQuota.get(id).Q1_M3_MCP_Quota__c;
                                    julQuota += mapQuota.get(id).Q2_M1_MCP_Quota__c;
                                    augQuota += mapQuota.get(id).Q2_M2_MCP_Quota__c;
                                    sepQuota += mapQuota.get(id).Q2_M3_MCP_Quota__c;
                                    octQuota += mapQuota.get(id).Q3_M1_MCP_Quota__c;
                                    novQuota += mapQuota.get(id).Q3_M2_MCP_Quota__c;
                                    decQuota += mapQuota.get(id).Q3_M3_MCP_Quota__c;
                                    janQuota += mapQuota.get(id).Q4_M1_MCP_Quota__c;
                                    febQuota += mapQuota.get(id).Q4_M2_MCP_Quota__c;
                                    marQuota += mapQuota.get(id).Q4_M3_MCP_Quota__c;
                                    }
                                    mapAmtQuota5.put('aprQuota',aprQuota);
                                    mapAmtQuota5.put('mayQuota',mayQuota);
                                    mapAmtQuota5.put('junQuota',junQuota);
                                    mapAmtQuota5.put('julQuota',julQuota);
                                    mapAmtQuota5.put('augQuota',augQuota);
                                    mapAmtQuota5.put('sepQuota',sepQuota);
                                    mapAmtQuota5.put('octQuota',octQuota);
                                    mapAmtQuota5.put('novQuota',novQuota);
                                    mapAmtQuota5.put('decQuota',decQuota);
                                    mapAmtQuota5.put('janQuota',janQuota);
                                    mapAmtQuota5.put('febQuota',febQuota);
                                    mapAmtQuota5.put('marQuota',marQuota);
                                      
                                      mapAmt5.put('aprAmt',aprAmt1);  
                                      mapAmt5.put('mayAmt',mayAmt1);  
                                      mapAmt5.put('junAmt',junAmt1);  
                                      mapAmt5.put('julAmt',julAmt1);  
                                      mapAmt5.put('augAmt',augAmt1);  
                                      mapAmt5.put('sepAmt',sepAmt1);  
                                      mapAmt5.put('octAmt',octAmt1);  
                                      mapAmt5.put('novAmt',novAmt1);  
                                      mapAmt5.put('decAmt',decAmt1);  
                                      mapAmt5.put('janAmt',janAmt1);  
                                      mapAmt5.put('febAmt',febAmt1);  
                                      mapAmt5.put('marAmt',marAmt1);  
                                      
                                      mapAmt25.put('aprAmt',aprAmt21);  
                                      mapAmt25.put('mayAmt',mayAmt21);  
                                      mapAmt25.put('junAmt',junAmt21);  
                                      mapAmt25.put('julAmt',julAmt21);  
                                      mapAmt25.put('augAmt',augAmt21);  
                                      mapAmt25.put('sepAmt',sepAmt21);  
                                      mapAmt25.put('octAmt',octAmt21);  
                                      mapAmt25.put('novAmt',novAmt21);  
                                      mapAmt25.put('decAmt',decAmt21);  
                                      mapAmt25.put('janAmt',janAmt21);  
                                      mapAmt25.put('febAmt',febAmt21);  
                                      mapAmt25.put('marAmt',marAmt21);  
                                      
                                    mapFacAmt5.put('aprAmt',aprFacAmt2);  
                                    mapFacAmt5.put('mayAmt',mayFacAmt2);  
                                    mapFacAmt5.put('junAmt',junFacAmt2);  
                                    mapFacAmt5.put('julAmt',julFacAmt2);  
                                    mapFacAmt5.put('augAmt',augFacAmt2);  
                                    mapFacAmt5.put('sepAmt',sepFacAmt2);  
                                    mapFacAmt5.put('octAmt',octFacAmt2);  
                                    mapFacAmt5.put('novAmt',novFacAmt2);  
                                    mapFacAmt5.put('decAmt',decFacAmt2);  
                                    mapFacAmt5.put('janAmt',janFacAmt2);  
                                    mapFacAmt5.put('febAmt',febFacAmt2);  
                                    mapFacAmt5.put('marAmt',marFacAmt2);

                                    mapFacAmt25.put('aprAmt',aprFacAmt22);  
                                    mapFacAmt25.put('mayAmt',mayFacAmt22);  
                                    mapFacAmt25.put('junAmt',junFacAmt22);  
                                    mapFacAmt25.put('julAmt',julFacAmt22);  
                                    mapFacAmt25.put('augAmt',augFacAmt22);  
                                    mapFacAmt25.put('sepAmt',sepFacAmt22);  
                                    mapFacAmt25.put('octAmt',octFacAmt22);  
                                    mapFacAmt25.put('novAmt',novFacAmt22);  
                                    mapFacAmt25.put('decAmt',decFacAmt22);  
                                    mapFacAmt25.put('janAmt',janFacAmt22);  
                                    mapFacAmt25.put('febAmt',febFacAmt22);  
                                    mapFacAmt25.put('marAmt',marFacAmt22);  
                                      
                      
                                }
                                else if(tempLOB == 'Other')
                                {
                                      tempOther = True;
                                    If(mapQuota.get(id) != null && mapQuota.get(id).Q1_M1_Other_Quota__c != null)  
                                    {
                                    aprQuota += mapQuota.get(id).Q1_M1_Other_Quota__c;
                                    mayQuota += mapQuota.get(id).Q1_M2_Other_Quota__c;
                                    junQuota += mapQuota.get(id).Q1_M3_Other_Quota__c;
                                    julQuota += mapQuota.get(id).Q2_M1_Other_Quota__c;
                                    augQuota += mapQuota.get(id).Q2_M2_Other_Quota__c;
                                    sepQuota += mapQuota.get(id).Q2_M3_Other_Quota__c;
                                    octQuota += mapQuota.get(id).Q3_M1_Other_Quota__c;
                                    novQuota += mapQuota.get(id).Q3_M2_Other_Quota__c;
                                    decQuota += mapQuota.get(id).Q3_M3_Other_Quota__c;
                                    janQuota += mapQuota.get(id).Q4_M1_Other_Quota__c;
                                    febQuota += mapQuota.get(id).Q4_M2_Other_Quota__c;
                                    marQuota += mapQuota.get(id).Q4_M3_Other_Quota__c;
                                    }
                                    mapAmtQuota6.put('aprQuota',aprQuota);
                                    mapAmtQuota6.put('mayQuota',mayQuota);
                                    mapAmtQuota6.put('junQuota',junQuota);
                                    mapAmtQuota6.put('julQuota',julQuota);
                                    mapAmtQuota6.put('augQuota',augQuota);
                                    mapAmtQuota6.put('sepQuota',sepQuota);
                                    mapAmtQuota6.put('octQuota',octQuota);
                                    mapAmtQuota6.put('novQuota',novQuota);
                                    mapAmtQuota6.put('decQuota',decQuota);
                                    mapAmtQuota6.put('janQuota',janQuota);
                                    mapAmtQuota6.put('febQuota',febQuota);
                                    mapAmtQuota6.put('marQuota',marQuota);
                                     
                                      mapAmt6.put('aprAmt',aprAmt1);
                                      mapAmt6.put('mayAmt',mayAmt1);
                                      mapAmt6.put('junAmt',junAmt1);
                                      mapAmt6.put('julAmt',julAmt1);
                                      mapAmt6.put('augAmt',augAmt1);
                                      mapAmt6.put('sepAmt',sepAmt1);
                                      mapAmt6.put('octAmt',octAmt1);
                                      mapAmt6.put('novAmt',novAmt1);
                                      mapAmt6.put('decAmt',decAmt1);
                                      mapAmt6.put('janAmt',janAmt1);
                                      mapAmt6.put('febAmt',febAmt1);
                                      mapAmt6.put('marAmt',marAmt1);
                                
                                      mapAmt26.put('aprAmt',aprAmt21);
                                      mapAmt26.put('mayAmt',mayAmt21);
                                      mapAmt26.put('junAmt',junAmt21);
                                      mapAmt26.put('julAmt',julAmt21);
                                      mapAmt26.put('augAmt',augAmt21);
                                      mapAmt26.put('sepAmt',sepAmt21);
                                      mapAmt26.put('octAmt',octAmt21);
                                      mapAmt26.put('novAmt',novAmt21);
                                      mapAmt26.put('decAmt',decAmt21);
                                      mapAmt26.put('janAmt',janAmt21);
                                      mapAmt26.put('febAmt',febAmt21);
                                      mapAmt26.put('marAmt',marAmt21);
                                      
                                    mapFacAmt6.put('aprAmt',aprFacAmt2);  
                                    mapFacAmt6.put('mayAmt',mayFacAmt2);  
                                    mapFacAmt6.put('junAmt',junFacAmt2);  
                                    mapFacAmt6.put('julAmt',julFacAmt2);  
                                    mapFacAmt6.put('augAmt',augFacAmt2);  
                                    mapFacAmt6.put('sepAmt',sepFacAmt2);  
                                    mapFacAmt6.put('octAmt',octFacAmt2);  
                                    mapFacAmt6.put('novAmt',novFacAmt2);  
                                    mapFacAmt6.put('decAmt',decFacAmt2);  
                                    mapFacAmt6.put('janAmt',janFacAmt2);  
                                    mapFacAmt6.put('febAmt',febFacAmt2);  
                                    mapFacAmt6.put('marAmt',marFacAmt2);

                                    mapFacAmt26.put('aprAmt',aprFacAmt22);  
                                    mapFacAmt26.put('mayAmt',mayFacAmt22);  
                                    mapFacAmt26.put('junAmt',junFacAmt22);  
                                    mapFacAmt26.put('julAmt',julFacAmt22);  
                                    mapFacAmt26.put('augAmt',augFacAmt22);  
                                    mapFacAmt26.put('sepAmt',sepFacAmt22);  
                                    mapFacAmt26.put('octAmt',octFacAmt22);  
                                    mapFacAmt26.put('novAmt',novFacAmt22);  
                                    mapFacAmt26.put('decAmt',decFacAmt22);  
                                    mapFacAmt26.put('janAmt',janFacAmt22);  
                                    mapFacAmt26.put('febAmt',febFacAmt22);  
                                    mapFacAmt26.put('marAmt',marFacAmt22);  
                                      
                                
                                }
                                amt = 0;
                                aprAmt1 = 0; mayAmt1 = 0; junAmt1 = 0; julAmt1 = 0; augAmt1 = 0; sepAmt1 = 0;
                                octAmt1 = 0; novAmt1 = 0; decAmt1 = 0; janAmt1 = 0; febAmt1 = 0; marAmt1 = 0;
                                amt2 = 0;
                                aprAmt21 = 0; mayAmt21 = 0; junAmt21 = 0; julAmt21 = 0; augAmt21 = 0; sepAmt21 = 0;
                                octAmt21 = 0; novAmt21 = 0; decAmt21 = 0; janAmt21 = 0; febAmt21 = 0; marAmt21 = 0;
                                
                                FacAmt2 = 0;
                                aprFacAmt2 = 0; mayFacAmt2 = 0; junFacAmt2 = 0; julFacAmt2 = 0; augFacAmt2 = 0; sepFacAmt2 = 0;
                                octFacAmt2 = 0; novFacAmt2 = 0; decFacAmt2 = 0; janFacAmt2 = 0; febFacAmt2 = 0; marFacAmt2 = 0;
                                FacAmt22 = 0; 
                                aprFacAmt22 = 0; mayFacAmt22 = 0; junFacAmt22 = 0; julFacAmt22 = 0; augFacAmt22 = 0; sepFacAmt22 = 0;
                                octFacAmt22 = 0; novFacAmt22 = 0; decFacAmt22 = 0; janFacAmt22 = 0; febFacAmt22 = 0; marFacAmt22 = 0;
                    
                                
                                aprQuota = 0; mayQuota = 0; junQuota = 0; julQuota = 0; augQuota = 0; sepQuota = 0;
                                octQuota = 0; novQuota = 0; decQuota = 0; janQuota = 0; febQuota = 0; marQuota = 0;

        
                            }
                            
                            If((acctype == '1' && opp.MAPS_LOB_Type__c == 'MA') 
                               || (acctype == '2' && opp.MAPS_LOB_Type__c == 'TK') 
                               || (acctype == '3' && opp.MAPS_LOB_Type__c == 'SR') 
                               || (acctype == '4' && opp.MAPS_LOB_Type__c == 'Rental Chillers') 
                               || (acctype == '5' && opp.MAPS_LOB_Type__c == 'MCP') 
                               || (acctype == '6' && opp.MAPS_LOB_Type__c == 'Other') 
                               || acctype == '0')
                            {
                                tempLOB = opp.MAPS_LOB_Type__c;                     
                                if(opp.Amount == null)
                                {
                                    amt = 0;
                                    FacAmt2 = 0;
                                }
                                else
                                {                           
                                    amt = opp.Amount;
                                    FacAmt2 = opp.Factored_Amount__c;
                                }
                                System.debug('@@@@@@@@ oppname :'+opp.name+' LOB'+opp.MAPS_LOB_Type__c+'  dummy date :'+opp.CloseDate + 'Opp Amt:'+opp.Amount+'month :'+Date.Today().month());
                                if(((opp.CloseDate >= Date.newInstance(Date.Today().year(),4,1) && opp.CloseDate <= Date.newInstance(Date.Today().addYears(1).year(),3,31)) && (Date.Today().month() != 1 && Date.Today().month() != 2 && Date.Today().month() != 3)) || (opp.CloseDate.year() ==  Date.Today().year() && (Date.Today().month() == 1 || Date.Today().month() == 2 || Date.Today().month() == 3) && (opp.CloseDate >= Date.newInstance(Date.Today().year(),1,1) && opp.CloseDate <= Date.newInstance(Date.Today().year(),3,31))) || (opp.CloseDate.year() ==  Date.Today().addyears(-1).year() && (opp.CloseDate >= Date.newInstance(Date.Today().addyears(-1).year(),4,1) && opp.CloseDate <= Date.newInstance(Date.Today().year(),3,31)))) {


                                  //Current Financial Year
                                  if(opp.CloseDate.month() >= 4 && opp.CloseDate.month() <= 6) {
                                    //Quarter1
                                    if(opp.CloseDate.month() == 4) {
                                      //April
                                        System.debug('apramt :'+opp.amount);
                                        aprAmt1 += amt;
                                        aprFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  aprAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  aprAmt3 += amt;
                                    }
                                    else if(opp.CloseDate.month() == 5) {
                                      //May
                                      mayAmt1 += amt;
                                      mayFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  mayAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  mayAmt3 += amt;  
                                    }
                                    else if(opp.CloseDate.month() == 6) {
                                      //June
                                        junAmt1 += amt;
                                        junFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  junAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  junAmt3 += amt;
                                    }
                                    //Q1Quota += mapQuota.get(id).Target_Q1__c;
                                  }
                                  
                                  else if(opp.CloseDate.month() >= 7 && opp.CloseDate.month() <= 9) {
                                    //Quarter2
                                    if(opp.CloseDate.month() == 7) {
                                      //July
                                        julAmt1 += amt;
                                        julFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  julAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  julAmt3 += amt;
                                    }
                                    else if(opp.CloseDate.month() == 8) {
                                      //August
                                        augAmt1 += amt;
                                        augFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  augAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  augAmt3 += amt;
                                    }
                                    else if(opp.CloseDate.month() == 9) {
                                      //September
                                        sepAmt1 += amt;
                                        sepFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  sepAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  sepAmt3 += amt;  
                                    }
                                    //Q2Quota += mapQuota.get(id).Target_Q2__c;
                                  }
                                  
                                  else if(opp.CloseDate.month() >= 10 && opp.CloseDate.month() <= 12) {
                                    //Quarter3
                                    if(opp.CloseDate.month() == 10) {
                                      //October
                                        octAmt1 += amt;
                                        octFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  octAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  octAmt3 += amt;
                                    }
                                    else if(opp.CloseDate.month() == 11) {
                                      //November
                                        novAmt1 += amt;
                                        novFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  novAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  novAmt3 += amt;
                                      
                                    }
                                    else if(opp.CloseDate.month() == 12) {
                                      //December
                                        decAmt1 += amt;
                                        decFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  decAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  decAmt3 += amt;
                                    }
                                    //Q3Quota += mapQuota.get(id).Target_Q3__c;
                                  }
                                  
                                  else if(opp.CloseDate.month() >= 1 && opp.CloseDate.month() <= 3) {
                                    //Quarter4
                                    if((math.mod(opp.CloseDate.year(),400) == 0) || ((math.mod(opp.CloseDate.year(),4) == 0) && (math.mod(opp.CloseDate.year(),100) != 0)))
                                      day = 29;
                                    else
                                      day = 28;
                                    
                                    if(opp.CloseDate.month() == 1) {
                                      //January
                                        janAmt1 += amt;
                                        janFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  janAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  janAmt3 += amt;
                                    }
                                  else if(opp.CloseDate.month() == 2) {
                                    //February
                                      febAmt1 += amt;
                                      febFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  febAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  febAmt3 += amt;
                                  }
                                    else if(opp.CloseDate.month() == 3) {
                                      //March
                                        marAmt1 += amt;
                                        marFacAmt2 += FacAmt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  marAmt2 += amt;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  marAmt3 += amt;
                                    }
                                    //Q4Quota += mapQuota.get(id).Target_Q4__c;
                                  }//else if
                                  
                                }//if - Financial year

                                else If(((opp.CloseDate >= Date.newInstance(Date.Today().addYears(1).year(),4,1) 
                                         && opp.CloseDate <= Date.newInstance(Date.Today().addYears(2).year(),3,31)) 
                                         && (Date.Today().month() != 1 && Date.Today().month() != 2 
                                         && Date.Today().month() != 3)) 
                                      || (opp.CloseDate.year() ==  Date.Today().year() 
                                         && (opp.CloseDate >= Date.newInstance(Date.Today().year(),4,1) 
                                         && opp.CloseDate <= Date.newInstance(Date.Today().addYears(1).year(),3,31))))
                                {
                                    if(opp.Amount == null)
                                    {
                                        amt2 = 0;
                                        FacAmt22 = 0;
                                    }
                                    else
                                    {
                                        amt2 = opp.Amount;
                                        FacAmt22 = opp.Factored_Amount__c;
                                    }
                                  System.debug('******@@@@ dummy date :'+opp.CloseDate+'   opp name :'+opp.name);
                                  if(opp.CloseDate.month() >= 4 && opp.CloseDate.month() <= 6) {
                                    //Quarter1
                                    if(opp.CloseDate.month() == 4) {
                                      //April
                                        aprAmt21 += amt2;
                                        aprFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  aprAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  aprAmt23 += amt2;
                                    }
                                    else if(opp.CloseDate.month() == 5) {
                                      //May
                                        mayAmt21 += amt2;
                                        mayFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  mayAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  mayAmt23 += amt2;  
                                    }
                                    else if(opp.CloseDate.month() == 6) {
                                      //June
                                        junAmt21 += amt2;
                                        junFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  junAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  junAmt23 += amt2;
                                    }
                                    //Q1Quota += mapQuota.get(id).Target_Q1__c;
                                  }
                                  
                                  else if(opp.CloseDate.month() >= 7 && opp.CloseDate.month() <= 9) {
                                    //Quarter2
                                    if(opp.CloseDate.month() == 7) {
                                      //July
                                        julAmt21 += amt2;
                                        julFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  julAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  julAmt23 += amt2;
                                    }
                                    else if(opp.CloseDate.month() == 8) {
                                      //August
                                        augAmt21 += amt2;
                                        augFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  augAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  augAmt23 += amt2;
                                    }
                                    else if(opp.CloseDate.month() == 9) {
                                      //September
                                        sepAmt21 += amt2;
                                        sepFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  sepAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  sepAmt23 += amt2;  
                                    }
                                    //Q2Quota += mapQuota.get(id).Target_Q2__c;
                                  }
                                  
                                  else if(opp.CloseDate.month() >= 10 && opp.CloseDate.month() <= 12) {
                                    //Quarter3
                                    if(opp.CloseDate.month() == 10) {
                                      //October
                                        octAmt21 += amt2;
                                        octFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  octAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  octAmt23 += amt2;
                                    }
                                    else if(opp.CloseDate.month() == 11) {
                                      //November
                                        novAmt21 += amt2;
                                        novFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  novAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  novAmt23 += amt2;
                                      
                                    }
                                    else if(opp.CloseDate.month() == 12) {
                                      //December
                                        decAmt21 += amt2;
                                        decFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  decAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  decAmt23 += amt2;
                                    }
                                    //Q3Quota += mapQuota.get(id).Target_Q3__c;
                                  }
                                  
                                  else if(opp.CloseDate.month() >= 1 && opp.CloseDate.month() <= 3) {
                                    //Quarter4
                                    if((math.mod(opp.CloseDate.year(),400) == 0) || ((math.mod(opp.CloseDate.year(),4) == 0) && (math.mod(opp.CloseDate.year(),100) != 0)))
                                      day = 29;
                                    else
                                      day = 28;
                                    
                                    if(opp.CloseDate.month() == 1) {
                                      //January
                                        janAmt21 += amt2;
                                        janFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  janAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  janAmt23 += amt2;
                                    }
                                  else if(opp.CloseDate.month() == 2) {
                                    //February
                                      febAmt21 += amt2;
                                      febFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  febAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  febAmt23 += amt2;
                                  }
                                    else if(opp.CloseDate.month() == 3) {
                                      //March
                                        marAmt21 += amt2;
                                        marFacAmt22 += FacAmt22;
                                      //else if(opp.MAPS_LOB_Type__c.contains('TK'))  marAmt22 += amt2;
                                      //else if(opp.MAPS_LOB_Type__c.contains('SR'))  marAmt23 += amt2;
                                    }
                                    //Q4Quota += mapQuota.get(id).Target_Q4__c;
                                  }//else if
                                  
                                }//next financial year
                            }
                            }
                        }//for - Opportunity
                    
                    
                        tempvar = True;
                        mapAmt7.put('aprAmt',aprAmt1);  
                        mapAmt7.put('mayAmt',mayAmt1);  
                        mapAmt7.put('junAmt',junAmt1);  
                        mapAmt7.put('julAmt',julAmt1);  
                        mapAmt7.put('augAmt',augAmt1);  
                        mapAmt7.put('sepAmt',sepAmt1);  
                        mapAmt7.put('octAmt',octAmt1);  
                        mapAmt7.put('novAmt',novAmt1);  
                        mapAmt7.put('decAmt',decAmt1);  
                        mapAmt7.put('janAmt',janAmt1);  
                        mapAmt7.put('febAmt',febAmt1);  
                        mapAmt7.put('marAmt',marAmt1);
                        

                        mapAmt27.put('aprAmt',aprAmt21);  
                        mapAmt27.put('mayAmt',mayAmt21);  
                        mapAmt27.put('junAmt',junAmt21);  
                        mapAmt27.put('julAmt',julAmt21);  
                        mapAmt27.put('augAmt',augAmt21);  
                        mapAmt27.put('sepAmt',sepAmt21);  
                        mapAmt27.put('octAmt',octAmt21);  
                        mapAmt27.put('novAmt',novAmt21);  
                        mapAmt27.put('decAmt',decAmt21);  
                        mapAmt27.put('janAmt',janAmt21);  
                        mapAmt27.put('febAmt',febAmt21);  
                        mapAmt27.put('marAmt',marAmt21);  
                        
                        mapFacAmt7.put('aprAmt',aprFacAmt2);  
                        mapFacAmt7.put('mayAmt',mayFacAmt2);  
                        mapFacAmt7.put('junAmt',junFacAmt2);  
                        mapFacAmt7.put('julAmt',julFacAmt2);  
                        mapFacAmt7.put('augAmt',augFacAmt2);  
                        mapFacAmt7.put('sepAmt',sepFacAmt2);  
                        mapFacAmt7.put('octAmt',octFacAmt2);  
                        mapFacAmt7.put('novAmt',novFacAmt2);  
                        mapFacAmt7.put('decAmt',decFacAmt2);  
                        mapFacAmt7.put('janAmt',janFacAmt2);  
                        mapFacAmt7.put('febAmt',febFacAmt2);  
                        mapFacAmt7.put('marAmt',marFacAmt2);

                        mapFacAmt27.put('aprAmt',aprFacAmt22);  
                        mapFacAmt27.put('mayAmt',mayFacAmt22);  
                        mapFacAmt27.put('junAmt',junFacAmt22);  
                        mapFacAmt27.put('julAmt',julFacAmt22);  
                        mapFacAmt27.put('augAmt',augFacAmt22);  
                        mapFacAmt27.put('sepAmt',sepFacAmt22);  
                        mapFacAmt27.put('octAmt',octFacAmt22);  
                        mapFacAmt27.put('novAmt',novFacAmt22);  
                        mapFacAmt27.put('decAmt',decFacAmt22);  
                        mapFacAmt27.put('janAmt',janFacAmt22);  
                        mapFacAmt27.put('febAmt',febFacAmt22);  
                        mapFacAmt27.put('marAmt',marFacAmt22); 

                        system.debug('************id :'+id+'  tempLOB : '+tempLOB+'  quota'+mapQuota.get(id));
                        

                    If(mapQuota.get(id) != null && tempLOB == 'MA' && id != null && mapQuota.get(id).Q1_M1_MA_Quota__c != null)
                    {
                        aprQuota += mapQuota.get(id).Q1_M1_MA_Quota__c;
                        mayQuota += mapQuota.get(id).Q1_M2_MA_Quota__c;
                        junQuota += mapQuota.get(id).Q1_M3_MA_Quota__c;
                        julQuota += mapQuota.get(id).Q2_M1_MA_Quota__c;
                        augQuota += mapQuota.get(id).Q2_M2_MA_Quota__c;
                        sepQuota += mapQuota.get(id).Q2_M3_MA_Quota__c;
                        octQuota += mapQuota.get(id).Q3_M1_MA_Quota__c;
                        novQuota += mapQuota.get(id).Q3_M2_MA_Quota__c;
                        decQuota += mapQuota.get(id).Q3_M3_MA_Quota__c;
                        janQuota += mapQuota.get(id).Q4_M1_MA_Quota__c;
                        febQuota += mapQuota.get(id).Q4_M2_MA_Quota__c;
                        marQuota += mapQuota.get(id).Q4_M3_MA_Quota__c;
                    
                    }
                    else If(mapQuota.get(id) != null && tempLOB == 'TK' && id != null && mapQuota.get(id).Q1_M1_TK_Quota__c != null)
                    {
                        aprQuota += mapQuota.get(id).Q1_M1_TK_Quota__c;
                        mayQuota += mapQuota.get(id).Q1_M2_TK_Quota__c;
                        junQuota += mapQuota.get(id).Q1_M3_TK_Quota__c;
                        julQuota += mapQuota.get(id).Q2_M1_TK_Quota__c;
                        augQuota += mapQuota.get(id).Q2_M2_TK_Quota__c;
                        sepQuota += mapQuota.get(id).Q2_M3_TK_Quota__c;
                        octQuota += mapQuota.get(id).Q3_M1_TK_Quota__c;
                        novQuota += mapQuota.get(id).Q3_M2_TK_Quota__c;
                        decQuota += mapQuota.get(id).Q3_M3_TK_Quota__c;
                        janQuota += mapQuota.get(id).Q4_M1_TK_Quota__c;
                        febQuota += mapQuota.get(id).Q4_M2_TK_Quota__c;
                        marQuota += mapQuota.get(id).Q4_M3_TK_Quota__c;
                    
                    }
                    else If(mapQuota.get(id) != null && tempLOB == 'SR' && id != null && mapQuota.get(id).Q1_M1_SR_Quota__c != null)
                    {
                        aprQuota += mapQuota.get(id).Q1_M1_SR_Quota__c;
                        mayQuota += mapQuota.get(id).Q1_M2_SR_Quota__c;
                        junQuota += mapQuota.get(id).Q1_M3_SR_Quota__c;
                        julQuota += mapQuota.get(id).Q2_M1_SR_Quota__c;
                        augQuota += mapQuota.get(id).Q2_M2_SR_Quota__c;
                        sepQuota += mapQuota.get(id).Q2_M3_SR_Quota__c;
                        octQuota += mapQuota.get(id).Q3_M1_SR_Quota__c;
                        novQuota += mapQuota.get(id).Q3_M2_SR_Quota__c;
                        decQuota += mapQuota.get(id).Q3_M3_SR_Quota__c;
                        janQuota += mapQuota.get(id).Q4_M1_SR_Quota__c;
                        febQuota += mapQuota.get(id).Q4_M2_SR_Quota__c;
                        marQuota += mapQuota.get(id).Q4_M3_SR_Quota__c;
                    
                    }
                    else If(mapQuota.get(id) != null && tempLOB == 'Rental Chillers' && id != null && mapQuota.get(id).Q1_M1_RC_Quota__c != null)
                    {
                        aprQuota += mapQuota.get(id).Q1_M1_RC_Quota__c;
                        mayQuota += mapQuota.get(id).Q1_M2_RC_Quota__c;
                        junQuota += mapQuota.get(id).Q1_M3_RC_Quota__c;
                        julQuota += mapQuota.get(id).Q2_M1_RC_Quota__c;
                        augQuota += mapQuota.get(id).Q2_M2_RC_Quota__c;
                        sepQuota += mapQuota.get(id).Q2_M3_RC_Quota__c;
                        octQuota += mapQuota.get(id).Q3_M1_RC_Quota__c;
                        novQuota += mapQuota.get(id).Q3_M2_RC_Quota__c;
                        decQuota += mapQuota.get(id).Q3_M3_RC_Quota__c;
                        janQuota += mapQuota.get(id).Q4_M1_RC_Quota__c;
                        febQuota += mapQuota.get(id).Q4_M2_RC_Quota__c;
                        marQuota += mapQuota.get(id).Q4_M3_RC_Quota__c;
                    
                    }
                    else If(mapQuota.get(id) != null && tempLOB == 'MCP' && id != null && mapQuota.get(id).Q1_M1_MCP_Quota__c != null)
                    {
                                    aprQuota += mapQuota.get(id).Q1_M1_MCP_Quota__c;
                                    mayQuota += mapQuota.get(id).Q1_M2_MCP_Quota__c;
                                    junQuota += mapQuota.get(id).Q1_M3_MCP_Quota__c;
                                    julQuota += mapQuota.get(id).Q2_M1_MCP_Quota__c;
                                    augQuota += mapQuota.get(id).Q2_M2_MCP_Quota__c;
                                    sepQuota += mapQuota.get(id).Q2_M3_MCP_Quota__c;
                                    octQuota += mapQuota.get(id).Q3_M1_MCP_Quota__c;
                                    novQuota += mapQuota.get(id).Q3_M2_MCP_Quota__c;
                                    decQuota += mapQuota.get(id).Q3_M3_MCP_Quota__c;
                                    janQuota += mapQuota.get(id).Q4_M1_MCP_Quota__c;
                                    febQuota += mapQuota.get(id).Q4_M2_MCP_Quota__c;
                                    marQuota += mapQuota.get(id).Q4_M3_MCP_Quota__c;
                    
                    }
                    else If(mapQuota.get(id) != null && tempLOB == 'Other' && id != null && mapQuota.get(id).Q1_M1_Other_Quota__c != null)
                    {
                                    aprQuota += mapQuota.get(id).Q1_M1_Other_Quota__c;
                                    mayQuota += mapQuota.get(id).Q1_M2_Other_Quota__c;
                                    junQuota += mapQuota.get(id).Q1_M3_Other_Quota__c;
                                    julQuota += mapQuota.get(id).Q2_M1_Other_Quota__c;
                                    augQuota += mapQuota.get(id).Q2_M2_Other_Quota__c;
                                    sepQuota += mapQuota.get(id).Q2_M3_Other_Quota__c;
                                    octQuota += mapQuota.get(id).Q3_M1_Other_Quota__c;
                                    novQuota += mapQuota.get(id).Q3_M2_Other_Quota__c;
                                    decQuota += mapQuota.get(id).Q3_M3_Other_Quota__c;
                                    janQuota += mapQuota.get(id).Q4_M1_Other_Quota__c;
                                    febQuota += mapQuota.get(id).Q4_M2_Other_Quota__c;
                                    marQuota += mapQuota.get(id).Q4_M3_Other_Quota__c;
                    
                    }
                    
                        mapAmtQuota7.put('aprQuota',aprQuota);
                        mapAmtQuota7.put('mayQuota',mayQuota);
                        mapAmtQuota7.put('junQuota',junQuota);
                        mapAmtQuota7.put('julQuota',julQuota);
                        mapAmtQuota7.put('augQuota',augQuota);
                        mapAmtQuota7.put('sepQuota',sepQuota);
                        mapAmtQuota7.put('octQuota',octQuota);
                        mapAmtQuota7.put('novQuota',novQuota);
                        mapAmtQuota7.put('decQuota',decQuota);
                        mapAmtQuota7.put('janQuota',janQuota);
                        mapAmtQuota7.put('febQuota',febQuota);
                        mapAmtQuota7.put('marQuota',marQuota);
                    
                    System.debug('########mapamt7 :'+mapAmt7);
                    if(accType == '0')
                    {
                        boolean boolAccType = true;
                        
                        If(tempMA == True)
                        {
                            tableWrap.add(new oppAmtCalc('MA', mapAmt1, mapAmtQuota1, mapAmt21, mapAmtQuota1, mapFacAmt1, mapFacAmt21,true, boolAccType, false,OwnerName));
                            boolAccType = False;
                        }

                        If(tempTK == True )
                        {
                            tableWrap.add(new oppAmtCalc('TK', mapAmt2, mapAmtQuota2, mapAmt22, mapAmtQuota2, mapFacAmt2, mapFacAmt22, true, boolAccType,false,OwnerName));
                            boolAccType = False;
                        }

                        If(tempSR == True)
                        {
                            tableWrap.add(new oppAmtCalc('SR', mapAmt3, mapAmtQuota3, mapAmt23, mapAmtQuota3, mapFacAmt3, mapFacAmt23, true, boolAccType,false,OwnerName));
                            boolAccType = False;                            
                        }

                        If(tempRental == True)
                        {                       
                            tableWrap.add(new oppAmtCalc('Rental Chillers', mapAmt4, mapAmtQuota4, mapAmt24, mapAmtQuota4, mapFacAmt4,mapFacAmt24, true, boolAccType,false,OwnerName));
                            boolAccType = False;                            
                        }
                        
                        If(tempMCP == True)
                        {
                            tableWrap.add(new oppAmtCalc('MCP', mapAmt5, mapAmtQuota5, mapAmt25, mapAmtQuota5, mapFacAmt5, mapFacAmt25, true, boolAccType,false,OwnerName));
                            boolAccType = False;                            
                        }
                        
                        If(tempOther == True)
                        {
                            tableWrap.add(new oppAmtCalc('Other', mapAmt6, mapAmtQuota6, mapAmt26, mapAmtQuota6, mapFacAmt6, mapFacAmt26, true, boolAccType,false,OwnerName));
                            boolAccType = False;                            
                        }
                        System.debug('Map 7 LOB :'+tempLOB+'  mapamt : '+mapAmt7);
//                        If(tempvar && tempLOB != 'False')
                        If(tempvar)
                        {
                            tableWrap.add(new oppAmtCalc(tempLOB, mapAmt7, mapAmtQuota7, mapAmt27, mapAmtQuota7, mapFacAmt7, mapFacAmt27, true, boolAccType,true,OwnerName));
                            boolAccType = False;                            
                        }   
                    }                   
                    else if(accType == '1')
                    {
                        tableWrap.add(new oppAmtCalc('MA', mapAmt7, mapAmtQuota7, mapAmt27, mapAmtQuota7, mapFacAmt7, mapFacAmt27, false, false,false,OwnerName));
                    }
                    else if(accType == '2')
                    {
                    
                        tableWrap.add(new oppAmtCalc('TK', mapAmt7, mapAmtQuota7, mapAmt27, mapAmtQuota7, mapFacAmt7, mapFacAmt27, false, false,false,OwnerName));
                    }
                    else if(accType == '3')
                    {
                    
                      tableWrap.add(new oppAmtCalc('SR', mapAmt7, mapAmtQuota7, mapAmt27, mapAmtQuota7, mapFacAmt7, mapFacAmt27, false, false,false,OwnerName));
                    }
                    else if(accType == '4')
                    {
                      tableWrap.add(new oppAmtCalc('Rental Chillers', mapAmt7, mapAmtQuota7, mapAmt27,mapAmtQuota7, mapFacAmt7, mapFacAmt27, false, false,false,OwnerName));
                    }
                    else if(accType == '5')
                    {
                      tableWrap.add(new oppAmtCalc('MCP', mapAmt7, mapAmtQuota7, mapAmt27, mapAmtQuota7, mapFacAmt7, mapFacAmt27, false, false,false,OwnerName));
                    }
                    
                    else if(accType == '6')
                    {
                      tableWrap.add(new oppAmtCalc('Other', mapAmt7, mapAmtQuota7, mapAmt27, mapAmtQuota7, mapFacAmt7, mapFacAmt27, false, false,false,OwnerName));
                    }
                
              }//User Loop.    
          return tableWrap;
        //} catch(Exception ex){
          //tableWrap.add(new oppAmtCalc('CATEGORY ERROR ' + ex.getMessage(),null,null,null,null,null,null,false,false,false,null));
          //return tableWrap;
        //}
      } set;
    } 

    class accOppWrapper {
        public Id accOwnerId {get; set;}
        public transient String accOwnerName {get; set;}
        
        public transient List<oppCategory> lstOppCategoryA {get; set;}
        public transient List<oppCategory> lstOppCategoryB {get; set;}
        public transient List<oppCategory> lstOppCategoryC {get; set;}
        
        public accOppWrapper(Id accOwnerId, String accOwnerName, List<oppCategory> lstOppCatA, List<oppCategory> lstOppCatB, List<oppCategory> lstOppCatC) {
            this.accOwnerId = accOwnerId;
            this.accOwnerName = accOwnerName;
            
            this.lstOppCategoryA = new List<oppCategory>(lstOppCatA);
            this.lstOppCategoryB = new List<oppCategory>(lstOppCatB);
            this.lstOppCategoryC = new List<oppCategory>(lstOppCatC);
        }
    }
    
     class oppCategory {
        public transient String cat {get; set;}
        public transient List<accOppSum> lstAccOppSum {get; set;}
        
        public oppCategory(String cat, List<accOppSum> lstAccOppSum){
            this.cat = cat;
            this.lstAccOppSum = new List<accOppSum>(lstAccOppSum);
        }
    }
    
       /******************************THIRD SCETION TABLE CLASS STARTS*******************************/
    
    class accOppSum {
        public Id accId {get; set;}
        public transient String accName {get; set;}
        public transient String accNumber {get; set;}
        public transient String accPhone {get; set;}
        public transient String totOppSum {get; set;}
        
        public accOppSum(Id accId, String accName, String accNumber, String accPhone, decimal totOppSum){
            this.accId = accId;
            this.accName = accName;
            this.accNumber = accNumber;
            this.accPhone = accPhone;
            this.totOppSum = totOppSum + '';
        }
    }
    
   public class MajorAccounts{
        public transient String lobType{get;set;}
        public transient String accName {get;set;}
        public transient decimal  totalOppValue {get; set;}
        public transient String oppName {get; set;}
        public transient String OppOwner {get; set;}
        public Boolean nationalAcc {get; set;}
        public Boolean japanCompany {get; set;}
        public transient String AccId{get;set;}
        public transient String OppId{get;set;}
        
        public MajorAccounts(String lobType, String accName,String OppName,String oppOwner, Decimal totalOppValue,Boolean nationalAcc, Boolean japanCompany, String AccId, String OppId) {
            this.lobType = lobType;
            this.accName = accName;
            this.totalOppValue = totalOppValue;
            this.nationalAcc = nationalAcc;
            this.japanCompany = japanCompany;
            this.oppName=oppName;
            this.OppOwner=oppOwner;
            this.AccId = AccId;
            this.OppId = OppId;
        }
    }
    
    public transient Map<String,List<MajorAccounts>> majorAcclist {get; set;}
    
    public Map<String,List<MajorAccounts>> getMajorAccounts { get{
        majorAcclist = new Map<String,List<MajorAccounts>>();
        
/******     
        Map<String, MajorAccounts> mapMAAccts = new Map<String, MajorAccounts>();
        Map<String, MajorAccounts> mapSRAccts = new Map<String, MajorAccounts>();
        Map<String, MajorAccounts> mapTKAccts = new Map<String, MajorAccounts>();
        Map<String, MajorAccounts> mapRCAccts = new Map<String, MajorAccounts>();
        Map<String, MajorAccounts> mapMCPAccts = new Map<String, MajorAccounts>();
        Map<String, MajorAccounts> mapOtherAccts = new Map<String, MajorAccounts>();
*******/        
		userIds = new Set<Id>();
        Set<Id> setSubRoleIds = new Set<Id>();
        
        String[] selIds = selectedValues.split(',');
        system.debug('sel ids ' + selIds);
        
        //if(selIds.size() == 0)  return false;
        
        for(String role : selIds)
        {
            if(role.length() >= 15)
            	setSubRoleIds.add(role.subString(0,15));
            //else if(role.leng)
           // 	setSubRoleIds.add(role);
            
        }
        
        system.debug('sub roles ' + setSubRoleIds);
        for(String id : selIds){
            id = id.trim();
            system.debug('id val ' + id);
            if(id.startswith('005')){//This is user
                userIds.add(id);
            }
        } 
        transient List<MajorAccounts> listMAAccts = new List<MajorAccounts>();
        transient List<MajorAccounts> listMAAcctsTotal = new List<MajorAccounts>();       
        transient List<MajorAccounts> listSRAccts = new List<MajorAccounts>();
        transient List<MajorAccounts> listSRAcctsTotal = new List<MajorAccounts>(); 
        transient List<MajorAccounts> listTKAccts = new List<MajorAccounts>();
        transient List<MajorAccounts> listTKAcctsTotal = new List<MajorAccounts>(); 
        transient List<MajorAccounts> listRCAccts = new List<MajorAccounts>();
        transient List<MajorAccounts> listRCAcctsTotal = new List<MajorAccounts>(); 
        transient List<MajorAccounts> listMCPAccts = new List<MajorAccounts>();
        transient List<MajorAccounts> listMCPAcctsTotal = new List<MajorAccounts>(); 
        transient List<MajorAccounts> listOtherAccts = new List<MajorAccounts>();
        transient List<MajorAccounts> listOtherAcctsTotal = new List<MajorAccounts>(); 

        String tempAccMA = 'False';
        Id accIdMA;
        Decimal tempAccMASum = 0;
        boolean tempAccMANA = False;
        boolean tempAccMAJA = False;

        String tempAccSR = 'False';
        Id accIdSR;
        Decimal tempAccSRSum = 0;
        boolean tempAccSRNA = False;
        boolean tempAccSRJA = False;

        String tempAccTK = 'False';
        Id accIdTK;
        Decimal tempAccTKSum = 0;
        boolean tempAccTKNA = False;
        boolean tempAccTKJA = False;

        String tempAccRC = 'False';
        Id accIdRC;
        Decimal tempAccRCSum = 0;
        boolean tempAccRCNA = False;
        boolean tempAccRCJA = False;

        String tempAccMCP = 'False';
        Id accIdMCP;
        Decimal tempAccMCPSum = 0;
        boolean tempAccMCPNA = False;
        boolean tempAccMCPJA = False;

        String tempAccOther = 'False';
        Id accIdOther;
        Decimal tempAccOtherSum = 0;
        boolean tempAccOtherNA = False;
        boolean tempAccOtherJA = False;
        
        
        for(Opportunity opp : [Select o.Name, o.Id, o.MAPS_LOB_Type__c, o.Amount, o.Account.Total_Opportunity_Amount__c, o.Account.Japanese_Company__c, o.Account.Account_Type__c, 
                                	  o.Account.Account_Owner_Name__c, o.Account.Account_Owner_Department__c, o.Account.National_Account__c, o.Account.OwnerId, o.Must_Win__c,
                                	  o.Account.Name, o.AccountId,o.Owner.name 
                                  From Opportunity o 
                                 where ownerId IN: userIds 
                                   and isClosed = false order by Account.name])
        {
        
                If(tempAccMA !='False' && opp.Account.name != tempAccMA )
                {
                    //(String lobType, String accName,String OppName,String oppOwner, Decimal totalOppValue,Boolean nationalAcc, Boolean japanCompany, String AccId, String OppId)
                    listMAAcctsTotal.add(new MajorAccounts('MA', tempAccMA, '','',tempAccMASum,tempAccMANA, tempAccMAJA,accIdMA, null));
                    listMAAcctsTotal.addAll(listMAAccts);
                    tempAccMASum = 0;
                    listMAAccts = new List<MajorAccounts>();
                    tempAccMANA = False;
                    tempAccMAJA = False;
                    tempAccMA = 'False';
                }
                If(tempAccSR !='False' && opp.Account.name != tempAccSR )
                {
                    
                    listSRAcctsTotal.add(new MajorAccounts('SR', tempAccSR, '','',tempAccSRSum,tempAccSRNA, tempAccSRJA, accIdSR, null));
                    listSRAcctsTotal.addAll(listSRAccts);
                    tempAccSRSum = 0;
                    listSRAccts = new List<MajorAccounts>();
                    tempAccSRNA = False;
                    tempAccSRJA = False;
                    tempAccSR = 'False';
                }
                If(tempAccTK !='False' && opp.Account.name != tempAccTK )
                {
                    
                    listTKAcctsTotal.add(new MajorAccounts('TK', tempAccTK, '','',tempAccTKSum,tempAccTKNA, tempAccTKJA, accIdTK, null));
                    listTKAcctsTotal.addAll(listTKAccts);
                    tempAccTKSum = 0;
                    listTKAccts = new List<MajorAccounts>();
                    tempAccTKNA = False;
                    tempAccTKJA = False;
                    tempAccTK = 'False';
                }
                If(tempAccRC !='False' && opp.Account.name != tempAccRC )
                {
                    
                    listRCAcctsTotal.add(new MajorAccounts('RC', tempAccRC, '','',tempAccRCSum, tempAccRCNA, tempAccRCJA, accIdRC, null));
                    listRCAcctsTotal.addAll(listRCAccts);
                    tempAccRCSum = 0;
                    listRCAccts = new List<MajorAccounts>();
                    tempAccRCNA = False;
                    tempAccRCJA = False;
                    tempAccRC = 'False';
                }
                If(tempAccMCP !='False' && opp.Account.name != tempAccMCP )
                {
                    
                    listMCPAcctsTotal.add(new MajorAccounts('MCP', tempAccMCP, '','',tempAccMCPSum,tempAccMCPNA, tempAccMCPJA, accIdMCP, null));
                    listMCPAcctsTotal.addAll(listMCPAccts);
                    tempAccMCPSum = 0;
                    listMCPAccts = new List<MajorAccounts>();
                    tempAccMCPNA = False;
                    tempAccMCPJA = False;
                    tempAccMCP = 'False';
                }
                If(tempAccOther !='False' && opp.Account.name != tempAccOther )
                {
                    
                    listOtherAcctsTotal.add(new MajorAccounts('Other', tempAccOther, '','',tempAccOtherSum,tempAccOtherNA, tempAccOtherJA, accIdOther, null));
                    listOtherAcctsTotal.addAll(listOtherAccts);
                    tempAccOtherSum = 0;
                    listOtherAccts = new List<MajorAccounts>();
                    tempAccOtherNA = False;
                    tempAccOtherJA = False;
                    tempAccOther = 'False';
                }
                                    
            if(opp.Maps_LOB_Type__c == 'MA' )
            {
                
                

                /*If(opp.Account.Account_Type__c == 'Strategic')
                {
                    listMAAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'', opp.Name,opp.owner.name,opp.Amount, opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                Else*/ 
                If(opp.Amount >=100000 || opp.Must_Win__c)
                {
                    listMAAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'',opp.Name,opp.owner.name, opp.Amount, opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                If(opp.Amount >=100000 || opp.Must_Win__c)//opp.Account.Account_Type__c == 'Strategic' || 
                {
                    tempAccMA = opp.Account.name;
                    accIdMA = opp.AccountId;
                    If(opp.Amount != null)
                        tempAccMASum = tempAccMASum + opp.Amount;
                    tempAccMANA = opp.Account.National_Account__c;
                    tempAccMAJA = opp.Account.Japanese_Company__c;
                }
                
                
            }
            else if(opp.Maps_LOB_Type__c == 'SR' )
            {
            
                /*If(opp.Account.Account_Type__c == 'Strategic')
                { 
                    listSRAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'', opp.Name,opp.owner.name,opp.Amount, opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                Else*/
                If(opp.Amount >=50000 || opp.Must_Win__c){    
                    listSRAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'',opp.name,opp.owner.name, opp.Amount, opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                If(opp.Amount >=50000 || opp.Must_Win__c)//opp.Account.Account_Type__c == 'Strategic' || 
                {
                    tempAccSR = opp.Account.name;
                    accIdSR = opp.AccountId;
                    If(opp.Amount != null)
                        tempAccSRSum = tempAccSRSum + opp.Amount;
                    tempAccSRNA = opp.Account.National_Account__c;
                    tempAccSRJA = opp.Account.Japanese_Company__c;
                }

            }
            else if(opp.Maps_LOB_Type__c == 'TK' )
            {
            
                /*If(opp.Account.Account_Type__c == 'Strategic')
                { 
                    listTKAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'', opp.Name,opp.owner.name,opp.Amount, opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                else */
                if(opp.Amount >=250000 || opp.Must_Win__c)
                {
                    listTKAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'',opp.name,opp.owner.name, opp.Amount, opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                If(opp.Amount >=250000 || opp.Must_Win__c)//opp.Account.Account_Type__c == 'Strategic' || 
                {
                    tempAccTK = opp.Account.name;
                    accIdTK = opp.AccountId;
                    If(opp.Amount != null )
                        tempAccTKSum = tempAccTKSum + opp.Amount;
                    tempAccTKNA = opp.Account.National_Account__c;
                    tempAccTKJA = opp.Account.Japanese_Company__c;
                }
                
            }
            else if(opp.Maps_LOB_Type__c == 'Rental Chillers' )
            {
            	/*
                If(opp.Account.Account_Type__c == 'Strategic')
                { 
                    listRCAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'', opp.Name,opp.owner.name,opp.Amount,opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }else*/
                if(opp.Amount >=100000 || opp.Must_Win__c)
                {
                    listRCAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'',opp.name,opp.owner.name, opp.Amount, opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                If(opp.Amount >=100000 || opp.Must_Win__c)//opp.Account.Account_Type__c == 'Strategic' || 
                {
                    tempAccRC = opp.Account.name;
                    accIdRC = opp.AccountId;
                    if(opp.Amount != null)
                        tempAccRCSum = tempAccRCSum + opp.Amount;
                    tempAccRCNA = opp.Account.National_Account__c;
                    tempAccRCJA = opp.Account.Japanese_Company__c;
                }
            }
            else if(opp.Maps_LOB_Type__c == 'MCP' && (opp.Amount >=500000 || opp.Must_Win__c))
            {
            	/*
                If(opp.Account.Account_Type__c == 'Strategic')
                { 
                    listMCPAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'', opp.Name,opp.owner.name,opp.Amount,opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                else*/
                if(opp.Amount >=500000 || opp.Must_Win__c)
                {
                    listMCPAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'',opp.name,opp.owner.name, opp.Amount, opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                if(opp.Amount >=50000 || opp.Must_Win__c)//opp.Account.Account_Type__c == 'Strategic' || 
                {
                    tempAccMCP = opp.Account.name;
                    accIdMCP = opp.AccountId;
                    If(opp.Amount != null)
                        tempAccMCPSum = tempAccMCPSum + opp.Amount;
                    tempAccMCPNA = opp.Account.National_Account__c;
                    tempAccMCPJA = opp.Account.Japanese_Company__c;
                }
            }
            else if(opp.Maps_LOB_Type__c == 'Other' )
            {
                /*            
                If(opp.Account.Account_Type__c == 'Strategic')
                { 
                    listOtherAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'', opp.Name,opp.owner.name,opp.Amount,opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                else */
                if(opp.Amount >=50000 || opp.Must_Win__c)
                {
                    listOtherAccts.add(new MajorAccounts(opp.Maps_LOB_Type__c,'',opp.name,opp.owner.name, opp.Amount, opp.Account.National_Account__c, opp.Account.Japanese_Company__c, opp.AccountId, Opp.Id));
                }
                if(opp.Amount >=50000 || opp.Must_Win__c == true)//opp.Account.Account_Type__c == 'Strategic' || 
                {
	                tempAccOther = opp.Account.name;
	                accIdOther = opp.AccountId;
	                If(opp.Amount != null)
	                    tempAccOtherSum = tempAccOtherSum + opp.Amount;
	                tempAccOtherNA = opp.Account.National_Account__c;
	                tempAccOtherJA = opp.Account.Japanese_Company__c;
                }
            }
        }
        
        
        If(tempAccMA != 'False')
        {
            listMAAcctsTotal.add(new MajorAccounts('MA', tempAccMA, '','',tempAccMASum,tempAccMANA,tempAccMAJA, accIdMA, null));
            listMAAcctsTotal.addAll(listMAAccts);
        }
        If(tempAccSR != 'False')
        {
            listSRAcctsTotal.add(new MajorAccounts('SR', tempAccSR, '','',tempAccSRSum,tempAccSRNA,tempAccSRJA, accIdSR, null));
            listSRAcctsTotal.addAll(listSRAccts);
        }
        If(tempAccTK != 'False')
        {
            listTKAcctsTotal.add(new MajorAccounts('TK', tempAccTK, '','',tempAccTKSum,tempAccTKNA,tempAccTKJA, accIdTK, null));
            listTKAcctsTotal.addAll(listTKAccts);
        }
        If(tempAccRC != 'False')
        {
            listRCAcctsTotal.add(new MajorAccounts('RC', tempAccRC, '','',tempAccRCSum,tempAccRCNA,tempAccRCJA, accIdRC, null));
            listRCAcctsTotal.addAll(listRCAccts);
        }
        If(tempAccMCP != 'False')
        {
            listMCPAcctsTotal.add(new MajorAccounts('MCP', tempAccMCP, '','',tempAccMCPSum,tempAccMCPNA,tempAccMCPJA, accIdMCP, null));
            listMCPAcctsTotal.addAll(listMCPAccts);
        }       
        If(tempAccOther != 'False')
        {
            listOtherAcctsTotal.add(new MajorAccounts('Other', tempAccOther, '','',tempAccOtherSum,tempAccOtherNA,tempAccOtherJA, accIdOther, null));
            listOtherAcctsTotal.addAll(listOtherAccts);
        }
        
        
        majorAcclist.put('MA', listMAAcctsTotal);
        majorAcclist.put('SR', listSRAcctsTotal);
        majorAcclist.put('TK', listTKAcctsTotal);
        majorAcclist.put('Rental Chillers', listRCAcctsTotal);
        majorAcclist.put('MCP', listMCPAcctsTotal);
        majorAcclist.put('Other', listOtherAcctsTotal);
        System.debug('--- LB --- ' + majorAccList);
        return majorAcclist;
    }
        set;
    }
    
     /******************************************************************************************/
    /************************** POPULATE THIRD SECTION TABLE STARTS **************************/
    /******************************************************************************************/
    
    
    /******************************************************************************************/
    /************************** POPULATE THIRD SECTION TABLE ENDS **************************/
    /******************************************************************************************/
    
 public class oppAmtCalc{
      public transient String tableName{get; set;}
      public boolean tableDisplayBool;
      public transient String tableDisplayStr{get;Set;}
      
        public transient String OwnerName{get; set;}
        
        public transient decimal  aprAmt{get; set;}
        public transient decimal  mayAmt{get; set;}
        public transient decimal  junAmt{get; set;}
        public transient decimal  julAmt{get; set;}
        public transient decimal  augAmt{get; set;}
        public transient decimal  sepAmt{get; set;}
        public transient decimal  octAmt{get; set;}
        public transient decimal  novAmt{get; set;}
        public transient decimal  decAmt{get; set;}
        public transient decimal  janAmt{get; set;}
        public transient decimal  febAmt{get; set;}
        public transient decimal  marAmt{get; set;}

        public transient decimal  aprfacAmt{get; set;}
        public transient decimal  mayfacAmt{get; set;}
        public transient decimal  junfacAmt{get; set;}
        public transient decimal  julfacAmt{get; set;}
        public transient decimal  augfacAmt{get; set;}
        public transient decimal  sepfacAmt{get; set;}
        public transient decimal  octfacAmt{get; set;}
        public transient decimal  novfacAmt{get; set;}
        public transient decimal  decfacAmt{get; set;}
        public transient decimal  janfacAmt{get; set;}
        public transient decimal  febfacAmt{get; set;}
        public transient decimal  marfacAmt{get; set;}     
        
        public transient String totOppAmount {get; set;}
        public transient decimal  totOppAmountDec {get; set;}      
        public transient String grandTotOppAmount {get; set;}
        
        public transient String totOppFacAmount {get; set;}
        public transient decimal  totOppFacAmountDec {get; set;}       
        
        public transient decimal  totOppAmountFacTotal2 {get; set;}  

        public transient String pqOppAmount_QuotaTotal2 {get; set;}       
        public transient String pqOppAmount_FacTotal2 {get; set;}         
                
        public transient decimal  aprQuota{get; set;}
        public transient decimal  mayQuota{get; set;}
        public transient decimal  junQuota{get; set;}
        public transient decimal  julQuota{get; set;}
        public transient decimal  augQuota{get; set;}
        public transient decimal  sepQuota{get; set;}
        public transient decimal  octQuota{get; set;}
        public transient decimal  novQuota{get; set;}
        public transient decimal  decQuota{get; set;}
        public transient decimal  janQuota{get; set;}
        public transient decimal  febQuota{get; set;}
        public transient decimal  marQuota{get; set;}
        
        public transient String totQuotaAmt{get; set;}
        
        public transient decimal  totQuotaAmtDec{get; set;}        
        
        public transient decimal  aprAmtPer {get; set;}
        public transient decimal  mayAmtPer {get; set;}
        public transient decimal  junAmtPer {get; set;}
        public transient decimal  julAmtPer {get; set;}
        public transient decimal  augAmtPer {get; set;}
        public transient decimal  sepAmtPer {get; set;}
        public transient decimal  octAmtPer {get; set;}
        public transient decimal  novAmtPer {get; set;}
        public transient decimal  decAmtPer {get; set;}
        public transient decimal  janAmtPer {get; set;}
        public transient decimal  febAmtPer {get; set;}
        public transient decimal  marAmtPer {get; set;}
        
        public transient decimal  pq1 {get; set;}
        public transient decimal  pq2 {get; set;}
        public transient decimal  pq3 {get; set;}
        public transient decimal  pq4 {get; set;}
        public transient decimal  pqAvg {get; set;}
        
        public transient decimal  avgPer {get; set;}

        public transient decimal  pqAmtPerFiscal {get; set;}
        
        public transient decimal  pqAprAmtPer {get; set;}
        public transient decimal  pqMayAmtPer {get; set;}
        public transient decimal  pqJunAmtPer {get; set;}
        public transient decimal  pqJulAmtPer {get; set;}
        public transient decimal  pqAugAmtPer {get; set;}
        public transient decimal  pqSepAmtPer {get; set;}
        public transient decimal  pqOctAmtPer {get; set;}
        public transient decimal  pqNovAmtPer {get; set;}
        public transient decimal  pqDecAmtPer {get; set;}
        public transient decimal  pqJanAmtPer {get; set;}
        public transient decimal  pqFebAmtPer {get; set;}
        public transient decimal  pqMarAmtPer {get; set;}
        
        public transient decimal  pqAmtPerAvg {get; set;}
        
        public transient decimal  pqAprAmtPerRol {get; set;}
        public transient decimal  pqMayAmtPerRol {get; set;}
        public transient decimal  pqJunAmtPerRol {get; set;}
        public transient decimal  pqJulAmtPerRol {get; set;}
        public transient decimal  pqAugAmtPerRol {get; set;}
        public transient decimal  pqSepAmtPerRol {get; set;}
        public transient decimal  pqOctAmtPerRol {get; set;}
        public transient decimal  pqNovAmtPerRol {get; set;}
        public transient decimal  pqDecAmtPerRol {get; set;}
        public transient decimal  pqJanAmtPerRol {get; set;}
        public transient decimal  pqFebAmtPerRol {get; set;}
        public transient decimal  pqMarAmtPerRol {get; set;}
        
        public transient decimal  pqAmtPerAvgRol {get; set;}
        
        //next financial year variables.

        public transient decimal  aprAmt2{get; set;}
        public transient decimal  mayAmt2{get; set;}
        public transient decimal  junAmt2{get; set;}
        public transient decimal  julAmt2{get; set;}
        public transient decimal  augAmt2{get; set;}
        public transient decimal  sepAmt2{get; set;}
        public transient decimal  octAmt2{get; set;}
        public transient decimal  novAmt2{get; set;}
        public transient decimal  decAmt2{get; set;}
        public transient decimal  janAmt2{get; set;}
        public transient decimal  febAmt2{get; set;}
        public transient decimal  marAmt2{get; set;}
        
        public transient decimal  aprfacAmt2{get; set;}
        public transient decimal  mayfacAmt2{get; set;}
        public transient decimal  junfacAmt2{get; set;}
        public transient decimal  julfacAmt2{get; set;}
        public transient decimal  augfacAmt2{get; set;}
        public transient decimal  sepfacAmt2{get; set;}
        public transient decimal  octfacAmt2{get; set;}
        public transient decimal  novfacAmt2{get; set;}
        public transient decimal  decfacAmt2{get; set;}
        public transient decimal  janfacAmt2{get; set;}
        public transient decimal  febfacAmt2{get; set;}
        public transient decimal  marfacAmt2{get; set;}
        
        
        public transient String totOppAmount2 {get; set;}
        
        public transient String totOppFacAmount2 {get; set;}
        public transient decimal  totOppFacAmount2Dec {get; set;}
        
        public transient decimal  aprQuota2{get; set;}
        public transient decimal  mayQuota2{get; set;}
        public transient decimal  junQuota2{get; set;}
        public transient decimal  julQuota2{get; set;}
        public transient decimal  augQuota2{get; set;}
        public transient decimal  sepQuota2{get; set;}
        public transient decimal  octQuota2{get; set;}
        public transient decimal  novQuota2{get; set;}
        public transient decimal  decQuota2{get; set;}
        public transient decimal  janQuota2{get; set;}
        public transient decimal  febQuota2{get; set;}
        public transient decimal  marQuota2{get; set;}
        
        public transient String totQuotaAmt2{get; set;}
        
        public transient decimal  aprAmtPer2 {get; set;}
        public transient decimal  mayAmtPer2 {get; set;}
        public transient decimal  junAmtPer2 {get; set;}
        public transient decimal  julAmtPer2 {get; set;}
        public transient decimal  augAmtPer2 {get; set;}
        public transient decimal  sepAmtPer2 {get; set;}
        public transient decimal  octAmtPer2 {get; set;}
        public transient decimal  novAmtPer2 {get; set;}
        public transient decimal  decAmtPer2 {get; set;}
        public transient decimal  janAmtPer2 {get; set;}
        public transient decimal  febAmtPer2 {get; set;}
        public transient decimal  marAmtPer2 {get; set;}
        
        public transient decimal  pq21 {get; set;}
        public transient decimal  pq22 {get; set;}
        public transient decimal  pq23 {get; set;}
        public transient decimal  pq24 {get; set;}
        public transient decimal  pqAvg2 {get; set;}
        
        public transient decimal  avgPer2 {get; set;}

        public transient decimal  pqAmtPerFiscal2 {get; set;}
        
        public transient decimal  pqAprAmtPer2 {get; set;}
        public transient decimal  pqMayAmtPer2 {get; set;}
        public transient decimal  pqJunAmtPer2 {get; set;}
        public transient decimal  pqJulAmtPer2 {get; set;}
        public transient decimal  pqAugAmtPer2 {get; set;}
        public transient decimal  pqSepAmtPer2 {get; set;}
        public transient decimal  pqOctAmtPer2 {get; set;}
        public transient decimal  pqNovAmtPer2 {get; set;}
        public transient decimal  pqDecAmtPer2 {get; set;}
        public transient decimal  pqJanAmtPer2 {get; set;}
        public transient decimal  pqFebAmtPer2 {get; set;}
        public transient decimal  pqMarAmtPer2 {get; set;}
        
        public transient decimal  pqAmtPerAvg2 {get; set;}
        
        public transient decimal  pqAprAmtPerRol2 {get; set;}
        public transient decimal  pqMayAmtPerRol2 {get; set;}
        public transient decimal  pqJunAmtPerRol2 {get; set;}
        public transient decimal  pqJulAmtPerRol2 {get; set;}
        public transient decimal  pqAugAmtPerRol2 {get; set;}
        public transient decimal  pqSepAmtPerRol2 {get; set;}
        public transient decimal  pqOctAmtPerRol2 {get; set;}
        public transient decimal  pqNovAmtPerRol2 {get; set;}
        public transient decimal  pqDecAmtPerRol2 {get; set;}
        public transient decimal  pqJanAmtPerRol2 {get; set;}
        public transient decimal  pqFebAmtPerRol2 {get; set;}
        public transient decimal  pqMarAmtPerRol2 {get; set;}
        
        public transient decimal  pqAmtPerAvgRol2 {get; set;}
        
        public transient decimal  pqAprAmt12monthRoll {get; set;}
        public transient decimal  pqMayAmt12monthRoll {get; set;}
        public transient decimal  pqJunAmt12monthRoll {get; set;}
        public transient decimal  pqJulAmt12monthRoll {get; set;}
        public transient decimal  pqAugAmt12monthRoll {get; set;}
        public transient decimal  pqSepAmt12monthRoll {get; set;}
        public transient decimal  pqOctAmt12monthRoll {get; set;}
        public transient decimal  pqNovAmt12monthRoll {get; set;}
        public transient decimal  pqDecAmt12monthRoll {get; set;}
        public transient decimal  pqJanAmt12monthRoll {get; set;}
        public transient decimal  pqFebAmt12monthRoll {get; set;}
        public transient decimal  pqMarAmt12monthRoll {get; set;}
        
        public transient String pqMarAmt12monthRollTotal {get; set;}
        public transient String pqMarAmt12monthRollFactored {get; set;}
        
        //variables for grandtotal
        public transient String grandTotQuota{get;set;}
        public transient decimal  grandTotQuotaDec{get;set;}       
        public transient String grandTotQuotaRoll{get;set;}
        public transient String grandTotOpp{get;set;}
        public transient decimal  grandTotOppDec{get;set;}     
        public transient String grandTotRollOpp{get;set;}
        public transient decimal  grandTotRollOppDec{get;set;}     
        public transient String grandTotFac{get;set;}
        public transient decimal  grandTotFacDec{get;set;}     
        public transient String grandTotRollFac{get;set;}
        public transient decimal  grandTotRollFacDec{get;set;}     
        public transient String grandTotPipeQuota{get;set;}
        public transient String grandTotRollPipeQuota{get;set;}
        public transient String grandTotFacPipeQuota{get;set;}
        public transient String grandTotRollFacPipeQuota{get;set;}
        
        public oppAmtCalc(String tableName,  Map<String, decimal> mapAmt,  Map<String, decimal> mapAmtQuota,  Map<String, decimal> mapAmt2,  Map<String, decimal> mapAmtQuota2,  Map<String, decimal> mapFacAmt,  Map<String, decimal> mapFacAmt2, boolean boolAccType, boolean boolGrandSet,boolean boolGrandSet7,String ownername  ){
            this.tableName = tableName;
            this.OwnerName = ownername;
            
            If(tableName != 'TK' && boolAccType)
                this.tableDisplayStr = 'none';
            If(((tableName == 'TK' || boolGrandSet7) && boolAccType) || !(boolAccType))
                this.tableDisplayStr = 'table';

            
            
            //*****calculation for current fiscal year
            if(mapAmt != null && mapAmtQuota != null) {
            
              this.aprAmt = mapAmt.get('aprAmt');
              this.mayAmt = mapAmt.get('mayAmt');
              this.junAmt = mapAmt.get('junAmt');
              this.julAmt = mapAmt.get('julAmt');
              
              this.augAmt = mapAmt.get('augAmt');
              System.debug('totAmt&&&&&&& :'+this.augAmt);            
              this.sepAmt = mapAmt.get('sepAmt');
              this.octAmt = mapAmt.get('octAmt');
              this.novAmt = mapAmt.get('novAmt');
              this.decAmt = mapAmt.get('decAmt');
              this.janAmt = mapAmt.get('janAmt');
              this.febAmt = mapAmt.get('febAmt');
              this.marAmt = mapAmt.get('marAmt');
               
              this.totOppAmount 
              = (mapAmt.get('aprAmt') + mapAmt.get('mayAmt') + mapAmt.get('junAmt') + mapAmt.get('julAmt') + mapAmt.get('augAmt') + mapAmt.get('sepAmt') + mapAmt.get('octAmt') + mapAmt.get('novAmt') + mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt')) + '';
              
              this.totOppAmountDec = decimal.valueOf(this.totOppAmount);
              System.debug('totAmt :'+this.totOppAmount+'    tot grand*****'+grandTotOpp);
              
              this.grandTotOpp = '0';                       
              If(this.totOppAmount != '0' && this.totOppAmount != null )
                this.grandTotOpp = String.valueOf(decimal.valueOf(this.grandTotOpp) + decimal.valueOf(this.totOppAmount));
              System.debug('totAmt :'+this.totOppAmount+'    tot grand*****'+this.grandTotOpp);
                            
              this.aprfacAmt = mapfacAmt.get('aprAmt');
              this.mayfacAmt = mapfacAmt.get('mayAmt');
              this.junfacAmt = mapfacAmt.get('junAmt');
              this.julfacAmt = mapfacAmt.get('julAmt');
              this.augfacAmt = mapfacAmt.get('augAmt');
              this.sepfacAmt = mapfacAmt.get('sepAmt');
              this.octfacAmt = mapfacAmt.get('octAmt');
              this.novfacAmt = mapfacAmt.get('novAmt');
              this.decfacAmt = mapfacAmt.get('decAmt');
              this.janfacAmt = mapfacAmt.get('janAmt');
              this.febfacAmt = mapfacAmt.get('febAmt');
              this.marfacAmt = mapfacAmt.get('marAmt');
               
              this.totOppFacAmount 
              = (mapfacAmt.get('aprAmt') + mapfacAmt.get('mayAmt') + mapfacAmt.get('junAmt') + mapfacAmt.get('julAmt') + mapfacAmt.get('augAmt') + mapfacAmt.get('sepAmt') + mapfacAmt.get('octAmt') + mapfacAmt.get('novAmt') + mapfacAmt.get('decAmt') + mapfacAmt.get('janAmt') + mapfacAmt.get('febAmt') + mapfacAmt.get('marAmt')) + '';
              
              this.totOppFacAmountDec = decimal.valueOf(this.totOppFacAmount);
              this.grandTotFac = '0';                       
              If(this.totOppFacAmount != '0' && this.totOppFacAmount != null )
                this.grandTotFac = String.valueOf(decimal.valueOf(this.grandTotFac) + decimal.valueOf(this.totOppFacAmount));
              System.debug('totAmt :'+this.totOppFacAmount+'    tot grand*****'+this.grandTotFac);                      
              
              this.aprQuota = mapAmtQuota.get('aprQuota');
              this.mayQuota = mapAmtQuota.get('mayQuota');
              this.junQuota = mapAmtQuota.get('junQuota');
              this.julQuota = mapAmtQuota.get('julQuota');
              this.augQuota = mapAmtQuota.get('augQuota');
              this.sepQuota = mapAmtQuota.get('sepQuota');
              this.octQuota = mapAmtQuota.get('octQuota');
              this.novQuota = mapAmtQuota.get('novQuota');
              this.decQuota = mapAmtQuota.get('decQuota');
              this.janQuota = mapAmtQuota.get('janQuota');
              this.febQuota = mapAmtQuota.get('febQuota');
              this.marQuota = mapAmtQuota.get('marQuota');
        
              this.totQuotaAmt = mapAmtQuota.get('aprQuota') + mapAmtQuota.get('mayQuota') + mapAmtQuota.get('junQuota') + mapAmtQuota.get('julQuota') + mapAmtQuota.get('augQuota') + mapAmtQuota.get('sepQuota') + mapAmtQuota.get('octQuota') + mapAmtQuota.get('novQuota') + mapAmtQuota.get('decQuota') + mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + '';
              
              this.totQuotaAmtDec = decimal.valueOf(this.totQuotaAmt);
              
              this.grandTotQuota = '0';                         
              If(this.totQuotaAmt != '0' && this.totQuotaAmt != null )
                this.grandTotQuota = String.valueOf(decimal.valueOf(this.grandTotQuota) + decimal.valueOf(this.totQuotaAmt));
              System.debug('toquotatAmt :'+this.totQuotaAmt+'    tot grandquota*****'+this.grandTotQuota);            

              If(Decimal.valueOf(this.totQuotaAmt) != 0)
                this.pqOppAmount_QuotaTotal2 = String.valueOf((Decimal.valueOf(this.totOppAmount)/Decimal.valueOf(this.totQuotaAmt)*100).setScale(0, RoundingMode.HALF_UP));
              If(Decimal.valueOf(this.totQuotaAmt) != 0)
                this.pqOppAmount_FacTotal2 = String.valueOf((Decimal.valueOf(this.totOppFacAmount)/Decimal.valueOf(this.totQuotaAmt)*100).setScale(0, RoundingMode.HALF_UP));
              
              if(mapAmt.get('aprAmt') != 0 && mapAmtQuota.get('aprQuota') > 0)
                this.aprAmtPer = ((mapAmt.get('aprAmt')/mapAmtQuota.get('aprQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.aprAmtPer = 0;
              
              if(mapAmt.get('mayAmt') != 0 && mapAmtQuota.get('mayQuota') > 0)
                this.mayAmtPer = ((mapAmt.get('mayAmt')/mapAmtQuota.get('mayQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.mayAmtPer = 0;
              
              if(mapAmt.get('junAmt') != 0 && mapAmtQuota.get('junQuota') > 0)
                this.junAmtPer = ((mapAmt.get('junAmt')/mapAmtQuota.get('junQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.junAmtPer = 0;
              
              if(mapAmt.get('julAmt') != 0 && mapAmtQuota.get('julQuota') > 0)
                this.julAmtPer = ((mapAmt.get('julAmt')/mapAmtQuota.get('julQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.julAmtPer = 0;
              
              if(mapAmt.get('augAmt') != 0 && mapAmtQuota.get('augQuota') > 0)
                this.augAmtPer = ((mapAmt.get('augAmt')/mapAmtQuota.get('augQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.augAmtPer = 0;
              
              if(mapAmt.get('sepAmt') != 0 && mapAmtQuota.get('sepQuota') > 0)
                this.sepAmtPer = ((mapAmt.get('sepAmt')/mapAmtQuota.get('sepQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.sepAmtPer = 0;
              
              if(mapAmt.get('octAmt') != 0 && mapAmtQuota.get('octQuota') > 0)
                this.octAmtPer = ((mapAmt.get('octAmt')/mapAmtQuota.get('octQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.octAmtPer = 0;
              
              if(mapAmt.get('novAmt') != 0 && mapAmtQuota.get('novQuota') > 0)
                this.novAmtPer = ((mapAmt.get('novAmt')/mapAmtQuota.get('novQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.novAmtPer = 0;
              
              if(mapAmt.get('decAmt') != 0 && mapAmtQuota.get('decQuota') > 0)
                this.decAmtPer = ((mapAmt.get('decAmt')/mapAmtQuota.get('decQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.decAmtPer = 0;
              
              if(mapAmt.get('janAmt') != 0 && mapAmtQuota.get('janQuota') > 0)
                this.janAmtPer = ((mapAmt.get('janAmt')/mapAmtQuota.get('janQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.janAmtPer = 0;
              
              if(mapAmt.get('febAmt') != 0 && mapAmtQuota.get('febQuota') > 0)
                this.febAmtPer = ((mapAmt.get('febAmt')/mapAmtQuota.get('febQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.febAmtPer = 0;
              
              if(mapAmt.get('marAmt') != 0 && mapAmtQuota.get('marQuota') > 0)
                this.marAmtPer = ((mapAmt.get('marAmt')/mapAmtQuota.get('marQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.marAmtPer = 0;
              
              decimal totSum = (this.aprAmtPer + this.mayAmtPer + this.junAmtPer + this.julAmtPer + this.augAmtPer + this.sepAmtPer + this.octAmtPer + this.novAmtPer + this.decAmtPer + this.janAmtPer + this.febAmtPer + this.marAmtPer);
              
              if(totSum > 0)
                this.avgPer =  (totSum/12).setScale(0, RoundingMode.HALF_UP);
              else  this.avgPer = 0;
              
              //Pipe/Quota Ratio 12 Month
              this.pqAmtPerFiscal = 0;
              If(Decimal.valueOf(this.totQuotaAmt) != 0 && this.totQuotaAmt != null)
                this.pqAmtPerFiscal = ((Decimal.valueOf(this.totOppAmount)/Decimal.valueOf(this.totQuotaAmt)) * 100).setScale(0, RoundingMode.HALF_UP);
              /*********************************************************************************************************************************************************************************************************************************/
              
              if(mapAmtQuota.get('aprQuota') > 0 || mapAmtQuota.get('mayQuota') > 0 || mapAmtQuota.get('junQuota') > 0)
                this.pq1 = (((this.aprAmt + this.mayAmt + this.junAmt)/(mapAmtQuota.get('aprQuota') + mapAmtQuota.get('mayQuota') + mapAmtQuota.get('junQuota'))) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.pq1 = 0;
              
              if(mapAmtQuota.get('julQuota') > 0 || mapAmtQuota.get('augQuota') > 0 || mapAmtQuota.get('sepQuota') > 0)
                this.pq2 = (((this.julAmt + this.augAmt + this.sepAmt)/(mapAmtQuota.get('julQuota') + mapAmtQuota.get('augQuota') + mapAmtQuota.get('sepQuota'))) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.pq2 = 0;
              
              if(mapAmtQuota.get('octQuota') > 0 || mapAmtQuota.get('novQuota') > 0 || mapAmtQuota.get('decQuota') > 0)
                this.pq3 = (((this.octAmt + this.novAmt + this.decAmt)/(mapAmtQuota.get('octQuota') + mapAmtQuota.get('novQuota') + mapAmtQuota.get('decQuota'))) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.pq3 = 0;
              
              if(mapAmtQuota.get('janQuota') > 0 || mapAmtQuota.get('febQuota') > 0 || mapAmtQuota.get('marQuota') > 0)
                this.pq4 = (((this.janAmt + this.febAmt + this.marAmt)/(mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota'))) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.pq4 = 0;
              
              this.pqAvg = ((this.pq1 + this.pq2 + this.pq3 + this.pq4)/4).setScale(0, RoundingMode.HALF_UP);
              
              /********************************************************************************************************************************************************************************************************/
              
              if(this.aprQuota > 0)
                this.pqAprAmtPer = ((this.aprAmt + this.mayAmt + this.junAmt)/(this.aprQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqAprAmtPer = 0;
              
              if(this.mayQuota > 0)
                this.pqMayAmtPer = ((this.mayAmt + this.junAmt + this.julAmt)/(this.mayQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqMayAmtPer = 0;
              
              if(this.junQuota > 0)
                this.pqJunAmtPer = ((this.junAmt + this.julAmt + this.augAmt)/(this.junQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJunAmtPer = 0;
              
              if(this.julQuota > 0)
                this.pqJulAmtPer = ((this.julAmt + this.augAmt + this.sepAmt)/(this.julQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJulAmtPer = 0;
              
              if(this.augQuota > 0)
                this.pqAugAmtPer = ((this.augAmt + this.sepAmt + this.octAmt)/(this.augQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqAugAmtPer = 0;
              
              if(this.sepQuota > 0)
                this.pqSepAmtPer = ((this.sepAmt + this.octAmt + this.novAmt)/(this.sepQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqSepAmtPer = 0;
              
              if(this.octQuota > 0)
                this.pqOctAmtPer = ((this.octAmt + this.novAmt + this.decAmt)/(this.octQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqOctAmtPer = 0;
              
              if(this.novQuota > 0)
                this.pqNovAmtPer = ((this.novAmt + this.decAmt + this.janAmt)/(this.novQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqNovAmtPer = 0;
              
              if(this.decQuota > 0)
                this.pqDecAmtPer = ((this.decAmt + this.janAmt + this.febAmt)/(this.decQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqDecAmtPer = 0;
              
              if(this.janQuota > 0)
                this.pqJanAmtPer = ((this.janAmt + this.febAmt + this.marAmt)/(this.janQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJanAmtPer = 0;
              
              if(this.febQuota > 0)
                this.pqFebAmtPer = ((this.febAmt + this.marAmt + this.aprAmt)/(this.febQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqFebAmtPer = 0;
              
              if(this.marQuota > 0)
                this.pqMarAmtPer = ((this.marAmt + this.aprAmt + this.mayAmt)/(this.marQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqMarAmtPer = 0;
              
              If(decimal.valueOf(this.totQuotaAmt) > 0)
                this.pqAmtPerAvg = ((Decimal.valueOf(this.totOppAmount)/Decimal.valueOf(this.totQuotaAmt))*100).setScale(0, RoundingMode.HALF_UP);
              else
                    this.pqAmtPerAvg =0;
              
              /**********************************************************************************************************************************************************************************************************************************************************************************************************/
              
              if(this.aprQuota > 0 || this.mayQuota > 0 || this.junQuota > 0)
                this.pqAprAmtPerRol = ((this.aprAmt + this.mayAmt + this.junAmt)/(this.aprQuota + this.mayQuota + this.junQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqAprAmtPerRol = 0;
              
              if(this.mayQuota > 0 || this.junQuota > 0 || this.julQuota > 0)
                this.pqMayAmtPerRol = ((this.mayAmt + this.junAmt + this.julAmt)/(this.mayQuota + this.junQuota + this.julQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqMayAmtPerRol = 0;
              
              if(this.junQuota > 0 || this.julQuota > 0 || this.augQuota > 0)
                this.pqJunAmtPerRol = ((this.junAmt + this.julAmt + this.augAmt)/(this.junQuota + this.julQuota + this.augQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJunAmtPerRol = 0;
              
              if(this.julQuota > 0 || this.augQuota > 0 || this.sepQuota > 0)
                this.pqJulAmtPerRol = ((this.julAmt + this.augAmt + this.sepAmt)/(this.julQuota + this.augQuota + this.sepQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJulAmtPerRol = 0;
              
              if(this.augQuota > 0 || this.sepQuota > 0 || this.octQuota > 0)
                this.pqAugAmtPerRol = ((this.augAmt + this.sepAmt + this.octAmt)/(this.augQuota + this.sepQuota + this.octQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqAugAmtPerRol = 0;
              
              if(this.sepQuota > 0 || this.octQuota > 0 || this.novQuota > 0)
                this.pqSepAmtPerRol = ((this.sepAmt + this.octAmt + this.novAmt)/(this.sepQuota + this.octQuota + this.novQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqSepAmtPerRol = 0;
              
              if(this.octQuota > 0 || this.novQuota > 0 || this.decQuota > 0)
                this.pqOctAmtPerRol = ((this.octAmt + this.novAmt + this.decAmt)/(this.octQuota + this.novQuota + this.decQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqOctAmtPerRol = 0;
              
              if(this.novQuota > 0 || this.decQuota > 0 || this.janQuota > 0)
                this.pqNovAmtPerRol = ((this.novAmt + this.decAmt + this.janAmt)/(this.novQuota + this.decQuota + this.janQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqNovAmtPerRol = 0;
              
              if(this.decQuota > 0 || this.janQuota > 0 || this.febQuota > 0)
                this.pqDecAmtPerRol = ((this.decAmt + this.janAmt + this.febAmt)/(this.decQuota + this.janQuota + this.febQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqDecAmtPerRol = 0;
              
              if(this.janQuota > 0 || this.febQuota > 0 || this.marQuota > 0)
                this.pqJanAmtPerRol = ((this.janAmt + this.febAmt + this.marAmt)/(this.janQuota + this.febQuota + this.marQuota) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJanAmtPerRol = 0;
              
              //::NS:: these two stradle the fiscal year so this must be dynamic
              
              if(this.febQuota > 0 || this.marQuota > 0 || mapAmtQuota2.get('aprQuota') > 0)
                this.pqFebAmtPerRol = ((this.febAmt + this.marAmt + mapAmt2.get('aprAmt'))/(this.febQuota + this.marQuota + mapAmtQuota2.get('aprQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqFebAmtPerRol = 0;
              
              if(this.marQuota > 0 || mapAmtQuota2.get('aprQuota') > 0 || mapAmtQuota2.get('mayQuota') > 0)
                this.pqMarAmtPerRol = ((this.marAmt + mapAmt2.get('aprAmt') + mapAmt2.get('mayAmt'))/(this.marQuota + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqMarAmtPerRol = 0;
              
              this.pqAmtPerAvgRol = ((this.pqAprAmtPerRol + this.pqMayAmtPerRol + this.pqJunAmtPerRol + this.pqJulAmtPerRol + this.pqAugAmtPerRol + this.pqSepAmtPerRol + this.pqOctAmtPerRol + this.pqNovAmtPerRol + this.pqDecAmtPerRol + this.pqJanAmtPerRol + this.pqFebAmtPerRol + this.pqMarAmtPerRol)/12).setScale(0, RoundingMode.HALF_UP);
              
            }//if
 

            //****calculation next fiscal year
            if(mapAmt2 != null && mapAmtQuota2 != null) {
            
              this.aprAmt2 = mapAmt2.get('aprAmt');
              this.mayAmt2 = mapAmt2.get('mayAmt');
              this.junAmt2 = mapAmt2.get('junAmt');
              this.julAmt2 = mapAmt2.get('julAmt');
              this.augAmt2 = mapAmt2.get('augAmt');
              this.sepAmt2 = mapAmt2.get('sepAmt');
              this.octAmt2 = mapAmt2.get('octAmt');
              this.novAmt2 = mapAmt2.get('novAmt');
              this.decAmt2 = mapAmt2.get('decAmt');
              this.janAmt2 = mapAmt2.get('janAmt');
              this.febAmt2 = mapAmt2.get('febAmt');
              this.marAmt2 = mapAmt2.get('marAmt');
               
              this.totOppAmount2 
              = (mapAmt2.get('aprAmt') + mapAmt2.get('mayAmt') + mapAmt2.get('junAmt') + mapAmt2.get('julAmt') + mapAmt2.get('augAmt') 
               + mapAmt2.get('sepAmt') + mapAmt2.get('octAmt') + mapAmt2.get('novAmt') + mapAmt2.get('decAmt') + mapAmt2.get('janAmt') 
               + mapAmt2.get('febAmt') + mapAmt2.get('marAmt')) + '';
/********              
              If(this.totOppAmount2 != '0' && this.totOppAmount2 != null )
                this.grandTotOpp = String.valueOf(decimal.valueOf(this.grandTotOpp) + decimal.valueOf(this.totOppAmount2));
                
              System.debug('totAmt :'+this.totOppAmount+'    tot grand*****'+this.grandTotOpp);
*****/
              
              //this field is related to total value for "rolling 12 months"section for conditional table.
              //::NS:: Needs to be the pipeline for this month and the next 11.
              this.totOppAmountFacTotal2= 0;
              Date rollingDate = Date.newInstance(System.today().year(), System.today().month(), 1);
              for(Integer x=1; x < 13; x++)
              {
              	    //dateSumStr ='-'+dateSumStr+'-'+rollingDate.format();
              	    Integer month = rollingDate.month();
              	    if((((rollingDate >= Date.newInstance(Date.Today().addYears(1).year(),4,1) 
                             && rollingDate <= Date.newInstance(Date.Today().addYears(2).year(),3,31)) 
                             && (Date.Today().month() > 3)) 
                          || (rollingDate.year() ==  Date.Today().year() 
                              && (rollingDate >= Date.newInstance(Date.Today().year(),4,1) 
                                 && rollingDate <= Date.newInstance(Date.Today().addYears(1).year(),3,31) )//always true given that rollingDate.year() ==  Date.Today().year()
                             ) 
                          )
                      )
                    {
              	    	totOppAmountFacTotal2 += (mapAmt2.get(getDateMapString(month)) ); 
                    }
                    else if(rollingDate.year() == System.today().year())
                    	totOppAmountFacTotal2 += (mapAmt.get(getDateMapString(month))  );
              		
              		rollingDate = rollingDate.addMonths(1);
              		
              }
             /* = (mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt') 
               + mapAmt2.get('mayAmt') + mapAmt2.get('junAmt') + mapAmt2.get('julAmt') + mapAmt2.get('augAmt') + mapAmt2.get('sepAmt') 
               + mapAmt2.get('octAmt') + mapAmt2.get('novAmt'));*/
              
              this.grandTotRollOpp = '0';                       
              If(this.totOppAmountFacTotal2 != 0 && this.totOppAmountFacTotal2 != null )
                this.grandTotRollOpp = String.valueOf(decimal.valueOf(this.grandTotRollOpp) + this.totOppAmountFacTotal2);
              System.debug('totAmt :'+this.totOppAmountFacTotal2+'    tot grand*****'+this.grandTotRollOpp);                        
              
              this.aprfacAmt2 = mapfacAmt2.get('aprAmt');
              this.mayfacAmt2 = mapfacAmt2.get('mayAmt');
              this.junfacAmt2 = mapfacAmt2.get('junAmt');
              this.julfacAmt2 = mapfacAmt2.get('julAmt');
              this.augfacAmt2 = mapfacAmt2.get('augAmt');
              this.sepfacAmt2 = mapfacAmt2.get('sepAmt');
              this.octfacAmt2 = mapfacAmt2.get('octAmt');
              this.novfacAmt2 = mapfacAmt2.get('novAmt');
              this.decfacAmt2 = mapfacAmt2.get('decAmt');
              this.janfacAmt2 = mapfacAmt2.get('janAmt');
              this.febfacAmt2 = mapfacAmt2.get('febAmt');
              this.marfacAmt2 = mapfacAmt2.get('marAmt');
              
              //::NS:: Not a rolling amount. Should be this month plus the next 11 months 
              
              /*= (mapfacAmt.get('decAmt') + mapfacAmt.get('janAmt') + mapfacAmt.get('febAmt') 
                + mapfacAmt.get('marAmt') + mapfacAmt2.get('aprAmt') + mapfacAmt2.get('mayAmt') + mapfacAmt2.get('junAmt') 
                + mapfacAmt2.get('julAmt') + mapfacAmt2.get('augAmt') + mapfacAmt2.get('sepAmt') + mapfacAmt2.get('octAmt') 
                + mapfacAmt2.get('novAmt')) + ''; */
                
              Double totOppFacAmountDouble = 0;
              rollingDate = Date.newInstance(System.today().year(), System.today().month(), 1);//curFiscalDate;
              for(Integer x=1; x < 12; x++)
              {
              	    Integer month = rollingDate.month();
              	    if((((rollingDate >= Date.newInstance(Date.Today().addYears(1).year(),4,1) 
                             && rollingDate <= Date.newInstance(Date.Today().addYears(2).year(),3,31)) 
                             && (Date.Today().month() > 3)) 
                          || (rollingDate.year() ==  Date.Today().year() 
                              && (rollingDate >= Date.newInstance(Date.Today().year(),4,1) 
                                 && rollingDate <= Date.newInstance(Date.Today().addYears(1).year(),3,31) )//always true given that rollingDate.year() ==  Date.Today().year()
                             ) 
                          )
                      )
                    {
              	    	totOppFacAmountDouble += (mapfacAmt2.get(getDateMapString(month)) == null ? 0 : mapfacAmt2.get(getDateMapString(month)) );
                    }
              		else if(rollingDate.year() == System.today().year())
              			totOppFacAmountDouble += (mapfacAmt.get(getDateMapString(month)) == null ? 0 : mapfacAmt.get(getDateMapString(month)) );
              		
              		rollingDate = rollingDate.addMonths(1);
              		
              		
              }
			  this.totOppFacAmount2 = totOppFacAmountDouble + '';
              this.totOppFacAmount2Dec = decimal.valueOf(this.totOppFacAmount2);
              this.grandTotRollFac = '0';                       
              If(this.totOppfacAmount2 != '0' && this.totOppfacAmount2 != null )
                this.grandTotRollFac = String.valueOf(decimal.valueOf(this.grandTotRollFac) + decimal.valueOf(this.totOppfacAmount2));
              System.debug('totAmt :'+this.totOppfacAmount2+'    tot grand*****'+this.grandTotRollFac);           
              
              this.aprQuota2 = mapAmtQuota2.get('aprQuota');
              this.mayQuota2 = mapAmtQuota2.get('mayQuota');
              this.junQuota2 = mapAmtQuota2.get('junQuota');
              this.julQuota2 = mapAmtQuota2.get('julQuota');
              this.augQuota2 = mapAmtQuota2.get('augQuota');
              this.sepQuota2 = mapAmtQuota2.get('sepQuota');
              this.octQuota2 = mapAmtQuota2.get('octQuota');
              this.novQuota2 = mapAmtQuota2.get('novQuota');
              this.decQuota2 = mapAmtQuota2.get('decQuota');
              this.janQuota2 = mapAmtQuota2.get('janQuota');
              this.febQuota2 = mapAmtQuota2.get('febQuota');
              this.marQuota2 = mapAmtQuota2.get('marQuota');
        
              this.totQuotaAmt2 = mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota') + mapAmtQuota2.get('julQuota') + mapAmtQuota2.get('augQuota') + mapAmtQuota2.get('sepQuota') + mapAmtQuota2.get('octQuota') + mapAmtQuota2.get('novQuota') + mapAmtQuota2.get('decQuota') + mapAmtQuota2.get('janQuota') + mapAmtQuota2.get('febQuota') + mapAmtQuota2.get('marQuota') + '';
              
              if(mapAmt2.get('aprAmt') != 0 && mapAmtQuota2.get('aprQuota') > 0)
                this.aprAmtPer2 = ((mapAmt2.get('aprAmt')/mapAmtQuota2.get('aprQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.aprAmtPer2 = 0;
                                                          

              If(boolAccType)
              {
                If(PageMapsPlanningQuotaController.grandTotOppPage == null || boolGrandSet)
                {
                    PageMapsPlanningQuotaController.grandTotOppPage = '0';
                }
                PageMapsPlanningQuotaController.grandTotOppPage = String.valueOf(decimal.valueOf(PageMapsPlanningQuotaController.grandTotOppPage) + decimal.valueOf(this.grandTotOpp));
                this.grandTotOpp = PageMapsPlanningQuotaController.grandTotOppPage;
                System.debug('grand total for all :'+this.grandTotOpp + ' PageMapsPlanningQuotaController.grandTotOppPage :'+PageMapsPlanningQuotaController.grandTotOppPage);
                
                If(PageMapsPlanningQuotaController.grandTotQuotaPage == null || boolGrandSet)
                {
                    PageMapsPlanningQuotaController.grandTotQuotaPage = '0';
                }
                PageMapsPlanningQuotaController.grandTotQuotaPage = String.valueOf(decimal.valueOf(PageMapsPlanningQuotaController.grandTotQuotaPage) + decimal.valueOf(this.grandTotQuota));
                this.grandTotQuota = PageMapsPlanningQuotaController.grandTotQuotaPage;
                System.debug('grand total for all :'+this.grandTotQuota + ' PageMapsPlanningQuotaController.grandTotQuotaPage :'+PageMapsPlanningQuotaController.grandTotQuotaPage);
                
                If(PageMapsPlanningQuotaController.grandTotOppRollPage == null || boolGrandSet)
                {
                    PageMapsPlanningQuotaController.grandTotOppRollPage = '0';
                }
                PageMapsPlanningQuotaController.grandTotOppRollPage = String.valueOf(decimal.valueOf(PageMapsPlanningQuotaController.grandTotOppRollPage) + decimal.valueOf(this.grandTotRollOpp));
                this.grandTotRollOpp = PageMapsPlanningQuotaController.grandTotOppRollPage;
                System.debug('grand total for all :'+this.grandTotRollOpp + ' PageMapsPlanningQuotaController.grandTotOppRollPage :'+PageMapsPlanningQuotaController.grandTotOppRollPage);

                If(PageMapsPlanningQuotaController.grandTotFacPage == null || boolGrandSet)
                {
                    PageMapsPlanningQuotaController.grandTotFacPage = '0';
                }
                PageMapsPlanningQuotaController.grandTotFacPage = String.valueOf(decimal.valueOf(PageMapsPlanningQuotaController.grandTotFacPage) + decimal.valueOf(this.grandTotFac));
                this.grandTotFac = PageMapsPlanningQuotaController.grandTotFacPage;
                System.debug('grand total for all :'+this.grandTotFac + ' PageMapsPlanningQuotaController.grandTotFacPage :'+PageMapsPlanningQuotaController.grandTotFacPage);
                
                If(PageMapsPlanningQuotaController.grandTotFacRollPage == null || boolGrandSet)
                {
                    PageMapsPlanningQuotaController.grandTotFacRollPage = '0';
                }
                PageMapsPlanningQuotaController.grandTotFacRollPage = String.valueOf(decimal.valueOf(PageMapsPlanningQuotaController.grandTotFacRollPage) + decimal.valueOf(this.grandTotRollFac));
                this.grandTotRollFac = PageMapsPlanningQuotaController.grandTotFacRollPage;
                System.debug('grand total for all :'+this.grandTotRollFac + ' PageMapsPlanningQuotaController.grandTotFacRollPage :'+PageMapsPlanningQuotaController.grandTotFacRollPage);
                
              }
                
                this.grandTotQuotaDec = decimal.valueOf(this.grandTotQuota);
                this.grandTotOppDec = decimal.valueOf(this.grandTotOpp);
                this.grandTotRollOppDec = decimal.valueOf(this.grandTotRollOpp);                
                this.grandTotFacDec = decimal.valueOf(this.grandTotFac);
                this.grandTotRollFacDec = decimal.valueOf(this.grandTotRollFac);
                
                //To calculate Grand Total row "Total Pipe/Quota Ratio" and Grand Total row "Total Factored Pipe/Quote Ratio"
                If(decimal.valueOf(this.grandTotQuota) !=  0  && decimal.valueOf(this.grandTotQuota) != null )
                {
                    this.grandTotPipeQuota = String.valueOf(((decimal.valueOf(this.grandTotOpp)/decimal.valueOf(this.grandTotQuota))*100).setScale(0, RoundingMode.HALF_UP));
                    this.grandTotRollPipeQuota = String.valueOf(((decimal.valueOf(this.grandTotRollOpp)/decimal.valueOf(this.grandTotQuota))*100).setScale(0, RoundingMode.HALF_UP));
                    this.grandTotFacPipeQuota = String.valueOf(((decimal.valueOf(this.grandTotFac)/decimal.valueOf(this.grandTotQuota))*100).setScale(0, RoundingMode.HALF_UP));
                    this.grandTotRollFacPipeQuota = String.valueOf(((decimal.valueOf(this.grandTotRollFac)/decimal.valueOf(this.grandTotQuota))*100).setScale(0, RoundingMode.HALF_UP));
                    
                }else
                {
                    this.grandTotPipeQuota = '0';
                    this.grandTotRollPipeQuota = '0';
                    this.grandTotFacPipeQuota = '0';
                    this.grandTotRollFacPipeQuota = '0';
                    
                }     
                                              
              
              if(mapAmt2.get('mayAmt') != 0 && mapAmtQuota2.get('mayQuota') > 0)
                this.mayAmtPer2 = ((mapAmt2.get('mayAmt')/mapAmtQuota2.get('mayQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.mayAmtPer2 = 0;
              
              if(mapAmt2.get('junAmt') != 0 && mapAmtQuota2.get('junQuota') > 0)
                this.junAmtPer2 = ((mapAmt2.get('junAmt')/mapAmtQuota2.get('junQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.junAmtPer2 = 0;
              
              if(mapAmt2.get('julAmt') != 0 && mapAmtQuota2.get('julQuota') > 0)
                this.julAmtPer2 = ((mapAmt2.get('julAmt')/mapAmtQuota2.get('julQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.julAmtPer2 = 0;
              
              if(mapAmt2.get('augAmt') != 0 && mapAmtQuota2.get('augQuota') > 0)
                this.augAmtPer2 = ((mapAmt2.get('augAmt')/mapAmtQuota2.get('augQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.augAmtPer2 = 0;
              
              if(mapAmt2.get('sepAmt') != 0 && mapAmtQuota2.get('sepQuota') > 0)
                this.sepAmtPer2 = ((mapAmt2.get('sepAmt')/mapAmtQuota2.get('sepQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.sepAmtPer2 = 0;
              
              if(mapAmt2.get('octAmt') != 0 && mapAmtQuota2.get('octQuota') > 0)
                this.octAmtPer2 = ((mapAmt2.get('octAmt')/mapAmtQuota2.get('octQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.octAmtPer2 = 0;
              
              if(mapAmt2.get('novAmt') != 0 && mapAmtQuota2.get('novQuota') > 0)
                this.novAmtPer2 = ((mapAmt2.get('novAmt')/mapAmtQuota2.get('novQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.novAmtPer2 = 0;
              
              if(mapAmt2.get('decAmt') != 0 && mapAmtQuota2.get('decQuota') > 0)
                this.decAmtPer2 = ((mapAmt2.get('decAmt')/mapAmtQuota2.get('decQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.decAmtPer2 = 0;
              
              if(mapAmt2.get('janAmt') != 0 && mapAmtQuota2.get('janQuota') > 0)
                this.janAmtPer2 = ((mapAmt2.get('janAmt')/mapAmtQuota2.get('janQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.janAmtPer2 = 0;
              
              if(mapAmt2.get('febAmt') != 0 && mapAmtQuota2.get('febQuota') > 0)
                this.febAmtPer2 = ((mapAmt2.get('febAmt')/mapAmtQuota2.get('febQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.febAmtPer2 = 0;
              
              if(mapAmt2.get('marAmt') != 0 && mapAmtQuota2.get('marQuota') > 0)
                this.marAmtPer2 = ((mapAmt2.get('marAmt')/mapAmtQuota2.get('marQuota')) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.marAmtPer2 = 0;
              
              decimal totSum2 = (this.aprAmtPer2 + this.mayAmtPer2 + this.junAmtPer2 + this.julAmtPer2 + this.augAmtPer2 + this.sepAmtPer2 + this.octAmtPer2 + this.novAmtPer2 + this.decAmtPer2 + this.janAmtPer2 + this.febAmtPer2 + this.marAmtPer2);
              
              if(totSum2 > 0)
                this.avgPer2 =  (totSum2/12).setScale(0, RoundingMode.HALF_UP);
              else  this.avgPer2 = 0;
              
              //Pipe/Quota Ratio 12 Month
              If(Decimal.valueOf(this.totQuotaAmt2) > 0)
                this.pqAmtPerFiscal2 = ((Decimal.valueOf(this.totOppAmount2)/Decimal.valueOf(this.totQuotaAmt2)) * 100).setScale(0, RoundingMode.HALF_UP);
              else
                this.pqAmtPerFiscal2 = 0;  
              /*********************************************************************************************************************************************************************************************************************************/
              
              if(mapAmtQuota2.get('aprQuota') > 0 || mapAmtQuota2.get('mayQuota') > 0 || mapAmtQuota2.get('junQuota') > 0)
                this.pq21 = (((this.aprAmt2 + this.mayAmt2 + this.junAmt2)/(mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota'))) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.pq21 = 0;
              
              if(mapAmtQuota2.get('julQuota') > 0 || mapAmtQuota2.get('augQuota') > 0 || mapAmtQuota2.get('sepQuota') > 0)
                this.pq22 = (((this.julAmt2 + this.augAmt2 + this.sepAmt2)/(mapAmtQuota2.get('julQuota') + mapAmtQuota2.get('augQuota') + mapAmtQuota2.get('sepQuota'))) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.pq22 = 0;
              
              if(mapAmtQuota2.get('octQuota') > 0 || mapAmtQuota2.get('novQuota') > 0 || mapAmtQuota2.get('decQuota') > 0)
                this.pq23 = (((this.octAmt2 + this.novAmt2 + this.decAmt2)/(mapAmtQuota2.get('octQuota') + mapAmtQuota2.get('novQuota') + mapAmtQuota2.get('decQuota'))) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.pq23 = 0;
              
              if(mapAmtQuota2.get('janQuota') > 0 || mapAmtQuota2.get('febQuota') > 0 || mapAmtQuota2.get('marQuota') > 0)
                this.pq24 = (((this.janAmt2 + this.febAmt2 + this.marAmt2)/(mapAmtQuota2.get('janQuota') + mapAmtQuota2.get('febQuota') + mapAmtQuota2.get('marQuota'))) * 100).setScale(0, RoundingMode.HALF_UP);
              else  this.pq24 = 0;
              
              this.pqAvg2 = ((this.pq21 + this.pq22 + this.pq23 + this.pq24)/4).setScale(0, RoundingMode.HALF_UP);
              
              /********************************************************************************************************************************************************************************************************/
              
              if(this.aprQuota2 > 0)
                this.pqAprAmtPer2 = ((this.aprAmt2 + this.mayAmt2 + this.junAmt2)/(this.aprQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqAprAmtPer2 = 0;
              
              if(this.mayQuota2 > 0)
                this.pqMayAmtPer2 = ((this.mayAmt2 + this.junAmt2 + this.julAmt2)/(this.mayQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqMayAmtPer2 = 0;
              
              if(this.junQuota2 > 0)
                this.pqJunAmtPer2 = ((this.junAmt2 + this.julAmt2 + this.augAmt2)/(this.junQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJunAmtPer2 = 0;
              
              if(this.julQuota2 > 0)
                this.pqJulAmtPer2 = ((this.julAmt2 + this.augAmt2 + this.sepAmt2)/(this.julQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJulAmtPer2 = 0;
              
              if(this.augQuota2 > 0)
                this.pqAugAmtPer2 = ((this.augAmt2 + this.sepAmt2 + this.octAmt2)/(this.augQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqAugAmtPer2 = 0;
              
              if(this.sepQuota2 > 0)
                this.pqSepAmtPer2 = ((this.sepAmt2 + this.octAmt2 + this.novAmt2)/(this.sepQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqSepAmtPer2 = 0;
              
              if(this.octQuota2 > 0)
                this.pqOctAmtPer2 = ((this.octAmt2 + this.novAmt2 + this.decAmt2)/(this.octQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqOctAmtPer2 = 0;
              
              if(this.novQuota2 > 0)
                this.pqNovAmtPer2 = ((this.novAmt2 + this.decAmt2 + this.janAmt2)/(this.novQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqNovAmtPer2 = 0;
              
              if(this.decQuota2 > 0)
                this.pqDecAmtPer2 = ((this.decAmt2 + this.janAmt2 + this.febAmt2)/(this.decQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqDecAmtPer2 = 0;
              
              if(this.janQuota2 > 0)
                this.pqJanAmtPer2 = ((this.janAmt2 + this.febAmt2 + this.marAmt2)/(this.janQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJanAmtPer2 = 0;
              
              if(this.febQuota2 > 0)
                this.pqFebAmtPer2 = ((this.febAmt2 + this.marAmt2 + this.aprAmt2)/(this.febQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqFebAmtPer2 = 0;
              
              if(this.marQuota2 > 0)
                this.pqMarAmtPer2 = ((this.marAmt2 + this.aprAmt2 + this.mayAmt2)/(this.marQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqMarAmtPer2 = 0;
              
              this.pqAmtPerAvg2 = ((this.pqAprAmtPer2 + this.pqMayAmtPer2 + this.pqJunAmtPer2 + this.pqJulAmtPer2 + this.pqAugAmtPer2 + this.pqSepAmtPer2 + this.pqOctAmtPer2 + this.pqNovAmtPer2 + this.pqDecAmtPer2 + this.pqJanAmtPer2 + this.pqFebAmtPer2 + this.pqMarAmtPer2)/12).setScale(0, RoundingMode.HALF_UP);
              
              /**********************************************************************************************************************************************************************************************************************************************************************************************************/
              
              if(this.aprQuota2 > 0 || this.mayQuota2 > 0 || this.junQuota2 > 0)
                this.pqAprAmtPerRol2 = ((this.aprAmt2 + this.mayAmt2 + this.junAmt2)/(this.aprQuota2 + this.mayQuota2 + this.junQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqAprAmtPerRol2 = 0;
              
              if(this.mayQuota2 > 0 || this.junQuota2 > 0 || this.julQuota2 > 0)
                this.pqMayAmtPerRol2 = ((this.mayAmt2 + this.junAmt2 + this.julAmt2)/(this.mayQuota2 + this.junQuota2 + this.julQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqMayAmtPerRol2 = 0;
              
              if(this.junQuota2 > 0 || this.julQuota2 > 0 || this.augQuota2 > 0)
                this.pqJunAmtPerRol2 = ((this.junAmt2 + this.julAmt2 + this.augAmt2)/(this.junQuota2 + this.julQuota2 + this.augQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJunAmtPerRol2 = 0;
              
              if(this.julQuota2 > 0 || this.augQuota2 > 0 || this.sepQuota2 > 0)
                this.pqJulAmtPerRol2 = ((this.julAmt2 + this.augAmt2 + this.sepAmt2)/(this.julQuota2 + this.augQuota2 + this.sepQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJulAmtPerRol2 = 0;
              
              if(this.augQuota2 > 0 || this.sepQuota2 > 0 || this.octQuota2 > 0)
                this.pqAugAmtPerRol2 = ((this.augAmt2 + this.sepAmt2 + this.octAmt2)/(this.augQuota2 + this.sepQuota2 + this.octQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqAugAmtPerRol2 = 0;
              
              if(this.sepQuota2 > 0 || this.octQuota2 > 0 || this.novQuota2 > 0)
                this.pqSepAmtPerRol2 = ((this.sepAmt2 + this.octAmt2 + this.novAmt2)/(this.sepQuota2 + this.octQuota2 + this.novQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqSepAmtPerRol2 = 0;
              
              if(this.octQuota2 > 0 || this.novQuota2 > 0 || this.decQuota2 > 0)
                this.pqOctAmtPerRol2 = ((this.octAmt2 + this.novAmt2 + this.decAmt2)/(this.octQuota2 + this.novQuota2 + this.decQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqOctAmtPerRol2 = 0;
              
              if(this.novQuota2 > 0 || this.decQuota2 > 0 || this.janQuota2 > 0)
                this.pqNovAmtPerRol2 = ((this.novAmt2 + this.decAmt2 + this.janAmt2)/(this.novQuota2 + this.decQuota2 + this.janQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqNovAmtPerRol2 = 0;
              
              if(this.decQuota2 > 0 || this.janQuota2 > 0 || this.febQuota2 > 0)
                this.pqDecAmtPerRol2 = ((this.decAmt2 + this.janAmt2 + this.febAmt2)/(this.decQuota2 + this.janQuota2 + this.febQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqDecAmtPerRol2 = 0;
              
              if(this.janQuota2 > 0 || this.febQuota2 > 0 || this.marQuota2 > 0)
                this.pqJanAmtPerRol2 = ((this.janAmt2 + this.febAmt2 + this.marAmt2)/(this.janQuota2 + this.febQuota2 + this.marQuota2) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqJanAmtPerRol2 = 0;
              
              //::NS:: this stratles into a year that we are not looking at so we don't calculate into that year
              if(this.febQuota2 > 0 || this.marQuota2 > 0 )
                this.pqFebAmtPerRol2 = ((this.febAmt2 + this.marAmt2 )/(this.febQuota2 + this.marQuota2 ) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqFebAmtPerRol2 = 0;
              
              if(this.marQuota2 > 0 )
                this.pqMarAmtPerRol2 = ((this.marAmt2 )/(this.marQuota2 ) * 100).setScale(0, RoundingMode.HALF_UP);
              else this.pqMarAmtPerRol2 = 0;
              
              this.pqAmtPerAvgRol2 = ((this.pqAprAmtPerRol2 + this.pqMayAmtPerRol2 + this.pqJunAmtPerRol2 + this.pqJulAmtPerRol2 + this.pqAugAmtPerRol2 + this.pqSepAmtPerRol2 + this.pqOctAmtPerRol2 + this.pqNovAmtPerRol2 + this.pqDecAmtPerRol2 + this.pqJanAmtPerRol2 + this.pqFebAmtPerRol2 + this.pqMarAmtPerRol2)/12).setScale(0, RoundingMode.HALF_UP);
              
              If(mapAmtQuota.get('aprQuota') != 0)
              {
              this.pqAprAmt12monthRoll = (((mapAmt.get('aprAmt') + mapAmt.get('mayAmt') + mapAmt.get('junAmt') + mapAmt.get('julAmt') + mapAmt.get('augAmt') + mapAmt.get('sepAmt') + mapAmt.get('octAmt') + mapAmt.get('novAmt') + mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt'))/(mapAmtQuota.get('aprQuota') + mapAmtQuota.get('mayQuota') + mapAmtQuota.get('junQuota') + mapAmtQuota.get('julQuota') + mapAmtQuota.get('augQuota') + mapAmtQuota.get('sepQuota') + mapAmtQuota.get('octQuota') + mapAmtQuota.get('novQuota') + mapAmtQuota.get('decQuota') + mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;
              
              this.pqMayAmt12monthRoll = (((mapAmt.get('mayAmt') + mapAmt.get('junAmt') + mapAmt.get('julAmt') + mapAmt.get('augAmt') + mapAmt.get('sepAmt') + mapAmt.get('octAmt') + mapAmt.get('novAmt') + mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt'))/(mapAmtQuota.get('mayQuota') + mapAmtQuota.get('junQuota') + mapAmtQuota.get('julQuota') + mapAmtQuota.get('augQuota') + mapAmtQuota.get('sepQuota') + mapAmtQuota.get('octQuota') + mapAmtQuota.get('novQuota') + mapAmtQuota.get('decQuota') + mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;

              this.pqJunAmt12monthRoll = (((mapAmt.get('junAmt') + mapAmt.get('julAmt') + mapAmt.get('augAmt') + mapAmt.get('sepAmt') + mapAmt.get('octAmt') + mapAmt.get('novAmt') + mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt') +mapAmt2.get('mayAmt'))/(mapAmtQuota.get('junQuota') + mapAmtQuota.get('julQuota') + mapAmtQuota.get('augQuota') + mapAmtQuota.get('sepQuota') + mapAmtQuota.get('octQuota') + mapAmtQuota.get('novQuota') + mapAmtQuota.get('decQuota') + mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;

              this.pqJulAmt12monthRoll = (((mapAmt.get('julAmt') + mapAmt.get('augAmt') + mapAmt.get('sepAmt') + mapAmt.get('octAmt') + mapAmt.get('novAmt') + mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt') +mapAmt2.get('mayAmt') + mapAmt2.get('junAmt'))/(mapAmtQuota.get('julQuota') + mapAmtQuota.get('augQuota') + mapAmtQuota.get('sepQuota') + mapAmtQuota.get('octQuota') + mapAmtQuota.get('novQuota') + mapAmtQuota.get('decQuota') + mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;

              this.pqAugAmt12monthRoll = (((mapAmt.get('augAmt') + mapAmt.get('sepAmt') + mapAmt.get('octAmt') + mapAmt.get('novAmt') + mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt') +mapAmt2.get('mayAmt') + mapAmt2.get('junAmt') +mapAmt2.get('julAmt'))/(mapAmtQuota.get('augQuota') + mapAmtQuota.get('sepQuota') + mapAmtQuota.get('octQuota') + mapAmtQuota.get('novQuota') + mapAmtQuota.get('decQuota') + mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota') + mapAmtQuota2.get('julQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;

              this.pqSepAmt12monthRoll = (((mapAmt.get('sepAmt') + mapAmt.get('octAmt') + mapAmt.get('novAmt') + mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt') +mapAmt2.get('mayAmt') + mapAmt2.get('junAmt') +mapAmt2.get('julAmt') + mapAmt2.get('augAmt'))/(mapAmtQuota.get('sepQuota') + mapAmtQuota.get('octQuota') + mapAmtQuota.get('novQuota') + mapAmtQuota.get('decQuota') + mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota') + mapAmtQuota2.get('julQuota') + mapAmtQuota2.get('augQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;

              this.pqOctAmt12monthRoll = (((mapAmt.get('octAmt') + mapAmt.get('novAmt') + mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt') +mapAmt2.get('mayAmt') + mapAmt2.get('junAmt') +mapAmt2.get('julAmt') + mapAmt2.get('augAmt') + mapAmt2.get('sepAmt'))/(mapAmtQuota.get('octQuota') + mapAmtQuota.get('novQuota') + mapAmtQuota.get('decQuota') + mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota') + mapAmtQuota2.get('julQuota') + mapAmtQuota2.get('augQuota') + mapAmtQuota2.get('sepQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;

              this.pqNovAmt12monthRoll = (((mapAmt.get('novAmt') + mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt') +mapAmt2.get('mayAmt') + mapAmt2.get('junAmt') +mapAmt2.get('julAmt') + mapAmt2.get('augAmt') + mapAmt2.get('sepAmt') + mapAmt2.get('octAmt'))/(mapAmtQuota.get('novQuota') + mapAmtQuota.get('decQuota') + mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota') + mapAmtQuota2.get('julQuota') + mapAmtQuota2.get('augQuota') + mapAmtQuota2.get('sepQuota') + mapAmtQuota2.get('octQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;

              this.pqDecAmt12monthRoll = (((mapAmt.get('decAmt') + mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt') +mapAmt2.get('mayAmt') + mapAmt2.get('junAmt') +mapAmt2.get('julAmt') + mapAmt2.get('augAmt') + mapAmt2.get('sepAmt') + mapAmt2.get('octAmt') + mapAmt2.get('novAmt'))/(mapAmtQuota.get('decQuota') + mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota') + mapAmtQuota2.get('julQuota') + mapAmtQuota2.get('augQuota') + mapAmtQuota2.get('sepQuota') + mapAmtQuota2.get('octQuota') + mapAmtQuota2.get('novQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;

              this.pqJanAmt12monthRoll = (((mapAmt.get('janAmt') + mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt') +mapAmt2.get('mayAmt') + mapAmt2.get('junAmt') +mapAmt2.get('julAmt') + mapAmt2.get('augAmt') + mapAmt2.get('sepAmt') + mapAmt2.get('octAmt') + mapAmt2.get('novAmt') + mapAmt2.get('decAmt'))/(mapAmtQuota.get('janQuota') + mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota') + mapAmtQuota2.get('julQuota') + mapAmtQuota2.get('augQuota') + mapAmtQuota2.get('sepQuota') + mapAmtQuota2.get('octQuota') + mapAmtQuota2.get('novQuota') + mapAmtQuota2.get('decQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;

              this.pqFebAmt12monthRoll = (((mapAmt.get('febAmt') + mapAmt.get('marAmt') + mapAmt2.get('aprAmt') +mapAmt2.get('mayAmt') + mapAmt2.get('junAmt') +mapAmt2.get('julAmt') + mapAmt2.get('augAmt') + mapAmt2.get('sepAmt') + mapAmt2.get('octAmt') + mapAmt2.get('novAmt') + mapAmt2.get('decAmt') + mapAmt2.get('janAmt'))/(mapAmtQuota.get('febQuota') + mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota') + mapAmtQuota2.get('julQuota') + mapAmtQuota2.get('augQuota') + mapAmtQuota2.get('sepQuota') + mapAmtQuota2.get('octQuota') + mapAmtQuota2.get('novQuota') + mapAmtQuota2.get('decQuota') + mapAmtQuota2.get('janQuota')))*100).setScale(0, RoundingMode.HALF_UP) ;

              this.pqMarAmt12monthRoll = (((mapAmt.get('marAmt') + mapAmt2.get('aprAmt') +mapAmt2.get('mayAmt') + mapAmt2.get('junAmt') +mapAmt2.get('julAmt') + mapAmt2.get('augAmt') + mapAmt2.get('sepAmt') + mapAmt2.get('octAmt') + mapAmt2.get('novAmt') + mapAmt2.get('decAmt') + mapAmt2.get('janAmt') + mapAmt2.get('febAmt'))/(mapAmtQuota.get('marQuota') + mapAmtQuota2.get('aprQuota') + mapAmtQuota2.get('mayQuota') + mapAmtQuota2.get('junQuota') + mapAmtQuota2.get('julQuota') + mapAmtQuota2.get('augQuota') + mapAmtQuota2.get('sepQuota') + mapAmtQuota2.get('octQuota') + mapAmtQuota2.get('novQuota') + mapAmtQuota2.get('decQuota') + mapAmtQuota2.get('janQuota') + mapAmtQuota2.get('febQuota')))*100).setScale(0, RoundingMode.HALF_UP) ; 
              }
              else
              {
                this.pqAprAmt12monthRoll = 0;
                this.pqMayAmt12monthRoll = 0;
                this.pqJunAmt12monthRoll = 0;
                this.pqJulAmt12monthRoll = 0;
                this.pqAugAmt12monthRoll = 0;
                this.pqSepAmt12monthRoll = 0;
                this.pqOctAmt12monthRoll = 0;
                this.pqNovAmt12monthRoll = 0;
                this.pqDecAmt12monthRoll = 0;
                this.pqJanAmt12monthRoll = 0;
                this.pqFebAmt12monthRoll = 0;
                this.pqMarAmt12monthRoll = 0;

              }
              
            }//if
            
            
            If(totQuotaAmt != null && decimal.valueOf(totQuotaAmt) != 0)
            {
                this.pqMarAmt12monthRollTotal = String.valueOf(((totOppAmountFacTotal2/decimal.valueOf(totQuotaAmt))*100).setScale(0, RoundingMode.HALF_UP));          
                this.pqMarAmt12monthRollFactored = String.valueOf(((decimal.valueOf(totOppfacAmount2)/decimal.valueOf(totQuotaAmt))*100).setScale(0, RoundingMode.HALF_UP));
            }
        }

    }//oppAmtCalc
    
    /******************************CONDITIONAL TABLE CLASS ENDS*******************************/
    
    
    public class accWrapper{
        public Id accId {get; set;}
        public transient String accName {get; set;}
        public Id ownerId {get; set;}
        public transient String ownerName {get; set;}
        public Boolean nationalAcc {get; set;}
        public Boolean japaneseCompany {get; set;}
        public transient decimal  totAmount {get; set;}
        public transient decimal  totMAAmount {get; set;}
        public transient decimal  totSRAmount  {get; set;}
        public transient decimal  totTKAmount    {get; set;}
        public transient decimal  totRCAmount {get; set;}
        public transient decimal  totMCPAmount  {get; set;} 
        public transient decimal  totOtherAmount  {get; set;}
        
        public accWrapper(Id accId, String accName, Id ownerId, String ownerName, Boolean natAcc, Boolean japanComp, Decimal totAmount, Decimal totMAAmount, Decimal totSRAmount, Decimal totTKAmount, Decimal totRCAmount, Decimal totMCPAmount, Decimal totOtherAmount) {
            this.accId = accId;
            this.accName = accName;
            this.ownerId = ownerId;
            this.ownerName = ownerName;
            this.nationalAcc = natAcc;
            this.japaneseCompany = japanComp;
            this.totAmount = totAmount;
            this.totMAAmount=totMAAmount;
            this.totSRAmount=totSRAmount;
            this.totTKAmount=totTKAmount;
            this.totRCAmount=totRCAmount;
            this.totMCPAmount=totMCPAmount;
            this.totOtherAmount=totOtherAmount;
        }
    }//accWrapper
    
    /******************************MIDDLE SECTION TABLE CLASS ENDS*******************************/
    
    
    public PageReference generatePdf() {
        PageReference pageRef = new PageReference('/apex/vfMapsQuotaAsPDFNew');
        pageRef.getParameters().put('Ids',selectedValues);
        
        return pageRef;
    }
    
    public List<SelectOption> getAccTypeList() {
        List<SelectOption> optionList = new List<SelectOption>();
        optionList.add(new SelectOption('0','All'));
        optionList.add(new SelectOption('1','MA'));
        optionList.add(new SelectOption('2','TK'));
        optionList.add(new SelectOption('3','SR'));
        optionList.add(new SelectOption('4','Rental Chillers'));
        optionList.add(new SelectOption('5','MCP'));
        optionList.add(new SelectOption('6','Others'));
        
        return optionList;
    }
    
    public static string getDateMapString(Integer month)
    {
    	if(month == 1)
    		return 'janAmt';
    	if(month == 2)
    		return 'febAmt';
    	if(month == 3)
    		return 'marAmt';
    	if(month == 4)
    		return 'aprAmt';
    	if(month == 5)
    		return 'mayAmt';
    	if(month == 6)
    		return 'junAmt';
    	if(month == 7)
    		return 'julAmt';
    	if(month == 8)
    		return 'augAmt';
    	if(month == 9)
    		return 'sepAmt';
    	if(month == 10)
    		return 'octAmt';
    	if(month == 11)
    		return 'novAmt';
    	if(month == 12)
    		return 'decAmt';
    		
        return 'err';
    		
    }
}