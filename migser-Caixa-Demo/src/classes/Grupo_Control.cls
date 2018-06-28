public class Grupo_Control {

	@AuraEnabled

	public static Campaign getCampana(Id campanaId){
		Campaign c;
		try{
			c  = [SELECT Id, Name, Grupo_Control__c FROM Campaign WHERE Id = :campanaId];
		}catch(exception e){
			throw new AuraHandledException('Error recuperando campaña.');
			return  null;
		}
		system.debug('Devolviendo campana:' +c.Id);
		return c;
	}

	@AuraEnabled

	public static Integer setGrupo(Id campanaId, Decimal pct){

		System.debug('Actualizando campaña...');
		if (pct>100) {
			pct=100;
		}
		Campaign c = [SELECT Id, Name, Grupo_Control__c FROM Campaign WHERE Id = :campanaId];
		if (pct!=c.Grupo_Control__c) {
			c.grupo_control__c= pct;
			update(c);
		}

		List<CampaignMember> miembros = [select id, grupo_de_control__c from Campaignmember where campaignid =  :campanaId];
		for (CampaignMember m : miembros) {
			m.grupo_de_control__c=false;
		}
		update(miembros);
		List<Campaignmember> seleccionados = new List<CampaignMember>();
		system.debug('Creando grupo para campana:' +campanaId);
		Integer num = miembros.size();
		Integer resultado = (Integer) Math.floor(num * (pct/100));

		System.debug('Resultado: ' + resultado);

		for (Integer i=0; i<resultado; i++) {

			Integer elegido = Math.round(Math.random()*(miembros.size()-1));	
			System.debug('Elegido: '+elegido);

			CampaignMember m = miembros.get(elegido);
			m.grupo_de_Control__c=true;
			seleccionados.add(m);
			miembros.remove(elegido);

		}

		System.debug('Total Elegidos: ' + seleccionados.size());

		update(seleccionados);

		return seleccionados.size();







	}
	public Grupo_Control() {
		
	}
}