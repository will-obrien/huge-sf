//This controller queries 10 opprotunities randomly
public class StreamingController {
public List<Opportunity> oppList{get;set;}

    public streamingController(){
        oppList = [Select Id,Name,Amount,StageName FROM Opportunity limit 10];
    }

}