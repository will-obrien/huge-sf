global class Product{
    
        global class ProductDetail{
            webservice String productName;
            webservice String criterionForSelling;
            webservice String userName;
        }
        
        webservice static ProductDetail getDetails(ProductDetail productDetail){
           
           
          
            cct_Product_Service.setProduct(productDetail.userName,productDetail.productName,productDetail.criterionForSelling);
            
            
            
            
            return productDetail;
        }
}