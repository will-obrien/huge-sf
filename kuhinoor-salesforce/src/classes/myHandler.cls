global class myHandler implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          outbox__c out = new outbox__c();
          out.firstname__c = email.fromname.subString(0,email.fromname.indexOf(' '));
          out.lastname__c=email.fromname.subString(email.fromname.indexOf(' '));
          out.from__c=email.fromaddress;
          out.subject__c=email.subject;
          out.body__c=email.htmlBody;
          insert out;
            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                      for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                        Attachment attachment = new Attachment();
                        // attach to the newly created contact record
                        attachment.ParentId = out.Id;
                        attachment.Name = email.binaryAttachments[i].filename;
                        attachment.Body = email.binaryAttachments[i].body;
                        insert attachment;
                      }
                }
          
          return result;
      }
  }