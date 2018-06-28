// ChangeLog        : MM: 4/10/2015 - Get CastIron UserId from Custom Setting, to reduce SOQL queries
//                    VB: 5/6/2016 - Removed references to CI tables (CI_ContactAddress_Change__c)
//                                      This trigger served no other purpose.
trigger CIContactAddressChanges on rC_Bios__Contact_Address__c (before update) {

}