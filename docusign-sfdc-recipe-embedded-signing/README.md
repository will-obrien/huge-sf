# SFDC - DocuSign Embedded Signing Ceremony
Using SFDC Apex, this repo sends an envelope and then provides the url for an embedded Signing Ceremony. 

After the signer completes the Signing Ceremony:

1. The envelope is sent on to the next recipient.
1. The signer's browser is redirected back to your SFDC app, to the url that you designated.
The redirect includes an event query parameters with the outcome of the Signing Ceremony.

The Apex class obtains the url for the Signing Ceremony by using the [RequestRecipientToken](https://www.docusign.com/p/APIGuide/APIGuide.htm#Embedding Group/Pre-DocuSign Operations.htm) method from the DocuSign SOAP API.


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

* Install the Apex class file `DS_Recipe_Signer_View_Controller` from the source file src/classes/DS_Recipe_Signer_View_Controller.cls
  * Update the class with your DocuSign Demo Integration Key and Account ID.
    Remember that you need to use the long form version of the Account ID.
* Install the VisualForce page `DS_Recipe_Signer_View` from the source file src/pages/DS_Recipe_Signer_View.page

### 4. Try it out
Navigate to \[your SFDC org\]/apex/DS_Recipe_Signer_View and fill in the form to create an envelope.

The page will create the envelope and return the DocuSign URL for the Signing Ceremony for the recipient.

## Questions, Problems, Issues
* If you have a question about a DocuSign API, please use the "docusignapi" tag on [StackOverflow](http://www.stackoverflow.com)
* Pull requests and other issues for this repository can be filed with the [repo's Issues list](https://github.com/docusign/sfdc-recipe-embedded-signing/issues).
