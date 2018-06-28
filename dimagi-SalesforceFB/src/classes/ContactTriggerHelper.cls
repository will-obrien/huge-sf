public class ContactTriggerHelper{

    public static void UpdateEmployee(Map<Id,Contact> oldContactMap,List<Contact> contactList) {
        
        if(CheckRecursive.firstRun){
        
        //System.debug('Update EMP Fire');
        CheckRecursive.firstrun=false;
        
            List<SFDC_Employee__c> empList=[select id,Contact__c,Email_Address__c,Entity__c from SFDC_Employee__c where Contact__c=:contactList];
            
            Map<id,SFDC_Employee__c> contactEmployeeMap=new Map<id,SFDC_Employee__c>();
            
            for(SFDC_Employee__c emp:empList){
               
               if(!contactEmployeeMap.containsKey(emp.Contact__c)){
                   contactEmployeeMap.put(emp.Contact__c,emp);
               }
               
            }
            
            Set<id> accountIds=new Set<id>();
            Set<id> reportToIds=new Set<id>();
           
            for(Contact con:contactList){
                accountIds.add(con.accountid);
                reportToIds.add(con.ReportsToId);
            }
        
        
        Map<id,Account> accountMap=new Map<id,Account>([select id, name from account where id=:accountIds]);
        //Map<id,Contact> reportToMap=new Map<id,Contact>([select id, name from Contact where id=:reportToIds]);
        
        List<SFDC_Employee__c> reportTOEmpList=[select id,Contact__c from SFDC_Employee__c where Contact__c=:reportToIds];
        map<Id,id> reportTOEmpMap=new map<Id,id>();
        for(SFDC_Employee__c emp:reportTOEmpList){
            if(!reportTOEmpMap.containsKey(emp.Contact__c)){
              reportTOEmpMap.put(emp.Contact__c,emp.id);
            }
        }      
                
                
                
        List<SFDC_Employee__c> updateEmpList=new List<SFDC_Employee__c>();
        
        for(Contact con :contactList){
            if(contactEmployeeMap.containsKey(con.id)){
            
                     Boolean shouldUpdateEmployee = false;
                     SFDC_Employee__c updateEmp=contactEmployeeMap.get(con.id);
                  
                      System.debug('Update EMP Fire: '+updateEmp.id);
                      Account acc=accountMap.get(con.AccountId);
                      //string empName='';
                      
                      Contact oldContact = oldContactMap.get( con.Id ); // Mustafa : Date : 3-Dec-15

                      if(con.FirstName==null && oldContact.LastName != con.LastName){
                          //empName=con.LastName;
                          updateEmp.Name = con.LastName;
                          shouldUpdateEmployee = true;
                      }
                      else if(oldContact.FirstName != con.FirstName || oldContact.LastName != con.LastName){ // Mustafa : Date : 3-Dec-15
                          //empName=con.FirstName+' '+con.LastName;
                          updateEmp.Name = con.FirstName+' '+con.LastName;
                          shouldUpdateEmployee = true;
                      }
                      
                      //updateEmp.Name =empName; //con.FirstName != Null ? con.FirstName : '' + ' '+con.LastName!= Null ? con.LastName: '';
                      /*  
                      if(acc!=null){
                          if(updateEmp.Entity__c != acc.Name) {
                              updateEmp.Entity__c = acc.Name;
                              shouldUpdateEmployee = true;
                          }
                      }
                      */
                      
                      if(con.Country__c != null && oldContact.Country__c != con.Country__c){ // Mustafa : Date : 3-Dec-15
                          updateEmp.Country__c=con.Country__c;
                          shouldUpdateEmployee = true;
                      }
                      
                      if(con.Department != null && oldContact.Department != con.Department){ // Mustafa : Date : 3-Dec-15
                          updateEmp.Sub_Unit__c = con.Department;
                          shouldUpdateEmployee = true;
                      }
                      
                      if(con.Skype__c != null && oldContact.Skype__c != con.Skype__c){ // Mustafa : Date : 3-Dec-15
                          updateEmp.Skype_ID__c = con.Skype__c;
                          shouldUpdateEmployee = true;
                      }
                      
                      if(con.Email != null && oldContact.Email != con.Email){ // Mustafa : Date : 3-Dec-15
                          updateEmp.Email_Address__c = con.Email;
                          shouldUpdateEmployee = true;
                      }
                      
                      if(con.Title != null && oldContact.Title != con.Title){ // Mustafa : Date : 3-Dec-15
                          updateEmp.Title__c = con.Title; 
                          shouldUpdateEmployee = true;
                      }
                      
                      if(con.ReportsToId != oldContact.ReportsToId) { // Mustafa : Date : 4-Dec-15
                          shouldUpdateEmployee = true;
                          if(con.ReportsToId!=null){
                              updateEmp.Direct_Manager_Lookup__c= reportTOEmpMap.get(con.ReportsToId);  
                          }
                          else{
                              updateEmp.Direct_Manager_Lookup__c=null;
                              
                          }
                      }
                          
                      if(shouldUpdateEmployee) {
                          updateEmpList.add(updateEmp);
                      }
                      
            }
            
        }
        if(updateEmpList.size()>0){
            update updateEmpList;
        }
          
        }
    }
}