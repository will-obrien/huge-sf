trigger set_Index_Number on Address__c (before insert) {

/*
    Need to set an index field for this address (range 1-5) 
    based on how many addresses have been already defined for the associated card object
    
*/
 
/*    
      for (Address__c a : Trigger.new) {
      Card__c c = [SELECT Number_of_Address_Records__c FROM Card__c WHERE id = :a.Card__c LIMIT 1];
           a.Index__c = c.Number_of_Address_Records__c + 1;

              }
*/

}
