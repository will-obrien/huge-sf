trigger Item_oportunidade_trigger on OpportunityLineItem (after insert) {

    if(trigger.isAfter && trigger.isInsert){
        
        System.debug('trg__ Item_oportunidade_trigger After update - Start - ');
        if(Triggers__c.getOrgDefaults().Oli_trigger__c== false)return; //verificar o que est[a acontecendo
        if(Trigger_Controller.Oli_Controller== false) return;
        Trigger_Controller.Oli_Controller= false;
        List<String> olis = new List<String>();
        for(OpportunityLineItem oli: trigger.New){
            olis.add(oli.Id);            
        }
        if(olis .size() > 0)ProductRequest.futureIntegrateOli(olis);
        System.debug('trg__ Item_oportunidade_trigger After opps - ' + olis);
        System.debug('trg__ Item_oportunidade_trigger After update - End- ');
    }
    
}