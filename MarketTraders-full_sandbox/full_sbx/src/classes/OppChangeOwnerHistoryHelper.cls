public without sharing class OppChangeOwnerHistoryHelper {
	public class OppChangeOwnerHistoryHelperException extends Exception {}
	
	private List<Opportunity> newOpps;
    private List<Opportunity> oldOpps;
    private Map<Id,Opportunity> newOppMap;
    private Map<Id,Opportunity> oldOppMap;
  
    public static Boolean BYPASS = false;
    
    public void executeRefactoredCode(List<SObject> newList, List<SObject> oldList, Map<Id, sObject> newMap, Map<Id, sObject> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isAfter) {
    	if (!OppChangeOwnerHistoryHelper.BYPASS) {
    		
    		this.newOpps = (List<Opportunity>)newList;
        	this.oldOpps = (List<Opportunity>)oldList;
        	this.newOppMap = (Map<Id ,Opportunity>)newMap;
        	this.oldOppMap = (Map<Id, Opportunity>)oldMap;
    		
    		List<Opportunity_Owner_History__c> OpportunityHistoryList = new List<Opportunity_Owner_History__c>();
    
		    for (Opportunity op : newOpps){        
		        if (isAfter && isInsert) {                                              
		            system.debug('****op.OwnerId*******'+op.OwnerId);
		            
		            Opportunity_Owner_History__c OppHistory = new Opportunity_Owner_History__c();                    
		            OppHistory.Opportunity__c = op.id;
		            OppHistory.Stage__c = op.StageName;                    
		            OppHistory.Type__c = 'Weekly';  // Changed
		            OppHistory.Product_List__c = op.Product__c ;
		            OppHistory.Date_Acquired__c = system.now();                    
		            OppHistory.User2__c = op.OwnerId;
		            
		            Opportunity_Owner_History__c OppHistory2 = new Opportunity_Owner_History__c();                    
		            OppHistory2.Opportunity__c = op.id;
		            OppHistory2.Stage__c = op.StageName;                    
		            OppHistory2.Type__c = 'Monthly';  // Changed
		            OppHistory2.Product_List__c = op.Product__c ;
		            OppHistory2.Date_Acquired__c = system.now();                    
		            OppHistory2.User2__c = op.OwnerId;
		                                                    
		            OpportunityHistoryList.add(OppHistory);
		            OpportunityHistoryList.add(OppHistory2);
		        } 
		    }
    
    		if (isAfter && isUpdate) {
        		Set<String> Oppids = new Set<String>();
        		Set<String> OwnerOppids = new Set<String>();
        
        		for (Opportunity opObj : newOpps){ 
            		if (opObj.OwnerId != oldOppMap.get(opObj.id).OwnerId) {
                		Oppids.add(opObj.id);
                		OwnerOppids.add(opObj.OwnerId);
            		}
    			}
        

		        Date todayDate = System.today();      
		        Date FDateOfMonth = todayDate.toStartOfMonth();
		        Date LDateOfMonth = FDateOfMonth.addDays(date.daysInMonth(todayDate.year(), todayDate.month()) - 1);


				/* Anthony trying to "fix" Historys__r" reference...
        			For(Opportunity Objt :[select id,StageName,Product__c,OwnerId,
                                (select id,Opportunity__c, Stage__c, Type__c, Product_List__c, Date_Acquired__c, User2__c, User__c, CreatedDate 
                                from Opportunity_Owner_History__r where User2__c in: OwnerOppids) 
                                from opportunity where id in :Oppids]){
				END Anthony "fix" */
        		for (Opportunity Objt :[select id,StageName,Product__c,OwnerId,
                                (select id,Opportunity__c, Stage__c, Type__c, Product_List__c, Date_Acquired__c, User2__c, User__c, CreatedDate 
                                from Opportunity_Owner_Historys__r where User2__c in: OwnerOppids) 
                                from opportunity where id in :Oppids]) {
            
            		Boolean FlagForMonthly = true;
            		Boolean FlagForWeekly = true;

            
					/* Anthony trying to "fix" Historys__r" reference...
            			For(Opportunity_Owner_History__c OOHObj : Objt.Opportunity_Owner_History__r){               
					END Anthony "fix" */
            		for (Opportunity_Owner_History__c OOHObj : Objt.Opportunity_Owner_Historys__r) {               
                	// For Monthly.
                		if (OOHObj.Date_Acquired__c.date() >= FDateOfMonth && OOHObj.Date_Acquired__c.date() <= LDateOfMonth && Objt.ownerid == OOHObj.User2__c && OOHObj.Type__c == 'Monthly') {
                   			FlagForMonthly = false;
                   			system.debug('******ifififififififif1111111111********');
                		}
                		system.debug('******FlagForMonthly ********:: ' + FlagForMonthly );
                
		                // For weekly.
		                Date todayDateWeekly = System.today();
		                Date FDayOfWeek = todayDateWeekly.toStartOfWeek();
		                Date LDayOfWeek = FDayOfWeek.addDays(6);                
		                system.debug('******FDayOfWeek ********' + FDayOfWeek );
		                system.debug('******LDayOfWeek ********' + LDayOfWeek );
		                system.debug('******OOHObj.Date_Acquired__c.date()********' + OOHObj.Date_Acquired__c.date());
                 
                		if(OOHObj.Date_Acquired__c.date() >= FDayOfWeek && OOHObj.Date_Acquired__c.date() <= LDayOfWeek && Objt.ownerid == OOHObj.User2__c && OOHObj.Type__c == 'Weekly'){
                    		FlagForWeekly = false;
                    		system.debug('******ifififififififif2222222222222********');
                		} 
                		system.debug('******FlagForWeekly********:: ' + FlagForWeekly);           
            		}
            

		            if (FlagForMonthly) {
		                Opportunity_Owner_History__c OppHistMnth = new Opportunity_Owner_History__c();                    
		                OppHistMnth.Opportunity__c = Objt.id;
		                OppHistMnth.Stage__c = Objt.StageName;                    
		                OppHistMnth.Type__c = 'Monthly';  // Changed
		                OppHistMnth.Product_List__c = Objt.Product__c ;
		                OppHistMnth.Date_Acquired__c = system.now();                    
		                OppHistMnth.User2__c = Objt.OwnerId;
		                OppHistMnth.User__c = oldOppMap.get(Objt.id).OwnerId;
		                OpportunityHistoryList.add(OppHistMnth);  
		            }
            

		            if (FlagForWeekly) {
		                Opportunity_Owner_History__c OppHistWeekly = new Opportunity_Owner_History__c();                    
		                OppHistWeekly.Opportunity__c = Objt.id;
		                OppHistWeekly.Stage__c = Objt.StageName;                    
		                OppHistWeekly.Type__c = 'Weekly';  // Changed
		                OppHistWeekly.Product_List__c = Objt.Product__c ;
		                OppHistWeekly.Date_Acquired__c = system.now();                    
		                OppHistWeekly.User2__c = Objt.OwnerId;
		                OppHistWeekly.User__c = oldOppMap.get(Objt.id).OwnerId;
		                OpportunityHistoryList.add(OppHistWeekly);
		            }
        		}
    		}
    
    		system.debug('******OpportunityHistoryList.size()********:: ' + OpportunityHistoryList.size());
		    if (OpportunityHistoryList.size() > 0) {
		        insert OpportunityHistoryList;
		    }
    	} // end bypass	
    }  // end executeTrigger
}