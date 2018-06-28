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
private class test_ganttcontroller {

    static testMethod void test_ganttcontroller() {
        
        Account test_account = new Account();
        test_account.Name = 'TEST ACCOUNT';
        test_account.BillingStreet = 'TEST STREET';
        test_account.BillingCity = 'TEST CITY';
        test_account.BillingState = 'California';
        test_account.BillingPostalCode = '90210';
        test_account.BillingCountry = 'United States';
        test_account.Account_Number__c='2345678';
        
        insert test_account;
        
        System.debug('ACCOUNT ID: ' + test_account.Id);
        
        Project__c test_project = new Project__c();
        test_project.Account__c = test_account.Id;
        test_project.Description__c = 'TEST PROJECT';
        test_project.Start_Date__c = Date.today();
        test_project.Stop_Date__c = Date.today().addDays(30);
        test_project.Status__c = 'Implementation';
        test_project.Percent_Complete__c = 5.0;
        test_project.Allocated_Budget__c = 10000.00;
        test_project.Allocated_Hours__c = 200;
        test_project.Allocated_Days__c = 30;
        test_project.Stage__c='Turnover';
        insert test_project;
        System.debug('PROJECT ID: ' + test_project.Id);
        
        Id task_recordtype_id = [SELECT Id FROM RecordType WHERE Name = 'Project Task' 
                    AND SObjectType = 'Project_Task__c' LIMIT 1][0].Id;
        
        Project_Task__c test_task = new Project_Task__c();
        test_task.Name = 'TEST TASK'; 
        test_task.Start_Date__c = Date.today().addDays(2);
        test_task.Due_Date__c = Date.today().addDays(15);
        test_task.Percent_Complete__c = 15.0;
        test_task.Project__c = test_project.Id;
        test_task.RecordTypeId = task_recordtype_id;
        insert test_task;
        System.debug('TASK ID: ' + test_task.Id);
        
        Project_Task__c test_subtask = new Project_Task__c();
        test_subtask.Project__c = test_project.Id;
        test_subtask.Name = 'TEST SUBTASK'; 
        test_subtask.Start_Date__c = Date.today().addDays(14);
        test_subtask.Due_Date__c = Date.today().addDays(27);
        test_subtask.Percent_Complete__c = 3.0;
        test_subtask.Parent_Task__c = test_task.Id;
        test_subtask.RecordTypeId = task_recordtype_id;
        insert test_subtask;
        
        System.debug('SUBTASK ID: ' + test_subtask.Id);
        
        ApexPages.StandardController sc = new ApexPages.Standardcontroller(test_project);

        System.debug('PROJECT ID: ' + sc.getId());

        gantt_controller test_gc = new gantt_controller(sc);
        
        test_gc.getdata();
        
        System.debug(test_gc.getnew_task_link());
        
        test_gc.currently_selected_task = '1';
        test_gc.new_subtask();
        test_gc.task_assign();
        
        test_gc.currently_selected_task = '2';
        test_gc.new_start_date = '2011.08.01 0.0';
        test_gc.new_end_date = '2011.08.30 0.0';
        test_gc.changed_task = '##2##Sun Mar 01 2011##Sun Mar 30 2011##30';
        
        test_gc.new_subtask();
        test_gc.task_assign();
        test_gc.task_detail();
        test_gc.task_edit();
        test_gc.task_save();
        test_gc.task_delete();
        
        test_gc.currently_selected_task = '3';
        test_gc.new_start_date = '2011.08.01 0.0';
        test_gc.new_end_date = '2011.08.30 0.0';
        test_gc.changed_task = '##2##Sun Dec 01 2011##Sun Dec 30 2011##30';
        test_gc.task_save();
        System.debug(test_gc.getview_revisions_link());
    }
}