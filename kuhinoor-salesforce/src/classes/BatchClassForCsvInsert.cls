Global Class BatchClassForCsvInsert implements Database.batchable<sobject>{
    List<Contact> conList;
    List<lightingprefix__csv__c> delList;
    List<lightingprefix__csv__c> updateList;
    Global BatchClassForCsvInsert(){
         conList = new List<Contact>();
         delList = new List<lightingprefix__csv__c>();
         updateList= new List<lightingprefix__csv__c>();
    }
    //----------------Start method------------------
    Global Database.QueryLocator start(Database.BatchableContext bc){
      return Database.getQueryLocator('select id,name,lightingprefix__firstname__c,lightingprefix__lastname__c,lightingprefix__email__c from lightingprefix__csv__c');  
    }
    Global void execute(Database.batchableContext bc,list<lightingprefix__csv__c> csvList){
        conList.clear();
        conList = new List<Contact>();
        updateList= new List<lightingprefix__csv__c>();
        delList = new List<lightingprefix__csv__c>();
        for(lightingprefix__csv__c cs : csvList){
          
            if(cs.lightingprefix__lastname__c != null || cs.lightingprefix__lastname__c ==''){
                
                    Contact con = new Contact();
                    lightingprefix__csv__c delobj = new lightingprefix__csv__c();
                    delobj.id = cs.id;
                    con.firstName = cs.lightingprefix__firstname__c;
                    con.lastname = cs.lightingprefix__lastname__c;
                    con.email = cs.lightingprefix__email__c;
                    conList.add(con);
                    delList.add(delobj);
                }
            
            else{
               
                lightingprefix__csv__c errobj = new lightingprefix__csv__c();
                errobj.id=cs.id;
                errobj.lightingprefix__Error__c = 'LastName is required';
                updateList.add(errobj);
            }
            
        }
        if(conList.size()>0){
            insert conList;
        }
        if(delList.size()>0){
            delete delList;
        }
        if(updateList.size()>0){
            update updateList;
        }
        
    }
    Global void Finish(Database.batchableContext bc){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Batch report');
            email.setToAddresses(new List<String>{'kuhinoor.alam@ibirdsservices.com'});         
            email.setHtmlBody('Batch Process has completed');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
            
    }
}