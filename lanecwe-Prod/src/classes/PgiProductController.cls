/********************************************************************************
Name:  PgiProductController() 
Copyright © 2012  PGI
======================================================
======================================================
Purpose:
-------
This class used to create and edit PGIProduct data 
======================================================
======================================================
History
-------
VERSION  AUTHOR                DATE        DETAIL              FEATURES/CSR/TTP
  1.0 – Capgemini India                                                  7/10/2012        Added 
********************************************************************************/    
public with sharing class PgiProductController {

    public Boolean isSaveNew { get; set; }
    public Boolean isAddon { get; set; }
    public String productId { get; set; }
    public Boolean isService { get; set; }
    public Boolean IsServiceCreate { get; set; }
    public String service { get; set; }
    public String solution { get; set; }
    public Product__c product { get; set; }
    public list<Solution__c> solutionlst { get; set; }
    public list<SelectOption> solutionOption { get; set; }
    public list<PGIServiceDetail> serviceDetaillst { get; set; }
   
    public PgiProductController(ApexPages.StandardController controller) {
        isSaveNew=false;
        isService=false; 
        isAddon=false;
        product=new Product__c();
        serviceDetaillst=new list<PGIServiceDetail>();
        solutionOption=new list<SelectOption>();
        list<Product__c> prolst=new list<Product__c>();
        productId=apexpages.currentPage().getParameters().get('id');
        if(productId!=null){
            prolst=[Select p.Min_Commit__c, p.Non_License_ContractDocumentGroup__c, p.isPGILicense__c,p.Tier__c,p.contract_not_supported_SFDC__c,p.Addon_Feature_Name_External__c,p.MaxMeeting__c,p.Add__c ,p.InstallmentPayment__c,p.SubscriptionTerms__c,p.Subscription_License_Type__c,p.Unit_Of_Measure__c, p.Term_Length__c, p.Target_Price__c, SOTS_Code__c,p.SystemModstamp,p.Quantity__c, p.ProductType__c, p.ProductCode__c, p.OwnerId,  p.Opportunity__c, p.Number_of_License__c, p.Name, p.Minimum_Quantity__c, p.Meet_Authority_Level__c,p.Authority_Level__c, p.Maximum_Quantity__c, p.List_Rate__c, p.LastModifiedDate, p.LastModifiedById, p.Is_active__c, p.IsDeleted, p.Id,p.CurrencyIsoCode, p.CreatedDate, p.CreatedById, p.Cost_Rate__c, p.Cost_Currency__c, p.Cost_Code__c, p.Channels__c, p.Billing_Frequency__c, p.Bid_Price__c, p.Auth_Rate6__c, p.Auth_Rate5__c, p.Auth_Rate4__c, p.Auth_Rate3__c, p.Auth_Rate2__c, p.Auth_Rate1__c ,p.Regions__c, p.Description__c,p.ContractDocumentGroup__c From Product__c p where id=:productId];
            if(prolst.size()>0){
               product=prolst[0];
             
               }
        }
        solutionlst=[select name ,id from Solution__c];
        for(Solution__c s : solutionlst){
            solutionOption.add(new SelectOption(s.id,s.name));
         }
        if(prolst.size()>0&&(prolst[0].ProductType__c=='Add-on'||prolst[0].ProductType__c=='Ancillary')){
            isAddon=true;
            Map<Id,Boolean> sdlst=new Map<Id,Boolean>();
            list<ServiceCategory__c> sclst=[Select s.Service__r.Name, s.Service__c, s.Product__c,s.Default__c From ServiceCategory__c s where s.Product__c=:productId];
            for(ServiceCategory__c sc : sclst){
               sdlst.put(sc.Service__c,sc.Default__c);
             }
            list<Service__c> servicelst=[select id,name from Service__c];
            for(Service__c s : servicelst){
               PGIServiceDetail sd=new PGIServiceDetail(); 
               sd.name=s.name;
               sd.serviceId=s.id;
               if(sdlst.get(s.id)!=null){
                   sd.isDefault=sdlst.get(s.id);
                   sd.isChecked=true;
                }
               serviceDetaillst.add(sd);
            }
        }
       else{
              list<Service__c> servicelst=[select id,name from Service__c];
                for(Service__c s : servicelst) {
                   PGIServiceDetail sd=new PGIServiceDetail(); 
                   sd.name=s.name;
                   sd.serviceId=s.id;
                   serviceDetaillst.add(sd);
                }
           }
        if(prolst.size()>0&&prolst[0].ProductType__c=='Service')
            isService=true;
    }
    
/*******************************************************************
    Purpose:    Save Method for saving and upserting the data      
    Parameters: -
    Returns:    PageReference
    *******************************************************************/
  public PageReference save() {
    try{
       Service__c s=new Service__c();
       list<Service__c> servicelst=new list<Service__c>();
       if(product.ProductType__c=='Service'&&IsServiceCreate==true){
                 servicelst=[select id from  Service__c where name=: product.name];
                if(servicelst.size()==0){
                                    s.name=product.name;
                                    s.Solution__c=solution;
                                    insert s;
                }
                if(apexpages.currentPage().getParameters().get('id')!=null)
                    upsert product;
                else
                    insert product;
                if(servicelst.size()==0){
                    ServiceCategory__c sc=new ServiceCategory__c();
                    sc.Product__c=product.id;
                    sc.Service__c=s.id;
                    sc.Default__c=true;
                    insert sc;
                }
        }
       else if(product.ProductType__c=='Add-on'||product.ProductType__c=='Ancillary'){
                 if(apexpages.currentPage().getParameters().get('id')!=null)
                    upsert product;
                 else
                    insert product; 
                    
                 if(apexpages.currentPage().getParameters().get('id')==null){
                        list<ServiceCategory__c> sclst=new list<ServiceCategory__c>();
                        for(PGIServiceDetail sd:serviceDetaillst){
                         if(sd.isChecked==true){
                             ServiceCategory__c sc=new ServiceCategory__c();
                             sc.Product__c=product.id;
                             sc.Service__c=sd.serviceId;
                             sc.Default__c=sd.isDefault;
                             sclst.add(sc);
                           }
                        }
                       insert sclst;
                }
                else{
                    Id id=apexpages.currentPage().getParameters().get('id'); 
                    Map<id,ServiceCategory__c> scMaplst=new Map<id,ServiceCategory__c>();
                    list<ServiceCategory__c> sclst=new list<ServiceCategory__c>();
                    Set<Id> ServiceCatIdlst=new Set<Id>();
                    sclst=[Select s.Service__c, s.Product__c, s.Default__c From ServiceCategory__c s where s.Product__c=:Id];
                     for(ServiceCategory__c sc:sclst){
                        scMaplst.put(sc.Service__c,sc);
                     }
                     sclst=new list<ServiceCategory__c>();
                     system.debug('#sclst'+scMaplst);
                     system.debug('#serviceDetaillst'+serviceDetaillst);
                        for(PGIServiceDetail sd:serviceDetaillst){
                             if(sd.isChecked==true){
                                    ServiceCatIdlst.add(sd.serviceId);
                                    ServiceCategory__c sc;
                                      if(scMaplst.get(sd.serviceId)!=null)
                                      {
                                         sc=scMaplst.get(sd.serviceId);
                                         sc.Default__c=sd.isDefault;
                                         System.debug('#sc'+sc);
                                      }
                                      else
                                      {
                                        sc=new ServiceCategory__c();
                                        sc.Product__c=product.id;
                                        sc.Service__c=sd.serviceId;
                                        sc.Default__c=sd.isDefault;
                                      }
                                    
                                     sclst.add(sc);
                               }
                        }
                         upsert sclst;
                         sclst=new list<ServiceCategory__c>();
                          for(ServiceCategory__c sc:scMaplst.Values())
                          {
                                if(ServiceCatIdlst.contains(sc.Service__c)==false)
                                {
                                    sclst.add(sc);
                                }
                          }
                         delete sclst;
                } 
            }
            else{
                if(apexpages.currentPage().getParameters().get('id')!=null)
                    upsert product;
                else
                   insert product;
            }
         IsServiceCreate=false;
         PageReference pageRef ;
         if(isSaveNew==true){
             pageRef = new PageReference('/apex/PGIProduct');
             isSaveNew=false;
           }
         else
            pageRef = new PageReference('/'+product.id);
            return pageRef;
        }Catch(Exception ex){
            PGIErrorUtilities.logPgiError('PgiProductController:save()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When redirecting to PGIProduct page '+ex.getMessage());
            ApexPages.addMessages(ex);
            return null;
        }

   }
/*******************************************************************
    Purpose:    SaveNew Method for saving and Redirecting to New page      
    Parameters: -
    Returns:    PageReference
    *******************************************************************/
 public PageReference SaveNew() {
    try
    {
        isSaveNew=true;
        PageReference pageRef=save();
        if(pageRef!=null)
           pageRef.setRedirect(true);
        return pageRef;
    }
        Catch(Exception ex){
            PGIErrorUtilities.logPgiError('PgiProductController:SaveNew()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When redirecting to saveNew page '+ex.getMessage());
        }
        return ApexPages.currentPage();  
    }
 public PageReference cancel() {
    try
    {
        PageReference pageRef;
        if(apexpages.currentPage().getParameters().get('id')!=null)
           pageRef = new PageReference('/'+product.id);
        else{
        String ObjectPrefix = Product__c.sObjectType.getDescribe().getKeyPrefix();
        pageRef  = new PageReference('/'+ObjectPrefix+'/o');
           // pageRef = new PageReference('/a0k/o');
        }
        return pageRef;
    }
     Catch(Exception ex)
     {
            PGIErrorUtilities.logPgiError('PgiProductController:cancel()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When calling to cancel metod '+ex.getMessage());
     }
        return ApexPages.currentPage();   
    }

 public PageReference ProductType() {
    try
    {
        if(product.ProductType__c=='Service'){
           isService=true;
           isAddon=false;
        }
        else if(product.ProductType__c=='Add-on'||product.ProductType__c=='Ancillary'){
               isService=false;
               isAddon=true;
            }
            else{
                isService=false;
                isAddon=false;
            }
    }
    Catch(Exception ex)
     {
            PGIErrorUtilities.logPgiError('PgiProductController:ProductType()',ex.getMessage(),PGIErrorUtilities.LoggingLevel.INFO);
            system.debug(LoggingLevel.ERROR,'Error When calling ProductType method '+ex.getMessage());
 
     }         
     return null;
 }
 /*******************************************************************
    Purpose:    Test Method for PGIProductController     
    Parameters: -
    Returns:    void
    *******************************************************************/
 private static TestMethod void test_PGIProductConstructor(){
        //Calling the constructor of PGIProductController with StandardController as parameter
       Product__c pro=new Product__c();
      // Region__c region=new  Region__c();
       Solution__c sol=new Solution__c();
       //Setting current page as PGIProduct
       PageReference pageRef = Page.PGIProduct;   
       Test.setCurrentPage(pageRef);
       //Test Data
     //  region=PGITestUtilities.getRegionDetails();
      // insert region;
       pro=PGITestUtilities.getProductDetails('Service','test','10111111'); 
       insert pro;
       sol=PGITestUtilities.getSolution();
       insert sol;
       Service__c service=PGITestUtilities.getService(sol.id);
       insert service;
       ServiceCategory__c serviceCat=PGITestUtilities.getSerCategory(service.id,pro.id,false);
       insert serviceCat;
       //setting page params
       //Test_PGIUtilities.setTestParameter('id',pro.id);
        PGITestUtilities.setTestParameter('id',pro.id);
      
       //case1: Id Value With ProductType 'Service'
       PgiProductController pgiProductCon=new PgiProductController(PGITestUtilities.getStandardController(pro));
       //assert
       system.assertEquals(pgiProductCon.product.productType__c,'Service');  
      
       //case2:Id Value With productType 'Add on'
       pro.ProductType__c='Add-on';
       update pro; 
       PgiProductController pgiProductAddonCon=new PgiProductController(PGITestUtilities.getStandardController(pro));
       //assert
       system.assertEquals(pgiProductAddonCon.product.productType__c,'Add-on');  
  }
/*******************************************************************
    Purpose:    Test Method for SavePGIProduct  
    Parameters: -
    Returns:    void
    *******************************************************************/
private static TestMethod void test_savePGIProduct(){
      //Setting current page as PGIProduct
       PageReference pageRef = Page.PGIProduct;   
       Test.setCurrentPage(pageRef);
       //Test Data
       //Region__c region=PGITestUtilities.getRegionDetails();
       //insert region;
       Product__c pro=PGITestUtilities.getProductDetails('Service','test','10111111'); 
       insert pro;
        Solution__c sol=PGITestUtilities.getSolution();
       insert sol;
       Service__c service=PGITestUtilities.getService(sol.id);
       insert service;
       ServiceCategory__c serviceCat=PGITestUtilities.getSerCategory(service.id,pro.id,false);
       insert serviceCat;
       //setting page params
           PGITestUtilities.setTestParameter('id',pro.id);
           
           //case1:Id Value with ProductType:Service and isServiceCreate:false
           PgiProductController pgiProductcon=new PgiProductController(PGITestUtilities.getStandardController(pro));
           pgiProductcon.isServiceCreate=false;
           pgiProductcon.save();
           //assert
           system.assertEquals(pro.id,pgiProductcon.product.id);
           system.assertEquals(pgiProductcon.product.ProductType__c,'Service');
         
          //case2:Id Value with ProductType:Service and isServiceCreate:true;
           pgiProductcon=new PgiProductController(PGITestUtilities.getStandardController(pro));
           pgiProductcon.IsServiceCreate=true;
           pgiProductcon.save();
           //assert
           system.assertEquals(pro.id,pgiProductcon.product.id);
           system.assertEquals(pgiProductcon.product.productType__c,'Service');
        
           //case3:Id Value with ProductType:Addon and isServiceCreate:false
           pro.ProductType__c='Add-on';
           update pro;
           PGITestUtilities.setTestParameter('id',pro.id);
           pgiProductcon=new PgiProductController(PGITestUtilities.getStandardController(pro));
           pgiProductcon.save();
           //assert
           system.assertEquals(pro.id,pgiProductcon.product.id);
           system.assertEquals(pgiProductcon.product.productType__c,'Add-on');
           
            //case4:Id:null value with ProductType:Service and isServiceCreate:true;
           pro.ProductType__c='Service';
           update pro;
           pgiProductcon=new PgiProductController(PGITestUtilities.getStandardController(pro));
           PGITestUtilities.setTestParameter('id',null);
           pgiProductcon.IsServiceCreate=true;
           pgiProductcon.product=PGITestUtilities.getProductDetails('Service','test','10111111');
           pgiProductcon.save();
           //assert
           system.assertNotEquals(pro.id,pgiProductcon.product.id);  
           system.assertEquals(pgiProductcon.product.productType__c,'Service'); 
           
           //case5:Id:null value with ProductType:Add-on and isServiceCreate:false;
           pro.ProductType__c='Add-on';
           update pro;
           pgiProductcon=new PgiProductController(PGITestUtilities.getStandardController(pro));
           PGITestUtilities.setTestParameter('id',null);
           pgiProductcon.IsServiceCreate=false;
           pgiProductcon.product=PGITestUtilities.getProductDetails('Add-on','test','30111111');
           pgiProductcon.save();
           //assert
           system.assertNotEquals(pro.id,pgiProductcon.product.id);
           system.assertEquals(pgiProductcon.product.productType__c,'Add-on'); 
}

private static TestMethod void test_savenewPGIProduct(){
           //Region__c region=PGITestUtilities.getRegionDetails();
      // insert region;
           Product__c pro=PGITestUtilities.getProductDetails('Service','test','10111111'); 
           PgiProductController pgiProductcon=new PgiProductController(PGITestUtilities.getStandardController(pro));
           //case1:Positive Test;
           pgiProductcon.product=PGITestUtilities.getProductDetails('Service', 'test','10111111');
           PageReference pageRef=pgiProductcon.savenew();
           system.assertnotEquals(pageRef,null);  
           //case2:Negative Test;
           pgiProductcon.product=null;
           pageRef=pgiProductcon.savenew();
           system.assertEquals(pageRef,null);
              
}

private static TestMethod void test_CancelPGIProduct(){
           //Test Data
      // Region__c region=PGITestUtilities.getRegionDetails();
      // insert region;
       Product__c pro=PGITestUtilities.getProductDetails('Service', 'test','10111111');
       insert pro;
       PgiProductController pgiProductcon=new PgiProductController(PGITestUtilities.getStandardController(pro));
       pgiProductcon.product=pro;
       //case1:id with null value
       PGITestUtilities.setTestParameter('id',null); 
       PageReference pageRef=pgiProductcon.Cancel();
       //system.assert(pageRef.getUrl().contains('/a0k/o')); 
       //case2:id with Value
       PGITestUtilities.setTestParameter('id',pro.id); 
       pageRef=pgiProductcon.Cancel();
       system.assert(pageRef.getUrl().contains('/'+pro.id));
 }
 
private static TestMethod void test_ProductType(){
         Product__c pro=new Product__c();
     PgiProductController pgiProductcon=new PgiProductController(PGITestUtilities.getStandardController(pro));
     //case1:ProductType__c:Service 
     pgiProductcon.product.productType__c='Service';
     pgiProductcon.ProductType();
     system.assertEquals(pgiProductcon.isService,true);
     system.assertEquals(pgiProductcon.isAddon,false);
     //case2:ProductType__c:Add-on
     pgiProductcon.product.productType__c='Add-on';
     pgiProductcon.ProductType();
     system.assertEquals(pgiProductcon.isService,false);
     system.assertEquals(pgiProductcon.isAddon,true);
     //case3:ProductType__c:None
     pgiProductcon.product.productType__c='None';
     pgiProductcon.ProductType();
     system.assertEquals(pgiProductcon.isService,false);
     system.assertEquals(pgiProductcon.isAddon,false);
}

}