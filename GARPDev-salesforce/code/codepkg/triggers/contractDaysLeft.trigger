trigger contractDaysLeft on Contract (before update, before insert) {

    for(Contract obj : trigger.New)
    {        
        if(obj .StartDate != null && obj .EndDate != null) {


            Date newEnd = obj.StartDate.addMonths(obj.ContractTerm);
            Double dTerm = Date.Today().daysBetween(newEnd );
            obj .Days_Left__c = Integer.valueOf(dTerm);
                
        }    
    }

}