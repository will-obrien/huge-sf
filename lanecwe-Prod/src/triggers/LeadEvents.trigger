/**
*    Lead trigger logic for Before/After Update Events
*
*    Modification Log
*
*    Deepthi        PGI    10/27/2014      Lead trigger logic for After Update 
**/
trigger LeadEvents on Lead (After Update) {
//if(UserInfo.getName() == 'eCommerce Customer'){
  if(Trigger.isAfter && Trigger.isUpdate && !LeadEventHandler.skipAfterEvent){
     //if(Trigger.isUpdate){
    for(Lead Leaddata : trigger.new){
       if(leaddata.Z_Source__c == 'eCommerce'){     
          LeadEventHandler.leadConversion(Trigger.new);
       }
       LeadEventHandler.skipAfterEvent = true;
    }
  }
}