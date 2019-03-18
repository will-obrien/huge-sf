@isTest
Public Class TestGNationLiveAdminController{
    
  /* This Method: 1. Tests the Getters
   *              2. Test the custom setting and the constructor
   */
   
  static testmethod void TestGNationLiveAdmin(){
      
     //Check if the custom setting exists on this org, if not create it.
     GNationLive__c mycs = GNationLive__c.getValues('Group_Name__c');
     if(mycs == null){
         mycs = new GNationLive__c(Name='GNation Live');
         insert mycs;
     } 
     
     GNationLiveAdminController GNLAC = new GNationLiveAdminController();
     
     //Update the Custom Settings
     GNLAC.GroupId = '012345679101112';
     GNLAC.RefreshTime = 5;
     GNLAC.UpdateCustomSettings();
     
     //Fetches the values
     GNLAC.getGroupId();
     GNLAC.getRefreshTime(); 
     
     //Asserts
     System.AssertEquals(5, GNLAC.getRefreshTime());
     System.AssertEquals('012345679101112', GNLAC.getGroupId());       
  }
}