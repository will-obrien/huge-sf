/**
*   Created By  :   
*   Description :   Apex based REST API which exposes POST method to send Email
*/
@RestResource(urlMapping='/sendExcelmail/*')
Global class GETExcelSheetContent{
     @HttpPost
    global static void sendEmail(String EmailIdCSV, String Subject, String body,String urlForReport) {
        OrgWideEmailAddress orgWideAddress= [select Id from OrgWideEmailAddress where 
                                              Address = 'dimagi-salesforce@dimagi.com' limit 1];

        List<String> EmailIds = EmailIdCSV.split(';');
        
        PageReference ref = new PageReference(urlForReport + '&excel=1&details=yes');
        Blob b;
        if (Test.IsRunningTest()) {
        	b = Blob.valueOf('UNIT.TEST');
   		} else {
        	b = ref.getContent();
        	ref.getContent();
   		}
        
        String output = b.toString();
        System.debug('Check file content: '+output);
        
        output = output.substring(output.indexOf('<body>')+6);  //remove leading html content
        output = output.substring(0,output.indexOf('</body>'));

        Blob excelbody = Blob.valueOf(output);

        

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1.setContentType('application/vnd.ms-excel');
        efa1.setFileName('report.csv');
        efa1.setInline(false);
        efa1.setBody(excelbody);

        String addresses;
        email.setUseSignature(false);
        email.setSubject(Subject);
        email.setToAddresses( EmailIds  );
        email.setHtmlBody(Body);
        email.setOrgWideEmailAddressId(orgWideAddress.Id);
        //email.setSenderDisplayName('Dimagi Reporter');
        email.setSaveAsActivity(false);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

    }

    
}