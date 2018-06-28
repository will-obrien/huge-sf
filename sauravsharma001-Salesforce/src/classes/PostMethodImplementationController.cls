public with sharing class PostMethodImplementationController {

    public string orgainzation{get;set;}
    public string appName{get;set;} 
    public string productUrl{get;set;}
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string email{get;set;}
    public String phone{get;set;}
    public string url{get;set;}
    public string key{get;set;} 
    APIkey_Register__c v = new APIkey_Register__c(); 
    boolean flag1=false;    
    PageReference pageRef;
    
    public PostMethodImplementationController(){ 
    
    }

	public PageReference save() {
        
        list<APIkey_Register__c> obj1 =[Select url_Open311__c from APIkey_Register__c where url_Open311__c=:productUrl];
        
        if(obj1.isEmpty()){

            APIkey_Register__c obj = new APIkey_Register__c();
            obj.Organization_Open311__c = orgainzation;
            obj.Name =appName;
            obj.URL_Open311__c = productUrl;
            obj.First_Name_Open311__c=firstName;
            obj.Last_Name_Open311__c = lastName;
            obj.Email_Open311__c = email;
            obj.Phone_Open311__c = phone;
               
            insert(obj);
            v =[select Key_Open311__c from APIkey_Register__c where url_Open311__c =:productUrl] ;
            key=string.valueOf(v.key_Open311__c);

            pageRef = new PageReference('https://311-developer-edition.ap1.force.com/apps/AppKeyRegistrationSuccess');
            pageRef.getParameters().put('key',string.valueOf(v.key_Open311__c));
                      
        } 
        else if((obj1.isEmpty()==false)){   
     
            v =[select Key_Open311__c from APIkey_Register__c where URL_Open311__c =:productUrl] ;
            key=string.valueOf(v.key_Open311__c);
            pageRef = new PageReference('https://311-developer-edition.ap1.force.com/apps/AppKeyRegistrationFailure');
			pageRef.getParameters().put('key',string.valueOf(v.key_Open311__c));  

		}
		return pageRef;          
	}
}