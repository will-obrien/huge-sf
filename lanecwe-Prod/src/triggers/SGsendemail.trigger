trigger SGsendemail on CONMAN_Contract__c (after update) {
 if(Trigger.isAfter && Trigger.isUpdate && SGLeadCreateREST.sendemail) {

     for (CONMAN_Contract__c  cntrctdata : Trigger.new) {
        If(cntrctdata.z_Source__c == 'Salesgateway'){ 
           string cntrctid = cntrctdata.id;
           SGEmailservice.sendsEmail(cntrctdata);
        }
     }
 }
}