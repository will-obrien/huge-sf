/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_MassReassignOpportunitiesController {
    static testmethod void testReassign(){
        
        map<Id,String> testUserMap = new map<Id,String>();
        for(User user : [SELECT id,Name FROM User WHERE IsActive = true AND (UserRole.Name = 'OPTIONS Closer Team Lead' OR UserRole.Name = 'OPTIONS Closer') ORDER BY UserRoleId]){
            testUserMap.put(user.Id,user.Name);
        }
        
        System.debug('@@@ inserting test account...');
        
        Account testAccount = new Account();
        testAccount.FirstName = 'Bruce';
        testAccount.LastName = 'Wayne';
        testAccount.PersonEmail = 'bruce.wayne@gotham.com';
        testAccount.Country_List__c = 'United States of America';
        testAccount.RecordTypeId = '012600000005CeK';
        Database.insert(testAccount);
        
        System.debug('@@@ inserted test account.');
        
        System.debug('@@@ inserting test opportunity...');
        
        Opportunity testOpty = new Opportunity();
        testOpty.StageName = 'Discover';
        testOpty.CloseDate = System.today()+1;
        testOpty.AccountId=testAccount.Id;
        testOpty.Name='testOpty';
        testOpty.Type = 'testType';
        insert testOpty;
        
        System.debug('@@@ inserted test opportunity.');
        
        List<Opportunity> opps = [SELECT Id, Name, StageName, CloseDate, AccountId, Type from Opportunity WHERE Id = :testOpty.Id];
        if ((opps != null) && (opps.size() == 1)) {
            System.debug('@@@ Opty fields: ' + opps[0].Id + ', ' + opps[0].Name + ', ' + opps[0].StageName + ', ' + opps[0].CloseDate + ', ' + opps[0].AccountId + ', ' + opps[0].Type);
        }
        
        MassReassignOpportunitiesController controller = new MassReassignOpportunitiesController();
        controller.refreshOptyList();
        controller.filterId = controller.listviewoptions[1].getValue();
        controller.refreshOptyList();
        controller.searchRecord.stageName = 'Discover';
        controller.helperRecord.ClosedDate_From__c=System.today();
        controller.helperRecord.ClosedDate_To__c=System.today()+2;
        controller.helperRecord.From__c=System.today();
        controller.helperRecord.To__c=System.today()+1;
        controller.searchRecord.Type = 'testType';
        controller.refreshOptyListBySearch();
        
       // System.assert(controller.optyList.size()>0);
        
        controller.assignOption = 'User';
        MassReassignOpportunitiesController.cOpty testcopty = new MassReassignOpportunitiesController.cOpty(opps[0]);
        controller.optyList.add(testcopty);
        controller.optyList[0].selected = true;
        controller.helperRecord.Assign_to__c = UserInfo.getUserId();
        controller.Assign();
        
        controller.refreshOptyList();
        controller.filterId = controller.listviewoptions[1].getValue();
        controller.refreshOptyList();
        controller.searchRecord.stageName = 'Discover';
        controller.helperRecord.ClosedDate_From__c=System.today();
        controller.helperRecord.ClosedDate_To__c=System.today()+2;
        controller.helperRecord.From__c=System.today();
        controller.helperRecord.To__c=System.today()+1;
        controller.searchRecord.Type = 'testType';
        controller.refreshOptyListBySearch();
        
       // System.assert(controller.optyList.size()>0);
        MassReassignOpportunitiesController.cOpty testcopty2 = new MassReassignOpportunitiesController.cOpty(opps[0]);
        controller.optyList.add(testcopty2);   
        controller.optyList[0].selected = true;
        
        list<SelectOption> assignOptions = controller.listAssignOptions;
        String currentAssignOption = controller.assignOption;
        controller.assignOption = 'Round Robin';
        
        String testingUserId = null;
        for(String userId : testUserMap.keySet()){
            if(testingUserId == null) testingUserId = userId;
        }
        
        list<SelectOption> availableusers = controller.listAvaliableRoundRobinUsers;
        controller.availableRoundRobinUsers.add(testingUserId);
        controller.addSelectedRoundRobinUser();
        availableusers = controller.listAvaliableRoundRobinUsers;
        availableusers = controller.listSelectedRoundRobinUsers;
        controller.selectedRoundRobinUsers.add(testingUserId);
    }
}