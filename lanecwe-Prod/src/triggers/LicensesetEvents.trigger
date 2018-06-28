/**
*    LicenseSet trigger logic for After Update Events
*
*    Modification Log
*
*    Deepthi        PGI    10/27/2014      LicenseSet trigger logic for After Update 
**/
trigger LicensesetEvents on LicenseSet__c (before update, after update) {
    //if(UserInfo.getName() == 'eCommerce Customer'){
    if(Trigger.new != null){
    for(LicenseSet__c Lsetdata : trigger.new){
       if(Lsetdata.Z_Source__c == 'eCommerce'){    
          if(Trigger.isBefore && Trigger.isUpdate && !LicensesetEventHandler.skipBeforeEvent){
          // Validating Licenseset updates
             LicensesetEventHandler.validateLicenseSetUpdates(Trigger.newMap);
          //Setting boolean to skip recursive trigger logic execution on simultaneous updates
             LicensesetEventHandler.skipBeforeEvent = true;
          } 
          if(Trigger.isAfter && Trigger.isUpdate && !LicensesetEventHandler.skipAfterEvent){
          // Logic to insert assets for licensesets with hubid/companyid updates
          LicensesetEventHandler.createOpporLicense(trigger.newMap, trigger.oldMap);
          // Setting boolean to skip recursive trigger logic execution on simultaneous updates
          LicensesetEventHandler.skipAfterEvent = true;
         }
      }
    }
}
}