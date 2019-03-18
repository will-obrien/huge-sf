trigger ContentDocTrigger on ContentDocument (after insert) {

	 for (ContentDocument cd : Trigger.new) {
	 	system.debug('NUEVO DOCUMENTO...' + cd.Title);
	 	contentversion doc = [select id, ContentSize, FileType, FIleExtension , PathOnClient , VersionData 
	 	from contentversion where ContentDocumentId = :cd.id limit 1];
	 	system.debug('Tamaño...'+doc.ContentSize);

	 }

}