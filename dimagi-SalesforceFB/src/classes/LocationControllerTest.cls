/**************************************************
Class Name: OpportunityContractController
Class Description: Class for Location creating from an Opportunity or a Deployment
Author: Virginia Fernández (vfernandez@adooxen.com)
Update Date: 2013-04-10
Additional Comments: 
**************************************************/
@isTest
private class LocationControllerTest {

    static testMethod void oppotunityLocationTest() {
        Account account = new Account();
        account.Name = 'Test';
        insert account;
        
        Business_Unit__c bunit = new Business_Unit__c();
        bunit.Name = 'Test';
        insert bunit; 
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Stage 1 - Connect';
        opp.CloseDate = Date.newInstance(2013, 4, 9);
        opp.Area__c = 'Health';
        opp.Sub_Area__c = 'Food Security';
        opp.AccountId = account.Id;
        opp.Funder_Account__c = account.Id;
        opp.Implementing_Business_Unit__c = bunit.Id;
        opp.Proposal_Dropbox_Location__c = 'proposal';
        opp.X7_Long_term_partnership_or_one_off__c = 'long term';
        opp.X10_Major_component_risks__c = 'risk';
        insert opp;
        
        Country__c country = new Country__c();
        country.Name = 'Test';
        insert country;
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        PageReference oppPage = sc.view();
        Test.setCurrentPageReference(oppPage);
        
        LocationController locationController = new LocationController(sc);
        Test.startTest();
        
        Location__c location = locationController.getLocation();
        location.Name = 'Test';
        location.Country__c = country.Id;
        locationController.setLocation(location);
        
        locationController.newOpportunityLocation();
        
        List<Opportunity_Location__c> oppLocations = [select Id, 
                                                             Location__r.Name,
                                                             Location__r.Country__c 
                                                      from Opportunity_Location__c 
                                                      where Opportunity__c = :opp.Id];
        
        System.assertEquals(oppLocations.size(), 1);
        System.assertEquals(oppLocations[0].Location__r.Name, location.Name);
        System.assertEquals(oppLocations[0].Location__r.Country__c, location.Country__c);
        
        Test.stopTest();
    }
    
    static testMethod void deploymentLocationTest() {
    	Account account = new Account();
        account.Name = 'Test';
        insert account;
        
        Project__c deployment = new Project__c();
        deployment.Name = 'Test';
        deployment.Implementing_Account__c = account.Id;
        insert deployment;
        
        Country__c country = new Country__c();
        country.Name = 'Test';
        insert country;
        
        ApexPages.StandardController sc = new ApexPages.standardController(deployment);
        PageReference deployPage = sc.view();
        Test.setCurrentPageReference(deployPage);
        
        LocationController locationController = new LocationController(sc);
        Test.startTest();
        
        Location__c location = locationController.getLocation();
        location.Name = 'Test';
        location.Country__c = country.Id;
        locationController.setLocation(location);
        
        locationController.newDeploymentLocation();
        
        List<Project_Location__c> deployLocations = [select Id, 
                                                             Location__r.Name,
                                                             Location__r.Country__c 
                                                      from Project_Location__c 
                                                      where Project__c = :deployment.Id];
        
        System.assertEquals(deployLocations.size(), 1);
        System.assertEquals(deployLocations[0].Location__r.Name, location.Name);
        System.assertEquals(deployLocations[0].Location__r.Country__c, location.Country__c);
        
        Test.stopTest();
    }
}