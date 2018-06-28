global with sharing class cct_Product_ServiceImpl implements cct_iProduct_Service{
	
	global static void setProduct(String userName,String productName, String sellDetails){
		fflib_ISObjectUnitOfWork uow = cct_Application.UnitOfWork.newInstance();
		
		/*cct_iProducts product = 
		(cct_iProducts)cct_Application.Domain.newInstance(
								cct_Product_Selector.newInstance().selectByName(productName) );
								
		product.setProducts(uow,productName,sellDetails);*/
		Product__c prod = new Product__c();
		prod.Name = productName;
		prod.ScoreCard__c = '';
		prod.Product_Instance__c = userName;
		prod.SellingCriterion__c = sellDetails;
		uow.registerNew(prod);
		uow.commitWork();
	}
}