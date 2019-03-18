trigger Match on Item__c (before insert, before update) {
    Set <Account> AcList = new Set <Account>([Select Name, OE_Code__c from Account]);
    Set <Listed_Item__c> LiList = new Set<Listed_Item__c>([Select Name from Listed_item__c]);
    for(Item__c item: Trigger.New){
        for(Account a: AcList){
            if(item.Customer_Number__c==a.OE_Code__c){
                item.Account__c=a.id;
                
            }
        }
        for(Listed_Item__c Li: LiList){
            if(Item.Item_Code__c==Li.Name){
            item.Listed_Item__c=Li.Id;
            item.Name=Li.Name;
            }
        }
    }
}