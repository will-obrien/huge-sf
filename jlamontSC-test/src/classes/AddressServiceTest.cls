//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Test Class for AddressService 
//	7 March 2014    Virendra (Appirio)     Original
//**********************************************************************/
@isTest
private class AddressServiceTest {
	@isTest static void testValidateAddress() {              
        // This causes a fake response to be generated
        TestDataUtility testData = new TestDataUtility();
        rC_Bios__Address__c accountAddress = testData.createNewAddress(false);
        // Call the method that invokes a callout
        AddressService.getPayLoad(accountAddress);
        AddressService.validateForTest(accountAddress, false, false);
        AddressService.validateForTest(accountAddress, true, false);
        AddressService.validateForTest(accountAddress, true, true);
        String strRespBody = '<country><streetadr>One Mountain St </streetadr><suppadr>  Street line 2</suppadr><city> San Francisco</city><state> CA </state><zipcode> 94105 </zipcode><country>USA</country></country>';
        AddressService.populateAddresses(strRespBody);
    }

}