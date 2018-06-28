public with sharing class SendUserEmail {

    public static void sendEmail(User user, String username, Map<String, String> mapBodyParams) {

        List<Messaging.SendEmailResult> listEmailResult = null;
        List<Messaging.Singleemailmessage> listSingleEmailMessages = new List<Messaging.Singleemailmessage>();
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'CommunityForgotPasswordEmailTemplate']; 

        String htmlBody = emailTemplate.HtmlValue;
        String plainBody = emailTemplate.Body;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		// 1/9/15: Fix to send email as the AddUP Org-Wide Email address
		// addup@sierraclub.org in Production
		mail.setOrgWideEmailAddressId('0D2i00000008Pdd');
        //mail.setSenderDisplayName('AddUP');
         
        mail.setReplyTo('noreply@salesforce.com');
        mail.setTargetObjectId(user.id);
        mail.setSubject('AddUP: Your password reset link.');
        //mail.setTemplateId(emailTemplate.id);

        for (String key : mapBodyParams.keySet()) {
            System.debug('\n[SendUserEmail:sendEmail] : Params...: key=' + key + ' and value='+mapBodyParams.get(key));
            if (!String.isEmpty(htmlBody)) {
              htmlBody = htmlBody.replace(key, (mapBodyParams.get(key) == null) ? '' : mapBodyParams.get(key));
            }
            plainBody = plainBody.replace(key, (mapBodyParams.get(key) == null) ? '' : mapBodyParams.get(key));
        }

		// Add in my custom footer email
        if (!String.isEmpty(htmlBody)) {
			htmlBody = htmlBody.replace('{!footerEmail}', user.Email);
        }
        if (!String.isEmpty(plainBody)) {
			plainBody = plainBody.replace('{!footerEmail}', user.Email);
        }
        

        mail.setHtmlBody(htmlBody);
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody(plainBody);
        listSingleEmailMessages.add(mail);
        listEmailResult = Messaging.sendEmail(listSingleEmailMessages);
    }
}