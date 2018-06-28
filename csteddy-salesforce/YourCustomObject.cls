public class YourCustomObject{
    private Map<String, String> fieldMap = new Map<String, String>{'someField' => this.someField};
    public String someField{get;set;}
    public Boolean check {get;set;}
static {
    system.debug(JSON.serialize(new YourCustomObject()));
    }
    public YourCustomObject(){
        
        this.someField = 'someText';
    }
    
    public String getField(String fieldName){
        Map<String, String> fieldMap = new Map<String, String>{'someField' => this.someField};
    return (fieldMap.get(fieldName) == null)?'':fieldMap.get(fieldName);
    }
}
