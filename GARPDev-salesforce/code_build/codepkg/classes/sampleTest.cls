public class sampleTest    
{
     
      public sampleTest()
      {
            List<Messaging.EmailFileAttachment> lstEmailAttachments = new List<Messaging.EmailFileAttachment>();
String strDomesticExcelBodyString =  'TEST1\tTest2\ttest3';
            Blob DomesticExcellBlob = Blob.valueof('Value1\tValue2\tValue3');
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('domestic.xls');
            system.debug('DomesticExcellBlob == '+DomesticExcellBlob.toString());
            attachment.setBody(DomesticExcellBlob);
            lstEmailAttachments.add(attachment);
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setFileAttachments(lstEmailAttachments);
        mail.setToAddresses(new String[] {'vvkathi@gmail.com'});
        mail.setReplyTo('vvkathi@gmail.com');
        mail.setSenderDisplayName('Batch XML Files');
        mail.setSubject('XML Files');
        mail.setPlainTextBody('');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
      }
             

}