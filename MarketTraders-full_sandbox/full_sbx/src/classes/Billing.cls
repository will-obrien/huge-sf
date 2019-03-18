public without sharing class Billing {
    
    public class BillingException extends Exception {}
         
    public Billing() {
    }
    
    //public static Void createBillings(list<Opportunity> UpdateOppList, Map<id,Opportunity> OldOppMap) { 
    public static Void createBillings(String oppId) { 
        //acctIds = new Set<ID>();
        //@info: get the accounts for each opp
        List<AcctSeed__Billing__c> newBillings = new List<AcctSeed__Billing__c>();
        
        List<Opportunity> opp = [SELECT id ,accountId,Total_Discount_Amount__c,amount,StageName,CloseDate, Error_Creating_Billing__c
        from opportunity where id = :oppId AND (Error_Creating_Billing__c = false OR Error_Creating_Billing__c = null) LIMIT 1];
        
        List<OpportunityLineItem> p1 = [
                SELECT ID, product2ID,product2.AcctSeed__Revenue_GL_Account__c,product2.Revenue_GL_Account_Discount__c, product2.Revenue_GL_Account__c         
                from OpportunityLineItem 
                where opportunityId = : opp[0].id
            ];
            
        List<Payment_Terms__c> pt = [ select id from Payment_Terms__c where Opportunity__c = :opp[0].id];
            
            
            if(p1.size() == 0 || pt.size() == 0){
                //skip if no product or no payment terms.
               
               opp[0].create_billing__c = false;
                update opp;                     
                return; 
            }
        
        List<AcctSeed__Accounting_Period__c> accountPeriod = [
                    SELECT id 
                    from AcctSeed__Accounting_Period__c 
                    where AcctSeed__Status__c = 'Open'
                    and AcctSeed__Start_Date__c <= :opp[0].closeDate 
                    and AcctSeed__End_Date__c >= :opp[0].closeDate  
                    LIMIT 1
                ];
                
        if(accountPeriod.size() == 0){
            //send email
                                        
            String textMessage = 'Error creating Billing for Opportunity, Attempting to close the sale in a closed accounting period ' + opp[0].id; 
            String htmlMessage = 'Error creating Billing for Opportunity, Attempting to close the sale in a closed accounting period:<b> ' +
                                        'To view the opportunity  <a href=https://na4.salesforce.com/'+opp[0].id+'>click here.</a>'; 
            sendErrorEmail (textMessage,htmlMessage);  
            opp[0].Error_Creating_Billing__c = true;
            update opp;                    
            return; 
        }
        
       // for (Opportunity opp : UpdateOppList) {
       //     if (opp.StageName.equals('Closed Won') && !OldOppMap.get(opp.id).StageName.equals('Closed Won')) {
                system.debug(LoggingLevel.Error, 'Create Billing : Opp Account ID '+ opp[0].AccountId);
                AcctSeed__Billing__c newBill = new AcctSeed__Billing__c();
                newBill.AcctSeed__Customer__c = opp[0].accountId;
                newBill.AcctSeed__Opportunity__c = opp[0].id;
                newBill.AcctSeed__Status__c = 'Approved';
                newBill.AcctSeed__Accounting_Period__c = accountPeriod[0].id;
                newBill.AcctSeed__Date__c = opp[0].closeDate;
                newBill.AcctSeed__Due_Date2__c = opp[0].closeDate;
                newBillings.add(newBill);
                
         //   }
       // }
       
        if(newBillings.size() > 0){
        
            PiggybackRefactor.BYPASS = true;
        
        //try
        
        
            insert newBillings;
        
            system.debug(LoggingLevel.Error, 'inserting billing ' + newBillings);
            //Add billing lines
            // need to bulkify
            //bulkify product lookup
            
            List<OpportunityLineItem> p = [
                SELECT ID, product2ID,product2.AcctSeed__Revenue_GL_Account__c,product2.Revenue_GL_Account_Discount__c, product2.Revenue_GL_Account__c         
                from OpportunityLineItem 
                where opportunityId = : opp[0].id
            ];
            
            system.debug(LoggingLevel.Error, 'OpportunityLineItem ' + p);
            
           // list<Product2> productsdebug = [Select Id, Name From Product2 where id =: p[0].product2ID];
            
            if(p.size() == 0){
                //send email
                                            
                String textMessage = 'Error creating Billing for Opportunity, there is no product on opportunity ' + opp[0].id; 
                String htmlMessage = 'Error creating Billing, there is no product on opportunity:<b> ' +
                                            'To view the opportunity  <a href=https://na4.salesforce.com/'+opp[0].id+'>click here.</a>'; 
                sendErrorEmail (textMessage,htmlMessage); 
                opp[0].Error_Creating_Billing__c = true;
                update opp;                     
                return; 
            }
            
            
            // Transaction line 2 GL account
            try {
                
                List<AcctSeed__GL_Account__c>  arAccount = [
                    SELECT id, name
                    from AcctSeed__GL_Account__c 
                    where Name = '1310 - Accounts Receivable' 
                    LIMIT 1
                ];
                
                system.debug(LoggingLevel.Error, 'arAccount  ' + arAccount);
               // system.debug(LoggingLevel.Error, 'getting  product ' + productsdebug);
                List<AcctSeed__Billing_Line__c> lBillings = new List<AcctSeed__Billing_Line__c>();
                
                for(AcctSeed__Billing__c b : newBillings){
                    AcctSeed__Billing_Line__c newB = new AcctSeed__Billing_Line__c();
                    newB.AcctSeed__Billing__c = b.id;
                    newB.AcctSeed__Rate__c = opp[0].amount + opp[0].Total_Discount_Amount__c;
                    newB.AcctSeed__List_Price__c = opp[0].amount + opp[0].Total_Discount_Amount__c;
                    newB.AcctSeed__Revenue_GL_Account__c = p[0].product2.AcctSeed__Revenue_GL_Account__c;
                    //newB.AcctSeed__Revenue_GL_Account__c = arAccount[0].Id;
                    
                    newB.AcctSeed__Product__c = p[0].product2ID;
                    system.debug(LoggingLevel.Error, 'insert billing line ' + newB);
                    //insert newB;
                    lBillings.add(newB);
                    AcctSeed__Billing_Line__c newB2 = new AcctSeed__Billing_Line__c();
                    newB2.AcctSeed__Billing__c = b.id;
                    newB2.AcctSeed__Rate__c = opp[0].Total_Discount_Amount__c * -1;
                    newB2.AcctSeed__List_Price__c = opp[0].Total_Discount_Amount__c * -1;
                    newB2.AcctSeed__Revenue_GL_Account__c = p[0].product2.Revenue_GL_Account_Discount__c;
                    //newB2.AcctSeed__Revenue_GL_Account__c = arAccount[0].Id;
                    newB2.AcctSeed__Product__c = p[0].product2ID;
                    system.debug(LoggingLevel.Error, 'insert billing line2 ' + newB2);
                    //insert newB2;
                    if(opp[0].Total_Discount_Amount__c != 0){
                        lBillings.add(newB2);
                    }
                }
                
                
                // Perform some database operations that 
                //   might cause an exception.
                
                
                insert lBillings;
                
                system.debug(LoggingLevel.Error, 'lBillings  ' + lBillings);
                
                
            
                
                system.debug(LoggingLevel.Error, 'accountPeriod  ' + accountPeriod);
                
                //insert billing line transactions
                List<AcctSeed__Transaction__c> blTransactions = new List<AcctSeed__Transaction__c>();
                
                for(AcctSeed__Billing_Line__c bl : lBillings){
                    
                    bl.AcctSeed__Product__c = p[0].product2ID;
                    
                    AcctSeed__Transaction__c newBlTran = new AcctSeed__Transaction__c();
                    newBlTran.AcctSeed__Billing_Line__c = bl.id;
                    
                    //TODO lookup GL accounting period
                    //newBlTran.AcctSeed__Accounting_Period__c ='a2E11000000WkFe';
                    newBlTran.AcctSeed__Accounting_Period__c = accountPeriod[0].id;
                    newBlTran.AcctSeed__Amount__c = bl.AcctSeed__Rate__c;
                    
                    //TODO get date
                    newBlTran.AcctSeed__Date__c = date.today();
               
                    // gl code should be acct receivable
                    //newBlTran.AcctSeed__GL_Account__c = 'a2k110000017HYg';
                    newBlTran.AcctSeed__GL_Account__c = arAccount[0].id;
                    blTransactions.add(newBlTran);
                    
                    AcctSeed__Transaction__c newBlTran2 = new AcctSeed__Transaction__c();
                    newBlTran2.AcctSeed__Billing_Line__c = bl.id;
                    //TODO lookup GL codes
                    // newBlTran2.AcctSeed__Accounting_Period__c ='a2E11000000WkFe';
                    newBlTran2.AcctSeed__Accounting_Period__c = accountPeriod[0].id;
                    newBlTran2.AcctSeed__Amount__c = bl.AcctSeed__Rate__c * -1;
                    
                    //TODO get date
                    newBlTran2.AcctSeed__Date__c = date.today();
                    
                    //TODO lookup gl
                    // gl code should be from if rate is negative use discount gl
                    
                    if(bl.AcctSeed__Rate__c < 0){
                        newBlTran2.AcctSeed__GL_Account__c = p[0].product2.Revenue_GL_Account_Discount__c;
                        //newBlTran2.AcctSeed__GL_Account__c = arAccount[0].id;
                    } else {
                        newBlTran2.AcctSeed__GL_Account__c = p[0].product2.Revenue_GL_Account__c;
                        //newBlTran2.AcctSeed__GL_Account__c = arAccount[0].id;
                    }
                    
                    blTransactions.add(newBlTran2);
                    
                } 
                //TODO ADD BACK UPDATE TO PRODUCT     
                system.debug(LoggingLevel.Error, 'new lBillings  ' + lBillings);

                update lBillings;
                
                system.debug(LoggingLevel.Error, 'before tran insert ' + blTransactions);
                //insert blTransactions;
                system.debug(LoggingLevel.Error, 'after tran insert ' + blTransactions);
                
                //find payment activity record;
                List<Payment_Activity__c> paymentActivity = [
                    select id,amount__c,Authorization_Decline_Number__c,PA_CC_Last_4__c 
                    from Payment_Activity__c 
                    where Opportunity__c =: opp[0].id 
                    and  Payment_Status__c = 'paid'
                ];
                
                system.debug(LoggingLevel.Error, 'list paymentActivity  ' + paymentActivity);
                
                for(Payment_Activity__c pa: paymentActivity){
                    //cash receipt
                    AcctSeed__Cash_Receipt__c newCR = new AcctSeed__Cash_Receipt__c();
                    newCR.AcctSeed__Account__c = opp[0].accountid;
                    newCR.AcctSeed__Amount__c = pa.amount__c;
                    if(pa.PA_CC_Last_4__c != null){
                        newCR.AcctSeed__Payment_Reference__c = pa.PA_CC_Last_4__c;
                    } else {
                        newCR.AcctSeed__Payment_Reference__c = 'Required';
                    }
                    system.debug(LoggingLevel.Error, 'insert newCR  ' + newCR);
                    //insert newCR;
                    system.debug(LoggingLevel.Error, 'cr inserted ' + newCR);
                    
                }
                    
                    //cash billing receipt
                    /*
                    AcctSeed__Billing_Cash_Receipt__c newCBR = new AcctSeed__Billing_Cash_Receipt__c();
                    newCBR.AcctSeed__Billing__c = newBillings[0].id;
                    newCBR.AcctSeed__Cash_Receipt__c = newCR.id;
                    newCBR.AcctSeed__Applied_Amount__c = 0;
                    system.debug(LoggingLevel.Error, 'cbr before insert ' + newCBR);
                    insert newCBR;
                    system.debug(LoggingLevel.Error, 'cbr inserted ' + newCBR);
                    */
                    
                         
                    
                    //cash receipt transactions.j
                    //  AcctSeed__Transaction__c newTR = new AcctSeed__Transaction__c();
                    //  newTR.AcctSeed__Accounting_Period__c ='a2E11000000WkFe';
                        //TODO query accounting period
                    //  newTR.AcctSeed__Amount__c = 112;
                    //  newTR.AcctSeed__Date__c =date.today();
                    //  newTR.AcctSeed__GL_Account__c = 'a2k110000017HYb';
                    //TODO lookup gl code
                    //insert newTR;
            } catch(Exception e) {
                    String textMessage2 = 'ERROR - a sale has attempted to close in a prior closed accounting month. Opportunity ' + opp[0].id + ' ' + e.getMessage(); 
                    String htmlMessage2 = 'ERROR - a sale has attempted to close in a prior closed accounting month. ' + e + ' <b> ' +
                                                'To view the opportunity  <a href=https://na4.salesforce.com/'+opp[0].id+'>click here.</a>';
                    sendErrorEmail(textMessage2,htmlMessage2);
                    opp[0].Error_Creating_Billing__c = true;
            } finally { 
                // Perform some clean up.
                 
            } 
            
        } 
        
        PiggybackRefactor.BYPASS = false;
        opp[0].create_billing__c = false;
        opp[0].billing_created__c = true;
        update opp;
        return ;
    }  
  
    public static void sendErrorEmail(String errorMessage,String errorMessageHtml){ 
         Messaging.reserveSingleEmailCapacity(2);

        // Processes and actions involved in the Apex transaction occur next,
        // which conclude with sending a single email.
        
        // Now create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Strings to hold the email addresses to which you are sending the email.
        // String[] toAddresses = new String[] {'skurup@markettraders.com'};
        // String[] ccAddresses = new String[] {'jamie.smith@coastalcloud.us'};
        
        // *NEW* get user list with profile names acc. & acc. managers and add to Sting Lists -JS
        List<User> accManEmails = [
            SELECT Email, UserRole.Name
            FROM User
            WHERE (UserRole.Name = 'accounting' OR UserRole.Name = 'accounting manager')
            AND isActive = true
            
             
        ]; // AND FirstName = 'Test' ///* FOR DEVELOPMENT WE ARE ONLY SENDING TO 'TEST' USER ( AND FirstName = 'Test' ) */
        
        
        String[] toAddresses = new String[] {};
        String[] ccAddresses = new String[] {};
        
        for (user currentUser : accManEmails){
            if (currentUser.UserRole.Name == 'accounting manager'){
                ccAddresses.add(currentUser.email);
            } else {
                toAddresses.add(currentUser.email);
            }
        }
        
        system.debug(LoggingLevel.Error, 'Ohiya: ccAddress = ' + ccAddresses + ' and toAddresses = ' + toAddresses);

        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);

        // Specify the address used when the recipients reply to the email. 
        //mail.setReplyTo('skurup@markettraders.com');

        // Specify the name used as the display name.
        mail.setSenderDisplayName('Billing Error');

        // Specify the subject line for your email address.
        //mail.setSubject('New Case Created : ' + case.Id);
        mail.setSubject('Billing error : ' );

        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);

        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);

        // Specify the text content of the email.
        mail.setPlainTextBody(errorMessage);

        mail.setHtmlBody(errorMessageHtml);

        // Send the email you have created.
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(exception e){
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.Error, 'Error: ' + e ));
        }
    }
    
    // *NEW* Query emails for 'accounting' && 'accounting manager' Roles -JS
    /*public List<User> getAccManEmails(){
        accManEmails = [
            SELECT Email, UserRole.Name
            FROM User
            WHERE (UserRole.Name = 'accounting' OR UserRole.Name = 'accounting manager')
            AND isActive = true
            AND FirstName = 'Test'
        ]; ///* FOR DEVELOPMENT WE ARE ONLY SENDING TO 'TEST' USER ( AND FirstName = 'Test' ) 
        
        return accManEmails;
    }*/


}