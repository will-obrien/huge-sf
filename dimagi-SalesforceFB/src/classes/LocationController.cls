/**************************************************
Class Name: LocationController
Class Description: Class for Location creating from an Opportunity or a Deployment
Author: Virginia Fernández (vfernandez@adooxen.com)
Update Date: 2013-04-10
Additional Comments: 
**************************************************/
public with sharing class LocationController {

    private String objId = null;
    private ApexPages.StandardController sc;
    private Location__c location = null;

    public LocationController(ApexPages.StandardController sc) {
        objId = sc.getId();
        this.sc = sc;
        location = new Location__c();
    }

    public Location__c getLocation() {
        return location;
    }

    public void setLocation(Location__c location) {
        this.location = location;
    }

    public PageReference newOpportunityLocation() {
        insert location;
        
        Opportunity_Location__c oppLocation = new Opportunity_Location__c();
        oppLocation.Location__c = location.Id;
        oppLocation.Opportunity__c = objId;
        insert oppLocation;

        PageReference oppPage = sc.view();
        oppPage.setRedirect(true);
        return oppPage;
    }

    public PageReference newDeploymentLocation() {
        insert location;

        Project_Location__c projLocation = new Project_Location__c();
        projLocation.Location__c = location.Id;
        projLocation.Project__c = objId;
        insert projLocation;

        PageReference oppPage = sc.view();
        oppPage.setRedirect(true);
        return oppPage;
    }
}