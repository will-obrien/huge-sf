global virtual with sharing class TravelCtrlExt {
    
    private final Travel__c travel;
    private ApexPages.StandardController stdCtrl;
    protected List<Expense__c> sortedExpenses = new List<Expense__c>();
    private List<Expense__c> dailyExpenses = new List<Expense__c>();
    
  
    // CONSTRUCTOR
    
    public TravelCtrlExt(ApexPages.StandardController standardController) {
        stdCtrl = standardController;
        
        travel = [SELECT Id, Name, CurrencyIsoCode, txt_Reason__c, txa_Description__c, 
                         dtm_Start__c, dtm_End__c, Owner.FirstName, Owner.LastName, 
                         rsum_TotalExpenses__c, rsum_ReimbursableExpenses__c, rsum_PerDiems__c, 
                         fcur_Reimbursement__c, 
                         (SELECT Id FROM Expenses__r),
                         (SELECT Id FROM MealInvitations__r),
                         (SELECT Id FROM Travel_Contact_Associations__r)
                  FROM Travel__c
                  WHERE Id = :stdCtrl.getId()];         
    }
    
    
    //GLOBAL METHODS
    
    @RemoteAction
    global static String getRecordStatus(Id recordId) {
        String result = '';
        List<ProcessInstance> processes = [SELECT Id, Status, CreatedDate 
                                           FROM ProcessInstance 
                                           WHERE TargetObjectId = :recordId];
        if(processes.size() > 0) {
            ProcessInstance processinstance = processes[0];
            for(ProcessInstance p : processes) {
                if(p.CreatedDate > processinstance.CreatedDate) {
                    processinstance = p;
                }
            }
            result = processinstance.Status;
        }
    
        return result;
    }
    

    // PUBLIC METHODS
    
    public List<Expense__c> getSortedExpenses() {
        return sortedExpenses;
    }
    
    
    public List<DailySummaries.Row> getDailySummaries() {
        List<DailySummaries.Row> results = new DailySummaries(sortedExpenses).getRows();
        
        return results;
    }
    
    
    public List<Expense__c> getDailyExpenses() {
        return dailyExpenses; 
    }
    
    
    public List<ExpenseElement> getExpenseElements() {
    	List<ExpenseElement> results = new List<ExpenseElement>();
    	List<ExpenseElement> elements = new List<ExpenseElement>();
    	
    	ExpenseElement element;
    	if(!sortedExpenses.isEmpty()) {
    		for(Expense__c e : sortedExpenses) {
    			element = new ExpenseElement();
    			
    			element.day = e.dat_ExpenseDate__c.format();
    			element.recordType = e.RecordType.Name;
    			element.amount = e.CurrencyIsoCode + ' ' + e.cur_Amount__c;
    			element.details = getDetails(e);
    			element.id = e.id;
    			
    			elements.add(element);
    			
    			if(e.chk_RoundTrip__c) {
    				element = new ExpenseElement();
    			
	    			element.day = e.dtm_ReturnDeparture__c.date().format();
	    			element.recordType = e.RecordType.Name;
	    			element.amount = '-';
	    			element.details = 'From "' + e.txt_To__c + '" to "' + e.txt_From__c + '"';
	    			element.id = e.id;
	    			
	    			elements.add(element);
    			}
    		}
    	}
    	
    	elements.sort();
    	
    	results = insertBlancRows(elements);
    	
    	return results;
    }
    
    
    public String getOwner() {
        String result = travel.Owner.FirstName + ' ' + travel.Owner.LastName;
        
        return result;
    }
    
    
    public Decimal getTotalExpenses() {
        Decimal result = travel.rsum_TotalExpenses__c.setScale(2);
        
        return result;
    }
    
    
    public Decimal getReimbursableExpenses() {
        Decimal result = travel.rsum_ReimbursableExpenses__c.setScale(2);
        
        return result;
    } 
    
    
    public Decimal getTotalPerDiems() {
        Decimal result = travel.rsum_PerDiems__c.setScale(2);
        
        return result;
    }
    
    
    public Decimal getTotalReimbursement() {
        Decimal result = travel.fcur_Reimbursement__c.setScale(2);
        
        return result;
    }

    
    public void doGeneratePerDiemsAndLists() {
        doGeneratePerDiems();
        doInitializeLists();
    }
    
    
    public void doInitializeLists() {
        sortExpenses();
        calculateDailyExpenses();
    }


    public void doGeneratePerDiems() {
        PerDiemCalculator perDiemCalculator = new PerDiemCalculator(travel);
        perDiemCalculator.calculate();
    }
    
    
    public PageReference doRedirectToTravel() {
        PageReference result = stdCtrl.view();

        return result;
    }
    
    
    public PageReference doValidateOnSubmit() {
        PageReference result;
        
        checkIfTravelIsLocked();
        
        RuleValidator validator = new RuleValidator(RuleType.SubmitTravelRule);
        validator.validate(new List<SObject>{ travel });
        
        if(!ApexPages.hasMessages()) {
            result = new PageReference('/apex/travelSubmit?id='+travel.Id);  
            result.setRedirect(true);  
        }
        else {
            result = null;
        }
        
        return result;
    }
    

    public PageReference doGenerateTravelExpenseReport() {
        PageReference result = new PageReference('/apex/travelExpenseReport?id='+travel.Id);
        result.setRedirect(true);
        
        return result;   
    }
    
    
    // PRIVATE METHODS
    
    private String getDetails(Expense__c e) {
    	String result = '';
    	
		if(e.RecordType.DeveloperName == 'Accommodation') {
			result = e.txt_LodgingAdress__c;
		} 
		else if(e.RecordType.DeveloperName == 'CompanyVehicleRide') {
			result = 'From "' + e.txt_From__c + '" to "' + e.txt_To__c + '"';
		}
		else if(e.RecordType.DeveloperName == 'Entertainment') {
			result = e.txt_PlaceOfEntertainment__c;
		}
		else if(e.RecordType.DeveloperName == 'Flight') {
			result = 'From "' + e.txt_From__c + '" to "' + e.txt_To__c + '"';
		}
		else if(e.RecordType.DeveloperName == 'Miscellaneous') {
			result = e.txt_Reason__c;
		}
		else if(e.RecordType.DeveloperName == 'perDiem') {
			result = e.lkp_Location__r.Name;
		}
		else if(e.RecordType.DeveloperName == 'PrivateVehicleRide') {
			result = 'From "' + e.txt_From__c + '" to "' + e.txt_To__c + '"';
		}
		else if(e.RecordType.DeveloperName == 'RentalVehicle') {
			result = e.dat_PickUpDate__c.format() + ' till ' + e.dat_ReturnDate__c.format();
		}
		else if(e.RecordType.DeveloperName == 'SeaTravel') {
			result = 'From "' + e.txt_From__c + '" to "' + e.txt_To__c + '"';
		}
		else if(e.RecordType.DeveloperName == 'TrainRide') {
			result = 'From "' + e.txt_From__c + '" to "' + e.txt_To__c + '"';
		}    
    	
    	return result;
    }
    
    private List<ExpenseElement> insertBlancRows(List<ExpenseElement> elements) {
    	List<ExpenseElement> results = new List<ExpenseElement>();
    	
    	if(!elements.isEmpty()) {
            ExpenseElement element = elements[0];
            ExpenseElement emptyElement = new ExpenseElement();
            for(ExpenseElement e : elements) {
                if(e.day != element.day) {
                    results.add(emptyElement);
                    element = e;    
                }
                results.add(e);
            }
        }
    	
    	return results;
    }
    
    
    private void checkIfTravelIsLocked() {
        Savepoint sp = Database.setSavepoint();

        try {
            update travel;
        }
        catch(DMLException ex) {
            if(ex.getMessage().contains('ENTITY_IS_LOCKED')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Travel is locked for approval.'));
            }
        }
        
        Database.rollback(sp);
    }
    
    
    private void sortExpenses() {
        sortedExpenses = [SELECT Id, Name, RecordType.Name, RecordType.DeveloperName, cur_Amount__c, dtm_DepartureTime__c, 
                                 dtm_ArrivalTime__c, dat_CheckInDate__c, dat_CheckOutDate__c, txt_Reason__c,
                                 txt_LodgingAdress__c, txt_From__c, txt_To__c, txt_PlaceOfEntertainment__c, 
                                 lkp_Location__c, CurrencyIsoCode, dat_ExpenseDate__c, mdr_Travel__c, dtm_ReturnDeparture__c,
                                 pkl_Reimbursement__c,cur_OriginalAmount__c, lkp_Location__r.Name, chk_RoundTrip__c,
                                 dat_PickUpDate__c, dat_ReturnDate__c,
                                 lkp_Location__r.cur_FullDailyRate__c,
                                 lkp_MealInvitation__r.lkp_Breakfast__c,lkp_MealInvitation__r.lkp_Breakfast__r.pct_FullDayAllowanceRate__c,
                                 lkp_MealInvitation__r.lkp_Lunch__c,lkp_MealInvitation__r.lkp_Lunch__r.pct_FullDayAllowanceRate__c,
                                 lkp_MealInvitation__r.lkp_Dinner__c,lkp_MealInvitation__r.lkp_Dinner__r.pct_FullDayAllowanceRate__c
                          FROM Expense__c
                          WHERE mdr_Travel__c = :travel.Id
                          ORDER BY dat_ExpenseDate__c ASC, dtm_DepartureTime__c ASC, RecordType.Name ASC];
    }

    
    private void calculateDailyExpenses() {
        Map<Date, Decimal> expensePerDate = new Map<Date, Decimal>();
        
        for(AggregateResult ar : [SELECT dat_ExpenseDate__c tag, SUM(cur_Amount__c) summe 
                                  FROM Expense__c
                                  WHERE mdr_Travel__c = :stdCtrl.getId()
                                  GROUP BY dat_ExpenseDate__c]) {
            Date tag = (Date) ar.get('tag');
            Decimal summe = (Decimal) ar.get('summe');
            expensePerDate.put(tag, summe);
        }
                
        List<Date> dates= new List<Date>(); 
        for(Date d : expensePerDate.keySet()) {
            dates.add(d);
        }
        dates.sort();
        
        List<CurrencyType> currencyTypeEur = [SELECT ConversionRate
                                              FROM CurrencyType
                                              WHERE IsoCode = 'EUR'];
        Decimal currencyRateEur = currencyTypeEur[0].ConversionRate;
        
        Expense__c e;
        for(Date d : dates) {
            Decimal amountInEuro = (expensePerDate.get(d) * currencyRateEur).setScale(2);
            e = new Expense__c(cur_Amount__c = amountInEuro, dat_ExpenseDate__c = d, CurrencyIsoCode = 'EUR');
            dailyExpenses.add(e);
        }       
    }
    
    // INNER CLASSES
    
    public class ExpenseElement implements Comparable {
    	public String day { get; set; }
    	public String recordType { get; set; }
        public String amount { get; set; }
        public String details { get; set; }
        public Id id { get; set; }
    	
    	public Integer compareTo(Object compareTo) {
	        ExpenseElement compareToEle = (ExpenseElement)compareTo;
	        if (day == compareToEle.day) return 0;
	        if (day > compareToEle.day) return 1;
	        return -1;        
    	}
    }
}