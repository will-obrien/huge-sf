trigger UpdOppTrigger on Opportunity (after update) {
    Set<ID> ids = Trigger.newMap.keySet();
    List<Opportunity> opps = [SELECT Id, Type_of_WIC_financing__c, ownerid
                              FROM Opportunity WHERE 
                              id in :ids];
    Attachment a = [select parentid, name, body, contenttype 
    				from attachment where name = 'Contrato_linea_de_credito.pdf' limit 1];
    List<Attachment> ins_atts = new List<Attachment>();

    for (Opportunity o : opps) {
    	if ((o.Type_of_WIC_financing__c == 'Línea de crédito') && (Trigger.oldMap.get(o.Id).Type_of_WIC_financing__c!='Línea de crédito')) {
    	  Attachment att = new Attachment(name = a.name, body = a.body, 
          parentid = o.Id, contenttype=a.contenttype, isprivate=false, ownerid=o.ownerid);
          System.debug('Actualización de estado: OK');
       //  insert att;
          ins_atts.add(att);
    	}

    }

    insert ins_atts;
    
}