# SFDC - DocuSign Embedded Sending
This repo enables you to send an envelope for signing from an Apex class on SFDC. 

The envelope is sent using *embedded sending*: The sender is redirected to a specific
DocuSign URL. Via that URL, the sender can add documents to the envelope, and add
*fields* for signing to the envelope's documents.

After the sender completes the sending process:

1. The envelope is sent to the first recipient.
1. The sender's browser is redirected back to your SFDC app, to the url that you designated.
The redirect includes query parameters with the envelope's ID and the outcome of the sending process.

The Apex class uses the [RequestSenderToken](https://www.docusign.com/p/APIGuide/APIGuide.htm#Embedding Group/RequestSenderToken.htm%3FTocPath%3DDocuSign%2520Service%2520API%2520Information%7CEmbedding%2520Function%2520Group%7CRequestSenderToken%7C_____0) method from the DocuSign SOAP API.

## Installation 

### 1. Install DocuSign for Salesforce
Install [DocuSign for Salesforce from AppExchange](https://appexchange.salesforce.com/listingDetail?listingId=a0N30000001taX4EAI) 

### Authentication via Named Credential
There are multiple ways to set up authentication on Salesforce with DocuSign Signature APIs.

The DocuSign Signature SOAP API uses DocuSign [Legacy Authentication](https://docs.docusign.com/esign/guide/authentication/legacy_auth.html), with or without SOBO.

For User Applications, it is preferable that each DocuSign sender logs in to use his or her own account. SFDC Named Credentials enable this.
 
### 2. Install Authentication support and Apex proxy classes
Please see the instructions from the [SFDC Hello World recipe](https://github.com/docusign/sfdc-recipe-hello-world/blob/master/README.md) for the following steps:

2. Create the Named Credential

3. Grant Access for Users to Update their own DocuSign Credentials

4. Each User: Enable Their DocuSign Authentication

5. Create the Apex proxy classes

### 3. Install and configure the Recipe

* Install the Apex class file `DS_Recipe_Sender_View_Controller` from the source file src/classes/DS_Recipe_Sender_View_Controller.cls
  * Update the class with your DocuSign Demo Integration Key and Account ID.
    Remember that you need to use the long form version of the Account ID.
* Install the VisualForce page `DS_Recipe_Sender_View` from the source file src/pages/DS_Recipe_Sender_view.page

### 4. Try it out
Navigate to \[your SFDC org\]/apex/DS_Recipe_Sender_View and fill in the form to create an envelope.

The page will create the envelope in *draft* mode and return the DocuSign URL that is used to complete the *sending experience.*
As part of the sending experience, you can add documents and templates to the envelope, and add fields/tags to the documents.

After you finish the sending process, the envelope will be sent to the first recipient.

## Questions, Problems, Issues
* If you have a question about a DocuSign API, please use the "docusignapi" tag on [StackOverflow](http://www.stackoverflow.com)
* Pull requests and other issues for this repository can be filed with the [repo's Issues list](https://github.com/docusign/sfdc-recipe-embedded-sending/issues).

