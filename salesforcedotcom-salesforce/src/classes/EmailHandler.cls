global class EmailHandler implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          System.debug('APEX>CUSTOMEMAILHANDLER>HANDLEINBOUNDEMAIL');
          return result;
      }
  }