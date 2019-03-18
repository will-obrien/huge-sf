public class NoLeadRule {
    public Lead l;
    public void main(Lead ld){
        l = ld;
        Lead newLd = new Lead(id = l.Id);
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = false;
        newLd.setOptions(dmo);
        update newLd;
        
    }
}