trigger AttachmentTrigger on Attachment (after insert) {

	System.debug('Iniciando Trigger Attachment');

	Set<ID> ids = Trigger.newMap.keySet();
	System.debug('Número de IDs...'+ids.size());
	List<Attachment> ats = 		[SELECT name 
									FROM Attachment
   							  		WHERE id in :ids and
   							  				parentid = '0015800000328gN'];
   	System.debug('Número de Attachments... ' +ats.size());
   	Set<String> correos = new Set<String>();
   	for (Attachment a : ats ) {
   		correos.add(a.name);
   		System.debug('Correo... ' +a.name);
   	}

   	List<Lead> leads = [SELECT id, Email FROM Lead where Email ='xx4@ab.ab'];
   	System.debug('Número de Leads... ' +leads.size());
	 for (Attachment a : Trigger.new) {
         		System.debug('Attachment: '+a.name);
          //   a.parentid = getLeadId(a.name, leads);
             System.debug('LEad: '+a.parentid);
         
   }

   public static String getLeadId( String correo, List<Lead> ls) {
     String resultado;

      for (Lead l : ls) {
        if (l.Email==correo) { 
    		resultado = l.id;
    		break;
        }
      }
      return resultado;
   }

}