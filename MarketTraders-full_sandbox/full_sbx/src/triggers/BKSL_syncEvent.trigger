trigger BKSL_syncEvent on BKSL2__Service_Request__c (before insert, after insert, after update){
    BKSL_SyncServiceRequest handlerClass = new BKSL_SyncServiceRequest();
    if(Trigger.isInsert){
        
        for(BKSL2__Service_Request__c objServiceRequest : Trigger.new ){
            if(Trigger.isBefore){
                if(objServiceRequest.Opportunity__c == null){
                    objServiceRequest.Appointment_Owner__c = Label.OPPOWID;
                }
                   /* list<OpportunityContactRole> oppConRole = [SELECT Id,OpportunityId,ContactId FROM OpportunityContactRole WHERE OpportunityId =:objServiceRequest.Opportunity__c];
                    system.debug('BKSL_CreateOppurtunity oppConRole'+oppConRole);
                    if(oppConRole.size() == 0){
                        OpportunityContactRole oppCont = new OpportunityContactRole();
                        oppCont.ContactId = objServiceRequest.BKSL2__Contact__c;
                        oppCont.OpportunityId = objServiceRequest.Opportunity__c;
                       // insert oppCont;
                        system.debug('BKSL_CreateOppurtunity oppCont'+oppCont);
                    }*/
            }
            if(Trigger.isAfter){
                handlerClass.afterInsertServiceRequestHandler(objServiceRequest);
            }
        }
    }
    if(Trigger.isUpdate){
        for(BKSL2__Service_Request__c objServiceRequest : Trigger.new ){
            handlerClass.afterUpdateServiceRequestHandler(objServiceRequest);
        }
    }
}