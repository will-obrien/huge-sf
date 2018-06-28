trigger SGContractAccept on Attachment (after insert,after update) {
    List<CONMAN_Contract__c> contractList = new List<CONMAN_Contract__c>();
    CONMAN_Contract__c ctrctdata = new CONMAN_Contract__c();
    Set<id> contractids = new Set<id>();
    if(Test.isRunningtest()) {
        if(Trigger.new[0].Description == 'run only for SG'){
            ctrctdata = [select z_source__c from CONMAN_Contract__c where id = :trigger.New[0].ParentId];
        } 
        else {
            ctrctdata.z_source__c = 'skiprun';
        }
    } 
    else {
        try {
            ctrctdata = [select z_source__c from CONMAN_Contract__c where id = :trigger.New[0].ParentId];
        } catch (QueryException e) {
            ctrctdata.z_source__c = 'skiprun';
        }       
    }
    
    String currentUser = UserInfo.getName();
    System.debug('currentUserName: ' + currentUser);
    
    if (ctrctdata.z_source__c == 'Salesgateway' && currentUser == 'eCommerce Customer') { 
    for(Attachment att : trigger.New){
        //Check if added attachment is related to CONMAN_Contract__c or not
        if(att.ParentId.getSobjectType() == CONMAN_Contract__c.SobjectType) {
            contractids.add(att.ParentId);
         }
    }
    
    contractList = [SELECT id,Contract_Status__c,Contract_URL__c, SlesgatewayID__c,Account_Name__r.id FROM CONMAN_Contract__c WHERE id IN :contractids];
    System.debug('contractList: ' + contractList);
    List<CONMAN_Contract__c> updatecontract = new List<CONMAN_Contract__c>();

    if(contractList!=null && contractList.size()>0) {
       for(CONMAN_Contract__c contractin :contractList) {
           contractin.Contract_Status__c = 'Customer Accepted';
           contractin.Contract_URL__c    = ''; 
           updatecontract.add(contractin);
       }
       SGLeadCreateREST.sendemail = true;
       update updatecontract;
       SGLeadCreateREST.sendemail = false;
          
       list<account> updateacct = new list<account>();
       list<opportunity> updateoppty = new list<opportunity>();
 
       for(CONMAN_Contract__c cmcontract : contractList) {
           try {
               account accttoupdate = [select Status__c,(select id,Opp_Stage__c,Prob_Input__c from Opportunities ) 
                                   from account where id = :cmcontract.Account_Name__r.id and Status__c!= 'Customer'
                                   and SlesgatewayID__c!= null];
               accttoupdate.Status__c = 'Customer';
               updateacct.add(accttoupdate);
               opportunity opptytoupdate = accttoupdate.Opportunities;
               updateoppty.add(opptytoupdate);
               
           } catch (QueryException q) {
               System.debug(q.getMessage());
           }
           
       }
       update updateacct;
       update updateoppty;
    }
  }
}