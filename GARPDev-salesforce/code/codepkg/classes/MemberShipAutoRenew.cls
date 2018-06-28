public without sharing class MemberShipAutoRenew {
              
   public Static PricebookEntry objPricebook = new PricebookEntry();
   public static boolean bIsMEMI = false;
   public static void autoRenewOff(boolean bIsAutoRenewOff)
        {
            if(!bIsAutoRenewOff) return;
            Id currentUSer = userInfo.getuserId();
            User objUSer = [select id,Email,contactId from user where id =: currentUSer];
            Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
            Contact objContact = [select id,Name,Accountid,KPI_Membership_Auto_Renew_Status__c from contact where id =: objUSer.contactId];
            List<Account> lstAcct = [select Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Billing_Address_Company__c from Account where Id = :objContact.AccountId];
            objContact.KPI_Membership_Auto_Renew_Status__c = false;
            update objContact;
            List<Opportunity> lst = new List<Opportunity>();
            for(Opportunity opp : [select id,ChargentSFA__Payment_Status__c from opportunity where accountId =: objContact.AccountId and ChargentSFA__Payment_Status__c =: 'Recurring'])
            {
                opp.ChargentSFA__Payment_Status__c = 'Stopped';
                lst.add(opp);
            }
            update lst;
            List<contract> con = new List<contract>();
            for(contract contract: [select id,recordTypeId,Membership_Type__c,Enddate,status from contract where recordTypeId =: memberRecordTypeID and status =: 'Activated ( Auto-Renew )' and accountId =: objContact.accountId])
            {
                contract.status = 'Activated';
                con.add(contract);
            }
            
            if(con.size() > 0)
                update con;
        }
        
    	public static Registration.wrapperCreateOrder autorenew(boolean bIsCurrentDay,string strProductCode, String AMP, Boolean Wiley)
        {
            Id currentUSer = userInfo.getuserId();
            Registration.wrapperCreateOrder wco = new Registration.wrapperCreateOrder();
                
            User objUSer = [select id,Email,contactId from user where id =: currentUSer];
            Contact objContact = [select id,HomePhone, Company__c, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, AccountId, GARP_Member_ID__c, Membership_Type__c,Name,LastName,FirstName,KPI_Membership_Auto_Renew_Status__c,Email,KPI_ERP_Certified__c,KPI_FRM_Certified__c from contact where id =: objUSer.contactId];
            List<Account> lstAcct = [select Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Billing_Address_Company__c from Account where Id = :objContact.AccountId];
            Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
            Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
            
            system.debug('$$$$$$:'+strProductCode);
            List<Contract> lstContract = [select id,status,recordTypeId,Membership_Type__c,Enddate from contract where recordTypeId =: memberRecordTypeID and (status =: 'Activated'  or (status =: 'Activated ( Auto-Renew )' and Membership_Type__c !=: 'Affiliate')) and accountId =: objContact.accountId];
                        
            PriceBookEntry PricebookEntryId = [select unitprice,productcode from PriceBookEntry where Pricebook2.IsActive = true and productcode =: strProductCode and isActive = true];
            decimal dAmount = null;
                  dAmount = PricebookEntryId.unitprice;
                  system.debug('$$$$$$:'+dAmount);
          ChargentSFA__Payment_Request__c objPayment = new ChargentSFA__Payment_Request__c();            
         
          if(bIsCurrentDay){
            Contract ct = lstContract.isEmpty() ? null : lstContract[0];
            Opportunity opp = createOpportunity(objContact,lstAcct[0],recordTypeID,PricebookEntryId,ct,AMP,Wiley);
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = opp.Id;
              
            wco.opportunityId = opp.Id;
            wco.garpId = objContact.GARP_Member_ID__c;
            if(bIsMEMI)
            {
            system.debug('$$$$$$:'+bIsMEMI);
                objPricebook = [select id,unitprice from PriceBookEntry where Pricebook2.IsActive = true and productcode =: 'MEMC'];
                oppLineItem.PricebookEntryId = objPricebook.Id;
                oppLineItem.UnitPrice = objPricebook.unitprice;
                system.debug('$$$$$$:'+oppLineItem.PricebookEntryId);
            }
            else
            {
                oppLineItem.PricebookEntryId = PricebookEntryId.Id;
                oppLineItem.UnitPrice = dAmount;
            }
            
            oppLineItem.Quantity = 1;
            insert oppLineItem;
            
            
            if(AMP != Null && AMP.length() > 0) {
            
               oppLineItem = new OpportunityLineItem();
               oppLineItem.OpportunityId = opp.Id;
                        
                objPricebook = [select id,unitprice from PriceBookEntry where Pricebook2.IsActive = true and productcode =: 'PRFEE'];
                oppLineItem.PricebookEntryId = objPricebook.Id;
                oppLineItem.UnitPrice = 50;
                oppLineItem.description = AMP;
                oppLineItem.Quantity = 1;
                insert oppLineItem;
            }
              
            if(Wiley) {
              oppLineItem = new OpportunityLineItem();
              oppLineItem.OpportunityId = opp.Id;
              
              objPricebook = [select id,unitprice from PriceBookEntry where Pricebook2.IsActive = true and productcode =: 'MEMW'];
              oppLineItem.PricebookEntryId = objPricebook.Id;
              oppLineItem.UnitPrice = objPricebook.unitprice;
              oppLineItem.Quantity = 12;
              insert oppLineItem;  
                           
            }
            
            List<Contract> lstUpdateContracts = new List<Contract>();
            for(Contract objCon : lstContract)
            {
                if(objCon.status == 'Activated')
                {
                    objCon.Opportunity__c = opp.Id;
                    lstUpdateContracts.add(objCon);  
                }
            }
            update lstUpdateContracts;
            objPayment.ChargentSFA__Billing_Contact__c = objContact.Id;
            objPayment.ChargentSFA__Opportunity__c = opp.Id;                    
            insert objPayment;
            objPayment = [select id, name, ChargentSFA__Pay_Link__c from ChargentSFA__Payment_Request__c where id = :objPayment.Id];
            wco.payRequest = objPayment;
      }
      return wco;
    }
    
    
    public static id createoppRecurring(String strProductCode){
    
           Id currentUSer = userInfo.getuserId();
           Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
           Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
           User objUSer = [select id,Email,contactId from user where id =: currentUSer];
           Contact objContact = [select id,Name,LastName,HomePhone,Company__c,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,email,firstName,Accountid,KPI_Membership_Auto_Renew_Status__c from contact where id =: objUSer.contactId];
           List<Contract> lstContract = [select id,recordTypeId,Membership_Type__c,Enddate from contract where recordTypeId =: memberRecordTypeID and (status =: 'Activated') and accountId =: objContact.accountId];
           List<Account> lstAcct = [select Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Billing_Address_Company__c from Account where Id = :objContact.AccountId];
           PriceBookEntry PricebookEntryId = [select unitprice,productcode from PriceBookEntry where Pricebook2.IsActive = true and productcode =: strProductCode and isActive = true];
           decimal dAmount = PricebookEntryId.unitprice;
           Contract objcontract = null;
           if(lstContract != null && lstContract.size() > 0)
                objcontract = lstContract[0];
           Opportunity opp = createOpportunity(objContact,lstAcct[0],recordTypeID,PricebookEntryId,objcontract,'',False);
           OpportunityLineItem oppLineItem = new OpportunityLineItem();
           oppLineItem.OpportunityId = opp.Id;
           if(bIsMEMI)
           {
                objPricebook = [select id from PriceBookEntry where Pricebook2.IsActive = true and productcode =: 'MEMC'];
                oppLineItem.PricebookEntryId = objPricebook.Id;
                dAmount =150.00;
           }
           else
                oppLineItem.PricebookEntryId = PricebookEntryId.Id;
           
           oppLineItem.UnitPrice = dAmount;
          // oppLineItem.UnitPrice = 150;
           oppLineItem.Quantity = 1;
           insert oppLineItem;
           Id oppId = opp.id;
           objcontract.Opportunity__c = opp.Id;
           update objcontract;   
                
           return oppid;
     }

    public Static String VoidRecurring(id oppid) {
        Opportunity oppMain = [select id,amount,ChargentSFA__Charge_Amount__c from opportunity where  id =: oppId];
        ChargentSFA.TChargentOperations.TChargentResult outputResult;
        String strVoidJson = PrepareVoidJsonParameters(oppMain.Id,oppMain.ChargentSFA__Charge_Amount__c);
        outputResult = ChargentSFA.TChargentOperations.VoidOpportunity_Click(oppMain.Id);
        return outputResult.Message;
    }    
    
    public Static String RecurringFuture(id oppid, String cardMonth, String cardYear, String paymentType, String cardType, String cardSecurity, String cardNumber){
        Opportunity oppMain = [select id,amount,ChargentSFA__Charge_Amount__c from opportunity where  id =: oppId];
        ChargentSFA.TChargentOperations.TChargentResult outputResult;
        String strInput = PrepareJsonParameters(oppMain.Id,cardMonth,cardYear,paymentType,cardType,cardSecurity,cardNumber,oppMain.ChargentSFA__Charge_Amount__c);
        outputResult = ChargentSFA.TChargentOperations.AuthorizeOpportunity_ClickJSON(strInput);
        if (!outputResult.Message.contains('Approved')) {
            oppMain.StageName = 'Closed Lost';
            update oppMain;
        }
        return outputResult.Message;
    }
    
    private static String PrepareVoidJsonParameters(Id oppId,Decimal amount)
    {
        String jsonInput = '{\n' +
        ' "ObjectId" : "'+ oppId +'",\n' +
        ' "ChargeAmount" : "'+ amount +'"\n' +
        '}';
        
        return jsonInput;
    
    }
    
     private static String PrepareJsonParameters(Id oppId,String cardMonth,String cardYear,String paymentType,String cardType,String cardSecurity,String cardNumber,Decimal amount)
    {
        boolean atuhorize = false;
        String jsonInput = '{\n' +
        ' "ObjectId" : "'+ oppId +'",\n' +
        ' "CardMonth" : "'+ cardMonth +'",\n' +
        ' "CardYear" :"'+ cardYear +'",\n' +
        ' "PaymentMethod" : "'+ paymentType +'",\n' +
        ' "CardType" : "Visa",\n' +
        ' "CardSecurity" : "'+ cardSecurity +'",\n' +
        ' "CardNumber" : "'+ cardNumber +'",\n' +
        ' "ChargeAmount" : "'+amount+'"' +
        '}';
        
        return jsonInput;
    
    }
    
    public static Opportunity createOpportunity(Contact objContact,Account objAccount,Id recordTypeID,PriceBookEntry PricebookEntryId,Contract objContract,String AMP,Boolean Wiley)
    {
        decimal dChargentAmount = 0;
        bIsMEMI = false;
                   Contact objContact1 = [select id,Name,KPI_ERP_Certified__c ,KPI_FRM_Certified__c,LastName,HomePhone,Company__c,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,email,firstName,Accountid,KPI_Membership_Auto_Renew_Status__c from contact where id =: objContact.Id];

        system.debug('objContact1 == '+objContact1 );
        system.debug('PricebookEntryId == '+PricebookEntryId);
        if(PricebookEntryId != null)
        {   
             if((objContact1.KPI_ERP_Certified__c || objContact1.KPI_FRM_Certified__c) && PricebookEntryId.productcode == 'MEMI')
             {
                  dChargentAmount = 150;
                  bIsMEMI = true;
             }
            else
            {
                 if(PricebookEntryId.productcode == 'MEMI')
                    dChargentAmount = 195;
                else if(PricebookEntryId.productcode == 'MEMC')
                    dChargentAmount = 150;
                else if(PricebookEntryId.productcode == 'MEMS')
                    dChargentAmount = 95;
            }
            
            if(Wiley)
                dChargentAmount+=75;
        }
        
        system.debug('dChargentAmount  == '+dChargentAmount );
        Opportunity opp = new Opportunity();
        opp.Name='Purchase';
        opp.StageName='New Lead';
        opp.Wiley__c = Wiley;
        opp.CloseDate = system.today();
        opp.Renew_Membership__c = true;
        opp.Auto_Renew__c = true;
        opp.AccountId=objContact.accountId;
        opp.RecordTypeId = recordTypeID;
        opp.ChargentSFA__Billing_Email__c = objContact.Email;
        opp.ChargentSFA__Billing_First__c = objContact.FirstName;
        opp.ChargentSFA__Billing_Last__c = objContact.LastName;
        opp.ChargentSFA__Billing_Phone__c = objContact.HomePhone;
        opp.ChargentSFA__Billing_Company__c = objAccount.Billing_Address_Company__c;   
        opp.ChargentSFA__Billing_Address__c = objAccount.BillingStreet;
        opp.ChargentSFA__Billing_City__c = objAccount.BillingCity;
        opp.ChargentSFA__Billing_State__c = objAccount.BillingState;
        opp.ChargentSFA__Billing_Zip__c = objAccount.BillingPostalCode;
        opp.ChargentSFA__Billing_Country__c = objAccount.BillingCountry;
        opp.Shipping_First_Name__c = objContact.FirstName;
        opp.Shipping_Last_Name__c = objContact.LastName;
        opp.Shipping_E_mail__c = objContact.Email;
        opp.Shipping_Company_Name__c = objContact.Company__c;
        opp.Shipping_Phone_No__c = objContact.HomePhone;
        opp.Shipping_Street__c = objContact.MailingStreet;
        opp.Shipping_City__c = objContact.MailingCity;
        opp.Shipping_State__c = objContact.MailingState;
        opp.Shipping_Postal_Code__c = objContact.MailingPostalCode;
        opp.Shipping_Country__c = objContact.MailingCountry;
        opp.ChargentSFA__Charge_Amount__c = dChargentAmount;
        opp.ChargentSFA__Manual_Charge__c = true;
        
        if(AMP != Null && AMP.length() > 0) {
            opp.Alternate_Method_of_Payment__c = AMP;
        }
        insert opp;
        
        OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=objContact.Id, Role='Decision Maker');
        insert contactRole;


        return opp;
    }}