trigger Project_FundingStream_Trigger on Project__c (after insert, after update,after delete) {
    Set<ID> projIds = new Set<ID>();
    Set<ID> FIds = new Set<ID>();
    Set<ID> PFSIds = new Set<ID>();
    List<ID> FTempIds = new List<ID>();
    List<Funding_Streams__c> updatefslist = new List<Funding_Streams__c>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Project__c pfObj: Trigger.new){
            projIds.add(pfObj.Id);
        }
    }
    if(Trigger.isUpdate || Trigger.isDelete){
        for(Project__c pfObj: Trigger.old){
             projIds.add(pfObj.Id);
        }  
    }
    List <Project_Funding_Sources__c> profundList = [select Funding_Stream__c from Project_Funding_Sources__c where Project__c IN :projIds LIMIT 200]; 
    for(Project_Funding_Sources__c pfs:profundList){
         FIds.add(pfs.Funding_Stream__c);
    }
        
    List<Project_Funding_Sources__c> PFSList = [select id from Project_Funding_Sources__c where Funding_Stream__c IN :FIds LIMIT 200 ];
    for(Project_Funding_Sources__c pfs:PFSList){
    	 PFSIds.add(pfs.Id);
    }
    
    List <AggregateResult> profundList1 = [select sum(amount__c) FundingObligated,Project_Funding__r.Funding_Stream__c from contracts__C where Project_Funding__c IN :PFSIds group by Project_Funding__r.Funding_Stream__c ]; 
    List <AggregateResult> profundList2 =[select sum(Amount__c) pfamount,Funding_Stream__c from Project_Funding_Sources__c where Funding_Stream__c IN :FIds group by Funding_Stream__c];
    Integer FundingObligated=0;
    Integer PlannedbutUnobligated=0;
    Integer amount=0;
    Integer pfamount=0;
    Integer pfamount1=0;
    for(AggregateResult sobj : profundList2 ){
       pfamount=Integer.valueOf(sobj.get('pfamount'));
       if(pfamount==null)
       pfamount=0;
       Id pffundingstream=(Id)sobj.get('Funding_Stream__c');
     for(AggregateResult sobj1 : profundList1 ){
       Id fundingstream=(Id)sobj1.get('Funding_Stream__c');
       if(fundingstream==pffundingstream){
       FundingObligated= Integer.valueOf(sobj1.get('FundingObligated'));
       if(FundingObligated==null)
       FundingObligated=0;
       PlannedbutUnobligated=pfamount-FundingObligated;
       List<Funding_Streams__c> fundingStreams =[select Id,Funds_Obligated__c,Funds_Transferred__c from Funding_Streams__c where Id = :fundingstream];
      for(Funding_Streams__c fs:fundingStreams)  
      {
        FTempIds.add(fs.Id);
        fs.Funds_Obligated__c=FundingObligated;
        fs.Funds_Transferred__c=PlannedbutUnobligated;
        updatefslist.add(fs);
      }
      }         
  	}
    }
    
    update updatefslist;
    
    /*Commented due to 101 soql errors*/
  Boolean bResult = FIds.removeAll(FTempIds);
  System.debug('FIDs ' + FIds);
  List<Funding_Streams__c> updatefslist2 = new List<Funding_Streams__c>();
  /*List <AggregateResult> profundList3 =[select sum(Amount__c) pfamount,Funding_Stream__c from Project_Funding_Sources__c where Funding_Stream__c IN :FIds and Funding_Stream__c NOT IN :FTempIds group by Funding_Stream__c ];*/
  List <AggregateResult> profundList3 =[select sum(Amount__c) pfamount,Funding_Stream__c from Project_Funding_Sources__c where Funding_Stream__c IN :FIds group by Funding_Stream__c ];
  for(AggregateResult sobj2 : profundList3 )
     {
        pfamount1=Integer.valueOf(sobj2.get('pfamount'));
       Id pffundingstream1=(Id)sobj2.get('Funding_Stream__c');
       if(pfamount1==null)
       pfamount1=0;
       List<Funding_Streams__c> fslist =[select Id,Funds_Obligated__c,Funds_Transferred__c from Funding_Streams__c where Id = :pffundingstream1];       
       if(fslist !=null && !fslist.isEmpty())
       {
           for(Funding_Streams__c fs:fslist)  
          {
            fs.Funds_Obligated__c=0;
            fs.Funds_Transferred__c=pfamount1;
            updatefslist2.add(fs);            
          }         
          
       }
     }
     
     update updatefslist2;
  
  }