/**
 * @author Johan Östman
 * @version 1.1 2016-01-28
 */
public with sharing class ProcessPhaseController {

    public class AttributeException extends Exception {}
    
    public static final String STATUS_COMPLETE = 'complete';
    public static final String STATUS_CURRENT = 'current';    
    public static final String STATUS_TOCOMPLETE = 'tocomplete';    
    
    public class PhaseContainer {
        @AuraEnabled
        public String phase {get;set;}
        @AuraEnabled
        public String status {get;set;}
        
        public PhaseContainer(String phase, String status){
            this.phase = phase;
            this.status = status;
        }
    }    
    
    @AuraEnabled
    public static List<PhaseContainer> getPhaseList(String sObjectName, String fieldName, String recordId)
    {
        system.debug('sObjectName: ' + sObjectName);
        system.debug('fieldName: ' + fieldName);
        system.debug('recordId: ' + recordId);
        List<PhaseContainer> phaseList = new List<PhaseContainer>();

        if(fieldName == 'RecordType') fieldName = 'RecordTypeId';

        SObjectType objectType = Schema.getGlobalDescribe().get(sObjectName);        
        
        Map<Id, RecordType> rtMap;
        List<String> pleList = new List<String>();
        if(fieldName != 'RecordTypeId'){
            Map<String,Schema.SObjectField> mFields = objectType.getDescribe().fields.getMap();
            List<Schema.PicklistEntry> ple = mFields.get(fieldName).getDescribe().getPicklistValues(); 
			for(Schema.PicklistEntry p : ple){
            	pleList.add(p.getLabel());
            }
        }else{
            List<RecordType> rtList = [SELECT Id, Name, SobjectType FROM RecordType where SObjectType = :sObjectName];
            rtMap = new Map<Id, RecordType>(rtList);
            
            for(String rt : getAvailableRecordTypeNamesForSObject(sObjectName)){
            	pleList.add(rt);
            }
        }        
                           
        // Query the current phase
        String qStr = 'SELECT ' + fieldName + ' FROM ' + sObjectName + ' WHERE Id = \'' + recordId +'\' LIMIT 1';
        system.debug('qStr: ' + qStr);
        String currentPhase = '';
        if (recordId != null && recordId != ''){
            sObject sObj = Database.query(qStr);
            if (fieldName == 'RecordTypeId'){
                Id i = (Id)sObj.get(fieldName);
                currentPhase = rtMap.get(i).Name;
            }else{
                currentPhase = (String) sObj.get(fieldName);
            }
                        
        }

        
        String picklistValueStatus = STATUS_COMPLETE;
        
        for(String p : pleList)
       	{
            if (currentPhase == p){
                picklistValueStatus = STATUS_CURRENT;
            } else if(picklistValueStatus == STATUS_CURRENT){
                picklistValueStatus = STATUS_TOCOMPLETE;
            }
          	phaseList.add(new PhaseContainer(p, picklistValueStatus));
       	}

		system.debug(phaseList);
       	return phaseList;
    } 

    private static List<String> getAvailableRecordTypeNamesForSObject(String sObjTypeStr) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(sObjTypeStr);
        List<String> names = new List<String>();
        List<RecordTypeInfo> infos = objType.getDescribe().getRecordTypeInfos();
        if (infos.size() > 1) {
            for (RecordTypeInfo i : infos) {
               if (i.isAvailable() && !String.valueOf(i.getRecordTypeId()).endsWith('AAA')) 
                   names.add(i.getName());
            }
        } 
        else names.add(infos[0].getName());
        return names;
    }    
    
}