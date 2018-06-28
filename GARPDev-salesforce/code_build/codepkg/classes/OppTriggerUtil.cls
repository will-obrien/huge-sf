public class OppTriggerUtil {
  public static boolean bIsRecusrive = false;

  public static void OppTriggerLogic(List < Opportunity > opp) {
    bIsRecusrive = true;
    Set < Id > setAccounts = new Set < Id > ();
    List < Id > ids = new List < Id > ();
    for (Opportunity op: opp) {

      ids.add(op.Id);
      op.Company__c = 'GARP';
      op.Pay_By_Wire_Check__c = false;
      op.ChargentSFA__Gateway__c = updateids__c.getValues(op.Company__c).Record_id__c;
      setAccounts.add(op.accountId);

    }
    if (trigger.isinsert && trigger.isbefore) {
      Map < Id, Contract > mapMemberShipContracts = new Map < Id, Contract > ();
      Map < Id, String > mapPrevoiusMemberShipContracts = new Map < Id, String > ();
      if (!setAccounts.isEmpty()) {
        Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
        for (Contract objContract: [select id, name, Membership_Type__c, Status, accountId from Contract where accountId in : setAccounts and recordTypeId = : memberRecordTypeID]) {
          if (objContract.Membership_Type__c == 'Individual' || objContract.Membership_Type__c == 'Student')
            mapMemberShipContracts.put(objContract.accountId, objContract);
          if (objContract.Status == 'Activated')
            mapPrevoiusMemberShipContracts.put(objContract.accountId, objContract.Membership_Type__c);
        }
      }
      for (Opportunity updateOpp: opp) {
        updateOpp.Type = 'New Business';
        if (mapMemberShipContracts.containsKey(updateOpp.accountId)) {
          updateOpp.Type = 'Existing Business';
        }
        if (mapPrevoiusMemberShipContracts.containsKey(updateOpp.accountId))
          updateOpp.Previous_Memerbship__c = mapPrevoiusMemberShipContracts.get(updateOpp.accountId);

      }
    }



    List < Id > prodIds = new List < Id > ();

    List < Opportunity > lstOpportunity = [SELECT Id, Name, StageName, Product_Purchase_Summary__c, Amount, CreatedDate, Shipping_First_Name__c, Shipping_Last_Name__c, Ship_Street__c, Shipping_City__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c, Shipping_E_mail__c, LEGACY_PurchasesRefNo__c ,Shipping_Phone_No__c, Shipping_Company_Name__c,GARP_Invoice_Number__c, Renew_Membership__c, (SELECT Id, Name, Description, PricebookEntryId, Quantity, UnitPrice, SortOrder, TotalPrice, Product2Id FROM OpportunityLineItems) FROM Opportunity where Id = : ids];
    for (Opportunity op: lstOpportunity) {
      Boolean gra = false;
      for (OpportunityLineItem ol: op.OpportunityLineItems) {
        prodIds.add(ol.Product2Id);

      }

    }

    system.debug('* * * prodIds ...' + prodIds);

    // Query Products and map to Company
    Map < Id, Product2 > prodMap = new Map < Id, Product2 > ();
    List < Product2 > prods = [Select Id, Name, Company__c, GL_Code__c, ProductCode from Product2 where Id in : prodIds];
    for (Product2 prod: prods) {
      prodMap.put(prod.Id, prod);

    }

    system.debug('* * * prodMap ...' + prodMap);

    // Find Opp that need new Company
    List < Id > opCompanyUpdateIds = new List < Id > ();
    List < Id > opDeferPayUpdateIds = new List < Id > ();

    for (Opportunity op: lstOpportunity) {
      for (OpportunityLineItem ol: op.OpportunityLineItems) {

        for (Id pid: prodMap.keySet()) {
          Product2 pco = prodMap.get(pid);
            
          System.debug('* * *:' + op.Id + ':' + pid + ':' + ol.Product2Id + ':' + pco);
            
          if (ol.Product2Id == pid) {


              if (pco.Company__c == 'GRA') {
                  System.debug('* * * Add opCompanyUpdateIds:' + op);
                  opCompanyUpdateIds.add(op.Id);
              }
              

            if (pco.ProductCode == 'PRFEE' && pco.GL_Code__c == '6110')
              opDeferPayUpdateIds.add(op.id);
          }
        }
      }
    }

    system.debug('* * * opCompanyUpdateIds ...' + opCompanyUpdateIds);
    system.debug('* * * opDeferPayUpdateIds ...' + opDeferPayUpdateIds);
    Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity', 'Automated');
    // Update Opps
    for (Opportunity op: opp) {

      for (Id opId: opCompanyUpdateIds) {
          
        system.debug('* * * Update opCompanyUpdateIds ...' + opId + ':' + op);
          
        if (opId == op.Id )
          op.Company__c = 'GRA';
      }
      for (Id opId: opDeferPayUpdateIds) {
        if (opId == op.Id)
          op.Pay_By_Wire_Check__c = true;
      }

     
      system.debug('Opportunity : '+op);
      if (op.Company__c != null && updateids__c.getValues(op.Company__c) != null&& op.LEGACY_PurchasesRefNo__c == null )
        op.ChargentSFA__Gateway__c = updateids__c.getValues(op.Company__c).Record_id__c;

      system.debug('Opportunity After: '+op);

    }
  }
}