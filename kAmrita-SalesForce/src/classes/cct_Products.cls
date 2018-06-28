public class cct_Products extends fflib_SObjectDomain implements cct_iProducts{
		
			public static cct_iProducts newInstance(List<Product__c> sObjectList)
				{
					return (cct_iProducts) cct_Application.Domain.newInstance(sObjectList);
				}

			public cct_Products(List<Product__c> sObjectList)
				{
					super(sObjectList);
				}
			
			
			public void setProducts(fflib_ISObjectUnitOfWork uow,String name,String sellingDetails){
				Product__c prod1 = new Product__c();
				prod1.Name = name;
				prod1.SellingCriterion__c = sellingDetails;
				
				uow.registerNew(prod1);
			}
			public class Constructor implements fflib_SObjectDomain.IConstructable
				{
					public fflib_SObjectDomain construct(List<SObject> sObjectList)
					{
						return new cct_Products(sObjectList);
					}
				}
}