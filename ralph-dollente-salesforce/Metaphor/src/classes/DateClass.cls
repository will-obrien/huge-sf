public class DateClass{    
    public String udate {get; set;}
    public Personal_UsageClass usage {get; set;}
    
    public DateClass(String d, Personal_UsageClass usage){
        this.udate = d;
        this.usage = usage;
    }
}