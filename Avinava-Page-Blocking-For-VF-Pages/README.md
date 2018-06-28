Page Blocking using jQuery UI Block
=========

Ever wondered how to show user a wait or loading message while a ajax call from a visualforce page is in progress?
Well the answer is yes! You can always show a message to user using action status, well that will be static message.
What if you want to block the page or some predefined area? Well the solution is jQuery UI block. Using this plugin you can actually block portions of visualforce page while the ajax action is processing.Well the part 1 I am demonstrating how to block the full page while a ajax request is in progress.

How it works?
-
Very simple from &lt;apex:commandButton/&gt; or &lt;apex:actionFunction/&gt; simply relate a &lt;apex:actionstatus/&gt; component which has a &quot;onstart&quot; and &quot;onstop&quot; event. Call the &quot;blockPage&quot; js function from the &quot;onstart&quot; and call &quot;unblockPage&quot; function from &quot;onstop&quot; attribute.

Version
-

1.0


Installation/Code
--------------

1.Install the Package from https://login.salesforce.com/packaging/installPackage.apexp?p0=04t90000000LxN6


  
    
