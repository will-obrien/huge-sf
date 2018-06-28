/*********************************************************************************************************
Name              : CallReportExtension
Last Modified By  : Dipika Gupta (Appirio JDC)
Last Modified Date: Feb 7, 2013
Description       : Extension class for page used to create/Edit new task
Updated			  : VB : 2017/2/20 - Added Next Steps field support
					JL: 2017/7/24 - Added XXXX field support
***********************************************************************************************************/
public class CallReportExtension {
    public Task t {get;set;}
    public Call_Report__c call {get;set;}
    private String returnUrl;
    public boolean sendNotification{get;set;}
    public boolean detailPage {get;set;}

    //Constructor
    public callReportExtension(ApexPages.StandardController c) {
        t = (Task) c.getRecord();
        returnUrl = ApexPages.currentPage().getParameters().get('retURL');
        if(t.Id == null){
            list<String> listSplits = returnUrl.split('/');
            if(listSplits.get(listSplits.size()-1).startsWith('003')){
                t.whoId = listSplits.get(listSplits.size()-1);
            }
            else if(listSplits.get(listSplits.size()-1).startsWith('001')){
                t.whatId = listSplits.get(listSplits.size()-1);
                
            }
            else if(listSplits.get(listSplits.size()-1).startsWith('006')){
                t.whatId = listSplits.get(listSplits.size()-1);
            } 
            else{
                t.whoId = null;
                t.whatId= null;
            }
            t.OwnerId = UserInfo.getUserId();
            t.Subject = 'Contact Report';
            t.Status='Completed';
            t.ActivityDate = Date.today();
            call = new Call_Report__c();
            //call.Account__c= listSplits.get(listSplits.size()-1);
            //Set the record type for the user
            t.RecordTypeId=Schema.SObjectType.Task.RecordTypeInfosByName.get('Contact Report').RecordTypeId;
        }
        else{
            t = [SELECT Subject, OwnerId ,Status,ActivityDate, WhoId, WhatId, Priority,CreatedDate,lastModifiedDate, Overview__c, Description
                 FROM Task WHERE Id = :t.Id];
            list<Call_Report__c> listcall = [SELECT Id, Parent_Task__c, X501_c_3_Discussion__c,X501_c_4_Discussion__c, X527_Voter_Education_Discussion__c,
                            SCIA_Discussion__c, SCPC_Pol_Cmte_Discussion__c, Call_Type__c,
                            Philanthropic_Goals__c, Donor_Background__c, Gift_and_Financial_Planning__c, Assets__c,
                            Next_Steps__c, Gift_of_Assets_Conversation__c
                            from Call_Report__c  where Parent_Task__c = :t.Id];
            if(listCall.size()>0){
                call = listCall.get(0);
            }
            else{
                call = new Call_Report__c();
            }

        }

    }

    //save task changes
    public PageReference saveAction() {
        if(t.Id == null){
            Database.DMLOptions dmlo = new Database.DMLOptions();
            dmlo.EmailHeader.triggerUserEmail = sendNotification;
             system.debug('----------'+database.insert(t, dmlo));
        }
        else{
            Database.DMLOptions dmlo = new Database.DMLOptions();
            dmlo.EmailHeader.triggerUserEmail = sendNotification;
            database.update(t, dmlo);
        }
        if(call.Id == null){
            call.Parent_Task__c = t.Id;
            insert call;
        }
        else{

            update call;
        }
        system.debug('----------'+t);
        return new PageReference('/'+t.Id);

    }

    //Redirect user to list view
    public PageReference cancel(){
      return new PageReference('/'+t.Id);  
    }

    public void changeCallType(){}

}