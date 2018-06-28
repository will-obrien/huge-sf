trigger AddressTrigger on rC_Bios__Address__c (before insert, before update) {
    for(rC_Bios__Address__c addr : Trigger.new) {
        if(addr.rC_Bios__Street_Line_1__c == 'Unknown') {
            addr.rC_Bios__Street_Line_1__c = null;
        }
        if(addr.rC_Bios__City__c == 'Unknown') {
            addr.rC_Bios__City__c = null;
        }
        if(addr.rC_Bios__State__c == 'UN') {
            addr.rC_Bios__State__c = null;
        }
        if(addr.rC_Bios__Postal_Code__c == 'Unknown') {
            addr.rC_Bios__Postal_Code__c = null;
        }
    }
}