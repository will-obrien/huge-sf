/**
 * Just a datatype to encapsulate data from a FogBugzCase.
 */
public with sharing class FogBugzCase {

    public String title { get;set; }
    public String project { get; set; }
    public String area { get;set; }
    public String assignedTo { get;set; }
    public String client { get; set; }
    public String status { get; set; }
    public Integer priority { get; set; }
    public Integer dealSize { get;set; }
    public Decimal probability { get;set; }
    public String externalBugID { get;set; }
    public String caseId { get; set; }
    public Datetime lastModifiedDate { get; set; }
    public String latestEvent { get; set; }
    public String ixPersonOpenedBy { get; set; }
    public Decimal hrsElapsed { get; set; }
}