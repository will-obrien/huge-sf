trigger onCaseInsert on Case (before insert) {

    
    Set<string> emailIds = new set<string>();
    map<string,Contact> emailToContact = new map<string,Contact>();
    boolean MarketingRequest = false;
        for(case c: trigger.new)
        {
                String CaseDesc = c.Description;
        
                if(string.isNotEmpty(CaseDesc))
                {
                    if((c.recordTypeID == RecordTypeHelper.GetRecordTypeId('Case','Marketing Request')) && (CaseDesc.contains('1. Your Email Address:')))
                    {
                              system.debug('Description length:'+CaseDesc.length());
                              system.debug('Record Type ID :'+c.recordTypeID);
                              system.debug('The description is'+CaseDesc);
                              String emailField = caseDesc.substringBetween('1. Your Email Address:', '2. Department:');
                              system.debug('The Email Field is:'+emailField);
                              emailField = emailField.trim();
                              system.debug('After Trimming:'+emailField);
                              emailField = emailField.replaceAll('\n','');
                              system.debug('After ReplaceAll:'+emailField);
                        	  emailField = emailField.toLowerCase();
                              emailIds.add(emailField);
                                                
                              String department = caseDesc.substringBetween('2. Department:', '3. Which one of the following would you like to submit this request for?');
                              system.debug('The Department Field is:'+department);
                              department = department.trim();
                              system.debug('After Trimming:'+department);
                              department = department.replaceAll('\n','');
                              system.debug('After ReplaceAll:'+department);
                              c.Department__c = department;
                              marketingRequest = true;
                    }   
                                                
                }
        }
                                            
                 if(marketingRequest)
                 {
                          
                     
                     		
                     
                     		for(Contact con:[select id,name,email from Contact where email in : emailIds])
                            {
                                	string emailId = con.email.toLowerCase();
                                    emailToContact.put(emailId,con);
                                   
                            } 
                     		
                            for(case cas: trigger.new)
                            {
                                  User u1 = new User();
                                  Contact c = new contact();
                                  String CaseDesc1 = cas.Description;
                                  String emailField = caseDesc1.substringBetween('1. Your Email Address:', '2. Department:');
                                  emailField = emailField.trim();
                                  emailField = emailField.replaceAll('\n','');
                                  emailField = emailField.toLowerCase();
                                                                
                                   if(!emailToContact.isEmpty())
                                  {
                                  		c = emailToContact.get(emailField);
                                  		cas.contactID = c.id;
                                  		cas.SuppliedName = c.name;                    
                                  } 
                                  
                             }
                 }
    
} // End of Trigger