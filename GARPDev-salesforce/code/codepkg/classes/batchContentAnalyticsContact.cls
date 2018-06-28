global class batchContentAnalyticsContact implements Database.Batchable<sObject>,Database.StateFul{
    
    public String mode;  
    global batchContentAnalyticsContact(String mode){
        this.mode = mode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        String strId = '0064000000dRTyi';
        return Database.getQueryLocator('select Id, Name, Content_Types_Viewed__c, Content_Viewed__c, Content_Viewed_Count__c, Content_Topics_Viewed__c from Contact where Content_Viewed_Count__c > 0');
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){

        MAP<Id, MAP<String, Integer>> mapViewed = new MAP<Id, MAP<String, Integer>>(); 
        
        system.debug('scope:' + scope.size());
        
        for(Contact c :scope) {
            
            system.debug('Contact:' + c);
            
            String[] arrText = c.Content_Viewed__c.split('~');                    
            if(arrText.size() > 0) {
                for(String s :arrText) {
                    
                    system.debug('s:' + s);
                    
                    MAP<String,Integer> fnd = mapViewed.get(s);
                    
                    system.debug('fnd:' + fnd);
                    
                    if(fnd != null) {
                        for(String s1 :arrText) {
                            if(s!=s1) {
                                Integer fndCnt = fnd.get(s1);
                                if(fndCnt != null)
                                    fndCnt++;
                                else fndCnt = 1;
                                fnd.put(s1,fndCnt);
                            }
                        }     
                        mapViewed.put(s,fnd);
                    } else {
                        MAP<String,Integer> newSet = new MAP<String,Integer>();
                        for(String s1 :arrText) {
                            if(s!=s1)
                                newSet.put(s1,1);
                        }
                        mapViewed.put(s,newSet);
                    }
                    
                    system.debug('mapViewed update:' + s + ':' + mapViewed.get(s));
                }
            }
            c.Content_Viewed__c=null;
            c.Content_Viewed_Count__c=0;
        }
        update scope;
        system.debug('mapViewed: ' + mapViewed);        

        List<Content__c> lstContent = [select Id, Name, Content_Other_Viewed__c, Content_Other_Viewed_Count__c from Content__c where Id in :mapViewed.keySet()];
        
        system.debug('lstContent:' + lstContent);
        for(Content__c cont :lstContent) {
            
            system.debug('cont:' + cont);
            
            MAP<String,Integer> contSet = new MAP<String,Integer>();
            if(cont.Content_Other_Viewed__c != null) {
                String[] arrText1 = cont.Content_Other_Viewed__c.split('~');                    
                if(arrText1.size() > 0) {
                    
                    system.debug('arrText1:' + arrText1);
                    
                    for(String s1 :arrText1) {
                        String[] arrVal = s1.split('!');
                        if(arrVal.size() > 1) {
                            Integer v;
                            if(arrVal[1] == 'null')
                                v=1;
                            else v = Integer.valueOf(arrVal[1]);
                            contSet.put(arrVal[0],v);
                        }
                        system.debug('contSet update:' + contSet.get(arrVal[0]));
                    }
                }   
            }
            
            system.debug('contSet:' + contSet);                
            MAP<String,Integer> fndSet = mapViewed.get(String.ValueOf(cont.Id));
            system.debug('fndSet:' + fndSet);                
            
            for(String s2: fndSet.keySet()) {
                Integer mapVal = fndSet.get(s2);
                Integer contVal = contSet.get(s2);
                
                system.debug('mapVal:' + mapVal + ':contVal:' + contVal);
                
                if(contVal != null) {
                    contVal+=mapVal;
                    contSet.put(s2,contVal);
                } else {
                    contSet.put(s2,mapVal);
                }
                system.debug('contSet:' + s2 + ':' + contSet.get(s2));
            }
            
            system.debug('contSet:' + contSet);
            
            String saveVal = '';
            for(String s3: fndSet.keySet()) {
                Integer contVal = contSet.get(s3);
                if(saveVal == '') {
                    saveVal = s3 + '!' + contVal;
                } else {
                    saveVal = saveVal + '~' + s3 + '!' + contVal;
                }
            }
            system.debug('saveVal:' + saveVal);
            cont.Content_Other_Viewed_Count__c = fndSet.keySet().size();
            cont.Content_Other_Viewed__c = saveVal;            
        }                           
        update lstContent;
    }
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}