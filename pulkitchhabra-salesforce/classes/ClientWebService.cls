@RestResource(urlMapping='/clientwebservice')
global class ClientWebService{
	@httpGet
	global static String getAsJSON(){
        Map<Id, Account> AdvId = new Map<Id, Account>([Select Id from Account where RecordTypeId = '01228000000PK9P']);
    	Map<Id, Contact> ConId = new Map<Id, Contact>([Select Id from Contact]);
        String xJSONx;
        String i = RestContext.request.params.get('i');        
        if(AdvId.containsKey(i)){
        	xJSONx = AccountAsJSON(i);
        }
       else	if(ConId.containsKey(i)){
            xJSONx = ContactAsJSON(i);
        }
        else {
           xJSONx = 'Its Null Boss';
        }
		return xJSONx;
	}
    
    global static String AccountAsJSON(String i1){
        List<Account> adv = new List<Account>([Select Name,(Select Pulkit__Agency__r.Name from Pulkit__Client_Relations__r) from Account where Id =: i1]);
		String AccountJSON = System.JSON.serialize(adv);
		return AccountJSON;
    }
    
    global static String ContactAsJSON(String i2){
		List<Contact> con = new List<Contact>([Select Name,(Select Pulkit__Advertiser__r.Name from Pulkit__Client_Relations_del__r) from Contact where id =:i2]);
        String ContactJSON = System.JSON.serialize(con);
        return ContactJSON;
    }
}