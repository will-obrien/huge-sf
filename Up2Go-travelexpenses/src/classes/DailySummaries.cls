public with sharing class DailySummaries {
	
	private Id travelId;
	private List<Expense__c> sortedExpenses;


	// CONSTRUCTOR
	
    public DailySummaries(List<Expense__c> sortedExpenses) {
    	this.sortedExpenses = sortedExpenses;
    } 
    
        
    //  PUBLIC METHODS    
    
    public List<Row> getRows() {
        List<Row> results = new List<Row>();
        
        if(sortedExpenses.size() > 0) {
        	travelId = sortedExpenses.get(0).mdr_Travel__c;
        	
	    	Map<Date, Decimal> dailyExpenseAmounts = calculateAmounts(false);
	        Map<Date, Decimal> dailyReimbursableAmounts = calculateAmounts(true);
	
	        for(Date d : sortedDays()) {
	            Row row = new Row();
	            row.day = d.format();
	            row.expenses = createElementList(d);
	
	            Decimal amount = dailyExpenseAmounts.get(d);
	            row.amount = amountNotNull(amount);
	
	            Decimal reimbursableAmount = dailyReimbursableAmounts.get(d);
	            row.reimbursableAmount = amountNotNull(reimbursableAmount);
	
	            results.add(row);
	        }
        }

        return results;
    }
    
    
    // PRIVATE METHODS
    
    private Map<Date, Decimal> calculateAmounts(Boolean justReimbursable) {
        Map<Date, Decimal> result = new Map<Date, Decimal>();
        
        List<CurrencyType> currencyTypeEur = [SELECT ConversionRate
                                              FROM CurrencyType
                                              WHERE IsoCode = 'EUR'];
        Decimal currencyRateEur = currencyTypeEur[0].ConversionRate;
        
        for(AggregateResult ar : queryExpenses(justReimbursable)) {
            Date tag = (Date) ar.get('tag');
            Decimal summe = ( (Decimal) ar.get('summe') );
            summe = ( summe * currencyRateEur ).setScale(2);
    
            result.put(tag, summe);
        }
        
        return result;
    }
    
    
    private List<AggregateResult> queryExpenses(Boolean justReimbursable) {
        List<AggregateResult> results;
        
        if(justReimbursable) {
            results = [SELECT dat_ExpenseDate__c tag, SUM(cur_Amount__c) summe 
                       FROM Expense__c
                       WHERE mdr_Travel__c = :travelId
                       AND pkl_Reimbursement__c = 'I paid for this, please reimburse me.'
                       GROUP BY dat_ExpenseDate__c];
        }
        else {
            results = [SELECT dat_ExpenseDate__c tag, SUM(cur_Amount__c) summe 
                       FROM Expense__c
                       WHERE mdr_Travel__c = :travelId
                       GROUP BY dat_ExpenseDate__c];
        }   
        
        return results;     
    }
    

    private List<Date> sortedDays() {
        List<Date> results;

        Set<Date> uniqueDays = new Set<Date>();
        for(Expense__c expense : sortedExpenses) {
            uniqueDays.add(expense.dat_ExpenseDate__c);
        }

        results = new List<Date>(uniqueDays);
        results.sort();

        return results;
    }
    

    private List<RowElement> createElementList(Date d) {
        List<RowElement> results = new List<RowElement>();

        for(Expense__c e : sortedExpenses) {
            if(d.isSameDay(e.dat_ExpenseDate__c)) {
                RowElement element = new RowElement();
                element.name = e.RecordType.Name;
                element.amount = e.cur_Amount__c;
                element.elementCurrency = e.CurrencyIsoCode;
                element.reimbursable = isReimbursable(e);

                if (isPerDiemWithDeduction(e)) {
                    RowElement beforeDeduction = new RowElement();
                    beforeDeduction.Name = 'Per Diem vor Kürzungen';
                    beforeDeduction.amount = e.cur_OriginalAmount__c;
                    beforeDeduction.elementCurrency = e.CurrencyIsoCode;
                    beforeDeduction.isDeduction = true;

                    results.add(beforeDeduction);

                    results.addAll(generateDeductionElements(e));

                    element.name = 'Per Diem nach Kürzungen';
                }

                results.add(element);
            }
        }

        return results;
    }


    private Boolean isReimbursable(Expense__c e) {
        Boolean result = e.pkl_Reimbursement__c.equals('I paid for this, please reimburse me.');

        return result;
    }


    private Boolean isPerDiemWithDeduction(Expense__c e) {
        Boolean result = ExpenseType.isPerDiem(e) && (e.lkp_MealInvitation__r.lkp_Breakfast__c != null 
                                                      || e.lkp_MealInvitation__r.lkp_Lunch__c != null 
                                                      || e.lkp_MealInvitation__r.lkp_Dinner__c != null);

        return result;
    }


    private Decimal amountNotNull(Decimal amount) {
        Decimal result;

        if(amount == null) {
            result = 0.00;
        }
        else {
            result = amount;
        }

        return result;
    }
    
    private List<RowElement> generateDeductionElements(Expense__c e) {
        List<RowElement> results = new List<RowElement>();
        RowElement element;
        Decimal amount; 

        if(e.lkp_MealInvitation__r.lkp_Breakfast__c != null) {
            amount = e.lkp_MealInvitation__r.lkp_Breakfast__r.pct_FullDayAllowanceRate__c;
            element = createDeductionInfo(e,'> Gekürzt für Frühstück',amount);   

            results.add(element);
        }
        if(e.lkp_MealInvitation__r.lkp_Lunch__c != null) {
            amount = e.lkp_MealInvitation__r.lkp_Lunch__r.pct_FullDayAllowanceRate__c;
            element = createDeductionInfo(e,'> Gekürzt für Mittagessen',amount); 

            results.add(element);
        }
        if(e.lkp_MealInvitation__r.lkp_Dinner__c != null) {
            amount = e.lkp_MealInvitation__r.lkp_Dinner__r.pct_FullDayAllowanceRate__c;
            element = createDeductionInfo(e,'> Gekürzt für Abendessen',amount); 

            results.add(element);
        }

        return results;
    }


    private RowElement createDeductionInfo(Expense__c e, String text, Decimal amount) {
        RowElement result = new RowElement();

        result.Name = text;
        result.amount = amount * e.lkp_Location__r.cur_FullDailyRate__c /100;
        result.elementCurrency = e.CurrencyIsoCode;
        result.isDeduction = true;

        return result;
    }
    
    
    // INNER CLASSES
    
    public class Row {
        public String day { get; set; }
        public List<RowElement> expenses { get; set; }
        public Decimal amount { get; set; }
        public Decimal reimbursableAmount { get; set; }
    }
    
    
    public class RowElement {
        public String name{ get; set; }
        public Decimal amount {get; set; }
        public Boolean reimbursable {get; set; }
        public String elementCurrency { get; set; }
        public Boolean isDeduction { get; set;}
    }
}