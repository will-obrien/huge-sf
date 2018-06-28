public class contractSyncUtil
{

    public static boolean bRecursive = false;
    static id MembershipTypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    static id FRMExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
    static id ERPExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
    static id ICBRRExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
    static id FBRExamTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FBR Program');
    static id WileyTypeId = RecordTypeHelper.GetRecordTypeId('Contract','Wiley Bookstore');
    static id CPETypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');

    public static void updateContracts(Map<Id,Contract> mapAccountIds)
    {

        List<Contact> lstActiveContacts = new List<Contact>();
    List<Contract> lstContract = [select Id, Name, AccountId, Status, All_Requirements_Completed__c, Membership_Type__c, StartDate, EndDate, ActivatedDate, Opportunity__c, recordTypeId from Contract where accountId in :mapAccountIds.keySet() Order By StartDate]; 
    List<Opportunity> lstOpportunityEligible = [SELECT Id, Name, AccountId, Eligible_for_Membership_Extension__c FROM Opportunity where AccountId in :mapAccountIds.keySet() and StageName = 'Closed Won' and Eligible_for_Membership_Extension__c = true]; 
    List<Candidate_Requirement__c> lstCandidateRequirement = [select Id, Name, RecordTypeID, Status__c, Certificate_Sent_Date__c, Date_of_Failed_Review__c , Date_of_Ready_for_Review__c, Date_of_Completion__c, Candidate_Commitment__c, Approved_Credits__c, Candidate_Commitment__r.StartDate  from Candidate_Requirement__c where Candidate_Commitment__c in :lstContract];
    
    List<Contact> lstContacts = new List<Contact>();
    for(Contact objContact : [select id,KPI_Member__c,Membership_Type__c,CVent_Contact_Type__c,KPI_Membership_Since__c,
                              KPI_Membership_Expiration_Date__c,KPI_Membership_Payment_Lapsed_Months__c,KPI_Membership_Payment_Status__c,
                              KPI_Membership_Source__c,KPI_Membership_Original_Business_Type__c,KPI_Membership_Renewal_Type__c,
                              KPI_Membership_Business_Type__c,KPI_Membership_Renewal_Count__c,KPI_Membership_Original_Type__c,
                              KPI_FRM_Resume_Program_Requirement_ID__c, KPI_ERP_Resume_Program_Requirement_ID__c,
                              KPI_FRM_Certified_Date__c,KPI_FRM_Certified_Year__c,KPI_FRM_Certified__c,KPI_FRM_Candidate__c,
                              KPI_FRM_Holder__c,KPI_FRM_Candidate_Payment_Lapsed_Months__c,KPI_FRM_Candidate_Payment_Status__c,
                              KPI_FRM_Candidate_Business_Type__c,KPI_ERP_Certified_Date__c,KPI_ERP_Certified_Year__c,
                              KPI_ERP_Certified__c,KPI_ERP_Candidate__c,KPI_ERP_Holder__c,KPI_ERP_Candidate_Payment_Lapsed_Months__c,
                              KPI_ERP_Candidate_Payment_Status__c,KPI_ERP_Candidate_Business_Type__c,KPI_ICBRR_Participant__c,
                              KPI_FBR_Participant__c,KPI_CPE_Participation__c,KPI_CPE_Current_Cycle__c,KPI_CPE_Credits__c,
                              KPI_CPE_Last_Completed_Cycle__c,KPI_CPE_Requirement_Status__c,CPE_Current_Program_Requirement__c,accountId, 
                              Email_Member_Update__c from contact where accountId in: mapAccountIds.keySet()])
    {
     
		objContact.KPI_FRM_Resume_Program_Requirement_ID__c=null;
        objContact.KPI_ERP_Resume_Program_Requirement_ID__c=null;
            
        objContact.KPI_FRM_Certified_Date__c = null;
        objContact.KPI_FRM_Certified_Year__c = null;
        objContact.KPI_FRM_Certified__c=false;
        objContact.KPI_FRM_Candidate__c=false;
        objContact.KPI_FRM_Holder__c=false;   
        objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = null;
        objContact.KPI_FRM_Candidate_Payment_Status__c = null;         
        objContact.KPI_FRM_Candidate_Business_Type__c = null;
        
        objContact.KPI_ERP_Certified_Date__c = null;
        objContact.KPI_ERP_Certified_Year__c = null;
        objContact.KPI_ERP_Certified__c=false;
        objContact.KPI_ERP_Candidate__c=false;
        objContact.KPI_ERP_Holder__c=false;   
        objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = null;
        objContact.KPI_ERP_Candidate_Payment_Status__c = null;                                         
        objContact.KPI_ERP_Candidate_Business_Type__c = null;
        
        objContact.KPI_ICBRR_Participant__c = false;
        //objContact.KPI_ICBRR_Result__c = null;
        objContact.KPI_FBR_Participant__c = false;
        
        objContact.KPI_CPE_Participation__c = false;
        objContact.KPI_CPE_Current_Cycle__c = null;
        objContact.KPI_CPE_Credits__c = null;
        objContact.KPI_CPE_Last_Completed_Cycle__c = null;
        objContact.KPI_CPE_Requirement_Status__c = null;
        objContact.CPE_Current_Program_Requirement__c = null;

		objCOntact.KPI_J_Wiley__c = false;
        objContact.KPI_Member__c = false;
        objContact.Membership_Type__c = null;
        objContact.CVent_Contact_Type__c = 'Non-Member';
        objContact.KPI_Membership_Since__c = null;
        objContact.KPI_Membership_Expiration_Date__c = null;
        objContact.KPI_Membership_Payment_Lapsed_Months__c = null;
        objContact.KPI_Membership_Payment_Status__c = null;                         
        objContact.KPI_Membership_Source__c = null;
        objContact.KPI_Membership_Original_Business_Type__c = null;
        objContact.KPI_Membership_Original_Source__c = null;
        objContact.KPI_Membership_Renewal_Type__c = null;
        objContact.KPI_Membership_Business_Type__c = null;
        objContact.KPI_Membership_Renewal_Count__c = null;    
        objContact.KPI_Membership_Original_Type__c = null;            
        
        
        
        List<Contract> contracts = new List<Contract>();
        
        
        String renewStatusLevel='';
        Boolean userComp = false;
        Boolean userPay=false;
        Integer renewalCount = 0;
        String userType = '';
        Integer frmCnt=0;
        Integer frmCanceledCnt=0;
        Integer erpCnt=0;
        Integer erpCanceledCnt=0;
        Integer memCnt=0;
        Contract lastContract=null;
        Contract thisContract=null;
		Contract firstContract = null;
        Date memberSinceContract=null;
        // Contracts are in Start Date Order!!
        for(Contract con : lstContract) {
            
            if(objContact.accountId != con.AccountId)
                continue;
            
            if(firstContract==null) {
                firstContract = con;
                objContact.Date_Joined__c = con.StartDate;
            }
            
            Boolean foundDupe=false;
            for(Contact conLook :lstContacts) {
                if(conLook.Id == objContact.Id) {
                    foundDupe=true;
                    break;
                }
            }
            if(foundDupe)
                continue;
            
            if(con.recordTypeId == MembershipTypeId)
                thisContract=con;
            
            Boolean currentCPE=false;

            if(con.status.indexof('Canceled') > -1) {                
                if(con.recordTypeId == FRMExamTypeId || con.recordTypeId == ERPExamTypeId) {
                    if(con.recordTypeId == FRMExamTypeId) {
                        frmCanceledCnt++;
                        objContact.KPI_FRM_Certified_Date__c = null;
                        objContact.KPI_FRM_Certified_Year__c = null;
                        objContact.KPI_FRM_Certified__c=false;
                        objContact.KPI_FRM_Candidate__c=false;
                        objContact.KPI_FRM_Holder__c=false;   
                        objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = null;
                        objContact.KPI_FRM_Candidate_Payment_Status__c = null;       
                        objContact.KPI_FRM_Resume_Status__c = null;
                        objContact.KPI_FRM_Resume_Status_Date__c = null;
                        objContact.KPI_FRM_Resume_Certificate_Sent_Date__c = null;
                    }
                    if(con.recordTypeId == ERPExamTypeId) {
                        erpCanceledCnt++;
                        objContact.KPI_ERP_Certified_Date__c = null;
                        objContact.KPI_ERP_Certified_Year__c = null;
                        objContact.KPI_ERP_Certified__c=false;
                        objContact.KPI_ERP_Candidate__c=false;
                        objContact.KPI_ERP_Holder__c=false;   
                        objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = null;
                        objContact.KPI_ERP_Candidate_Payment_Status__c = null;               
                        objContact.KPI_ERP_Resume_Status__c = null;
                        objContact.KPI_ERP_Resume_Status_Date__c = null;
                        objContact.KPI_ERP_Resume_Certificate_Sent_Date__c = null;                        
                    }
                }
                if(con.recordTypeId == CPETypeId) {
                    Candidate_Requirement__c lastCR = new Candidate_Requirement__c();
                    for(Candidate_Requirement__c cr : lstCandidateRequirement) {
                        if(cr.Candidate_Commitment__c == con.Id) {
                            if(cr.Name == 'CPE') {
                                objContact.KPI_CPE_Requirement_Status__c = 'Pending';
                                if(cr.Status__c == 'Completed') {
                                    objContact.KPI_CPE_Last_Completed_Cycle__c = String.valueOf(cr.Candidate_Commitment__r.StartDate.year()) + '/' + String.valueOf(cr.Candidate_Commitment__r.StartDate.year()+1);
                                    if((cr.Candidate_Commitment__r.StartDate.year()+2) == Date.today().year() || (cr.Candidate_Commitment__r.StartDate.year()+3) == Date.today().year()) {  
                                        lastCR = cr;
                                        objContact.KPI_CPE_Requirement_Status__c = 'In Good Standing';                                                    
                                    }
                                }                                    
                            } 
                        }                            
                    } 
                    if(lastCR != null && lastCR.Status__c != 'Completed') {
                        objContact.KPI_CPE_Requirement_Status__c = 'Lapsed';
                    }
                }
                
            }    
            // Active Contracts            
            if(con.status.indexof('Activated') > -1 || con.status.indexof('Completed') > -1) {
                                
                system.debug('* * * Active Contract:' + con.id + ':' + con.recordTypeId);
                
                if(con.recordTypeId == MembershipTypeId) {

                    if(lastContract==null || (lastContract != null && lastContract.status.indexof('Canceled') == -1))
                        memberSinceContract = con.StartDate;
                    
                    system.debug('* * * Member:' + con.Membership_Type__c);
                    objContact.KPI_Member__c = true;
                    objContact.Membership_Type__c = con.Membership_Type__c;
                    if(con.Membership_Type__c == 'Individual') {
                        objContact.CVent_Contact_Type__c = 'Member';
                    }
                    objContact.KPI_Membership_Since__c = con.StartDate;
                    objContact.KPI_Membership_Expiration_Date__c = con.EndDate;
                }

                if(con.recordTypeId == WileyTypeId) {    
                    system.debug('* * * Wiley:' + con.Membership_Type__c);
                    objContact.KPI_J_Wiley__c = true;
                }
                
                
                if(con.recordTypeId == CPETypeId) {
                    currentCPE=true;
                    if(con.StartDate != null)
                    {
                        objContact.KPI_CPE_Current_Cycle__c = String.valueOf(con.StartDate.year()) + '/' + String.valueOf(con.StartDate.year()+1);
                        if(con.StartDate.year() <= Date.today().year()) {
                            objContact.KPI_CPE_Participation__c = true;
                        }
                    }
                }
                
                if(con.recordTypeId == FRMExamTypeId || con.recordTypeId == ERPExamTypeId || con.recordTypeId == CPETypeId) {
        
                    system.debug('* * * FRM/ERP:' + con.All_Requirements_Completed__c);
                                 
                    Date lastDate = null;
                    Boolean passNotDone = false;
                    Candidate_Requirement__c lastCR = new Candidate_Requirement__c();
                    Id examRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Exam');
                    Id jobRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Job Experience');
                    
                    for(Candidate_Requirement__c cr : lstCandidateRequirement) {
                                                
                        if(cr.Candidate_Commitment__c == con.Id) {

                            system.debug('* * * Candidate_Requirement__c?:' + cr.Name + ':' + cr.Id + ':' + cr.Candidate_Commitment__c + ':' + con.Id + ':' + cr.Name + ':' + cr.Status__c + ':' + cr.Date_of_Completion__c + ':' + cr.RecordTypeID);
                            //if(cr.Name.toLowerCase().indexof('pass') > -1 && cr.Status__c != 'Completed')
                            if(cr.RecordTypeID == examRecordTypeID && cr.Status__c != 'Completed')
                                passNotDone=true;
                                
                            if(cr.Status__c == 'Completed' && (lastDate == null || cr.Date_of_Completion__c >= lastDate)) {
                                lastDate = cr.Date_of_Completion__c; 
                            }
                            
                             if(cr.Name == 'CPE') {
                                 if(currentCPE)
                                    objContact.CPE_Current_Program_Requirement__c = cr.Id;
                                 objContact.KPI_CPE_Credits__c = cr.Approved_Credits__c;
                             }
                            
                            if(cr.RecordTypeID == jobRecordTypeID && con.recordTypeId == FRMExamTypeId) {
            					objContact.KPI_FRM_Resume_Status__c = cr.Status__c;
                                objContact.KPI_FRM_Resume_Program_Requirement_ID__c = cr.Id;
                                if(cr.Status__c == 'Completed' && cr.Date_of_Completion__c != null)
                                    objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Completion__c;
                                if(cr.Status__c == 'Ready For Review' && cr.Date_of_Ready_for_Review__c != null)
                                    objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Ready_for_Review__c;
                                if(cr.Status__c == 'Failed Review' && cr.Date_of_Failed_Review__c != null)
                                    objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Failed_Review__c;
                                if(cr.Certificate_Sent_Date__c != null)
                                    objContact.KPI_FRM_Resume_Certificate_Sent_Date__c = cr.Certificate_Sent_Date__c;
                            }
                            
                            if(cr.RecordTypeID == jobRecordTypeID && con.recordTypeId == ERPExamTypeId) {
                            	objContact.KPI_ERP_Resume_Program_Requirement_ID__c=cr.Id;
                                objContact.KPI_ERP_Resume_Status__c = cr.Status__c;
                                if(cr.Status__c == 'Completed' && cr.Date_of_Completion__c != null)
                                    objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Completion__c;
                                if(cr.Status__c == 'Ready For Review' && cr.Date_of_Ready_for_Review__c != null)
                                    objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Ready_for_Review__c;
                                if(cr.Status__c == 'Failed Review' && cr.Date_of_Failed_Review__c != null)
                                    objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Failed_Review__c;
                                if(cr.Certificate_Sent_Date__c != null)
                                    objContact.KPI_ERP_Resume_Certificate_Sent_Date__c = cr.Certificate_Sent_Date__c;
                            }
                                    

                        }
                    }
                    
                    system.debug('* * * passNotDone:' + passNotDone + ':' + lastDate);

                    system.debug('* * * RecordTypes:' + con.recordTypeId + ':' + FRMExamTypeId + ':'+ ERPExamTypeId);

                    if(con.All_Requirements_Completed__c) {
                        if(con.recordTypeId == FRMExamTypeId && lastDate != null) {
                            system.debug('* * * In 1');
                            objContact.KPI_FRM_Certified_Date__c = lastDate;
                            objContact.KPI_FRM_Certified_Year__c = string.valueof(lastDate.year());
                            objContact.KPI_FRM_Certified__c=true;
                            objContact.KPI_FRM_Candidate__c=false;
                            objContact.KPI_FRM_Holder__c=false;
                        }
                        if(con.recordTypeId == ERPExamTypeId && lastDate != null) {
                            system.debug('* * * In 2');
                            objContact.KPI_ERP_Certified_Date__c = lastDate;   
                            objContact.KPI_ERP_Certified_Year__c = string.valueof(lastDate.year());    
                            objContact.KPI_ERP_Certified__c=true;
                            objContact.KPI_ERP_Candidate__c=false;
                            objContact.KPI_ERP_Holder__c=false;
                        }   
                    } else {
                        if(con.recordTypeId == FRMExamTypeId) {
                            system.debug('* * * In 3');
                            objContact.KPI_FRM_Certified__c=false;
                            if(passNotDone) {
                                objContact.KPI_FRM_Holder__c=false;
                                objContact.KPI_FRM_Candidate__c=true;
                            } else {
                                objContact.KPI_FRM_Holder__c=true;
                                objContact.KPI_FRM_Candidate__c=true;
                            }
                        }
                        if(con.recordTypeId == ERPExamTypeId) {
                            system.debug('* * * In 4');
                            objContact.KPI_ERP_Certified__c=false;
                            if(passNotDone) {
                                objContact.KPI_ERP_Holder__c=false;
                                objContact.KPI_ERP_Candidate__c=true;
                            } else {
                                objContact.KPI_ERP_Holder__c=true;
                                objContact.KPI_ERP_Candidate__c=true;
                            }
                        }                   
                    }
                }

                if(con.recordTypeId == ICBRRExamTypeId) {
                    objContact.KPI_ICBRR_Participant__c = true;
                    //objContact.KPI_ICBRR_Result__c = null;
                }
                if(con.recordTypeId == FBRExamTypeId) {
                    objContact.KPI_FBR_Participant__c = true;                    
                }
                
                Date nowDateTime = date.today();
                
                system.debug('* * * Lapsed?:' + nowDateTime + ':' + con.EndDate + ':' + objContact.Id+ ':' + objContact.Id);
                
                if(nowDateTime > con.EndDate) {
                    
                    if(con.recordTypeId == MembershipTypeId) {
                        Integer monthDiff = con.EndDate.monthsBetween(nowDateTime); 
                        objContact.KPI_Membership_Payment_Lapsed_Months__c = monthDiff;
                        objContact.KPI_Membership_Payment_Status__c = 'Lapsed';                         
                    }
                    if(con.recordTypeId == FRMExamTypeId) {
                        Integer monthDiff = con.EndDate.monthsBetween(nowDateTime); 
                        objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = monthDiff;
                        objContact.KPI_FRM_Candidate_Payment_Status__c = 'Lapsed';                                         
                    }
                    if(con.recordTypeId == ERPExamTypeId) {
                        Integer monthDiff = con.EndDate.monthsBetween(nowDateTime); 
                        objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = monthDiff;
                        objContact.KPI_ERP_Candidate_Payment_Status__c = 'Lapsed';                                         
                    }
                } else {
                    if(con.recordTypeId == MembershipTypeId) {
                        objContact.KPI_Membership_Payment_Status__c = 'In Good Standing';
                        objContact.KPI_Membership_Payment_Lapsed_Months__c = null;
                    }
                    if(con.recordTypeId == FRMExamTypeId) {
                        objContact.KPI_FRM_Candidate_Payment_Status__c = 'In Good Standing';
                        objContact.KPI_FRM_Candidate_Payment_Lapsed_Months__c = null;
                    }
                    if(con.recordTypeId == ERPExamTypeId) {
                        objContact.KPI_ERP_Candidate_Payment_Status__c = 'In Good Standing';
                        objContact.KPI_ERP_Candidate_Payment_Lapsed_Months__c = null;
                    }
                }
                
                system.debug('* * * Set Lapsed:' + objContact.KPI_Membership_Payment_Status__c);
        
                if(con.recordTypeId == MembershipTypeId) {
                    Boolean found=false;
                    for(Opportunity opp : lstOpportunityEligible) {
                        
                        //system.debug('* * * Opp:' + opp.Id + ':' + opp.AccountId + ':' + opp.Eligible_for_Membership_Extension__c + ' == ' + objContact.accountId);
                        //if(opp.AccountId == objContact.accountId && opp.Eligible_for_Membership_Extension__c) {
                        if(opp.AccountId == objContact.accountId) {
                            objContact.KPI_Membership_Source__c = 'FRM/ERP Program';
                            found=true;
                        }
                        
                        // Add other cases here!
                    }
                    
                    if(!found) {
                        objContact.KPI_Membership_Source__c = 'Registration';        
                    }
                }  
            }

            if(con.status.indexof('Canceled') > -1) {
                if(con.recordTypeId == MembershipTypeId) {                     
                    if(memberSinceContract==null)
                        memberSinceContract = con.StartDate;
                    
                    if(lastContract != null && lastContract.status.indexof('Canceled') == -1)
                        memberSinceContract = con.StartDate;
                }
            }
            
            if(con.status.indexof('Expired') > -1) {
                                
                system.debug('* * * Expired Contract:' + con.id + ':' + con.recordTypeId);
                
                Date nowDateTime = date.today();
                
                if(con.recordTypeId == MembershipTypeId) {
                    
                    system.debug('* * * Member:' + con.Membership_Type__c);
                    objContact.KPI_Member__c = true;
                    objContact.Membership_Type__c = con.Membership_Type__c;
                    if(con.Membership_Type__c == 'Individual') {
                        objContact.CVent_Contact_Type__c = 'Member';
                    }
                    objContact.KPI_Membership_Since__c = con.StartDate;
                    objContact.KPI_Membership_Expiration_Date__c = con.EndDate;
                    
                    if(nowDateTime > con.EndDate) {
                        Integer monthDiff = con.EndDate.monthsBetween(nowDateTime); 
                        objContact.KPI_Membership_Payment_Lapsed_Months__c = monthDiff;
                        objContact.KPI_Membership_Payment_Status__c = 'Lapsed'; 
                    } else {
                        objContact.KPI_Membership_Payment_Status__c = 'In Good Standing';
                        objContact.KPI_Membership_Payment_Lapsed_Months__c = null;                        
                    }
                }
            }
            
            if(con.recordTypeId == FRMExamTypeId) {
                frmCnt++;
            }
            if(con.recordTypeId == ERPExamTypeId) {  
                erpCnt++;
            }
            
            if(con.recordTypeId == MembershipTypeId) {
                memCnt++;
                Boolean comp = false;
                Boolean pay = true;
                String type = con.Membership_Type__c;
                
                if(con.Membership_Type__c != 'Affiliate') {
                    for(Opportunity opp : lstOpportunityEligible) {
                        //if(opp.Id == con.Opportunity__c && opp.Eligible_for_Membership_Extension__c && con.Membership_Type__c != 'Affiliate') {
                        if(opp.Id == con.Opportunity__c) {
                            comp=true;
                            pay=false;
                        }            
                    }            
                }

                if(firstContract.StartDate == null) {
                    firstContract = con;
                    if(pay) {
                        objContact.KPI_Membership_Original_Business_Type__c = 'New Business';
                        objContact.KPI_Membership_Original_Source__c = 'Registration';
                    } else {
                        objContact.KPI_Membership_Original_Business_Type__c = 'Exam Comp';
                        objContact.KPI_Membership_Original_Source__c = 'FRM/ERP Program';
                    }
                    
                }
                
                system.debug('* * * Contracts:'+ con.Id + ':' + comp + ':' + pay + ':' + userComp + ':' + userPay + ':' + renewalCount + ':' + con.Membership_Type__c);           
                    
                if(pay && userPay) { 
                    renewStatusLevel='Renewal';
                    renewalCount++;
                    
                    system.debug('* * * Renewal_Type: ' + type + ':' + userType);
                                 
                    if(userType == 'Affiliate' && type != 'Affiliate' ||
                       userType == 'Student' && type != 'Individual') {
                        objContact.KPI_Membership_Renewal_Type__c = 'Upgrade';
                    } else if(userType == type){
                        objContact.KPI_Membership_Renewal_Type__c = 'Same';                         
                    } else {
                        objContact.KPI_Membership_Renewal_Type__c = 'Downgrade';                            
                    }
    
                }
                    
                if(!comp && userComp) {
                    renewStatusLevel='Conversion';
                }
                
                if(comp && !userComp) {
                    renewStatusLevel='Exam Comp';
                }
    
                if(pay && !userPay) {
                    renewStatusLevel='New Business';
                }
    
                if(pay) {
                    userPay=true;
                }
                if(comp) {
                    userComp=true;
                }
                if(type != null) {
                    userType=type;
                }
            }
            system.debug('* * * renewStatusLevel:'+ renewStatusLevel);      
            if(con.recordTypeId == MembershipTypeId)
                lastContract=con;
        }
        
        if(frmCnt == 1) {
            if(frmCanceledCnt == 1)
                objContact.KPI_FRM_Candidate_Business_Type__c = null;
            else objContact.KPI_FRM_Candidate_Business_Type__c = 'New';
        } else if(frmCnt > 1) {
            objContact.KPI_FRM_Candidate_Business_Type__c = 'Renewal';
        }

        if(erpCnt == 1) {
            if(erpCanceledCnt == 1)
                objContact.KPI_ERP_Candidate_Business_Type__c = null;
            else objContact.KPI_ERP_Candidate_Business_Type__c = 'New';
        } else if(erpCnt > 1) {
            objContact.KPI_ERP_Candidate_Business_Type__c = 'Renewal';
        }
        
        if(memCnt > 0) {        
            objContact.KPI_Membership_Business_Type__c = renewStatusLevel;
            if(renewalCount > 0) {
                objContact.KPI_Membership_Renewal_Count__c = string.valueof(renewalCount);    
            }
            objContact.KPI_Membership_Original_Type__c = firstContract.Membership_Type__c;
        }
        
        system.debug('* * * objContact:'+ objContact);
        
        if(objContact.KPI_Membership_Payment_Status__c == 'In Good Standing') {
            objContact.KPI_Membership_Since__c = memberSinceContract;
        } else {
            objContact.KPI_Membership_Since__c = null;
        }
        
        lstContacts.add(objContact);
    }

    if(lstContacts.size() > 0)
        update lstContacts;
    }

}