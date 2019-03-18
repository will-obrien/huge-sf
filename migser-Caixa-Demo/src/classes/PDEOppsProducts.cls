global class PDEOppsProducts {

    @AuraEnabled
    public static List<DropDownRecord> getDDR(String parentId){
       List<DropDownRecord> records = new List<DropDownRecord>();       
       Opportunity[] opps =  [Select Id, Name, StageName, Amount, Probability, CloseDate 
                from Opportunity where AccountId = :parentId ORDER BY CloseDate DESC LIMIT 10];
     
      for (Opportunity opp : opps) {
              OpportunityLineItem[] OLI = Database.query('SELECT Id, Name, Quantity, UnitPrice, TotalPrice, Discount, ProductCode, Product2.name , Image__c FROM OpportunityLineItem WHERE OpportunityId = \'' + opp.Id+'\'');
          /* I am forced to use Dynamic SOQL to be able to include a custom field from the SDO in the request. Otherwise, when creating 
           * the package, SDO field is included in the package and package cannot be installed on another SDO (error: field already existing)
           * /
          /* OpportunityLineItem[] OLI =  [Select Id, Name, Quantity,UnitPrice,TotalPrice,Discount, ProductCode, Product2.name , Image__c
                from OpportunityLineItem where OpportunityId = :opp.Id];*/
             DropDownRecord DDR = new DropDownRecord(opp.id,opp.Name,opp.StageName,String.valueOf(opp.Amount),String.valueOf(opp.Probability),String.valueOf(opp.CloseDate),OLI);             
             records.add(DDR);
      }

         return records;
    }
     
   global class DropDownRecord {
        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public String Name { get; set; }
        @AuraEnabled
        public String StageName;
        @AuraEnabled
        public String Amount;
        @AuraEnabled
        public String Probability;
        @AuraEnabled
        public String CloseDate;
        @AuraEnabled
		public List<OpportunityLineItem> LOLI;
        //Id Id1, String Name, String StageName, String Amount, List<OpportunityLineItem> LOLI
        DropDownRecord() {
            this.Name='Sample Record';
        }
        DropDownRecord(Id Id, String Name, String StageName, String Amount,String Probability, String CloseDate, List<OpportunityLineItem> LOLI) {
            this.Id=Id;
            this.Name=Name;
            this.StageName=StageName;
            this.Amount=Amount;
            this.Probability=Probability;
            this.CloseDate=CloseDate;
            this.LOLI=LOLI;
            
        }
       
   }
    
}