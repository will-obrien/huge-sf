/*
@author:raip
*/
trigger AccountAddressTrigger on Account (before insert, before update) {

    if (Trigger.IsInsert) {
    for (Account a : Trigger.New){
    if (a.Match_Billing_Address__c == true){
        //assign shipping postal code with billing postal code
        a.ShippingPostalCode = a.BillingPostalCode;
    }
    
    }
    }
    else if (Trigger.IsUpdate && Trigger.IsInsert)
    {
    List<Account> acctsWithOpps = [SELECT Id, (SELECT Id, Name, CloseDate FROM Opportunities)
                                    FROM  Account WHERE Id IN : Trigger.New];

    //Iterate over the retrurned accounts
    for(Account a : acctsWithOpps) {
        Opportunity[] relatedOpps = a.Opportunities;
        //relatedOpps.Name = relatedOpps.Name + 'Updated!';
    }                                    
    System.debug('Updated');
    }
    
    else if (Trigger.IsUpdate)
    {
        //Get the related opportunities for the accounts in this trigger
        List<Opportunity> relatedOpps = [SELECT Id, Name, Probability FROM Opportunity WHERE AccountId IN : Trigger.New];
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>();

        //Iterate over the related opportunities
        for (Opportunity opp: relatedOpps) {
            //Update the description when probibility is greatedr
            //than 50% but less than 100%
            if((opp.Probability >= 50) && (opp.Probability < 100)){
            opp.Description = 'New description for opportunity. Probability is between 50 and 100';
            
            oppsToUpdate.add(opp);
        }
  }
  // Perform DML on a collection
  update oppsToUpdate;
 }
}