trigger validateAddress on Case (after insert, after update) {
    
    public List<ID> caseList = new List<ID>();
    
    for (Case c : Trigger.new) {
         if((c.Location__Longitude__s == null || c.Location__Longitude__s == 0 ) && c.Street__c != null)
             caseList.add(c.ID);
    } 
     
    if(caseList != null && caseList.size() > 0)
        LocateAddress.LocateAddressFuture(caseList, 'gmap', 'Cases');
}