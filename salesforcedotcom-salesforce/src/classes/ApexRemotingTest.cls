global with sharing class ApexRemotingTest {
// 0.30
    public String caseNumber { get; set; }
    public static Case c { get; set; }
    public ApexRemotingTest() { } // empty constructor 
    
    
    @RemoteAction
    global static Case getCase(String caseNumber) {
        c= [SELECT Id,Subject FROM Case WHERE CaseNumber= :caseNumber];
        return c;
    }
}
