trigger recordupdate on A__c (before update) {
    list<lightingprefix__A_clone__c> recordList = new list<lightingprefix__A_clone__c>();    
    set<String> codeSet = new Set<String>();
    Map<String, Schema.SObjectField> ObjectFieldMap = Schema.SObjectType.A__C.fields.getMap();
    for(A__c obj : trigger.new){
        codeSet.add(obj.code__c);
        lightingprefix__A_clone__c obj1 = new lightingprefix__A_clone__c();
        boolean isCheck=false;
        for(String str : ObjectFieldMap.keySet()){    
            if(ObjectFieldMap.get(str).getDescribe().isUpdateable()){       
            if(obj.get(str) != trigger.oldMap.get(obj.id).get(str)){                
                obj1.put(str,obj.get(str));
                isCheck = true;     
            }
           }
        }
          if(isCheck){
              //recordList.add(obj1);
          }  
    }    
    if(recordList.size() > 0){
        // INSERT recordList;
    }  
    map<String,lightingprefix__A_clone__c> codeMap = new   map<String,lightingprefix__A_clone__c>();
    
     for(lightingprefix__A_clone__c  acln : [select code__c from lightingprefix__A_clone__c  where code__c IN : codeSet]){
            codeMap.put(acln.code__c,acln);
        }
        
        
     for(A__c aobj : trigger.new){
      lightingprefix__A_clone__c obj1 = new lightingprefix__A_clone__c();
      boolean isCheck=false;
      if(codeMap.containsKey(aobj.code__c)){   
            for(String str : ObjectFieldMap.keySet()){    
                    if(ObjectFieldMap.get(str).getDescribe().isUpdateable()){       
                        if(aobj.get(str) != trigger.oldMap.get(aobj.id).get(str)){                
                           // obj1.id = codeMap.get(aobj.code__c).id;
                            obj1.put(str,aobj.get(str));
                            isCheck = true;                
                        }
                   } 
            }
          }else{
              for(String str : ObjectFieldMap.keySet()){    
                    if(ObjectFieldMap.get(str).getDescribe().isUpdateable()){       
                        if(aobj.get(str) != trigger.oldMap.get(aobj.id).get(str)){                
                            obj1.code__c = aobj.code__c;
                            obj1.put(str,aobj.get(str));
                            isCheck = true;
                        }
                   } 
            }
          }
           if(isCheck){
               if(codemap.containskey(aobj.code__c)){
                    obj1.id = codeMap.get(aobj.code__c).id;                    
               }                
                recordList.add(obj1);
           }          
        }
        
        if(recordList.size() > 0){
            upsert recordList;
        }
   
}