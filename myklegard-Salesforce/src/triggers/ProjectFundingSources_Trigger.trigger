/*
  This trigger will update the Amount on Funding_Streams__c objects as the sum total of all the Amount on the Contract Funding Source Object 
  associated with each Project Funding Source under the 
  **********************************************************
  Author: Shrawan Raina
  Audit History
  **********************************************************
  06/13/2014        Shrawan Raina       Created
  07/23/2014        Shrawan Raina       Modified
  08/18/2014        Mounika Sattu       Modified
  **********************************************************  
*/ 
trigger ProjectFundingSources_Trigger on Project_Funding_Sources__c (after insert,before insert,after update, after delete) {
     
     new ProjectFundingSourcesHelper().process();

}