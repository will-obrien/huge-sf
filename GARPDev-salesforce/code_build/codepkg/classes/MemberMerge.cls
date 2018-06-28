public class MemberMerge {
    public Boolean showRecords{get;set;}
    public List<Content__c> cust {get;set;}

    public String processStatus {get;set;}

    public CPE_Claim__c claim1 {get;set;}
    public CPE_Claim__c claim2 {get;set;}
    
    public Contact contact1 {get;set;}
    public Contact contact2 {get;set;}

    public sfdcAppRemoter.getUserReturnData contact1Data {get;set;}
    public sfdcAppRemoter.getUserReturnData contact2Data {get;set;}
    
    public List<Account> cust1Account {get;set;}
    public List<Account> cust2Account {get;set;}    
    
    //In constructor
    
    public MemberMerge() {
        showRecords =false;         
        contact1 = new Contact();
        contact2 = new Contact();
        
        claim1 = new CPE_Claim__c();
        claim2 = new CPE_Claim__c();
        
        contact1Data = new sfdcAppRemoter.getUserReturnData();
        contact2Data = new sfdcAppRemoter.getUserReturnData();
    }
    
    public class contWrapper { 
        public Boolean selected { get; set; }
        public Contact obj { get; set; }
    }    

    public List<contWrapper> cont1Lst {get;set;}
    public List<contWrapper> cont2Lst {get;set;}
    
    public List<contWrapper> createContWrapper(List<Contact> conterienceData) {
        List<contWrapper> contLst = new List<contWrapper>();
        for(Contact cont :conterienceData) {
            contWrapper contW = new contWrapper();
            contW.obj = cont;
            contW.selected = false;
            contLst.add(contW);
        }
        return contLst;
    }    
    public class acctWrapper { 
        public Boolean selected { get; set; }
        public Account obj { get; set; }
    }    

    public List<acctWrapper> acct1Lst {get;set;}
    public List<acctWrapper> acct2Lst {get;set;}
    
    public List<acctWrapper> createAcctWrapper(List<Account> accterienceData) {
        List<acctWrapper> acctLst = new List<acctWrapper>();
        for(Account acct :accterienceData) {
            acctWrapper acctW = new acctWrapper();
            acctW.obj = acct;
            acctW.selected = false;
            acctLst.add(acctW);
        }
        return acctLst;
    }
    
    public class expWrapper { 
        public Boolean selected { get; set; }
        public Experience__c obj { get; set; }
    }    

    public List<expWrapper> exp1Lst {get;set;}
    public List<expWrapper> exp2Lst {get;set;}
    
    public List<expWrapper> createExpWrapper(List<Experience__c> experienceData) {
        List<expWrapper> expLst = new List<expWrapper>();
        for(Experience__c exp :experienceData) {
            expWrapper expW = new expWrapper();
            expW.obj = exp;
            expW.selected = false;
            expLst.add(expW);
        }
        return expLst;
    }

    public class eaWrapper { 
        public Boolean selected { get; set; }
        public Exam_Attempt__c obj { get; set; }
    }    

    public List<eaWrapper> ea1Lst {get;set;}
    public List<eaWrapper> ea2Lst {get;set;}
    
    public List<eaWrapper> createEaWrapper(List<Exam_Attempt__c> eaData) {
        List<eaWrapper> eaLst = new List<eaWrapper>();
        if(eaData != null)
            for(Exam_Attempt__c ea :eaData) {
                eaWrapper eaW = new eaWrapper();
                eaW.obj = ea;
                eaW.selected = false;
                eaLst.add(eaW);
            }
        return eaLst;
    }

    public class opWrapper { 
        public Boolean selected { get; set; }
        public Opportunity obj { get; set; }
    }    

    public List<opWrapper> op1Lst {get;set;}
    public List<opWrapper> op2Lst {get;set;}
    
    public List<opWrapper> createOpWrapper(List<Opportunity> opData) {
        List<opWrapper> opLst = new List<opWrapper>();
        if(opData != null)
            for(Opportunity op :opData) {
                opWrapper opW = new opWrapper();
                opW.obj = op;
                opW.selected = false;
                opLst.add(opW);
            }
        return opLst;
    }
     
    public class cpeWrapper { 
        public Boolean selected { get; set; }
        public CPE_Claim__c obj { get; set; }
    }    

    public List<cpeWrapper> cpe1Lst {get;set;}
    public List<cpeWrapper> cpe2Lst {get;set;}
    
    public List<cpeWrapper> createCPEWrapper(List<CPE_Claim__c> cpeData) {
        List<cpeWrapper> cpeLst = new List<cpeWrapper>();
        if(cpeData != null)
            for(CPE_Claim__c cpe :cpeData) {
                cpeWrapper cpeW = new cpeWrapper();
                cpeW.obj = cpe;
                cpeW.selected = false;
                cpeLst.add(cpeW);
            }
        return cpeLst;
    }         
    

    public class conWrapper { 
        public Boolean selected { get; set; }
        public Contract obj { get; set; }
    }    

    public List<conWrapper> con1Lst {get;set;}
    public List<conWrapper> con2Lst {get;set;}
    
    public List<conWrapper> createConWrapper(List<Contract> conData) {
        List<conWrapper> conLst = new List<conWrapper>();
        if(conData != null)
            for(Contract con :conData) {
                conWrapper conW = new conWrapper();
                conW.obj = con;
                conW.selected = false;
                conLst.add(conW);
            }
        return conLst;
    }         
        
        
    public void fetchRecords(){
        
        if(claim1.Member__c == null || claim2.Member__c == null) {
            processStatus = 'Cannot select both contacts as the destination!';
        } else {
            contact1Data = sfdcAppRemoter.fetchUserDataInside(string.valueof(claim1.Member__c)); 
            contact2Data = sfdcAppRemoter.fetchUserDataInside(string.valueof(claim2.Member__c));
            
            if(contact1Data == null || contact2Data == null) {
                
            } else {

                cont1Lst = createContWrapper(contact1Data.contactData);
                cont2Lst = createContWrapper(contact2Data.contactData);
                    
                acct1Lst = createAcctWrapper(contact1Data.accountData);
                acct2Lst = createAcctWrapper(contact2Data.accountData);
        
                exp1Lst = createExpWrapper(contact1Data.experienceData);
                exp2Lst = createExpWrapper(contact2Data.experienceData);
        
                ea1Lst = createEaWrapper(contact1Data.examAttemptData);
                ea2Lst = createEaWrapper(contact2Data.examAttemptData);
        
                op1Lst = createOpWrapper(contact1Data.opportunityData);
                op2Lst = createOpWrapper(contact2Data.opportunityData);
        
                cpe1Lst = createCPEWrapper(contact1Data.claimsData);
                cpe2Lst = createCPEWrapper(contact2Data.claimsData);
                
                con1Lst = createConWrapper(contact1Data.contractData);
                con2Lst = createConWrapper(contact2Data.contractData);
                
                showRecords = true;
                processStatus = '';
                
            }            
        }
    }    

    public void combineContacts(){    
        
        List<cpeWrapper> cpeSrcLst;
        List<cpeWrapper> cpeTargetLst;

        List<conWrapper> conSrcLst;
        List<conWrapper> conTargetLst;

        List<expWrapper> expSrcLst;
        List<expWrapper> expTargetLst;

        List<opWrapper> opSrcLst;
        List<opWrapper> opTargetLst;

        List<contWrapper> contSrcLst;
        List<contWrapper> contTargetLst;
        
        String mode = Apexpages.currentPage().getParameters().get('mode');
        system.debug('* * * Mege mode: '+mode);
        
        sfdcAppRemoter.getUserReturnData contSrc;
        sfdcAppRemoter.getUserReturnData contTarget;
        Integer recMoved = 0;
        Id cpeRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract cpeContractTarget;
        Candidate_Requirement__c cpeCR;
        
        Savepoint sp = Database.setSavepoint();
        
        if(cont1Lst != null && cont1Lst.size() > 0 && cont2Lst != null && cont2Lst.size() > 0) {
            if(cont1Lst[0].selected && cont2Lst[0].selected) {
                processStatus = 'Cannot select both contacts as the destination!';
            } else if(cont1Lst[0].selected == false && cont2Lst[0].selected == false) {
                processStatus = 'Must select one destination!' + cont1Lst[0].selected + ':' + cont2Lst[0].selected;
            } else {
                 system.debug('* * * contact1Data'+contact1Data);
                if(cont1Lst[0].selected) {
                    contTarget = contact1Data;
                    contSrc = contact2Data;

                    conTargetLst = con1Lst;                   
                    conSrcLst = con2Lst;

                    cpeTargetLst = cpe1Lst;                   
                    cpeSrcLst = cpe2Lst;
                    
                    expTargetLst = exp1Lst;                   
                    expSrcLst = exp2Lst;

                    opTargetLst = op1Lst;                   
                    opSrcLst = op2Lst;

                    contTargetLst = cont1Lst;                   
                    contSrcLst = cont2Lst;

                } else {
                    contTarget = contact2Data;
                    contSrc = contact1Data;

                    conTargetLst = con2Lst;
                    conSrcLst = con1Lst;

                    cpeTargetLst = cpe2Lst;
                    cpeSrcLst = cpe1Lst;
                    
                    expTargetLst = exp2Lst;                   
                    expSrcLst = exp1Lst;

                    opTargetLst = op2Lst;                   
                    opSrcLst = op1Lst;

                    contTargetLst = cont2Lst;                   
                    contSrcLst = cont1Lst;
                    
                }
                system.debug('* * * contTarget'+contTarget + ':' + contSrc + ':' + conTargetLst + '][' + conSrcLst + ':' + conTargetLst + ':' + expSrcLst + ':' + expTargetLst + '][' + opSrcLst + ':' + opTargetLst);

                if(contTarget.contractData != null) {
                    for(Contract cont :contTarget.contractData) {
                        if(cont.RecordTypeId == cpeRecordTypeID) {
                            cpeContractTarget = cont;
                            for(Candidate_Requirement__c cr :cont.Candidate_Requirements__r) {
                                if(cr.Name=='CPE') {
                                    cpeCR = cr;
                                }
                            }
                        }
                    }
                }

                Boolean contSelected=false;
                for(contWrapper contW :contSrcLst) {
                    if(contW.selected == true) {
                        contSelected=true;
                    }
                }
                
                Boolean cpeSelected=false;
                for(cpeWrapper cpeW :cpeSrcLst) {
                    if(cpeW.selected == true) {
                        cpeSelected=true;
                    }
                }
                Boolean expSelected=false;
                for(expWrapper expW :expSrcLst) {
                    if(expW.selected == true) {
                        expSelected=true;
                    }
                }
                Boolean conSelected=false;
                for(conWrapper conW :conSrcLst) {
                    if(conW.selected == true) {
                        conSelected=true;
                    }
                }
                Boolean opSelected=false;
                for(opWrapper opW :opSrcLst) {
                    if(opW.selected == true) {
                        opSelected=true;
                    }
                }
                
                if(cpeSelected == true) {
                    if(cpeContractTarget!= null && cpeCR != null) {
                        List<CPE_Claim__c> moveCliams = new List<CPE_Claim__c>();
                        for(cpeWrapper cpeW :cpeSrcLst) {
                            if(cpeW.selected == true) {
                                cpeW.obj.Member__c = contTarget.contactData[0].Id;
                                cpeW.obj.Candidate_Requirement__c = cpeCR.Id;
                                moveCliams.add(cpeW.obj);
                                recMoved++;
                            }
                        }
                        if(mode == null || mode != 'readonly') {
                            update moveCliams;    
                        }
                        processStatus = processStatus + '\nDone Merge! CPE Credit Records Moved:' + string.valueOf(recMoved);                    
                        recMoved=0;
                    } else {
                        processStatus = processStatus + '\nCould not move CPE Credits, no target CPE Contract Requirement.';                    
                    }                    
                }

                if(expSelected) {
                    List<Experience__c> moveExp = new List<Experience__c>();
                    for(expWrapper expW :expSrcLst) {
                        if(expW.selected == true) {
                            expW.obj.Contact__c = contTarget.contactData[0].Id;
                            moveExp.add(expW.obj);
                            recMoved++;
                        }
                    }
                    if(mode == null || mode != 'readonly') {
                        update moveExp;    
                    }
                    processStatus = processStatus + '\nDone Merge! Experience Records Moved:' + string.valueOf(recMoved);                    
                    recMoved=0;                    
                }

                if(opSelected) {
                    List<Opportunity> moveOp = new List<Opportunity>();
                    for(opWrapper opW :opSrcLst) {
                        if(opW.selected == true) {
                            opW.obj.AccountId = contTarget.accountData[0].Id;
                            moveOp.add(opW.obj);
                            recMoved++;
                        }
                    }
                    List<Contract> lstCont = [select Id, Name, Opportunity__c from Contract where Opportunity__c in :moveOp];
                    Boolean bFoundCont = false;
                    if(lstCont != null && lstCont.size() > 0) {
                        bFoundCont = true;                            
                    }

                    List<Exam_Attempt__c> lstEA = [select Id, Name, Opportunity__c from Exam_Attempt__c where Opportunity__c in :moveOp];
                    Boolean bFoundEA = false;
                    if(lstEA != null && lstEA.size() > 0) {
                        bFoundEA = true;                            
                    }                        
                    if(bFoundCont || bFoundEA) {
                        processStatus = processStatus + '\nCound not Merge! Programs and/or Exam Registrations found on Opportunites.';                    
                    } else {
                        if(mode == null || mode != 'readonly') {
                            update moveOp;    
                        }
                        processStatus = processStatus + '\nDone Merge! Opporunity Records Moved:' + string.valueOf(recMoved);                    
                        recMoved=0;                    
                    }
                }

                // Contracts
                //processStatus = processStatus + '\rconSelected:' + conSelected + ':' + contSrc + ':' + conTargetLst + '][' + conSrcLst + ':' + conTargetLst + ':' + expSrcLst + ':' + expTargetLst + '][' + opSrcLst + ':' + opTargetLst;                    
                
                if(conSelected == true) {
                    
                    if(contTarget.accountData != null && contTarget.accountData.size() > 0) {
                        List<Contract> moveCont = new List<Contract>();
                        Set<Id> moveOpp = new Set<Id>();
                        List<Candidate_Requirement__c> moveCR = new List<Candidate_Requirement__c>();
                        //map<Id, Id> oppContract = new map<Id, id> () ;
                        
                        for(conWrapper conW :conSrcLst) {
                            if(conW.selected == true) {
                                moveCont.add(conW.obj);                            
                                moveOpp.add(conW.obj.Opportunity__c);
                                //Requirements
                                for(Candidate_Requirement__c cr :conW.obj.Candidate_Requirements__r) {
                                    moveCR.add(cr);
                                }                            
                            }
                        }
                        
                        // Check Contract in Opp match selected list - if not error
                        List<Contract> lstCheckCont = [select Id, Name, Opportunity__c from Contract where Opportunity__c in :moveOpp];
                        map<Id, Boolean> lstCheckContOK = new map<Id, Boolean> () ;
                        for(Contract con :lstCheckCont) {
                            lstCheckContOK.put(con.Id, false);
                        }
                        
                        for(Contract con :lstCheckCont) {
                            for(Contract conMove :moveCont) {
                                if(conMove.Id == con.Id) {
                                    lstCheckContOK.put(con.Id, true);
                                }
                            }
                        }
                        
                        Boolean allgood = true;
                        for(Id conId : lstCheckContOK.keySet()) {
                            if(lstCheckContOK.get(conId) == false)
                                allgood = false;
                        }
                        if(allgood == false) {
                            processStatus = processStatus + '\nCould not move Programs, Some Opportunities point to contracts not being moved.';
                        } else {
                            
                            List<Contract> inCont = new List<Contract>();
                            for(Contract cc :moveCont) {
                                Contract newCont = cc.clone(false);
                                newCont.AccountId = contTarget.accountData[0].Id;
                                newCont.CustomerSignedId = contTarget.contactData[0].Id;
                                newCont.Name = 'Merged - ' + contSrc.contactData[0].Name + ' - ' + contTarget.contactData[0].Name;
                                newCont.Status = 'Draft';
                                newCont.ContractTerm = cc.ContractTerm;
                                newCont.Membership_Type__c = cc.Membership_Type__c;
                                newCont.Clone_from__c = cc.Id;
                                inCont.add(newCont);
                                recMoved++;
                            }
                            System.debug('Clone:' + inCont);
                            if(mode == null || mode != 'readonly') {
                                insert inCont;    
                            }
                            System.debug('Clone:' + inCont);
                            processStatus = processStatus + '\nContracts Records Cloned:' + string.valueOf(recMoved); 
                            recMoved=0;
                            
                            map<String, Id> movedContracts = new map<String, Id> () ;
                            List<Contract> mapCont = [select Id, Name, Clone_from__c from Contract where Id in :inCont];
                            for(Contract mc :mapCont) {
                                movedContracts.put(mc.Clone_from__c, mc.Id);
                            }
                            
                            List<Candidate_Requirement__c> moveLstCR = [select Id, Name,Candidate_Commitment__c from Candidate_Requirement__c where id in :moveCR];
                            
                            for(Candidate_Requirement__c mcr :moveLstCR) {
                                System.debug('Change CR Contract from :' + mcr.Candidate_Commitment__c + ':' + movedContracts.get(mcr.Candidate_Commitment__c));
                                processStatus = processStatus + '\nChange CR Contract from :' + mcr.Candidate_Commitment__c + ':' + movedContracts.get(mcr.Candidate_Commitment__c);   
                                mcr.Candidate_Commitment__c = movedContracts.get(mcr.Candidate_Commitment__c);
                                recMoved++;
                            }
                            if(mode == null || mode != 'readonly') {
                                update moveLstCR;
                            }
                            processStatus = processStatus + '\nContracts Requirement Records Moved:' + string.valueOf(recMoved); 
                            recMoved=0;
                            
                            //try {
                            //} catch(exception e) {
                            //    Database.rollback(sp);
                            //  ApexPages.addMessages(e);
                            //}
                                                
                            List<Opportunity> updateOpp = [select Id, Name,AccountId from  Opportunity where Id in :moveOpp];
                            for(Opportunity opp :updateOpp) {
                                opp.AccountId = contTarget.accountData[0].Id;
                                //opp.ContractId = oppContract.get(opp.Id);
                                recMoved++;
                            }
    
                            if(mode == null || mode != 'readonly') {
                                update updateOpp;
                            }
                            processStatus = processStatus + '\nOpportunity Records Moved:' + string.valueOf(recMoved);
                            recMoved=0;                        
                            
                            List<OpportunityContactRole> moveOCR = [select Id, ContactId, OpportunityId from OpportunityContactRole where OpportunityId in :moveOpp];
                            for(OpportunityContactRole ocr :moveOCR) {
                                ocr.ContactId = contTarget.contactData[0].Id;
                                recMoved++;
                            }
                            if(mode == null || mode != 'readonly') {
                                update moveOCR;
                            }
                            processStatus = processStatus + '\nOpportunity Contact Roles Moved:' + string.valueOf(recMoved);   
                          /*  
                            List<pymt__PaymentX__c> movePay = [select Id, Name, pymt__Account__c, pymt__Opportunity__c from pymt__PaymentX__c where pymt__Opportunity__c in :moveOpp];
                            for(pymt__PaymentX__c pay :movePay) {
                                pay.pymt__Account__c = contTarget.accountData[0].Id;
                                pay.pymt__Contact__c = contTarget.contactData[0].Id;
                                recMoved++;
                            }
                            if(mode == null || mode != 'readonly') {
                                update movePay;
                            }
                            processStatus = processStatus + '\nPayment Records Moved:' + string.valueOf(recMoved);   
                            recMoved=0;
      */
                            List<Exam_Attempt__c> moveEA = [select Id, Name, Member__c, Opportunity__c, Candidate_Commitment__c from Exam_Attempt__c where Opportunity__c in :moveOpp or Candidate_Commitment__c in :movedContracts.keySet()];
                            for(Exam_Attempt__c ea :moveEA) {
                                ea.Member__c = contTarget.contactData[0].Id;
                                
                                processStatus = processStatus + '\nChange EA Contract from :' + ea.Candidate_Commitment__c + ':' + movedContracts.get(ea.Candidate_Commitment__c);   
                                
                                ea.Candidate_Commitment__c = movedContracts.get(ea.Candidate_Commitment__c);
                                recMoved++;
                            }
                            if(mode == null || mode != 'readonly') {
                                update moveEA;
                            }
                            processStatus = processStatus + '\nExam Registration Records Moved:' + string.valueOf(recMoved);  
                            recMoved=0;
                            
                            List<CPE_Claim__c> moveCliams =  [select Id, Name, Candidate_Requirement__c from CPE_Claim__c where Candidate_Requirement__c in :moveCR];
                            for(cpeWrapper cpeW :cpeSrcLst) {
                                if(cpeW.selected == true) {
                                    cpeW.obj.Member__c = contTarget.contactData[0].Id;
                                    recMoved++;
                                }
                            }
                            if(mode == null || mode != 'readonly') {                        
                                update moveCliams;
                            }
                            processStatus = processStatus + '\nCPE Credit Records Moved:' + string.valueOf(recMoved);                          
                            recMoved=0;
                            
                            recMoved = moveCont.size();
                            if(mode == null || mode != 'readonly') {
                                //delete moveCont;
                            }
                            processStatus = processStatus + '\nOld Contract Records deleted:' + string.valueOf(recMoved);                          
                            
                        }
    
                        
                    } else {
                        processStatus = processStatus + '\nCould not move Programs, no target Account.';   
                    }
                }
            }
        }
    }
}