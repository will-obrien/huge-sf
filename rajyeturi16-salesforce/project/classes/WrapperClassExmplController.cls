public with sharing class WrapperClassExmplController {
public list<WarpperClass1> getwrprLst(){
     list<WarpperClass1> wpr = new list<WarpperClass1>();
     List<aggregateResult> results = [select owner.name ownername, count(name) TotalOpps, max(createdDate) MaxCreatedDate , sum(Amount) TotalVal from Opportunity group by owner.name];
      for (AggregateResult ar : results){
       string ownername = string.Valueof(ar.get('ownername'));
       integer TotalOpps = integer.Valueof(ar.get('TotalOpps'));
       Date MaxCreatedDate = Date.Valueof(ar.get('MaxCreatedDate'));
       Double TotalVal = Double.Valueof(ar.get('TotalVal'));
       integer TotalLeads = (integer)[select count(name) TotalLeads from lead where owner.name =: ownername][0].get('TotalLeads');
       WarpperClass1 cls = new WarpperClass1(ownername, TotalOpps, TotalLeads, MaxCreatedDate, TotalVal);
       wpr.add(cls);
       }
    return wpr;}
    



    public class WarpperClass1{
       
        public String owner {get; set;}
         public Integer opps {get; set;}
          public Integer leads {get; set;}
         public Date maxdate {get; set;}
         public Double amount {get; set;}
        public WarpperClass1(string own, integer opp, integer lead, Date dt, Double am){
           owner = own;
           opps = opp;
           leads = lead;
           maxdate = dt;
           amount = am;
           
        }
    }
}