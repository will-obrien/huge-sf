public class ChartDataWrapper{
    @AuraEnabled
    public String name{get; set;}
    @AuraEnabled
    public List<Decimal> numericData{get; set;}

    public ChartDataWrapper(String name, List<Decimal> numericData){
        this.name = name;
        this.numericData = numericData;
    }
}