//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Handler Class for PlannedGiving Trigger 
//  24 Feb 2014     Pitamber Sharma (Appirio)     Original
//  24 March 2013       Pitamber Sharma (Appirio)           Updated as per T-264764
//  
//  5 December 2014   Maslow   Added AccountId to new Opportunity
//**********************************************************************/

public without sharing class PlannedGivingTriggerHandler {
    
    static Map<String, Planned_Giving_Opportunity_Mapping__c> fieldMappingMap;
    static Map<String, Date> forecastingMap = new Map<String, Date>();
    static Id rTypeId;
    
    static{
        fieldMappingMap = Planned_Giving_Opportunity_Mapping__c.getAll();
        rTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Proposal').RecordTypeId;    
        for(Forecasting__c f : Forecasting__c.getAll().values()) {
            forecastingMap.put(f.Year__c, f.Beginning_Yr_Forecast_Final_Date__c);
        }   
    }
    
    public static void onAfterInsert(List<rC_Giving__Planned_Giving__c> newList) {
        List<Opportunity> newOpptyList = new List<Opportunity>();
        Opportunity oppty;
        
        for(rC_Giving__Planned_Giving__c newPG : newList) {
            if(isValidPlannedGiving(newPG, null)) {
                if(newPG.Include_in_Forecast__c) {
                    oppty = new Opportunity();
                    oppty.RecordTypeId = rTypeId;
                    oppty.rC_Giving__Planned_Giving__c = newPG.Id;
                    for(Planned_Giving_Opportunity_Mapping__c cs : fieldMappingMap.values()) {
                        oppty.put(cs.Opportunity_Field_Name__c, newPG.get(cs.Planned_Giving_Field_Name__c));
                    }
                    
                    //MM 5 December 2014 Begin
                    oppty.AccountId = newPG.rC_Giving__Account__c;
                    //MM End
                    
                    newOpptyList.add(oppty);
                }
            }
        }
        
        if(newOpptyList.size() > 0) {
            insert newOpptyList;
        }
    }
    
    public static void onAfterUpdate(List<rC_Giving__Planned_Giving__c> newList, Map<Id, rC_Giving__Planned_Giving__c> oldMap) {
        Set<String> updatedPGIds = new Set<String>();
        for(rC_Giving__Planned_Giving__c newPG : newList) {
            if(isValidPlannedGiving(newPG, oldMap.get(newPG.Id))) {
                if(isUpdated(newPG, oldMap.get(newPG.Id))) {
                    updatedPGIds.add(newPG.Id);
                }
            }
        }
        
        Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>();
        String query = 'SELECT Id, rC_Giving__Planned_Giving__c';
        for(Planned_Giving_Opportunity_Mapping__c cs : fieldMappingMap.values()) {
            query += ', ' + cs.Opportunity_Field_Name__c;
        }
        
        query += ' FROM Opportunity WHERE rC_Giving__Planned_Giving__c IN (' + listToQueryString(updatedPGIds) + ')';
        
        system.debug('@@@ query : ' + query);
        
        for(Opportunity opportunty : Database.query(query)) {
            opptyMap.put(opportunty.rC_Giving__Planned_Giving__c, opportunty);
        }
        
        List<Opportunity> updateableOpptyList = new List<Opportunity>();
        Opportunity oppty;
         
        for(rC_Giving__Planned_Giving__c newPG : newList) {
            if(opptyMap.containsKey(newPG.Id)) {
                oppty = opptyMap.get(newPG.Id);
                for(Planned_Giving_Opportunity_Mapping__c cs : fieldMappingMap.values()) {
                    oppty.put(cs.Opportunity_Field_Name__c, newPG.get(cs.Planned_Giving_Field_Name__c));
                }
                updateableOpptyList.add(oppty);
            } else if(newPG.Include_in_Forecast__c) {
                oppty = new Opportunity();
                oppty.RecordTypeId = rTypeId;
                oppty.rC_Giving__Planned_Giving__c = newPG.Id;
                for(Planned_Giving_Opportunity_Mapping__c cs : fieldMappingMap.values()) {
                    oppty.put(cs.Opportunity_Field_Name__c, newPG.get(cs.Planned_Giving_Field_Name__c));
                }
                updateableOpptyList.add(oppty);
            }
        }
        
        if(updateableOpptyList.size() > 0) {
            try {
              upsert updateableOpptyList;
            } catch (DMLException e) {
              for(Opportunity opptyerr : updateableOpptyList){
                opptyerr.addError('Exception occurred'+e.getCause());
              }
            }
        }
    }
    
    private static Boolean isUpdated(rC_Giving__Planned_Giving__c newPG, rC_Giving__Planned_Giving__c oldPG) {
        for(Planned_Giving_Opportunity_Mapping__c cs : fieldMappingMap.values()) {
            if(newPG.get(cs.Planned_Giving_Field_Name__c) != oldPG.get(cs.Planned_Giving_Field_Name__c)) {
                return true;
            }
        }
        return true;
    }
    
    private static String listToQueryString(Set<String> strLst) {
        if(strLst == null || strLst.size() == 0) {
            return '\'\'';
        }
        String retStr = '';
        for(String val : strLst) {
            if(val != null && !val.equals('')) {
                retStr += '\'' + val + '\',';
            }
        }
        system.debug('@@@@ retStr : ' + retStr + '  @@@ ' + strLst);
        retStr = retStr.contains(',') ? retStr.substring(0, retStr.lastIndexOf(',')) : '\'\'';
        return retStr;
    }
    
    private static Boolean isValidPlannedGiving(rC_Giving__Planned_Giving__c newPG, rC_Giving__Planned_Giving__c oldPG) {
        String closeYear = String.valueOf(newPG.rC_Giving__Expected_Final_Distribution_Date__c.year());
        Date sDate, eDate;
        if(forecastingMap.containsKey(closeYear)) {
            sDate = Date.newInstance((Integer.valueOf(closeYear) - 1), 10, 1);
            eDate = Date.newInstance((Integer.valueOf(closeYear) - 1), 12, 31);
            if(Date.today() >= sDate && Date.today() <= eDate && newPG.Beginning_Yr_Forecast__c == null && oldPG == null) {
                newPG.Beginning_Yr_Forecast__c.addError('Beginning Year Forecast can not be empty!');
                return false;
            }
            if(Date.today() >= forecastingMap.get(closeYear) && newPG.Beginning_Yr_Forecast__c != null && oldPG == null) {
                newPG.Beginning_Yr_Forecast__c.addError('Beginning Year Forecast can not be set after ' + forecastingMap.get(closeYear).format() + ' for closing year ' + closeYear + '.');
                return false;
            }
            if(Date.today() >= forecastingMap.get(closeYear) && oldPG != null && newPG.Beginning_Yr_Forecast__c != oldPG.Beginning_Yr_Forecast__c) {
                newPG.Beginning_Yr_Forecast__c.addError('Beginning Year Forecast can not be updated after ' + forecastingMap.get(closeYear).format() + ' for closing year ' + closeYear + '.');
                return false;
            }
        }
        return true;
    }

}