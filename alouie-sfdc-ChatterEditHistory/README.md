# ChatterEditHistory
A VisualForce page to display the editing history of a Chatter thread. Useful for compliance.

# Background
The Summer '15 release brought us the [Edit Feed Posts and Comments](http://docs.releasenotes.salesforce.com/en-us/summer15/release-notes/rn_chatter_feeds_edit_posts.htm?edition=&impact=) feature for Chatter. Currently, the editing history for posts and comments is available in the [API](https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_feedrevision.htm) only. It's not available in the Salesforce UI. To make it easier to view the history of a thread, we've provided a VisualForce page that calls the API and displays all of the revisions.

# Installation
Add the Apex classes and VisualForce page to your org, and grant access to the users who need to use it.

Here are some sample screenshots of what an edited Chatter thread looks like in the Salesforce UI and in the VisualForce page. The post and the first comment are edited:

![Screenshot](https://cloud.githubusercontent.com/assets/6492902/8214166/2f2c9faa-14dc-11e5-9847-2ab82211df17.png "Screenshot")

Admittedly, it's not the prettiest page. Pull requests are welcome!

**Note:** To get the link to a Chatter thread, you can click on the timestamp of the post.
