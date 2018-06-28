trigger AfterPayment on ChargentSFA__Transaction__c(after update,before insert,after insert) {

     Set<Id> setIds = new Set<Id>();
     id transactionid ;
     Set<Id> oppIds = new Set<Id>();
     Set<Id> RefundoppIds = new Set<Id>();
     Set<Id> paymentid = new Set<Id>();
     List<Opportunity> lstOpps = new List<Opportunity>();
     List< Product_Refunds__c > listpr = new List< Product_Refunds__c >();
   
    for(ChargentSFA__Transaction__c obj : trigger.new)
    {

      if(obj.Do_not_fire__c) continue;

      system.debug('obj == '+obj);
      if(obj.ChargentSFA__Response_Status__c== 'Approved' && obj.ChargentSFA__Type__c =='Charge' && obj.ChargentSFA__Recurring__c != true)
      {
           setIds.add(obj.ChargentSFA__Opportunity__c); 

      }
      
      if(obj.ChargentSFA__Response_Status__c== 'Approved' && obj.ChargentSFA__Type__c =='Void' && obj.ChargentSFA__Recurring__c != true)
      {
           oppIds.add(obj.ChargentSFA__Opportunity__c); 

      }
     
      if(obj.ChargentSFA__Response_Status__c== 'Approved' && (obj.ChargentSFA__Type__c =='Refund'|| obj.ChargentSFA__Type__c =='Charge Back Accepted' || obj.ChargentSFA__Type__c =='Charge Back Loss'))
      {
            
           RefundoppIds.add(obj.ChargentSFA__Opportunity__c); 
           transactionid= obj.id;
        system.debug('transactionid == '+transactionid);
        system.debug('RefundoppIds == '+RefundoppIds);
      }}
   
   if(!oppIds.isEmpty()){
        for(opportunity opp : [select id,StageName from opportunity where id in: oppIds])
        {
            opp.StageName = 'Recurring Intent';
            opp.CloseDate = system.today();
            lstOpps.add(opp);
        }}  
    
    if(!setIds.isEmpty()){
       
        for(opportunity opp : [select id,StageName from opportunity where id in: setIds])
        {
            opp.StageName = 'Closed';
            opp.CloseDate = system.today();
            lstOpps.add(opp);
        }}


   if(!RefundoppIds.isEmpty() && transactionid != null){
   
        for(Product_Refunds__c pr : [select id,status__C from Product_Refunds__c where Opportunity__c in: RefundoppIds and status__c ='Approved'])
        {
            pr.Status__c  ='Completed';
            pr.Payment_Transaction__c = transactionid;
            system.debug('&&&&&&&:'+pr.Payment_Transaction__c );
            listpr.add(pr);
            
        }}  
        system.debug('listpr == '+listpr);
        if(lstOpps.size() > 0)
            update lstOpps;
            
       if(listpr.size()>0)           
       update listpr;
    
    }