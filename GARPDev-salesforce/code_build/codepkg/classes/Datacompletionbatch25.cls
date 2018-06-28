global class Datacompletionbatch25 implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Shipping_E_mail__c,Shipping_Phone_No__c,ChargentSFA__Billing_Phone__c,ChargentSFA__Billing_Email__c,accountId from opportunity');
    }
    
    
    global void execute(Database.BatchableContext BC, List<opportunity> scope){
       
       List<Opportunity> lstOpps = new List<Opportunity>();
       Set<Id> setAccs = new Set<Id>();
       boolean bAdd = false;
       for(Opportunity opp : scope)
       {
                  if(opp.Shipping_Phone_No__c != null && opp.Shipping_Phone_No__c.startsWith('"'))
                    {
                      string strShippingPhone = opp.Shipping_Phone_No__c;
                      strShippingPhone = strShippingPhone.replace('"','');
                      opp.Shipping_Phone_No__c = strShippingPhone;
                      bAdd = true;

                    }
                    if(opp.ChargentSFA__Billing_Phone__c != null && opp.ChargentSFA__Billing_Phone__c.startsWith('"'))
                    {
                        string strBillingPhone = opp.ChargentSFA__Billing_Phone__c;
                        strBillingPhone = strBillingPhone.replace('"','');
                        opp.ChargentSFA__Billing_Phone__c = strBillingPhone;
                        bAdd = true;

                    }

                    if(bAdd)
                        lstOpps.add(opp);
       }

       if(! lstOpps.isEmpty())
          update lstOpps;

    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}