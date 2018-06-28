public class Product_Wrapper {

 public Product__c pr {get; private set;}
 public Integer ident {get; private set;}
   
 public Product_Wrapper(Integer inIdent)
 {
  ident=inIdent;
  pr=new Product__c(Name='New Product ' + ident);
 }
}