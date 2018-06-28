//*********************************************************************************************************
//Name              : SignUpWebService
//Created By        : Virendra 
//Created Date      : June 9, 2014
//Description       : T-285920 >> Update the SignUpWebService class make address funcitonality saperate
//
// *********************************************************************************************************

public with sharing class SignUpWebService_AddressHelper {
   
   
   /*
    *  Method created as per updates by Tim Parker on T-257870
    *  to store the account address
    */
    @future
    public static void insertAccountAddress(Id accountId,String AddressLine1,
                                      String AddressLine2,String City, String State, String Zip, String Country){
        rC_Bios__Account_Address__c accountAddress = new rC_Bios__Account_Address__c();
        accountAddress.rC_Bios__Account__c = accountId;
        accountAddress.rC_Bios__Original_Street_Line_1__c = AddressLine1;
        accountAddress.rC_Bios__Original_Street_Line_2__c = AddressLine2;
        accountAddress.rC_Bios__Active__c = true;
        accountAddress.rC_Bios__Original_City__c = city;
        accountAddress.rC_Bios__Type__c = 'Home';
        accountAddress.rC_Bios__Preferred_Billing__c = true;
        accountAddress.rC_Bios__Preferred_Shipping__c = true;
        accountAddress.rC_Bios__Original_State__c = state;
        accountAddress.rC_Bios__Original_Country__c = Country;
        accountAddress.rC_Bios__Original_Postal_Code__c = zip;
        insert accountAddress;
        system.debug(':::accountAddress::'+accountAddress+'::accountId::'+accountId);
    }
}