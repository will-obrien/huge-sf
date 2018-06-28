public class FBRICBRUtils
{
    public static decimal dTotalPrice = 0;
    public class productList {
        public String GLCode { get; set; }
        public String price { get; set; }
    }
    public static List<wrapperUtils.wrapperProductDetails> getProductCodes()
    {
        try
        {
            User objUser = Utilities.getCurrentUserDetails();
            if(objUser.Contactid == null) return null;
            Contact objCont = [select id,accountid, KPI_Membership_Payment_Status__c from contact where id =: objUser.Contactid];
            if(objCont == null) return null;
            id memrecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
            id icbrrrecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
            id fbrrecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FBR Program');
            List<PriceBookEntry> lstProceBooks = null;
            List<Contract> lstContracts = [select id,Membership_Type__c,accountId,Status,Enddate from contract where accountID =: objCont.accountid and (recordtypeId =: memrecordTypeId or recordtypeId =: icbrrrecordTypeId or recordtypeId =: fbrrecordTypeId)];
            boolean bICBRActiveContract = false;
            Id icbrContractID = null;
            system.debug('lstContracts == '+lstContracts);
            Contract objContract;
            Contract objICBRContract;
            boolean bIcbrrCompleted = false;
            boolean bFbrCompleted = false;
            for(Contract objCon : lstContracts)
            {
                if(objCon.recordtypeId == icbrrrecordTypeId && objCon.Status =='Completed')
                    bIcbrrCompleted = true;
                if(objCon.recordtypeId == fbrrecordTypeId && objCon.Status =='Completed')
                    bFbrCompleted = true;
                if(objCon.recordtypeId == icbrrrecordTypeId && (objCon.Status == 'Activated' || objCon.Status =='Activated ( Auto-Renew )'))
                {
                    bICBRActiveContract = true;
                    icbrContractID = objCon.Id;
                    objICBRContract = objCon;
                }
                if(objCon.recordtypeId == memrecordTypeId && (objCon.Status == 'Activated'|| objCon.Status =='Activated ( Auto-Renew )'))
                {
                   objContract = objCon;
                }
            
            }
            system.debug('bICBRActiveContract == '+bICBRActiveContract);
            List<Exam_Attempt__c> lstExamAttempts = null;
            if(icbrContractID != null)
            {
                lstExamAttempts = [select id,Icbrr_Exam_Date__c,Result__c,Candidate_Commitment__c from Exam_Attempt__c where Candidate_Commitment__c =: icbrContractID order by Icbrr_Exam_Date__c DESC];
            }
            system.debug('lstExamAttempts == '+lstExamAttempts);
            Set<String> setProductCodes = new Set<String>{'MEMI','FCBR','FBRNM','CBR','CBRNM','CBR2A'};
            //if(objContract.Membership_Type__c == 'Individual') 
           
            lstProceBooks = [select unitprice,productcode,product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode in: setProductCodes and IsActive =: true];
             system.debug('lstProceBooks == '+lstProceBooks);
            if(lstProceBooks == null) return null;
            boolean bIsNotMember = objContract == null || (objContract != null && objContract.Membership_Type__c != 'Individual');
            wrapperUtils.wrapperProductDetails wrapObject;
            List<wrapperUtils.wrapperProductDetails> lstWrapper = new List<wrapperUtils.wrapperProductDetails>();
            boolean bAddIndividualMemberPrice = false;
            
            system.debug('objContract == '+objContract);
            
            system.debug('bIsNotMember == '+bIsNotMember);
            
            for(PriceBookEntry obj :lstProceBooks)
            {
                wrapObject = new wrapperUtils.wrapperProductDetails();
                    system.debug('obj == '+obj);
                    system.debug('bFbrCompleted == '+bFbrCompleted);
                    system.debug('bIcbrrCompleted == '+bIcbrrCompleted);
                    if(objContract != null && obj.productcode == 'MEMI' && objContract.Membership_Type__c != 'Individual' && (objContract.Status == 'Activated'|| objContract.Status =='Activated ( Auto-Renew )'))
                    {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;
                    }
                    else if((!bFbrCompleted) && (obj.productcode == 'FCBR' || obj.productcode == 'FBRNM' ) && bIsNotMember)
                    {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;
                        bAddIndividualMemberPrice = true;
                        
                    }
                    else if((!bFbrCompleted) && (obj.productcode == 'FCBR') && !bIsNotMember)
                    {
                         wrapObject.strProductCode = obj.productcode;
                         wrapObject.dPrice = obj.unitprice; 
                         wrapObject.strGlCode = obj.product2.Gl_Code__c;
                    }
                    else if((!bIcbrrCompleted) && obj.productCode == 'CBR' || obj.productCode == 'CBRNM' || obj.productCode == 'CBR2A')
                    {
                        Exam_Attempt__c objEA = (lstExamAttempts == null || lstExamAttempts.size() <= 0 ? null :lstExamAttempts[0]);
                        system.debug('objEA == '+objEA);
                        system.debug('bICBRActiveContract == '+bICBRActiveContract);
                        if(bICBRActiveContract)
                        {
                            if(lstExamAttempts == null) 
                            {   
                                wrapObject.strProductCode = obj.productcode;
                                wrapObject.dPrice = obj.unitprice;
                                wrapObject.strGlCode = obj.product2.Gl_Code__c;
                                continue;
                            }
                            else if(objICBRContract.EndDate < system.today() && (objEA != null && objEA.Result__c != 'Pass'))
                            {
                                wrapObject.strProductCode = obj.productcode;
                                wrapObject.strGlCode = obj.product2.Gl_Code__c;
                                //wrapObject.dPrice = 0;
                                if(bIsNotMember && (obj.productcode == 'CBRNM' || obj.productcode == 'CBR' || obj.productcode == 'CBR2A'))
                                    wrapObject.dPrice = obj.unitprice;
                                else if(!bIsNotMember && (obj.productcode == 'CBR'))
                                {
                                    wrapObject.dPrice = obj.unitprice;
                                    bAddIndividualMemberPrice = true;
                                }
                            }
                            else
                            {
                                
                                
                                Date dtCurrentDate = system.today();
                                Integer iDaysDifference = 0;
                                if(objEA != null && objEA.Icbrr_Exam_Date__c != null)
                                    iDaysDifference = objEA.Icbrr_Exam_Date__c.daysBetween(dtCurrentDate);
                                system.debug('iDaysDifference == '+iDaysDifference);
                                //if((objEA.Result__c == 'Fail' || objEA.Result__c == 'No-Show') && objEA.Icbrr_Exam_Date__c >= dtCurrentDate)
                                if(objEA != null && (objEA.Result__c == 'Fail' || objEA.Result__c == 'No-Show') && iDaysDifference >= 30 && obj.productcode == 'CBR2A')
                                {
                                    wrapObject.dPrice = obj.unitprice;
                                    wrapObject.strProductCode = obj.productcode;
                                    wrapObject.strGlCode = obj.product2.Gl_Code__c;
                                }
                            
                            }
                            
                        }
                        else
                        {
                            if(bIcbrrCompleted || bFbrCompleted) continue;
                            
                                wrapObject.strProductCode = obj.productcode;
                                wrapObject.strGlCode = obj.product2.Gl_Code__c;
                                //wrapObject.dPrice = 0;
                                if(bIsNotMember && (obj.productcode == 'CBRNM'|| obj.productcode == 'CBR' || obj.productcode == 'CBR2A'))
                                        wrapObject.dPrice = obj.unitprice;
                                else if(!bIsNotMember && (obj.productcode == 'CBR'))
                                {
                                        wrapObject.dPrice = obj.unitprice;
                                        bAddIndividualMemberPrice = true;
                                }
                                    
                                system.debug('wrapObject == '+wrapObject);
                            
                        }
                        
                    }
                
                if(wrapObject.strProductCode == null || wrapObject.dPrice == null) continue;
                lstWrapper.add(wrapObject);
                
            }
            
            system.debug('lstWrapper == '+lstWrapper);
            return lstWrapper;
         }
         catch(exception ex)
         {
             throw ex;
         }       
        
    }
    
     public static Registration.wrapperCreateOrder generateOrders(Map<String,string[]> mapProdDetails, TempAccount objData)
     {
        Decimal dTotalAmount = 0;
        system.debug('mapProdDetails == '+mapProdDetails);
        User objUser = Utilities.getCurrentUserDetails();
        if(objUser.Contactid == null) return null;
        Contact objContact = [select id,Name,GARP_Member_ID__c ,Accountid,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet from contact where id =: objUSer.contactId];
        
        Opportunity oppRecord = CreateOpportunity(mapProdDetails, objContact, objData);
        dTotalAmount = createOppLineItems(oppRecord.Id,mapProdDetails);
        //Id paymentId = createPaymentDetails(oppRecord.Id,objContact.Id,oppRecord.AccountId);
        createExamAttempts(mapProdDetails,objContact.Id,oppRecord.AccountId,oppRecord.Id,true);
         
		Registration.wrapperCreateOrder returnWrapper = new Registration.wrapperCreateOrder();
        returnWrapper.garpId = objContact.GARP_Member_ID__c;
        returnWrapper.totalCost = dTotalAmount;
        returnWrapper.contactId = objContact.Id;
        returnWrapper.opportunityId =oppRecord.Id ; 
         
        return returnWrapper;
     }
     
    public static Opportunity CreateOpportunity(Map<String,String[]> mapProdDetails, Contact objContact, TempAccount objData)
    {
        
        Id oppRecordTypeId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
        Opportunity opp = new Opportunity();
        try
        {
            if(objData.isIcbrChecked)
                opp.Name = 'ICBRR Registration';
            else opp.Name = 'FBR Registration';
            opp.Accountid = objContact.AccountId;
            opp.StageName = 'New Lead';
            opp.CloseDate = system.today();
            opp.ChargentSFA__Payment_Method__c = 'Credit Card';
            opp.RecordTypeId = oppRecordTypeId;
          //  opp.Eligible_for_Membership_Extension__c = (mapProdDetails.containsKey('MEMI'));
            opp.Eligible_for_Membership_Extension__c = true;
            opp.Shipping_First_Name__c = objData.FirstName;
            opp.Shipping_Last_Name__c = objData.LastName;
            opp.Shipping_Phone_No__c = objData.HomePhone;
            opp.Shipping_E_mail__c = objData.Email;
            
            opp.Shipping_Company_Name__c = objData.MailingCompany;
            opp.Shipping_Street__c = objData.MailingStreet;
            opp.Shipping_City__c = objData.MailingCity;
            opp.Shipping_State__c = objData.MailingState;
            opp.Shipping_Country__c = objData.MailingCountry;
            opp.Shipping_Postal_Code__c = objData.MailingPostalCode;
            
            opp.ChargentSFA__Billing_Email__c = objData.Email;
            opp.ChargentSFA__Billing_First__c = objData.FirstName;
            opp.ChargentSFA__Billing_Last__c = objData.LastName;
            opp.ChargentSFA__Billing_Phone__c = objData.HomePhone;
            opp.ChargentSFA__Billing_Company__c = objData.BillingCompany;
            
            opp.ChargentSFA__Billing_Address__c = objData.BillingStreet;
            if(objData.BillingStreetTwo != null && objData.BillingStreetTwo.length() > 0)
                opp.ChargentSFA__Billing_Address__c += '\n' + objData.BillingStreetTwo;
            if(objData.BillingStreetThree != null && objData.BillingStreetThree.length() > 0)
                opp.ChargentSFA__Billing_Address__c += '\n' + objData.BillingStreetThree;
            
            opp.ChargentSFA__Billing_City__c = objData.BillingCity;
            opp.ChargentSFA__Billing_State__c = objData.BillingState;
            opp.ChargentSFA__Billing_Zip__c = objData.BillingPostalCode;
            opp.ChargentSFA__Billing_Country__c = objData.BillingCountry;
            
            opp.Alternate_Method_of_Payment__c = objData.paymentMethod;
            opp.Has_Books__c = objData.hasBooks;
                
            insert opp;
            return opp;
        }
        catch(exception ex)
        {
            return null;
        }
        
    
    }

    public static decimal createOppLineItems(Id oppId,Map<String,String[]> mapProdDetails)
        {
            if(mapProdDetails == null) return null;
            Decimal dExamFee = 0;
            dTotalPrice = 0;
            String strNameByProdcutCode  = '';
            List<String> lstExamNames = new List<String>();
            List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
            for(PriceBookEntry PricebookEntryId : [select unitprice,productcode,product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode in: mapProdDetails.keySet() and isActive =: true]) 
            {
                dExamFee = 0;
                OpportunityLineItem oppLineItem = new OpportunityLineItem();
                String[] arrGlPrice = mapProdDetails.get(PricebookEntryId.productcode);
                system.debug('PricebookEntryId == '+PricebookEntryId);
                system.debug('arrGlPrice == '+arrGlPrice);
                if(PricebookEntryId.productcode == 'SHIP' && PricebookEntryId.product2.Gl_Code__c == arrGlPrice[0])
                    oppLineItem.UnitPrice = decimal.valueOf(arrGlPrice[1]);
                else if(PricebookEntryId.productcode == 'SLSTX' && PricebookEntryId.product2.Gl_Code__c == arrGlPrice[0])
                    oppLineItem.UnitPrice = decimal.valueOf(arrGlPrice[1]);
                else if(PricebookEntryId.productcode == 'MISC' && PricebookEntryId.product2.Gl_Code__c == arrGlPrice[0])
                    oppLineItem.UnitPrice = decimal.valueOf(arrGlPrice[1]);
				else if(PricebookEntryId.productcode == 'CBRHB' && PricebookEntryId.product2.Gl_Code__c == arrGlPrice[0])
                    oppLineItem.UnitPrice = decimal.valueOf(arrGlPrice[1]);                
				else if(PricebookEntryId.productcode == 'FBRHB' && PricebookEntryId.product2.Gl_Code__c == arrGlPrice[0])
                    oppLineItem.UnitPrice = decimal.valueOf(arrGlPrice[1]);                
                else
                    oppLineItem.UnitPrice = PricebookEntryId.unitprice;
                
                oppLineItem.OpportunityId = oppId;
                if(arrGlPrice.size() > 1 && arrGlPrice[2] != null)
                    oppLineItem.Description = arrGlPrice[2];
                oppLineItem.PricebookEntryId = PricebookEntryId.Id;
                oppLineItem.Quantity = 1;
                system.debug('3 dExamFee == '+dExamFee);
                
                dTotalPrice += oppLineItem.UnitPrice;
                system.debug('&&&&:'+dTotalPrice);
                lstOppLineItems.add(oppLineItem);
                
            }    
            system.debug('lstOppLineItems == '+lstOppLineItems);            
            insert lstOppLineItems;
            
            return dTotalPrice;
    }   
    
   
    
    public static Contract checkContractExist(Map<String,String[]> mapProdDetails,Id accounID)
    {
        ID recTypeID = null;
        if(mapProdDetails.containsKey('CBR') || mapProdDetails.containsKey('CBRNM') || mapProdDetails.containsKey('CBR2A'))
                recTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
        try
        {
            system.debug('accounID == '+accounID);
            system.debug('recTypeID == '+recTypeID);
            Contract obj = [select id,recordtypeID,enddate from Contract where recordTypeID =: recTypeID and accountID =: accounID and (Status =:'Activated' or Status =: 'Activated ( Auto-Renew )') limit 1];
            return obj;
        }
        catch(exception ex)
        {
            return null;
        }
        
   
    }
    
    public static void createExamAttempts(Map<String,String[]> mapProdDetails,Id contID,Id accID,Id oppId,boolean bCreateContratcs)
    {
       List<Candidate_Requirement__c> lstCandReqs;
       Contract objContract;
       Id contractID;
       boolean bISIcBRR = (mapProdDetails.containsKey('CBR') || mapProdDetails.containsKey('CBRNM') || mapProdDetails.containsKey('CBR2A'));
       if(bISIcBRR)
            objContract = checkContractExist(mapProdDetails,accID);
        system.debug('objCon==='+objContract);
        system.debug('bISIcBRR==='+bISIcBRR);
        contractID = objContract != null ? objContract.Id : null;
       if(!bISIcBRR || (objContract != null && objContract.EndDate < System.today()) || (bISIcBRR && objContract == null))
            contractID = CreateContract(accID,mapProdDetails,oppId);
       system.debug('Contract Id == '+contractId);
      lstCandReqs = createCandidateRequirements(contractID,mapProdDetails,oppId);
     
       system.debug('lstCandReqs == '+lstCandReqs);
       
       if(lstCandReqs == null)
       {
            lstCandReqs = [select id,name from Candidate_Requirement__c where Candidate_Commitment__c =: contractID];
       }
      
        list<Exam_Sites__c> lstExamSites = new List<Exam_Sites__c>();
        
        try
        {

           updateids__c recIds = updateids__c.getInstance('ICBRR');
           string str = recIds.Record_id__c;
           lstExamSites = [Select id,Name,Exam__r.Exam__c from Exam_Sites__c where id =: str];
                      
        }
        catch(exception ex)
        {
            lstExamSites = null;
        }
       if(bISIcBRR)
            registerExam(lstExamSites,contID,lstCandReqs,contractID,oppId);
        
    }
    
    public static ID CreateContract(ID accID,Map<String,String[]> mapProdDetails,ID oppId)
    {
        Contract objContract = new Contract();
        objContract.accountId = accID;
        objContract.Opportunity__c = oppId;
        objContract.StartDate = system.today();
        system.debug('CreateContract == '+mapProdDetails);
        if(mapProdDetails.containsKey('FCBR') || mapProdDetails.containsKey('FBRNM'))
        {
            objContract.recordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FBR Program');
            objContract.ContractTerm  = 6;
        }
        else if(mapProdDetails.containsKey('CBR') || mapProdDetails.containsKey('CBRNM') || mapProdDetails.containsKey('CBR2A'))
        {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
            objContract.ContractTerm  = 9;
        }
        insert objContract;  
    system.debug('objContract == '+objContract);        
        return objContract.Id;
      
    }
    
    public static List<Candidate_Requirement__c> createCandidateRequirements(Id contractID,Map<String,String[]> mapProdDetails,id oppId)
    {
        
        //id oppID = [SELECT Opportunity__c FROM contract WHERE id = :contractID LIMIT 1].Opportunity__c ;
        string email = [SELECT Shipping_E_mail__c FROM opportunity WHERE id = :oppID LIMIT 1].Shipping_E_mail__c ;
        List<Candidate_Requirement__c> lstCandReq = new List<Candidate_Requirement__c>();
        Candidate_Requirement__c objCandReq;
    
        Integer iCount = 1;
        for(Integer i = 0; i <iCount; i++)
        {
            objCandReq = new Candidate_Requirement__c();  
            objCandReq.Candidate_Commitment__c = contractID;
            objCandReq.Candidate_Email__c = email ;
            if(mapProdDetails.containsKey('FCBR') || mapProdDetails.containsKey('FBRNM'))
                    objCandReq.Name = 'Pass FBR';
            else if(mapProdDetails.containsKey('CBR') || mapProdDetails.containsKey('CBRNM') || mapProdDetails.containsKey('CBR2A') )
                    objCandReq.Name = 'Pass ICBR';
            lstCandReq.add(objCandReq);
            
        }
        
        if(lstCandReq.size() > 0)
            insert lstCandReq;    
      
        return lstCandReq;
    }
    
    public static void registerExam(List<Exam_Sites__c> lstExamSites,Id contID,List<Candidate_Requirement__c> lstCandReqs,id ContractID,Id oppId)
        {
            Exam_Attempt__c objAttempt = null;
            Map<String,Id> mapCandIds = new Map<String,Id>();
            
            for(Candidate_Requirement__c obj: lstCandReqs)
            {
                mapCandIds.put(obj.Name,obj.Id);
            }
            List<Exam_Attempt__c> lstExamApptempts = new List<Exam_Attempt__c>();
            system.debug('mapCandIds == '+mapCandIds);
            for(Exam_Sites__c objExamSite : lstExamSites)
            {
                objAttempt = new Exam_Attempt__c();
                objAttempt.Exam_Site__c = objExamSite.Id;
                objAttempt.Member__c = contID;
                String strExamName = '';
                objAttempt.Candidate_Commitment__c = ContractID;
                objAttempt.Opportunity__c = oppId;
                objAttempt.Candidate_Requirement__c = mapCandIds.get('Pass ICBR');
                lstExamApptempts.add(objAttempt);
            }
            system.debug('objAttempt == '+objAttempt);
            if(lstExamApptempts.size() > 0)
                insert lstExamApptempts;
            
        }
    


}