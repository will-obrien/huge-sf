public class Internal_Webinars{
    
    public string webinar_id {get;set;}
    public list<string> list_webinar_ids {get;set;}
    //public map<object> map_webinar {get;set;}
	public map<string,map<string,object>> map_webinars {get;set;}
    
    /**
     * Constructor
     */
    public Internal_Webinars()
    {
        this.list_webinar_ids = new list<string>();
        //this.map_webinar = new map<object>();
    	this.map_webinars = new map<string,map<string,object>>();
     	this.webinar_id = System.currentPageReference().getParameters().get('id');
        
        this.getWebinars();
        /*
        if(this.webinar_id != null){
        	this.getWebinar(webinar_id);
        }
		*/
    }
    
    public void getWebinar(string webinar_id)
    {
        
    }
    
    public void getWebinars()
    {

        AggregateResult[] results = [SELECT Webinar__c, COUNT(Name) visit_count 
                                     FROM Statistics__c 
                                     GROUP BY Webinar__c];
        if(!results.isEmpty()){
            for (AggregateResult r : results){
                string webinar_id = (string)r.get('Webinar__c');
                integer visit_count = (integer)r.get('visit_count');
                
				//build webinar id list to select relational data
				this.list_webinar_ids.add(webinar_id);   
                
                //build webinar redirect object to display
                this.map_webinars.put(webinar_id, new map<string,Object>());
                this.map_webinars.get(webinar_id).put('webinar_id',webinar_id);
                this.map_webinars.get(webinar_id).put('visit_count',visit_count);
            }
            
            Webinar__c[] webinars = [SELECT Id, Attended__c, Actual_Start_Time__c, Time_at_Close__c 
                                  	 FROM Webinar__c 
                                  	 WHERE Id IN :list_webinar_ids];
            
            for(Webinar__c w : webinars){
                
                System.debug('DEBUG:: webinar ID: ' + w.get('Id'));
                System.debug('DEBUG:: Attended__c: ' + w.get('Attended__c'));
                System.debug('DEBUG:: Actual_Start_Time__c: ' + w.get('Actual_Start_Time__c'));
                System.debug('DEBUG:: Time_at_Close__c: ' + w.get('Time_at_Close__c'));
               
                string webinar_id = (string)w.get('Id');
                decimal attended_count = (decimal)w.get('Attended__c');
                datetime start_time = (datetime)w.get('Actual_Start_Time__c');
                datetime end_time = (datetime)w.get('Time_at_Close__c');
                
                this.map_webinars.get(webinar_id).put('attended_count',attended_count);
                this.map_webinars.get(webinar_id).put('start_time',start_time);
                this.map_webinars.get(webinar_id).put('end_time',end_time);
               
            }
            System.debug('map_webinars');
            System.debug(this.map_webinars);
            
        }else{
            System.debug('No records found');
        }   

    }
    
}