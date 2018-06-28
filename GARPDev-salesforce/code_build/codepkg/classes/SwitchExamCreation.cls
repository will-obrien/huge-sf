Public class SwitchExamCreation
{
    
    public static boolean bIsRecursiveForOpps = false;
    public static List<Exam_Attempt__c> CancelExamAttempts(Set<ID> setAccIDs,Id recordTypeId)
        {
           List<Contact> lstContact = [select id,name from contact where accountId in: setAccIDs]; 
           List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
            for(Exam_Attempt__c objEA : [select id,name,Cancelled__c from Exam_Attempt__c where Member__c in:     lstContact and Cancelled__c != true and Exam_Site__r.Exam__r.Exam_Group__r.Active__c =: true and Program__c =: recordTypeId])
            {
                objEA.Cancelled__c = true;
                lstEA.add(objEA);
            }
            if(lstEA.size() <= 0) return null;
            update lstEA;
            return lstEA;
            
            
            
        }
        
        public static void checkExamAttempts(Set<ID> setERPAccts,Set<Id> setFRMAccts,Set<Opportunity> setOpps)
        {
            bIsRecursiveForOpps = true;
            List<Exam_Attempt__c> lstExamAttempts;
            List<Contact> lstContact;
            id erpRecTypeId  = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
            id frmRecTypeId  = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
            List<Contract> lstContracts = null;
            List<ChargentSFA__Transaction__c> lstPayments = new List<ChargentSFA__Transaction__c>();
            system.debug('setERPAccts =='+setERPAccts);
            system.debug('setFRMAccts =='+setFRMAccts);
            if(setERPAccts.size() > 0)
            {
                lstContact = [select id,name from contact where accountId in: setERPAccts];
                lstExamAttempts = [select id,name,Cancelled__c,Opportunity__c,Member__c from Exam_Attempt__c where Member__c in: lstContact and Exam_Site__r.Exam__r.Exam_Group__r.Active__c != true and Program__c =: frmRecTypeId];
                system.debug('lstExamAttempts ==='+lstExamAttempts);
                if(lstExamAttempts.size() <= 0)
                    lstContracts = updateContract(setERPAccts,frmRecTypeId);
                
                List<Exam_Attempt__c> lstEAs = CancelExamAttempts(setERPAccts,frmRecTypeId);
                system.debug('lstContracts == '+lstContracts);
                system.debug('lstEAs == '+lstEAs);
                if(lstContracts!= null && lstContracts.size() > 0)
                   lstPayments =  createPaymentRecordForContract(lstContracts);
                else if(lstEAs != null && lstEAs.size() > 0)
                   lstPayments = createPaymentRecordForExamReg(lstEAs);
            }
            else if(setFRMAccts.size() > 0)
            {
                lstContact = [select id,name from contact where accountId in: setFRMAccts];
                lstExamAttempts = [select id,name,Cancelled__c,Opportunity__c,Member__c from Exam_Attempt__c where Member__c in: lstContact and Exam_Site__r.Exam__r.Exam_Group__r.Active__c != true and Program__c =: erpRecTypeId];
                if(lstExamAttempts.size() <= 0)
                    lstContracts =  updateContract(setFRMAccts,erpRecTypeId);
                system.debug('lstExamAttempts ==='+lstExamAttempts);
                List<Exam_Attempt__c> lstEAs = CancelExamAttempts(setFRMAccts,erpRecTypeId);
                system.debug('lstContracts == '+lstContracts);
                system.debug('lstEAs == '+lstEAs);
                if(lstContracts!= null && lstContracts.size() > 0)
                    lstPayments = createPaymentRecordForContract(lstContracts);
                else if(lstEAs != null && lstEAs.size() > 0)
                    lstPayments = createPaymentRecordForExamReg(lstEAs);
            }
            if(lstPayments == null) return;
            List<ChargentSFA__Transaction__c> lstClonedPayments = lstPayments.deepClone(false,false,false);
            for(ChargentSFA__Transaction__c obj : lstClonedPayments)
            {
                for(Opportunity opp : setOpps)
                {
                   
                    obj.ChargentSFA__Opportunity__c= opp.Id;
                    obj.ChargentSFA__Type__c = 'Debit';
                    obj.Id = null;
                }
            }
            insert lstClonedPayments;
            
            
            
        }
        
        public static List<Contract> updateContract(set<Id> setAccounts,Id idRecordType){
        
            List<Contract> lstContracts = new List<Contract>();
            for(Contract objContract : [select id,Opportunity__c,accountid,Opportunity_Amount__c from Contract where accountId in: setAccounts and (Status =: 'Activated' or Status =: 'Activated ( Auto-Renew )') and RecordTypeId =: idRecordType])
            {
                objContract.Status = 'Canceled';
                lstContracts.add(objContract);
            }
            if(lstContracts.size() <= 0) return null;
            update lstContracts;
            return lstContracts;
        }
        
        public static List<ChargentSFA__Transaction__c> createPaymentRecordForContract(List<Contract> lstContracts)
        {
            
            if(lstContracts == null) return null;
            Map<ID,Contract> MapOpps = new Map<ID,Contract>();
            for(Contract objCon : lstContracts)
                MapOpps.put(objCon.Opportunity__c,objCon);
            system.debug('MapOpps == '+MapOpps);
            if(MapOpps== null || MapOpps.size() <= 0) return null;
            List<ChargentSFA__Transaction__c> lstPayments = new List<ChargentSFA__Transaction__c>();
            for(Id idVal : MapOpps.keySet())
            {
                Contract objContract = MapOpps.get(idVal);
                lstPayments.add(preparePaymentDetails(objContract.Opportunity__c,null,objContract.accountid,objContract.Opportunity_Amount__c));
            
            }
            system.debug('lstPayments == '+lstPayments);
            if(lstPayments.size() <= 0) return null;
            insert lstPayments;
            return lstPayments;
        }
        public static List<ChargentSFA__Transaction__c> createPaymentRecordForExamReg(List<Exam_Attempt__c> lstEA)
        {
            if(lstEA == null) return null;
            Map<ID,Exam_Attempt__c> MapOpps = new Map<ID,Exam_Attempt__c>();
            for(Exam_Attempt__c objEA : lstEA)
                MapOpps.put(objEA.Opportunity__c,objEA);
            system.debug('MapOpps == '+MapOpps);
            if(MapOpps== null || MapOpps.size() <= 0) return null;
            Map<Id,opportunity> mapRelatedOpps = new Map<Id,Opportunity>([select id,Name,Amount,accountiD from opportunity where id in: MapOpps.keySet()]);
            List<ChargentSFA__Transaction__c> lstPayments = new List<ChargentSFA__Transaction__c>();
            for(Id idVal : MapOpps.keySet())
            {
                Exam_Attempt__c objEA = MapOpps.get(idVal);
                Opportunity opp = mapRelatedOpps.get(idVal);
                if(opp == null) continue;
                lstPayments.add(preparePaymentDetails(objEA.Opportunity__c,objEA.Member__c,opp.accountiD,opp.Amount));
            }
            system.debug('lstPayments == '+lstPayments);
            if(lstPayments.size() <= 0) return null;
            insert lstPayments;
            return lstPayments;
        }
        
        public static ChargentSFA__Transaction__c preparePaymentDetails(Id oppID,id contactId,id accID,Decimal dAmount)
        {
            ChargentSFA__Transaction__c objPayment = new ChargentSFA__Transaction__c();
           
            objPayment.ChargentSFA__Opportunity__c= oppID;
            objPayment.ChargentSFA__Response_Status__c = 'Approved';
            objpayment.ChargentSFA__Amount__c= dAmount;
            objpayment.ChargentSFA__Type__c= 'Credit';
            return objPayment;
        
        }
}