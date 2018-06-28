/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class JHAFormControllerTest {

// NOTE: Need to use the @isTest(SeeAllData=true) annotation because JHAFormController needs access to hazardtype data in Hazard_Type__c object table

	static final integer JHA_ITEM_COUNT = 41;
	

    @isTest(SeeAllData=true) static void testAffectedAreaMultiSelectPicklists() {
        // Test functionality of some of the Affected Area Multi-Select Picklists
        JHAFormController jhaFormController = new JHAFormController();
        List<SelectOption> options = new List<SelectOption>();
        
        // *** TEST Affected Area 2 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues2();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Respiratory') {
        		System.assertEquals('Respiratory', so.getValue());
        		System.assertEquals('Respiratory', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected2.add('Eyes');
        jhaFormController.selectclick2();
        options = jhaFormController.getSelectedValues2();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected2.add('Eyes');
        jhaFormController.unselectclick2();
        options = jhaFormController.getunSelectedValues2();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Respiratory') {
        		System.assertEquals('Respiratory', so.getValue());
        		System.assertEquals('Respiratory', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 3 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues3();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Respiratory') {
        		System.assertEquals('Respiratory', so.getValue());
        		System.assertEquals('Respiratory', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected3.add('Eyes');
        jhaFormController.selectclick3();
        options = jhaFormController.getSelectedValues3();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected3.add('Eyes');
        jhaFormController.unselectclick3();
        options = jhaFormController.getunSelectedValues3();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Respiratory') {
        		System.assertEquals('Respiratory', so.getValue());
        		System.assertEquals('Respiratory', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 4 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues4();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected4.add('Eyes');
        jhaFormController.selectclick4();
        options = jhaFormController.getSelectedValues4();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected4.add('Eyes');
        jhaFormController.unselectclick4();
        options = jhaFormController.getunSelectedValues4();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 6 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues6();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected6.add('Foot');
        jhaFormController.selectclick6();
        options = jhaFormController.getSelectedValues6();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected6.add('Foot');
        jhaFormController.unselectclick6();
        options = jhaFormController.getunSelectedValues6();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 11 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues11();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Noise') {
        		System.assertEquals('Noise', so.getValue());
        		System.assertEquals('Noise', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected11.add('Noise');
        jhaFormController.selectclick11();
        options = jhaFormController.getSelectedValues11();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Noise') {
        		System.assertEquals('Noise', so.getValue());
        		System.assertEquals('Noise', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected11.add('Noise');
        jhaFormController.unselectclick11();
        options = jhaFormController.getunSelectedValues11();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Noise') {
        		System.assertEquals('Noise', so.getValue());
        		System.assertEquals('Noise', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 12 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues12();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Body/Torso') {
        		System.assertEquals('Body/Torso', so.getValue());
        		System.assertEquals('Body/Torso', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected12.add('Body/Torso');
        jhaFormController.selectclick12();
        options = jhaFormController.getSelectedValues12();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Body/Torso') {
        		System.assertEquals('Body/Torso', so.getValue());
        		System.assertEquals('Body/Torso', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected12.add('Body/Torso');
        jhaFormController.unselectclick12();
        options = jhaFormController.getunSelectedValues12();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Body/Torso') {
        		System.assertEquals('Body/Torso', so.getValue());
        		System.assertEquals('Body/Torso', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 13 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues13();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected13.add('Hands');
        jhaFormController.selectclick13();
        options = jhaFormController.getSelectedValues13();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected13.add('Hands');
        jhaFormController.unselectclick13();
        options = jhaFormController.getunSelectedValues13();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 14 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues14();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected14.add('Foot');
        jhaFormController.selectclick14();
        options = jhaFormController.getSelectedValues14();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected14.add('Foot');
        jhaFormController.unselectclick14();
        options = jhaFormController.getunSelectedValues14();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 15 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues15();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected15.add('Eyes');
        jhaFormController.selectclick15();
        options = jhaFormController.getSelectedValues15();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected15.add('Eyes');
        jhaFormController.unselectclick15();
        options = jhaFormController.getunSelectedValues15();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 17 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues17();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected17.add('Foot');
        jhaFormController.selectclick17();
        options = jhaFormController.getSelectedValues17();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected17.add('Foot');
        jhaFormController.unselectclick17();
        options = jhaFormController.getunSelectedValues17();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 25 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues25();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Body/Torso') {
        		System.assertEquals('Body/Torso', so.getValue());
        		System.assertEquals('Body/Torso', so.getLabel());
        	}
        	else if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected25.add('Eyes');
        jhaFormController.selectclick25();
        options = jhaFormController.getSelectedValues25();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected25.add('Eyes');
        jhaFormController.unselectclick25();
        options = jhaFormController.getunSelectedValues25();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Body/Torso') {
        		System.assertEquals('Body/Torso', so.getValue());
        		System.assertEquals('Body/Torso', so.getLabel());
        	}
        	else if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 29 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues29();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Body/Torso') {
        		System.assertEquals('Body/Torso', so.getValue());
        		System.assertEquals('Body/Torso', so.getLabel());
        	}
        	else if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected29.add('Eyes');
        jhaFormController.selectclick29();
        options = jhaFormController.getSelectedValues29();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected29.add('Eyes');
        jhaFormController.unselectclick29();
        options = jhaFormController.getunSelectedValues29();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Body/Torso') {
        		System.assertEquals('Body/Torso', so.getValue());
        		System.assertEquals('Body/Torso', so.getLabel());
        	}
        	else if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 34 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues34();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Body/Torso') {
        		System.assertEquals('Body/Torso', so.getValue());
        		System.assertEquals('Body/Torso', so.getLabel());
        	}
        	else if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected34.add('Eyes');
        jhaFormController.selectclick34();
        options = jhaFormController.getSelectedValues34();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected34.add('Eyes');
        jhaFormController.unselectclick34();
        options = jhaFormController.getunSelectedValues34();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Body/Torso') {
        		System.assertEquals('Body/Torso', so.getValue());
        		System.assertEquals('Body/Torso', so.getLabel());
        	}
        	else if (so.getValue() == 'Eyes') {
        		System.assertEquals('Eyes', so.getValue());
        		System.assertEquals('Eyes', so.getLabel());
        	}
        	else if (so.getValue() == 'Foot') {
        		System.assertEquals('Foot', so.getValue());
        		System.assertEquals('Foot', so.getLabel());
        	}
        	else if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 36 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues36();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected36.add('Hands');
        jhaFormController.selectclick36();
        options = jhaFormController.getSelectedValues36();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected36.add('Hands');
        jhaFormController.unselectclick36();
        options = jhaFormController.getunSelectedValues36();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 37 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues37();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected37.add('Hands');
        jhaFormController.selectclick37();
        options = jhaFormController.getSelectedValues37();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected37.add('Hands');
        jhaFormController.unselectclick37();
        options = jhaFormController.getunSelectedValues37();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Hands') {
        		System.assertEquals('Hands', so.getValue());
        		System.assertEquals('Hands', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 38 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues38();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected38.add('Head');
        jhaFormController.selectclick38();
        options = jhaFormController.getSelectedValues38();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected38.add('Head');
        jhaFormController.unselectclick38();
        options = jhaFormController.getunSelectedValues38();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST Affected Area 39 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getunSelectedValues39();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.affectedAreaLeftSelected39.add('Head');
        jhaFormController.selectclick39();
        options = jhaFormController.getSelectedValues39();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.affectedAreaRightSelected39.add('Head');
        jhaFormController.unselectclick39();
        options = jhaFormController.getunSelectedValues39();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Head') {
        		System.assertEquals('Head', so.getValue());
        		System.assertEquals('Head', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
    }
    
    
    @isTest(SeeAllData=true) static void testPPEIDMultiSelectPicklists() {
        // Test functionality of some of the PPE ID Multi-Select Picklists
        JHAFormController jhaFormController = new JHAFormController();
        List<SelectOption> options = new List<SelectOption>();
        
        // *** TEST PPE ID 2 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues2();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Dust Mask/Air Purifying') {
        		System.assertEquals('Dust Mask/Air Purifying', so.getValue());
        		System.assertEquals('Dust Mask/Air Purifying', so.getLabel());
        	}
        	else if (so.getValue() == 'Face-shield/Goggles') {
        		System.assertEquals('Face-shield/Goggles', so.getValue());
        		System.assertEquals('Face-shield/Goggles', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected2.add('Dust Mask/Air Purifying');
        jhaFormController.ppeIdSelectClick2();
        options = jhaFormController.getPPEIdSelectedValues2();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Dust Mask/Air Purifying') {
        		System.assertEquals('Dust Mask/Air Purifying', so.getValue());
        		System.assertEquals('Dust Mask/Air Purifying', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected2.add('Dust Mask/Air Purifying');
        jhaFormController.ppeIdUnselectClick2();
        options = jhaFormController.getPPEIdUnselectedValues2();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Dust Mask/Air Purifying') {
        		System.assertEquals('Dust Mask/Air Purifying', so.getValue());
        		System.assertEquals('Dust Mask/Air Purifying', so.getLabel());
        	}
        	else if (so.getValue() == 'Face-shield/Goggles') {
        		System.assertEquals('Face-shield/Goggles', so.getValue());
        		System.assertEquals('Face-shield/Goggles', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 3 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues3();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Dust Mask/Air Purifying') {
        		System.assertEquals('Dust Mask/Air Purifying', so.getValue());
        		System.assertEquals('Dust Mask/Air Purifying', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected3.add('Dust Mask/Air Purifying');
        jhaFormController.ppeIdSelectClick3();
        options = jhaFormController.getPPEIdSelectedValues3();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Dust Mask/Air Purifying') {
        		System.assertEquals('Dust Mask/Air Purifying', so.getValue());
        		System.assertEquals('Dust Mask/Air Purifying', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected3.add('Dust Mask/Air Purifying');
        jhaFormController.ppeIdUnselectClick3();
        options = jhaFormController.getPPEIdUnselectedValues3();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Dust Mask/Air Purifying') {
        		System.assertEquals('Dust Mask/Air Purifying', so.getValue());
        		System.assertEquals('Dust Mask/Air Purifying', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 4 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues4();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Face-shield/Goggles') {
        		System.assertEquals('Face-shield/Goggles', so.getValue());
        		System.assertEquals('Face-shield/Goggles', so.getLabel());
        	}
        	else if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected4.add('Face-shield/Goggles');
        jhaFormController.ppeIdSelectClick4();
        options = jhaFormController.getPPEIdSelectedValues4();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Face-shield/Goggles') {
        		System.assertEquals('Face-shield/Goggles', so.getValue());
        		System.assertEquals('Face-shield/Goggles', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected4.add('Face-shield/Goggles');
        jhaFormController.ppeIdUnselectClick4();
        options = jhaFormController.getPPEIdUnselectedValues4();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Face-shield/Goggles') {
        		System.assertEquals('Face-shield/Goggles', so.getValue());
        		System.assertEquals('Face-shield/Goggles', so.getLabel());
        	}
        	else if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 6 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues6();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected6.add('Standard Uniform');
        jhaFormController.ppeIdSelectClick6();
        options = jhaFormController.getPPEIdSelectedValues6();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected6.add('Standard Uniform');
        jhaFormController.ppeIdUnselectClick6();
        options = jhaFormController.getPPEIdUnselectedValues6();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 11 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues11();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Earplug/Headset') {
        		System.assertEquals('Earplug/Headset', so.getValue());
        		System.assertEquals('Earplug/Headset', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected11.add('Earplug/Headset');
        jhaFormController.ppeIdSelectClick11();
        options = jhaFormController.getPPEIdSelectedValues11();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Earplug/Headset') {
        		System.assertEquals('Earplug/Headset', so.getValue());
        		System.assertEquals('Earplug/Headset', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected11.add('Earplug/Headset');
        jhaFormController.ppeIdUnselectClick11();
        options = jhaFormController.getPPEIdUnselectedValues11();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Earplug/Headset') {
        		System.assertEquals('Earplug/Headset', so.getValue());
        		System.assertEquals('Earplug/Headset', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 12 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues12();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Face-shield/Goggles') {
        		System.assertEquals('Face-shield/Goggles', so.getValue());
        		System.assertEquals('Face-shield/Goggles', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected12.add('Face-shield/Goggles');
        jhaFormController.ppeIdSelectClick12();
        options = jhaFormController.getPPEIdSelectedValues12();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Face-shield/Goggles') {
        		System.assertEquals('Face-shield/Goggles', so.getValue());
        		System.assertEquals('Face-shield/Goggles', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected12.add('Face-shield/Goggles');
        jhaFormController.ppeIdUnselectClick12();
        options = jhaFormController.getPPEIdUnselectedValues12();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Face-shield/Goggles') {
        		System.assertEquals('Face-shield/Goggles', so.getValue());
        		System.assertEquals('Face-shield/Goggles', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 13 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues13();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected13.add('Leather Work Gloves');
        jhaFormController.ppeIdSelectClick13();
        options = jhaFormController.getPPEIdSelectedValues13();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected13.add('Leather Work Gloves');
        jhaFormController.ppeIdUnselectClick13();
        options = jhaFormController.getPPEIdUnselectedValues13();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 14 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues14();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected14.add('Standard Uniform');
        jhaFormController.ppeIdSelectClick14();
        options = jhaFormController.getPPEIdSelectedValues14();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected14.add('Standard Uniform');
        jhaFormController.ppeIdUnselectClick14();
        options = jhaFormController.getPPEIdUnselectedValues14();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 15 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues15();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected15.add('Leather Work Gloves');
        jhaFormController.ppeIdSelectClick15();
        options = jhaFormController.getPPEIdSelectedValues15();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected15.add('Leather Work Gloves');
        jhaFormController.ppeIdUnselectClick15();
        options = jhaFormController.getPPEIdUnselectedValues15();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 16 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues16();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Anchoring') {
        		System.assertEquals('Anchoring', so.getValue());
        		System.assertEquals('Anchoring', so.getLabel());
        	}
        	else if (so.getValue() == 'Safety Harness and Lanyard') {
        		System.assertEquals('Safety Harness and Lanyard', so.getValue());
        		System.assertEquals('Safety Harness and Lanyard', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected16.add('Anchoring');
        jhaFormController.ppeIdSelectClick16();
        options = jhaFormController.getPPEIdSelectedValues16();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Anchoring') {
        		System.assertEquals('Anchoring', so.getValue());
        		System.assertEquals('Anchoring', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected16.add('Anchoring');
        jhaFormController.ppeIdUnselectClick16();
        options = jhaFormController.getPPEIdUnselectedValues16();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Anchoring') {
        		System.assertEquals('Anchoring', so.getValue());
        		System.assertEquals('Anchoring', so.getLabel());
        	}
        	else if (so.getValue() == 'Safety Harness and Lanyard') {
        		System.assertEquals('Safety Harness and Lanyard', so.getValue());
        		System.assertEquals('Safety Harness and Lanyard', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 17 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues17();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected17.add('Standard Uniform');
        jhaFormController.ppeIdSelectClick17();
        options = jhaFormController.getPPEIdSelectedValues17();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected17.add('Standard Uniform');
        jhaFormController.ppeIdUnselectClick17();
        options = jhaFormController.getPPEIdUnselectedValues17();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 18 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues18();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Anchoring') {
        		System.assertEquals('Anchoring', so.getValue());
        		System.assertEquals('Anchoring', so.getLabel());
        	}
        	else if (so.getValue() == 'Safety Harness and Lanyard') {
        		System.assertEquals('Safety Harness and Lanyard', so.getValue());
        		System.assertEquals('Safety Harness and Lanyard', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected18.add('Anchoring');
        jhaFormController.ppeIdSelectClick18();
        options = jhaFormController.getPPEIdSelectedValues18();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Anchoring') {
        		System.assertEquals('Anchoring', so.getValue());
        		System.assertEquals('Anchoring', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected18.add('Anchoring');
        jhaFormController.ppeIdUnselectClick18();
        options = jhaFormController.getPPEIdUnselectedValues18();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Anchoring') {
        		System.assertEquals('Anchoring', so.getValue());
        		System.assertEquals('Anchoring', so.getLabel());
        	}
        	else if (so.getValue() == 'Safety Harness and Lanyard') {
        		System.assertEquals('Safety Harness and Lanyard', so.getValue());
        		System.assertEquals('Safety Harness and Lanyard', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 25 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues25();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Arc Flash Protective Equipment') {
        		System.assertEquals('Arc Flash Protective Equipment', so.getValue());
        		System.assertEquals('Arc Flash Protective Equipment', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected25.add('Arc Flash Protective Equipment');
        jhaFormController.ppeIdSelectClick25();
        options = jhaFormController.getPPEIdSelectedValues25();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Arc Flash Protective Equipment') {
        		System.assertEquals('Arc Flash Protective Equipment', so.getValue());
        		System.assertEquals('Arc Flash Protective Equipment', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected25.add('Arc Flash Protective Equipment');
        jhaFormController.ppeIdUnselectClick25();
        options = jhaFormController.getPPEIdUnselectedValues25();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Arc Flash Protective Equipment') {
        		System.assertEquals('Arc Flash Protective Equipment', so.getValue());
        		System.assertEquals('Arc Flash Protective Equipment', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 29 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues29();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Arc Flash Protective Equipment') {
        		System.assertEquals('Arc Flash Protective Equipment', so.getValue());
        		System.assertEquals('Arc Flash Protective Equipment', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected29.add('Arc Flash Protective Equipment');
        jhaFormController.ppeIdSelectClick29();
        options = jhaFormController.getPPEIdSelectedValues29();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Arc Flash Protective Equipment') {
        		System.assertEquals('Arc Flash Protective Equipment', so.getValue());
        		System.assertEquals('Arc Flash Protective Equipment', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected29.add('Arc Flash Protective Equipment');
        jhaFormController.ppeIdUnselectClick29();
        options = jhaFormController.getPPEIdUnselectedValues29();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Arc Flash Protective Equipment') {
        		System.assertEquals('Arc Flash Protective Equipment', so.getValue());
        		System.assertEquals('Arc Flash Protective Equipment', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 34 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues34();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Cut Resistant Gloves/Sleeves') {
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getValue());
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getLabel());
        	}
        	else if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected34.add('Cut Resistant Gloves/Sleeves');
        jhaFormController.ppeIdSelectClick34();
        options = jhaFormController.getPPEIdSelectedValues34();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Cut Resistant Gloves/Sleeves') {
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getValue());
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected34.add('Cut Resistant Gloves/Sleeves');
        jhaFormController.ppeIdUnselectClick34();
        options = jhaFormController.getPPEIdUnselectedValues34();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Cut Resistant Gloves/Sleeves') {
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getValue());
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getLabel());
        	}
        	else if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 36 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues36();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Cut Resistant Gloves/Sleeves') {
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getValue());
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getLabel());
        	}
        	else if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected36.add('Cut Resistant Gloves/Sleeves');
        jhaFormController.ppeIdSelectClick36();
        options = jhaFormController.getPPEIdSelectedValues36();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Cut Resistant Gloves/Sleeves') {
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getValue());
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected36.add('Cut Resistant Gloves/Sleeves');
        jhaFormController.ppeIdUnselectClick36();
        options = jhaFormController.getPPEIdUnselectedValues36();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Cut Resistant Gloves/Sleeves') {
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getValue());
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getLabel());
        	}
        	else if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 37 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues37();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Cut Resistant Gloves/Sleeves') {
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getValue());
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getLabel());
        	}
        	else if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected37.add('Cut Resistant Gloves/Sleeves');
        jhaFormController.ppeIdSelectClick37();
        options = jhaFormController.getPPEIdSelectedValues37();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Cut Resistant Gloves/Sleeves') {
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getValue());
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected37.add('Cut Resistant Gloves/Sleeves');
        jhaFormController.ppeIdUnselectClick37();
        options = jhaFormController.getPPEIdUnselectedValues37();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Cut Resistant Gloves/Sleeves') {
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getValue());
        		System.assertEquals('Cut Resistant Gloves/Sleeves', so.getLabel());
        	}
        	else if (so.getValue() == 'Leather Work Gloves') {
        		System.assertEquals('Leather Work Gloves', so.getValue());
        		System.assertEquals('Leather Work Gloves', so.getLabel());
        	}
        	else if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 38 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues38();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected38.add('Standard Uniform');
        jhaFormController.ppeIdSelectClick38();
        options = jhaFormController.getPPEIdSelectedValues38();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected38.add('Standard Uniform');
        jhaFormController.ppeIdUnselectClick38();
        options = jhaFormController.getPPEIdUnselectedValues38();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        
        // *** TEST PPE ID 39 ***
        // Test that all values are in the left list unselected
        options = jhaFormController.getPPEIdUnselectedValues39();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: Undefined picklist value');
        	}
        }
        
        // Test selecting 1 value from the left list and moving it over to the right list
        jhaFormController.ppeIdLeftSelected39.add('Standard Uniform');
        jhaFormController.ppeIdSelectClick39();
        options = jhaFormController.getPPEIdSelectedValues39();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
        
        // Test selecting the 1 value on the right list and moving it back over to the left list
        jhaFormController.ppeIdRightSelected39.add('Standard Uniform');
        jhaFormController.ppeIdUnselectClick39();
        options = jhaFormController.getPPEIdUnselectedValues39();
        for (SelectOption so : options) {
        	if (so.getValue() == 'Standard Uniform') {
        		System.assertEquals('Standard Uniform', so.getValue());
        		System.assertEquals('Standard Uniform', so.getLabel());
        	}
        	else {
        		// Fail the test
        		System.assert(false, 'Error: picklist value not valid');
        	}
        }
    }
    
    
    @isTest(SeeAllData=true) static void testCancel() {
    	// Test some of the objects after the cancel operation is executed.
    	JHAFormController jhaFormController = new JHAFormController();
    	jhaFormController.cancel();
    	System.assertEquals(null, jhaFormController.jhaForm.Id);
    	System.assertEquals(null, jhaFormController.addr.Id);
    	System.assertEquals(null, jhaFormController.jhaItem0.Id);
    	System.assertEquals(null, jhaFormController.jhaItem20.Id);
    	System.assertEquals(null, jhaFormController.jhaItem40.Id);
    }
    
    
    @isTest(SeeAllData=true) static void testCheckIfHTA2ValuePickedIsYes() {
    	// Test Action Function which checks if the Hazard Type Assessment for the 3rd row (Asbestos, mold, chemical exposure, etc) is Yes
    	JHAFormController jhaFormController = new JHAFormController();
    	jhaFormController.jhaItem2.Hazard_Type_Assessment__c = 'Yes';
    	jhaFormController.checkIfHTA2ValuePickedIsYes();
    	System.assertEquals(true, jhaFormController.hta2ReturnValueYes);
    	
    	jhaFormController.jhaItem2.Hazard_Type_Assessment__c = 'No';
    	jhaFormController.checkIfHTA2ValuePickedIsYes();
    	System.assertEquals(false, jhaFormController.hta2ReturnValueYes);
    }
    
    
    @isTest(SeeAllData=true) static void testCheckIfHTA26and25ValuesPickedAreNo() {
    	// Test Action Function which checks if the Hazard Type Assessments for the 26th row (Energy sources can be locked/tagged out)
    	// and 27th row (Electrical components are guarded with at least 3' clearance) are No
    	JHAFormController jhaFormController = new JHAFormController();
    	jhaFormController.jhaItem26.Hazard_Type_Assessment__c = 'No';
    	jhaFormController.jhaItem25.Hazard_Type_Assessment__c = 'No';
    	jhaFormController.checkIfHTA26and25ValuesPickedAreNo();
    	System.assertEquals(true, jhaFormController.hta26and25ReturnValuesAreNo);
    	
    	jhaFormController.jhaItem26.Hazard_Type_Assessment__c = 'No';
    	jhaFormController.jhaItem25.Hazard_Type_Assessment__c = 'Yes';
    	jhaFormController.checkIfHTA26and25ValuesPickedAreNo();
    	System.assertEquals(false, jhaFormController.hta26and25ReturnValuesAreNo);
    }
    
    
    @isTest(SeeAllData=true) static void testCheckIfRatePickedIsGT2() {
    	// Test Action Function which checks if the Hazard Type Assessment for the 28th row (Electrical hazard category rate for location) is > 2
    	JHAFormController jhaFormController = new JHAFormController();
    	jhaFormController.jhaItem27.Hazard_Type_Assessment_Rate__c = '';
    	jhaFormController.checkIfRatePickedIsGT2();
    	System.assertEquals(false, jhaFormController.htaReturnValueRateGT2);
    	
    	jhaFormController.jhaItem27.Hazard_Type_Assessment_Rate__c = '1';
    	jhaFormController.checkIfRatePickedIsGT2();
    	System.assertEquals(false, jhaFormController.htaReturnValueRateGT2);
    	
    	jhaFormController.jhaItem27.Hazard_Type_Assessment_Rate__c = '3';
    	jhaFormController.checkIfRatePickedIsGT2();
    	System.assertEquals(true, jhaFormController.htaReturnValueRateGT2);
    }
    
    
    @isTest(SeeAllData=true) static void testCheckIfHTA28ValuePickedIsYesAndHTA25No() {
    	// Test Action Function which checks if the Hazard Type Assessment for the 29th row (Electrical voltage exceeds 600V) is Yes
    	// and 26th row (Energy sources can be locked/tagged out) is No
    	JHAFormController jhaFormController = new JHAFormController();
    	jhaFormController.jhaItem28.Hazard_Type_Assessment__c = 'Yes';
    	jhaFormController.jhaItem25.Hazard_Type_Assessment__c = 'No';
    	jhaFormController.checkIfHTA28ValuePickedIsYesAndHTA25No();
    	System.assertEquals(true, jhaFormController.hta28ReturnValueYesAndHta25No);
    	
    	jhaFormController.jhaItem28.Hazard_Type_Assessment__c = 'No';
    	jhaFormController.jhaItem25.Hazard_Type_Assessment__c = 'No';
    	jhaFormController.checkIfHTA28ValuePickedIsYesAndHTA25No();
    	System.assertEquals(false, jhaFormController.hta28ReturnValueYesAndHta25No);
    }
    
    
    @isTest(SeeAllData=true) static void testRetrieveJobSiteAddress() {
    	// Test to retrieve the job site address given the account customer name id
    	// Create an Account record, Address__c record and corresponding Account_Address__c record for testing purposes.
    	Account acctTemp = null;
        Address__c addrTemp = null;
        Account_Address__c acctAddrJunctionObj = null;
        
        addrTemp = new Address__c();
        addrTemp.Address_Line_1__c = 'Test Address Line 1';
        addrTemp.Address_Line_2__c = 'Test Address Line 2';
        addrTemp.Address_Line_3__c = 'Test Address Line 3';
        addrTemp.Address_Line_4__c = 'Test Address Line 4';
        addrTemp.City__c = 'Minneapolis';
        addrTemp.Postal_Code__c = '55421';
        addrTemp.Country__c = 'United States';
        addrTemp.State_Province__c = 'Minnesota';
        insert addrTemp;
        
        acctTemp = new Account();
        acctTemp.Name = 'Test Account Name';
        acctTemp.Physical_Address__c = addrTemp.Id;
        insert acctTemp;
        
        acctAddrJunctionObj = new Account_Address__c();
        acctAddrJunctionObj.Account__c = acctTemp.Id;
        acctAddrJunctionObj.Address__c = addrTemp.Id;
        acctAddrJunctionObj.Active__c = true;
        acctAddrJunctionObj.Physical__c = true;
        insert acctAddrJunctionObj;
        
    	
    	JHAFormController jhaFormController = new JHAFormController();
    	jhaFormController.jhaForm.Customer_Name__c = acctTemp.Id;
    	jhaFormController.loadExistingForm = false;
    	jhaFormController.forceDotComSite = true;
    	jhaFormController.epriseLoginId = 'blowj1';
    	jhaFormController.firstName = 'Joe';
    	jhaFormController.lastName = 'Blow';
    	jhaFormController.email = 'joe.blow@xyz.com';
    	PageReference pageRef = jhaFormController.retrieveJobSiteAddress();
    	System.assertEquals(addrTemp.Address_Line_1__c, jhaFormController.addr.Address_Line_1__c);
    	System.assertEquals(addrTemp.Address_Line_2__c, jhaFormController.addr.Address_Line_2__c);
    	System.assertEquals(addrTemp.City__c, jhaFormController.addr.City__c);
    	System.assertEquals(addrTemp.Postal_Code__c, jhaFormController.addr.Postal_Code__c);
    	System.assertEquals(addrTemp.Country__c, jhaFormController.addr.Country__c);
    	System.assertEquals(addrTemp.State_Province__c, jhaFormController.addr.State_Province__c);
    	System.assertEquals(addrTemp.Id, jhaFormController.jhaForm.Jobsite_Address__c);
    	
    	String expectedURL = URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/JHA_Form?addrId=' + jhaFormController.jhaForm.Jobsite_Address__c + '&msg=This jobsite has no existing forms!' + '&epriseLoginId=' + jhaFormController.epriseLoginId + '&email=' + jhaFormController.email + '&firstName=' + jhaFormController.firstName + '&lastName=' + jhaFormController.lastName;
    	System.assertEquals(expectedURL, jhaFormController.formURLName);
    	
    	// Here we are testing individual parts since the order in the returned url varies.
    	// Also need to replace some of the character sequences (hex values) with the character they represent since they are added in the url that is returned.
    	String actualUrl = pageRef.getUrl().replace('%3A', ':').replace('%2F', '/').replace('%40', '@').replace('%21', '!').replace('+', ' ');
        System.assert(actualUrl.contains(URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/JHA_Form?'));
        System.assert(actualUrl.contains('addrId=' + jhaFormController.jhaForm.Jobsite_Address__c));
        System.assert(actualUrl.contains('msg=This jobsite has no existing forms!'));
    	System.assert(actualUrl.contains('epriseLoginId=' + jhaFormController.epriseLoginId));
    	System.assert(actualUrl.contains('email=' + jhaFormController.email));
    	System.assert(actualUrl.contains('firstName=' + jhaFormController.firstName));
    	System.assert(actualUrl.contains('lastName=' + jhaFormController.lastName));
    	
    	// Test scenario where address doesn't exist in the database for the customer account id
    	Account acctTemp2 = null;
    	acctTemp2 = new Account();
        acctTemp2.Name = 'Test Account Name2';
        acctTemp2.Physical_Address__c = null;
        insert acctTemp2;
        jhaFormController.jhaForm.Customer_Name__c = acctTemp2.Id;
        pageRef = jhaFormController.retrieveJobSiteAddress();
        System.assertEquals(null, pageRef);
        
        // Test scenario where there is an existing form for this jobsite address, so the most recent one is returned
        JHA_Form__c jhaFormTemp = null;
        jhaFormTemp = new JHA_Form__c();
        jhaFormTemp.Jobsite_Address__c = addrTemp.Id;
        jhaFormTemp.Customer_Name__c = null;
        jhaFormTemp.Facility_Type__c = 'Other';
        jhaFormTemp.Date__c = System.today();
        jhaFormTemp.Employee__c = UserInfo.getUserName();
        jhaFormTemp.Evaluation_Type__c = 'First Time Evaluation';
        jhaFormTemp.Special_Comments__c = null;
        jhaFormTemp.Login_Contact__c = null;
        insert jhaFormTemp;
        jhaFormController.loadExistingForm = false;
    	jhaFormController.forceDotComSite = true;
    	jhaFormController.jhaForm.Customer_Name__c = acctTemp.Id;
    	jhaFormController.jhaForm.Jobsite_Address__c = addrTemp.Id;
    	pageRef = jhaFormController.retrieveJobSiteAddress();
    	expectedURL = URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/JHA_Form?id=' + jhaFormTemp.Id + '&msg=This jobsite has an existing form!' + '&epriseLoginId=' + jhaFormController.epriseLoginId + '&email=' + jhaFormController.email + '&firstName=' + jhaFormController.firstName + '&lastName=' + jhaFormController.lastName;
    	System.assertEquals(expectedURL, jhaFormController.formURLName);
    	
    	actualUrl = pageRef.getUrl().replace('%3A', ':').replace('%2F', '/').replace('%40', '@').replace('%21', '!').replace('+', ' ');
        System.assert(actualUrl.contains(URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/JHA_Form?'));
        System.assert(actualUrl.contains('id=' + jhaFormTemp.Id));
        System.assert(actualUrl.contains('msg=This jobsite has an existing form!'));
    	System.assert(actualUrl.contains('epriseLoginId=' + jhaFormController.epriseLoginId));
    	System.assert(actualUrl.contains('email=' + jhaFormController.email));
    	System.assert(actualUrl.contains('firstName=' + jhaFormController.firstName));
    	System.assert(actualUrl.contains('lastName=' + jhaFormController.lastName));
    }
    
    
    @isTest(SeeAllData=true) static void testLoadForm() {
    	// Test loading of an existing form called from the controller's constructor.
    	// Methods tested: loadForm, retrieveAccountAndAddressFields, setMultiSelectPicklistValues
    	// Create an Account record, Address__c record and corresponding Account_Address__c record for testing purposes.
    	// Create a JHA_Form__c record and corresponding JHA_Item__c records
    	Account acctTemp = null;
        Address__c addrTemp = null;
        Account_Address__c acctAddrJunctionObj = null;
        JHA_Form__c jhaFormTemp = null;
        JHA_Item__c[] jhaItemListTemp = new JHA_Item__c[JHA_ITEM_COUNT];
        
        addrTemp = new Address__c();
        addrTemp.Address_Line_1__c = 'Test Address Line 1';
        addrTemp.Address_Line_2__c = 'Test Address Line 2';
        addrTemp.Address_Line_3__c = 'Test Address Line 3';
        addrTemp.Address_Line_4__c = 'Test Address Line 4';
        addrTemp.City__c = 'Minneapolis';
        addrTemp.Postal_Code__c = '55421';
        addrTemp.Country__c = 'United States';
        addrTemp.State_Province__c = 'Minnesota';
        insert addrTemp;
        
        acctTemp = new Account();
        acctTemp.Name = 'Test Account Name';
        acctTemp.Physical_Address__c = addrTemp.Id;
        insert acctTemp;
        
        acctAddrJunctionObj = new Account_Address__c();
        acctAddrJunctionObj.Account__c = acctTemp.Id;
        acctAddrJunctionObj.Address__c = addrTemp.Id;
        acctAddrJunctionObj.Active__c = true;
        acctAddrJunctionObj.Physical__c = true;
        insert acctAddrJunctionObj;
        
        jhaFormTemp = new JHA_Form__c();
        jhaFormTemp.Jobsite_Address__c = addrTemp.Id;
        jhaFormTemp.Customer_Name__c = acctTemp.Id;
        jhaFormTemp.Facility_Type__c = 'Other';
        jhaFormTemp.Date__c = System.today();
        jhaFormTemp.Employee__c = UserInfo.getUserName();
        jhaFormTemp.Evaluation_Type__c = 'First Time Evaluation';
        jhaFormTemp.Special_Comments__c = null;
        jhaFormTemp.Login_Contact__c = null;
        insert jhaFormTemp;
        
        Hazard_Type__c hazardType;
        string s;
        for (Integer i = 0; i < JHA_ITEM_COUNT; i++) {
        	s = string.valueof(i);
            hazardType = [SELECT Id, Name, Description__c FROM Hazard_Type__c WHERE Name = :s];
            
            jhaItemListTemp[i] = new JHA_Item__c();
            jhaItemListTemp[i].JHA_Form__c = jhaFormTemp.Id;
            jhaItemListTemp[i].Hazard_Type__c = hazardType.Id;
            if (i != 27) {
            	jhaItemListTemp[i].Hazard_Type_Assessment__c = 'No';
            	jhaItemListTemp[i].Hazard_Type_Assessment_Rate__c = null;
            }
            else {
            	jhaItemListTemp[i].Hazard_Type_Assessment__c = null;
            	jhaItemListTemp[i].Hazard_Type_Assessment_Rate__c = '0';
            }
            jhaItemListTemp[i].Affected_Area__c = null;
            jhaItemListTemp[i].PPE_ID__c = null;
            jhaItemListTemp[i].Hazard_Description__c = null;
        }
        // Set some jha items
        jhaItemListTemp[0].Hazard_Type_Assessment__c = 'Yes';
        
        jhaItemListTemp[2].Hazard_Type_Assessment__c = 'No';
        jhaItemListTemp[2].Affected_Area__c = 'Eyes;Respiratory';
        jhaItemListTemp[2].PPE_ID__c = 'Standard Uniform;Face-shield/Goggles;Dust Mask/Air Purifying';
        jhaItemListTemp[2].Hazard_Description__c = 'Asbestos issue';
        
        jhaItemListTemp[15].Hazard_Type_Assessment__c = 'Yes';
        jhaItemListTemp[15].Affected_Area__c = 'Eyes;Head';
        jhaItemListTemp[15].PPE_ID__c = 'Leather Work Gloves';
        jhaItemListTemp[15].Hazard_Description__c = 'Bad blood';
        
        jhaItemListTemp[16].Hazard_Type_Assessment__c = 'Yes';
        jhaItemListTemp[16].PPE_ID__c = 'Standard Uniform;Anchoring';
        jhaItemListTemp[16].Hazard_Description__c = 'Work fall issue';
        
        jhaItemListTemp[21].Hazard_Type_Assessment__c = 'Yes';
        
        jhaItemListTemp[24].Hazard_Type_Assessment__c = 'Yes';
        
        jhaItemListTemp[25].Hazard_Type_Assessment__c = 'Yes';
        jhaItemListTemp[25].Affected_Area__c = 'Body/Torso';
        jhaItemListTemp[25].PPE_ID__c = 'Arc Flash Protective Equipment';
        jhaItemListTemp[25].Hazard_Description__c = 'Tagged out';
        
        jhaItemListTemp[26].Hazard_Type_Assessment__c = 'Yes';
        
        jhaItemListTemp[31].Hazard_Type_Assessment__c = 'Yes';
        
        jhaItemListTemp[35].Hazard_Type_Assessment__c = 'Yes';
        
        insert jhaItemListTemp;
        
        // Create new JHAFormController object which will call the constructor.
        // Put the form id query string parameter for current page's PageReference so the constructor has access to it.
        // Test against some of the visualforce page elements
        Apexpages.currentpage().getparameters().put('id', jhaFormTemp.Id);
        JHAFormController jhaFormController = new JHAFormController();
    	System.assertEquals(jhaFormTemp.Id, jhaFormController.jhaForm.Id);
    	System.assertEquals(jhaItemListTemp[0].Hazard_Type_Assessment__c, jhaFormController.jhaItem0.Hazard_Type_Assessment__c);
    	System.assertEquals(jhaItemListTemp[2].Hazard_Type_Assessment__c, jhaFormController.jhaItem2.Hazard_Type_Assessment__c);
    	System.assertEquals(jhaItemListTemp[2].Affected_Area__c, jhaFormController.jhaItem2.Affected_Area__c);
    	System.assertEquals(jhaItemListTemp[2].PPE_ID__c, jhaFormController.jhaItem2.PPE_ID__c);
    	System.assertEquals(jhaItemListTemp[2].Hazard_Description__c, jhaFormController.jhaItem2.Hazard_Description__c);
    	System.assertEquals(jhaItemListTemp[15].Hazard_Type_Assessment__c, jhaFormController.jhaItem15.Hazard_Type_Assessment__c);
    	System.assertEquals(jhaItemListTemp[15].Affected_Area__c, jhaFormController.jhaItem15.Affected_Area__c);
    	System.assertEquals(jhaItemListTemp[15].PPE_ID__c, jhaFormController.jhaItem15.PPE_ID__c);
    	System.assertEquals(jhaItemListTemp[15].Hazard_Description__c, jhaFormController.jhaItem15.Hazard_Description__c);
    	System.assertEquals(jhaItemListTemp[16].Hazard_Type_Assessment__c, jhaFormController.jhaItem16.Hazard_Type_Assessment__c);
    	System.assertEquals(jhaItemListTemp[16].PPE_ID__c, jhaFormController.jhaItem16.PPE_ID__c);
    	System.assertEquals(jhaItemListTemp[16].Hazard_Description__c, jhaFormController.jhaItem16.Hazard_Description__c);
    	System.assertEquals(jhaItemListTemp[21].Hazard_Type_Assessment__c, jhaFormController.jhaItem21.Hazard_Type_Assessment__c);
    	System.assertEquals(jhaItemListTemp[24].Hazard_Type_Assessment__c, jhaFormController.jhaItem24.Hazard_Type_Assessment__c);
    	System.assertEquals(jhaItemListTemp[25].Hazard_Type_Assessment__c, jhaFormController.jhaItem25.Hazard_Type_Assessment__c);
    	System.assertEquals(jhaItemListTemp[25].Affected_Area__c, jhaFormController.jhaItem25.Affected_Area__c);
    	System.assertEquals(jhaItemListTemp[25].PPE_ID__c, jhaFormController.jhaItem25.PPE_ID__c);
    	System.assertEquals(jhaItemListTemp[25].Hazard_Description__c, jhaFormController.jhaItem25.Hazard_Description__c);
    	System.assertEquals(jhaItemListTemp[26].Hazard_Type_Assessment__c, jhaFormController.jhaItem26.Hazard_Type_Assessment__c);
    	System.assertEquals(jhaItemListTemp[31].Hazard_Type_Assessment__c, jhaFormController.jhaItem31.Hazard_Type_Assessment__c);
    	System.assertEquals(jhaItemListTemp[35].Hazard_Type_Assessment__c, jhaFormController.jhaItem35.Hazard_Type_Assessment__c);
    }
    
    
    @isTest(SeeAllData=true) static void testSave() {
    	// Test saving a new or updated form to the database.
    	// Methods tested: save, checkIfFormFieldsHaveValue, checkIfContactExists, returnMultiSelectSetAsString
    	// Create a Contact record that is associated with the Account record
    	// Need to set affectedAreaRightValuesX and ppeIdRightValuesX objects of type Set<string>, where (0 <= X <= 40)
    	Account acctTemp = null;
        Address__c addrTemp = null;
        Contact contactTemp = null;
        RecordType recordTypeTemp = null;
        String epriseLoginId = 'blowj1';
		String firstName = 'Joe';
		String lastName = 'Blow';
		String email = 'joe.blow@xyz.com';
        
        // Get 'Daikin Applied Americas Corporate' account and corresponding address for the tests
        // NOTE- This account MUST exist in the environment since all contacts that login to create a JHA form must be associated with this account.
        recordTypeTemp = [SELECT Id FROM RecordType WHERE Name='Daikin Applied' AND SObjectType='Contact'];
        acctTemp = [SELECT Id, Physical_Address__c FROM Account WHERE Name = 'Daikin Applied Americas Corporate' AND Type != ''];
        addrTemp = [SELECT Id, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, Address_Name__c, Postal_Code__c, City__c, Country__c, State_Province__c FROM Address__c WHERE Id = :acctTemp.physical_address__c];
        
        // Create a Contact record that is associated with this account
        contactTemp = new Contact();
        contactTemp.Eprise_Login_ID__c = epriseLoginId;
        contactTemp.RecordTypeId = recordTypeTemp.Id;
        contactTemp.AccountId = acctTemp.Id;
        contactTemp.Status__c = 'Active';
        contactTemp.Email = email;
        contactTemp.FirstName = firstName;
        contactTemp.LastName = lastName;
        insert contactTemp;
        
        // Set up query string parameters for the page before constructor gets called when creating the object
        Apexpages.currentpage().getparameters().put('epriseLoginId', epriseLoginId);
        Apexpages.currentpage().getparameters().put('firstName', firstName);
        Apexpages.currentpage().getparameters().put('lastName', lastName);
        Apexpages.currentpage().getparameters().put('email', email);
        JHAFormController jhaFormController = new JHAFormController();
        jhaFormController.forceDotComSite = true;
        
        
        // *** Set JHA Form and JHA Item values before Save ***
        
        // JHA Form fields: Id, Name, Customer_Name__c, Date__c, Employee__c, Evaluation_Type__c, Facility_Type__c, Jobsite_Address__c, Special_Comments__c, Login_Contact__c
        // These fields are set in the constructor for a new form: Date__c, Employee__c, Evaluation_Type__c
        jhaFormController.jhaForm.Customer_Name__c = acctTemp.Id;
        jhaFormController.jhaForm.Facility_Type__c = 'Other';
        jhaFormController.jhaForm.Jobsite_Address__c = addrTemp.Id;
        jhaFormController.jhaForm.Special_Comments__c = 'Any comments';
        
        // Address fields: Id, Name, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, Address_Name__c, Postal_Code__c, City__c, Country__c, State_Province__c
        jhaFormController.addr.Address_Line_1__c = addrTemp.Address_Line_1__c;
        jhaFormController.addr.Address_Line_2__c = addrTemp.Address_Line_2__c;
        jhaFormController.addr.Address_Line_3__c = addrTemp.Address_Line_3__c;
        jhaFormController.addr.Address_Line_4__c = addrTemp.Address_Line_4__c;
        jhaFormController.addr.Country__c = addrTemp.Country__c;
        jhaFormController.addr.State_Province__c = addrTemp.State_Province__c;
        jhaFormController.addr.City__c = addrTemp.City__c;
        jhaFormController.addr.Postal_Code__c = addrTemp.Postal_Code__c;
        
        // JHA Item fields: Id, Name, Affected_Area__c, PPE_ID__c, JHA_Form__c, Hazard_Type__c, Hazard_Type_Assessment__c, Hazard_Type_Assessment_Rate__c, Hazard_Description__c
        // These fields are set in the constructor: Hazard_Type__c
        // These fields get set in the save method: Affected_Area__c, PPE_ID__c, JHA_Form__c
        // First initialize all jha item objects
        for (Integer i = 0; i < JHA_ITEM_COUNT; i++) {
            if (i != 27) {
            	jhaFormController.jhaItemList[i].Hazard_Type_Assessment__c = 'No';
            	jhaFormController.jhaItemList[i].Hazard_Type_Assessment_Rate__c = null;
            }
            else {
            	jhaFormController.jhaItemList[i].Hazard_Type_Assessment__c = null;
            	jhaFormController.jhaItemList[i].Hazard_Type_Assessment_Rate__c = '0';
            }
            jhaFormController.jhaItemList[i].Affected_Area__c = null;
            jhaFormController.jhaItemList[i].PPE_ID__c = null;
            jhaFormController.jhaItemList[i].Hazard_Description__c = null;
        }
        // Now set some specific jha item objects with values
        jhaFormController.jhaItemList[0].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController.jhaItemList[2].Hazard_Type_Assessment__c = 'No';
        jhaFormController.jhaItemList[2].Hazard_Description__c = 'Asbestos issue';
        jhaFormController.affectedAreaRightValues2.add('Eyes');
        jhaFormController.affectedAreaRightValues2.add('Respiratory');
        jhaFormController.ppeIdRightValues2.add('Standard Uniform');
        jhaFormController.ppeIdRightValues2.add('Face-shield/Goggles');
        jhaFormController.ppeIdRightValues2.add('Dust Mask/Air Purifying');
        
        jhaFormController.jhaItemList[15].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController.jhaItemList[15].Hazard_Description__c = 'Bad blood';
        jhaFormController.affectedAreaRightValues15.add('Eyes');
        jhaFormController.affectedAreaRightValues15.add('Head');
        jhaFormController.ppeIdRightValues15.add('Leather Work Gloves');
        
        jhaFormController.jhaItemList[16].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController.jhaItemList[16].Hazard_Description__c = 'Work fall issue';
        jhaFormController.ppeIdRightValues16.add('Standard Uniform');
        jhaFormController.ppeIdRightValues16.add('Anchoring');
        
        jhaFormController.jhaItemList[21].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController.jhaItemList[24].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController.jhaItemList[25].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController.jhaItemList[25].Hazard_Description__c = 'Tagged out';
        jhaFormController.affectedAreaRightValues25.add('Body/Torso');
        jhaFormController.ppeIdRightValues25.add('Arc Flash Protective Equipment');
        
        jhaFormController.jhaItemList[26].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController.jhaItemList[31].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController.jhaItemList[35].Hazard_Type_Assessment__c = 'Yes';
        
        
        // Call the Save method
        PageReference pageRef = jhaFormController.save();
        
        String expectedURL = URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/FormSaveConfirm';
    	System.assertEquals(expectedURL, jhaFormController.formURLName);
    	
    	// Test the pageRef returned
    	// Need to replace some of the character sequences (hex values) with the character they represent since they are added in the url that is returned.
    	String actualUrl = pageRef.getUrl().replace('%3A', ':').replace('%2F', '/').replace('%40', '@').replace('%21', '!').replace('+', ' ');
        System.assert(actualUrl.contains(URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/FormSaveConfirm'));
        
        
        // Test negative case where an exception is thrown if some address fields are not set
        Apexpages.currentpage().getparameters().put('epriseLoginId', epriseLoginId);
        Apexpages.currentpage().getparameters().put('firstName', firstName);
        Apexpages.currentpage().getparameters().put('lastName', lastName);
        Apexpages.currentpage().getparameters().put('email', email);
        
        JHAFormController jhaFormController2 = new JHAFormController();
        jhaFormController2.forceDotComSite = true;
        jhaFormController2.jhaForm.Customer_Name__c = acctTemp.Id;
        jhaFormController2.jhaForm.Facility_Type__c = 'Other';
        jhaFormController2.jhaForm.Jobsite_Address__c = addrTemp.Id;
        jhaFormController2.jhaForm.Special_Comments__c = 'Any comments';
        
        jhaFormController2.addr.Address_Line_1__c = null;
        jhaFormController2.addr.Address_Line_2__c = null;
        jhaFormController2.addr.Address_Line_3__c = null;
        jhaFormController2.addr.Address_Line_4__c = null;
        jhaFormController2.addr.Country__c = null;
        jhaFormController2.addr.State_Province__c = null;
        jhaFormController2.addr.City__c = null;
        jhaFormController2.addr.Postal_Code__c = null;
        
        PageReference pageRef2 = jhaFormController2.save();
        System.assertEquals(null, pageRef2);
        
        System.debug('Have Messages? ' + apexpages.hasMessages());
        ApexPages.Message[] msgs = Apexpages.getMessages();
        /*for (ApexPages.Message m : msgs) {
        	System.debug(m.getSummary());
        }*/
        System.assertEquals('Address field "Address Line 1" is undefined. Please update! Form will not be saved!', msgs[0].getSummary());
    }
    
    
    @isTest(SeeAllData=true) static void testSave_NewAddress() {
    	// Test the case where a new address was added by the user since the jobsite address is new.
        JHAFormController jhaFormController3 = new JHAFormController();
        jhaFormController3.forceDotComSite = true;
        
        jhaFormController3.jhaForm.Customer_Name__c = null;
        jhaFormController3.jhaForm.Facility_Type__c = 'Other';
        jhaFormController3.jhaForm.Jobsite_Address__c = null;
        jhaFormController3.jhaForm.Special_Comments__c = 'Any comments';
        
        jhaFormController3.addr.Address_Line_1__c = 'New Test Address Line 1';
        jhaFormController3.addr.Address_Line_2__c = 'New Test Address Line 2';
        jhaFormController3.addr.Address_Line_3__c = 'New Test Address Line 3';
        jhaFormController3.addr.Address_Line_4__c = 'New Test Address Line 4';
        jhaFormController3.addr.Country__c = 'United States';
        jhaFormController3.addr.State_Province__c = 'Minnesota';
        jhaFormController3.addr.City__c = 'Minneapolis';
        jhaFormController3.addr.Postal_Code__c = '55421';
        
        for (Integer i = 0; i < JHA_ITEM_COUNT; i++) {
            if (i != 27) {
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment__c = 'No';
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment_Rate__c = null;
            }
            else {
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment__c = null;
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment_Rate__c = '0';
            }
            jhaFormController3.jhaItemList[i].Affected_Area__c = null;
            jhaFormController3.jhaItemList[i].PPE_ID__c = null;
            jhaFormController3.jhaItemList[i].Hazard_Description__c = null;
        }
        
        jhaFormController3.jhaItemList[0].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[2].Hazard_Type_Assessment__c = 'No';
        jhaFormController3.jhaItemList[2].Hazard_Description__c = 'Asbestos issue';
        jhaFormController3.affectedAreaRightValues2.add('Eyes');
        jhaFormController3.affectedAreaRightValues2.add('Respiratory');
        jhaFormController3.ppeIdRightValues2.add('Standard Uniform');
        jhaFormController3.ppeIdRightValues2.add('Face-shield/Goggles');
        jhaFormController3.ppeIdRightValues2.add('Dust Mask/Air Purifying');
        
        jhaFormController3.jhaItemList[15].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[15].Hazard_Description__c = 'Bad blood';
        jhaFormController3.affectedAreaRightValues15.add('Eyes');
        jhaFormController3.affectedAreaRightValues15.add('Head');
        jhaFormController3.ppeIdRightValues15.add('Leather Work Gloves');
        
        jhaFormController3.jhaItemList[16].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[16].Hazard_Description__c = 'Work fall issue';
        jhaFormController3.ppeIdRightValues16.add('Standard Uniform');
        jhaFormController3.ppeIdRightValues16.add('Anchoring');
        
        jhaFormController3.jhaItemList[21].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[24].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[25].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[25].Hazard_Description__c = 'Tagged out';
        jhaFormController3.affectedAreaRightValues25.add('Body/Torso');
        jhaFormController3.ppeIdRightValues25.add('Arc Flash Protective Equipment');
        
        jhaFormController3.jhaItemList[26].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[31].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[35].Hazard_Type_Assessment__c = 'Yes';
        
        PageReference pageRef3 = jhaFormController3.save();
        
        System.assertNotEquals(null, jhaFormController3.jhaForm.Jobsite_Address__c);
        System.assertEquals(jhaFormController3.addr.Id, jhaFormController3.jhaForm.Jobsite_Address__c);
        
        Address__c addrTemp3 = null;
        addrTemp3 = [SELECT Id, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, Address_Name__c, Postal_Code__c, City__c, Country__c, State_Province__c FROM Address__c WHERE Id = :jhaFormController3.jhaForm.Jobsite_Address__c];
        System.assertEquals('New Test Address Line 1', addrTemp3.Address_Line_1__c);
        
        JHA_Form__c jhaFormTemp3 = null;
        jhaFormTemp3 = [SELECT Id, Jobsite_Address__c, Login_Contact__c FROM JHA_Form__c WHERE Jobsite_Address__c = :jhaFormController3.jhaForm.Jobsite_Address__c];
        System.assertNotEquals(null, jhaFormTemp3.Id);
        
        String expectedURL = URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/FormSaveConfirm';
    	System.assertEquals(expectedURL, jhaFormController3.formURLName);
    }
    
    
    @isTest(SeeAllData=true) static void testLoadAddressInformation() {
    	// Test loading of a page with just address information from the controller's constructor.
    	// Create an Account record, Address__c record and corresponding Account_Address__c record for testing purposes.
		Account acctTemp = null;
        Address__c addrTemp = null;
        Account_Address__c acctAddrJunctionObj = null;
        
        addrTemp = new Address__c();
        addrTemp.Address_Line_1__c = 'Test Address Line 1';
        addrTemp.Address_Line_2__c = 'Test Address Line 2';
        addrTemp.Address_Line_3__c = 'Test Address Line 3';
        addrTemp.Address_Line_4__c = 'Test Address Line 4';
        addrTemp.City__c = 'Minneapolis';
        addrTemp.Postal_Code__c = '55421';
        addrTemp.Country__c = 'United States';
        addrTemp.State_Province__c = 'Minnesota';
        insert addrTemp;
        
        acctTemp = new Account();
        acctTemp.Name = 'Test Account Name';
        acctTemp.Physical_Address__c = addrTemp.Id;
        insert acctTemp;
        
        acctAddrJunctionObj = new Account_Address__c();
        acctAddrJunctionObj.Account__c = acctTemp.Id;
        acctAddrJunctionObj.Address__c = addrTemp.Id;
        acctAddrJunctionObj.Active__c = true;
        acctAddrJunctionObj.Physical__c = true;
        insert acctAddrJunctionObj;
        
        // Create new JHAFormController object which will call the constructor.
        // Put the address id query string parameter for current page's PageReference so the constructor has access to it.
        Apexpages.currentpage().getparameters().put('addrId', addrTemp.Id);
        JHAFormController jhaFormController = new JHAFormController();
        System.assertEquals(addrTemp.Id, jhaFormController.jhaForm.Jobsite_Address__c);
        System.assertEquals(acctTemp.Id, jhaFormController.jhaForm.Customer_Name__c);
        
        // Test negative case where the address doesn't exist and an exception is thrown
        Id fakeId = Id.valueOf('001xa000003DIlo');
        Apexpages.currentpage().getparameters().put('addrId', fakeId);
        JHAFormController jhaFormController2 = new JHAFormController();
        System.assertEquals(null, jhaFormController2.jhaForm.Jobsite_Address__c);
        System.assertEquals(null, jhaFormController2.jhaForm.Customer_Name__c);
    }
    
    
    @isTest(SeeAllData=true) static void testAddNewContact() {
    	// Test the private method checkIfContactExists which will add a new contact if the epriseLoginId doesn't exist
    	String epriseLoginId = 'blowj1';
		String firstName = 'Joe';
		String lastName = 'Blow';
		String email = 'joe.blow@xyz.com';
		
		// Set up query string parameters for the page before constructor gets called when creating the object
        Apexpages.currentpage().getparameters().put('epriseLoginId', epriseLoginId);
        Apexpages.currentpage().getparameters().put('firstName', firstName);
        Apexpages.currentpage().getparameters().put('lastName', lastName);
        Apexpages.currentpage().getparameters().put('email', email);
        JHAFormController jhaFormController = new JHAFormController();
        jhaFormController.forceDotComSite = true;
        
        Id contactIdTemp = null;
        contactIdTemp = jhaFormController.checkIfContactExists();
        System.assertNotEquals(null, contactIdTemp);
        
        Contact contactTemp = null;
        contactTemp = [SELECT Id FROM Contact WHERE Eprise_Login_ID__c = :epriseLoginId];
        System.assertEquals(contactIdTemp, contactTemp.Id);
    }
    
    
    @isTest(SeeAllData=true) static void testSave_NewAddressAndContact() {
    	// Method tested: Save
    	// Test the case where a new address was added by the user since the jobsite address is new.
    	// New contact is added too.
    	String epriseLoginId = 'blowj1';
		String firstName = 'Joe';
		String lastName = 'Blow';
		String email = 'joe.blow@xyz.com';
		
		Apexpages.currentpage().getparameters().put('epriseLoginId', epriseLoginId);
        Apexpages.currentpage().getparameters().put('firstName', firstName);
        Apexpages.currentpage().getparameters().put('lastName', lastName);
        Apexpages.currentpage().getparameters().put('email', email);
        JHAFormController jhaFormController3 = new JHAFormController();
        jhaFormController3.forceDotComSite = true;
        
        jhaFormController3.jhaForm.Customer_Name__c = null;
        jhaFormController3.jhaForm.Facility_Type__c = 'Other';
        jhaFormController3.jhaForm.Jobsite_Address__c = null;
        jhaFormController3.jhaForm.Special_Comments__c = 'Any comments';
        
        jhaFormController3.addr.Address_Line_1__c = 'New Test Address Line 1';
        jhaFormController3.addr.Address_Line_2__c = 'New Test Address Line 2';
        jhaFormController3.addr.Address_Line_3__c = 'New Test Address Line 3';
        jhaFormController3.addr.Address_Line_4__c = 'New Test Address Line 4';
        jhaFormController3.addr.Country__c = 'United States';
        jhaFormController3.addr.State_Province__c = 'Minnesota';
        jhaFormController3.addr.City__c = 'Minneapolis';
        jhaFormController3.addr.Postal_Code__c = '55421';
        
        for (Integer i = 0; i < JHA_ITEM_COUNT; i++) {
            if (i != 27) {
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment__c = 'No';
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment_Rate__c = null;
            }
            else {
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment__c = null;
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment_Rate__c = '0';
            }
            jhaFormController3.jhaItemList[i].Affected_Area__c = null;
            jhaFormController3.jhaItemList[i].PPE_ID__c = null;
            jhaFormController3.jhaItemList[i].Hazard_Description__c = null;
        }
        
        jhaFormController3.jhaItemList[0].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[2].Hazard_Type_Assessment__c = 'No';
        jhaFormController3.jhaItemList[2].Hazard_Description__c = 'Asbestos issue';
        jhaFormController3.affectedAreaRightValues2.add('Eyes');
        jhaFormController3.affectedAreaRightValues2.add('Respiratory');
        jhaFormController3.ppeIdRightValues2.add('Standard Uniform');
        jhaFormController3.ppeIdRightValues2.add('Face-shield/Goggles');
        jhaFormController3.ppeIdRightValues2.add('Dust Mask/Air Purifying');
        
        jhaFormController3.jhaItemList[15].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[15].Hazard_Description__c = 'Bad blood';
        jhaFormController3.affectedAreaRightValues15.add('Eyes');
        jhaFormController3.affectedAreaRightValues15.add('Head');
        jhaFormController3.ppeIdRightValues15.add('Leather Work Gloves');
        
        jhaFormController3.jhaItemList[16].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[16].Hazard_Description__c = 'Work fall issue';
        jhaFormController3.ppeIdRightValues16.add('Standard Uniform');
        jhaFormController3.ppeIdRightValues16.add('Anchoring');
        
        jhaFormController3.jhaItemList[21].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[24].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[25].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[25].Hazard_Description__c = 'Tagged out';
        jhaFormController3.affectedAreaRightValues25.add('Body/Torso');
        jhaFormController3.ppeIdRightValues25.add('Arc Flash Protective Equipment');
        
        jhaFormController3.jhaItemList[26].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[31].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[35].Hazard_Type_Assessment__c = 'Yes';
        
        PageReference pageRef3 = jhaFormController3.save();
        
        System.assertNotEquals(null, jhaFormController3.jhaForm.Jobsite_Address__c);
        System.assertEquals(jhaFormController3.addr.Id, jhaFormController3.jhaForm.Jobsite_Address__c);
        
        Address__c addrTemp3 = null;
        addrTemp3 = [SELECT Id, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, Address_Name__c, Postal_Code__c, City__c, Country__c, State_Province__c FROM Address__c WHERE Id = :jhaFormController3.jhaForm.Jobsite_Address__c];
        System.assertEquals('New Test Address Line 1', addrTemp3.Address_Line_1__c);
        
        Contact contactTemp = null;
        contactTemp = [SELECT Id FROM Contact WHERE Eprise_Login_ID__c = :epriseLoginId];
        System.assertNotEquals(null, contactTemp.Id);
        
        JHA_Form__c jhaFormTemp3 = null;
        jhaFormTemp3 = [SELECT Id, Jobsite_Address__c, Login_Contact__c FROM JHA_Form__c WHERE Jobsite_Address__c = :jhaFormController3.jhaForm.Jobsite_Address__c];
        System.assertNotEquals(null, jhaFormTemp3.Id);
        System.assertEquals(contactTemp.Id, jhaFormTemp3.Login_Contact__c);
        
        String expectedURL = URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/FormSaveConfirm';
    	System.assertEquals(expectedURL, jhaFormController3.formURLName);
    }
    
    
    @isTest(SeeAllData=true) static void testSave_CheckIfFormFieldsHaveValue1() {
    	// Test the case during a save when 1 of the form header fields don't have a value
        JHAFormController jhaFormController3 = new JHAFormController();
        jhaFormController3.forceDotComSite = true;
        
        jhaFormController3.jhaForm.Customer_Name__c = null;
        jhaFormController3.jhaForm.Facility_Type__c = null;
        jhaFormController3.jhaForm.Jobsite_Address__c = null;
        jhaFormController3.jhaForm.Special_Comments__c = null;
        
        jhaFormController3.addr.Address_Line_1__c = 'New Test Address Line 1';
        jhaFormController3.addr.Address_Line_2__c = 'New Test Address Line 2';
        jhaFormController3.addr.Address_Line_3__c = 'New Test Address Line 3';
        jhaFormController3.addr.Address_Line_4__c = 'New Test Address Line 4';
        jhaFormController3.addr.Country__c = 'United States';
        jhaFormController3.addr.State_Province__c = 'Minnesota';
        jhaFormController3.addr.City__c = 'Minneapolis';
        jhaFormController3.addr.Postal_Code__c = '55421';
        
        for (Integer i = 0; i < JHA_ITEM_COUNT; i++) {
            if (i != 27) {
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment__c = 'No';
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment_Rate__c = null;
            }
            else {
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment__c = null;
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment_Rate__c = '0';
            }
            jhaFormController3.jhaItemList[i].Affected_Area__c = null;
            jhaFormController3.jhaItemList[i].PPE_ID__c = null;
            jhaFormController3.jhaItemList[i].Hazard_Description__c = null;
        }
        
        jhaFormController3.jhaItemList[0].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[2].Hazard_Type_Assessment__c = 'No';
        jhaFormController3.jhaItemList[2].Hazard_Description__c = 'Asbestos issue';
        jhaFormController3.affectedAreaRightValues2.add('Eyes');
        jhaFormController3.affectedAreaRightValues2.add('Respiratory');
        jhaFormController3.ppeIdRightValues2.add('Standard Uniform');
        jhaFormController3.ppeIdRightValues2.add('Face-shield/Goggles');
        jhaFormController3.ppeIdRightValues2.add('Dust Mask/Air Purifying');
        
        jhaFormController3.jhaItemList[15].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[15].Hazard_Description__c = 'Bad blood';
        jhaFormController3.affectedAreaRightValues15.add('Eyes');
        jhaFormController3.affectedAreaRightValues15.add('Head');
        jhaFormController3.ppeIdRightValues15.add('Leather Work Gloves');
        
        jhaFormController3.jhaItemList[16].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[16].Hazard_Description__c = 'Work fall issue';
        jhaFormController3.ppeIdRightValues16.add('Standard Uniform');
        jhaFormController3.ppeIdRightValues16.add('Anchoring');
        
        jhaFormController3.jhaItemList[21].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[24].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[25].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[25].Hazard_Description__c = 'Tagged out';
        jhaFormController3.affectedAreaRightValues25.add('Body/Torso');
        jhaFormController3.ppeIdRightValues25.add('Arc Flash Protective Equipment');
        
        jhaFormController3.jhaItemList[26].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[31].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[35].Hazard_Type_Assessment__c = 'Yes';
        
        PageReference pageRef3 = jhaFormController3.save();
        System.assertEquals(null, pageRef3);
        
        System.debug('Have Messages? ' + apexpages.hasMessages());
        ApexPages.Message[] msgs = Apexpages.getMessages();
        /*for (ApexPages.Message m : msgs) {
        	System.debug(m.getSummary());
        }*/
        System.assertEquals('Required', msgs[0].getSummary());
        System.assertEquals('Facility Type field not set. Form will not be saved!', msgs[1].getSummary());
    }
    
    
    @isTest(SeeAllData=true) static void testSave_CheckIfFormFieldsHaveValue2() {
    	// Test the case during a save when 1 of the form's jha item fields don't have a value
        JHAFormController jhaFormController3 = new JHAFormController();
        jhaFormController3.forceDotComSite = true;
        
        jhaFormController3.jhaForm.Customer_Name__c = null;
        jhaFormController3.jhaForm.Facility_Type__c = 'Other';
        jhaFormController3.jhaForm.Jobsite_Address__c = null;
        jhaFormController3.jhaForm.Special_Comments__c = null;
        
        jhaFormController3.addr.Address_Line_1__c = 'New Test Address Line 1';
        jhaFormController3.addr.Address_Line_2__c = 'New Test Address Line 2';
        jhaFormController3.addr.Address_Line_3__c = 'New Test Address Line 3';
        jhaFormController3.addr.Address_Line_4__c = 'New Test Address Line 4';
        jhaFormController3.addr.Country__c = 'United States';
        jhaFormController3.addr.State_Province__c = 'Minnesota';
        jhaFormController3.addr.City__c = 'Minneapolis';
        jhaFormController3.addr.Postal_Code__c = '55421';
        
        for (Integer i = 0; i < JHA_ITEM_COUNT; i++) {
            if (i != 27) {
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment__c = 'No';
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment_Rate__c = null;
            }
            else {
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment__c = null;
            	jhaFormController3.jhaItemList[i].Hazard_Type_Assessment_Rate__c = '0';
            }
            jhaFormController3.jhaItemList[i].Affected_Area__c = null;
            jhaFormController3.jhaItemList[i].PPE_ID__c = null;
            jhaFormController3.jhaItemList[i].Hazard_Description__c = null;
        }
        
        jhaFormController3.jhaItemList[0].Hazard_Type_Assessment__c = null;
        
        jhaFormController3.jhaItemList[2].Hazard_Type_Assessment__c = 'No';
        jhaFormController3.jhaItemList[2].Hazard_Description__c = 'Asbestos issue';
        jhaFormController3.affectedAreaRightValues2.add('Eyes');
        jhaFormController3.affectedAreaRightValues2.add('Respiratory');
        jhaFormController3.ppeIdRightValues2.add('Standard Uniform');
        jhaFormController3.ppeIdRightValues2.add('Face-shield/Goggles');
        jhaFormController3.ppeIdRightValues2.add('Dust Mask/Air Purifying');
        
        jhaFormController3.jhaItemList[15].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[15].Hazard_Description__c = 'Bad blood';
        jhaFormController3.affectedAreaRightValues15.add('Eyes');
        jhaFormController3.affectedAreaRightValues15.add('Head');
        jhaFormController3.ppeIdRightValues15.add('Leather Work Gloves');
        
        jhaFormController3.jhaItemList[16].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[16].Hazard_Description__c = 'Work fall issue';
        jhaFormController3.ppeIdRightValues16.add('Standard Uniform');
        jhaFormController3.ppeIdRightValues16.add('Anchoring');
        
        jhaFormController3.jhaItemList[21].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[24].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[25].Hazard_Type_Assessment__c = 'Yes';
        jhaFormController3.jhaItemList[25].Hazard_Description__c = 'Tagged out';
        jhaFormController3.affectedAreaRightValues25.add('Body/Torso');
        jhaFormController3.ppeIdRightValues25.add('Arc Flash Protective Equipment');
        
        jhaFormController3.jhaItemList[26].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[31].Hazard_Type_Assessment__c = 'Yes';
        
        jhaFormController3.jhaItemList[35].Hazard_Type_Assessment__c = 'Yes';
        
        PageReference pageRef3 = jhaFormController3.save();
        System.assertEquals(null, pageRef3);
        
        System.debug('Have Messages? ' + apexpages.hasMessages());
        ApexPages.Message[] msgs = Apexpages.getMessages();
        /*for (ApexPages.Message m : msgs) {
        	System.debug(m.getSummary());
        }*/
        System.assertEquals('Required', msgs[0].getSummary());
        System.assertEquals('Hazard Type Assessment field, "Customer has site specific safety plan" not set. Form will not be saved!', msgs[1].getSummary());
    }
    
    
    @isTest(SeeAllData=true) static void testRetrieveAccountAndAddressFields() {
    	// Test to retrieve the account and job site address fields given the address id
    	// Create an Account record, Address__c record and corresponding Account_Address__c record for testing purposes.
    	Account acctTemp = null;
        Address__c addrTemp = null;
        Account_Address__c acctAddrJunctionObj = null;
        
        addrTemp = new Address__c();
        addrTemp.Address_Line_1__c = 'Test Address Line 1';
        addrTemp.Address_Line_2__c = 'Test Address Line 2';
        addrTemp.Address_Line_3__c = 'Test Address Line 3';
        addrTemp.Address_Line_4__c = 'Test Address Line 4';
        addrTemp.City__c = 'Minneapolis';
        addrTemp.Postal_Code__c = '55421';
        addrTemp.Country__c = 'United States';
        addrTemp.State_Province__c = 'Minnesota';
        insert addrTemp;
        
        acctTemp = new Account();
        acctTemp.Name = 'Test Account Name';
        acctTemp.Physical_Address__c = addrTemp.Id;
        insert acctTemp;
        
        acctAddrJunctionObj = new Account_Address__c();
        acctAddrJunctionObj.Account__c = acctTemp.Id;
        acctAddrJunctionObj.Address__c = addrTemp.Id;
        acctAddrJunctionObj.Active__c = true;
        acctAddrJunctionObj.Physical__c = true;
        insert acctAddrJunctionObj;
        
    	
    	JHAFormController jhaFormController = new JHAFormController();
    	jhaFormController.jhaForm.Jobsite_Address__c = addrTemp.Id;
    	jhaFormController.jhaForm.Customer_Name__c = null;
    	jhaFormController.loadExistingForm = false;
    	jhaFormController.forceDotComSite = true;
    	jhaFormController.epriseLoginId = 'blowj1';
    	jhaFormController.firstName = 'Joe';
    	jhaFormController.lastName = 'Blow';
    	jhaFormController.email = 'joe.blow@xyz.com';
    	PageReference pageRef = jhaFormController.retrieveAccountAndAddressFields();
    	System.assertEquals(addrTemp.Address_Line_1__c, jhaFormController.addr.Address_Line_1__c);
    	System.assertEquals(addrTemp.Address_Line_2__c, jhaFormController.addr.Address_Line_2__c);
    	System.assertEquals(addrTemp.City__c, jhaFormController.addr.City__c);
    	System.assertEquals(addrTemp.Postal_Code__c, jhaFormController.addr.Postal_Code__c);
    	System.assertEquals(addrTemp.Country__c, jhaFormController.addr.Country__c);
    	System.assertEquals(addrTemp.State_Province__c, jhaFormController.addr.State_Province__c);
    	System.assertEquals(acctTemp.Id, jhaFormController.jhaForm.Customer_Name__c);
    	
    	String expectedURL = URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/JHA_Form?addrId=' + jhaFormController.jhaForm.Jobsite_Address__c + '&msg=This jobsite has no existing forms!' + '&epriseLoginId=' + jhaFormController.epriseLoginId + '&email=' + jhaFormController.email + '&firstName=' + jhaFormController.firstName + '&lastName=' + jhaFormController.lastName;
    	System.assertEquals(expectedURL, jhaFormController.formURLName);
    	
    	// Here we are testing individual parts since the order in the returned url varies.
    	// Also need to replace some of the character sequences (hex values) with the character they represent since they are added in the url that is returned.
    	String actualUrl = pageRef.getUrl().replace('%3A', ':').replace('%2F', '/').replace('%40', '@').replace('%21', '!').replace('+', ' ');
        System.assert(actualUrl.contains(URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/JHA_Form?'));
        System.assert(actualUrl.contains('addrId=' + jhaFormController.jhaForm.Jobsite_Address__c));
        System.assert(actualUrl.contains('msg=This jobsite has no existing forms!'));
    	System.assert(actualUrl.contains('epriseLoginId=' + jhaFormController.epriseLoginId));
    	System.assert(actualUrl.contains('email=' + jhaFormController.email));
    	System.assert(actualUrl.contains('firstName=' + jhaFormController.firstName));
    	System.assert(actualUrl.contains('lastName=' + jhaFormController.lastName));
    	
    	// Test scenario where address doesn't exist in the database for the customer account id
    	Account acctTemp2 = null;
    	acctTemp2 = new Account();
        acctTemp2.Name = 'Test Account Name2';
        acctTemp2.Physical_Address__c = null;
        insert acctTemp2;
        jhaFormController.jhaForm.Customer_Name__c = acctTemp2.Id;
        jhaFormController.jhaForm.Jobsite_Address__c = null;
        pageRef = jhaFormController.retrieveAccountAndAddressFields();
        System.assertEquals(null, pageRef);
        
        // Test scenario where there is an existing form for this jobsite address, so the most recent one is returned
        JHA_Form__c jhaFormTemp = null;
        jhaFormTemp = new JHA_Form__c();
        jhaFormTemp.Jobsite_Address__c = addrTemp.Id;
        jhaFormTemp.Customer_Name__c = null;
        jhaFormTemp.Facility_Type__c = 'Other';
        jhaFormTemp.Date__c = System.today();
        jhaFormTemp.Employee__c = UserInfo.getUserName();
        jhaFormTemp.Evaluation_Type__c = 'First Time Evaluation';
        jhaFormTemp.Special_Comments__c = null;
        jhaFormTemp.Login_Contact__c = null;
        insert jhaFormTemp;
        jhaFormController.loadExistingForm = false;
    	jhaFormController.forceDotComSite = true;
    	jhaFormController.jhaForm.Customer_Name__c = null;
    	jhaFormController.jhaForm.Jobsite_Address__c = addrTemp.Id;
    	pageRef = jhaFormController.retrieveAccountAndAddressFields();
    	expectedURL = URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/JHA_Form?id=' + jhaFormTemp.Id + '&msg=This jobsite has an existing form!' + '&epriseLoginId=' + jhaFormController.epriseLoginId + '&email=' + jhaFormController.email + '&firstName=' + jhaFormController.firstName + '&lastName=' + jhaFormController.lastName;
    	System.assertEquals(expectedURL, jhaFormController.formURLName);
    	
    	actualUrl = pageRef.getUrl().replace('%3A', ':').replace('%2F', '/').replace('%40', '@').replace('%21', '!').replace('+', ' ');
        System.assert(actualUrl.contains(URL.getSalesforceBaseUrl().toExternalForm() + '/LaunchForm/JHA_Form?'));
        System.assert(actualUrl.contains('id=' + jhaFormTemp.Id));
        System.assert(actualUrl.contains('msg=This jobsite has an existing form!'));
    	System.assert(actualUrl.contains('epriseLoginId=' + jhaFormController.epriseLoginId));
    	System.assert(actualUrl.contains('email=' + jhaFormController.email));
    	System.assert(actualUrl.contains('firstName=' + jhaFormController.firstName));
    	System.assert(actualUrl.contains('lastName=' + jhaFormController.lastName));
    }
    
    
}