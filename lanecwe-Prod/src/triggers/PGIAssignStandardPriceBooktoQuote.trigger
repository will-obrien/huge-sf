/********************************************************************************
Name:  PGIAssignStandardPriceBooktoQuote ()
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
Trigger to assign Standard pricebook to Quote
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE           DETAIL              
1.0    - Nagendra          4/09/2012         Initial Development 
********************************************************************************/ 
trigger PGIAssignStandardPriceBooktoQuote on Quote (before insert) {
  PGIQuoteTriggerUtilities.assignStandardPriceBookToQuote(trigger.new);
 }