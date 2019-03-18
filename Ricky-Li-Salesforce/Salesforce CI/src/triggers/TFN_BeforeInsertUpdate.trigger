trigger TFN_BeforeInsertUpdate on Toll_Free_Number__c (before insert, before update) {
    Set<String> tfnNames = new Set<String>();
    for(Toll_Free_Number__c tfn: trigger.new){
        tfn.name = tfn.Phone_Number__c;
        tfnNames.add(tfn.name);        
    }
    List<Toll_Free_Number__c> tfnList = [select id, name, Phone_Number__c from Toll_Free_Number__c where name IN :tfnNames];
    
    Map<String, Toll_Free_Number__c> tfnsMap = new Map<String, Toll_Free_Number__c>();
    for(Toll_Free_Number__c t: tfnList){
        tfnsMap.put(t.name, t);
    }
        
    for(Toll_Free_Number__c tfn: trigger.new){
        if(tfnsMap.containsKey(tfn.name)){
            if(tfnsMap.get(tfn.name).Id != tfn.Id){
                tfn.addError('Toll Free Number ' + tfn.name + ' is already exist!');
            }
        }  
    }
}