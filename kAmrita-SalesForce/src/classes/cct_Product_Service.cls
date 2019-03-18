global with sharing class cct_Product_Service implements cct_iProduct_Service{
		global static void setProduct(String userName,String name, String sellDetails){
			service().setProduct(userName, name, sellDetails);
		}
		
		
		
		private static cct_iProduct_Service service()
			{
				return (cct_iProduct_Service) cct_Application.Service.newInstance(cct_iProduct_Service.class);
			}
}