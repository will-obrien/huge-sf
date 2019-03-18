trigger SGLeadEvents on Lead (Before insert, After insert, Before Update, After Update) {
  /*** for salesgateway***/ 
  if(((Trigger.isAfter && Trigger.isInsert)||(Trigger.isAfter && Trigger.isUpdate)) && !SGLeadEventHandler.skipexecution) {
     for (Lead NewLead : Trigger.new) {
        If(NewLead.z_Source__c == 'Salesgateway'){ 
           SGLeadEventHandler.leadConversion(Trigger.new);
           SGLeadEventHandler.skipexecution = true; 
        }
     }
  }
}