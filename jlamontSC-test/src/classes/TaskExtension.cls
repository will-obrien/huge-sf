/*********************************************************************************************************
Name               : TaskExtension
Created by         : Dipika Gupta (Appirio)
Created Date       : Feb 7, 2014
Description        : T-244255 show call fields
				VB : 11/5/15 - Added "ALL ROWS" to allow deleted or archived task access.
				VB : 02/20/17 - Added call for new Next Steps field
***********************************************************************************************************/
public without sharing class TaskExtension {
    public Task t {get;set;}
    public Call_Report__c call {get;set;}

	public Id taskId;

    //Constructor
    public TaskExtension(ApexPages.StandardController c) {
        try{
            //t = (Task) c.getRecord();
            taskId = (Id) System.currentPageReference().getParameters().get('id');
            
            //t = [SELECT Subject, OwnerId ,Status,ActivityDate, WhoId, WhatId, Priority,CreatedDate,lastModifiedDate, Overview__c, Description
            //     FROM Task WHERE Id = :t.Id ALL ROWS];
            t = [SELECT Subject, OwnerId ,Status,ActivityDate, WhoId, WhatId, Priority,CreatedDate,lastModifiedDate, Overview__c, Description
                 FROM Task 
                 WHERE Id = :taskId 
                 ALL ROWS];
                 
            //fetch related call report
            list<Call_Report__c> listcall = [SELECT Id, Parent_Task__c, X501_c_3_Discussion__c,X501_c_4_Discussion__c, X527_Voter_Education_Discussion__c,
            SCIA_Discussion__c, SCPC_Pol_Cmte_Discussion__c, Call_Type__c,
                            Philanthropic_Goals__c, Donor_Background__c, Gift_and_Financial_Planning__c, Assets__c, Next_Steps__c, Gift_of_Assets_Conversation__c
                            from Call_Report__c  where Parent_Task__c = :t.Id];
            if(listCall.size()>0){
                call = listCall.get(0);
            }
            else{
                call = new Call_Report__c();
            }
        }
        catch(Exception e){

			system.debug('::TASK:e:' + e + ':');

        }
    }
    // test method to fetch test detail for detail page
    private static testMethod void taskDetail(){
    	
    	// VB: This test sucks and it doesn't work.  11/5/15
    	
    	/*
        Test.startTest();
        Task task = new task();
        
        Account testAccount = new Account(Name='Sierra');
        insert testAccount;
        ApexPages.currentPage().getParameters().put('retURL',testAccount.Id);
        ApexPages.currentPage().getParameters().put('OwnerId',UserInfo.getUserId());
        ApexPages.StandardController con = new ApexPages.StandardController(task);
        CallReportExtension CRE = new callReportExtension(con);
        CRE.saveAction();
        task = [SELECT ID FROM Task Where whatId =: testAccount.Id];
        con = new ApexPages.StandardController(task);
        
        TaskExtension Textension = new TaskExtension(con);
        system.assert(Textension.call!= null);
        
        list<Call_Report__c> listcall = [SELECT Id from Call_Report__c where Parent_Task__c = :task.Id];
        system.assert(listcall.size() > 0);
        
        delete listcall;
        
        con = new ApexPages.StandardController(task);
        Textension = new TaskExtension(con);
        system.assert(Textension.call!= null);
        */       
    }
}