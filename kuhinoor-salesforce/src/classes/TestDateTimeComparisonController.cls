public class TestDateTimeComparisonController{
    public Datetime startTime {get;set;}
    public Datetime endTime {get;set;}
    public TestDateTimeComparisonController(){
        startTime = Datetime.now();
        endTIme = Datetime.now().addHours(-5);
    
    }
}