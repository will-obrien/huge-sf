public with sharing class PiggybackTriggerManager {


    public PiggybackTriggerManager()    {    }
    

    public static boolean PBOppFromAccountCheck = false;


    public Map<String, List<Opportunity>> GetDistinctProductsForAccount(Account objAccount)
    {
        Map<String, List<Opportunity>> retMap = new Map<String, List<Opportunity>>();
        List<Opportunity> listCurrOps = new List<Opportunity>();
        if (objAccount.Opportunities != null) {

            listCurrOps = objAccount.Opportunities;
            map<String, String> tempMap = new map<String, String> ();
            
            for(Opportunity currOp: listCurrOps) {
                if (tempMap.get(currOp.Product__c) == null ) {
                    tempMap.put(currOp.Product__c, currOp.Product__c);
                }
            }
            
            for(String currProd: tempMap.keySet()) {
                List<Opportunity> listTempOps = new List<Opportunity>();
                
                for(Opportunity currOp: listCurrOps) {
                    if (currOp.Product__c == currProd) {
                        listTempOps.add(currOp);    
                    }
                }
                retMap.put(currProd,listTempOps );
            }
        }
        return retMap;
    }


/*
    public SObject SetNullFieldsForAccount(SObject accObj, String productName)
    {    

      Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap();
      for(Schema.SObjectField sfield : fieldMap.Values()){

            schema.describefieldresult dfield =   sfield.getDescribe();
            string fname = dfield.getname();      

            if(   
                fname == ('pb_Client_' + productName + '__c')  || 
                fname == ('pb_CloseDate_' + productName + '__c') ||
                fname == ('pb_Close_Owner_' + productName + '__c') ||
                fname == ('pb_Amount_' + productName + '__c') || 
                fname == ('pb_Stage_' + productName + '__c')  || 
                fname == ('pb_SubStage_' + productName + '__c') || 
                fname == ('pb_RecordType_' + productName + '__c')  || 
                fname == ('pb_CreateDate_' + productName + '__c') ||
                fname == ('pb_SubBegin_' + productName + '__c')  || 
                fname == ('pb_SubEnd_' + productName + '__c') ||
                fname == ('pb_PrevSubEnd_' + productName + '__c') ||
                fname == ('pb_Package_' + productName + '__c') ||
                fname == ('pb_ChargeType_' + productName + '__c')
            )
            {
                if (dfield.isUpdateable())
                    if (fname == ('pb_Client_' + productName + '__c') )
                        accObj.put(fname, false);
                    else
                    {
                        accObj.put(fname, null);
                    }
            }
        }
        return accObj;
    }
*/  


 
    
}