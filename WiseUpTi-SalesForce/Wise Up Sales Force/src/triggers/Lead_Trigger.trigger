trigger Lead_Trigger on Lead (after insert, after update) {
     // if(trigger.isAfter && trigger.isUpdate){
        // System.debug('trg__ Lead_Trigger After update - Start - ');
        // if(Triggers__c.getOrgDefaults().Oportunidade_Trigger__c == false)return; //verificar o que est[a acontecendo
        // if(Trigger_Controller.Lead_trigger == false) return;
        // Trigger_Controller.Lead_trigger= false;
        // List<String> leads = new List<String>();
        // for(Lead l : trigger.New){
            // if(l.Status!= trigger.oldMap.get(l.Id).Status)                leads.add(l.Id);
        // }
        // if(leads.size() > 0)ProspectUpdate.futureIntegrateLead(leads);
        // System.debug('trg__ Lead_Trigger After opps - ' + leads);
        // System.debug('trg__ Lead_Trigger After update - End- ');
    // }
}