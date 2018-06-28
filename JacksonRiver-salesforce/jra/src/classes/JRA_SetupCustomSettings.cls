public with sharing class JRA_SetupCustomSettings {
/*
PNC June 2015
Called by installation script
*/
public static void createSettings() {
//Setup shell endpoint records - client will need to add credentials
List<jrsbd__JRA_Advocacy_Endpoint_Settings__c> AuthSettings = new List<jrsbd__JRA_Advocacy_Endpoint_Settings__c>();
AuthSettings.add(new jrsbd__JRA_Advocacy_Endpoint_Settings__c(Name = 'Sandbox', jrsbd__Endpoint__c = 'https://advocacy-staging.gospringboard.io/api/v1'));
AuthSettings.add(new jrsbd__JRA_Advocacy_Endpoint_Settings__c(Name = 'Live', jrsbd__Endpoint__c = 'https://advocacy.gospringboard.io/api/v1'));

insert AuthSettings;

//Setup default settings
List<jrsbd__JR_Advocacy_Settings__c> GeneralSettings = new List<jrsbd__JR_Advocacy_Settings__c> ();
GeneralSettings.add(new jrsbd__JR_Advocacy_Settings__c(Name = 'ZipCodeField', jrsbd__String_Value__c = 'MailingPostalCode'));
GeneralSettings.add(new jrsbd__JR_Advocacy_Settings__c(Name = 'APIEndpoint', jrsbd__String_Value__c = 'Sandbox'));

insert GeneralSettings;

}



}