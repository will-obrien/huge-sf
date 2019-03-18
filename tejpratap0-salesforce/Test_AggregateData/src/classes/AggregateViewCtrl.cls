public with sharing class AggregateViewCtrl { 
       /*   
        *   Properties different uses: To validate data before a change is made,
        *   To prompt an action when data is changed.
        *	Git Test
        */
        public String account {get; set;}  
        public Date startDate {get; set;}
        public Date endDate {get; set;} 
        public List<String> options {get; set;}
        public List<String> options1 {get; set;}
        public List<String> options2 {get; set;}
        public List<String> options3 {get; set;}
        public List<AggregatedData__c> aggregateRecords {get; set;}
        public List<Account> AccNo = [SELECT Id, Name From Account];
        //Integer[] AccNum = new List<Integer>();
        public Integer startWeek ;
        public Integer endWeek ;
        private Map<String, Id> accountMap;
        
        /**
         * Creating Object of List and Map and quering Records from Account to populate on visualforce Page.
         */
        // Constructor
        public AggregateViewCtrl(){ 
            
             aggregateRecords = new List<AggregatedData__c>();
             accountMap = new Map<String, Id>();
             options = new List<String>();
             
             for(Account obj : [SELECT Id, Name From Account]) {
                 accountMap.put(obj.Name, obj.Id);
                 options.add(obj.Name);
             } 
        }     
         
        /**
         * method to display Account Records when user click on button,
         * This method display Account Name, Week start date and week End date.
         */
        public PageReference go() { 
            if(account ==  NULL || account == '')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Account Name'));
            }
            if( startDate != NULL ) {
                AggregateHandler.WeekUtility startObj = new AggregateHandler.WeekUtility(startDate );
                startWeek = startObj.weekNumber;
            }
            else
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Start Date'));
            
            if( endDate != NULL ) {
                AggregateHandler.WeekUtility endObj = new AggregateHandler.WeekUtility(endDate);
                endWeek = endObj.weekNumber; 
            }
            else
                 Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please enter EndDate'));
            if( startDate > endDate)
            {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Start Date is Greater than end Date'));
            }
             
            if( startWeek != NULL && endWeek != NULL && account !=  NULL ) {  
                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Successfully Display Account Records'));
                System.debug('Start Week: '+startWeek + ', End Week: '+endWeek ); 
                aggregateRecords.clear(); 
                for( AggregatedData__c obj : [SELECT Account__c, CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesER__c, OpportunitiesOP__c, Opportunities__c, OpportunityCLIds__c, OpportunityCWIds__c, OpportunityOPIds__c, WeekEndDate__c, WeekNumber__c, WeekStartDate__c, Year__c FROM AggregatedData__c WHERE Account__c =:accountMap.get(account) AND ( WeekNumber__c >=: Integer.valueOf(startWeek) AND WeekNumber__c <=: Integer.valueOf(endWeek))]){
                     aggregateRecords.add(obj);
                }  
                 
                //System.debug('Aggregate List '+aggregateRecords );  
            }
            return NULL;
        } 
        
        public Boolean getRecords(){
        
            if(aggregateRecords.isEmpty())
                return false;
            else
                return true;
        }
               
      /*  public List<String> getOptions()
            {
                 Account tempAccount;
                Map<Id ,Account> temp = new Map<Id,Account>();
                for(Account obj : ls) {
                temp.put( obj.Id, new Account() );    
                tempAccount = temp.get(obj.Name);         
            }
          
            List<String> tempList= new List<String>();
            for(Account obj : [SELECT Id, Name From Account])
                tempList.add(obj.Name); 
             
             return a;
                  }
           
            return tempList;
        } 
        
        // Obtaining List of Start weeks using selectOption and adding into List
        public List<SelectOption> getStartWeeks() {
            List<SelectOption> options = new List<SelectOption>();
            for(Integer i=1; i<=52; i++)
                options.add(new SelectOption(String.valueOf(i), 'Week '+String.valueOf(i)));
                
            return options;
        }
        // Obtaining List of End weeks using selectOption and adding into List
        public List<SelectOption> getEndWeeks() {
            List<SelectOption> options = new List<SelectOption>();
            for(Integer i=Integer.valueOf(this.startWeek) ; i<=52; i++)
                options.add(new SelectOption(String.valueOf(i), 'Week '+String.valueOf(i)));
                
            return options;
        }
        */
}