public with sharing class StrategyEvaluator {
   private String Name;
   private String Matching_Type;
   private String Matching_Value;
   private Decimal Score;
   private String Strategy_Name;
   private Decimal Weight;
   private String operator;
   
   public void setName(String name){
   	  this.Name = name; 
   }
   public String getName(){
   		return this.Name;
   }
   
   public void setMatchingType(String Matching_Type){
   		this.Matching_Type = Matching_Type;
   }
   
   public String getMatchingType(){
   		return this.Matching_Type;
   }
   
   public void setMatchingValue(String Matching_Value){
   		this.Matching_Value = Matching_Value;
   }
   
   public String getMatchingValue(){
   		return this.Matching_Value;
   }
   
   public void setScore(Decimal score){
   		this.Score = score;
   }
   
   public Decimal getScore(){
   	return this.Score;
   }
   
   public void setWeight(Decimal Weight){
   		this.Weight = Weight;
   }
   
   public Decimal getWeight(){
   		return this.Weight;
   }
   
   public void setStrategyName(String strategyName){
   		this.Strategy_Name = strategyName;
   }
   
   public String getStrategyName(){
   		return this.Strategy_Name;
   }
   
   public void setOperator(String operator){
   		this.operator = operator;
   }
   
   public String getOperator(){
   		return this.operator;
   }
}