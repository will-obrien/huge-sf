public class ProductUpdater{



  Zuora.zApi zApiInstance = new Zuora.zApi();
  public String searchWord{ get; set; }
  public void updateProduct() {
      try {
          List<Zuora.zObject> objs = new List<Zuora.zObject>();
          for (MyProduct p : MyProducts) {
            if (p.updateFlag==true) {
                Zuora.zObject prod = new Zuora.zObject('Product');
                prod.setValue('Id',p.id); 
                prod.setValue('Description',p.description);
                objs.add(prod);
            }
          }
          if (!objs.isEmpty()) {
            List<Zuora.zApi.SaveResult> results = zApiInstance.zupdate(objs);
          }
          searchProduct();
      } catch (Zuora.zRemoteException ex) {
          if ('INVALID_FIELD' == ex.code) {
             // An invalid field was specified
             //more code here...
          } else {
             //more code here...
          }
        } catch (Zuora.zAPIException ex) {
           ex.getMessage();
           //more code here...
        } catch (Zuora.zForceException ex) {
           //more code here...
        }
      
  }

  public List<MyProduct> myProducts {
      get { return myProducts; }
      set { myProducts = value; }
  }

  
  public ProductUpdater(ApexPages.StandardController controller){

      zApiInstance.setEndpoint('https://apisandbox-zforsf.zuora.com/apps/services/a/60.0');
      zApiInstance.zlogin('xucong.chen@zuora.com', 'Cxc198201241');      
      zApiInstance.zlogin();
      searchProduct();
    
  }
  
  public void searchProduct(){
      try {
        myProducts = new List<MyProduct>();
        String zoql = 'SELECT Id, Name, Description from Product';

        if (searchWord!=null){
          zoql += ' where name = \''+searchWord+'\'';
          System.debug('after '+zoql);
        }
        
        String searchWordLike = '%'+ searchWord + '%';
        List<Zuora.zObject> zobjs = zApiInstance.zquery(zoql);
        
        for (Zuora.zObject o : zobjs) {
            myProduct myProduct = new MyProduct();
            myProduct.id = (String)o.getValue('Id');
            myProduct.name = (String)o.getValue('Name');
            myProduct.description = (String)o.getValue('Description');
            myProduct.updateFlag = false;
            myProducts.add(myProduct);
            
            //more code here...
        }
        } catch (Zuora.zRemoteException ex) {
        if ('INVALID_FIELD' == ex.code) {
            // An invalid field was specified
            //more code here...
            } else {
            //more code here...
        }
        } catch (Zuora.zAPIException ex) {
        ex.getMessage();
        //more code here...
        } catch (Zuora.zForceException ex) {
        //more code here...
    }
  }
}