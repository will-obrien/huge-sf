public class pssKeyValuePair{
    public string key {get; set;}
    public object value {get; set;}
    
    public pssKeyValuePair(string k, object v){
        this.key = k;
        this.value = v;
    }
}