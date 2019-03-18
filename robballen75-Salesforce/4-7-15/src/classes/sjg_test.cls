/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class sjg_test implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		
		
		
		/**
		Integer x_index=0;
		String varsweneed='year1Billing,year2Billing,year3Billing';
		String currentvar='';
		Integer howmany=0;
				
		howmany=varsweneed.split(',').size();
		
		for (x_index=0;x_index<=howmany-1;x_index++){
			currentvar=varsweneed.split(',')[x_index];
			system.debug('var' + currentvar);
			
			if (email.plainTextBody.indexOfIgnoreCase('<' + currentvar +'>')!=-1 && email.plainTextBody.indexOfIgnoreCase('</' + currentvar +'>')!=-1){
				system.debug(email.plainTextBody.substring(email.plainTextBody.indexOfIgnoreCase('<' + currentvar +'>')+currentvar.length()+2,email.plainTextBody.indexOfIgnoreCase('</' + currentvar +'>')).trim());
			}
			
		}
		*/
		/**
		String emailbody=email.plainTextBody;
		system.debug(GetNode('test',emailbody));
		*/
			
    return Null;
    }

			
			
		
		
	
}