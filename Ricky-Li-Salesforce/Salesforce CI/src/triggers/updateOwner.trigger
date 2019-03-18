trigger updateOwner on Account (before insert, before update) {
    for(Account a: trigger.new){
        if(a.Regional_Sales_Manager__c != null){
            a.OwnerId = a.Regional_Sales_Manager__c;
        }    
    }

}