public class opportunityTriggerUtils
    {
        public static boolean bIsRecursive = false;
        public static boolean bIsRecursiveForOpps = false;
        public static boolean bIsRecursiveForRenewOpps = false;
        public static boolean bUpdateEA = false;
        public static boolean bActivateCons = false;
        public static boolean bAutoRenew = false;
        public static Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
        public static Id frmRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
        public static Id erpRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
        public static Id fbrRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FBR Program');
        public static Id icbrrRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
        public static Id WileyRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Wiley Bookstore');

        
        private static Contract createContract(Opportunity opp,Date startDate,Id memberRecordType,String strStatus,string strMemberShipType,integer iMonths)
        {
            Contract objContract = new Contract();
            objContract.status = strStatus;
            objContract.accountId = opp.accountId;
            objContract.Opportunity__c = opp.Id;
            objContract.StartDate = startDate;
            objContract.ContractTerm  = iMonths;
            objContract.Membership_Type__c = strMemberShipType;
            objContract.recordTypeID = memberRecordType;
            return objContract; 
        
        }
       
        public static void extendWiley(map<ID, Opportunity> wileyOpps, Map < Id, OpportunityLineItem > wileyOppItems) {
            
            List<ID> draftContractIDs = new List<ID>();
            MAP<ID,Opportunity> mapAcctIds = new MAP<ID,Opportunity>();
            for(Opportunity opp :wileyOpps.values()) {
                mapAcctIds.put(opp.AccountId, Opp);
            }            
            system.debug('mapAcctIds:' + mapAcctIds);
            
            List<Contract> lstContractWiley = [select id,status,recordTypeId,Enddate,Opportunity__c,ContractTerm,AccountId from contract where recordTypeId =: wileyRecordTypeID and (status =: 'Activated' or status =: 'Activated ( Auto-Renew )' or status =: 'Draft') and accountId in :mapAcctIds.keySet()];

            MAP<ID,Contract> mapContIds = new MAP<ID,Contract>();
            for(Contract con :lstContractWiley) {
                mapContIds.put(con.AccountId, con);
            }            
            system.debug('mapContIds:' + mapContIds);
            
            List<Contract> newContracts = new List<Contract>();
            List<Contract> draftContracts = new List<Contract>();
            List<Contract> updateContracts = new List<Contract>();
            List<ID> lstDraftIDS = new List<ID>();
            
            for(Opportunity opp :wileyOpps.values()) {
                Contract con = mapContIds.get(opp.AccountId);
                OpportunityLineItem lineItem = wileyOppItems.get(opp.Id);
                
                if(lineItem != NULL) {
                    Integer quantity = Integer.valueOf(lineItem.Quantity);
                    if(con != null && con.status == 'Draft') {
                        con.ContractTerm = quantity;
                        con.Opportunity__c = opp.Id;
                        draftContracts.add(con);
                        lstDraftIDS.add(opp.Id);
                    } else if(con != null && con.status != 'Draft') {
                        con.ContractTerm+=quantity;
                        con.Opportunity__c = opp.Id;
                        updateContracts.add(con);
                    } else {
                        Contract objWContract = new Contract();
                        objWContract.Name = 'JWiley';
                        //objWContract.CustomerSigned = contID;
                        objWContract.accountId = opp.AccountId;
                        objWContract.Opportunity__c = opp.Id;
                        objWContract.StartDate = system.today();
                        objWContract.ContractTerm = quantity;
                        objWContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Wiley Bookstore');
                        newContracts.add(objWContract);
                        lstDraftIDS.add(opp.Id);
                    }
                }
            }
            
            system.debug('draftContracts:' + newContracts);
            system.debug('newContracts:' + newContracts);
            system.debug('updateContracts:' + updateContracts);
            
            if(newContracts != null && newContracts.size() > 0) {
                insert newContracts;
            }
            
            List<Contract> lstActContractWiley = [select id,status,recordTypeId,Enddate,Opportunity__c,ContractTerm from contract where recordTypeId =: wileyRecordTypeID and status =: 'Draft' and accountId in :mapAcctIds.keySet() and Opportunity__c in :lstDraftIDS];
            system.debug('lstActContractWiley:' + lstActContractWiley);
            
            if(lstActContractWiley != null && lstActContractWiley.size() > 0) {
                for(Contract con :lstActContractWiley) {
                    con.Status = 'Activated';
                }
                system.debug('lstActContractWiley:' + lstActContractWiley);
                update lstActContractWiley;
            }
            update updateContracts;
        }
        
        public static void provisionEBook(map<ID, Opportunity> eBookOpps, String eBookType) {

            List<eBook_Key__c> lstKeysUsed = [select Id, Key__c, Opportunity__c from eBook_Key__c where Type__c = :eBookType and Opportunity__c != null and Opportunity__c in :eBookOpps.keySet()];
            MAP<Id,eBook_Key__c> mapEBookKeysUsed = new MAP<Id,eBook_Key__c>();
            for(eBook_Key__c ebk :lstKeysUsed) {
                mapEBookKeysUsed.put(ebk.Opportunity__c,ebk);
            }
            
            List<eBook_Key__c> lstUpdateKeys = new List<eBook_Key__c>();
            List<eBook_Key__c> lstKey = [select Id, Key__c, Opportunity__c from eBook_Key__c where Type__c = :eBookType and Opportunity__c = null];
            Integer getCount = 0;
            
            system.debug('provisionEBook:' + eBookOpps);
            for(Opportunity opp :eBookOpps.values()) {
                
                if(lstKey != null && lstKey.size() > 0 && getCount < lstKey.size() && mapEBookKeysUsed.get(opp.Id) == null) {
                    lstKey[getCount].Opportunity__c = opp.Id;
                    lstKey[getCount].Member_EMail__c = opp.Shipping_E_mail__c;
                    lstUpdateKeys.add(lstKey[getCount]);
                    getCount++;
                    system.debug('Found eBook:' + getCount);
                }
                
            }
            update lstUpdateKeys;
            
        }
        
        
       //If Opportunity stage name is closed and Renew_Membership__c is TRUE.
   public static void updteRenewContracts(Set<Id> setOpps,Set<Id> setAccountIds,Map<Id,Set<String>> mapProdCodesWithAccount,opportunity opp)
    { 
        bIsRecursiveForRenewOpps = true;
        id memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
        Map<Id,String> mapProdCodesForMemberShip = new Map<Id,String>();
        system.debug('mapProdCodesWithAccount == '+mapProdCodesWithAccount);
        for(Id objId : mapProdCodesWithAccount.keySet())
        {
            Set<String> setProdCodes = mapProdCodesWithAccount.get(objID);
            system.debug('setProdCodes == '+setProdCodes);
            if(setProdCodes.Contains('AFREE'))
                mapProdCodesForMemberShip.put(objId,'Affiliate');
            else if(setProdCodes.Contains('MEMI'))
                mapProdCodesForMemberShip.put(objId,'Individual');
            else if(setProdCodes.Contains('MEMS'))
                mapProdCodesForMemberShip.put(objId,'Student');
            else if(setProdCodes.Contains('MEMC'))
                  mapProdCodesForMemberShip.put(objId,'Individual');
            else if(setProdCodes.Contains('MEMF'))
                mapProdCodesForMemberShip.put(objId,'Individual');     
        }
        List<Contract> lsNewContracts = new List<Contract>();
        Set<Contract> setUpdatingContracts = new Set<Contract>();
        boolean bIsOneContractActive = false;
        boolean bHasDraftContract = false;
        List<Contract> lstCons = [select id,recordtypeId,Status ,startdate,enddate,ContractTerm,Membership_Type__c,accountId,Opportunity__c from contract where accountId in: setAccountIds and Status != 'Canceled'];
        Map<Id,Contract> mapActivatedCon = new Map<Id,Contract>();
        for(Contract con : lstCons)
        {
            if(con.recordTypeID == memRecordType && (con.Status == 'Activated' || con.Status == 'Activated ( Auto-Renew )')){
                mapActivatedCon.put(con.accountId,con);
                 bIsOneContractActive = true;}
            else if(con.recordTypeID == memRecordType && con.Status == 'Draft')
                bHasDraftContract = true;

        }
        boolean bIsExpired = false;
        for(Contract objContract : lstCons)
        {
            

            system.debug('mapProdCodesForMemberShip == '+mapProdCodesForMemberShip);
            system.debug('objContract == '+objContract);
            boolean bHasActivatedContract = false;
            Contract obJActivatedontract = new Contract();
            if(mapActivatedCon.containsKey(objContract.accountId))
            {   
                bHasActivatedContract = true;
                obJActivatedontract = mapActivatedCon.get(objContract.accountId);
            }

            if(objContract.status == 'Draft' && objContract.recordTypeID == WileyRecordTypeID && setOpps.contains(objContract.Opportunity__c)){
            
                objContract.status = 'Activated ';
                setUpdatingContracts.add(objContract);
            }

            if(objContract.status == 'Draft' && (objContract.recordTypeID == frmRecordTypeID || objContract.recordTypeID == erpRecordTypeID || objContract.recordTypeID == fbrRecordTypeID ||objContract.recordTypeID == icbrrRecordTypeID) && setOpps.contains(objContract.Opportunity__c))
            {
                objContract.status = 'Activated ( Auto-Renew )';
                objContract.StartDate = system.today();
                setUpdatingContracts.add(objContract);
            }
            else if(mapProdCodesForMemberShip.size() > 0 &&  objContract.status == 'Draft' && objContract.recordTypeID == memRecordType && !bHasActivatedContract && setOpps.contains(objContract.Opportunity__c))
            {
               
                if(opp.Auto_Renew__c|| objContract.Membership_Type__c == 'Affiliate') objContract.status ='Activated ( Auto-Renew )';
                else objContract.status ='Activated';
                objContract.StartDate = system.today();
               setUpdatingContracts.add(objContract);
               
            }
            else if(mapProdCodesForMemberShip.size() > 0 && objContract.status == 'Draft' && objContract.recordTypeID == memRecordType && bHasActivatedContract && obJActivatedontract.Membership_Type__c == 'Affiliate' && setOpps.contains(objContract.Opportunity__c))
            {
                 system.debug('4 objContract == '+objContract);
                obJActivatedontract.status = 'Canceled';
                objContract.status = 'Activated';
                objContract.StartDate = system.today();
                if(opp.Auto_Renew__c) objContract.status ='Activated ( Auto-Renew )';
                setUpdatingContracts.add(objContract);
                setUpdatingContracts.add(obJActivatedontract);
                
            }
            else if(mapProdCodesForMemberShip.size() > 0)
            {
                system.debug('3 objContract == '+objContract);
                //objContract.Enddate >= system.today() &&

                if( objContract.recordTypeID == memRecordType && objContract.Membership_Type__c == mapProdCodesForMemberShip.get(objContract.accountId) &&(objContract.Status == 'Activated'||objContract.Status == 'Activated ( Auto-Renew )')){
                    system.debug('1 objContract == '+objContract);
           
                    objContract.ContractTerm = objContract.ContractTerm + 12;
                    if(opp.Auto_Renew__c) objContract.status ='Activated ( Auto-Renew )';
                    setUpdatingContracts.add(objContract);
                    bIsOneContractActive = true;
                }
                else if(objContract.Enddate < system.today() && objContract.recordTypeID == memRecordType  && objContract.Status == 'Expired' && !bIsOneContractActive && mapProdCodesForMemberShip.get(objContract.accountId)!='Affiliate' && !bIsExpired)
                {
     
                  system.debug('7 objContract == '+objContract);
                    setUpdatingContracts.add(objContract);
                    bIsExpired = true;
                    Contract newCon = createContract(opp,system.today(),memRecordType,'Draft',mapProdCodesForMemberShip.get(objContract.accountId),12);
             
                    lsNewContracts.add(newCon);
                }
                if((objContract.Membership_Type__c != mapProdCodesForMemberShip.get(objContract.accountId)) && objContract.recordTypeID == memRecordType && objContract.Enddate >= system.today() && mapProdCodesForMemberShip.get(objContract.accountId)!='Affiliate' && (objContract.Status == 'Activated'||objContract.Status == 'Activated ( Auto-Renew )')){

                    
                     system.debug('2 objContract == '+objContract);

            
                    objContract.Status = 'Canceled';
                    Integer iMonthsLeftOver = 0;
                    if(objContract.Membership_Type__c == 'Affiliate') iMonthsLeftOver = 12;
                    else
                    {
                        Integer iMonthsTilDate = objContract.startDate.monthsBetween(system.today());
                        if(objContract.enddate >= system.today())
                            iMonthsLeftOver = system.today().monthsBetween(objContract.enddate);
                        else
                            iMonthsLeftOver = objContract.enddate.monthsBetween(system.today());
                        objContract.ContractTerm = iMonthsTilDate == 0 ? 1 : iMonthsTilDate;
                        if(iMonthsTilDate == 0)
                            objContract.Technically_Zero__c = true;
                    
                        iMonthsLeftOver += 12;
                    }
                    setUpdatingContracts.add(objContract);
                    Contract newCon = createContract(opp,system.today(),memRecordType,'Draft',mapProdCodesForMemberShip.get(objContract.accountId),iMonthsLeftOver);
                    lsNewContracts.add(newCon);
                    
            
                }
                
               if((opp.Cross_Check__c == true) &&(objContract.Membership_Type__c != mapProdCodesForMemberShip.get(objContract.accountId)) && objContract.recordTypeID == memRecordType && mapProdCodesForMemberShip.get(objContract.accountId)!='Affiliate' && (objContract.Status == 'Activated'||objContract.Status == 'Activated ( Auto-Renew )')){

                   Integer iMonthsLeftOver = 12;
                   system.debug('10 objContract == '+objContract);
                   Contract newCon = createContract(opp,system.today(),memRecordType,'Draft',mapProdCodesForMemberShip.get(objContract.accountId),iMonthsLeftOver);
                   lsNewContracts.add(newCon);
                    
            
                }      
            }
        }
        system.debug('New COntracts === '+lsNewContracts);
        List<Contract> upsertList = New List<Contract>();
        upsertList.addAll(setUpdatingContracts);
        upsertList.addAll(lsNewContracts);
        system.debug('All Contracts === '+upsertList);
        if(upsertList.size() > 0)
            upsert upsertList;
       try
       {
        Contract objCon = [select id,Status from contract where id in: upsertList and Status =: 'Draft'];
        if(opp.Auto_Renew__c) objCon.status ='Activated ( Auto-Renew )';
        else objCon.Status = 'Activated';
        update objCon;
        
        
            
       }
       catch(exception ex)
       {
       
       }
    }    
    public static void updateShipService(Map<Id,Opportunity> mapOppIds)
    {
        bIsRecursiveForOpps = true;
        

       
        Map<Id,oppLineWrapper> mapOppLines = new Map<Id,oppLineWrapper>();
        for(OpportunityLineItem oppLine : [select id,ProductCode,OpportunityId,Product2.Weight__c,Product2.Product_ID__c,Product2.Bookstore__c,Description,Quantity,Product2.Name,Product2.Customs_Cost__c  from OpportunityLineItem where OpportunityId in: mapOppIds.keySet()])
        {
            Opportunity opp = mapOppIds.get(oppLine.OpportunityId);
            if(oppLine.ProductCode == 'Ship')
            {   
                opp.Shipping_Serive_Selected__c = oppLine.Description;
                opp.UPS_Service_Code_For_Xml__c = getUPSCode(oppLine.Description);
                
            }
            oppLineWrapper oWrapper;
            if(mapOppLines.containsKey(oppLine.OpportunityId))
            {
                oWrapper = mapOppLines.get(oppLine.OpportunityId);
            }
            else
                oWrapper = new oppLineWrapper();

            if(oppLine.Product2.Product_ID__c != null)
            {
                if(oWrapper.Product_Codes == null)
                     oWrapper.Product_Codes =   oppLine.Product2.Product_ID__c;
                else
                     oWrapper.Product_Codes =   oWrapper.Product_Codes + ',' +oppLine.Product2.Product_ID__c;

                 if(oWrapper.Product_Names == null)
                     oWrapper.Product_Names =   oppLine.Product2.Name;
                else
                     oWrapper.Product_Names =   oWrapper.Product_Names + ',' +oppLine.Product2.Name;

                 if(oWrapper.Customs_Cost == null)
                     oWrapper.Customs_Cost =   oppLine.Product2.Customs_Cost__c;
                else
                     oWrapper.Customs_Cost =   oWrapper.Customs_Cost + ',' +oppLine.Product2.Customs_Cost__c;


                 if(oWrapper.Product_Weight == null)
                     oWrapper.Product_Weight =   oppLine.Product2.Weight__c;
                else
                     oWrapper.Product_Weight =   oWrapper.Product_Weight + oppLine.Product2.Weight__c;

               
                //oWrapper.Product_Weight = (oWrapper.Product_Weight == null ? 0 : oWrapper.Product_Weight) +  oppLine.Product2.Weight__c == null ? 0 : oppLine.Product2.Weight__c;
              
                mapOppLines.put(oppLine.OpportunityId,oWrapper);

            }

        }
        system.debug('mapOppLines :'+mapOppLines);
        for(Id oppId : mapOppLines.keySet())
        {
            Opportunity opp = mapOppIds.get(oppId);
            opp.Total_Package_Weight__c = mapOppLines.get(oppId).Product_Weight;
            opp.Product_Ids__c = mapOppLines.get(oppId).Product_Codes;
            opp.Product_Names__c = mapOppLines.get(oppId).Product_Names;
            opp.Customs_Cost__c = mapOppLines.get(oppId).Customs_Cost;
           
            

        }
        
       
    }

    public class oppLineWrapper
    {

        public string Product_Codes;
        public Decimal Product_Weight; 
        public string Product_Names;
        public string Customs_Cost;
    }

    
    public static String getUPSCode(String strDesc)
    {
        if(strDesc == null) return 'ERROR';
        if(strDesc.IndexOf('UPS Next Day Air') >= 0)
            return '1DA';
        if(strDesc.IndexOf('UPS 2nd Day Air') >= 0)
            return '2DA';
        if(strDesc.IndexOf('UPS Ground') >= 0)
            return 'GND';
        if(strDesc.IndexOf('UPS Worldwide Express')  >= 0)
            return 'ES';
        if(strDesc.IndexOf('UPS Worldwide Expedited') >= 0)
            return 'EX';
        if(strDesc.IndexOf('UPS Standard') >= 0)
            return 'ST';
        if(strDesc.IndexOf('UPS 3 Day Select') >= 0)
            return '3DS';
        if(strDesc.IndexOf('UPS Next Day Air Saver') >= 0)
            return '1DP';
        if(strDesc.IndexOf('UPS Next Day Air Early A.M.') >= 0)
            return '1DM';
        if(strDesc.IndexOf('UPS Worldwide Express Plus') >= 0)
            return 'EP';
        if(strDesc.IndexOf('UPS 2nd Day Air A.M.') >= 0)
            return '2DM';
        if(strDesc.IndexOf('UPS Saver') >= 0)
            return 'SV';
        return 'ERROR';
}

    public static void updateShippingInfo(List<Opportunity> lstOpp)
    {
        Set<Id> setAccountId = new Set<Id>();
        for(Opportunity opp : lstOpp)
            setAccountId.add(opp.accountId);
            
        Map<Id,Contact> mapContact = new Map<Id,Contact>();
        for(Contact ct : [select id,AccountId,MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet,email,firstname,lastname,Phone from contact where accountId in : setAccountId])
            mapContact.put(ct.accountId,ct);
        
        for(Opportunity oppUpdate : lstOpp)
        {
            Contact con = mapContact.get(oppUpdate.accountId);
            oppUpdate.Shipping_City__c = con.MailingCity;
            oppUpdate.Shipping_Postal_Code__c = con.MailingPostalCode;
            oppUpdate.Shipping_State__c = con.MailingState;
            oppUpdate.Shipping_Country__c = con.MailingCountry;
            oppUpdate.Shipping_E_mail__c = con.email;
            oppUpdate.Shipping_First_Name__c = con.firstname;
            oppUpdate.Shipping_Last_Name__c = con.lastname;
            oppUpdate.Shipping_Phone_No__c = con.Phone;
            oppUpdate.Shipping_Street__c = con.MailingStreet;                    
        }
        
    }
    
    public static void updateautorenew(Set<Id> accountIds)
    {
        bAutoRenew = true;
         List<Contract> lstContracts = new List<Contract>();
        List<Contact> lstContacts = [select id,KPI_Membership_Auto_Renew_Status__c from contact where accountId in: accountIds];
        for(Contact objCon : lstContacts)
        {
            objCon.KPI_Membership_Auto_Renew_Status__c = true;
            update objcon;
        }
        for(Contract objContr : [select id, Status ,RecordTypeId,accountId,Opportunity__c,ContractTerm,EndDate,startdate,Membership_Type__c from contract where  accountId in : accountIds and RecordTypeId =: memberRecordTypeID])
        {
            if(objContr.Status == 'Activated' || objContr.Status == 'Draft')
            {
                objContr.status = 'Activated ( Auto-Renew )';
                lstContracts.add(objContr);
            }
        }
        
        if(lstContracts.size() > 0)
            update  lstContracts;
       
    }

    public static void updateRegisterExamAttempts(Set < ID > setRegisterExamAttempts) {
        system.debug('* * * setRegisterExamAttempts ...'+ setRegisterExamAttempts);        
        if (setRegisterExamAttempts.size() > 0) {
            List < Exam_Attempt__c > lstExamAttempts = [select id, Section__c, Member__c, Defered__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where id in : setRegisterExamAttempts];
            update lstExamAttempts;
        }            
    }


    public static void updateExamAttempts(Set < ID > setExamAttempts,Set < ID > setUnDeferredExamAttempts)
    {
        bUpdateEA = true;
        List<Exam_Attempt__c> lstUpdateEAs = new List<Exam_Attempt__c>();
        MAP<Id, Id> mapExamAttempts = new MAP<Id, Id>();
        // logic for defering depending if it is frm1 or frm 2
         
        system.debug('* * * updateExamAttempts ...'+ setExamAttempts + ':' + setUnDeferredExamAttempts);        
        if (setExamAttempts.size() > 0) {

            List < Exam_Attempt__c > lstExamAttempts = [select id, Section__c, Member__c, Defered__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where id in : setExamAttempts and Exam_Site__r.Exam__r.Exam_Group__r.Active__c = true];
            Set < Id > setMemberIds = new Set < Id > ();
            
            for (Exam_Attempt__c objExaAttmept: lstExamAttempts) {

              mapExamAttempts.put(objExaAttmept.Id, objExaAttmept.Id);
              if (objExaAttmept.Section__c == 'FRM Part 1' || objExaAttmept.Section__c == 'ERP Exam Part I'&& objExaAttmept.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == true) {
                setMemberIds.add(objExaAttmept.Member__c);
              }
            }

            for (Exam_Attempt__c objEA: [select id, Section__c, Member__c, Defered__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where Member__c in : setMemberIds and Exam_Site__r.Exam__r.Exam_Group__r.Active__c = true]) {

              Id findEA = mapExamAttempts.get(objEA.Id);
              if ((objEA.Section__c == 'FRM Part 1' || objEA.Section__c == 'FRM Part 2' || objEA.Section__c == 'ERP Exam Part I' || objEA.Section__c == 'ERP Exam Part II') && findEA == null) {

                lstExamAttempts.add(objEA);

              }
            }
            
            system.debug('* * * setExamAttempts ...'+ lstExamAttempts);
            
            for (Exam_Attempt__c updEA: lstExamAttempts) {
                updEA.Defered__c = 'Pending';
                lstUpdateEAs.add(updEA);
            }

            update lstExamAttempts;
          }
          // logic for undeferring depending on frm1 or frm2.
 
          if (setUnDeferredExamAttempts.size() > 0) {

            List < Exam_Attempt__c > lstExamAttempts = [select id,Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Section__c, Member__c, Defered__c from Exam_Attempt__c where id in : setUnDeferredExamAttempts];
            Set < Id > setMemberIds = new Set < Id > ();
            
            for (Exam_Attempt__c objExaAttmept: lstExamAttempts) {

              mapExamAttempts.put(objExaAttmept.Id, objExaAttmept.Id);
              if (objExaAttmept.Section__c == 'FRM Part 2' || objExaAttmept.Section__c == 'ERP Exam Part II'&& objExaAttmept.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == true) {
                setMemberIds.add(objExaAttmept.Member__c);
              }
            }

            system.debug('* * * setMemberIds ...'+ setMemberIds);
            
            for (Exam_Attempt__c objEA: [select id, Section__c, Member__c, Defered__c from Exam_Attempt__c where Member__c in : setMemberIds]) {

              Id findEA = mapExamAttempts.get(objEA.Id);
              if ((objEA.Section__c == 'FRM Part 1' || objEA.Section__c == 'FRM Part 2' || objEA.Section__c == 'ERP Exam Part I' || objEA.Section__c == 'ERP Exam Part II') && findEA == null) {

                lstExamAttempts.add(objEA);

              }
            }
              
            system.debug('* * * setUnDeferredExamAttempts ...'+ lstExamAttempts);
              
            for (Exam_Attempt__c updEA: lstExamAttempts) {
                updEA.Defered__c='';
            }
            update lstExamAttempts;
          }
        }
    }