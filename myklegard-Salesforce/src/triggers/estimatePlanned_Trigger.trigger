trigger estimatePlanned_Trigger  on Estimate_Planned__c (after insert, after update,after delete) {
Set<ID> estIds = new Set<ID>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Estimate_Planned__c epObj: Trigger.new){
            estIds.add(epObj.Funding_Stream__c);
        }
    }
    if(Trigger.isUpdate || Trigger.isDelete){
        for(Estimate_Planned__c epObj: Trigger.old){
             estIds.add(epObj.Funding_Stream__c);
        }  
    }
     LIST<AggregateResult> estPlanned=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  status__c in ('Approved','Locked') and Project_Funding__c  in (select Id from Project_Funding_Sources__c where status__c='Draft' ) and Funding_Direction__c='Request' and Funding_Stream__c IN :estIds GROUP BY Funding_Stream__c Limit 10];
     LIST<AggregateResult> dupestPlanned=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  status__c in ('Approved','Locked') and Project_Funding__c='' and Funding_Direction__c='Request' and Funding_Stream__c IN :estIds GROUP BY Funding_Stream__c Limit 10];
     List<AggregateResult>  projectFunding=[select sum(Amount__c) pfamount,Funding_Stream__c from Project_Funding_Sources__c where  Status__c in ('Approved','Locked') and Funding_Type__c='Request' and Funding_Stream__c IN :estIds GROUP BY Funding_Stream__c Limit 10];
     LIST<AggregateResult> estPlanned1=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Project_Funding__c='' and Funding_Direction__c='Return' and Funding_Stream__c IN :estIds GROUP BY Funding_Stream__c Limit 10];
     LIST<AggregateResult> dupestPlanned1=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Project_Funding__c in (select Id from Project_Funding_Sources__c where status__c='Draft') and Funding_Direction__c='Return' and Funding_Stream__c IN :estIds GROUP BY Funding_Stream__c Limit 10];
     List<AggregateResult>  projectFunding1=[select sum(Amount__c) pfamount,Funding_Stream__c from Project_Funding_Sources__c where  Status__c in ('Approved','Locked') and Funding_Type__c='Return' and Funding_Stream__c IN :estIds GROUP BY Funding_Stream__c Limit 10];
     List<Funding_Streams__c> fundingStreams =[select Id,Budget_Authority__c,Funds_Available1__c from Funding_Streams__c where Id IN :estIds Limit 10];
     Integer costEstimate=0;
     Integer dupcostEstimate=0;
     Integer pfamount=0; 
     Integer costEstimate1=0;
     Integer dupcostEstimate1=0;
     Integer pfamount1=0;  
     for(AggregateResult sobj : estPlanned)
     {   
       costEstimate= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(costEstimate==null)
       costEstimate=0; 
     }
     
     for(AggregateResult sobj : dupestPlanned)
     {   
       
       dupcostEstimate= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(dupcostEstimate==null)
       dupcostEstimate=0; 
     }
     
     for(AggregateResult sobj : projectFunding)
     { 
        
       pfamount= Integer.valueOf(sobj.get('pfamount'));
       if(pfamount==null)
       pfamount=0;
     }
     for(AggregateResult sobj : estPlanned1)
     {   
       
       costEstimate1= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(costEstimate1==null)
       costEstimate1=0; 
     }
     for(AggregateResult sobj : dupestPlanned1)
     {   
       dupcostEstimate1= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(dupcostEstimate1==null)
       dupcostEstimate1=0; 
     }
     
     for(AggregateResult sobj : projectFunding1)
     { 
        
       pfamount1= Integer.valueOf(sobj.get('pfamount'));
       if(pfamount1==null)
       pfamount1=0;
     }     
      for(Funding_Streams__c fs:fundingStreams)  
      {
        fs.Funds_Available1__c=fs.Budget_Authority__c-costEstimate-dupcostEstimate- pfamount+costEstimate1+dupcostEstimate1+pfamount1; 
        update fs;
      }
}