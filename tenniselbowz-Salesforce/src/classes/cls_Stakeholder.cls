public class cls_Stakeholder {

        public String selected_role;//{get;set;}
        private Map<String, Schema.sObjectField> fields_map{get;set;}
        public List<stakeholder_wrapper> wr_stakeholder{get;set;}
        public String current_project{get;set;}
        public static integer indexRow =0;
        public Integer delIndex;
        public List<stakeholder_wrapper> del_wr_stake; 
        public Integer iterator;
        public boolean flag{get;set;}
        public Project__c p;
        public void setselected_role(string s)    {
        
        selected_role=s;
        
        }
        
        public String getselected_role(){   
        
        
        
        return selected_role;
        
        }
    
        public void setdelIndex(integer i){
        
        delIndex=i;
        } 
        
        public integer getdelIndex(){
        
        return delIndex;
        
        }
        //***************** Constructor **************************************
        
        public cls_Stakeholder(ApexPages.StandardController controller) {
        
      
       iterator=0; 
       flag=false;
        current_project= controller.getId();
        system.debug('Apex: Project Id : ' + current_project);
        //System.currentPageReference().getParameters().get('id');
   
        p=[Select id , Name,Account__c, Account__r.Name from Project__c where Id =:current_project];



    }
    
    public List<stakeholder_wrapper> getstakeholder_Records(){
       
        wr_stakeholder=new List<stakeholder_wrapper>();
        
        
        
        List<Stakeholder__c> s=[select Id , name ,Project__c,Contact__c, 
        Stakeholder_Role__c,Opportunity__c 
        from Stakeholder__c where Project__c =:current_project];// where Project__c='a0XQ0000000ywtrMAA'];//:current_project];
        
        
        system.debug('Apex :SIZE' + s.size());
        if(s!= null){
        if(s.size() > 0){
        
            for(Stakeholder__c sk :s){
            
            wr_stakeholder.add(new stakeholder_wrapper(sk));
            
            }
             wr_stakeholder.add(new stakeholder_wrapper(new Stakeholder__c()));
        }
        else{
        
       
            wr_stakeholder.add(new stakeholder_wrapper(new Stakeholder__c()));
        } 
        
        
        
        
        }
        
        
        
        if(flag==true){
        
        system.debug('Apex:' + wr_stakeholder.size());
//wr_stakeholder.add(new stakeholder_wrapper(new Stakeholder__c()));
        
        }
        
        for(integer i=0;i<iterator;i++){
       
         wr_stakeholder.add(new stakeholder_wrapper(new Stakeholder__c()));
       
       }
        return wr_stakeholder;
        
    }
    
    
    
    public PageReference Save(){
     
     iterator=0;
     List<Stakeholder__c> upsertlist=new List<Stakeholder__c>();
     
     system.debug('Apex: Save() method ' +  wr_stakeholder.size());
     try{
     p=[Select id , Name,Account__r.Name from Project__c where Id =:current_project];
     
     for(stakeholder_wrapper w:wr_stakeholder){
        Stakeholder__c s;
        String role;
        
        role=w.SelectedRole;
        
        if(w.stakeholder.id == null){
        
         s=new Stakeholder__c();
         s.Project__c=current_project;
        // s.Opportunity__c='006Q00000064CWE';
         s.Contact__c=w.stakeholder.Contact__c;
         
             if(role.contains('Select Role')){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Role is Required'));
             
             }
             else{
                 system.debug('Apex :SelectedRole ' +w.SelectedRole);
                 s.Stakeholder_Role__c=w.SelectedRole;
             
             }
         
         upsertlist.add(s);
         }
         else{
         
         
         
         
          s=w.stakeholder;
          s.Contact__c=w.stakeholder.Contact__c;
         // s.Opportunity__c='006Q00000064CWE';
          s.Project__c=current_project;
          
            if(w.SelectedRole =='--- Select Role ---'){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Role is Required'));
             }
             else{
                 system.debug('Apex :SelectedRole ' +w.SelectedRole);
                 s.Stakeholder_Role__c=w.SelectedRole;
             
             }
         
          upsertlist.add(s);
         }
         
         
     
     
     
     }
     
     
     if(upsertlist.size() >0){
       try{
       upsert upsertlist;
       }
       catch(Exception e){
       
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getmessage()));
       }
     
     }
    }
    catch(Exception ex){
    
    ApexPages.addMessages(ex);
    
    
    
    }
   return null;
    
    }  
    
    
    
    public void addRow(){
    
    flag=true;
    iterator=iterator+1;
   // wr_stakeholder.add(new stakeholder_wrapper(new Stakeholder__c()));
    
    
    }
    
  public PageReference navigatetoContact(){
 
   //con4_lkid ,   retURL=%2Fa0XQ0000000ywtr
   //pagereference pg=new PageReference('/003/e?retURL=%2Fa0X%2Fo');
   //pagereference pg=new PageReference('/003/e?con4=' + p.Account__r.Name + '&retURL=%2F' + current_project+'/e');
   //%2Fa0X%2Fo
   //retURL=%2F003%2Fo
   pagereference pg=new PageReference('/003/e?con4='+p.Account__r.Name);
   pg.setredirect(true);
   return pg;
    
    }
   
  public pageReference DeleteRow(){
    
    system.debug('Del Index' + delIndex);
    
  
    system.debug('Del size' + wr_stakeholder.size());
    
    stakeholder_wrapper delRec=wr_stakeholder.get(delIndex-1);
    system.debug('Index at which delete is called' + delRec);
    Stakeholder__c  stakeholder_Del;
    stakeholder_Del=wr_stakeholder.get(delIndex-1).stakeholder;
    
    stakeholder_wrapper recordsToDel;
    
  
    system.debug('Index at which delete is called' + stakeholder_Del);
             
         if(wr_stakeholder.get(delIndex-1).stakeholder.Id ==null && delIndex <> null){
         
             wr_stakeholder.remove(delIndex-1);
             return null;
         
         }
         else if(wr_stakeholder.get(delIndex-1).stakeholder.Id <> null){
             
             recordsToDel=wr_stakeholder.get(delIndex-1);
             stakeholder_Del=recordsToDel.stakeholder;
             delete stakeholder_Del;
         } 
  
        
    return null;
    
    //return pg;
    }
    
    class stakeholder_wrapper{
        
        public Stakeholder__c stakeholder{get;set;}
        public List<Stakeholder__c> list_stakeholder{get;set;}
        public String SelectedRole{get;set;}
        public List<SelectOption> Role_list; 
        private Map<String, Schema.sObjectField> fields_map{get;set;}
        public Integer LineNo;
        
        
        public List<SelectOption> getRole_list(){
        
        fields_map = Schema.SObjectType.Stakeholder__c.fields.getMap();        
        Role_list = new List<SelectOption>();
        Role_list.add(new SelectOption('--- Select Role ---', '--- Select Role ---'));            
           
            for (Schema.PicklistEntry p : fields_map.get('Stakeholder_Role__c').getDescribe().getPicklistValues()) {
    
                Role_list.add(new SelectOption(p.getValue(), p.getLabel()));
    
            }        
          
            
            system.debug('Apex: getRole_list() method ,'+ Role_List.size());
            
            
        return Role_list;
        }
    
        public integer getIndexRow(){
        
        indexRow=indexRow+1;
        return indexRow;
        
        }
        
        public void setIndexRow(integer s){
        indexRow=s;
        
    }
    
        
        public stakeholder_wrapper(Stakeholder__c s){
            
            stakeholder=s;
            
            list_stakeholder = new List<Stakeholder__c>();
            
         /*    if(Role_list!=null){
                for(SelectOption o:Role_list){
            
                 system.debug('Apex - Role List' + Role_list.size());
                 if(stakeholder.Stakeholder_Role__c==string.valueof(o)){
                    SelectedRole=string.valueof(o);
                    system.debug('SelectedRole :' + SelectedRole);
                 }
            
            }
           } // end of (Role_list != null) condition
            
        */    
        
         SelectedRole=stakeholder.Stakeholder_Role__c;
          
        }
    }

}