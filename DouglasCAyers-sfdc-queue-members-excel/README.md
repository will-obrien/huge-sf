Problem Statement
=================

As of this writing, Salesforce provides [no way of reporting](https://success.salesforce.com/ideaview?id=08730000000BqYaAAK) on who belongs to which queues.

The only workaround is to use SOQL to query users that belong to known groups by joining on **groupmember** object:
```
    SELECT
        id, name, username, isActive
    FROM
        user
    WHERE
        id IN ( SELECT userOrGroupId FROM groupmember WHERE groupId = :groupId )
    ORDER BY
        name
```

Solution: Visualforce and Apex
==============================

As a simple solution, I created an apex controller and two visualforce pages (one for selecting a queue and listing the members and second for rendering in Excel).

Deployment: How To
==================

<a href="https://githubsfdeploy.herokuapp.com?owner=douglascayers&repo=sfdc-queue-members-excel">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

To simplify deployment of this custom code to your org, you may use the [github deploy tool](http://andyinthecloud.com/2013/09/24/deploy-direct-from-github-to-salesforce/) developed by [Andy Fawcett](https://twitter.com/andyinthecloud).

Once deployed, you will need to grant users access to the pages, classes, and custom tab as well as add the tab to an app if you want it to always show on the menu bar.

To deploy in your **sandbox**:
https://githubsfdeploy-sandbox.herokuapp.com/app/githubdeploy/douglascayers/sfdc-queue-members-excel

To deploy to **production**:
https://githubsfdeploy.herokuapp.com/app/githubdeploy/douglascayers/sfdc-queue-members-excel

*If deploying to production via github tool fails due to tests not being run, you may opt to use Change Sets or Ant Tool or however you normally deploy your code from sandbox to production. Please use your best judgement and due diligence before making any production changes to your org.*
