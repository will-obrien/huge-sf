/* 
    Class : APTPS_DaikinPricingCallback
    Description : This class will contain pricing utilities which calculate line item pricing fields accordingly.
                Class must be included in Config Custom Class setting record as Call back class.
    Author : Parth Sevak , @Apttus            
*/
global with sharing class APTPS_DaikinPricingCallback implements Apttus_Config2.CustomClass.IPricingCallback3{
    
    private Apttus_Config2.ProductConfiguration cart = null;
    private Apttus_Config2.CustomClass.PricingMode mode = null;
    
    global void start(Apttus_Config2.ProductConfiguration cart) {        
        this.cart = cart;
    }
  
    global void setMode(Apttus_Config2.CustomClass.PricingMode mode) {
        this.mode = mode;
    }
    //Apttus_Config2.CustomClass.PricingMode.BASEPRICE == mode)
    /*
        Callback before pricing the line item collection
        Use this method to do all required pre-processing to prepare the line items for pricing.
        @param itemColl the line item collection to pre-process
    */
    global void beforePricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        if(Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT != mode && !test.isRunningTest()) {
                return;
        }
        for(Apttus_Config2.LineItem lineItem : itemColl.getAllLineItems()) {
            
            Apttus_Config2__LineItem__c item = lineItem.getLineItemSO();
            Boolean isPriceAdjusted = false;
            if(!String.isBlank(item.Apttus_Config2__AdjustmentType__c) && item.Apttus_Config2__AdjustmentAmount__c != null) {
                isPriceAdjusted = true;
            }
            //if(isPriceAdjusted == true) { continue; }
            //for labor product cost = base price
            if(!String.isBlank(item.APTPS_Product_Name__c) && 
                item.APTPS_Product_Name__c.equalsIgnoreCase('Service Technician')) {
                //item.APTPS_Product_Name__c.equalsIgnoreCase('Service Supervisor'))) : deprecated
                 if(item.Apttus_Config2__BasePrice__c != null && item.Apttus_Config2__BasePrice__c > 0)
                     item.APTPS_Cost__c = item.Apttus_Config2__BasePrice__c;
                 if(item.APTPS_Final_Cost__c == null)
                     item.APTPS_Final_Cost__c = item.APTPS_Cost__c;
            } //for Personnel Vehicle Mileage/Mile Product
            else if(item.Apttus_Config2__Quantity__c != null && !String.isBlank(item.APTPS_Product_Name__c) && item.APTPS_Product_Name__c.equalsIgnoreCase('Personnel Vehicle Mileage/Mile')) {
                item.APTPS_Cost__c = item.Apttus_Config2__Quantity__c * Decimal.valueOf(label.APTPS_VehicleProductNumberOfMilesConstant);
                if(item.APTPS_Final_Cost__c == null)
                    item.APTPS_Final_Cost__c = item.APTPS_Cost__c;
            }
            //Avoid custom validation callback, instead override correct cost
            if(item.APTPS_Final_Cost__c != null && item.APTPS_Final_Cost__c > 0) {
                item.APTPS_Cost__c = item.APTPS_Final_Cost__c;
            }
            if(item.APTPS_Cost__c != null && item.APTPS_Cost__c > 0) {
                item.Apttus_Config2__BaseExtendedCost__c = item.APTPS_Cost__c * item.Apttus_Config2__Quantity__c;
            }    
                   
            //if user has changed Margin% or Selling Price 
            //avoid NPE
            if(item.Apttus_Config2__BaseExtendedCost__c != null && item.Apttus_Config2__BaseExtendedCost__c > 0 
                && (item.APTPS_Margin_Percentage__c != null || item.APTPS_Selling_Price__c != null)) {
                if(item.APTPS_Margin_Percentage__c != null //&& item.APTPS_Margin_Percentage__c != 0.00 &&
                  && item.APTPS_Margin_Percentage__c != item.APTPS_Margin_Percentage_Previous__c) {
                    //item.APTPS_Selling_Price__c = item.Apttus_Config2__BaseExtendedCost__c * (1 + item.APTPS_Margin_Percentage__c/100);
                    if(item.APTPS_Margin_Percentage__c != 100) {
                        item.APTPS_Selling_Price__c = item.Apttus_Config2__BaseExtendedCost__c/(1 - (item.APTPS_Margin_Percentage__c/100));
                    } else {
                        item.APTPS_Selling_Price__c = item.Apttus_Config2__BaseExtendedCost__c;
                    }
                    
                } else {
                  if(item.Apttus_Config2__BaseExtendedCost__c != null && item.Apttus_Config2__BaseExtendedCost__c > 0 
                    && item.APTPS_Selling_Price__c  != null && item.APTPS_Selling_Price__c != 0.00)
                    System.debug('*** item.APTPS_Selling_Price__c ' + item.APTPS_Selling_Price__c);
                    System.debug('*** item.APTPS_Selling_Price_Previous__c ' + item.APTPS_Selling_Price_Previous__c);
                    if(item.APTPS_Selling_Price_Previous__c != item.APTPS_Selling_Price__c) {
                        item.APTPS_Margin_Percentage__c = 
                            ((item.APTPS_Selling_Price__c - item.Apttus_Config2__BaseExtendedCost__c)/item.APTPS_Selling_Price__c)*100; 
                    } else {
                        if(item.APTPS_Margin_Percentage__c != null && item.APTPS_Margin_Percentage__c != 100) {
                            item.APTPS_Selling_Price__c = item.Apttus_Config2__BaseExtendedCost__c/(1 - (item.APTPS_Margin_Percentage__c/100));
                        } else {
                            item.APTPS_Selling_Price__c = item.Apttus_Config2__BaseExtendedCost__c;
                        }
                    }
                }
                if(isPriceAdjusted == false) { 
                    if(item.Apttus_Config2__BaseExtendedCost__c != null && item.Apttus_Config2__BaseExtendedCost__c > 0) {
                      item.APTPS_Margin_Dollar__c  = item.APTPS_Selling_Price__c - item.Apttus_Config2__BaseExtendedCost__c;
                        //for net price calculation
                        if(item.APTPS_Selling_Price__c != null && item.APTPS_Selling_Price__c != 0.00 && item.Apttus_Config2__Quantity__c != null) {
                            item.Apttus_Config2__BasePrice__c = item.APTPS_Selling_Price__c; /// item.Apttus_Config2__Quantity__c; 
                            if(item.APTPS_Final_Base_Price__c == null) item.APTPS_Final_Base_Price__c = item.Apttus_Config2__BasePrice__c;
                        }
                    }
                } else if(isPriceAdjusted == true) {
                    item.Apttus_Config2__BasePrice__c = item.APTPS_Final_Base_Price__c; 
                }
            } 
            if(item.APTPS_Selling_Price__c == null || item.APTPS_Selling_Price__c == 0.00) {
                item.APTPS_Selling_Price__c = item.Apttus_Config2__BaseExtendedCost__c;
                item.APTPS_Margin_Percentage__c = 0;
                item.APTPS_Margin_Dollar__c = 0;
            }
            item.Apttus_Config2__ExtendedPrice__c = item.APTPS_Selling_Price__c; 
            item.Apttus_Config2__BaseExtendedPrice__c = item.Apttus_Config2__ExtendedPrice__c;
            
        } 
        if(test.isRunningTest()) {
            rollUpNetPriceOnBundle(itemColl);
        }     
                
    }
    
    
    
    /*
        Callback after pricing the line item collection
        Use this method to do all required post-processing after line items are priced.
        @param itemColl the line item collection to post-process
    */
    global void afterPricing(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        
        for(Apttus_Config2.LineItem lineItem : itemColl.getAllLineItems()) {
            
            Apttus_Config2__LineItem__c item = lineItem.getLineItemSO();  
            if(item.APTPS_Product_Name__c == 'Equipment & Tasking') {                  
                lineItem.updatePrice(); 
            }
        
            //item.Apttus_Config2__ExtendedPrice__c = item.Apttus_Config2__BasePrice__c * item.Apttus_Config2__Quantity__c;
            
        }    
        
        rollUpNetPriceOnBundle(itemColl);
        
            
    }
    
    /*
        Method : rollUpNetPriceOnBundle, parameter 
        Description : it updated option price, net price on bundle
    */
    public void rollUpNetPriceOnBundle(Apttus_Config2.ProductConfiguration.LineItemColl itemColl) {
        //For "Equipment & Tasking", conisder option price as well
        List<APTPS_Bundle_Products_With_Option_Price__c> bundleCSList = APTPS_Bundle_Products_With_Option_Price__c.getall().values(); 
        List<Apttus_Config2__LineItem__c> listBundleLineItem = new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> listOptionLineItem = new List<Apttus_Config2__LineItem__c>();
        Map<Id, Apttus_Config2__LineItem__c> mapOptionLineItem = new Map<Id, Apttus_Config2__LineItem__c>();
        
        Map<Id, Apttus_Config2.LineItem> mapIdToconfigLineItem = new Map<Id, Apttus_Config2.LineItem>();
        
        for(Apttus_Config2.LineItem lineItem : itemColl.getAllLineItems()) {
            Apttus_Config2__LineItem__c item = lineItem.getLineItemSO();
            Decimal optionPriceSum = 0.0;
            
            if(item != null) {
                if(item.Apttus_Config2__LineType__c == 'Option') {
                    listOptionLineItem.add(item);
                    mapOptionLineItem.put(item.Apttus_Config2__ProductId__c, item); 
                } else if(item.Apttus_Config2__LineType__c == 'Product/Service') {
                    listBundleLineItem.add(item);
                }
                mapIdToconfigLineItem.put(item.Id, lineItem);
            }
        }
                
        if(listBundleLineItem != null && !listBundleLineItem.isEmpty()) {
            
            for(Apttus_Config2__LineItem__c bItem : listBundleLineItem) {
                Boolean calculateOptionPrice = false;
                if(bundleCSList != null && !bundleCSList.isEmpty()) {
                    for(APTPS_Bundle_Products_With_Option_Price__c bundleCS : bundleCSList) {
                        if(bundleCS != null && bundleCS.Name == bItem.APTPS_Product_Name__c) {
                            bItem.Apttus_Config2__OptionPrice__c = 0.0;
                            bItem.Apttus_Config2__NetPrice__c = 0.0;
                            calculateOptionPrice = true;
                        }
                    }
                }
                if(calculateOptionPrice == true) {
                    for(Apttus_Config2__LineItem__c oItem : listOptionLineItem) {
                        if(oItem.Apttus_Config2__ProductId__c == bItem.Apttus_Config2__ProductId__c &&
                            oItem.Apttus_Config2__LineNumber__c == bItem.Apttus_Config2__LineNumber__c) {
                            if(oItem.Apttus_Config2__PrimaryLineNumber__c > bItem.Apttus_Config2__PrimaryLineNumber__c) {
                                bItem.Apttus_Config2__OptionPrice__c = bItem.Apttus_Config2__OptionPrice__c + oItem.Apttus_Config2__AdjustedPrice__c;
                                bItem.Apttus_Config2__NetPrice__c = bItem.Apttus_Config2__NetPrice__c + oItem.Apttus_Config2__NetPrice__c;
                                Apttus_Config2.LineItem lItemConfig = mapIdToconfigLineItem.get(bItem.Id);
                                lItemConfig.updatePrice(); //to update net price
                            }
                        }
                    
                    }
                }
                
                
            } 
            
        }
    }
    
  
  /**
   * Callback after line items
   */
    global void afterPricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemcoll, Apttus_Config2.LineItem li){
            
    }
  
  /**
   * Callback before line items
   */
    global void beforePricingLineItem(Apttus_Config2.ProductConfiguration.LineItemColl itemcoll, Apttus_Config2.LineItem lineItemMO){
             
    }
    

    /**
   * Callback after all batches of line items are processed
   */
    global void finish() {
        List<Apttus_Config2.LineItem> listLineitem  = cart.getLineItems();
        if(listLineitem .isEmpty()) return;
        for (Apttus_Config2.LineItem lineItem : listLineitem) {
            Apttus_Config2__LineItem__c item = lineItem.getLineItemSO();
            if(item != null) {
                if(item.APTPS_Margin_Percentage__c != null && item.APTPS_Margin_Percentage__c > 0){
                    item.APTPS_Margin_Percentage__c = item.APTPS_Margin_Percentage__c.setScale(2);
                }
                item.APTPS_Selling_Price_Previous__c = item.APTPS_Selling_Price__c;
                item.APTPS_Margin_Percentage_Previous__c = item.APTPS_Margin_Percentage__c;
                /*
                if(item.APTPS_Cost__c == null || item.APTPS_Cost__C == 0.0) continue;
                if(item.Apttus_Config2__NetPrice__c != null  && item.Apttus_Config2__NetPrice__c > 0 && item.Apttus_Config2__AdjustedPrice__c != null && !String.isBlank(item.Apttus_Config2__AdjustmentType__c)) {
                    try {
                        item.APTPS_Margin_Percentage__c = 
                          ((item.Apttus_Config2__NetPrice__c - item.Apttus_Config2__BaseExtendedCost__c)/item.Apttus_Config2__NetPrice__c)*100;
                          //((item.Apttus_Config2__NetPrice__c - item.Apttus_Config2__BaseExtendedCost__c)/item.Apttus_Config2__BaseExtendedCost__c)*100;
                        item.APTPS_Margin_Percentage__c = item.APTPS_Margin_Percentage__c.setScale(2);
                        item.APTPS_Margin_Dollar__c  = item.Apttus_Config2__NetPrice__c - item.Apttus_Config2__BaseExtendedCost__c;                 
                    } catch(Exception e) {
                        System.debug('*** Exception in finish - ' + e.getMessage());
                    }
                }
                */
            }    
        }
        
        
    }     

   global void onPriceItemSet(Apttus_Config2__PriceListItem__c itemSO, Apttus_Config2.LineItem lineItemMO){
   }       
      
}