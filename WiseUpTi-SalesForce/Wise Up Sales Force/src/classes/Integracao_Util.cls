global class Integracao_Util {

    public Integracao_Util() {
        
    }


    public static Map<String,Object> Json_deserialize(Object obj){
         // Serialize our Object into JSON
        String s = JSON.serialize(obj);

        // Deserialize it back into a key/value map
        Map<String,Object> mapObj = 
            (Map<String,Object>) JSON.deserializeUntyped(s);

        // Return a Set of those fields present on our object
        return mapObj;
    }

    public static String Serialize_multipart(Object obj){
        Map<String, Object> mapObj = Json_deserialize(obj);
        String result = '';
        boolean oneTry = false;
        for(String key : mapObj.keySet()){
            if(mapObj.get(key) != null){
                if(!oneTry){                    
                    result += key + '=' + String.valueOf(mapObj.get(key)).replace(' ', '+');
                    oneTry = true;
                }else{                    
                    result += '&' + key + '=' + String.valueOf(mapObj.get(key)).replace(' ', '+');
                }
            }
        }
        return result;
    }
    
    
    global class RequestResult {
        public Boolean value {get;set;}
        public String message {get; set;}
    } 
    
    global class OppRequestResult{
        public Boolean success { get; set; }
        public String pkRequest { get; set; }
    } 
    
    global class errorAccountResult{
        public String httpStatus { get ; set; }
        public String code { get ; set; }
        public String message { get ; set; }
        public String cause { get ; set; }
    }
    
    global class restLeadConverterResult {
        public Boolean value {get;set;}
        public String message {get; set;}
        public String AccountId {get; set;}
        public String OpportunityId {get;set;}
    }
    




}