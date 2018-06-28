trigger examRegistration2ContactSync on Exam_Attempt__c (after insert, after update) {

    Map<Id,Exam_Attempt__c> mapEAIds = new Map<Id,Exam_Attempt__c>();
 map< id, Exam_Attempt__c > ContactID2EA = new map< id, Exam_Attempt__c > () ;
    for(Exam_Attempt__c obj : trigger.New)
    {        
        mapEAIds.put(obj.Member__c,obj);
        ContactID2EA.put( obj.member__c, obj ) ;
    }
    
    system.debug('* * * mapEAIds: ' + mapEAIds.keySet());
        
    List<Exam_Attempt__c> lstExamAttempt = [SELECT Id, Name, Opportunity__r.CloseDate, CreatedDate, ADA_Status__c, RAD_Status__c, Scholarship_Status__c, Cancelled__c, Candidate_Commitment__c, Candidate_Commitment__r.Opportunity__c, hasViolation__c, Checked_In__c, Result__c, Defered__c, Exam_Site__r.Site__r.Display_Address__c , Exam_Site__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Date__c, Exam_Site__r.Exam__r.Exam_Group__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Early_Registration__c, Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Late_Registration__c, Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Standard_Registration__c, Session__c, Member__r.GARP_ID__c, Member__r.name, Exam_Site__r.Site__r.Site_Code__c, Room__r.name, Seat_No__c FROM Exam_Attempt__c where Member__C in :mapEAIds.keySet() and Cancelled__c != true order by Exam_Site__r.Exam_Date__c];

    system.debug('* * * lstExamAttempt: ' + lstExamAttempt);

    List<Contact> lstActiveContacts = new List<Contact>();
    for(Contact objContact : [select id,Membership_Type__c,KPI_ICBRR_Result__c,KPI_Membership_Since__c,KPI_Exam_Attempt_ID_2__c, KPI_Exam_Attempt_ID__c, accountId from contact where Id in: mapEAIds.keySet()])
    {
        objContact.KPI_ICBRR_Result__c = null;
        objContact.KPI_Current_Exam_Registration__c = null;
        objContact.KPI_Current_Exam_Registration_Type__c = null;
        objContact.KPI_Current_Exam_Location__c = null;
        objContact.KPI_Current_Exam_Reg_Business_Type__c = null;
        objContact.KPI_Current_Exam_Registration_ADA__c = false;
        objContact.KPI_Current_Exam_Registration_RA__c = false;
        objContact.KPI_Current_Exam_Reg_Scholarship__c = false;
        objContact.KPI_Current_Exam_Registration_Date__c = null;
            
        objContact.KPI_Last_Exam_Result__c = null;
        objContact.KPI_Last_Exam_Violation__c = false;
        objContact.KPI_Last_Exam_Registration__c = null;
        objContact.KPI_Last_Exam_Location__c = null;
        objContact.KPI_Last_Exam_Registration_Type__c = null;
        objContact.KPI_Last_Exam_Registration_ADA__c = false;
        objContact.KPI_Last_Exam_Registration_RA__c = false;
        objContact.KPI_Last_Exam_Registration_Scholarship__c = false;
        
        objContact.KPI_Exam_Attempt_ID__c = null;
        objContact.KPI_Exam_Attempt_ID_2__c = null; 
        
        objContact.KPI_Last_Exam_Check_In__c = false;
                            
    
        Boolean activeFound=false;
        Boolean activeDeferal=false;
        Integer activeCnt=0;
        Exam_Attempt__c lastResult=null;
        Exam_Attempt__c ICBRRLastResult=null;
        //Exam_Site__r.Exam__r
        
        
        for(Exam_Attempt__c ea : lstExamAttempt) {
            if(ea.Member__C == objContact.Id) {
                
                system.debug('* * * Exam Attempt: ' + ea.Id);
                
                if(ea.Exam_Site__r.Exam__r.Exam__c != 'ICBRR' && ea.Result__c != null && (lastResult == null || ea.Exam_Site__r.Exam_Date__c < lastResult.Exam_Site__r.Exam_Date__c))
                    lastResult = ea;

                if(ea.Exam_Site__r.Exam__r.Exam__c == 'ICBRR' && ea.Result__c != null && (ICBRRLastResult == null || ea.Exam_Site__r.Exam_Date__c < ICBRRLastResult.Exam_Site__r.Exam_Date__c))
                    ICBRRLastResult = ea;
                
                system.debug('* * * Active__c: ' + ea.Exam_Site__r.Exam__r.Exam_Group__r.Active__c);
                
                if(ea.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == true) {
                    activeFound=true;
                    activeCnt++;

                    system.debug('* * * activeCnt: ' + activeCnt);
                    
                    if(objContact.KPI_Exam_Attempt_ID__c == null) {
                        objContact.KPI_Exam_Attempt_ID__c = ea.id;
                        //objContact.KPI_Current_Exam_Registration_Date__c = date.newinstance(ea.Opportunity__r.CloseDate.year(), ea.Opportunity__r.CloseDate.month(), ea.Opportunity__r.CloseDate.day());
                    } else {
                        objContact.KPI_Exam_Attempt_ID_2__c = ea.id;
                    }
                    
                    if(ea.Defered__c != null) {
                        activeDeferal=true;
                    }
                    if(ea.Exam_Site__r.Exam__r.Exam__c.toLowerCase().indexof('frm') > -1) {
                        if(activeCnt > 1)
                            objContact.KPI_Current_Exam_Registration__c = 'FRM Part 1 & 2';
                        else objContact.KPI_Current_Exam_Registration__c = ea.Exam_Site__r.Exam__r.Exam__c;
                    } else if(ea.Exam_Site__r.Exam__r.Exam__c.toLowerCase().indexof('erp') > -1) {
                        objContact.KPI_Current_Exam_Registration__c = ea.Exam_Site__r.Exam__r.Exam__c;
                    }
                        

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
                    
                    if(ea.Exam_Site__r.Site__r.Display_Address__c != null) {
                        if(ea.Exam_Site__r.Site__r.Display_Address__c.length() > 255)
                            objContact.KPI_Current_Exam_Location__c = ea.Exam_Site__r.Site__r.Display_Address__c.substring(1,255);
                        else objContact.KPI_Current_Exam_Location__c = ea.Exam_Site__r.Site__r.Display_Address__c;
                    }
                        
                    
                    if(ea.Exam_Site__r.Exam_Date__c != null) {
                        Datetime dt = datetime.newInstance(ea.Exam_Site__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam_Date__c.month(),ea.Exam_Site__r.Exam_Date__c.day());
                        objContact.KPI_Current_Exam_Date__c = dt.format('MMMM yyyy');
                    }
                }
                
            }
        }
        if(activeFound == false) {
            objContact.KPI_Current_Exam_Registration__c = null;
            objContact.KPI_Current_Exam_Registration_Type__c = null;
            objContact.KPI_Current_Exam_Location__c = null;
        }
        if(activeDeferal) {
            objContact.KPI_Current_Exam_Reg_Business_Type__c = 'Deferred';
        } else if(activeFound && activeCnt == 1) {
            objContact.KPI_Current_Exam_Reg_Business_Type__c = 'New';
        } else if(activeFound && activeCnt > 1) {
            objContact.KPI_Current_Exam_Reg_Business_Type__c = 'Renewal';
        }
        
        if(ICBRRLastResult != null) {
            objContact.KPI_ICBRR_Result__c = ICBRRLastResult.Result__c;
        }
        
        if(lastResult != null) {
            if(lastResult.Checked_In__c != null) {
                system.debug('* * * lastResult.Checked_In__c ...'+ lastResult.Checked_In__c);
                objContact.KPI_Last_Exam_Check_In__c = lastResult.Checked_In__c;
            }
                
            
            objContact.KPI_Last_Exam_Result__c = lastResult.Result__c;
            objContact.KPI_Last_Exam_Violation__c = lastResult.hasViolation__c;
            objContact.KPI_Last_Exam_Registration__c = lastResult.Exam_Site__r.Exam__r.Exam__c;
            
            if(lastResult.Exam_Site__r.Site__r.Display_Address__c.length() > 255)
                objContact.KPI_Last_Exam_Location__c = lastResult.Exam_Site__r.Site__r.Display_Address__c.substring(1,255);
            else objContact.KPI_Last_Exam_Location__c = lastResult.Exam_Site__r.Site__r.Display_Address__c;
                                    
            if(lastResult.CreatedDate <= lastResult.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Early_Registration__c) {
                objContact.KPI_Last_Exam_Registration_Type__c = 'Early';
            } else if(lastResult.CreatedDate <= lastResult.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Standard_Registration__c) {
                objContact.KPI_Last_Exam_Registration_Type__c = 'Standard';
            } else if(lastResult.CreatedDate <= lastResult.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_Late_Registration__c) {
                objContact.KPI_Last_Exam_Registration_Type__c = 'Late';
            }                

            if(lastResult.ADA_Status__c != null && lastResult.ADA_Status__c.toLowerCase().indexOf('approved') > -1) {
                objContact.KPI_Last_Exam_Registration_ADA__c = true;    
            }
            if(lastResult.RAD_Status__c != null && lastResult.RAD_Status__c.toLowerCase().indexOf('approved') > -1) {
                objContact.KPI_Last_Exam_Registration_RA__c = true;    
            }
            if(lastResult.Scholarship_Status__c != null && lastResult.Scholarship_Status__c.toLowerCase().indexOf('approved') > -1) {
                objContact.KPI_Last_Exam_Registration_Scholarship__c = true;    
            }            

            if(lastResult.Exam_Site__r.Exam_Date__c != null) {
                Datetime dt = datetime.newInstance(lastResult.Exam_Site__r.Exam_Date__c.year(), lastResult.Exam_Site__r.Exam_Date__c.month(),lastResult.Exam_Site__r.Exam_Date__c.day());
                objContact.KPI_Last_Exam_Date__c = dt.format('MMMM yyyy');                
            }            
        }

        if ( ContactID2EA.get(objContact.id ).Cancelled__c == TRUE)
            objContact.Recent_Exam__c = ContactID2EA.get(objContact.id ).Exam_Name__c+' Cancelled' ;
        else 
             if ( ContactID2EA.get(objContact.id ).Defered__c == 'Pending' ) 
                objContact.Recent_Exam__c = ContactID2EA.get(objContact.id ).Exam_Name__c+' Deferred' ;
            else 
                objContact.Recent_Exam__c = ContactID2EA.get(objContact.id ).Exam_Name__c ;


        system.debug('* * * Add Contact: ' + objContact);
        lstActiveContacts.add(objContact);        
    }
    if(lstActiveContacts.size() > 0)
        update lstActiveContacts;            
}