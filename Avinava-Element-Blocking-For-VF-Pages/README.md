Element Blocking using jQuery UI Block
=========
Demonstration of how jQuery UI Block can be used to block the cetain portion of Visualforce Page while a Ajax Call is in progress.

How it works?
-
Very simple from &lt;apex:commandButton/&gt; or &lt;apex:actionFunction/&gt; simply relate a &lt;apex:actionstatus/&gt; component which has a &quot;onstart&quot; and &quot;onstop&quot; event. Call the &quot;blockElement&quot; js function from the &quot;onstart&quot; and call &quot;unblockElement&quot; function from &quot;onstop&quot; attribute.


Version
-

1.0


Installation/Code
--------------

1.Install the Package from https://login.salesforce.com/packaging/installPackage.apexp?p0=04t90000000LxcY


  
    
