public class GoogleEarthMappController {
    
    public Double latitude {get; private set;}
    public Double longitude {get; private set;}

    public GoogleEarthMappController(){
        Id accId = apexpages.currentpage().getparameters().get('id');
        Account ac =  [SELECT Coordinates__c FROM Account WHERE Id =: accId][0];
        if(ac.Coordinates__c != null){
            Location loc = ac.Coordinates__c;
            latitude = loc.getLatitude();
            longitude = loc.getLongitude();
        }  
    }
    
    @AuraEnabled 
    public static String getSalesforceBaseURL(){
        return system.URL.getSalesforceBaseUrl().toExternalForm();
    }
}