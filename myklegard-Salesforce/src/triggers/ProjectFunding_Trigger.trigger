trigger ProjectFunding_Trigger on Project_Funding_Sources__c (after insert, after update,after delete) {
       Set<ID> pfIds = new Set<ID>();
       Set<ID> PFSIds = new Set<ID>();
       Set<ID> EstIds = new Set<ID>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Project_Funding_Sources__c pfObj: Trigger.new){
            pfIds.add(pfObj.Funding_Stream__c);
        }
    }
    if(Trigger.isUpdate || Trigger.isDelete){
        for(Project_Funding_Sources__c pfObj: Trigger.old){
             pfIds.add(pfObj.Funding_Stream__c);
        }  
    }    
    List<Project_Funding_Sources__c> PFSList = [select Id from Project_Funding_Sources__c where status__c='Draft' LIMIT 10];
    for(Project_Funding_Sources__c pfs:PFSList){
    	 PFSIds.add(pfs.Id);
    }     
    
     List<Estimate_Planned__c> mpEstimated = [SELECT Id from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Funding_Stream__c IN :pfIds];
     for(Estimate_Planned__c mps:mpEstimated){
    	 EstIds.add(mps.Id);
    }
     
    /* List<Funding_Streams__c> fundingStreams =[select Id,Budget_Authority__c,Funds_Available1__c from Funding_Streams__c where Id IN :pfIds];
     LIST<AggregateResult> estPlanned=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Project_Funding__c='' and Funding_Direction__c='Request' and Funding_Stream__c IN :pfIds GROUP BY Funding_Stream__c];
     LIST<AggregateResult> dupestPlanned=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Project_Funding__c IN :PFSIds and Funding_Direction__c='Request' and Funding_Stream__c IN :pfIds GROUP BY Funding_Stream__c];
     List<AggregateResult>  projectFunding=[select sum(Amount__c) pfamount,Funding_Stream__c from Project_Funding_Sources__c where  Status__c in ('Approved','Locked') and Funding_Type__c='Request' and Funding_Stream__c IN :pfIds GROUP BY Funding_Stream__c];
     LIST<AggregateResult> estPlanned1=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Project_Funding__c='' and Funding_Direction__c='Return' and Funding_Stream__c IN :pfIds GROUP BY Funding_Stream__c];
     LIST<AggregateResult> dupestPlanned1=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  Status__c in ('Approved','Locked') and Project_Funding__c IN :PFSIds and Funding_Direction__c='Return' and Funding_Stream__c IN :pfIds GROUP BY Funding_Stream__c];
     List<AggregateResult>  projectFunding1=[select sum(Amount__c) pfamount,Funding_Stream__c from Project_Funding_Sources__c where  Status__c in ('Approved','Locked') and Funding_Type__c='Return' and Funding_Stream__c IN :pfIds GROUP BY Funding_Stream__c];*/
     
     List<Funding_Streams__c> fundingStreams =[select Id,Budget_Authority__c,Funds_Available1__c from Funding_Streams__c where Id IN :pfIds];
     LIST<AggregateResult> estPlanned=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  Project_Funding__c='' and Funding_Direction__c='Request' and Funding_Stream__c IN :EstIds GROUP BY Funding_Stream__c];
     LIST<AggregateResult> dupestPlanned=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  Project_Funding__c IN :PFSIds and Funding_Direction__c='Request' and Funding_Stream__c IN :EstIds GROUP BY Funding_Stream__c];
     List<AggregateResult>  projectFunding=[select sum(Amount__c) pfamount,Funding_Stream__c from Project_Funding_Sources__c where  Funding_Type__c='Request' and Funding_Stream__c IN :EstIds GROUP BY Funding_Stream__c];
     LIST<AggregateResult> estPlanned1=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where  Project_Funding__c='' and Funding_Direction__c='Return' and Funding_Stream__c IN :EstIds GROUP BY Funding_Stream__c];
     LIST<AggregateResult> dupestPlanned1=[select sum(Cost_Estimate__c) Cost_Estimate,Funding_Stream__c from Estimate_Planned__c   where Project_Funding__c IN :PFSIds and Funding_Direction__c='Return' and Funding_Stream__c IN :EstIds GROUP BY Funding_Stream__c];
     List<AggregateResult>  projectFunding1=[select sum(Amount__c) pfamount,Funding_Stream__c from Project_Funding_Sources__c where Funding_Type__c='Return' and Funding_Stream__c IN :EstIds GROUP BY Funding_Stream__c];
     
     Integer costEstimate=0;
     Integer dupcostEstimate=0;
     Integer pfamount=0; 
     Integer costEstimate1=0;
     Integer dupcostEstimate1=0;
     Integer pfamount1=0;  
     for(AggregateResult sobj : estPlanned){ 
       costEstimate= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(costEstimate==null) costEstimate=0; 
     }
     for(AggregateResult sobj : dupestPlanned){          
       dupcostEstimate= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(dupcostEstimate==null) dupcostEstimate=0; 
     }
     for(AggregateResult sobj : projectFunding){  
       pfamount= Integer.valueOf(sobj.get('pfamount'));
       if(pfamount==null)pfamount=0;
     }
     for(AggregateResult sobj : estPlanned1){   
       costEstimate1= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(costEstimate1==null) costEstimate=0; 
     }
     for(AggregateResult sobj : dupestPlanned1){   
       dupcostEstimate1= Integer.valueOf(sobj.get('Cost_Estimate'));
       if(dupcostEstimate1==null) dupcostEstimate1=0; 
     }
     for(AggregateResult sobj : projectFunding1){   
       pfamount1= Integer.valueOf(sobj.get('pfamount'));
       if(pfamount1==null)pfamount=0;
     }   
      List<Funding_Streams__c> lsFundingStreams = new List<Funding_Streams__c>(); 
      for(Funding_Streams__c fs:fundingStreams){
        fs.Funds_Available1__c=fs.Budget_Authority__c-costEstimate-dupcostEstimate- pfamount+costEstimate1+dupcostEstimate1+pfamount1;
        lsFundingStreams.add(fs);        
      }      
      update lsFundingStreams;
  }