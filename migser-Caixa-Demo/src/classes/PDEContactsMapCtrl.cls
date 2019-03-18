global class PDEContactsMapCtrl {

    @AuraEnabled
    public static List<Contact> getAccountContacts(String accountId){
        return [Select Id, Name, Influence_Rating__c, Support_Rating__c, Display_On_Power_Map__c, Title
                   from Contact where AccountId = :accountId
                   ORDER BY Name ASC];
    }
    
    
    @AuraEnabled
    public static List<MapItem> getMapItems(String accountId){
       List<MapItem> MIs = new List<MapItem>();       
       Contact[] cons =  [Select Id, Name, Influence_Rating__c, Support_Rating__c 
                from Contact where AccountId = :accountId AND Display_On_Power_Map__c = true
                         ORDER BY Name ASC];
        for (Contact con : cons){
            MapItem MI = new MapItem(con.Id,con.Name,con.Influence_Rating__c,con.Support_Rating__c);
            MIs.add(MI);
        }
      return MIs;
    }
    
    global class MapItem {
        @AuraEnabled
        public Id ContactId;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public Decimal Influence_Rating;
        @AuraEnabled
        public Decimal Support_Rating;
        @AuraEnabled
        public String Category;
        @AuraEnabled
        public Integer Size;
        
        MapItem(Id ContactId, String Name, Decimal Influence_Rating, Decimal Support_Rating) {
            this.ContactId=ContactId;
            this.Name=Name;
            this.Influence_Rating=Influence_Rating;
            this.Support_Rating=Support_Rating;
            this.Category='ContactCategory';
            this.Size=5;
        }
        
    }
    
}