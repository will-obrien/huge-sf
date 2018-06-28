/*
MergeCheckChildren

Created by: Mark Maslow
Created on: September, 2014

Check Accounts that have been requested to be merged away for 
presence of child objects. 

Merge Requests that are requesting to merge away an Account or Contact with child objects attached
will be marked with an appropriate error message so no further processing
will be done for those requests.
*/
public with sharing class MergeCheckChildren {
	static Id opportunityProposalTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
	static Id opportunityDonationTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
	static Id opportunityTransactionTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Transaction').getRecordTypeId();

    public static void processMerges(List<Merge_Request__c> mergeRequestList) {
        //Create map to correlate Previous Account with Error Message
        Map<Id, String> prevAccountMap = new Map<Id, String>();
        for(Merge_Request__c req : mergeRequestList) {
            if(req.Retained_Account__c != req.Previous_Account__c) {
                prevAccountMap.put(req.Previous_Account__c, '');
            }
        }
        
        //Create map to correlate Previous Contact with Error Message
        Map<Id, String> prevContactMap = new Map<Id, String>();
        for(Merge_Request__c req : mergeRequestList) {
            if(req.Retained_Contact__c != req.Previous_Contact__c) {
                prevContactMap.put(req.Previous_Contact__c, '');
            }
        }

        //Check for Opportunities
        //Online transactions and donations should be merged
        //If Opportunities came from Neobiz, mark with error message 
        //and terminate processing of Merge Request            
        List<Opportunity> opList = new List<Opportunity>([
            SELECT Id, AccountId, RecordTypeId
            FROM Opportunity
            WHERE AccountId in :prevAccountMap.keySet()
            AND (
            	(RecordTypeId = :opportunityDonationTypeId AND Source__c != 'Batch Upload') OR
            	(RecordTypeId = :opportunityTransactionTypeId AND rC_Giving__Parent__r.Source__c != 'Batch Upload')
            )
        ]);
        for(Opportunity opp : opList) {
            String msg = prevAccountMap.get(opp.AccountId);
            if(msg != null) {
            	String objName;
            	if(opp.RecordTypeId == opportunityProposalTypeId) {
            		objName = 'Proposal';
            	} 
            	else {
            		objName = 'Opportunity';
            	}
                msg = addToMessage(msg, objName);
                prevAccountMap.put(opp.AccountId, msg);
            } 
        }

/*
        //Check for Preferences
        List<rC_Bios__Preference__c> prefList = new List<rC_Bios__Preference__c>([
            SELECT Id, rC_Bios__Account__c 
            FROM rC_Bios__Preference__c
            WHERE rC_Bios__Account__c in :prevAccountMap.keySet()
        ]);     
        for(rC_Bios__Preference__c pref : prefList) {
            String msg = prevAccountMap.get(pref.rC_Bios__Account__c);
            if(msg != null) {
                msg = addToMessage(msg, 'Preference');
                prevAccountMap.put(pref.rC_Bios__Account__c, msg);
            } 
        }
*/      
        //Check for Planned Giving
        List<rC_Giving__Planned_Giving__c> pgList = new List<rC_Giving__Planned_Giving__c>([
            SELECT Id, rC_Giving__Account__c 
            FROM rC_Giving__Planned_Giving__c 
            WHERE rC_Giving__Account__c in :prevAccountMap.keySet()
        ]);     
        for(rC_Giving__Planned_Giving__c pg : pgList) {
            String msg = prevAccountMap.get(pg.rC_Giving__Account__c);
            if(msg != null) {
                msg = addToMessage(msg, 'Planned Giving');
                prevAccountMap.put(pg.rC_Giving__Account__c, msg);
            } 
        }

        //Check for Relationship - Account1
        List<rC_Bios__Relationship__c> rel1List = new List<rC_Bios__Relationship__c>([
            SELECT Id, rC_Bios__Account_1__c 
            FROM rC_Bios__Relationship__c 
            WHERE rC_Bios__Account_1__c in :prevAccountMap.keySet()
        ]);     
        for(rC_Bios__Relationship__c rel1 : rel1List) {
            String msg = prevAccountMap.get(rel1.rC_Bios__Account_1__c);
            if(msg != null) {
                msg = addToMessage(msg, 'Account Relationship');
                prevAccountMap.put(rel1.rC_Bios__Account_1__c, msg);
            } 
        }

        //Check for Relationship - Account2
        List<rC_Bios__Relationship__c> rel2List = new List<rC_Bios__Relationship__c>([
            SELECT Id, rC_Bios__Account_2__c 
            FROM rC_Bios__Relationship__c 
            WHERE rC_Bios__Account_2__c in :prevAccountMap.keySet()
        ]);     
        for(rC_Bios__Relationship__c rel2 : rel2List) {
            String msg = prevAccountMap.get(rel2.rC_Bios__Account_2__c);
            if(msg != null) {
                msg = addToMessage(msg, 'Account Relationship');
                prevAccountMap.put(rel2.rC_Bios__Account_2__c, msg);
            } 
        }

        //Check for Relationships - Contact_1
        List<rC_Bios__Relationship__c> relList3 = new List<rC_Bios__Relationship__c>([
            SELECT Id, rC_Bios__Contact_1__c 
            FROM rC_Bios__Relationship__c 
            WHERE rC_Bios__Contact_1__c in :prevContactMap.keySet()
        ]);     
        for(rC_Bios__Relationship__c rel : relList3) {
            String msg = prevContactMap.get(rel.rC_Bios__Contact_1__c);
            if(msg != null) {
                msg = addToMessage(msg, 'Contact Relationship');
                prevContactMap.put(rel.rC_Bios__Contact_1__c, msg);
            } 
        }
        
        //Check for Relationships - Contact_2
        List<rC_Bios__Relationship__c> relList4 = new List<rC_Bios__Relationship__c>([
            SELECT Id, rC_Bios__Contact_2__c 
            FROM rC_Bios__Relationship__c 
            WHERE rC_Bios__Contact_2__c in :prevContactMap.keySet()
        ]);     
        for(rC_Bios__Relationship__c rel : relList4) {
            String msg = prevContactMap.get(rel.rC_Bios__Contact_2__c);
            if(msg != null) {
                msg = addToMessage(msg, 'Contact Relationship');
                prevContactMap.put(rel.rC_Bios__Contact_2__c, msg);
            } 
        }
        
        //Check for Contact Addresses
        List<rC_Bios__Contact_Address__c> addrList = new List<rC_Bios__Contact_Address__c>([
            SELECT Id, rC_Bios__Contact__c, ContactAccount18__c 
            FROM rC_Bios__Contact_Address__c 
            WHERE ContactAccount18__c in :prevAccountMap.keySet()
        ]);
        for(rC_Bios__Contact_Address__c addr : addrList) {
            String msg = prevAccountMap.get(addr.ContactAccount18__c);
            if(msg == null) {
                System.debug('prevAccountMap Entry NOT FOUND!');
            }
            if(msg != null) {
                msg = addToMessage(msg, 'Contact Address');
                prevAccountMap.put(addr.ContactAccount18__c, msg);
            } 
        }
       
        //Check for Salutations
        List<rC_Bios__Salutation__c> salList = new List<rC_Bios__Salutation__c>([
            SELECT Id, rC_Bios__Account__c 
            FROM rC_Bios__Salutation__c  
            WHERE rC_Bios__Account__c in :prevAccountMap.keySet()
        ]);     
        for(rC_Bios__Salutation__c sal : salList) {
            String msg = prevAccountMap.get(sal.rC_Bios__Account__c);
            if(msg != null) {
                msg = addToMessage(msg, 'Saluation');
                prevAccountMap.put(sal.rC_Bios__Account__c, msg);
            } 
        }
          
        /*
        //Check for Contacts with AddUp Id
        List<Contact> contList = new List<Contact>([
            SELECT Id
            FROM Contact  
            WHERE Id in :prevContactMap.keySet() AND Website_System_Id__c > ''
        ]);     
        for(Contact cont : contList) {
            String msg = prevContactMap.get(cont.Id);
            if(msg != null) {
                msg = addToMessage(msg, 'AddUpId');
                prevContactMap.put(cont.Id, msg);
            } 
        }
        */
        
        //Check for Contacts with User
        List<User> userList = new List<User>([
        	SELECT ContactId, Alias
        	FROM User
        	WHERE ContactId in :prevContactMap.keySet()
        ]);
        for(User usr : userList) {
            String msg = prevContactMap.get(usr.ContactId);
            if(msg != null) {
                msg = addToMessage(msg, 'User');
                prevContactMap.put(usr.ContactId, msg);
            } 
        }
        
        /*
        //Check for Tasks - WhatId
        List<Task> taskList2 = new List<Task>([
            SELECT Id, WhatId
            FROM Task  
            WHERE WhatId in :prevAccountMap.keySet()
        ]);     
        for(Task task2 : taskList2) {
            String msg = prevAccountMap.get(task2.WhatId);
            if(msg != null) {
                msg = addToMessage(msg, 'Task');
                prevAccountMap.put(task2.WhatId, msg);
            } 
        }

        //Check for Events - WhatId
        List<Event> eventList = new List<Event>([
            SELECT Id, WhatId
            FROM Event  
            WHERE WhatId in :prevAccountMap.keySet()
        ]);     
        for(Event ev : eventList) {
            String msg = prevAccountMap.get(ev.WhatId);
            if(msg != null) {
                msg = addToMessage(msg, 'Event');
                prevAccountMap.put(ev.WhatId, msg);
            } 
        }
        */
        
        //Populate Merge Requests with any error message found and set last step completed
        List<Merge_Request__c> mergesToUpdate = new List<Merge_Request__c>();
        for(Merge_Request__c request : mergeRequestList) {
            String errorMsg = (String)prevAccountMap.get(request.Previous_Account__c);
            if( ! String.isEmpty(errorMsg) ) {
                request.Error_Message__c = errorMsg;
            }
            else {
                errorMsg = (String)prevContactMap.get(request.Previous_Contact__c);
                if( ! String.isEmpty(errorMsg) ) {
                    request.Error_Message__c = errorMsg;
                }
            }
            request.Last_Step_Completed__c = MergeProcessor.checkChildrenStep;
            request.Date_Last_Step_Completed__c = System.now();
            mergesToUpdate.add(request);
        }
        
        //Save all Merge Requests
        if(mergesToUpdate.size() > 0) {
            Database.SaveResult[] srList = Database.update(mergesToUpdate, false);
            for(Database.SaveResult sr : srList) {
                if( ! sr.isSuccess() ) {
                    String errorMessage = formatSaveError(sr);
                    System.debug('Save Error:' + errorMessage);
                    throw new MergeException(errorMessage);
                }
            }
        }
    }
    private static String addToMessage(String currentMsg, String msgToAppend) {
        String returnMsg = '';
        if(currentMsg.contains(msgToAppend)) {
            return currentMsg;
        }
        if(String.isEmpty(currentMsg)) {
            //returnMsg = 'Child Object(s): ';
        }
        else {
            returnMsg = ', ';
        }
        returnMsg = currentMsg + returnMsg + msgToAppend;
        return returnMsg; 
    }
    private static String formatSaveError(Database.SaveResult sr) {
        String errMsg = '';
        for(Database.Error error : sr.getErrors()) {
            for(String field : error.getFields()) {
                errMsg += 'Field:' + field + ' '; 
            }
            errMsg += 'Message:' + error.getMessage();
        }
        return errMsg;                  
    }
}