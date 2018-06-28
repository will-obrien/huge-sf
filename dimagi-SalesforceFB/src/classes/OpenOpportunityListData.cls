/**
 *
 * @author  Fernando Rodriguez (frodriguez@adooxen.com)
 * @date    01/16/2012
 *
 */
 public with sharing class OpenOpportunityListData {

    public String stageName { get; set;}
    public Opportunity[] opportunities { get; set;} 

    public OpenOpportunityListData(String stageName, Opportunity[] opportunities) {
        this.opportunities = opportunities;
        this.stageName = stageName;
    }
}