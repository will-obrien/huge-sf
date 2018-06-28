public class cct_ObjectCreator {
	public static Product__c createProduct(){
		Product__c product = new Product__c();

		product.Name = 'TestLoan';
		product.SellingCriterion__c = '{ "Year": "4" }';
		product.Product_Instance__c = 'Amrita';
		product.ScoreCard__c = null;

		return product;
	}

	public static EvaluationCriterion__c createEvaluationCriterion(){
		EvaluationCriterion__c criterion = new EvaluationCriterion__c();
		criterion.Name = 'TestLoan';
		criterion.Matching_Type__c = 'Year';
		criterion.Matching_Value__c = '3';
		criterion.Score__c = 10.00;
		criterion.Strategy_Name__c = 'Loan';
		criterion.Weight__c = 5.00;
		criterion.Operator__c = '>';
		return criterion;
	}

	public static Stratergy__c createStrategy(){
		Stratergy__c strategy = new Stratergy__c();
		strategy.Name = 'Loan';
		strategy.Name__c = 'Car Loan';
		strategy.Description__c = '{"criteria": [{"Matching_Type": "Year","Matching_Value": "3","Score": 10.00,"Weightage":5.00}]}';
		return strategy;
	}
}