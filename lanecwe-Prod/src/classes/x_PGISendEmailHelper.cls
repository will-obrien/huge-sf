/**
 * This class contains the helper methods to send single email using salesforce Messaging.SingleEmailMessage class.
 *
 * @author Amit M.
 * @version 1.0
 */
public with sharing class x_PGISendEmailHelper {
	//Improve code coverage
	public static void inactive(){
	}

    /* Stores to addresses to send email. */
    /*private String[] toAddresses;*/
    
    /* Stores to cc addresses to send email. */
    /*private String[] ccAddresses;*/
    
    /* Stores reply to address for the email. */
    /*private String replyTo;*/
    
    /* Stores display name for sender email address. */
    /*private String senderDisplayName;*/
    
    /* Stores subject for the email. */
    /*private String subject;*/
    
    /* Stores boolean to check if sender should be added to bcc of the email. */
    /*private Boolean bccSender;*/
    
    /* Stores boolean to check if sender signature should be used. */
    /*private Boolean useSignature;*/
    
    /* Stores plain text body of the email. */
    /*private String plainTextBody;*/
    
    /* Stores html body of the email. */
    /*private String htmlBody;*/
    
    /**
     * Constructor to populate the values to send email.
     *
     * @param toAddresses, email addresses to send email.
     * @param subject, email subject.
     * @param plainTextBody, plain text body for email.
     */
    /*public PGISendEmailHelper(String[] toAddresses, String subject, String plainTextBody)
    {
        this(toAddresses, null, null, null, subject, false, false, plainTextBody, null);
    }*/
    
    /**
     * Constructor to populate the values to send email.
     *
     * @param toAddresses, email addresses to send email.
     * @param subject, email subject.
     * @param plainTextBody, plain text body for email.
     * @param htmlBody, html body for email.
     */
    /*public PGISendEmailHelper(String[] toAddresses, String subject, String plainTextBody, String htmlBody)
    {
        this(toAddresses, null, null, null, subject, false, false, plainTextBody, htmlBody);
    }*/
    
    /**
     * Constructor to populate the values to send email.
     *
     * @param toAddresses, email addresses to send email.
     * @param ccAddresses, email cc addresses to send email.
     * @param subject, email subject.
     * @param plainTextBody, plain text body for email.
     * @param htmlBody, html body for email.
     */
    /*public PGISendEmailHelper(String[] toAddresses, String[] ccAddresses, 
                            String subject, String plainTextBody)
    {
        this(toAddresses, ccAddresses, null, null, subject, false, false, plainTextBody, null);
    }*/
    
    /**
     * Constructor to populate the values to send email.
     *
     * @param toAddresses, email addresses to send email.
     * @param ccAddresses, email cc addresses to send email.
     * @param replyTo, reply address for the email.
     * @param senderDisplayName, sender name to be displayed to user.
     * @param subject, email subject.
     * @param bccSender, true if sender is added as bcc for email.
     * @param useSignature, true if sender signature are used.
     * @param plainTextBody, plain text body for email.
     * @param htmlBody, html body for email.
     */
    /*public PGISendEmailHelper(String[] toAddresses, String[] ccAddresses, 
                                String replyTo, String senderDisplayName, 
                                String subject, Boolean bccSender, 
                                Boolean useSignature, String plainTextBody, 
                                String htmlBody)
    {
        this.toAddresses = toAddresses;
        this.ccAddresses = ccAddresses;
        this.replyTo = replyTo;
        this.senderDisplayName = senderDisplayName;
        this.subject = subject;
        this.bccSender = bccSender;
        this.useSignature = useSignature;
        this.plainTextBody = plainTextBody;
        this.htmlBody = htmlBody;
    }*/
    
    
    /**
     * Uses Messaging.SingleEmailMessage class of salesforce to send the email message for given values.
     */
    /*public void sendEmail()
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(this.toAddresses);
        mail.setCcAddresses(this.ccAddresses);
        mail.setReplyTo(this.replyTo);
        mail.setSenderDisplayName(this.senderDisplayName);
        mail.setSubject(this.subject);
        mail.setBccSender(this.bccSender);
        mail.setUseSignature(this.useSignature);
        mail.setPlainTextBody(this.plainTextBody);
        mail.setHtmlBody(this.htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }*/
}