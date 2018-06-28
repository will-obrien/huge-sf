trigger ProjectFunding_Project_Trigger on Project_Funding_Sources__c (after insert, after update,after delete) {
    Set<ID> pfIds = new Set<ID>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Project_Funding_Sources__c pfObj: Trigger.new){
            pfIds.add(pfObj.Project__c);
        }
    }
    if(Trigger.isUpdate || Trigger.isDelete){
        for(Project_Funding_Sources__c pfObj: Trigger.old){
             pfIds.add(pfObj.Project__c);
        }  
    } 
     LIST<AggregateResult> estPlanned=[select sum(Cost_Estimate__c) Cost_Estimate,Project__c from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Project_Funding__c='' and Funding_Direction__c='Request' and Project__c IN :pfIds GROUP BY Project__c];
     LIST<AggregateResult> dupestPlanned=[select sum(Cost_Estimate__c) Cost_Estimate,project__c from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Project_Funding__c in (select Id from Project_Funding_Sources__c where status__c='Draft' ) and Funding_Direction__c='Request' and project__c IN :pfIds GROUP BY project__c];
     List<AggregateResult>  projectFunding=[select sum(Amount__c) pfamount,Project__c from Project_Funding_Sources__c where  Status__c in ('Approved','Locked') and Funding_Type__c='Request' and Project__c IN :pfIds GROUP BY Project__c];
     LIST<AggregateResult> estPlanned1=[select sum(Cost_Estimate__c) Cost_Estimate,Project__c from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Project_Funding__c='' and Funding_Direction__c='Return' and Project__c IN :pfIds GROUP BY Project__c];
     LIST<AggregateResult> dupestPlanned1=[select sum(Cost_Estimate__c) Cost_Estimate,project__c from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Project_Funding__c in (select Id from Project_Funding_Sources__c where status__c='Draft')  and Funding_Direction__c='Return' and project__c IN :pfIds GROUP BY project__c];
     List<AggregateResult>  projectFunding1=[select sum(Amount__c) pfamount,Project__c from Project_Funding_Sources__c where  Status__c in ('Approved','Locked') and Funding_Type__c='Return' and Project__c IN :pfIds GROUP BY Project__c];
     List<project__c> proj =[select Id,Total_Funding1__c,Funding_Planned1__c from project__c where Id IN :pfIds];
     Integer costEstimate=0;
     Integer dupcostEstimate=0;     
     Integer pfamount=0; 
     Integer costEstimate1=0;
     Integer dupcostEstimate1=0;     
     Integer pfamount1=0;  
     for(AggregateResult sobj : estPlanned){ 
       costEstimate= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(costEstimate==null)
       costEstimate=0; 
     }
     for(AggregateResult sobj : dupestPlanned){   
       
       dupcostEstimate= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(dupcostEstimate==null)
       dupcostEstimate=0; 
     }
     for(AggregateResult sobj : projectFunding){  
       pfamount= Integer.valueOf(sobj.get('pfamount'));
       if(pfamount==null)
       pfamount=0;
     }
     for(AggregateResult sobj : estPlanned1){   
       costEstimate1= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(costEstimate1==null)
       costEstimate=0; 
     }
     for(AggregateResult sobj : dupestPlanned1){   
       dupcostEstimate1= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(dupcostEstimate1==null)
       dupcostEstimate1=0; 
     }
     
     for(AggregateResult sobj : projectFunding1){   
       pfamount1= Integer.valueOf(sobj.get('pfamount'));
       if(pfamount1==null)
       pfamount1=0;
     }     
    for(project__c p:proj){
        p.Total_Funding1__c=costEstimate+dupcostEstimate+pfamount-costEstimate1-dupcostEstimate1-pfamount1;  
        p.Funding_Planned1__c=pfamount-pfamount1;
        p.Total_Estimated__c=costEstimate+dupcostEstimate-costEstimate1-dupcostEstimate1;
        update p;
      }
  }