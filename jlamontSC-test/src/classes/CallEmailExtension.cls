/*********************************************************************************************************
Name               : CallEmailExtension
Created by         : Pitamber Sharma (Appirio)
Created Date       : 2014/4/12
Description        : Handles the Call Report Email page and sending of emails
Comment            : VB: This page is just an unmitigated disaster.  I'm attempting to clean this up
                     and make it somehow useful.  The formatting on the emails makes this unusable by 
                     Advancement.
Updated			   : 2014/8/7 - Commenting and possible cleanup.
				   : VB : 2016/12/15 - Due to OoA security concerns, the text fields are being removed
				   		and replaced with a link to the Contact Report in CORE.
Updated			   : VB : 2017/2/20 - Added Next Steps field support
***********************************************************************************************************/
global class CallEmailExtension {
    
    public Task t {get;set;}
    public String toAddress{get;set;}
    public String ccAddress{get;set;}
    public String bccAddress{get;set;}
    public Call_Report__c call {get;set;}
    Public String recipients;

    // Constructor
    public CallEmailExtension(ApexPages.StandardController c) {
        
        // Retrieve the Task
        try{
            t = (Task) c.getRecord();
            t = [SELECT Subject, 
                 		OwnerId, 
                 		Owner.Name,
                 		Status,
                 		ActivityDate, 
                 		WhoId, 
                 		Who.Name, 
                 		WhatId, 
                 		What.Name, 
                 		Priority,
                 		CreatedDate,
                 		lastModifiedDate, 
                 		Overview__c, 
                 		Description,
                 		To__c, 
                 		Bcc__c 
                 	FROM Task 
                 	WHERE Id = :t.Id];

            //(A):fetch related call report
            // Retrieve the related Call Report object for this task.
            list<Call_Report__c> listcall = [SELECT Id, Parent_Task__c, 
                                             		X501_c_3_Discussion__c,
                                             		X501_c_4_Discussion__c, 
                                             		X527_Voter_Education_Discussion__c,
                                             		SCIA_Discussion__c, 
                                             		SCPC_Pol_Cmte_Discussion__c, 
                                             		Call_Type__c,
                                             		Philanthropic_Goals__c, 
                                             		Donor_Background__c, 
                                             		Gift_and_Financial_Planning__c, 
                                             		Assets__c,
                                             		Next_Steps__c
                                             	FROM Call_Report__c  
                                             	WHERE Parent_Task__c = :t.Id];

            // If there were related Call report objects 
            if(listCall.size()>0){

                // Only grab the first one ( No sort so it's random which one is picked)
                call = listCall.get(0);
            }
            // Shouldn't this be an error?
            else{
                call = new Call_Report__c();
            }
        } catch(Exception e) {
            // There's an error, so do NOTHING.  :(
        }
    }

	// Called when the user presses the "Send Email" button from the Call Report detail page, 
	// 		by hitting the "Send Report as Email" button.
    public PageReference doSendEmail(){            

        //(A):Set Up Email structure
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        //(A):Gather the Recipient information and prepare to store it in the task custom fields
        if (String.isNotBlank(toAddress)){
            
            String fixedTo= toAddress.ReplaceAll(',+',' ');
            email.setToAddresses(fixedTo.split('\\s+'));
            
            if(fixedTo.length() > 255) {
                fixedTo = fixedTo.substring(0, 254);
                fixedTo = fixedTo.substring(0, fixedTo.lastIndexOf(' '));
                t.To__c = fixedTo.substring(0, 254);
            } else {
                t.To__c = fixedTo;
            }
        }
        if (String.isNotBlank(ccAddress)){
            String fixedCC = ccAddress.ReplaceAll(',+',' ');
            email.setCcAddresses(fixedCC.split('\\s+'));
            if(fixedCC.length() > 255) {
                fixedCC = fixedCC.substring(0, 254);
                fixedCC = fixedCC.substring(0, fixedCC.lastIndexOf(' '));
                t.CC__c = fixedCC.substring(0, 254);
            } else {
                t.CC__c = fixedCC;
            }
        }
        if (String.isNotBlank(bccAddress)){
            String fixedBcc = bccAddress.ReplaceAll(',+',' ');
            email.setBccAddresses(fixedBcc.split('\\s+'));
             if(fixedBcc.length() > 255) {
                fixedBcc = fixedBcc.substring(0, 254);
                fixedBcc = fixedBcc.substring(0, fixedBcc.lastIndexOf(' '));
                t.Bcc__c = fixedBcc.substring(0, 254);
            } else {
                t.Bcc__c = fixedBcc;
            }
        }
        
        system.debug('email.getToAddresses ::: ' + email.getToAddresses());
        system.debug('email.getCcAddresses ::: ' + email.getCcAddresses());
        system.debug('email.getBccAddresses ::: ' + email.getBccAddresses());

        email.setReplyTo(UserInfo.GetUserEmail());
        email.setSubject('Contact Report for: ' + t.What.Name);
       
        //(A):Store the Emails we sent the report to
        // Update the task, saying the email was sent.
        t.Email_Sent__c= true;       
        update t;
    
        //(A):Get Labels to display for both call types
        String whatLabel = Schema.sObjectType.Task.fields.WhatId.getSObjectField().getDescribe().getLabel();
        String whoLabel = Schema.sObjectType.Task.fields.WhoId.getSObjectField().getDescribe().getLabel();
        String subjectLabel= Schema.sObjectType.Task.fields.Subject.getSObjectField().getDescribe().getLabel();
        String overviewLabel = Schema.sObjectType.Task.fields.Overview__c.getSObjectField().getDescribe().getLabel();
        String statusLabel = Schema.sObjectType.Task.fields.Status.getSObjectField().getDescribe().getLabel();
        String commentLabel = Schema.sObjectType.Task.fields.Description.getSObjectField().getDescribe().getLabel();
        String callTypeLabel = Schema.sObjectType.Call_Report__c.fields.Call_Type__c.getSObjectField().getDescribe().getLabel();
        
        //(A):Forming the HTML for the reportInfo
        // Who thinks this way???
        String br = '<br>';
        String col = ': ';
        String b ='<b>';
        String bEnd ='</b>';
        //String contactReportHTML = b + whatLabel + col + bEnd + t.What.Name + br +
        //                           b + whoLabel + col + bEnd + t.Who.Name + br + 
        //                           b + subjectLabel + col + bEnd + t.Subject + br + 
        //                           b + Label.Completed_Date + col +bEnd + t.ActivityDate + br + 
        //                           b + statusLabel + col + bEnd + t.Status + br + 
        //                           b + overviewLabel + col + bEnd + t.Overview__c + br +
        //                           b + callTypeLabel + col + bEnd + call.Call_Type__c + br + br;
        String contactReportHTML = '';
		//contactReportHTML = '<head><style>pre.mine {font-family: inherit;font-size: inherit;color: red;}</style></head><body>';
        
        String subjectLink = '<a href=' + 'http://' + ApexPages.currentPage().getHeaders().get('Host') + '/' + t.Id + '>' + t.Subject + '</a>';
        String whatLink = '<a href=' + 'http://' + ApexPages.currentPage().getHeaders().get('Host') + '/' + t.WhatId + '>' + t.What.Name + '</a>';
        String whoLink = '';
        if (null == t.Who.Name) {
            whoLink = 'n/a';
        } else {
            whoLink = '<a href=' + 'http://' + ApexPages.currentPage().getHeaders().get('Host') + '/' + t.WhoId + '>' + t.Who.Name + '</a>';
        }
        
        String txt = 'http://' + ApexPages.currentPage().getHeaders().get('Host') + '/';
            
        contactReportHTML += '<b>' + whatLabel 				+ ':</b> ' + WhatLink	 				+ '<br />' +
                            '<b>' + 'Contact' 				+ ':</b> ' + WhoLink	 				+ '<br />' +
							'<b>' + subjectLabel 			+ ':</b> ' + subjectLink				+ '<br />' +
                            '<b>' + Label.Completed_Date 	+ ':</b> ' + t.ActivityDate.format()	+ '<br />' +
                            '<b>' + statusLabel 			+ ':</b> ' + t.Status 					+ '<br />' +
                            '<b>' + callTypeLabel			+ ':</b> ' + call.Call_Type__c 			+ '<br />' +
                            '<br />' +
                            '<b>' + overviewLabel		+ ':</b><br />' +
            				t.Overview__c	+ '<br />' +
                            '<br />';
        
        // If this is a Major Giving Call Report
        if (call.Call_Type__c == 'Major Giving'){
            
            // 12/15/16 - VB Add Link to Contact Report
            contactReportHTML += 'Please see full <a href=\"https://sierraclub.my.salesforce.com/' + t.Id + '\">contact report</a> in CORE.<br /><br />';
            
           //Get Major Giving Labels
           //String x501c3Label = Schema.sObjectType.Call_Report__c.fields.X501_c_3_Discussion__c.getSObjectField().getDescribe().getLabel();
           //String x501c4Label = Schema.sObjectType.Call_Report__c.fields.X501_c_4_Discussion__c.getSObjectField().getDescribe().getLabel();
           //String x527VoterLabel = Schema.sObjectType.Call_Report__c.fields.X527_Voter_Education_Discussion__c.getSObjectField().getDescribe().getLabel();
           //String sciaLabel = Schema.sObjectType.Call_Report__c.fields.SCIA_Discussion__c.getSObjectField().getDescribe().getLabel(); 
           //String scpcLabel = Schema.sObjectType.Call_Report__c.fields.SCPC_Pol_Cmte_Discussion__c.getSObjectField().getDescribe().getLabel();
           String nextstepsLabel = Schema.sObjectType.Call_Report__c.fields.Next_Steps__c.getSObjectField().getDescribe().getLabel();
       
           //(A):Build HTML with labels and values
           // Weird double + + in the formatting, and produces a mass text blob.
           // Since this format puts the carriage returns after the labels, the additional spacing is incorrect.
           // This really sucks formatting-wise.
           //contactReportHTML = contactReportHTML + b + x501c3Label + col + bEnd + br + call.X501_c_3_Discussion__c + br + br +
           //                                      + b + x501c4Label + col + bEnd + br + call.X501_c_4_Discussion__c + br + br +
           //                                      + b + x527VoterLabel + col + bEnd + br + call.X527_Voter_Education_Discussion__c + br + br +
           //                                      + b + sciaLabel + col + bEnd + br + call.SCIA_Discussion__c + br + br +
           //                                      + b + scpcLabel + col + bEnd + br + call.SCPC_Pol_Cmte_Discussion__c + br + br;

			// VB: 2/20/17 - Adding Next Steps into the emails
            // Add the Next Steps label
			contactReportHTML += '<b>' + nextstepsLabel + ':</b><br />';
            
            // If the next steps field isn't blank
            if(!String.isBlank(call.Next_Steps__c) ) {
                contactReportHTML += '<pre style=\"font-family:inherit;font-size:inherit;\">' + call.Next_Steps__c + '</pre>';
            }


            // Add the c3 label
            // <style>pre.mine {font-family: inherit;font-size: inherit;}</style>
            // 
//			contactReportHTML += '<b>' + x501c3Label + ':</b><br />';
            
            // If the c3 field isn't blank
//            if(!String.isBlank(call.X501_c_3_Discussion__c) ) {
//                contactReportHTML += '<pre style=\"font-family:inherit;font-size:inherit;\">' + call.X501_c_3_Discussion__c + '</pre>';
//            }
//			contactReportHTML += '<br /><br />';
//            contactReportHTML += '<b>' + x501c4Label + ':</b><br />';
//            if(!String.isBlank(call.X501_c_4_Discussion__c) ) {
//            	contactReportHTML += '<pre style=\"font-family:inherit;font-size:inherit;\">' + call.X501_c_4_Discussion__c + '</pre>';
//            }
//			contactReportHTML += '<br /><br />';
//            contactReportHTML += '<b>' + x527VoterLabel + ':</b><br />';
//            if(!String.isBlank(call.X527_Voter_Education_Discussion__c) ) {
//				contactReportHTML += '<pre style=\"font-family:inherit;font-size:inherit;\">' + call.X527_Voter_Education_Discussion__c + '</pre>';
//            }
//			contactReportHTML += '<br /><br />';
//            contactReportHTML += '<b>' + sciaLabel + ':</b><br />';
//            if(!String.isBlank(call.SCIA_Discussion__c) ) {
//            	contactReportHTML += '<pre style=\"font-family:inherit;font-size:inherit;\">' + call.SCIA_Discussion__c + '</pre>';
//            }
//			contactReportHTML += '<br /><br />';
//            contactReportHTML += '<b>' + scpcLabel + ':</b><br />';
//            if(!String.isBlank(call.SCPC_Pol_Cmte_Discussion__c) ) {
//            	contactReportHTML += '<pre style=\"font-family:inherit;font-size:inherit;\">' + call.SCPC_Pol_Cmte_Discussion__c + '</pre>';
//            }
//			contactReportHTML += '<br /><br />';
//            contactReportHTML += '<br />';
            
            // Replace the Newlines with the HTML br
//            contactReportHTML.replaceAll('\r\n','<br/>');
        }
        // If this is a Planned Giving Call Report
        else if (call.Call_type__c == 'Planned Giving'){

            // 12/15/16 - VB Add Link to Contact Report
            contactReportHTML += 'Please see full <a href=\"https://sierraclub.my.salesforce.com/' + t.Id + '\">contact report</a> in CORE.<br /><br />';

            
            //Get Planned Giving Labels
//            String donorBGLabel = Schema.sObjectType.Call_Report__c.fields.Donor_Background__c.getSObjectField().getDescribe().getLabel();
//            String assetsLabel = Schema.sObjectType.Call_Report__c.fields.Assets__c.getSObjectField().getDescribe().getLabel();
//            String philanthropyLabel = Schema.sObjectType.Call_Report__c.fields.Philanthropic_Goals__c.getSObjectField().getDescribe().getLabel();
//            String giftAndFinancialLabel = Schema.sObjectType.Call_Report__c.fields.Gift_and_Financial_Planning__c.getSObjectField().getDescribe().getLabel();
           String nextstepsLabel = Schema.sObjectType.Call_Report__c.fields.Next_Steps__c.getSObjectField().getDescribe().getLabel();

			// VB: 2/20/17 - Adding Next Steps into the emails
            // Add the Next Steps label
			contactReportHTML += '<b>' + nextstepsLabel + ':</b><br />';
            
            // If the next steps field isn't blank
            if(!String.isBlank(call.Next_Steps__c) ) {
                contactReportHTML += '<pre style=\"font-family:inherit;font-size:inherit;\">' + call.Next_Steps__c + '</pre>';
            }

        
            //Build HTML with labels and values
//            contactReportHTML = contactReportHTML + b + donorBGLabel + col + bEnd + br + call.Donor_Background__c + br + br +
//                                                  + b + assetsLabel + col + bEnd + br + call.Assets__c + br + br +
//                                                  + b + philanthropyLabel + col + bEnd + br + call.Philanthropic_Goals__c + br + br +
//                                                  + b + giftAndFinancialLabel + col + bEnd + br + call.Gift_and_Financial_Planning__c + br + br;
        }
        
        //
        // Add the comments to the end of the contact report
        // 
        //contactReportHTML = contactReportHTML + b + Label.Comments_in_Contact_Reports + col + bEnd + br + t.Description;
//        contactReportHTML = contactReportHTML + b + Label.Comments_in_Contact_Reports + col + bEnd + br;
//        if(!String.isBlank(t.Description) ) {
//            contactReportHTML += '<pre style=\"font-family:inherit;font-size:inherit;\">' + t.Description + '</pre>';
//		}
   		//contactReportHTML += '</body>';

//        system.debug('HTML code: ' + contactReportHTML);
        
        //(A):Replace the 'null' value returned by salesforce with a break in the HTML code
        // This appears to be useless, and doesn't work to catch the previous formatting.
        contactReportHTML = contactReportHTML.replace(': </b>null<br>',': </b><br>');
        
        //(A):Set Email body to the HTML we put together
        email.setHTMLBody(contactReportHTML);
        
        List<Messaging.SendEmailResult> results = 
            Messaging.sendEmail(new Messaging.Email[] { email });
        if (!results.get(0).isSuccess()) {
            System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
            String errorMessage = results.get(0).getErrors()[0].getMessage();
    
        }
        
    return new PageReference('/'+t.Id);
    }
    
    @RemoteAction
    global static List<TabWrapper> fetchListOfTags(String searchString){
        List<TabWrapper> listOfTags =  new List<TabWrapper>();
        System.debug('---------'+searchString);
        for(User tg : Database.query(
            	'SELECT Id, Name, Email FROM User WHERE IsActive = true AND Profile.UserLicense.LicenseDefinitionKey = \'SFDC\' AND Name Like \'%'+searchString+'%\' LIMIT 20')){
        listOfTags.add(New TabWrapper(tg));
        }
        return listOfTags;
    }
    global class TabWrapper {
            public String Label {get;set;}
            public String Id {get;set;}
            public tabWrapper(User usr) {
        Label = usr.Name + '(' + usr.Email + ')';
        Id = usr.Email;
            }
    }

}