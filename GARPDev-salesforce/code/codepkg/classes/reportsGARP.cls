global without sharing class reportsGARP {

     public reportsGARP() { 
     }
     
    global class rptData { 
        public List<Product_Refunds__c> refunds { get; set; }
        public List<Opportunity> opps { get; set; }
        public List<ChargentSFA__Transaction__c> trans { get; set; }
        
    }
    
    @RemoteAction
    public static rptData getReportData(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);

        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();

        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null)
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
        
        List<Opportunity> pdes;
        pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id FROM OpportunityLineItems) from Opportunity where Id in :ids];
        
        List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, Product__c, Product_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, Unique_Id__c, CreatedDate from Product_Refunds__c where Opportunity__c in :ids and Payment_Transaction__c in :transIds];
       
        //List<Opportunity> pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, (SELECT Id,Description,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice FROM OpportunityLineItems) from Opportunity where Id in :pIds];
        //List<ChargentSFA__Transaction__c> trs = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c in :pIds];
        
        rd.refunds = prs; 
        rd.opps = pdes;
        rd.trans = tres;

        return rd ;
    }     
    
    
    @RemoteAction
    public static rptData getReportDataTrans(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);

        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();

        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null)
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
        
        rd.trans = tres;

        return rd ;
    }     
    
    @RemoteAction
    public static rptData getReportDataOpp(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);

        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();

        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null)
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
        
        List<Opportunity> pdes;
        pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity where Id in :ids];
                
        rd.opps = pdes;

        return rd ;
    }     
    
    @RemoteAction
    public static rptData getReportDataRefunds(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);

        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();

        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null)
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
                
        List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, Product__c, Product_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, Unique_Id__c, CreatedDate from Product_Refunds__c where Opportunity__c in :ids and Payment_Transaction__c in :transIds];
       
        rd.refunds = prs;

        return rd ;
    }         
    
    @RemoteAction
    public static rptData getReportDataTransFilters(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ, List<String> filterProdIds) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);

        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();

        MAP<String,String> filterProdsIdsMap = new MAP<String,String>();
        if(filterProdIds != null) {
            for(String s :filterProdIds) {                
                filterProdsIdsMap.put(s, s);
            }
        }
        system.debug('filterProdsIdsMap:' + filterProdsIdsMap);
        
        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null) {
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
            
            if(filterProdIds != null) {
                List<Opportunity> pdes;
                List<ChargentSFA__Transaction__c> finalTrans = new List<ChargentSFA__Transaction__c>();
                MAP<Id,Opportunity> fndOpp = new MAP<Id,Opportunity>();
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity where Id in :ids];
                for(Opportunity opp :pdes) {
                    for(OpportunityLineItem oli :opp.OpportunityLineItems) {
                        
                        //system.debug('oli:' + oli + ':' + oli.Product2Id);
                        //System.assert(false, 'BOOM!oli' + oli.PricebookEntry.Id);
                        Id fndId = filterProdsIdsMap.get(String.valueOf(oli.PricebookEntry.Id));
                        
                        system.debug('fndId:' + fndId);
                        
                        if(fndId != null) {
                            fndOpp.put(opp.Id,Opp);
                        }                
                    }
                }
                
                system.debug('fndOpp:' + fndOpp);
                
                for(ChargentSFA__Transaction__c t :tres) {
                    Opportunity fnd = fndOpp.get(t.ChargentSFA__Opportunity__c);
                    if(fnd != null)
                        finalTrans.add(t);
                }
                
                system.debug('finalTrans:' + finalTrans);
                
                rd.trans = finalTrans;
            } else {
                rd.trans = tres;            
            }
            
        }
        
        
        return rd ;
    }     
    
    @RemoteAction
    public static rptData getReportDataOppFilters(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ, List<String> filterProdIds) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);

        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();

        MAP<String,String> filterProdsIdsMap = new MAP<String,String>();
        if(filterProdIds != null) {
            for(String s :filterProdIds) {                
                filterProdsIdsMap.put(s, s);
            }
        }
        system.debug('filterProdsIdsMap:' + filterProdsIdsMap);
        
        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null) {
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
            
            if(filterProdIds != null) {
                List<Opportunity> pdes;
                List<ChargentSFA__Transaction__c> finalTrans = new List<ChargentSFA__Transaction__c>();
                MAP<Id,Opportunity> fndOpp = new MAP<Id,Opportunity>();
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity where Id in :ids];
                for(Opportunity opp :pdes) {
                    for(OpportunityLineItem oli :opp.OpportunityLineItems) {
                        
                        //system.debug('oli:' + oli + ':' + oli.Product2Id);
                        //System.assert(false, 'BOOM!oli' + oli.PricebookEntry.Id);
                        Id fndId = filterProdsIdsMap.get(String.valueOf(oli.PricebookEntry.Id));
                        
                        system.debug('fndId:' + fndId);
                        
                        if(fndId != null) {
                            fndOpp.put(opp.Id,Opp);
                        }                
                    }
                }
                
                system.debug('fndOpp:' + fndOpp);
                                                
                rd.opps = fndOpp.Values();
            } else {
			    List<Opportunity> pdes;
				pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity where Id in :ids];

                rd.opps = pdes;            
            }
            
        }

        return rd ;
    }     
    
    @RemoteAction
    public static rptData getReportDataRefundsFilters(String startDate,String endDate, Boolean GARP, Boolean GRA, Boolean NJ, List<String> filterProdIds) {
       Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);

        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();

        MAP<String,String> filterProdsIdsMap = new MAP<String,String>();
        if(filterProdIds != null) {
            for(String s :filterProdIds) {                
                filterProdsIdsMap.put(s, s);
            }
        }
        system.debug('filterProdsIdsMap:' + filterProdsIdsMap);
        
        List<ChargentSFA__Transaction__c> tres;
        
        if(!GARP && !GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        else if(GARP && !GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && !NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        else if(!GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey')];
        else if(GARP && GRA && !NJ)
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Company__c = 'GRA' or ChargentSFA__Opportunity__r.Company__c = 'GARP')];
        else if(GARP && !GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GARP'];
        else if(!GARP && GRA && NJ)    
            tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Opportunity__r.Company__c, ChargentSFA__Opportunity__r.Shipping_State__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined' and (ChargentSFA__Opportunity__r.Shipping_State__c = 'NJ' or ChargentSFA__Opportunity__r.Shipping_State__c = 'New Jersey') and ChargentSFA__Opportunity__r.Company__c = 'GRA'];
        
        List<Id> ids = new List<Id>();
        List<Id> transIds = new List<Id>();
        if(tres != null) {
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
                transIds.add(t.Id);
            }        
            
            if(filterProdIds != null) {
                List<Opportunity> pdes;
                List<ChargentSFA__Transaction__c> finalTrans = new List<ChargentSFA__Transaction__c>();
                MAP<Id,Opportunity> fndOpp = new MAP<Id,Opportunity>();
                pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, Member_First_Name__c, Member_Last_Name__c, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, PricebookEntry.Id, PricebookEntry.product2.Gl_Code__c,PricebookEntry.productcode  FROM OpportunityLineItems) from Opportunity where Id in :ids];
                for(Opportunity opp :pdes) {
                    for(OpportunityLineItem oli :opp.OpportunityLineItems) {
                        
                        //system.debug('oli:' + oli + ':' + oli.Product2Id);
                        //System.assert(false, 'BOOM!oli' + oli.PricebookEntry.Id);
                        Id fndId = filterProdsIdsMap.get(String.valueOf(oli.PricebookEntry.Id));
                        
                        system.debug('fndId:' + fndId);
                        
                        if(fndId != null) {
                            fndOpp.put(opp.Id,Opp);
                        }                
                    }
                }
                
                system.debug('fndOpp:' + fndOpp);
				
                List<Id> finalTransIds = new List<Id>();                
                for(ChargentSFA__Transaction__c t :tres) {
                    Opportunity fnd = fndOpp.get(t.ChargentSFA__Opportunity__c);
                    if(fnd != null)
                        finalTransIds.add(t.Id);
                }
                
                system.debug('finalTrans:' + finalTransIds);
				
                List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, Product__c, Product_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, Unique_Id__c, CreatedDate from Product_Refunds__c where Opportunity__c in :ids and Payment_Transaction__c in :finalTransIds];
				rd.refunds = prs;

            } else {
                List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, Product__c, Product_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, Unique_Id__c, CreatedDate from Product_Refunds__c where Opportunity__c in :ids and Payment_Transaction__c in :transIds];
				rd.refunds = prs;
            }
            
        }

        return rd ;
    }     
    
    @RemoteAction
    public static rptData getRefunds(String startDate,String endDate) {
        Long d = Long.valueOf(startDate) * 1000;
        DateTime stDateTime = DateTime.newInstance(d);
        Date stDate = date.newInstance(stDateTime.year(), stDateTime.month(), stDateTime.day());
        
        Long e = Long.valueOf(endDate) * 1000;
        DateTime endDateTime = DateTime.newInstance(e);
        Date edDate = date.newInstance(endDateTime.year(), endDateTime.month(), endDateTime.day()+1);

        system.debug('* * * Refund dates ...'+ String.valueOf(stDate) + ':' + String.valueOf(edDate) + ':' + String.valueOf(stDateTime) + ':' + String.valueOf(endDateTime));
        rptData rd = new rptData();

        List<ChargentSFA__Transaction__c> tres = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c, ChargentSFA__Gateway_Response__c from ChargentSFA__Transaction__c where ChargentSFA__Gateway_Date__c >= :stDateTime and ChargentSFA__Gateway_Date__c <= :endDateTime and ChargentSFA__Response_Status__c != 'Declined'];
        List<Id> ids = new List<Id>();
        if(tres != null)
            for(ChargentSFA__Transaction__c t :tres) {
                ids.add(t.ChargentSFA__Opportunity__c);
            }        
        
        List<Opportunity> pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, Shipping_State__c, Shipping_Country__c, (SELECT Id,Description,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id FROM OpportunityLineItems) from Opportunity where Id in :ids];
        
        List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, Product__c, Product_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, Unique_Id__c, CreatedDate from Product_Refunds__c where Opportunity__c in :ids];
       
        //List<Opportunity> pdes = [select Id, Display_Invoice_Number__c, Name, Amount, CloseDate, GARP_Member_ID__c, Company__c, (SELECT Id,Description,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice FROM OpportunityLineItems) from Opportunity where Id in :pIds];
        //List<ChargentSFA__Transaction__c> trs = [select Id, Name, ChargentSFA__Gateway_ID__c, ChargentSFA__Tokenization__c, ChargentSFA__Opportunity__c, ChargentSFA__Opportunity__r.Name, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c in :pIds];
        
        rd.refunds = prs; 
        rd.opps = pdes;
        rd.trans = tres;

        return rd ;
    }     
    
    @RemoteAction
    public static List<PriceBookEntry> getProducts(String priceBookId) {

        List<PriceBookEntry> pdes = [select Id, Name, Product2.RPT_Sort_Order__c, Product2.Id, Product2.FRM_Exam__c, Product2.ERP_Exam__c, Product2.Name, Product2.Company__c, Product2.ProductCode, Product2.GL_Code__c, Product2.Description, Product2.Image__c, Product2.IsActive, Product2.Weight__c, Product2.FRM_1_Book__c, Product2.FRM_2_Book__c, Product2.ERP_Study_Center__c, Product2.FBR_Study_Center__c, Product2.ICBRR_Study_Center__c, pricebook2.IsActive, UnitPrice, UseStandardPrice from PriceBookEntry where Pricebook2.Id = :priceBookId order by Product2.RPT_Sort_Order__c];
        return pdes ;
    }     

}