public with sharing class DS_Recipe_Sender_View_Controller {

    // Send an envelope for embedded signing using a 
    // Sender View for document uploading and tagging
    // Copyright (c) 2016 DocuSign, Inc. 
    // LICENSE: The MIT License, see https://opensource.org/licenses/MIT

    // SETTINGS
    Private static string integration_key = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
    Private static string account_id =      'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'; 
        // NOTE: You MUST use the long form of the account id. It has 32 digits 
        // with 4 dashes (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx). 
        // This version of the account id is shown in the APIs and Connects section
        // of your DocuSign Administration tool


    // Input parameters
    Public string signer_email {get;set;}      // Required
    Public string signer_name {get;set;}       // Required
    Public string sender_return_url {get;set;} // Required. Where DS redirects to after sending  
    Public string signer_user_id {get;set;}    // Required when using embedded signing
    
    // Output
    Public string output {get;set;}
    Public string envelope_id {get;set;}
    Public string sender_view_url {get;set;} // Redirect to this url  
    Public string error_code {get;set;}      // Null means no error
    Public string error_message {get;set;}

    // Using Legacy authentication via an SFDC Named Credential
    Private static string ds_server = 'callout:DocuSign_Legacy_Demo/api/3.0/dsapi.asmx';
    // If you choose to not use a named credential:
    // Private static string ds_server = 'https://demo.docusign.net/api/3.0/dsapi.asmx';
    
    Private static string trace_value = 'SFDC_002_SOAP_sender_view'; // Used for tracing API calls
    Private static string trace_key = 'X-ray';
    Private DocuSignTK.APIServiceSoap api_sender = new DocuSignTK.APIServiceSoap();

	Public DS_Recipe_Sender_View_Controller() {}
    
    Public void send(){
        configure_sender();
        do_send();

        if (no_error()) {
            output = '<p>The draft envelope was created, Envelope ID: ' + envelope_id + '</p>';
            output += '<p></p><p>Signer: ' + signer_name + ' &lt;' + signer_email + '&gt;</p>';
            output += '<p><b>To complete and send the envelope, redirect the user to <a href = "' + 
            		  sender_view_url + '" target="_blank">DocuSign</a></b></p>';
            output += '<p>The redirect address is ' + sender_view_url + '</p>';
            output += '<p><b>Note:</b> the sender view url can only be used for a couple of minutes after ' +
                      'it has been created. Do NOT store the url for later use. Instead, ' +
                      'generate the URL immediately before you redirect the user\'s ' + 
                      'browser to the URL.</p>';
            output += '<p>After the sender has finished sending the envelope, his ' +
                      'browser will be redirected back to your app with some query fields added. Example: </p>' +
                      '<p>http://www.foo.com/?envelopeId=dad2e78b-9d35-47c7-8c13-f197dac08f10&event=Send</p>';

        } else {
            output = '<h3>Problem</h3><p>' + error_message + '</p>';
        }
    }

    Private void configure_sender(){
        api_sender.endpoint_x = ds_server;
        api_sender.inputHttpHeaders_x = new Map<String, String>();
        String auth =   '<DocuSignCredentials><Username>{!$Credential.Username}</Username>' 
                      + '<Password>{!$Credential.Password}</Password>' 
                      + '<IntegratorKey>' + integration_key + '</IntegratorKey></DocuSignCredentials>';

        api_sender.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);
        api_sender.inputHttpHeaders_x.put(trace_key, trace_value);
    }

    Private void do_send() {
        // Sends a draft signing request to signer_name / signer_email

        // Check input
        if (String.isBlank(signer_email) || String.isBlank(signer_name) || !signer_email.contains('@')) {
            error_message = 'Please fill in the email and name fields';
            error_code = 'INPUT_PROBLEM';
            return;
        }

        // Check configuration
        if (integration_key == 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' ||
            account_id == 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx') { 
            error_message = 'Please configure the Apex class DS_Recipe_Send_Env_Email_Controller with your integration key and account id.';
            error_code = 'CONFIGURATION_PROBLEM';
            return;
        }

        // The recipient
        // No tabs needed since they'll be added via the sending view
        DocuSignTK.Recipient recipient = new DocuSignTK.Recipient();
        recipient.Email = signer_email;
        recipient.UserName = signer_name;
        recipient.ID = 1;
        recipient.Type_x = 'Signer';
        recipient.RoutingOrder = 1;
        // If we want this signer to be "captive" so we can use embedded signing with him,
        // Then include the following.
        // recipient.CaptiveInfo = new DocuSignTK.RecipientCaptiveInfo();
        // recipient.CaptiveInfo.ClientUserID = signer_user_id; 

        // Create an envelope and fill it in
        DocuSignTK.Envelope envelope = new DocuSignTK.Envelope();
        envelope.Subject = 'Please sign the NDA package'; // Make the subject specific to the request
            // Since the subject is used to identify the envelope, you may want to include the
            // key signer's name or org. Eg Please sign the Example Corp - Sender Corp NDA                            
        envelope.AccountId  = account_id; 
        envelope.Recipients = new DocuSignTK.ArrayOfRecipient();
        envelope.Recipients.Recipient = new DocuSignTK.Recipient[1];
        envelope.Recipients.Recipient.add(recipient);
 
        // Make the calls
        try {
        	// Create a draft envelope
            DocuSignTK.EnvelopeStatus result = api_sender.CreateEnvelope(envelope);
            envelope_id = result.EnvelopeID;
            System.debug('Create envelope success, envelope_id = ' + envelope_id );
        	// Get a Sender View url
            // NOTE: the sender view url can only be used for a couple of minutes after
            //       it has been created. Do NOT store the url for later use. Instead,
            //       generate the URL immediately before you redirect the user's 
            //       browser to the URL.
            sender_view_url = api_sender.RequestSenderToken(
            	envelope_id, account_id, sender_return_url);
            System.debug('RequestSenderToken success, url = ' + sender_view_url);
        } catch ( CalloutException e) {
            System.debug('Exception - ' + e );
            error_code = 'Problem: ' + e;
            error_message = error_code;
        }      
    }

    Private Boolean no_error() {
        return (String.isEmpty(error_code));
    }

}