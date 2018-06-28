/**
* This controller will be used by Group Event Page
* which will create Group event and add related list 
* 
* @author  Jiten Joysar
* @version 1.0
* @since   2017-01-22 
*/
public with sharing class CreateGroupEventSLDSController {
	
 /* ATTRIBUTES */
 
 public Id AccountId ;
 public Account AccountObj ;
 public List<Contact> contactList ;
 public List<ContactRecordsWithCheckBox> WrapperList ;
 public static final Integer USER_LIST_LIMIT = 20;
 
 	/*DEFAULT CONTRUCTORS */   
	 public CreateGroupEventSLDSController() {
	 	
	 }
	 
	 /* PARAMETERIZE CONTRUCTORS */   
	 public CreateGroupEventSLDSController( ApexPages.StandardController stdController ) {
	 	
	 }
 
 	/*
     * Method Name   : getcampaignObj
     * Description   : Method will return new object reference for campaign object    
     * @param        : None
     * @returns      : New Campaign Object 
    */
	 @RemoteAction 
	 public static Campaign getcampaignObj() {
	       return new Campaign();    
	 }
 
   /*
    * Method Name   : fetchObjectKey
    * Description   : Method will return object key for Described object    
    * @param        : None
    * @returns      : Schema result
   */
 
   @RemoteAction
   public static String fetchObjectKey(){        
      Schema.DescribeSObjectResult schemaResult = Contact.sObjectType.getDescribe();
      return schemaResult.getKeyPrefix();
   }
   
   /*
    * Method Name   : searchSpeaker
    * Description   : Method will return all the matched contact for Oncology Speaker    
    * @param        : SpeakerName - Entered search Text on page
    * @returns      : List<Contact> 
   */
   
   @RemoteAction
   public static List<Contact> searchSpeaker(String SpeakerName){
        String query = 'SELECT Id,Name,AccountId,Account.Name FROM Contact '+ 
                   ' WHERE Name LIKE \'%'+SpeakerName+'%\' and Speaker_Oncology__c = true LIMIT '+ USER_LIST_LIMIT;
        return Database.query(query);
   }
   
   /*
    * Method Name   : searchAccount
    * Description   : Method will return all the matched Account    
    * @param        : accountName - Entered search Text on page
    * @returns      : List<Account> 
   */
   
   @RemoteAction
   public static List<Account> searchAccount(String accountName){
        String query = 'SELECT Id,Name,(Select id,Name,Title,Oncology_Specialties__c,Active_Product__c from contacts) FROM Account '+ 
                   ' WHERE Name LIKE \'%'+accountName+'%\' LIMIT '+ USER_LIST_LIMIT;
        return Database.query(query);
   }
   
   /*
    * Method Name   : getAllPicklistValues
    * Description   : Method will Fetch picklist Values Dynamically    
    * @param        : None
    * @returns      : Picklist values as string 
   */
   
   @RemoteAction
   public static String getAllPicklistValues(){
        PickListValues pickVals = new PickListValues();
        
        Schema.DescribeFieldResult CampaignTypeFieldDescribe = Campaign.Type.getDescribe();
        for(Schema.PicklistEntry loop_var : CampaignTypeFieldDescribe.getPicklistValues()){
              pickVals.campaignType.add(loop_var.getLabel());
        }
        
        Schema.DescribeFieldResult CampaignProductFieldDescribe = Campaign.Active_Product__c.getDescribe();
        for(Schema.PicklistEntry loop_var : CampaignProductFieldDescribe.getPicklistValues()){
              pickVals.campaignProduct.add(loop_var.getLabel());
        }
        
        Schema.DescribeFieldResult CampaignEventLocationStateDescribe = Campaign.Event_Location_State__c.getDescribe();
        for(Schema.PicklistEntry loop_var : CampaignEventLocationStateDescribe.getPicklistValues()){
              pickVals.campaignEventLocationState.add(loop_var.getLabel());
        }
        
        return JSON.serialize(pickVals);
        
   }
   
   
    /*
    * Method Name   : saveGroupEventAndGroupEventMembers
    * Description   : Save Group Events and Group Event members   
    * @param        : Campaign campaignObj,List<ContactRecordsWithCheckBox> contactRecordsWithCheckBoxWrapperList,String speaker
    * @returns      : success/failure values as string 
   */ 
    @RemoteAction
    public static String saveGroupEventAndGroupEventMembers(Campaign campaignObj,List<ContactRecordsWithCheckBox> contactRecordsWithCheckBoxWrapperList,String speaker){
    	List<ContactRecordsWithCheckBox> contactContactWithCheckBoxWrapperList = new List<ContactRecordsWithCheckBox>();
        system.debug('campaignObj' + campaignObj);
        system.debug('contactRecordsWithCheckBoxWrapperList' + contactRecordsWithCheckBoxWrapperList);
        system.debug('speaker '+speaker );
        Contact SpeakerContact;
        if(speaker != null || speaker != '')
        	SpeakerContact = (Contact)JSON.deserialize(speaker, Contact.class);
        try{
        	if(SpeakerContact != null)
            	campaignObj.Speaker__c = SpeakerContact.id; 
            
            campaignObj.Status = 'In Progress';
            campaignObj.IsActive = true;
            insert campaignObj;
            
        	/* Insert all the group Members */ 
        	
            List<CampaignMember> CampaignMemberList = new List<CampaignMember>();
        	if(contactRecordsWithCheckBoxWrapperList != null && contactRecordsWithCheckBoxWrapperList.size() > 0){
            	for(ContactRecordsWithCheckBox wrapperObj : contactRecordsWithCheckBoxWrapperList) {
            		CampaignMember CampaignMemberObj = new CampaignMember();
            		CampaignMemberObj.CampaignId = campaignObj.id;
            		CampaignMemberObj.ContactId = wrapperObj.con.id;
            		CampaignMemberObj.Status = 'Sent';
            		CampaignMemberList.add(CampaignMemberObj);
            	}
        	}
        	if(CampaignMemberList.size() > 0)
        		insert CampaignMemberList;	
        		
            return campaignObj.id ;
        }catch(Exception e){            
            system.debug('ERROR' + e.getMessage());
            return 'ERROR';
        }
        
    }
   
   // WRAPPER CLASS TO HOLD ALL PICKLIST VALUES
   
   public class PickListValues{
        public List<String> campaignType {get;set;}
        public List<String> campaignProduct {get;set;}
        public List<String> campaignEventLocationState {get;set;}
        
        public PickListValues(){
            campaignType = new List<String>();
            campaignProduct = new List<String>();
            campaignEventLocationState = new List<String>();
        }           
   }
   
   // WRAPPER CLASS TO HOLD ALL CONTACTS RECORDS WITH ADDITIONAL CHECKBOX
   
   public class ContactRecordsWithCheckBox{
        
        public Contact con {get;set;}
        public boolean isChecked {get;set;}
        
        public ContactRecordsWithCheckBox(Contact c , boolean checked){
            con = c;
            isChecked = checked ;
        }           
   }
}