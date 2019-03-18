public class GNationLiveAdminController {

    //Properties
    public Integer RefreshTime { get; set; }
    public String GroupId { get; set; }
    GNationLive__c GNationLive;
    
    
    /* Constructor: 1. Fetches the values from the custom setting
     *              2. Displays the respective values in the input text fields
     */
    public GNationLiveAdminController(){
        GNationLive = [Select Group_Id__c, Refresh_Time__c from GNationLive__c Limit 1];
        GroupId = GNationLive.Group_Id__c;
        RefreshTime = (integer)GNationLive.Refresh_Time__c;
    }
     
    /* Getters: 1. Get the respective values for the Id or Refresh Time
     *
     */ 
    
    public String getGroupId(){
        return GroupId;
    }
    
    public Integer getRefreshTime(){
        return RefreshTime;
    }

    /* Action Method: 1. Updates the Custom Settings with the respective values
     *
     */
    public void UpdateCustomSettings() {
        GNationLive.Group_Id__c = GroupId;
        GNationLive.Refresh_Time__c = RefreshTime;
        
        //Update the Custom Setting
        Update GNationLive;
        
    }

}