global class  PGIBaseUrl {
Public String BaseUrl { get; set; }

public list<ProcessInstanceStep> processlst { get; set ; }
public list<ProcessInstanceworkitem> processworklist { get; set ; }
public string actorName{get;set;}
public string OriginalActorName{get;set;}
public ID QuoteId ;
public ID getQuoteId (){return QuoteId;}
public void setQuoteId(Id q){
    QuoteId =q;
    PGIBaseUrl();
}


public void  PGIBaseUrl(){
 processlst=new list<ProcessInstanceStep>();
 processworklist=new list<ProcessInstanceworkitem>();
    processlst=[Select p.ProcessInstance.TargetObjectId, p.ProcessInstanceId, p.Actor.Name,p.OriginalActor.Name,p.ActorId From ProcessInstanceStep p
                                        where  p.ProcessInstance.TargetObjectId=:QuoteId order by p.CreatedDate desc limit 1];
    processworklist=[Select p.ProcessInstance.TargetObjectId, p.ProcessInstanceId, p.Actor.Name,p.OriginalActor.Name,p.ActorId From ProcessInstanceWorkitem p
                                        where  p.ProcessInstance.TargetObjectId=:QuoteId order by p.CreatedDate desc limit 1] ;
    if(!processlst.isEmpty()&& !processworklist.isEmpty()){
    actorName=processlst[0].Actor.Name;
    OriginalActorName=processworklist[0].OriginalActor.Name ;
       }

   BaseUrl=URL.getSalesforceBaseUrl().toExternalForm();
   

    }
}