/*********************************************************************************************************
Name			: TestrCSettingUtility
Created By		: Vernon Baas
Created Date	: June 27, 2017
Description		: Utility class that sets rC Custom Settings for test classes.
				: 		The hope is that this will reduce the additional SOQL 
				:		calls during test execution. 
Updated			: 2017/07/05 VB: ...
***********************************************************************************************************/
public with sharing class TestrCSettingUtility {
 
	private static boolean hasRunBefore = false;

    public static void createrCSettings(){
 
 		if(!hasRunBefore) {
 			setrC_BiosSettings();
 			setrC_GivingSettings();
 			hasRunBefore = true;
 		} 
	}
 
	// Create an Account & Contact, add a No Phone preference 
	//	then deactivate the preference
    private static void setrC_BiosSettings() {

		/* rC Bios settings that are set to Disable All
			Action Plan Setting			rC_Bios__Action_Plan_Setting__c
			Action Plan Task Setting	rC_Bios__Action_Plan_Task_Setting__c
			Lead Setting				rC_Bios__Lead_Setting__c
			Relationship Setting		rC_Bios__Relationship_Settings__c
			Salutation Setting			rC_Bios__Salutation_Setting__c
			Task Setting				rC_Bios__Task_Setting__c		
		*/

    	rC_Bios__Action_Plan_Setting__c 	setting1 = new rC_Bios__Action_Plan_Setting__c();
        setting1.rC_Bios__Disable_All__c = TRUE;
        insert setting1; 

    	rC_Bios__Action_Plan_Task_Setting__c setting2 = new rC_Bios__Action_Plan_Task_Setting__c();
        setting2.rC_Bios__Disable_All__c = TRUE;
        insert setting2; 

    	rC_Bios__Lead_Setting__c 			setting3 = new rC_Bios__Lead_Setting__c();
        setting3.rC_Bios__Disable_All__c = TRUE;
        insert setting3; 

    	rC_Bios__Relationship_Settings__c 	setting4 = new rC_Bios__Relationship_Settings__c();
        setting4.rC_Bios__Disable_All__c = TRUE;
        insert setting4; 

    	rC_Bios__Salutation_Setting__c		setting5 = new rC_Bios__Salutation_Setting__c();
        setting5.rC_Bios__Disable_All__c = TRUE;
        insert setting5; 

    	rC_Bios__Task_Setting__c 			setting6 = new rC_Bios__Task_Setting__c();
        setting6.rC_Bios__Disable_All__c = TRUE;
        insert setting6; 
        
    }

	// Create an Account & Contact, add a No Phone preference 
	//	then deactivate the preference
    private static void setrC_GivingSettings() {

    	// This custom setting needs to be specifically set for test classes
    	//	as the Custom Settings values are not present during the test?
    	//	and it will create a recursive SELF_REFERENCE_FROM_TRIGGER error
    	//rC_Giving__Contact_Setting__c setting = new rC_Giving__Contact_Setting__c();
        //setting.rC_Giving__Disable_CascadeAccounts__c = TRUE;
        //insert setting;


		/* rC Giving settings that are set to Disable All

			Account Setting					rC_Giving__Account_Setting__c.rC_Giving__Disable_All__c
			Campaign Setting				rC_Giving__Campaign_Setting__c.rC_Giving__Disable_All__c
			Contact Setting					rC_Giving__Contact_Setting__c.rC_Giving__Disable_All__c
			Giving Level Setting			rC_Giving__Giving_Level_Setting__c.rC_Giving__Disable_All__c
			MatchingRatio Setting			rC_Giving__MatchingRatio_Setting__c.rC_Giving__Disable_All__c
			Opportunity Allocation Setting	rC_Giving__Opportunity_Allocation_Setting__c.rC_Giving__Disable_All__c
			Opportunity Credit Setting		rC_Giving__Opportunity_Credit_Setting__c.rC_Giving__Disable_All__c
			Opportunity Product Setting		rC_Giving__Opportunity_Product_Setting__c.rC_Giving__Disable_All__c
		*/

    	rC_Giving__Account_Setting__c 					setting1 = new rC_Giving__Account_Setting__c();
        setting1.rC_Giving__Disable_All__c = TRUE;
        insert setting1; 

    	rC_Giving__Campaign_Setting__c 					setting2 = new rC_Giving__Campaign_Setting__c();
        setting2.rC_Giving__Disable_All__c = TRUE;
        insert setting2; 

    	rC_Giving__Contact_Setting__c					setting3 = new rC_Giving__Contact_Setting__c();
        setting3.rC_Giving__Disable_All__c = TRUE;
        insert setting3; 

    	rC_Giving__Giving_Level_Setting__c 				setting4 = new rC_Giving__Giving_Level_Setting__c();
        setting4.rC_Giving__Disable_All__c = TRUE;
        insert setting4; 

    	rC_Giving__MatchingRatio_Setting__c				setting5 = new rC_Giving__MatchingRatio_Setting__c();
        setting5.rC_Giving__Disable_All__c = TRUE;
        insert setting5; 

    	rC_Giving__Opportunity_Allocation_Setting__c	setting6 = new rC_Giving__Opportunity_Allocation_Setting__c();
        setting6.rC_Giving__Disable_All__c = TRUE;
        insert setting6; 
        
    	rC_Giving__Opportunity_Credit_Setting__c 		setting7 = new rC_Giving__Opportunity_Credit_Setting__c();
        setting7.rC_Giving__Disable_All__c = TRUE;
        insert setting7; 
        
    	rC_Giving__Opportunity_Product_Setting__c		setting8 = new rC_Giving__Opportunity_Product_Setting__c();
        setting8.rC_Giving__Disable_All__c = TRUE;
        insert setting8; 
    	
    }
}