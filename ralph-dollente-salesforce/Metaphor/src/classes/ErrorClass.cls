public class ErrorClass{
    public String Code {get; set;}
    public String Msg {get; set;}
    public String Spiel {get; set;}

    public ErrorClass(String c, String m, String s){
        this.Code = c;
        this.Msg = m;
        this.Spiel = s;    
    }
}