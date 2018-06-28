@isTest(seeAllData=true)		//annotation to grant test classes and individual test methods access to all data in the organization, including pre-existing data that the test didn’t create.
public class TestProductTriggerHandler {		
	static testMethod void myUnitTest() {
        List<Product2> productSample = [SELECT Id,Name From Product2 LIMIT 1];			//SOQL query to pull only one product and assign it to List variable called productSample
        for(Product2 product: productSample){											//Iterating through the records in the list --> Ofcourse only one record in available in the list atanytime.
            product.name = 'new name update test';										//Setting the product name to 'new name Update test'
            update product;																//updating the product name
        }
        
    }
}