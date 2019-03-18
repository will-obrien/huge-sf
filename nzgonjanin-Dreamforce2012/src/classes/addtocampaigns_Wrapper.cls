public with sharing class addtocampaigns_Wrapper {
	
	//variables used for creating add to Campaigns record  
	public String message{ get; set; } //success message
	public Boolean checked{ get; set; } //check box for selection
	public Boolean disabled {get; set;} //if member is alread part of campaign selection check box is disabled 
    public Campaign camp { get; set;}   //Campaign record returned as part of data set driven by listView filter
 
    public addtocampaigns_Wrapper(){
    	//constructor without passed parameters
        camp = new Campaign();
        checked = false;
        disabled = false;
        message='';
    }
 	
 	public addtocampaigns_Wrapper(Campaign c){
 		//constructor with passed parameters
        camp = c;
        checked = false;
        disabled = false;
        message='';
    }
}//end of class