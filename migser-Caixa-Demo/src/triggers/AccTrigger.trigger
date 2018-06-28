trigger AccTrigger on Account (before update) {

	System.debug('Actualizando Account...');


	for( Account a : Trigger.new ) {
		System.debug(Trigger.oldMap.get( a.id ).dni_ocr__c );
		System.debug(a.dni_ocr__c );
  		if( Trigger.oldMap.get( a.id ).dni_ocr__c != a.dni_ocr__c ) {
  			System.debug('Leyendo DNI!!!');
	    	HttpRequest req = new HttpRequest(); 
  			String license = 'C6B3C8E4-DDD1-46AD-9A16-910B0127752B';
  			String username = 'MSERRANO';
  			req.setMethod('POST');
  			ContentDocumentLink  cdl = [select LinkedEntityId, ContentDocumentId ,ContentDocument.ContentModifiedDate, ShareType 
  									FROM ContentDocumentLink where LinkedEntityId = :a.id
  									order by ContentDocument.ContentModifiedDate desc 
  									limit 1];
  			ContentVersion doc = [select id, ContentSize, FileType, FIleExtension , PathOnClient , VersionData 
  									from contentversion 
  									where ContentDocumentId = :cdl.ContentDocumentId
  									limit 1];
  			  req.setHeader('content-type', 'application/json');
			  req.setHeader('Content-Length',String.valueof(doc.ContentSize));
			  req.setEndpoint( 'http://www.ocrwebservice.com/restservices/processDocument?language=spanish&gettext=true');
			  req.setHeader('Authorization','Basic ' + EncodingUtil.base64Encode(Blob.valueof(username+':'+license))); 
			  req.setBodyAsBlob(doc.VersionData); 	
			  Http http = new Http();
			  try {
			        System.debug('Lanzando request!!');
			        HTTPResponse res = http.send(req);	
			        
			        System.debug(res.toString());
			        String ocr = res.getBody();
			        System.debug(ocr);
			        System.debug('STATUS:'+res.getStatus());
			        System.debug('STATUS_CODE:'+res.getStatusCode());

			        String texto = parseaDNI(ocr);

			        System.debug('Texto parsseado: '+ texto);

			     //   a.DNI_Texto__c = texto;
			        
			        String lugarnac = busca(texto,'NACIMIENTO','PROVINCIA',0,0);
			        a.DNI_Lugar_Nacimiento__c= lugarnac;
			        System.debug('Lugar Nacimento: "'+ lugarnac+'"');

			        Integer desde = texto.indexOfIgnoreCase('PROVINCIA');
			        String provincianac = busca(texto,'PROVINCIA','HIJO',desde,14);
			        a.DNI_Provincia_Nacimiento__c = provincianac;
			        System.debug('Prov Nacimento: "'+ provincianac+'"');

			        desde = texto.indexOfIgnoreCase('HIJO');
			        String domicilio = busca(texto,'DOMICILIO','LUGAR',desde,0);
			        a.DNI_Domicilio__c = domicilio;
			        System.debug('Domicilio: "'+ domicilio+'"');

			        desde = texto.indexOfIgnoreCase('LUGAR');
			        String lugardomicilio = busca(texto,'LUGAR ','PROVINCIA',desde,0);
			        a.DNI_Ciudad_Domicilio__c = lugardomicilio;
			        System.debug('Ciudad Domicilio : "'+ lugardomicilio+'"');

			        String proviciadom = busca(texto,'PROVINCIA ','EQUIPO',desde,0);
			        a.DNI_Provincia_Domicilio__c = proviciadom;
			        System.debug('PRov Domicilio: "'+ proviciadom+'"');	

										
			      } catch(System.CalloutException e) {
					System.debug(e);
			      }		
	  	
	  }

	}

	public static String parseaDNI(String input) {
		JSONParser parser = JSON.createParser(input.remove('[[').remove(']]'));
		String resultado ='';
		while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'OCRText')) {
                parser.nextToken();
                resultado = parser.getText();
                break;
            }
        }
        return resultado;
	}
	public  static String busca(String texto, String t1, String t2, Integer desp, Integer long1) {
			Integer i1 = texto.indexOfIgnoreCase(t1,desp);
			Integer l1;
			String resultado ='';
			if (i1>-1) {
				if (long1==0) {
					l1=t1.length();
				} else {
					l1=long1;
				}
				Integer i2 = texto.indexOfIgnoreCase(t2,i1);
				if (i2>-1) {
					resultado = texto.substring(i1+l1,i2).trim();
				}
			}
				System.debug('RESULTADO: "'+resultado+'"');
				return resultado;
	}
	 
}