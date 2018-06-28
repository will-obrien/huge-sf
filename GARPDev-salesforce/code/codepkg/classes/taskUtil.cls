public class taskUtil {
    
    
    public static void noMatch(set<ID> LeadsToConvert, Map<string, String> mapEmailToAmtowed, Map<String, String> mapEmailToBalance, Map<string,List<string>> mapIdtoBodyFields,List<ID> tasklist)
    {
                                /* Getting Cvent Product and Gl codes from custom settings */
                                Cvent_Registration_Codes__c cvent = Cvent_Registration_Codes__c.getall().values();
                                String cventProdCode = cvent.ProductCode__c;
                                String cventGlCode = cvent.Gl_Code__c;
                                String cventName = cvent.Convention_Name__c;
                                Individual_Membership_Codes__c membership = Individual_Membership_Codes__c.getall().values();
                                String memProdCode = membership.Product_Code__c;
                                String memGlCode = membership.Gl_Code__c;
                                String memName = membership.Name__c;
                                Decimal memPrice = Decimal.valueof(membership.memPrice__c);
                                Boolean converted;
                                
                                // Change the lead owner to 'GARP system' before convert.
                                List<lead> leadOwnerID = new List<lead>();
                                User u = [select ID, name from user where Username = 'garpsfdcsystem@garp.com'];
                                for(Lead ld : [select id,name,OwnerID from Lead where id in: LeadsToConvert])
                                {
                                 List<String> descFields = new List<string>();
                                 descFields = mapIdtoBodyFields.get(ld.ID);
                                   
                                 
                                    if(descFields[12] == 'Non-Member'){
                                    ld.do_not_fire__C = true;
                                    ld.OwnerID = u.id;
                                    leadOwnerID.add(ld);}
                                    
                                    else{
                                      ld.OwnerID = u.id;
                                    leadOwnerID.add(ld);
                                    }
                                }
                                update leadOwnerID;
        
                           
                                /* Convert Lead to Account, Contact and Opportunity */
                                list<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>();
                                for(ID w: LeadsToConvert)
                                {
                                    Database.LeadConvert lc = new database.LeadConvert();
                                    lc.setLeadId(w);
                                    lc.convertedStatus = 'Qualified';
                                    leadConverts.add(lc);
                                }
                                
                                if(!leadConverts.isEmpty())
                                {
                                            for(Integer i = 0; i <= leadConverts.size()/100 ; i++)
                                            {
                                                    list<Database.LeadConvert> tempList = new list<Database.LeadConvert>();
                                                    Integer startIndex = i*100;
                                                    Integer endIndex = ((startIndex+100) < leadConverts.size()) ? startIndex+100: leadConverts.size();
                                                    for(Integer j=startIndex;j<endIndex;j++){
                                                    tempList.add(leadConverts[j]);
                                                    }
                                                    Database.LeadConvertResult[] lcrList = Database.convertLead(tempList, false);
                                                    system.debug('The lcr list of converted lead is: '+ lcrList);
                                                    converted = true;
                                            }   
                                            
                                            map<id,id> LeadToOpportunityMap = new map<id,id>();
                                            map<id,id> LeadToAccountMap = new map<id,id>();
                                            map<id,id> LeadToContactMap = new map<id,id>();
                                            map<id,contact> mapConvertedContacts = new map<Id,contact>();
                                            
                                    
                                            for(Lead l:[select ID,ConvertedOpportunityId,ConvertedAccountId,ConvertedContactId from Lead where ID in:LeadsToConvert])
                                            {
                                               // Map of lead to converted Account, contact and opportunity
                                                LeadToOpportunityMap.put(l.ID,l.ConvertedOpportunityId);
                                                LeadToAccountMap.put(l.ID,l.ConvertedAccountId);
                                                LeadToContactMap.put(l.ID,l.ConvertedContactId);
                                                
                                            }
                                        
                                            // Fetching converted opp Ids to create opportunity line items later.
                                            List<opportunity> lstCreateOppLineItems = [select Id,Name from opportunity where ID in: LeadToOpportunityMap.values()];
                                            
                                            //List declarations
                                            List<OpportunityLineItem> oppLineItem = new List<OpportunityLineItem>();
                                            List<opportunity> lstopp = new List<opportunity>();
                                            List<contract> lstcontracts = new List<contract>();
                                            List<Account> lstacc = new List<Account>();
                                            List<Task> lsttasktoupdate = new List<Task>();
                                    
                                            for(contact con: [select Id,Company__c,Email,FirstName,LastName,Title,MailingCity,OtherPhone,MailingState,MailingStreet from contact where ID in: LeadToContactMap.values()])
                                            {
                                                mapConvertedContacts.put(con.id, con);
                                            }
                                
                                             
                                            List<contact> lstcontact = new List<contact>();
                                            for(Lead l: [select Id from Lead where ID in: LeadToContactMap.keyset()])
                                            {
                                                List<String> descFields = new List<string>();
                                                descFields = mapIdtoBodyFields.get(l.ID);
                                                ID conID = LeadToContactMap.get(l.ID);
                                                Decimal purchase;
                                                
                                                /* Map task's Description fields to the contact fields  */
                                                contact c = mapConvertedContacts.get(conID);
                                                
                                                c.Company__c = descFields[1];
                                                c.Email = descFields[2];
                                                c.FirstName = descFields[3];
                                                c.LastName = descFields[4];
                                                c.Title = descFields[6];
                                                c.MailingCity = descFields[7];
                                                c.OtherPhone = descFields[8];
                                                c.MailingState = descFields[9];  
                                                
                                               
                                                /*** Rename the Account ***/
                                                
                                                Account a = new Account();
                                                a.Id = LeadToAccountMap.get(l.id);
                                                a.Name = c.FirstName + c.LastName;
                                                lstacc.add(a);
                                               
                                                                                               
                                                /* Turn off the email settings */
                                                c.Email_Daily_News__c = false;
                                                c.Email_The_Week_in_Risk__c = false;
                                                c.Email_Chapter_Meetings__c = false;
                                                c.Email_GARP_Updates__c = false;
                                                c.Email_Career_Center_Job_Board__c = false;
                                                c.Email_Information_Exchange__c = false;
                                                c.Exam_Prep_Provider_Outreach__c = false;
                                                c.Email_CPE_News__c = false;
                                               
                                                // Set Event Participant
                                                c.Event_Participant__c = TRUE;
                                                
                                                
                                                
                                                
                                                // If Member, create Opportunity (Event registration + membership) and add a new contract.
                                                if(descFields[12] == 'Individual Member') 
                                                {
                                                    for(Opportunity oppty:lstCreateOppLineItems)
                                                    {
                                                        if(oppty.id == LeadToOpportunityMap.get(l.ID))
                                                        {
                                                                    String key = c.Email.toLowerCase();
                                                                    Decimal total = Decimal.valueof(mapEmailToAmtowed.get(key));
                                                                    system.debug('Value in the match method: '+ Decimal.valueof(mapEmailToBalance.get(key)));
                                                                    Decimal balance = Decimal.valueof(mapEmailToBalance.get(key));
                                                                    Decimal eventPrice = total - memPrice;
                                                                    oppty.name = 'Event Registration and Membership';
                                                                    oppty.Eligible_for_Membership_Extension__c = TRUE;
                                                                    oppty.description = 'Event Registration and Membership';
                                                                    oppty.CloseDate = system.today();
                                                                    oppty.Event_Order__c = TRUE;
                                                                    
                                                                    // As Cvent tracks the product price and Invoice, we are not saving the product price in salesforce. Hence passing 0.00
                                                                    createOppLineItem(oppty.ID,cventProdCode,cventGlCode,cventName,0.00);
                                                                    createOppLineItem(oppty.ID,memProdCode,memGlCode,memName,0.00);
                                                                    
                                                                    if(balance == 0.00)
                                                                        oppty.StageName = 'Closed';
                                                                    else
                                                                    {
                                                                        oppty.StageName = 'New Lead';
                                                                        oppty.Alternate_Method_of_Payment__c = 'Wire';
                                                                    }
                                                                        
                                                                    
                                                                    
                                                                    /***** Mapping description fields of the task to the opportunity fields ******/
                                                                    oppty.ChargentSFA__Billing_Company__c = descFields[1];
                                                                    oppty.ChargentSFA__Billing_Email__c = descFields[2];
                                                                    oppty.ChargentSFA__Billing_First__c = descFields[3];
                                                                    oppty.ChargentSFA__Billing_Last__c = descFields[4];
                                                                    oppty.ChargentSFA__Billing_City__c = descFields[7];
                                                                    oppty.ChargentSFA__Billing_Phone__c = descFields[8];
                                                                    oppty.ChargentSFA__Billing_State__c = descFields[9];  
                                                                    //oppty.ChargentSFA__Billing_Address__c = descFields[10];
                                                                    oppty.Display_Invoice_Number__c = descFields[13];
                                                                    
                                                                    system.debug('List of opportunities :'+lstopp);
                                                                    lstopp.add(oppty);
                                                                    
                                                                    
                                                                    /****** Contract creation *****/
                                                                    createContract(LeadToAccountMap.get(l.ID),c.Id,oppty.Id);
                                                                    
                                                                    c.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contact','Member');
                                                        
                                                        }
                                                    }
                                                    
                                                }  
                                                 
                                                
                                                
                                                else if(descFields[12] == 'Non-Member')
                                                {
                                                    
                                                    /* Create Opportunity Line Items for event registration */
                                                       for(Opportunity oppty:lstCreateOppLineItems)
                                                        {     
                                                           if(oppty.id == LeadToOpportunityMap.get(l.ID))
                                                            {
                                                                            oppty.Name = 'Event Registration';
                                                                            oppty.Description = 'Event Registration';
                                                                            oppty.CloseDate = system.today();
                                                                            String key = c.Email.toLowerCase();
                                                                            Decimal total = Decimal.valueof(mapEmailToAmtowed.get(key));
                                                                            Decimal balance = Decimal.valueof(mapEmailToBalance.get(key));
                                                                            // As Cvent tracks the product price and Invoice, we are not saving the product price in salesforce. Hence passing 0.00
                                                                            createOppLineItem(oppty.ID,cventProdCode,cventGlCode,cventName,0.00);
                                                                            oppty.Event_Order__c = TRUE;
                                                                            if(balance == 0.00)
                                                                                oppty.StageName = 'Closed';
                                                                            else
                                                                            {   
                                                                                oppty.StageName = 'New Lead';
                                                                                oppty.Alternate_Method_of_Payment__c = 'Wire';
                                                                            }
                                                                                
                                                                            
                                                                
                                                                            /***** Mapping description fields of the task to the opportunity fields ******/
                                                                            oppty.ChargentSFA__Billing_Company__c = descFields[1];
                                                                            oppty.ChargentSFA__Billing_Email__c = descFields[2];
                                                                            oppty.ChargentSFA__Billing_First__c = descFields[3];
                                                                            oppty.ChargentSFA__Billing_Last__c = descFields[4];
                                                                            oppty.ChargentSFA__Billing_City__c = descFields[7];
                                                                            oppty.ChargentSFA__Billing_Phone__c = descFields[8];
                                                                            oppty.ChargentSFA__Billing_State__c = descFields[9];  
                                                                            //oppty.ChargentSFA__Billing_Address__c = descFields[10];
                                                                            oppty.Display_Invoice_Number__c = descFields[13];
                                                                            
                                                                            lstopp.add(oppty);
                                                                
                                                                            //Schema.SObjectType.contact.getRecordTypeInfosByName().get('Business_Relationship').getRecordTypeId();
                                                                            c.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship');
                                                                            c.do_not_fire__c = True;
                                                                            system.debug('Business Relationship record type ID is: '+c.recordTypeID);
                
                                                            }
                                                        }
                                              } 
                                                
                                                lstcontact.add(c);  
                                            }
                                            
                                            update lstopp;
                                            insert lstcontracts;
                                            update lstcontact;
                                            update lstacc;
                                    
                                 for(Task tk: [select Id,status,subject,whoID,WhatID,OwnerID from Task where ID in: tasklist])
                                 {
                                               if(converted)
                                               {
                                                    tk.Status = 'Completed';
                                                    tk.OwnerID = u.id;
                                                    lsttasktoupdate.add(tk);   
                                               }

                                 }   
                                   update lsttasktoupdate; 
                                                   
                             } // End 
                         
} // End of method
    
    
    
public static void singleMatch(List<Contact> lstCheckCon, Map<string, String> mapEmailToAmtowed, Map<string, String> mapEmailToBalance, Map<string,List<string>> mapEmailtoBodyFields,List<ID> tasklist)
{
        
                            /* Getting Cvent Product and Gl codes from custom settings */
                                Cvent_Registration_Codes__c cvent = Cvent_Registration_Codes__c.getall().values();
                                String cventProdCode = cvent.ProductCode__c;
                                String cventGlCode = cvent.Gl_Code__c;
                                String cventName = cvent.Convention_Name__c;
                                Individual_Membership_Codes__c membership = Individual_Membership_Codes__c.getall().values();
                                String memProdCode = membership.Product_Code__c;
                                String memGlCode = membership.Gl_Code__c;
                                String memName = membership.Name__c;
                                Decimal memPrice = Decimal.valueof(membership.memPrice__c);
                                Boolean singlematch = false;
                                User u = [select ID, name from user where Username = 'garpsfdcsystem@garp.com'];
                            
                            List<opportunity> lstopp = new List<opportunity>();
                            List<contract> lstcontracts = new List<contract>();
                            List<ID> lstAccountIds = new List<ID>();
                            List<contact> lstcontact = new List<contact>();
                            List<OpportunityContactRole> lstContactRole = new List<OpportunityContactRole>();
                            List<Task> lsttasktoupdate = new List<Task>();
                   
                             for(contact c:lstCheckCon)
                             {
                                 string key = c.Email.toLowerCase();
                                 String amt = mapEmailToAmtowed.get(key);
                                 
                                 Decimal purchase;
                                 purchase = Decimal.valueof(amt);
                                 
                                 
                                 /* Map Task's Description fields to the contact fields  */
                                 List<String> descFields = new List<string>();
                                 descFields = mapEmailtoBodyFields.get(key);
                                 c.Company__c = descFields[1];
                                 
                                 c.Title = descFields[6];
                                 if(c.MailingCity==null)
                                    c.MailingCity = descFields[7];
                                 
                                 if(c.OtherPhone==null)
                                    c.OtherPhone = descFields[8];
                                 
                                 if(c.MailingState==null)
                                    c.MailingState = descFields[9];  
                                 
                                
                                 
                                 
                                 if(c.CVent_Member_Type__C =='Individual' && descFields[12] == 'Individual Member')
                                 {
                                         
                                         contactExtn conextn = new contactExtn();
                                         Opportunity objOpp = new Opportunity();
                                         objOpp.Name = 'Event Registration';
                                         objOpp.description = 'Event Registration';
                                         objOpp = conextn.createOpportunity(c,'Event Registration',true);
                                        objOpp.Event_Order__c = TRUE;
                                        Decimal total = Decimal.valueof(mapEmailToAmtowed.get(key));
                                        Decimal balance = Decimal.valueof(mapEmailToBalance.get(key));
                                        Decimal eventPrice = total - memPrice;
                                        
                                     // As Cvent tracks the product price and Invoice, we are not saving the product price in salesforce. Hence passing 0.00
                                        createOppLineItem(objOpp.ID,cventProdCode,cventGlCode,cventName,0.00);
                                                                               
                                        if(balance == 0.00)
                                            objOpp.StageName = 'Closed';
                                        else
                                        {   
                                                objOpp.StageName = 'New Lead';
                                                objOpp.Alternate_Method_of_Payment__c = 'Wire';
                                         }
                                         
                                         /* Set Event Participation */
                                         c.Event_Participant__c = TRUE;
                                     
                                     
                                      /***** Mapping description fields of the task to the opportunity fields ******/
                                                objOpp.ChargentSFA__Billing_Company__c = descFields[1];
                                                objOpp.ChargentSFA__Billing_Email__c = descFields[2];
                                                objOpp.ChargentSFA__Billing_First__c = descFields[3];
                                                objOpp.ChargentSFA__Billing_Last__c = descFields[4];
                                                objOpp.ChargentSFA__Billing_City__c = descFields[7];
                                                objOpp.ChargentSFA__Billing_Phone__c = descFields[8];
                                                objOpp.ChargentSFA__Billing_State__c = descFields[9];  
                                                //objOpp.ChargentSFA__Billing_Address__c = descFields[10];
                                                objOpp.Display_Invoice_Number__c = descFields[13];
                                                
                                         singlematch = true;       
                                         lstopp.add(objOpp);                                 
                                         
                                 }
                                 
                                 
                                 else if(c.CVent_Member_Type__C !='Individual' && descFields[12] == 'Individual Member')
                                 {
                                         
                                         contactExtn conextn = new contactExtn();
                                         Opportunity objOpp = new Opportunity(); 
                                         objOpp.Name = 'Event Registration and Membership';
                                         objOpp.description = 'Event Registration and Membership';
                                         objOpp = conextn.createOpportunity(c,'Event Registration and Membership',true);
                                         objOpp.Event_Order__c = TRUE;
                                         objOpp.Eligible_for_Membership_Extension__c = TRUE;
                                        Decimal total = Decimal.valueof(mapEmailToAmtowed.get(key));
                                        Decimal eventPrice = total - memPrice;
                                        Decimal balance = Decimal.valueof(mapEmailToBalance.get(key));
                                        // As Cvent tracks the product price and Invoice, we are not saving the product price in salesforce. Hence passing 0.00
                                        createOppLineItem(objOpp.ID,cventProdCode,cventGlCode,cventName,0.00);
                                        createOppLineItem(objOpp.ID,memProdCode,memGlCode,memName,0.00);                                       
                                        
                                        if(balance == 0.00)
                                            objOpp.StageName = 'Closed';
                                        else
                                        {   
                                                objOpp.StageName = 'New Lead';
                                                objOpp.Alternate_Method_of_Payment__c = 'Wire';
                                         }
                                     
                                        createContract(c.AccountId,c.Id,objOpp.Id);
                                     
                                         /* Set Event Participation */
                                         c.Event_Participant__c = TRUE;
                                        c.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contact','Member');
                                     
                                      /***** Mapping description fields of the task to the opportunity fields ******/
                                                objOpp.ChargentSFA__Billing_Company__c = descFields[1];
                                                objOpp.ChargentSFA__Billing_Email__c = descFields[2];
                                                objOpp.ChargentSFA__Billing_First__c = descFields[3];
                                                objOpp.ChargentSFA__Billing_Last__c = descFields[4];
                                                objOpp.ChargentSFA__Billing_City__c = descFields[7];
                                                objOpp.ChargentSFA__Billing_Phone__c = descFields[8];
                                                objOpp.ChargentSFA__Billing_State__c = descFields[9];  
                                                //objOpp.ChargentSFA__Billing_Address__c = descFields[10];
                                                objOpp.Display_Invoice_Number__c = descFields[13];
                                         
                                         singlematch = true;   
                                         lstopp.add(objOpp);                                 
                                         
                                 }
                                 
                                 else if(c.CVent_Member_Type__C !='Individual' && descFields[12] == 'Non-Member')
                                 {
                                         contactExtn conextn = new contactExtn();
                                         Opportunity objOpp = new Opportunity(); 
                                         objOpp = conextn.createOpportunity(c,'Event Registration',true);
                                        objOpp.Description = 'Event Registration';
                                        objOpp.CloseDate = system.today();
                                        objOpp.Event_Order__c = TRUE;
                                        Decimal total = Decimal.valueof(mapEmailToAmtowed.get(key));
                                        Decimal balance = Decimal.valueof(mapEmailToBalance.get(key));
                                        // As Cvent tracks the product price and Invoice, we are not saving the product price in salesforce. Hence passing 0.00
                                        createOppLineItem(objOpp.ID,cventProdCode,cventGlCode,cventName,0.00);
                                         
                                        if(balance == 0.00)
                                            objOpp.StageName = 'Closed';
                                        else
                                        {   
                                                objOpp.StageName = 'New Lead';
                                                objOpp.Alternate_Method_of_Payment__c = 'Wire';
                                         }

                                        c.Event_Participant__c = TRUE;
                                     
                                     /***** Mapping description fields of the task to the opportunity fields ******/
                                                objOpp.ChargentSFA__Billing_Company__c = descFields[1];
                                                objOpp.ChargentSFA__Billing_Email__c = descFields[2];
                                                objOpp.ChargentSFA__Billing_First__c = descFields[3];
                                                objOpp.ChargentSFA__Billing_Last__c = descFields[4];
                                                objOpp.ChargentSFA__Billing_City__c = descFields[7];
                                                objOpp.ChargentSFA__Billing_Phone__c = descFields[8];
                                                objOpp.ChargentSFA__Billing_State__c = descFields[9];  
                                               // objOpp.ChargentSFA__Billing_Address__c = descFields[10];
                                                objOpp.Display_Invoice_Number__c = descFields[13];
                                        singlematch = true;
                                         lstopp.add(objOpp);   
                                        
                                 }
                                    
                                 lstcontact.add(c);
                             }
                             update lstcontact;
                             update lstopp;
                            
                            for(Task tk: [select Id,status,subject,whoID,WhatID,OwnerID from Task where ID in: tasklist])
                                {
                                               if(singlematch)
                                               {
                                                    tk.Status = 'Completed';
                                                    tk.OwnerID = u.id;
                                                    lsttasktoupdate.add(tk);   
                                               }
                                                
                                }   
                                   update lsttasktoupdate; 
    }

        /******** Create Opportunity line item  method *****/
    public static void createOppLineItem(ID oppID,string strProdCode,string glCode,string descp,Decimal totalPrice)
    {
        
        PriceBookEntry PricebookEntryId = [select unitprice,productcode,Product2.GL_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode =: strProdCode and Product2.GL_Code__c = :glCode and isActive =: true];
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = oppID;
        oli.PricebookEntryId = PricebookEntryId.Id;
        oli.Quantity = 1;
        oli.Description = descp;
        oli.TotalPrice = totalPrice;
        insert oli;
    }
    
        /******** Create Membership contract method *****/
    public static void createContract(ID accountID,ID contactID,ID oppID)
    {
        Contract objContract = new Contract(); 
        objContract.accountId = accountID;
        objContract.CustomerSignedId = contactID;
        objContract.Opportunity__c = oppID;
        objContract.StartDate = system.today();
        objContract.ContractTerm  = 12;
        objContract.Status = 'Draft';
        objContract.Membership_Type__c = 'Individual';
        objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
        insert objContract;   
    }
}