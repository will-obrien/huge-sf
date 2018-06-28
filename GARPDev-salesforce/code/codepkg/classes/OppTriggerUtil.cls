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
      if(updateids__c.getValues(op.Company__c) != null)
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

        List < Product_Refunds__c > lstPr = [select Id, Refund_amount__c, Opportunity__c, Opportunity__r.AccountId,
            Product__r.ProductCode, Product__r.Product_ID__c, Product__r.GL_Code__c from Product_Refunds__c where
            Status__c = 'Completed'
            and Opportunity__c in : opp
        ];

        system.debug('Get Refunds:' + lstPr);
      
        MAP < ID, List < Product_Refunds__c >> mapPR = new MAP < ID, List < Product_Refunds__c >> ();
        MAP < ID, List < Product_Refunds__c >> mapExamRegPR = new MAP < ID, List < Product_Refunds__c >> ();
        MAP < ID, List < Product_Refunds__c >> mapWileyRegPR = new MAP < ID, List < Product_Refunds__c >> ();

      Map<String,String> regProdCodeMap = new Map<String,String>();
      regProdCodeMap.put('ENCL','ERP');
      regProdCodeMap.put('ENCE','ERP');
      regProdCodeMap.put('ENCS','ERP');
      
      regProdCodeMap.put('FRM1E','FRM1');
      regProdCodeMap.put('FRM1S','FRM1');
      regProdCodeMap.put('FRM1L','FRM1');
      
      regProdCodeMap.put('FRM2E','FRM2');
      regProdCodeMap.put('FRM2S','FRM2');
      regProdCodeMap.put('FRM2L','FRM2');
      
      Map<String,String> regProdIdMap = new Map<String,String>();
      regProdIdMap.put('1157','ERP');
      regProdIdMap.put('957','ERP');
      regProdIdMap.put('989','ERP');
      regProdIdMap.put('1028','ERP');
      regProdIdMap.put('1047','ERP');
      regProdIdMap.put('1054','ERP');
      regProdIdMap.put('1070','ERP');
      regProdIdMap.put('1109','ERP');
      regProdIdMap.put('1124','ERP');
      regProdIdMap.put('1132','ERP');
      regProdIdMap.put('1142','ERP');
      regProdIdMap.put('1150','ERP');
      regProdIdMap.put('1157','ERP');
      regProdIdMap.put('1164','ERP');
      
      regProdIdMap.put('935','FRM1');
      regProdIdMap.put('934','FRM1');
      regProdIdMap.put('987','FRM1');
      regProdIdMap.put('1030','FRM1');
      regProdIdMap.put('1045','FRM1');
      regProdIdMap.put('1052','FRM1');
      regProdIdMap.put('1068','FRM1');
      regProdIdMap.put('1107','FRM1');
      regProdIdMap.put('1122','FRM1');
      regProdIdMap.put('1130','FRM1');
      regProdIdMap.put('1140','FRM1');
      regProdIdMap.put('1148','FRM1');
      regProdIdMap.put('1155','FRM1');
      regProdIdMap.put('1162','FRM1');
      regProdIdMap.put('682','FRM1');
      regProdIdMap.put('482','FRM1');
      regProdIdMap.put('384','FRM1');
      regProdIdMap.put('302','FRM1');
      regProdIdMap.put('206','FRM1');
      regProdIdMap.put('2','FRM1');
      regProdIdMap.put('1','FRM1');
      regProdIdMap.put('34','FRM1');
      regProdIdMap.put('35','FRM1');
      regProdIdMap.put('36','FRM1');
      
      regProdIdMap.put('988','FRM2');
      regProdIdMap.put('1031','FRM2');
      regProdIdMap.put('1046','FRM2');
      regProdIdMap.put('1053','FRM2');
      regProdIdMap.put('1069','FRM2');
      regProdIdMap.put('1108','FRM2');
      regProdIdMap.put('1123','FRM2');
      regProdIdMap.put('1131','FRM2');
      regProdIdMap.put('1141','FRM2');
      regProdIdMap.put('1149','FRM2');
      regProdIdMap.put('1156','FRM2');
      regProdIdMap.put('1163','FRM2');
          
        for (Product_Refunds__c pr: lstPr) {
            
            if (pr.Product__r.ProductCode == '208' ||
                pr.Product__r.ProductCode == '7' ||
                pr.Product__r.ProductCode == '207' ||
                pr.Product__r.ProductCode == '1129' ||
                pr.Product__r.ProductCode == '4' ||
                pr.Product__r.ProductCode == '944' ||
                pr.Product__r.ProductCode == 'MEMS' ||
                pr.Product__r.ProductCode == 'MEMI' ||
                pr.Product__r.ProductCode == 'MEMC' ||
                pr.Product__r.ProductCode == '395' ||
                pr.Product__r.ProductCode == 'MEMF' ||
                pr.Product__r.Product_ID__c == '181' ||
                pr.Product__r.Product_ID__c == '209' ||
                pr.Product__r.Product_ID__c == '5' ||
                pr.Product__r.Product_ID__c == '6') {

                system.debug('Member Refund Found:' + pr);
                    
                List < Product_Refunds__c > lst = mapPR.get(pr.Opportunity__c);
                if (lst == null) {
                    List < Product_Refunds__c > newlst = new List < Product_Refunds__c > ();
                    newlst.add(pr);
                    mapPR.put(pr.Opportunity__c, newlst);
                } else {
                    lst.add(pr);
                    mapPR.put(pr.Opportunity__c, lst);
                }
            }
            
            String  examRegProdCodeMap = regProdCodeMap.get(pr.Product__r.ProductCode);
            String  examRegProdIdMap = regProdIdMap.get(pr.Product__r.Product_ID__c);
            
            if (examRegProdCodeMap != null || examRegProdIdMap != null) {

                system.debug('Exam Reg Refund Found:' + pr);
                    
                List < Product_Refunds__c > lst = mapExamRegPR.get(pr.Opportunity__c);
                if (lst == null) {
                    List < Product_Refunds__c > newlst = new List < Product_Refunds__c > ();
                    newlst.add(pr);
                    mapExamRegPR.put(pr.Opportunity__c, newlst);
                } else {
                    lst.add(pr);
                    mapExamRegPR.put(pr.Opportunity__c, lst);
                }
            }            
            
            if ((pr.Product__r.GL_Code__c == '2007' && 
                pr.Product__r.Product_ID__c == '1147')  ||
                pr.Product__r.ProductCode == 'MEMW') {

                system.debug('Wley Refund Found:' + pr);
                    
                List < Product_Refunds__c > lst = mapWileyRegPR.get(pr.Opportunity__c);
                if (lst == null) {
                    List < Product_Refunds__c > newlst = new List < Product_Refunds__c > ();
                    newlst.add(pr);
                    mapWileyRegPR.put(pr.Opportunity__c, newlst);
                } else {
                    lst.add(pr);
                    mapWileyRegPR.put(pr.Opportunity__c, lst);
                }
            }                        
            
        }

    List < Id > prodIds = new List < Id > ();
    Map<Id,Decimal> frm1totalMap = new Map<Id,Decimal>();
    Map<Id,Decimal> frm2totalMap = new Map<Id,Decimal>();
    Map<Id,Decimal> erptotalMap = new Map<Id,Decimal>();
    Map<Id,Decimal> memtotalMap = new Map<Id,Decimal>();
    Map<Id,Decimal> wtotalMap = new Map<Id,Decimal>();
    List < Opportunity > lstOpportunity = [SELECT Id, Name, StageName, Product_Purchase_Summary__c, Amount, CreatedDate, Shipping_First_Name__c, Shipping_Last_Name__c, Ship_Street__c, Shipping_City__c, Shipping_State__c, Shipping_Postal_Code__c, Shipping_Country__c, Shipping_E_mail__c, LEGACY_PurchasesRefNo__c ,Shipping_Phone_No__c, Shipping_Company_Name__c,GARP_Invoice_Number__c, Renew_Membership__c, (SELECT Id, Name, Description, PricebookEntryId, Quantity, UnitPrice, SortOrder, TotalPrice, PriceBookEntry.UnitPrice, PricebookEntry.Name,
                PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.Name, PricebookEntry.Product2.Product_ID__c, PricebookEntry.Product2.GL_Code__c, Product2Id FROM OpportunityLineItems) FROM Opportunity where Id = : ids];
    for (Opportunity op: lstOpportunity) {
      Boolean gra = false;
      Decimal frm1total = 0;
      Decimal frm2total = 0;
      Decimal erptotal = 0;
      Decimal memtotal = 0;
      Decimal wtotal = 0;
        
      List<Product_Refunds__c> lPR = mapExamRegPR.get(op.Id);
      List<Product_Refunds__c> lMemPR = mapPR.get(op.Id);
      List<Product_Refunds__c> lWileyPR = mapWileyRegPR.get(op.Id);
        
      
      system.debug('Refunds:' + lPR);
        
      for (OpportunityLineItem ol: op.OpportunityLineItems) {
            prodIds.add(ol.Product2Id);
          
          system.debug('Prod:' + ol.PricebookEntry.Product2.ProductCode + ':' + ol.PricebookEntry.Product2.Product_ID__c + ':' + ol.PricebookEntry.Product2.Name);

          if (ol.PricebookEntry.Product2.ProductCode == '208' ||
              ol.PricebookEntry.Product2.ProductCode == '7' ||
              ol.PricebookEntry.Product2.ProductCode == '207' ||
              ol.PricebookEntry.Product2.ProductCode == '1129' ||
              ol.PricebookEntry.Product2.ProductCode == '4' ||
              ol.PricebookEntry.Product2.ProductCode == '944' ||
              ol.PricebookEntry.Product2.ProductCode == 'MEMS' ||
              ol.PricebookEntry.Product2.ProductCode == 'MEMI' ||
              ol.PricebookEntry.Product2.ProductCode == 'MEMC' ||
              ol.PricebookEntry.Product2.ProductCode == '395' ||
              ol.PricebookEntry.Product2.ProductCode == 'MEMF' ||
              ol.PricebookEntry.Product2.ProductCode == 'AFREE' ||
              ol.PricebookEntry.Product2.Product_ID__c == '181' ||
              ol.PricebookEntry.Product2.Product_ID__c == '209' ||
              ol.PricebookEntry.Product2.Product_ID__c == '5' ||
              ol.PricebookEntry.Product2.Product_ID__c == '6') {
                  
                    Boolean found=false;
                    if(lMemPR != null) {
                        for(Product_Refunds__c pr :lMemPR) {
                            if(pr.Product__r.ProductCode == ol.PricebookEntry.Product2.ProductCode)
                                found=true;
                        }
                    }
                    if(found==false)
                        memtotal += ol.TotalPrice; 
                  
                    system.debug('Found Membership:' + found + ':' + memtotal);
                }
          
            String  examRegProdCodeMap = regProdCodeMap.get(ol.PricebookEntry.Product2.ProductCode);
            String  examRegProdIdMap = regProdIdMap.get(ol.PricebookEntry.Product2.Product_ID__c);
          
            if (examRegProdCodeMap == 'ERP' || examRegProdIdMap == 'ERP') {
                    Boolean found=false;
                    if(lPR != null) {
                        for(Product_Refunds__c pr :lPR) {
                            if(pr.Product__r.ProductCode == ol.PricebookEntry.Product2.ProductCode)
                                found=true;
                        }
                    }
                    if(found==false)
                        erptotal += ol.TotalPrice;    
                   
                   system.debug('Found ERP Reg:' + found + ':' + erptotal);
                }          
          
            if (examRegProdCodeMap == 'FRM1' || examRegProdIdMap == 'FRM1') {
                    Boolean found=false;
                    if(lPR != null) {
                        for(Product_Refunds__c pr :lPR) {
                            if(pr.Product__r.ProductCode == ol.PricebookEntry.Product2.ProductCode)
                                found=true;
                        }
                    }
                    if(found==false)
                        frm1total += ol.TotalPrice;            
                   
                   system.debug('Found FRM1 Reg:' + found + ':' + frm1total);
                }
          
            if (examRegProdCodeMap == 'FRM2' || examRegProdIdMap == 'FRM2') {
                    Boolean found=false;
                    if(lPR != null) {
                        for(Product_Refunds__c pr :lPR) {
                            if(pr.Product__r.ProductCode == ol.PricebookEntry.Product2.ProductCode)
                                found=true;
                        }
                    }
                    if(found==false)
                        frm2total += ol.TotalPrice; 
                   
                   system.debug('Found FRM2 Reg:' + found + ':' + frm2total);
                }
          
            if ((ol.PricebookEntry.Product2.GL_Code__c == '2007' && 
                ol.PricebookEntry.Product2.Product_ID__c == '1147')  ||
                ol.PricebookEntry.Product2.ProductCode == 'MEMW') {
                
                   wtotal += ol.TotalPrice; 
                   
                   system.debug('Found Wiley Reg:' + wtotal);
                }

      }
     
        system.debug('frm1total:'+frm1total);  
        frm1totalMap.put(op.Id, frm1total);       
        
        system.debug('frm2total:'+frm2total);   
        frm2totalMap.put(op.Id, frm2total);
        
        system.debug('erptotal:'+erptotal); 
        erptotalMap.put(op.Id, erptotal);
    
        system.debug('memtotal:'+memtotal);
        memtotalMap.put(op.Id, memtotal);

        system.debug('wtotal:'+wtotal);
        wtotalMap.put(op.Id, wtotal);
        
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

      Decimal fr1mt = frm1totalMap.get(op.Id);
      if(fr1mt != null)
          op.FRM_1_Registration_Fee__c = fr1mt;
      Decimal fr2mt = frm2totalMap.get(op.Id);
      if(fr2mt != null)
          op.FRM_2_Registration_Fee__c = fr2mt;
      Decimal erpt = erptotalMap.get(op.Id);
      if(erpt != null)
          op.ERP_Registration_Fee__c = erpt;
      
      system.debug('Update Reg Fee:' + op);

      Decimal mrpt = memtotalMap.get(op.Id);
      if(mrpt != null)
          op.Membership_Fee__c = mrpt;
        
      Decimal wrpt = wtotalMap.get(op.Id);
      if(wrpt != null)
          op.Wiley_Fee__c = wrpt;
        

    
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