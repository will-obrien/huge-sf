/*
MergeDelete

Created by: Mark Maslow
Created on: September, 2014

Merge Requests that get to this step should not have any child objects attached
that would prevent Accounts from being merged.

First, delete any child objects that are left.
Then, delete Accounts for Merge Requests that do not have a Retained Account
*/
public with sharing class MergeDelete {
    public static void processMerges(List<Merge_Request__c> mergeRequestList) {
        //Map to correlate Previous Account Id with Merge Request
        Map<Id, Merge_Request__c> accountToRequestMap = new Map<Id, Merge_Request__c>();
        
        for(Merge_Request__c request : mergeRequestList) {
            if(request.Retained_Account__c != request.Previous_Account__c) {
                accountToRequestMap.put((Id)request.Previous_Account__c, request);
            }
        }
        
        //Delete Account Addresses
        List<rC_Bios__Account_Address__c> accountAddressList = new List<rC_Bios__Account_Address__c>([
            SELECT Id, rC_Bios__Account__c FROM rC_Bios__Account_Address__c WHERE rC_Bios__Account__c in :accountToRequestMap.keySet()
        ]);
        if(accountAddressList.size() > 0) {
            Database.DeleteResult[] dr = Database.delete(accountAddressList, false);
            for(Integer i=0; i < accountAddressList.size(); i++) {
                rC_Bios__Account_Address__c accountAddr = accountAddressList.get(i);
                Merge_Request__c request = accountToRequestMap.get((Id)accountAddr.rC_Bios__Account__c);
                if( ! dr[i].isSuccess()) {
                    request.Error_Message__c = request.Error_Message__c + formatDeleteError(dr[i]);
                    accountToRequestMap.put((Id)accountAddr.rC_Bios__Account__c, request);
                }
            }
        }

        //Delete Memberships
        List<Membership__c> membershipList = new List<Membership__c>([
            SELECT Id, Member_Account__c FROM Membership__c WHERE Member_Account__c in :accountToRequestMap.keySet() 
        ]);
        
        if(membershipList.size() > 0) {
            Database.DeleteResult[] dr = Database.delete(membershipList, false);
            for(Integer i=0; i < membershipList.size(); i++) {
                Membership__c membership = membershipList.get(i);
                Merge_Request__c request = accountToRequestMap.get((Id)membership.Member_Account__c);
                if( ! dr[i].isSuccess()) {
                    request.Error_Message__c = request.Error_Message__c + formatDeleteError(dr[i]);
                    accountToRequestMap.put((Id)membership.Member_Account__c, request);
                }
            }
        }

        //Delete Leadership
        List<Leadership__c> leadershipList = new List<Leadership__c>([
            SELECT Id, Account__c FROM Leadership__c WHERE Account__c in :accountToRequestMap.keySet() 
        ]);
        if(leadershipList.size() > 0) {
            Database.DeleteResult[] dr = Database.delete(leadershipList, false);
            for(Integer i=0; i < leadershipList.size(); i++) {
                Leadership__c leadership = leadershipList.get(i);
                Merge_Request__c request = accountToRequestMap.get((Id)leadership.Account__c);
                if( ! dr[i].isSuccess()) {
                    request.Error_Message__c = request.Error_Message__c + formatDeleteError(dr[i]);
                    accountToRequestMap.put((Id)leadership.Account__c, request);
                }
            }
        }
        
        //Delete Reservations
        List<Reservation__c> reservationList = new List<Reservation__c>([
            SELECT Id, Account__c FROM Reservation__c WHERE Account__c in :accountToRequestMap.keySet() 
        ]);
        if(reservationList.size() > 0) {
            Database.DeleteResult[] dr = Database.delete(reservationList, false);
            for(Integer i=0; i < reservationList.size(); i++) {
                Reservation__c reservation = reservationList.get(i);
                Merge_Request__c request = accountToRequestMap.get((Id)reservation.Account__c);
                if( ! dr[i].isSuccess()) {
                    request.Error_Message__c = request.Error_Message__c + formatDeleteError(dr[i]);
                    accountToRequestMap.put((Id)reservation.Account__c, request);
                }
            }
        }
        
        //Delete Accounts for Merge Requests that do not have a Retained Account
        List<Id> accountsToDelete = new List<Id>();
        for(Merge_Request__c request : accountToRequestMap.values()) {
            if(String.isEmpty(request.Retained_Account__c)) {
                accountsToDelete.add((Id)request.Previous_Account__c);
            }
        }
        Database.DeleteResult[] dr = Database.delete(accountsToDelete, false);
        for(Integer i=0; i < accountsToDelete.size(); i++) {
            Id accountId = accountsToDelete[i];
            Merge_Request__c request = accountToRequestMap.get(accountId);
            if( ! dr[i].isSuccess()) {
                request.Error_Message__c = MergeProcessor.AppendMergeError(request.Error_Message__c, formatDeleteError(dr[i]));
                accountToRequestMap.put(accountId, request);
            }
        }
        
        //Update all Merge Requests
        List<Merge_Request__c> mergesToUpdate = new List<Merge_Request__c>();
        for(Merge_Request__c request : mergeRequestList) {
            Merge_Request__c processedMerge = accountToRequestMap.get((Id)request.Previous_Account__c);
            if(processedMerge != null) {
                if(! String.isEmpty(processedMerge.Error_Message__c)) {
                    request.Error_Message__c = processedMerge.Error_Message__c;
                }
            }
            request.Last_Step_Completed__c = MergeProcessor.deleteObjectsStep;
            request.Date_Last_Step_Completed__c = System.now();
            mergesToUpdate.add(request);
        }
        
        update mergesToUpdate;
    }
    private static String formatDeleteError(Database.DeleteResult dr) {
        String errMsg = '';
        for(Database.Error error : dr.getErrors()) {
            for(String field : error.getFields()) {
                errMsg += 'Field:' + field + ' '; 
            }
            errMsg += 'Message:' + error.getMessage();
        }
        if(errMsg.length() > 225) {
            errMsg = errMsg.substring(0, 225);
        }
        return errMsg;                  
    }
}