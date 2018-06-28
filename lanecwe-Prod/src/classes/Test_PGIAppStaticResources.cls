/**
 * This is the test class for the PGIAppStaticResources class. 
 *
 * @author Amit M.
 * @version 1.0
 */
@isTest
private class Test_PGIAppStaticResources {

	/**
	 * Unit test the static resources methods of the PGIAppStaticResources class.
	 */
    static testMethod void UnitTest_TestStaticResourceMethods() 
    {
    	setUp();
    	Test.startTest();
    	PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
    	Product2 standardProduct = staticResources.pgiStandardProduct;
    	system.assertNotEquals(standardProduct, NULL);
    	system.assertEquals(standardProduct.Name, PGIAppConstants.STANDARD_PRODUCT_NAME);
    	
    	Map<Id, Pricebook2> allPricebooks = staticResources.allPricebooks;
    	system.assertNotEquals(allPricebooks, NULL);
    	system.assertEquals(allPricebooks.isEmpty(), false);
    	
    	Map<Id, Profile> attachmentViewProfiles = staticResources.attachmentViewProfiles;
    	system.assertNotEquals(attachmentViewProfiles, NULL);
    	system.assertEquals(attachmentViewProfiles.isEmpty(), false);
    	
    	PGITestUtilities.createRegionWiseAppLevNameSetting();
    	Map<String, Map<String, String>> regionWiseApprovalLevelMap = staticResources.regionWiseApprovalLevelMap;
    	system.assertNotEquals(regionWiseApprovalLevelMap, NULL);
    	system.assertEquals(regionWiseApprovalLevelMap.isEmpty(), false);
    	
    	Map<String, Pricebook2> regionWisePricebooks = staticResources.regionWisePricebooks;
    	system.assertNotEquals(regionWisePricebooks, NULL);
    	system.assertEquals(regionWisePricebooks.isEmpty(), false);
    	Test.stopTest();
    }
    
    /**
     * Creates the test data for the test method.
     */
    static void setUp()
    {
    	Product2 newProduct = PGITestUtilities.getStdProduct();
    	newProduct.Name = PGIAppConstants.STANDARD_PRODUCT_NAME;
    	insert newProduct;
    	
    	Pricebook2 naRegionPb = new Pricebook2();
    	naRegionPb.Name = 'NA PB';
    	naRegionPb.IsActive = true;
    	insert naRegionPb;
    }
}