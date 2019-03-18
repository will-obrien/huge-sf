public class csvinsertcontroller{
    Public String file{get;set;}
    Public Blob body{get;set;}
    Public String[] csvline{get;set;}
    Public List<csv__c> record{get;set;}
    Public csvinsertcontroller(){
        csvline = new String[]{};  
        record = new  List<csv__c>();      
    }
    public void import(){
        record.clear();
        
        if(file==null){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No record to insert please load CSV file '));
        }
        else{
        
            
            
            file = body.toString();
            csvline = file.split('\n');
            for(integer i=0;i<csvline.size();i++){
                csv__c obj= new csv__c();
                String[] data = csvline[i].Split(',');
                obj.firstname__c=data[0];
                obj.lastname__c=data[1];
                obj.email__c = data[2];
                record.add(obj);               
            }
            
            
        }
        
    }
    Public void save(){
       if(record.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'please load CSV file'));            
       }
        else if(file!=null && record.isEmpty()){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'please show CSV file first then save'));
       }       
        else{            
              insert record;
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Succesfully inserted data'));
        }          
    }
    Public void csvprocess(){
        BatchClassForCsvInsert  obj = new BatchClassForCsvInsert();
        Database.executeBatch(obj,50);
    }    
}