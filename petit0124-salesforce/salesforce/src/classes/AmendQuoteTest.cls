public class AmendQuoteTest{
  public void amendTest(){
    Zuora.zApi zuoraApi = new Zuora.zApi(); 

    zuoraApi.setEndpoint('https://apisandbox.zuora.com/apps/services/a/55.0');
    zuoraApi.zlogin('xucong.chen@zuora.com', 'Cxc19820124');

    Zuora.zObject[] objectsToCreateList = new List<Zuora.zObject>(); 
    
    Zuora.zObject amendment1; 
    Integer i = 0; 
    for(i=0; i<2; i++){ 
    
        amendment1 = new Zuora.zObject('Amendment');
        
        if (i==0){
            amendment1.setValue('SubscriptionId', '2c92c0f946d184c30146d215497b7c14');
        }else{
            amendment1.setValue('SubscriptionId', '2c92c0f946d184c30146dd6231960bd6');
        }
        
        amendment1.setValue('Type', 'NewProduct');
        
        amendment1.setValue('Name', 'testAdd'); 
        amendment1.setValue('Description', 'amendmentDescription');
        
        
        Datetime rightNowDateTime = DateTime.now(); 
        String currentTimeZuoreFormat = rightNowDateTime.format('yyyy-MM-dd') + 'T' +rightNowDateTime.format('HH:mm:ss.SSS') + rightNowDateTime.format('Z').substring(0,3) +':' + rightNowDateTime.format('Z').substring(3,5);
        System.debug(currentTimeZuoreFormat);
        amendment1.setValue('ContractEffectiveDate', currentTimeZuoreFormat); 
        amendment1.setValue('EffectiveDate', currentTimeZuoreFormat); 
        amendment1.setValue('Status', 'Completed');
        
        //Create RatePlanCharge 
        Zuora.zObject ratePlanCharge = new Zuora.zObject('RatePlanCharge'); 
        ratePlanCharge.setValue('ProductRatePlanChargeId','2c92c0f946d184c30146dd61b21709ee'); 
        ratePlanCharge.setValue('Quantity',1); 
        
        //Create RatePlanChargeData and attach RatePlanCharge 
        Zuora.zObject ratePlanChargeData = new Zuora.zObject('RatePlanChargeData'); 
        ratePlanChargeData.setValue('RatePlanCharge', ratePlanCharge);
        
        //Create RatePlan and assign the ProductRatePlanId 
        Zuora.zObject ratePlan = new Zuora.zObject('RatePlan'); 
        ratePlan.setValue('ProductRatePlanId', '2c92c0f946d184c30146dd5ff22904dc');
        
        //Create RatePlanData and load RatePlan + RatePlanChargeData 
        Zuora.zObject ratePlanData = new Zuora.zObject('RatePlanData'); 
        ratePlanData.setValue('RatePlan', ratePlan); 
        ratePlanData.setValue('RatePlanChargeData', new List < Zuora.zObject > {ratePlanChargeData});
        
        amendment1.setValue('RatePlanData', ratePlanData);
        
        objectsToCreateList.add(amendment1); 
    } 
    List<Zuora.zApi.SaveResult> saveResultList = null; 
    try{
        saveResultList = zuoraApi.zcreate(objectsToCreateList,true);
        System.debug('zapi logger ' + Zuora.zApi.currentLogger.toString());
    }catch (Exception e){
        System.debug('zapi logger ' + Zuora.zApi.currentLogger.toString());
    }
    if(saveResultList == null || saveResultList.isEmpty()){
      return;
    }
    if(saveResultList[0].success) 
    { 
        system.debug('@@ Creation successful'); 
        system.debug('@@ Creation successful :'+saveResultList ); 
    } 
    else 
    { 
        system.debug('@@ Success = false:'); 
        // Print errors 
        Zuora.zObject[] errors = saveResultList[0].errors;
        
        for (Zuora.zObject error : errors) { 
        String errorCode = (String)error.getValue('Code'); 
        String message = (String)error.getValue('Message'); 
        system.debug('@@ error :' + errorCode + '____' + message); 
    } 
    }
  }

}