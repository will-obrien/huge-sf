global class CreateContactFrmEmail implements Messaging.InboundEmailHandler {
     global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
         Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
         
         Contact con = new Contact();
         con.FirstName = email.fromname.substring(0,email.fromname.indexOf(' '));
         con.LastName = email.fromname.substring(email.fromname.indexOf(' '));
        // con.From__c = email.fromAddress;
          // con.Description = email.plainTextBody;
           con.body__c= email.htmlBody;
           con.Subject__c = email.subject;
         insert con;
         System.debug('##### '+con.id);
         
         if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                     for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                       Attachment attachment = new Attachment();
                       // attach to the newly created contact record
                       attachment.ParentId = con.Id;
                       attachment.Name = email.binaryAttachments[i].filename;
                       attachment.Body = email.binaryAttachments[i].body;
                       insert attachment;
                     }
               }
         
         return result;
     }
 }