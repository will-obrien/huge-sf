Chlacker - the sibling to [Slatter](https://github.com/aire-con-gas/slatter)
================================

Chlacker provides an easy Slack channel creation from a Salesforce VisualForce page. You can use Chlacker in conjunction with Slatter to provide a medium for real-time collaboration via Slack and tie it with a Salesforce object.

This is intended to be a community-driven project so feel free to contribute and make modifications.

Getting Started
----------------
- Step 1. Create a Slack App

Create a new Slack app here https://api.slack.com/applications/new
Enter in the following information:
App Name: Chlacker
Team: [Utilize whichever account you want to integrate with]
Description: Auto-generate channel for associated Salesforce object
Redirect URI(s): set this to the callback URL for the visualforce page handling the oauth integration (e.g. https://[your salesforce instance]/apex/chlacker?callback=1)

Once the app has been created, copy the Client ID and Client Secret

- Step 2. Set Client and Secret in Setup

Go to your salesforce instance and go to Setup > Custom Settings > Slack Client Settings. Hit ‘Manage’ and enter the Client ID and Client Secret from the previous step.

- Step 3. Allow for Cross Site communication

Go to your salesforce instance and go to Setup > Security > Remote Site Settings. Hit ‘New Remote Site’ and enter in the following:
Remote Site Name: Slack_OAuth_Access
Remote Site URL: https://slack.com

- Step 4. Open up Chlacker

Open up a new browser tab/window and go to https://[your salesforce instance]/apex/chlacker?slack=1. This will initiate the chain of first authenticating yourself with the Chlacker app you created in step 1 on slack.com. Once you’ve authenticated and given permission, you’ll redirect back to the callback URL

Improvements
----------------
- Need to temporarily save channel name in some session store
- Channel creation guard

Installing the Source Code (Developers)
--------------------------------------

If you are a developer obtain the source code from this repository if you wish to develop it further and/or contribute to it. Click the button below to deploy the source code to your developer or sandbox org.

<a href="https://githubsfdeploy.herokuapp.com?owner=aire-con-gas&repo=Chlacker">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>
