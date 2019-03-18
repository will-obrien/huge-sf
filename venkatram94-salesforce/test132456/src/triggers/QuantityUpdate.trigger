trigger QuantityUpdate on Order (before insert) {
   
    for(Order r:Trigger.new) {
        Decimal quant = [select QuantityAvailble__c from Container__c where id =: r.Category__c].QuantityAvailble__c;
        System.debug('Qunat: '+quant);
        integer quantity = quant.intValue();
        r.QuantityAvailable__c = quantity;
        System.debug('Quanity Available is: '+quantity);
    }
}