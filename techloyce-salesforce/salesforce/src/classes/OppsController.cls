public class OppsController {
// Get a set of Opportunities
public ApexPages.StandardSetController setCon {
get {
if(setCon == null) {
setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
[SELECT name, type, amount, closedate FROM Opportunity]));
setCon.setPageSize(5);
}
return setCon;
}
set;
}
public List<Opportunity> getOpportunities() {
return (List<Opportunity>) setCon.getRecords();
}
public List<OppWrapper> getOpportunitiesWithIndex() {
List<Opportunity> opps = this.getOpportunities();
List<OppWrapper> oppsWrapped = new List<OppWrapper>();
Integer idex = 1;
for (Opportunity opp : opps) {
oppsWrapped.add(new OppWrapper(opp, idex));
idex++;
}
return oppsWrapped;
}
public class OppWrapper {
public Opportunity opp { get; set; }
public Integer tabIndex { get; set; }
public OppWrapper(Opportunity opp, Integer tabIndex) {
this.opp = opp;
this.tabIndex = tabIndex;
}
}
}