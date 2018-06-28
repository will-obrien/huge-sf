public with sharing class AggregateHandler { 
   
    /*
     * Aggregating weekly Account, Contact, Case, Opportunity.
     * This code will be run on every Sunday 12:00 am.
     */
    
    public void syncWeekly(){
        List<AggregatedData__c> aggrObjList = new List<AggregatedData__c>(); 
        List<Account> accList = [SELECT Id, CaseIds__c,Cases__c,ContactIds__c,Contacts__c,CreatedDate,OpportunitiesCL__c,OpportunitiesCW__c,OpportunitiesOP__c,Opportunities__c,OpportunitiesER__c,OpprtunityIds__c FROM Account ];
        AggregatedData__c aggrObj;
        System.debug('accList '+accList);
        for( Account obj : accList ) { 
			WeekUtility w = new WeekUtility(obj.CreatedDate);
            
            aggrObj = new AggregatedData__c();
            aggrObj.Account__c = obj.Id;
            aggrObj.Opportunities__c = obj.Opportunities__c;
            aggrObj.Contacts__c = obj.Contacts__c;
            aggrObj.Cases__c = obj.Cases__c;
            aggrObj.OpportunitiesCW__c = obj.OpportunitiesCW__c;
            aggrObj.OpportunitiesCL__c = obj.OpportunitiesCL__c;    
            aggrObj.OpportunitiesOP__c = obj.OpportunitiesOP__c;
            aggrObj.OpportunitiesER__c = obj.OpportunitiesER__c;
            aggrObj.Year__c = (obj.CreatedDate).year();
            aggrObj.WeekNumber__c = w.weekNumber;
            aggrObj.WeekStartDate__c = w.startDayOfWeek;
            aggrObj.WeekEndDate__c = w.endDayOfWeek;  
            aggrObjList.add(aggrObj);  
             
            obj.Cases__c = 0.0;
            obj.Contacts__c = 0.0; 
            obj.OpportunitiesCL__c = 0.0;
            obj.OpportunitiesCW__c = 0.0;
            obj.OpportunitiesOP__c = 0.0;
            obj.Opportunities__c = 0.0;
            obj.OpportunitiesER__c = 0.0;
            obj.CaseIds__c = ''; 
            obj.ContactIds__c = '';
            obj.OpprtunityIds__c = ''; 
            obj.OpportunityCWIds__c = '';
            obj.OpportunityCLIds__c = '';
            obj.OpportunityOPIds__c = '';
        } 
         
        Database.update(accList);
        Database.SaveResult[] results = Database.insert(aggrObjList, false);
        for (Database.SaveResult result : results) 
        {
            if (result.isSuccess()){
                System.debug('Record' + result.getId() + ' successfully created.');
            }
            else{
                if (result.getErrors().size() > 0){
                    System.debug(result.getErrors()[0].getMessage());
                }
            }
        }
        
    }
      
    
    /*
     * Aggregating Previous Account, Contact, Case, Opportunity.
     * This code will be run when we will install the aggragate package in our organization.
     */
 
    public void syncPrevious(Integer l){ 
        List<Account>  accounts = [SELECT Id, Name, CreatedDate FROM Account ];
        List<Case> cases = [SELECT Id, Account.Id, CreatedDate FROM Case WHERE Account.Id != NULL LIMIT :l];
        List<Contact> contacts = [SELECT Id, Account.Id, CreatedDate FROM Contact WHERE Account.Id != NULL LIMIT :l];
        List<Opportunity> opportunities = [SELECT Id, Account.Id, CreatedDate, StageName, ExpectedRevenue FROM Opportunity WHERE Account.Id != NULL LIMIT :l]; 
        
        Map<Id, Account> accountMap = new Map<Id, Account>();
		Map<String, AggregatedData__c> aggregateMap = new Map<String, AggregatedData__c>();
        
        
        for(Account obj : accounts ) {  
            
            obj.Cases__c = 0.0;
            obj.Contacts__c = 0.0; 
            obj.OpportunitiesCL__c = 0.0;
            obj.OpportunitiesCW__c = 0.0;
            obj.OpportunitiesOP__c = 0.0;
            obj.Opportunities__c = 0.0; 
            obj.OpportunitiesER__c = 0.0;
            obj.CaseIds__c = '';
            obj.ContactIds__c = '';
            obj.OpportunityCWIds__c = '';
            obj.OpportunityCLIds__c = '';
            obj.OpportunityOPIds__c = '';
            obj.OpprtunityIds__c = ''; 
			accountMap.put( obj.Id, obj );             
        }
          
        for( Case obj : cases ){
            if(accountMap.containsKey(obj.Account.Id)){
                WeekUtility w = new WeekUtility(obj.CreatedDate);
                
                if(aggregateMap.containsKey( obj.Account.Id+'#'+w.weekNumber )){
                    AggregatedData__c temp =  aggregateMap.get( obj.Account.Id+'#'+w.weekNumber);
                    temp.Cases__c++;
                    
                    if(temp.CaseIds__c != null && temp.CaseIds__c != ''){
                        temp.CaseIds__c +=','+obj.Id; 
                    }   
                    else{
                         temp.CaseIds__c = obj.Id; 
                    } 
                }
                else{
                    aggregateMap.put( obj.Account.Id+'#'+w.weekNumber , new AggregatedData__c( Account__c = obj.Account.Id, Opportunities__c = 0, Contacts__c = 0, Cases__c = 1, CaseIds__c = obj.Id , OpportunitiesCW__c = 0, OpportunitiesCL__c = 0, OpportunitiesOP__c = 0 , OpportunitiesER__c = 0, Year__c = (obj.CreatedDate).year(),  WeekNumber__c = w.weekNumber, WeekStartDate__c = w.startDayOfWeek, WeekEndDate__c = w.endDayOfWeek ));
                }  
            } 
        } 
        
         for( Contact obj : contacts ){
            if(accountMap.containsKey(obj.Account.Id)){
                WeekUtility w = new WeekUtility(obj.CreatedDate); 
                if(aggregateMap.containsKey( obj.Account.Id+'#'+w.weekNumber )){
                   	AggregatedData__c temp =  aggregateMap.get( obj.Account.Id+'#'+w.weekNumber);
                    temp.Contacts__c++;
                if(temp.ContactIds__c != null && temp.ContactIds__c != '')
              		temp.ContactIds__c +=','+obj.Id; 
                else
                    temp.ContactIds__c = obj.Id;
                }
                else{
                    aggregateMap.put( obj.Account.Id+'#'+w.weekNumber , new AggregatedData__c( Account__c = obj.Account.Id, Opportunities__c = 0, Contacts__c = 1, ContactIds__c = obj.Id , Cases__c = 0, OpportunitiesCW__c = 0, OpportunitiesCL__c = 0, OpportunitiesOP__c = 0 , OpportunitiesER__c = 0, Year__c = (obj.CreatedDate).year(),  WeekNumber__c = w.weekNumber, WeekStartDate__c = w.startDayOfWeek, WeekEndDate__c = w.endDayOfWeek ));
                }  
            } 
        } 
        
        for(Opportunity obj : opportunities){
           
            if(accountMap.containsKey(obj.Account.Id)){
                 
                WeekUtility w = new WeekUtility(obj.CreatedDate);
                if(aggregateMap.containsKey(obj.Account.Id+'#'+w.weekNumber)){
                    AggregatedData__c temp = aggregateMap.get(obj.Account.Id +'#'+w.weekNumber);
                    if((obj.StageName).equals('Closed Won')){
                        temp.OpportunitiesCW__c++;
                    if(temp.OpportunityCWIds__c != null && temp.OpportunityCWIds__c != '')
              			temp.OpportunityCWIds__c +=','+obj.Id; 
                    else
                   		temp.OpportunityCWIds__c = obj.Id;
                    }
                 	else if((obj.StageName).equals('Closed Lost')){
                        temp.OpportunitiesCL__c++;
                    if(temp.OpportunityCLIds__c != null && temp.OpportunityCLIds__c != '')
              			temp.OpportunityCLIds__c +=','+obj.Id; 
                    else
                   		temp.OpportunityCLIds__c = obj.Id;
                    }
                    else{
                        temp.OpportunitiesOP__c++;
                    if(temp.OpportunityOPIds__c != null && temp.OpportunityOPIds__c != '')
              			temp.OpportunityOPIds__c +=','+obj.Id; 
                    else
                   		temp.OpportunityOPIds__c = obj.Id;
                    	}
                    	temp.Opportunities__c++;
					 
                }
            else{
                  if((obj.StageName).equals('Closed Won'))
                  		aggregateMap.put( obj.Account.Id+'#'+w.weekNumber , new AggregatedData__c( Account__c = obj.Account.Id, Opportunities__c = 1, Contacts__c = 0, Cases__c = 0, OpportunitiesCW__c = 1, OpportunityCWIds__c = obj.id, OpportunitiesCL__c = 0, OpportunitiesOP__c = 0 , OpportunitiesER__c = 0, Year__c = (obj.CreatedDate).year(),  WeekNumber__c = w.weekNumber, WeekStartDate__c = w.startDayOfWeek, WeekEndDate__c = w.endDayOfWeek ));
                  else if((obj.StageName).equals('Closed Lost'))
                        aggregateMap.put( obj.Account.Id+'#'+w.weekNumber , new AggregatedData__c( Account__c = obj.Account.Id, Opportunities__c = 1, Contacts__c = 0, Cases__c = 0, OpportunitiesCW__c = 0, OpportunitiesCL__c = 1, OpportunityCLIds__c = obj.id, OpportunitiesOP__c = 0 , OpportunitiesER__c = 0, Year__c = (obj.CreatedDate).year(),  WeekNumber__c = w.weekNumber, WeekStartDate__c = w.startDayOfWeek, WeekEndDate__c = w.endDayOfWeek ));
                  else
                      	aggregateMap.put( obj.Account.Id+'#'+w.weekNumber , new AggregatedData__c( Account__c = obj.Account.Id, Opportunities__c = 1, Contacts__c = 0, Cases__c = 0, OpportunitiesCW__c = 0, OpportunitiesCL__c = 0, OpportunitiesOP__c = 1 , OpportunityOPIds__c = obj.id, OpportunitiesER__c = 0, Year__c = (obj.CreatedDate).year(),  WeekNumber__c = w.weekNumber, WeekStartDate__c = w.startDayOfWeek, WeekEndDate__c = w.endDayOfWeek ));
            	}
            } 
        }
		
        System.debug(' Aggregate Data Map : '+JSON.serialize(aggregateMap) );
        Database.insert(aggregateMap.values());
    }
    
  
  	public class WeekUtility
    {
    	public DateTime startDayOfWeek;   
    	public DateTime endDayOfWeek;     
        public Integer weekNumber; 
            
        public WeekUtility(Datetime d){  
            DateTime newDate = d;
            String dayOfDate = (newDate.format('EEEE/MM/yyyy').split('/'))[0];
            Integer i = 0;
            Integer year = d.year();
            
            //while( dayOfDate != 'Sunday' && newDate.year() == year  ){ 
          	while( dayOfDate != 'Sunday' ){ 
                newDate = d.addDays(-i); 
                List<String> dayofcurrentday1 = newDate.format('EEEE/MM/yyyy').split('/'); 
                dayOfDate = dayofcurrentday1[0]; 
                i=i+1;     
            } 
             
            startDayOfWeek = DateTime.newInstance(newDate.year(), newDate.month(), newDate.day()+1 , 00, 00, 01); //Monday 00:00:01
            endDayOfWeek = DateTime.newInstance(newDate.addDays(6).year(), newDate.addDays(6).month(), newDate.addDays(6).day(), 23, 59, 59);
            Datetime firstMonday = firstMondayOfYear(d);
            weekNumber = firstMonday.date().daysBetween(newDate.date())/7 ;
            
            if(!('Monday'.equals((newDate.format('EEEE/MM/yyyy').split('/'))[0])))
                weekNumber += 1;
            
            if(!(firstMonday.day() == 1))
                weekNumber += 1;
    	}
        
        public Datetime firstMondayOfYear(Datetime d){
            Datetime obj = Datetime.newInstance(d.year() , 1, 1);         
            DateTime newDate = obj; 
            String day = (newDate.format('EEEE/MM/yyyy').split('/'))[0];
            Integer i = 0;
            while( day != 'Monday' ){ 
                newDate = obj.addDays(i);   
                day = (newDate.format('EEEE/MM/yyyy').split('/'))[0];
                i=i+1;    
            } 
            return newDate;
        }
	}
    
    public static String removeId(String ids, String newId)
    {
        String str = ''; 
        if( ids != null && ids != '' )
        { 
            String[] araayOfIds = ids.split(',');
            if(araayOfIds.size() > 1){  
                for(String i: araayOfIds)
                {
                    if(!i.equals(newId))
                      if(str!=null && str!= '')
                        str = str+','+i;
                      else
                        str = i;
                }
                System.debug('No of ids'+str);
                if(Str.substring(0)==',')
                    return str.substring(1, str.length());
                return str;
            } 
            else{
                if(araayOfIds[0].equals(newId))
                    return '';
                else
                    return araayOfIds[0];
            }
        }
        else{
            return '';
        }
        
        return str.substring(1);
    } 
    
    public static String addId(String ids, String newId)
    {
        if( ids != null && ids != '' )
        {
            String [] arrayOfId = ids.split(',');
            if(arrayOfId.size() > 1){ 
                for(String i: arrayOfId){	
                    if(i.equals(newId))
                        return ids; 
                }
                return ids+','+newId;
            }
            else{
                if(arrayOfId[0].equals(newId))
                    return newId;
                else
                    return arrayOfId[0]+','+newId;
            }
        }
        else
            return newId;
    }
   
    public static Account initCustomFields(Account obj)
    {  
        if( obj.Cases__c == null ) obj.Cases__c = 0.0; 
        if( obj.Contacts__c == null ) obj.Contacts__c = 0.0; 
        if( obj.OpportunitiesCL__c == null ) obj.OpportunitiesCL__c = 0.0;
        if( obj.OpportunitiesCW__c == null ) obj.OpportunitiesCW__c = 0.0;
        if( obj.OpportunitiesOP__c == null ) obj.OpportunitiesOP__c = 0.0;
        if( obj.Opportunities__c == null ) obj.Opportunities__c = 0.0;
        if( obj.OpportunitiesER__c == null ) obj.OpportunitiesER__c = 0.0;
        if( obj.CaseIds__c == null ) obj.CaseIds__c = '';
        if( obj.ContactIds__c == null ) obj.ContactIds__c = '';
        if( obj.OpprtunityIds__c == null ) obj.OpprtunityIds__c = '';
        if( obj.OpportunityCWIds__c == null ) obj.OpportunityCWIds__c = '';
        if( obj.OpportunityCLIds__c == null ) obj.OpportunityCLIds__c = '';
        if( obj.OpportunityOPIds__c == null ) obj.OpportunityOPIds__c = '';
 
        return obj;
    }
    
    /*   
   	public class AggregateAccount
    {
        public Account accObj = null; 
        public AggregatedData__c aggObj = new AggregatedData__c();
        
        public AggregateAccount(Account acc_obj){
            this.accObj = acc_obj;
        }
    }

	public class ObjectWrapper
    {
        Account acc = null;
        Decimal opportunitiesER = 0;
        Integer noOfCases = 0;
        Integer noOfContacts = 0;
        Integer noOfOpportunities = 0;
        Integer noOfOpportunitiesCW = 0;
        Integer noOfOpportunitiesCL = 0;
        Integer noOfOpportunitiesOP = 0;
       	String idOfCases = '';
        String idOfContacts = '';
        String idOfOpportunities = '';
        String idOfOpportunitiesCW = '';
        String idOfOpportunitiesCL = '';
        String idOfOpportunitiesOP = '';
        
        public ObjectWrapper(Account acc){
            this.acc = acc;
        }
    }
 
	public void synchronizingAll1() {
        List<ObjectWrapper> aggregatedDataList = new List<ObjectWrapper>(); 
        
        List<Account>  accounts = [SELECT Id, Name, CreatedDate FROM Account];
        List<Case> cases = [SELECT Id, Account.Id FROM Case WHERE Account.Id != NULL];
        List<Contact> contacts = [SELECT Id, Account.Id FROM Contact WHERE Account.Id != NULL];
        List<Opportunity> opportunities = [SELECT Id, Account.Id, StageName, ExpectedRevenue FROM Opportunity WHERE Account.Id != NULL]; 
        
        Map<Id, ObjectWrapper> accountMap = new Map<Id, ObjectWrapper>();

        for(Account obj : accounts ) {
			accountMap.put( obj.Id, new ObjectWrapper(obj) );             
        }
        
        for( Case obj : cases ){
            if(accountMap.containsKey(obj.Account.Id)){
                ObjectWrapper unit = accountMap.get(obj.Account.Id);
                unit.noOfCases++; 
                if(unit.idOfCases != null && unit.idOfCases != '')
              		unit.idOfCases +=','+obj.Id; 
                else
                    unit.idOfCases = obj.Id;
            } 
        }
        
        // Counting no of contacts and Contacts ID
        for( Contact obj : contacts ){
            if(accountMap.containsKey(obj.Account.Id)){
                ObjectWrapper unit = accountMap.get(obj.Account.Id);
                unit.noOfContacts++; 
                if(unit.idOfContacts != null && unit.idOfContacts != '')
              		unit.idOfContacts +=','+obj.Id; 
                else
                    unit.idOfContacts = obj.Id;
            } 
        }
        
        //Counting no of opportunity and opportunity ID
        for( Opportunity obj : opportunities ){
            if(accountMap.containsKey(obj.Account.Id)){
                ObjectWrapper unit = accountMap.get(obj.Account.Id);                    
                    //Counting 'Closed Won' opportunities
                    if((obj.StageName).equals('Closed Won')){
                        unit.noOfOpportunitiesCW++;
                    if(unit.idOfOpportunitiesCW != null && unit.idOfOpportunitiesCW != '')
              			unit.idOfOpportunitiesCW +=','+obj.Id; 
                    else
                    	unit.idOfOpportunitiesCW = obj.Id;
                    }
                    
                    //Counting 'Closed Lost' opportunities
                    if((obj.StageName).equals('Closed Lost')){
                        unit.noOfOpportunitiesCL++;
                    if(unit.idOfOpportunitiesCL != null && unit.idOfOpportunitiesCL != '')
              			unit.idOfOpportunitiesCL +=','+obj.Id; 
                    else
                    	unit.idOfOpportunitiesCL = obj.Id;
                    }  
                
                   //Counting 'Open' opportunities
                	if(obj.StageName != 'Closed Lost' && obj.StageName != 'Closed Won'){
                        unit.noOfOpportunitiesOP++;
                    if(unit.idOfOpportunitiesOP != null && unit.idOfOpportunitiesOP != '')
              		    unit.idOfOpportunitiesOP +=','+obj.Id; 
                    else
                    	unit.idOfOpportunitiesOP = obj.Id;
                    }  
                    unit.noOfOpportunities++; 
               
                if(unit.idOfOpportunities != null && unit.idOfOpportunities != '')
              		unit.idOfOpportunities +=','+obj.Id; 
                else
                    unit.idOfOpportunities = obj.Id;
            } 
        }
        System.debug('accountMap '+JSON.serialize(accountMap) );
    }

    public void synchronizingAll(){
        List<AggregatedData__c> aggrObjList = new List<AggregatedData__c>();
        
        List<Case> cases = [SELECT Id, Account.Id FROM Case WHERE Account.Id != NULL];
        List<Contact> contacts = [SELECT Id, Account.Id FROM Contact WHERE Account.Id != NULL];
        List<Opportunity> opportunities = [SELECT Id, Account.Id, StageName, ExpectedRevenue FROM Opportunity WHERE Account.Id != NULL];    
        AggregatedData__c aggrObj;
        
        for( Account obj : [SELECT Id, Name, CreatedDate FROM Account Where CreatedDate != NULL  Limit 2] ) {
            Integer noOfCases = 0;
            Integer noOfContacts = 0;
            Integer noOfOpportunities = 0;
            Integer noOfOpportunitiesCW = 0;
            Integer noOfOpportunitiesCL = 0;
            Integer noOfOpportunitiesOP = 0;
            Decimal amountOfOpportunitiesER = 0;
            
            //Getting aggregate data for a Account
            
            //Getting Cases
            for(Case c : cases){ 
                if((obj.Id).equals(c.Account.Id)){
                    noOfCases++;
                }
            }
            System.debug(obj.Name+', Cases: '+ NoOfCases );
            
            //Getting Contacts
            for(Contact c : contacts){ 
                if((obj.Id).equals(c.Account.Id)){
                    noOfContacts++;
                }
            }
            System.debug(obj.Name+', Contacts: '+ noOfContacts );
            
            //Getting Opportunity
            for(Opportunity c : opportunities){ 
                if((obj.Id).equals(c.Account.Id)){ 
                    //Counting all opportunities
                    noOfOpportunities++;
                    
                    //Counting 'Closed Won' opportunities
                    if((c.StageName).equals('Closed Won')){
                        noOfOpportunitiesCW++;
                    }
                    
                    //Counting 'Closed Lost' opportunities
                    if((c.StageName).equals('Closed Lost')){
                        noOfOpportunitiesCL++;
                    }    
                    
                    // Calculating Expected Revenuue
                    amountOfOpportunitiesER += c.ExpectedRevenue;
                }
            }
            
            System.debug(obj.Name+', Opportunities: '+ noOfOpportunities );
            System.debug(obj.Name+', Opportunities - Closed Won: '+ noOfOpportunitiesCW );
            System.debug(obj.Name+', Opportunities - Closed Lost: '+ noOfOpportunitiesCL ); 
            System.debug(obj.Name+', Opportunities - Expected Revenue: '+ amountOfOpportunitiesER );
            
            System.debug('Creating Aggregate Object...');
            
            WeekUtility w = new WeekUtility(obj.CreatedDate);
            
            aggrObj = new AggregatedData__c();
            aggrObj.Account__c = obj.Id;
            aggrObj.Opportunities__c = noOfOpportunities;
            aggrObj.Contacts__c = noOfContacts;
            aggrObj.Cases__c = noOfCases;
            aggrObj.OpportunitiesCW__c = noOfOpportunitiesCW;
            aggrObj.OpportunitiesCL__c = noOfOpportunitiesCL;    
            aggrObj.OpportunitiesOP__c = noOfOpportunities - ( noOfOpportunitiesCW+noOfOpportunitiesCL);
            aggrObj.OpportunitiesER__c = amountOfOpportunitiesER ;
            aggrObj.Year__c = (obj.CreatedDate).year();
            aggrObj.WeekNumber__c = w.weekNumber;
            aggrObj.WeekStartDate__c = w.startDayOfWeek;
            aggrObj.WeekEndDate__c = w.endDayOfWeek; 
            
            aggrObjList.add(aggrObj);  
        } 
        
        Database.SaveResult[] results = Database.insert(aggrObjList, false);
        for (Database.SaveResult result : results) 
        {
            if (result.isSuccess()){
                System.debug('Record' + result.getId() + ' successfully created.');
            }
            else{
                if (result.getErrors().size() > 0){
                    System.debug(result.getErrors()[0].getMessage());
                }
            }
        }
    } 
    */
  
}