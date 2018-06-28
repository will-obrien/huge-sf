public class EmployeeInsertUpdateTriggerHelper{
    
    public static void RemoveInactiveEmployeeFromEmailList(List<SFDC_Employee__c> employees,Map<id,SFDC_Employee__c> oldMap){
        List<id> contactList=new List<id>();
        for(SFDC_Employee__c emp : employees){
            SFDC_Employee__c oldEmp=oldMap.get(emp.id);
            
            if(emp.Employee_Status__c!=oldEmp.Employee_Status__c){
                if(emp.Contact__c!=null && emp.Employee_Status__c=='Terminated'){
                    contactList.add(emp.Contact__c);
                }
            }
        }
        
        System.debug('RemoveInactiveEmployeeFromEmailList: '+ contactList);
        
        List<Contract_Contact__c> contractContactList=[select id from Contract_Contact__c where Contact__c=: contactList];
        
        if(contractContactList.size()>0){
            delete contractContactList;
        }
        
    }
    
    //Function to map contact with employee
    public static void mapContactToEmployee(List<SFDC_Employee__c> employees){
        
        //Contact IDs
        Set<Id> contactIDs = new Set<Id>(); 
        Map<Id, SFDC_Employee__c> empByContactId = new Map<Id, SFDC_Employee__c>();
        for(SFDC_Employee__c emp :employees)
        {
            if(emp.Contact__c != null)
            {
                contactIDs.add(emp.Contact__c);
                empByContactId.put(emp.Contact__c, emp);
            }
        } 
         
        if(contactIDs.size() > 0)
        {
            //Get list of contacts
            Map<Id, Contact> contactsById = new Map<Id, Contact>([Select Id, Name,FirstName,LastName, AccountId, ReportsToId, Title, MobilePhone,
            Department,Country__c,ReportsTo.Name,Country__r.Name, Skype__c, 
            Email from Contact where Id in :contactIDs]);
            
            Set<Id> accountIDs = new Set<Id>();
            Set<Id> contactEmpIds=new Set<Id>();
            for(Contact con :contactsById.values()){
                accountIDs.add(con.AccountId);
                contactEmpIds.add(con.ReportsToId);
            }
            Map<Id, SFDC_Employee__c> relatedEmpList=new Map<Id, SFDC_Employee__c>();
            
            List<SFDC_Employee__c> empList=[select id,Name,Contact__C from SFDC_Employee__c where Contact__c=: contactEmpIds];
            
            for(SFDC_Employee__c emp: empList){
                if(!relatedEmpList.containsKey(emp.Contact__C)){
                    relatedEmpList.put(emp.Contact__C,emp);
                }
            }
            
            //Get list of accounts
            Map<Id, Account> accountsByID = new Map<Id, Account>([Select Id, Name from Account where Id in :accountIDs]);
                        
            for(SFDC_Employee__c emp :employees){
                
                Contact cntct = contactsById.get(emp.Contact__c);
                Account acnt = accountsByID.get(cntct.AccountId);
 
                if(acnt.Name.toLowerCase().contains('dimagi')){
                    if(emp.Name == null)
                        emp.Name = cntct.Name;

                    if(emp.Entity__c == null)
                        emp.Entity__c = acnt.Name;    

                    if(emp.Country__c == null)
                        emp.Country__c = cntct.Country__c;   

                    if(emp.Sub_Unit__c == null)
                        emp.Sub_Unit__c = cntct.Department;

                    if(emp.Skype_ID__c == null)
                        emp.Skype_ID__c = cntct.Skype__c;

                    if(emp.Email_Address__c == null)
                        emp.Email_Address__c = cntct.Email;                         

                    if(emp.Title__c == null)
                        emp.Title__c = cntct.Title;
                    
                    if(emp.Direct_Manager_Lookup__c == null && cntct.ReportsToId != null){
                        SFDC_Employee__c  relatedEmp=relatedEmpList.get(cntct.ReportsToId);
                        
                        if(relatedEmp!=null){
                            emp.Direct_Manager_Lookup__c =relatedEmp.Id;
                        }
                    }
                }
            } 
        }   
    }
    
    
    
    public static void mapContactToEmployeeAfter(List<SFDC_Employee__c> employees){
        
        //Contact IDs
        Set<Id> contactIDs = new Set<Id>();
        List<SFDC_Employee__c> empListOldData= new List<SFDC_Employee__c>();
        List<SFDC_Employee__c> empListToUpdate= new List<SFDC_Employee__c>();
        Map<Id, SFDC_Employee__c> empByContactId = new Map<Id, SFDC_Employee__c>();
        for(SFDC_Employee__c emp :employees)
        {
            if(emp.Contact__c != null)
            {
                contactIDs.add(emp.Contact__c);
                empByContactId.put(emp.Contact__c, emp);
            }
        }
        System.debug('Check contactIDs: '+contactIDs);
        for(Contact con: [SELECT Id, (SELECT Id,Contact__c FROM Employees__r) FROM Contact Where ReportsToId IN : contactIDs])
        {
            
            contactIDs.add(con.Id);
            List<SFDC_Employee__c> empListTemp = con.Employees__r;
            System.debug('Check empListTemp: '+empListTemp);
            Set<SFDC_Employee__c> empSetTemp = new Set<SFDC_Employee__c>();
            for(SFDC_Employee__c temp: empListTemp)
            {
                if(!empSetTemp.contains(temp))
                {
                    empListOldData.add(temp);
                    empSetTemp.add(temp);
                }
            }
        }
        System.debug('Check empListOldData: '+empListOldData);
        System.debug('Check contactIDs: '+contactIDs);
        if(contactIDs.size() > 0)
        {
            //Get list of contacts
            Map<Id, Contact> contactsById = new Map<Id, Contact>([Select Id, Name,FirstName,LastName, AccountId, ReportsToId, Title, MobilePhone,
            Department,Country__c,ReportsTo.Name,Country__r.Name, Skype__c, 
            Email from Contact where Id in :contactIDs]);
            
            Set<Id> accountIDs = new Set<Id>();
            Set<Id> contactEmpIds=new Set<Id>();
            for(Contact con :contactsById.values()){
                accountIDs.add(con.AccountId);
                contactEmpIds.add(con.ReportsToId);
            }
            Map<Id, SFDC_Employee__c> relatedEmpList=new Map<Id, SFDC_Employee__c>();
            
            List<SFDC_Employee__c> empList=[select id,Name,Contact__C from SFDC_Employee__c where Contact__c=: contactEmpIds];
            
            for(SFDC_Employee__c emp: empList){
                if(!relatedEmpList.containsKey(emp.Contact__C)){
                    relatedEmpList.put(emp.Contact__C,emp);
                }
            }
            
            //Get list of accounts
            Map<Id, Account> accountsByID = new Map<Id, Account>([Select Id, Name from Account where Id in :accountIDs]);
                       
            for(SFDC_Employee__c emp :empListOldData){
                
                Contact cntct = contactsById.get(emp.Contact__c);
                Account acnt = accountsByID.get(cntct.AccountId);
 
                if(acnt.Name.toLowerCase().contains('dimagi'))
                {   
                    if(cntct.ReportsToId!=null){
                        SFDC_Employee__c  relatedEmp=relatedEmpList.get(cntct.ReportsToId);
                        
                        if(relatedEmp!=null){
                            emp.Direct_Manager_Lookup__c =relatedEmp.Id;
                        }
                        else{
                            emp.Direct_Manager_Lookup__c=null;
                        }
                    }
                    else{
                        emp.Direct_Manager_Lookup__c=null;
                    }
                    empListToUpdate.add(emp);
                }
            }
            System.debug('Check empListToUpdate: '+empListToUpdate);
            if(empListToUpdate.size() > 0)
                update empListToUpdate;
        }   
    }
    
    //Function to map contact with employee
    public static void updateContact(List<SFDC_Employee__c> employees,Map<Id,SFDC_Employee__c> oldEmployees){
        if(CheckRecursive.firstRun){
            CheckRecursive.firstRun=false;
            
            Map<Id, SFDC_Employee__c> empByContactId = new Map<Id, SFDC_Employee__c>();
            Set<Id> contactIDs = new Set<Id>();
            
            set<id> employeeSet=new set<id>();          
            for(SFDC_Employee__c emp:employees){
                if(emp.Direct_Manager_Lookup__c!=null){
                    employeeSet.add(emp.Direct_Manager_Lookup__c);
                }
                if(emp.Contact__c != null)
                {
                    contactIDs.add(emp.Contact__c);
                    empByContactId.put(emp.Contact__c, emp);
                }
            }
            
            Map<id,SFDC_Employee__c> directManagerList=new Map<id,SFDC_Employee__c>([select id,Contact__C from SFDC_Employee__c where id=:employeeSet]);

            List<Contact> updateContactList=new List<Contact>();
            
             //Get list of contacts
            Map<Id, Contact> contactsById = new Map<Id, Contact>([Select Id, Name, AccountId, ReportsToId, Title, MobilePhone,
            Department,Country__c,ReportsTo.Name,Country__r.Name, Skype__c, 
            Email from Contact where Id in :contactIDs]);
            
            Set<Id> accountIDs = new Set<Id>();
            Set<Id> contactEmpIds=new Set<Id>();
            for(Contact con :contactsById.values()){
                accountIDs.add(con.AccountId);
                contactEmpIds.add(con.ReportsToId);
            }
            Map<Id, SFDC_Employee__c> relatedEmpList=new Map<Id, SFDC_Employee__c>();
            
            List<SFDC_Employee__c> empList=[select id,Name,Contact__C from SFDC_Employee__c where Contact__c=: contactEmpIds];
            
            for(SFDC_Employee__c emp: empList){
                if(!relatedEmpList.containsKey(emp.Contact__C)){
                    relatedEmpList.put(emp.Contact__C,emp);
                }
            }
            
            //Get list of accounts
            Map<Id, Account> accountsByID = new Map<Id, Account>([Select Id, Name from Account where Id in :accountIDs]);
            
            
            
            for(SFDC_Employee__c emp : employees){
                if(emp.Contact__C!=null){
                    //Mustafa: Employee will always be considered master. And whenever there is a change, we will update contact record.
                    //if(oldEmployees.get(emp.id).Contact__c==emp.Contact__c){
                        SFDC_Employee__c oldEmp = oldEmployees.get(emp.Id);

                        Contact con=new Contact();
                        con.id=emp.Contact__C;
                        Boolean updateContact = false;
                        Boolean newContact = (emp.Contact__c != oldEmp.Contact__c);

                        if(emp.Name != oldEmp.Name || newContact) {
                            List<string> nameList=emp.Name.split(' ');
                            
                            if(nameList.size()>=2){
                                con.FirstName=nameList[0] != Null ? nameList[0] : '';
                                con.LastName=nameList[1] != Null ? nameList[1] : '';
                            }
                            else if(nameList.size()==1){
                                con.FirstName= '';
                                con.LastName=nameList[0] != Null ? nameList[0] : '';
                            }
                            updateContact = true;
                        }
                        
                        if(emp.Sub_Unit__c != oldEmp.Sub_Unit__c || newContact) {
                            con.Department=emp.Sub_Unit__c;
                            updateContact = true;
                        }

                        if(emp.Skype_ID__c != oldEmp.Skype_ID__c || newContact) {
                            con.Skype__c=emp.Skype_ID__c;
                            updateContact = true;
                        }

                        if(emp.Email_Address__c != oldEmp.Email_Address__c || newContact) {
                            con.Email=emp.Email_Address__c;
                            updateContact = true;
                        }

                        if(emp.Title__c != oldEmp.Title__c || newContact) {
                            con.Title=emp.Title__c;
                            updateContact = true;  
                        }

                        if(emp.Country__c != oldEmp.Country__c || newContact) {
                            con.Country__c=emp.Country__c;
                            updateContact = true;
                        }
                        
                        
                        if(emp.Direct_Manager_Lookup__c != oldEmp.Direct_Manager_Lookup__c || newContact) {
                            SFDC_Employee__c empDirectManager=directManagerList.get(emp.Direct_Manager_Lookup__c);
                            if(empDirectManager != null) {
                                con.ReportsToId=empDirectManager.Contact__C;
                            }
                            else{
                                 con.ReportsToId=null;
                            }
                            updateContact = true;
                        }

                        if(updateContact == true) {
                            updateContactList.add(con);
                        }  
                    //}
                    //Mustafa: according to new discussion with Lucina, employee will always be the master. 
                    //Hence, commenting out functionality to update employee record from contact when employee
                    //is associated with another contact.
                    /*
                    else{
                        //Update Employee object we Contact is changed.
                        
                        Contact cntct = contactsById.get(emp.Contact__c);
                        Account acnt = accountsByID.get(cntct.AccountId);
             
                        if(acnt.Name.toLowerCase().contains('dimagi')){

                            emp.Name = cntct.Name;
                            emp.Entity__c = acnt.Name;    
                            emp.Country__c = cntct.Country__c;   
                            emp.Sub_Unit__c = cntct.Department;
                            emp.Skype_ID__c = cntct.Skype__c;
                            emp.Email_Address__c = cntct.Email;                         
                            emp.Title__c = cntct.Title;
                            
                            if(cntct.ReportsToId!=null){
                                SFDC_Employee__c  relatedEmp=relatedEmpList.get(cntct.ReportsToId);
                                
                                if(relatedEmp!=null){
                                    emp.Direct_Manager_Lookup__c =relatedEmp.Id;
                                }
                                else{
                                    emp.Direct_Manager_Lookup__c=null;
                                }
                            }
                            else{
                                emp.Direct_Manager_Lookup__c=null;
                            }
                        }
                    }*/
                }
            }
            
            if(updateContactList.size()>0){
                upsert updateContactList;
            }
        }
    }
}