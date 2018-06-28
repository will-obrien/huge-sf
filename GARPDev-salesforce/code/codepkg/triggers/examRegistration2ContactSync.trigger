trigger examRegistration2ContactSync on Exam_Attempt__c (after insert, after update) {
    
    Map<Id,Exam_Attempt__c> mapEAIds = new Map<Id,Exam_Attempt__c>();
    map< id, Exam_Attempt__c > ContactID2EA = new map< id, Exam_Attempt__c > () ;
    for(Exam_Attempt__c obj : trigger.New)
    {        
        mapEAIds.put(obj.Member__c,obj);
        ContactID2EA.put( obj.member__c, obj ) ;
    }
    
    system.debug('* * * mapEAIds: ' + mapEAIds.keySet());
    
    List<Exam_Attempt__c> lstExamAttempt = [SELECT Id, Name, ICBRR_Submission_Status__c, Registered_On__c, Opportunity__r.CloseDate, Opportunity__r.StageName, CreatedDate, ADA_Status__c, RAD_Status__c, Scholarship_Status__c, Cancelled__c, Candidate_Commitment__c, Candidate_Commitment__r.Opportunity__c, hasViolation__c, Checked_In__c, Result__c, Defered__c, Exam_Site__r.Site__r.Display_Address__c , Exam_Site__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Early_Registration__c, Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Late_Registration__c, Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Standard_Registration__c, Session__c, Member__r.GARP_ID__c, Member__r.name, Exam_Site__r.Site__r.Site_Code__c, Room__r.name, Seat_No__c FROM Exam_Attempt__c where Member__C in :mapEAIds.keySet() and Cancelled__c != true order by Exam_Site__r.Exam_Date__c];
    
    system.debug('* * * lstExamAttempt: ' + lstExamAttempt);
    
    List<Contact> lstActiveContacts = new List<Contact>();
    for(Contact objContact : [select id,Membership_Type__c,Scholarship_Status__c,KPI_Last_Exam_Date__c,KPI_Last_Exam_Registration_Scholarship__c,KPI_Last_Exam_Registration_RA__c,KPI_Last_Exam_Registration_ADA__c,KPI_Last_Exam_Registration_Type__c,KPI_Last_Exam_Location__c,KPI_Last_Exam_Registration__c,KPI_Last_Exam_Violation__c,KPI_Last_Exam_Result__c,KPI_Last_Exam_Check_In__c, KPI_Last_Exam_Deferral_Status__c, KPI_Current_Exam_Reg_Business_Type__c, KPI_Exam_Deferral_Status__c, KPI_Current_Exam_Date__c,KPI_Current_Exam_Location__c,KPI_Current_Exam_Reg_Scholarship__c,KPI_Current_Exam_Registration_RA__c, KPI_Current_Exam_Registration_ADA__c,KPI_Current_Exam_Registration_Date__c,KPI_Current_Exam_Registration__c, KPI_Current_Exam_Registration_Type__c, KPI_FRM_Last_Registration_Date__c,KPI_ERP_Last_Registration_Date__c,KPI_ICBRR_Result__c,KPI_ICBRR_Registration_Count__c,KPI_Membership_Since__c,KPI_Exam_Attempt_ID_2__c, KPI_Exam_Attempt_ID__c, accountId from contact where Id in: mapEAIds.keySet()])
    {
        
        objContact.KPI_ICBRR_Result__c = null;
        objContact.KPI_ICBRR_Registration_Count__c = 0;
        objContact.KPI_Current_Exam_Registration__c = null;
        objContact.KPI_Current_Exam_Registration_Type__c = null;
        objContact.KPI_Current_Exam_Location__c = null;
        objContact.KPI_Current_Exam_Reg_Business_Type__c = null;
        objContact.KPI_Current_Exam_Registration_ADA__c = false;
        objContact.KPI_Current_Exam_Registration_RA__c = false;
        objContact.KPI_Current_Exam_Reg_Scholarship__c = false;
        objContact.Scholarship_Status__c = null;
        objContact.KPI_Current_Exam_Registration_Date__c = null;
        objContact.KPI_Current_Exam_Date__c = null;
        objContact.KPI_Exam_Deferral_Status__c = null;
        
        objContact.KPI_Last_Exam_Result__c = null;
        objContact.KPI_Last_Exam_Violation__c = false;
        objContact.KPI_Last_Exam_Registration__c = null;
        objContact.KPI_Last_Exam_Location__c = null;
        objContact.KPI_Last_Exam_Registration_Type__c = null;
        objContact.KPI_Last_Exam_Registration_ADA__c = false;
        objContact.KPI_Last_Exam_Registration_RA__c = false;
        objContact.KPI_Last_Exam_Registration_Scholarship__c = false;
        objContact.KPI_Last_Exam_Date__c = null;
        objContact.KPI_Last_Exam_Deferral_Status__c = null;
        
        objContact.KPI_Exam_Attempt_ID__c = null;
        objContact.KPI_Exam_Attempt_ID_2__c = null; 
        
        objContact.KPI_Last_Exam_Check_In__c = false;
        
        objContact.KPI_FRM_Last_Registration_Date__c = null;
        objContact.KPI_ERP_Last_Registration_Date__c = null;
        
        
        Boolean activeFound=false;
        Boolean activeDeferal=false;
        Integer activeCnt=0;
        Exam_Attempt__c lastResult=null;
        
        Exam_Attempt__c lastFRMResult=null;
        Exam_Attempt__c lastERPResult=null;
        
        Exam_Attempt__c ICBRRLastResult=null;
        //Exam_Site__r.Exam__r
        
        List<Exam_Attempt__c> lstLastExam = new List<Exam_Attempt__c>();
        List<Exam_Attempt__c> lstCurrentExam = new List<Exam_Attempt__c>();
        
        for(Exam_Attempt__c ea : lstExamAttempt) {
            if(ea.Member__C == objContact.Id) {
                
                system.debug('* * * Exam Attempt: ' + ea.Id);
                
                // Find most recent previous Exam Registrations
                if(ea.Exam_Site__r.Exam__r.Exam__c != 'ICBRR' && ea.Cancelled__c != True && (ea.Opportunity__r.StageName == 'Closed' || ea.Opportunity__r.StageName == 'Closed Won') && 
                   ea.Exam_Site__r.Exam__r.Exam_Group__r.Active__c != True) {
                    if(lstLastExam.size() > 0) {
                        Exam_Attempt__c lea = lstLastExam.get(0);
                        if(lea.Exam_Site__r.Exam_Date__c != ea.Exam_Site__r.Exam_Date__c) {
                            lstLastExam = new List<Exam_Attempt__c>();
                        }
                    }
                    lstLastExam.add(ea);  
                }
                
                // Find current Exam Registrations
                if(ea.Exam_Site__r.Exam__r.Exam__c != 'ICBRR' && ea.Cancelled__c != True && (ea.Opportunity__r.StageName == 'Closed' || ea.Opportunity__r.StageName == 'Closed Won') && 
                   ea.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == True) {
                    if(lstCurrentExam.size() > 0) {
                        Exam_Attempt__c lea = lstCurrentExam.get(0);
                        if(lea.Exam_Site__r.Exam_Date__c != ea.Exam_Site__r.Exam_Date__c) {
                            lstCurrentExam = new List<Exam_Attempt__c>();
                        }
                    }
                    lstCurrentExam.add(ea);  
                }
                
                
                if(ea.Exam_Site__r.Exam__r.Exam__c == 'ICBRR') {
                    if(ea.Result__c != null && (ICBRRLastResult == null || ea.Exam_Site__r.Exam_Date__c > ICBRRLastResult.Exam_Site__r.Exam_Date__c))
                        ICBRRLastResult = ea;
                    
                    if(ea.ICBRR_Submission_Status__c != NULL)
                        objContact.KPI_ICBRR_Registration_Count__c++;                    
                }
            }
        }
        
        // Set ICBRR Result
        if(ICBRRLastResult != null) {
            objContact.KPI_ICBRR_Result__c = ICBRRLastResult.Result__c;
        }
        
        // Set Last (non-Active) Exam Registration Data
        Integer deferCount = 0;
        String deferredLastExamName;
        for(Exam_Attempt__c ea : lstLastExam) {

            // Exam Date            
            if(ea.Exam_Site__r.Exam_Date__c != null) {
                Datetime dt = datetime.newInstance(ea.Exam_Site__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam_Date__c.month(),ea.Exam_Site__r.Exam_Date__c.day());
                if(objContact.KPI_Last_Exam_Date__c != dt.format('MMMM yyyy')) {
                    deferCount = 0;
                }
                objContact.KPI_Last_Exam_Date__c = dt.format('MMMM yyyy');                
            }            

            if(ea.Defered__c != NULL && ea.Defered__c.toLowerCase().indexOf('approved') > -1) {
                //objContact.KPI_Last_Exam_Deferral_Status__c = 'Deferred';
                deferCount++;

                // Exam Name
                if(deferredLastExamName != null && deferredLastExamName.toLowerCase().indexOf('frm') > -1) {
                    deferredLastExamName = 'FRM Part 1 & 2';
                } else if(deferredLastExamName != null && deferredLastExamName.toLowerCase().indexOf('erp') > -1) {
                    deferredLastExamName = 'ERP Part 1 & 2';
                } else {
                    deferredLastExamName = ea.Exam_Site__r.Exam__r.Exam__c;
                }

                
            } else {
                
                // Exam Name
                if(objContact.KPI_Last_Exam_Registration__c != null && objContact.KPI_Last_Exam_Registration__c.toLowerCase().indexOf('frm') > -1) {
                    objContact.KPI_Last_Exam_Registration__c = 'FRM Part 1 & 2';
                } else if(objContact.KPI_Last_Exam_Registration__c != null && objContact.KPI_Last_Exam_Registration__c.toLowerCase().indexOf('erp') > -1) {
                    objContact.KPI_Last_Exam_Registration__c = 'ERP Part 1 & 2';
                } else {
                    objContact.KPI_Last_Exam_Registration__c = ea.Exam_Site__r.Exam__r.Exam__c;
                }
                
            }
                                    
            // FRM / ERP Exam Date
            if(ea.Exam_Site__r.Exam__r.Exam__c != null && ea.Exam_Site__r.Exam__r.Exam__c.indexOf('FRM') > -1)
                objContact.KPI_FRM_Last_Registration_Date__c = ea.Exam_Site__r.Exam_Date__c;
            if(ea.Exam_Site__r.Exam__r.Exam__c != null && ea.Exam_Site__r.Exam__r.Exam__c.indexOf('ERP') > -1)
                objContact.KPI_ERP_Last_Registration_Date__c = ea.Exam_Site__r.Exam_Date__c;   
            
            // Exam Location
            if(ea.Exam_Site__r.Site__r.Display_Address__c != null && ea.Exam_Site__r.Site__r.Display_Address__c.length() > 255)
                objContact.KPI_Last_Exam_Location__c = ea.Exam_Site__r.Site__r.Display_Address__c.substring(1,255);
            else objContact.KPI_Last_Exam_Location__c = ea.Exam_Site__r.Site__r.Display_Address__c;
            
            // Registration Type - most recent
            if(ea.CreatedDate <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Early_Registration__c) {
                objContact.KPI_Last_Exam_Registration_Type__c = 'Early';
            } else if(ea.CreatedDate <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Standard_Registration__c) {
                objContact.KPI_Last_Exam_Registration_Type__c = 'Standard';
            } else if(ea.CreatedDate <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Late_Registration__c) {
                objContact.KPI_Last_Exam_Registration_Type__c = 'Late';
            }                
            
            // Last Exam Data - Results
            objContact.KPI_Last_Exam_Check_In__c = ea.Checked_In__c;
            objContact.KPI_Last_Exam_Result__c = ea.Result__c;
            objContact.KPI_Last_Exam_Violation__c = ea.hasViolation__c;
            
            if(ea.ADA_Status__c != null && ea.ADA_Status__c.toLowerCase().indexOf('approved') > -1) {
                objContact.KPI_Last_Exam_Registration_ADA__c = true;    
            }
            if(ea.RAD_Status__c != null && ea.RAD_Status__c.toLowerCase().indexOf('approved') > -1) {
                objContact.KPI_Last_Exam_Registration_RA__c = true;    
            }
            if(ea.Scholarship_Status__c != null && ea.Scholarship_Status__c.toLowerCase().indexOf('approved') > -1) {
                objContact.KPI_Last_Exam_Registration_Scholarship__c = true;    
            }                        
        }
        
        
        //System.assert(false, 'BOOM!' + lstCurrentExam);
        
        // Set Active Exam Registration Data
        Integer currDeferCount = 0;
        String deferredExamName;
        for(Exam_Attempt__c ea : lstCurrentExam) {

            if(ea.Defered__c != null && ea.Defered__c.toLowerCase().indexOf('pending') > -1) {
                currDeferCount++;
                
                // Exam Name
                if(deferredExamName != null && deferredExamName.toLowerCase().indexOf('frm') > -1) {
                    deferredExamName = 'FRM Part 1 & 2';
                } else if(deferredExamName != null && deferredExamName.toLowerCase().indexOf('erp') > -1) {
                    deferredExamName = 'ERP Part 1 & 2';
                } else {
                    deferredExamName = ea.Exam_Site__r.Exam__r.Exam__c;
                }
                
            } else {
                                
                // Exam Name
                if(objContact.KPI_Current_Exam_Registration__c != null && objContact.KPI_Current_Exam_Registration__c.toLowerCase().indexOf('frm') > -1) {
                    objContact.KPI_Current_Exam_Registration__c = 'FRM Part 1 & 2';
                } else if(objContact.KPI_Current_Exam_Registration__c != null && objContact.KPI_Current_Exam_Registration__c.toLowerCase().indexOf('erp') > -1) {
                    objContact.KPI_Current_Exam_Registration__c = 'ERP Part 1 & 2';
                } else {
                    objContact.KPI_Current_Exam_Registration__c = ea.Exam_Site__r.Exam__r.Exam__c;
                }
            }

            // Exam Date            
            if(ea.Exam_Site__r.Exam_Date__c != null) {
                Datetime dt = datetime.newInstance(ea.Exam_Site__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam_Date__c.month(),ea.Exam_Site__r.Exam_Date__c.day());
                objContact.KPI_Current_Exam_Date__c = dt.format('MMMM yyyy');                
            }            
            
            // Exam Location
            if(ea.Exam_Site__r.Site__r.Display_Address__c != null && ea.Exam_Site__r.Site__r.Display_Address__c.length() > 255)
                objContact.KPI_Current_Exam_Location__c = ea.Exam_Site__r.Site__r.Display_Address__c.substring(1,255);
            else objContact.KPI_Current_Exam_Location__c = ea.Exam_Site__r.Site__r.Display_Address__c;
            
            // Id - most recent
            if(objContact.KPI_Exam_Attempt_ID__c == null) {
                objContact.KPI_Exam_Attempt_ID__c = ea.id;
            } else {
                objContact.KPI_Exam_Attempt_ID_2__c = ea.id;
            }
            
            // Regostration Date - most recent
            objContact.KPI_Current_Exam_Registration_Date__c = ea.Registered_On__c;
            
            // Registration Type - most recent
            if(ea.CreatedDate <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Early_Registration__c) {
                objContact.KPI_Current_Exam_Registration_Type__c = 'Early';
            } else if(ea.CreatedDate <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Standard_Registration__c) {
                objContact.KPI_Current_Exam_Registration_Type__c = 'Standard';
            } else if(ea.CreatedDate <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Late_Registration__c) {
                objContact.KPI_Current_Exam_Registration_Type__c = 'Late';
            }                
            
            if(ea.ADA_Status__c != null && ea.ADA_Status__c.toLowerCase().indexOf('approved') > -1) {
                objContact.KPI_Current_Exam_Registration_ADA__c = true;    
            }
            if(ea.RAD_Status__c != null && ea.RAD_Status__c.toLowerCase().indexOf('approved') > -1) {
                objContact.KPI_Current_Exam_Registration_RA__c = true;    
            }
            if(ea.Scholarship_Status__c != null && ea.Scholarship_Status__c.toLowerCase().indexOf('approved') > -1) {
                objContact.KPI_Current_Exam_Reg_Scholarship__c = true;    
            }            
            
            if(ea.Scholarship_Status__c != NULL)
                objContact.Scholarship_Status__c = ea.Scholarship_Status__c;            
        }

        if(lstCurrentExam.size() > 0 && lstLastExam.size() > 0) {
            objContact.KPI_Current_Exam_Reg_Business_Type__c = 'Renewal';
        } else if(lstCurrentExam.size() > 0) {
            objContact.KPI_Current_Exam_Reg_Business_Type__c = 'New';
        }
        if(lstCurrentExam.size() > 0 && lstCurrentExam.size() == currDeferCount) {
            objContact.KPI_Current_Exam_Reg_Business_Type__c = 'New';
            objContact.KPI_Exam_Deferral_Status__c='Defferral Pending';
            objContact.KPI_Current_Exam_Registration__c = deferredExamName;
        }
        
        //System.assert(false, 'BOOM!' + lstLastExam.size() + ':' + deferCount);
        
        if(lstLastExam.size() > 0 && lstLastExam.size() == deferCount) {
            objContact.KPI_Last_Exam_Deferral_Status__c='Defferred';
            objContact.KPI_Last_Exam_Registration__c = deferredLastExamName;
        }        
        system.debug('* * * Add Contact: ' + objContact);
        lstActiveContacts.add(objContact);        
    }    
    
    if(lstActiveContacts.size() > 0)
        update lstActiveContacts;            
    
    /************** To populate last registration exam fields (FRM 1, FRM 2 and ERP) On contact record *************/
    
    List<Contact> lstContactsToUpdate = new List<Contact>();
    List<contact> listContact = [select ID,Name,(select id,section__c,result__c,Exam_Date__c,Score__c,hasViolation__c  from Exam_Attempts__r) from contact where ID in :mapEAIds.keySet()];
    for(Contact con : listcontact)
    {
        
        Date lastExamDatefrm1;
        Date lastExamDatefrm2;
        Date lastExamDateerp1;
        Date lastExamDateerp2;
        Boolean visitedfrm1;
        Boolean visitedfrm2;
        Boolean visitederp1;
        Boolean visitederp2;
        visitedfrm1 = false;
        visitedfrm2 = false;
        visitederp1 = false;
        visitederp2 = false;
        List<Exam_Attempt__c> lstEA = con.Exam_Attempts__r;
        
        if(lstEA.size()>0)
        {
            lastExamDatefrm1 = Date.newInstance(1990, 01, 01);
            lastExamDatefrm2 = Date.newInstance(1990, 01, 02);
            lastExamDateerp1 = Date.newInstance(1990, 01, 01);
            lastExamDateerp2 = Date.newInstance(1990, 01, 02);
        }
        
        for(Exam_Attempt__c ea : lstEA)
        {
            
            if(ea.section__c == 'FRM Part 1' || ea.section__c == 'FRM Full Program')
            {
                
                if((ea.result__c == 'Pass' || ea.result__c == 'Fail' || ea.result__c == 'No-Show' || ea.result__c == 'Not Graded' || ea.result__c == null ))
                {
                    
                    if(ea.Exam_Date__c > lastExamDatefrm1 && ea.Exam_Date__c < system.today())
                    {
                        
                        lastExamDatefrm1 = ea.Exam_Date__c;
                        con.FRM_Part_I_Last_Exam_Violation__c = ea.hasViolation__c;
                        con.FRM_Part_I_Last_Exam_Result__c = ea.result__c;
                        visitedfrm1 = true;
                    }
                    
                    
                }
                
                con.FRM_Part_I_Last_Registration_Exam_Date__c = lastExamDatefrm1;
                if(ea.Exam_Date__c > system.today() && (!visitedfrm1))
                {
                    con.FRM_Part_I_Last_Registration_Exam_Date__c  = null;
                    con.FRM_Part_I_Last_Exam_Violation__c = false;
                    con.FRM_Part_I_Last_Exam_Result__c = null;
                }
            }
            
            /****** FRM 2 *****/
            if(ea.section__c == 'FRM Part 2')
            {
                
                if((ea.result__c == 'Pass' || ea.result__c == 'Fail' || ea.result__c == 'No-Show' || ea.result__c == 'Not Graded' || ea.result__c == null ))
                {
                    
                    if(ea.Exam_Date__c > lastExamDatefrm2 && ea.Exam_Date__c < system.today())
                    {
                        
                        lastExamDatefrm2 = ea.Exam_Date__c;
                        con.FRM_Part_II_Last_Exam_Violation__c = ea.hasViolation__c;
                        con.FRM_Part_II_Last_Exam_Result__c = ea.Result__c;
                        visitedfrm2 = true;
                    }
                    
                    
                }
                con.FRM_Part_II_Last_Registration_Exam_Date__c = lastExamDatefrm2;
                if(ea.Exam_Date__c > system.today() && (!visitedfrm2))
                {
                    con.FRM_Part_II_Last_Registration_Exam_Date__c  = null;
                    con.FRM_Part_II_Last_Exam_Violation__c = false;
                    con.FRM_Part_II_Last_Exam_Result__c = null;
                }
            }
            
            
            /************* ERP  ***********/
 
             if(ea.section__c == 'ERP Part 1' || ea.section__c == 'ERP Full Program')
            {
                
                if((ea.result__c == 'Pass' || ea.result__c == 'Fail' || ea.result__c == 'No-Show' || ea.result__c == 'Not Graded' || ea.result__c == null ))
                {
                    
                    if(ea.Exam_Date__c > lastExamDateerp1 && ea.Exam_Date__c < system.today())
                    {
                        
                        lastExamDateerp1 = ea.Exam_Date__c;
                        con.ERP_Last_Violation__c = ea.hasViolation__c;
                        con.ERP_Last_Exam_Result__c = ea.result__c;
                        visitederp1 = true;
                    }
                    
                    
                }
                
                con.ERP_Last_Registration_Exam_Date__c = lastExamDateerp1;
                if(ea.Exam_Date__c > system.today() && (!visitederp1))
                {
                    con.ERP_Last_Registration_Exam_Date__c  = null;
                    con.ERP_Last_Violation__c = false;
                    con.ERP_Last_Exam_Result__c = null;
                }
            }
            
            /****** ERP 2 *****/
            if(ea.section__c == 'ERP Part 2')
            {
                
                if((ea.result__c == 'Pass' || ea.result__c == 'Fail' || ea.result__c == 'No-Show' || ea.result__c == 'Not Graded' || ea.result__c == null ))
                {
                    
                    if(ea.Exam_Date__c > lastExamDateerp2 && ea.Exam_Date__c < system.today())
                    {
                        
                        lastExamDateerp2 = ea.Exam_Date__c;
                        con.ERP_Last_Violation__c = ea.hasViolation__c;
                        con.ERP_Last_Exam_Result__c = ea.Result__c;
                        visitederp2 = true;
                    }
                    
                    
                }
                con.ERP_Last_Registration_Exam_Date__c = lastExamDateerp2;
                if(ea.Exam_Date__c > system.today() && (!visitederp2))
                {
                    con.ERP_Last_Registration_Exam_Date__c  = null;
                    con.ERP_Last_Violation__c = false;
                    con.ERP_Last_Exam_Result__c = null;
                }
            }
            
            
        }
        lstContactsToUpdate.add(con);
    } 
    if(lstContactsToUpdate.size()>0)
        update lstContactsToUpdate;
    
}