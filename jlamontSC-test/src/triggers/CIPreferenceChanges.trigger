/*
//*************************************************************************************************
//
// Name              : CIPreferenceChanges
// By                : Vernon Baas
// Description       : Stores off the Preferences that have been deleted or updated by users
//                         into the CI_Preference_Change__c object
// ChangeLog        : MM: 4/10/2015 - Get CastIron UserId from Custom Setting, to reduce SOQL queries
//                    VB: 5/6/2016 - Removed references to CI tables (CI_Preference_Change__c)
//                                      This trigger served no other purpose.
//*************************************************************************************************
*/
trigger CIPreferenceChanges on rC_Bios__Preference__c (before update,before delete) {

}