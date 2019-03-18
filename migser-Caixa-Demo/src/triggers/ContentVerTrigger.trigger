trigger ContentVerTrigger on ContentVersion (after insert) {
  //select LinkedEntityId, ContentDocumentId ,ShareType FROM ContentDocumentLink where LinkedEntityId = '0015800000AFgRxAAL'
  //select id , title from contentdocument where id = '06958000000AKfIAAW'
  //select id, ContentSize, FileType, FIleExtension , PathOnClient , VersionData from contentversion where ContentDocumentId = '06958000000AKfIAAW'
	Set<ID> ids = Trigger.newMap.keySet();
   	system.debug('FICHERO NUEVO...');	
   	List<ContentVersion> covers = [SELECT id, ContentSize, FileType, FIleExtension , title, 
   										PathOnClient , VersionData, ContentDocumentId
   							  FROM ContentVersion WHERE 
   							  id in :ids and FileType='JPG'];

   	Set<ID> cdocument_ids = new Set<ID>();

   	for (ContentVersion cv : covers) {
   		if (cv.Title.startsWith('Photo')) {
   			cdocument_ids.add(cv.ContentDocumentId);
   		} 
   	}
	
	Map<ID,contentDocumentLink> cdocumentlinks = new Map<ID, ContentDocumentLink>([SELECT Id, LinkedEntityId, ContentDocumentId
														 FROM ContentDocumentLink
														 where ContentDocumentId in :cdocument_ids]);

	for (ContentVersion cv : covers) {
		system.debug('FICHERO NUEVO...');		
		system.debug('Tamaño: '+cv.contentsize);
		system.debug('Nombre: '+cv.Title);
		system.debug('Entidad: '+cdocumentlinks.get(cv.ContentDocumentId).LinkedEntityId);

	}
	

}