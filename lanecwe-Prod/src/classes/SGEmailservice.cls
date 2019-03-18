/*** This class gets invoked from PGI_Contract tigger "SGSendemail" to send emails to contract record owner and contract team (only accepted contracts)
 ***/ 
public with sharing class SGEmailservice {
    public static void sendsEmail(CONMAN_Contract__c cntrctdata ){
        string subject;
        string htmlBody;
        List<OrgWideEmailAddress> orgWideAddress = [select Id from OrgWideEmailAddress where Address = 'salesforcecrmsupport@pgi.com'];
        user owneremail = [select email, name from user where id = :cntrctdata.ownerid];
        String[] toAddresses = new String[] {owneremail.email};
        //boolean mailtocontractteam = false;
        string bodymessage = 'Click below links for more details. <br> <br>';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
        	mail.setOrgWideEmailAddressId(orgWideAddress.get(0).id);
        	//mail.setSenderDisplayName('Salesforce CRM Support');
            if(cntrctdata.Contract_Status__c == 'Sent To Customer'){
               subject = 'Your Sales Gateway customer record has been created in SFDC';
            }else if(cntrctdata.Contract_Status__c == 'Customer Accepted'){
               //mailtocontractteam = true;
               subject = 'SG Customer has accepted the contract, Please update the opportunity stage to closed won';
            }else if(cntrctdata.Contract_Status__c == 'Customer Rejected'){
               subject = 'SG Customer has rejected the contract, Please update the opportunity stage to closed lost';
            }
            
        	if(cntrctdata.Contract_Status__c == 'Customer Rejected' || cntrctdata.Contract_Status__c == 'Customer Accepted'){
                try {
                    list<opportunitylineitem> opptyprdcts = [select id, product2.name from opportunitylineitem where Unit_Type__c = 'Event' and OpportunityId = :cntrctdata.Opportunity__c];
                	System.debug('opptyprdcts: ' + opptyprdcts);
                    String opportunityProducts;
                 	
                    for (OpportunityLineItem oli : opptyprdcts) {
                        opportunityProducts = '<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+ opptyprdcts[0].id   + '">' + string.valueOf(opptyprdcts[0].product2.name) + '<br>';
                        //opportunityProducts = string.valueOf(opptyprdcts[0].product2.name) + ': ' + '<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+ opptyprdcts[0].id   + '">' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ opptyprdcts[0].id  +'</a> <br>';
                    }
                    for (Integer i = 1; i < opptyprdcts.size(); i++) {
                        //opportunityProducts = opportunityProducts + string.valueOf(opptyprdcts[i].product2.name) + ': ' + '<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+ opptyprdcts[i].id   + '">' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ opptyprdcts[i].id  +'</a> <br>';//'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+ opptyprdcts[i].id;
                    	opportunityProducts = opportunityProducts + '<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+ opptyprdcts[i].id   + '">' + string.valueOf(opptyprdcts[i].product2.name) + '<br>';
                    }
                  
                 	if(opptyprdcts.size() > 0){ 
                 		bodymessage = 'Opportunity contains below event based products, please update the quantity and unit price: <br><br>' + opportunityProducts + '</a><br>'+
                 		'Click below links for more details. <br> <br>';
              		}
              	} catch(exception e) {
                // No action required  
              	}
            }
        
            mail.setSubject(subject);
            htmlBody = owneremail.name +', <br> <br>'+ bodymessage +
                'Opportunity :' + '<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+ cntrctdata.Opportunity__c   + '">' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ cntrctdata.Opportunity__c  +'</a> <br>'+
                'Account     :' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'  + cntrctdata.Account_Name__c + '">' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ cntrctdata.Account_Name__c +'</a> <br>'+
                'Contract    :' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'  + cntrctdata.id              + '">' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ cntrctdata.id              +'</a> <br>';
            mail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        	
        	/*if(mailtocontractteam){
              toAddresses.clear();  
	          ToAddresses.add('subbuzind@gmail.com');
        	  bodymessage = 'Click below links for more details <br> <br>';
              htmlBody = UserInfo.getName()+', <br> <br>'+ bodymessage +
                  'Opportunity :' + '<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+ cntrctdata.Opportunity__c   + '">' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ cntrctdata.Opportunity__c  +'</a> <br>'+
                  'Account     :' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'  + cntrctdata.Account_Name__c + '">' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ cntrctdata.Account_Name__c +'</a> <br>'+
                  'Contract    :' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'  + cntrctdata.id              + '">' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ cntrctdata.id              +'</a>';
              mail.setHtmlBody(htmlBody);
	          mail.setToAddresses(toAddresses);
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        	}*/
     }
}