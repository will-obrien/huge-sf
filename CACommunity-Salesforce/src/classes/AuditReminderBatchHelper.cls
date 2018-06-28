// This is the helper class for the AuditReminderBatch job 
// 
// Audit Reminder Logic:
// For each CA owner, create one audit reminder email for all of the root certs that they own 
// that have outdated audit statements. Attach the activity to the CA Owner Object. Also set
// one user as 'CA Program Manager in User object'. The sender will be copied only if 
// 'Compliance BCC Email' has been enabled. Ignore Root Certs which have 'Do NOT send Audit Reminder'
// checked.
// 
// For each Root Cert Object:
// Check Standard Audit Statement Date when 
// Root Status = Included or Change Requested
// and Chosen Trust Bits is not empty and not equal to "All Trust Bits Turned Off"
// (If the Std Audit Dt is due then send reminder email and don't check for BR and EV)
// Check BR Audit Statement Date when 
// Root Status = Included or Change Requested
// and Chosen Trust Bits includes Websites
// (If the BR Audit Dt is due then send reminder email and don't check for EV)
// Check EV Audit Statement Date when 
// Root Status = Included or Change Requested
// and Chosen Trust Bits includes Websites
// and EV Policy OID(s) is not empty and not "Not EV".
// (If the EV Audit Dt is due then send reminder email)
// 
// Audit Reminder Email Templates
// 
// "30 days past due" = The audit statement date is older than 1 year plus  30 days. 
// For example if the program were run on January 20, 2015, and it found an audit statement dated December 12, 2013,
// which is now over 1 year plus 30 days old, the first  "courtesy reminder" email would be sent.
// 
// ** For the Overdue and Danger notices, send the email to all of the email addresses we have on file for the
// CA (the aliases, Primary POC, *and* POCs)
// 
// <Note: list each audit and corresponding date only once; check for unique 'Audit' and pick any date from corresponding root cert>
// <Note: only show BR Audit info if one of the roots has the Websites trust bit set; check for unique BR Audit>
// <Note: only show the EV Audit info if one of the roots has an EV Policy OID; check for unique EV Audit>
// 
// From: CA Program Manager email address
// BCC: CA Program Manager email address  * Compliance BCC Email has been enabled *
// 
// == Reminder: Audit statements due (start with 30 to 120 days past due) ==
// 
// *** Use email template Audit_Reminder_Level_1
// 
// To: <Alias1 and Alias2. If Alias1 and 2 are blank then the primary POC and CC POC(s)>
// 
// Subject: Mozilla Audit Reminder 
// 
// Email template body contains following merge fields 
// - <Root Cert Name 1>
// - <Root Cert Name 2>
// - <Root Cert Name 3> etc
// 
// Audit: <Standard Audit>
// Audit Statement Date: <Standard Audit Statement Date>
// 
// BR Audit: <BR Audit>
// BR Audit Statement Date: <BR Audit Statement Date>
// 
// EV Audit: <EV Audit>
// EV Audit Statement Date: <EV Audit Statement Date>
// 
// == Overdue (start with 120 to 240 days past due) ==
// 
// *** Use email template Audit_Reminder_Level_2
// 
// To: <Alias1 and Alias2 *and* the primary POC and CC POC(s)
// 
// Subject: Mozilla: Overdue Audit Statements
// 
// Email template body is same as above
// 
// == Danger of root being removed (start with 240 days and over past due) ==
// 
// *** Use email template Audit_Reminder_Level_3
// 
// To: <Alias1 and Alias2 *and* the primary POC and CC POC(s)
// 
// Subject: Mozilla: Your root is in danger of being removed
// 
// Email template body is same as above


public class AuditReminderBatchHelper {

 // This method iterates over a list of root accounts and processes them for audit reminder email notification
 public static void processRootAccount(List<Account> parentAccountSoLLst) {
     
     Set<Account> rootAccountSOSet;
     String templateNameStr = ' ';
     String subjectStr = ' ';
     String WEBSITES = 'Websites';
     Boolean showBRAuditInfo=FALSE;
     Boolean showEVAuditInfo=FALSE;
     Date consideredDate;
     
  // iterate over each root account
   for(Account accountSO : parentAccountSoLLst)
      {
           rootAccountSOSet = new Set<Account>();
          
           templateNameStr = ' ';  // initialize
           subjectStr = ' ';       // initialize
           showBRAuditInfo=FALSE;  // initialize
           showEVAuditInfo=FALSE;  // initialize
           
          for(Account rootAccountSo: [select id, parentid, name, Standard_Audit__c,br_Audit__c,ev_Audit__c, 
                                      ev_policy_oid_s__c, trust_bits__c,Standard_Audit_Statement_Date__c,
                                      br_audit_statement_date__c,ev_audit_statement_date__c,parent.name 
                                      from account where parentid = :accountSO.id and Type = 'Root' 
                                      and status__c in ('Included','Change Requested')
                                      and Do_NOT_Send_Audit_Reminder__c = False])
          {
              if(!showBRAuditInfo )
                  {
                    showBRAuditInfo = (rootAccountSo.trust_bits__c!=null 
                                       && rootAccountSo.trust_bits__c.length()>0 
                                       && rootAccountSo.trust_bits__c.contains(WEBSITES)) ? true : false;
                  }
              
              if(!showEVAuditInfo )
                  {

                     showEVAuditInfo = (rootAccountSo.trust_bits__c!=null 
                                     && rootAccountSo.trust_bits__c.length()>0
                                     && rootAccountSo.trust_Bits__c.contains(WEBSITES) 
                                     && rootAccountSo.ev_policy_oid_s__c!=null 
                                     && rootAccountSo.ev_policy_oid_s__c!='Not EV') ? true : false; 
                  }
              
              // system.debug('accountSo Id = ' + accountSo.Id);
              // system.debug('rootAccount ID = ' + rootAccountSo.Id);
              // system.debug('showEVAuditInfo = ' + showEVAuditInfo);
              // system.debug('rootAccountSo.trust_Bits__c = ' + rootAccountSo.trust_Bits__c);
              // system.debug('rootAccountSo.ev_policy_oid_s__c = ' + rootAccountSo.ev_policy_oid_s__c);
                                 
              // system.debug('trustBits='+rootAccountSo.trust_Bits__c.contains('Off'));
              // system.debug('days='+system.today().daysBetween(rootAccountSo.standard_audit_statement_date__c));
              
             if(rootAccountSo.trust_bits__c!=null && !rootAccountSo.trust_Bits__c.contains('Off') 
                && rootAccountSo.standard_audit_statement_date__c!=null 
                && Math.abs(system.today().daysBetween(rootAccountSo.standard_audit_statement_date__c)) > 395)
               {
                 consideredDate = rootAccountSo.Standard_Audit_Statement_Date__c;
                 rootAccountSOSet.add(rootAccountSo);
               }
               
               else if(rootAccountSo.trust_bits__c!=null && rootAccountSo.trust_Bits__c.contains(WEBSITES) 
                       &&  rootAccountSo.br_audit_statement_date__c !=null 
                       && Math.abs(system.today().daysBetween(rootAccountSo.br_audit_statement_date__c)) > 395)
               {
                 consideredDate = rootAccountSo.br_audit_statement_date__c;
                 rootAccountSOSet.add(rootAccountSo);
               }
               else if(rootAccountSo.trust_bits__c!=null && rootAccountSo.trust_bits__c.length()>0 
                       && rootAccountSo.trust_Bits__c.contains(WEBSITES) 
                       && rootAccountSo.ev_policy_oid_s__c!=null && rootAccountSo.ev_policy_oid_s__c!='Not EV' 
                       && rootAccountSo.ev_audit_statement_date__c !=null 
                       && Math.abs(system.today().daysBetween(rootAccountSo.ev_audit_statement_date__c)) > 395)
               {
                   consideredDate = rootAccountSo.ev_audit_statement_date__c;
                   rootAccountSOSet.add(rootAccountSo);
               }
             
               if(consideredDate!=null)
                {
                    If( consideredDate!=null &&  Math.abs(system.today().daysBetween(consideredDate)) > 395 &&  Math.abs(system.today().daysBetween(consideredDate)) <485  )
                    {
                         templateNameStr='Audit_Reminder_Level_1';                        
                         subjectStr = 'Mozilla: Audit Reminder'; // Over 30-120 days past due
                    }
                    else If(consideredDate!=null && Math.abs(system.today().daysBetween(consideredDate)) > 485 &&   Math.abs(system.today().daysBetween(consideredDate)) <605  )
                    {
                         templateNameStr = 'Audit_Reminder_Level_2';                      
                         subjectStr = 'Mozilla: Overdue Audit Statements'; // Over 120-240 days past due  
                    }   
                    else if (consideredDate!=null && Math.abs(system.today().daysBetween(consideredDate)) > 605 )
                    {   
                        templateNameStr = 'Audit_Reminder_Level_3';                     
                        subjectStr = 'Mozilla: Your root is in danger of being removed';  // Over 240 days past due
                    }
               }
          }
          
          // create the lists which will hold the TO and CC email addresses
          List<String> toAddressesLst = new List<String>();
          List<String> ccAddressesLst = new List<String>();  
             
          // check if the email alias info is available on the parent account   
          if((accountSO.CA_Email_Alias_1__c!=null && accountSO.CA_Email_Alias_1__c.length()>0) 
             || (accountSO.CA_Email_Alias_2__c!=null && accountSO.CA_Email_Alias_2__c.length()>0))
             {
             
               // system.debug('Sending email for Account ' + accountSo.Id);
             
               // if email alias info is available on the parent account then we need to send the 
               // the audit reminder email notification to these email addresses
               try {
               
                     // add email alias 1 to the list if it is not null
                     if(accountSO.CA_Email_Alias_1__c!=null && accountSO.CA_Email_Alias_1__c.length() > 0)
                       {
                           toAddressesLst.add(accountSo.CA_Email_Alias_1__c); 
                       }

                     // add email alias 2 to the list if it is not null             
                     if(accountSO.CA_Email_Alias_2__c!=null && accountSO.CA_Email_Alias_2__c.length() > 0)
                       {
                           toAddressesLst.add(accountSo.CA_Email_Alias_2__c); 
                       }                      

                }
                catch(Exception ex) {
                   // System.debug('Exception type caught: ' + ex.getTypeName());    
                   // System.debug('Message: ' + ex.getMessage());    
                   // System.debug('Cause: ' + ex.getCause());    // returns null
                   // System.debug('Line number: ' + ex.getLineNumber());    
                   // System.debug('Stack trace: ' + ex.getStackTraceString());    
               }
             }
             // else
             // {
             
          // ccAddressesLst.add('ccemail@apicalapps.com');
          if ((accountSO.CA_Email_Alias_1__c == null && accountSO.CA_Email_Alias_2__c == null)
             || (templateNameStr == 'Audit_Reminder_Level_2') || (templateNameStr == 'Audit_Reminder_Level_3'))
            {
               // ccAddressesLst.add('ccemail@apicalapps.com');
               // fetch the Primary POC and POC contacts from the parent account
               List<Contact> contactLst = [select id, email, Type__c from contact where account.id=:accountSO.id and (Type__c = 'Primary POC' or Type__c = 'POC')];
               
               // if such contacts exists
               if(contactLst!=null && contactLst.size()>0)
               {               

                 // iterate over each contact record and add their
                 // email address to their corresponding list based on the record type
                 // Primary POC email address is added to TO list and 
                 // POC email address is added to the CC list
                 
                 for(Contact contactSO: contactLst)
                 {
                   if(contactSO.Type__c == 'Primary POC')
                   {
                       toAddressesLst.add(contactSO.email);
                   }
                    
                   else if(contactSO.Type__c == 'POC')
                    {
                       ccAddressesLst.add(contactSO.email);
                   }
                     
                 }          
                               
               }
                            
           }
          
          if((toAddressesLst.size()>0 || ccAddressesLst.size()>0) && rootAccountSoSet.size() > 0 )
          {
             // system.debug('Sending email to =' );
             // system.debug('rootAccountSet = ' + rootAccountSoSet);
             sendEmail(toAddressesLst,ccAddressesLst,accountSo, subjectStr,templateNameStr, 
                       rootAccountSoSet, showBRAuditInfo, showEVAuditInfo);
          }
          
      }
    
  }
    
    
    // this method sends out the email to the Primary POC and POC contacts associated with the parent account
    public static void sendEmail(List<String> toAddressesLst, List<String> ccAddressesLst, Account rootAccountSo,
                                 String subjectStr,String templateNameStr, Set<Account> rootAccountSoSet, 
                                 Boolean showBRAuditInfo, Boolean showEVAuditInfo) {

    // create a new instance of singleEmailMessage
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    // grab the email template
    EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where developername = :templateNameStr];
        
    // get the HTML body from the template
    String htmlBody = emailTemplate.HtmlValue;
    
      // set the TO addresses on the email
    mail.setToAddresses(toAddressesLst);
    
    String bodyStr = 'To Addresses: ' + toAddressesLst + '\n';    
         
     List<User> userLst = [select email,name,firstname,lastname,companyname,title,phone from user 
                           where CA_Program_Manager__c = true order by name];
     
     if(userLst!=null && userLst.size()>0)
     {
         
         mail.setReplyTo(userLst[0].email);
         mail.setSenderDisplayName(userLst[0].name);
         
         // for(User tempUserSo: userLst)
         //  {
         //     ccAddressesLst.add(tempUserSo.email);
         //  }
     }
     
    // set the CC addresses on the email
    if(ccAddressesLst!=null && ccAddressesLst.size()>0)
     {
         mail.setCCAddresses(ccAddressesLst);
         bodyStr = bodyStr + 'CC Addresses: ' + ccAddressesLst + '\n\n';
     }

    // set other mandatory parameters like subject, replyTo etc
    mail.setSubject(subjectStr);

    String rootAccountHTMLStr = '<ul>';
    String rootAccountPlainStr = '' ;
    Map<String,Account> standardAuditMap = new Map<String,Account>();
    Map<String,Account> brAuditMap = new Map<String,Account>();
    Map<String,Account> evAuditMap = new Map<String,Account>();
    
    
    for(Account accountSo: rootAccountSoSet)
    {
            
      rootAccountHTMLStr  =  rootAccountHTMLStr + '<li>' +  accountSo.name + '</li><br/>' ;
      rootAccountPlainStr = (rootAccountPlainStr!=null & rootAccountPlainStr.length()>0)?  rootAccountPlainStr + '- ' + accountSo.name + '\n' : '- ' + accountSo.name + '\n';
      
        // for audit+date key pull the record from root account set
      standardAuditMap.put(accountSo.Standard_Audit_Statement_Date__c+accountSo.standard_audit__c,accountSo);
      brAuditMap.put(accountSo.br_Audit_Statement_Date__c+accountSo.br_audit__c,accountSo);
      if (accountSo.ev_policy_oid_s__c!='Not EV') {
            evAuditMap.put(accountSo.ev_Audit_Statement_Date__c+accountSo.ev_audit__c,accountSo);
      }
      
    }
    
    String standardAuditInfoStr = '';
    String brAuditInfoStr = '';
    String evAuditInfoStr = '';
    
    if(standardAuditMap.size()>0)
    {    
        for(String mapKeyStr : standardAuditMap.keySet())
        {
          Account rootAccount = standardAuditMap.get(mapKeyStr);
          
           // if(rootAccount.standard_audit__c == null && rootAccount.standard_audit_statement_date__c ==null)
           // {
           //     continue;
           // }
           // else
           // {
             String auditStr = rootAccount.standard_audit__c == null ? ' ' : rootAccount.standard_audit__c ;
             String auditDate =  rootAccount.standard_audit_statement_date__c == null ? ' ' : String.valueOf(rootAccount.standard_audit_statement_date__c) ; 
             standardAuditInfoStr = standardAuditInfoStr + 'Standard Audit: ' + auditStr + '<br/>Audit Statement Date: ' + auditDate + '<br/>';
          // }
        }
      
    }
    
     if(showBRAuditInfo && brAuditMap.size()>0 )
    {
    
        for(String mapKeyStr :brAuditMap.keySet())
        {
          Account rootAccount = brAuditMap.get(mapKeyStr);
           // if(rootAccount.br_audit__c == null && rootAccount.br_audit_statement_date__c ==null)
           //  {
           //     continue;
           // }
           // // else
           // {
             String auditStr = rootAccount.br_audit__c == null ? ' ' : rootAccount.br_audit__c;
             String auditDate =  rootAccount.br_audit_statement_date__c == null ? ' ' : String.valueOf(rootAccount.br_audit_statement_date__c); 
             brAuditInfoStr = brAuditInfoStr + 'BR Audit: ' + auditStr + '<br/>BR Audit Statement Date: ' + auditDate + '<br/>';
          // }
        }
      
    }

     if(showEVAuditInfo && evAuditMap.size()>0)
    {
    
        for(String mapKeyStr :evAuditMap.keySet())
        {
          Account rootAccount = evAuditMap.get(mapKeyStr);
          // if(rootAccount.ev_audit__c == null && rootAccount.ev_audit_statement_date__c ==null)
          //  {
          //      continue;
          //  }
          //  else
          // {
             String auditStr = rootAccount.ev_audit__c == null ? ' ' : rootAccount.ev_audit__c;
             String auditDate =  rootAccount.ev_audit_statement_date__c == null ? ' ' : String.valueOf(rootAccount.ev_audit_statement_date__c); 
             evAuditInfoStr = evAuditInfoStr + 'EV Audit: ' + auditStr + '<br/>EV Audit Statement Date: ' + auditDate + '<br/>';
          //  }
        }     
    }



    if(rootAccountHTMLStr.length()> 3)
    {
        rootAccountHTMLStr += '</ul>';
    }
     
   
     // if the HTML body is not null, provide values for all the merge fields in the template
    if(htmlBody!=null && htmlBody.length() > 0)
     {
        
        if(userLst!=null && userLst.size()>0)
        {
        htmlBody = htmlBody.replace('{!User.FirstName}', userLst[0].FirstName == null ? ' ' : userLst[0].FirstName);
        htmlBody = htmlBody.replace('{!User.LastName}', userLst[0].LastName == null ? ' ' : userLst[0].LastName);
        htmlBody = htmlBody.replace('{!User.CompanyName}', userLst[0].CompanyName  == null ? ' ' : userLst[0].CompanyName);
        htmlBody = htmlBody.replace('{!User.Title}', userLst[0].Title   == null ? ' ' : userLst[0].Title);
        htmlBody = htmlBody.replace('{!User.Phone}', userLst[0].phone  == null ? ' ' : userLst[0].phone); 
           
        }
        
         htmlBody = htmlBody.replace('{!RootCertificateList}', rootAccountHTMLStr );
         htmlBody = htmlBody.replace('{!standardAuditInfoStr}', standardAuditInfoStr);
         htmlBody = htmlBody.replace('{!brAuditInfoStr}', brAuditInfoStr);
         htmlBody = htmlBody.replace('{!evAuditInfoStr}', evAuditInfoStr);
        //TODO set userInfo details.       
         mail.setHtmlBody(htmlBody);
     }
    
    // get the plan text body from the template
    String plainBody = emailTemplate.Body;
    
    // if the plain text body is not null, provide values for all the merge fields in the template
    if(plainBody!=null && plainBody.length() > 0)
     {
        plainBody = plainBody.replace('{!RootCertificateList}', rootAccountPlainStr);
        plainBody = plainBody.replace('{!standardAuditInfoStr}', standardAuditInfoStr);
        plainBody = plainBody.replace('{!brAuditInfoStr}', brAuditInfoStr);
        plainBody = plainBody.replace('{!evAuditInfoStr}', evAuditInfoStr);
       if(userLst!=null && userLst.size()>0)
        {
          plainBody = plainBody.replace('{!User.FirstName}', userLst[0].FirstName == null ? ' ' : userLst[0].FirstName);
          plainBody = plainBody.replace('{!User.LastName}', userLst[0].LastName == null ? ' ' : userLst[0].LastName);
          plainBody = plainBody.replace('{!User.CompanyName}', userLst[0].CompanyName  == null ? ' ' : userLst[0].CompanyName);
          plainBody = plainBody.replace('{!User.Title}', userLst[0].Title   == null ? ' ' : userLst[0].Title);
          plainBody = plainBody.replace('{!User.Phone}', userLst[0].phone  == null ? ' ' : userLst[0].phone);
        }
        plainBody = plainBody.replace('<br/>','\n');
        plainBody = plainBody.replace('<ul>',' ');
        plainBody = plainBody.replace('</ul>',' ');
        plainBody = plainBody.replace('<li>',' ');
        plainBody = plainBody.replace('</li>',' ');     
 
       mail.setPlainTextBody(plainBody);    
     }

    
    
    // send out the email
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
    // create a task record for the sent email so that it shows up 
    // on the related list for the corresponding root account
    
    createTask(mail.getSubject(),bodyStr + mail.getPlainTextBody(),UserInfo.getUserId(),rootAccountSo.id);
    
    }
    
    // this method creates the task that would be associated with the corresponding root account
    // this lets the users know that an email was sent out for the root account
    public static void createTask(String subject, String mailBody, String userId, String accountId)
    {
        
        Task taskSo = new Task();
        taskSo.subject = subject;
        taskSo.Description = mailBody; 
        taskSo.status = 'Completed';
        taskSo.OwnerId =   userId; //user id        
        taskSo.WhatId = accountId; //record id
    
        insert taskSo; 
    
    }
}